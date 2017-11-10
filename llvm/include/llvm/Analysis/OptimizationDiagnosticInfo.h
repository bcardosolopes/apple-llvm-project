//===- OptimizationDiagnosticInfo.h - Optimization Diagnostic ---*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Optimization diagnostic interfaces.  It's packaged as an analysis pass so
// that by using this service passes become dependent on BFI as well.  BFI is
// used to compute the "hotness" of the diagnostic message.
//===----------------------------------------------------------------------===//

#ifndef LLVM_IR_OPTIMIZATIONDIAGNOSTICINFO_H
#define LLVM_IR_OPTIMIZATIONDIAGNOSTICINFO_H

#include "llvm/ADT/Optional.h"
#include "llvm/Analysis/BlockFrequencyInfo.h"
#include "llvm/IR/DiagnosticInfo.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Pass.h"

namespace llvm {
class DebugLoc;
class LLVMContext;
class Loop;
class Pass;
class Twine;
class Value;

/// The optimization diagnostic interface.
///
/// It allows reporting when optimizations are performed and when they are not
/// along with the reasons for it.  Hotness information of the corresponding
/// code region can be included in the remark if DiagnosticsHotnessRequested is
/// enabled in the LLVM context.
class OptimizationRemarkEmitter {
public:
  OptimizationRemarkEmitter(const Function *F, BlockFrequencyInfo *BFI)
      : F(F), BFI(BFI) {}

  /// \brief This variant can be used to generate ORE on demand (without the
  /// analysis pass).
  ///
  /// Note that this ctor has a very different cost depending on whether
  /// F->getContext().getDiagnosticsHotnessRequested() is on or not.  If it's off
  /// the operation is free.
  ///
  /// Whereas if DiagnosticsHotnessRequested is on, it is fairly expensive
  /// operation since BFI and all its required analyses are computed.  This is
  /// for example useful for CGSCC passes that can't use function analyses
  /// passes in the old PM.
  OptimizationRemarkEmitter(const Function *F);

  OptimizationRemarkEmitter(OptimizationRemarkEmitter &&Arg)
      : F(Arg.F), BFI(Arg.BFI) {}

  OptimizationRemarkEmitter &operator=(OptimizationRemarkEmitter &&RHS) {
    F = RHS.F;
    BFI = RHS.BFI;
    return *this;
  }

  /// Handle invalidation events in the new pass manager.
  bool invalidate(Function &F, const PreservedAnalyses &PA,
                  FunctionAnalysisManager::Invalidator &Inv);

  /// \brief Output the remark to the optimization record file.  Also send it to
  /// the diagnostic handler if remarks are requested for the pass.
  ///
  /// This is the new interface that should be now used rather than the legacy
  /// emit* APIs.
  void emit(DiagnosticInfoOptimizationBase &OptDiag);

  /// \brief Whether we allow for extra compile-time budget to perform more
  /// analysis to produce fewer false positives.
  ///
  /// This is useful when reporting missed optimizations.  In this case we can
  /// use the extra analysis (1) to filter trivial false positives or (2) to
  /// provide more context so that non-trivial false positives can be quickly
  /// detected by the user.
  bool allowExtraAnalysis() const {
    // For now, only allow this with -fsave-optimization-record since the -Rpass
    // options are handled in the front-end.
    return F->getContext().getDiagnosticsOutputFile();
  }

private:
  const Function *F;

  BlockFrequencyInfo *BFI;

  /// If we generate BFI on demand, we need to free it when ORE is freed.
  std::unique_ptr<BlockFrequencyInfo> OwnedBFI;

  /// Compute hotness from IR value (currently assumed to be a block) if PGO is
  /// available.
  Optional<uint64_t> computeHotness(const Value *V);

  /// Similar but use value from \p OptDiag and update hotness there.
  void computeHotness(DiagnosticInfoIROptimization &OptDiag);

  /// \brief Only allow verbose messages if we know we're filtering by hotness
  /// (BFI is only set in this case).
  bool shouldEmitVerbose() { return BFI != nullptr; }

  OptimizationRemarkEmitter(const OptimizationRemarkEmitter &) = delete;
  void operator=(const OptimizationRemarkEmitter &) = delete;
};

/// \brief Add a small namespace to avoid name clashes with the classes used in
/// the streaming interface.  We want these to be short for better
/// write/readability.
namespace ore {
using NV = DiagnosticInfoOptimizationBase::Argument;
using setIsVerbose = DiagnosticInfoOptimizationBase::setIsVerbose;
using setExtraArgs = DiagnosticInfoOptimizationBase::setExtraArgs;
}

/// OptimizationRemarkEmitter legacy analysis pass
///
/// Note that this pass shouldn't generally be marked as preserved by other
/// passes.  It's holding onto BFI, so if the pass does not preserve BFI, BFI
/// could be freed.
class OptimizationRemarkEmitterWrapperPass : public FunctionPass {
  std::unique_ptr<OptimizationRemarkEmitter> ORE;

public:
  OptimizationRemarkEmitterWrapperPass();

  bool runOnFunction(Function &F) override;

  void getAnalysisUsage(AnalysisUsage &AU) const override;

  OptimizationRemarkEmitter &getORE() {
    assert(ORE && "pass not run yet");
    return *ORE;
  }

  static char ID;
};

class OptimizationRemarkEmitterAnalysis
    : public AnalysisInfoMixin<OptimizationRemarkEmitterAnalysis> {
  friend AnalysisInfoMixin<OptimizationRemarkEmitterAnalysis>;
  static AnalysisKey Key;

public:
  /// \brief Provide the result typedef for this analysis pass.
  typedef OptimizationRemarkEmitter Result;

  /// \brief Run the analysis pass over a function and produce BFI.
  Result run(Function &F, FunctionAnalysisManager &AM);
};

namespace yaml {
template <> struct MappingTraits<DiagnosticInfoOptimizationBase *> {
  static void mapping(IO &io, DiagnosticInfoOptimizationBase *&OptDiag);
};
}
}
#endif // LLVM_IR_OPTIMIZATIONDIAGNOSTICINFO_H
