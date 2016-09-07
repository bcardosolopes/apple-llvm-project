//===-- CUDASaxpy.cpp - Example of CUDA saxpy with StreamExecutor API -----===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This file contains example code demonstrating the usage of the
/// StreamExecutor API. Snippets of this file will be included as code examples
/// in documentation. Taking these examples from a real source file guarantees
/// that the examples will always compile.
///
//===----------------------------------------------------------------------===//

#include <algorithm>
#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <vector>

#include "streamexecutor/StreamExecutor.h"

/// [Example saxpy compiler-generated]
// Code in this namespace is generated by the compiler (e.g. clang).
//
// The name of this namespace may depend on the compiler that generated it, so
// this is just an example name.
namespace __compilergen {

// Specialization of the streamexecutor::Kernel template class for the parameter
// types of the saxpy(float A, float *X, float *Y) kernel.
using SaxpyKernel =
    streamexecutor::Kernel<float, streamexecutor::GlobalDeviceMemory<float>,
                           streamexecutor::GlobalDeviceMemory<float>>;

// A string containing the PTX code generated by the device compiler for the
// saxpy kernel. String contents not shown here.
extern const char *SaxpyPTX;

// A global instance of a loader spec that knows how to load the code in the
// SaxpyPTX string.
static streamexecutor::MultiKernelLoaderSpec SaxpyLoaderSpec = []() {
  streamexecutor::MultiKernelLoaderSpec Spec;
  Spec.addCUDAPTXInMemory("saxpy", {{{2, 0}, SaxpyPTX}});
  return Spec;
}();

} // namespace __compilergen
/// [Example saxpy compiler-generated]

/// [Example saxpy host PTX]
// The PTX text for a saxpy kernel.
const char *__compilergen::SaxpyPTX = R"(
  .version 4.3
  .target sm_20
  .address_size 64

  .visible .entry saxpy(.param .f32 A, .param .u64 X, .param .u64 Y) {
    .reg .f32 %AValue;
    .reg .f32 %XValue;
    .reg .f32 %YValue;
    .reg .f32 %Result;

    .reg .b64 %XBaseAddrGeneric;
    .reg .b64 %YBaseAddrGeneric;
    .reg .b64 %XBaseAddrGlobal;
    .reg .b64 %YBaseAddrGlobal;
    .reg .b64 %XAddr;
    .reg .b64 %YAddr;
    .reg .b64 %ThreadByteOffset;

    .reg .b32 %TID;

    ld.param.f32 %AValue, [A];
    ld.param.u64 %XBaseAddrGeneric, [X];
    ld.param.u64 %YBaseAddrGeneric, [Y];
    cvta.to.global.u64 %XBaseAddrGlobal, %XBaseAddrGeneric;
    cvta.to.global.u64 %YBaseAddrGlobal, %YBaseAddrGeneric;
    mov.u32 %TID, %tid.x;
    mul.wide.u32 %ThreadByteOffset, %TID, 4;
    add.s64 %XAddr, %ThreadByteOffset, %XBaseAddrGlobal;
    add.s64 %YAddr, %ThreadByteOffset, %YBaseAddrGlobal;
    ld.global.f32 %XValue, [%XAddr];
    ld.global.f32 %YValue, [%YAddr];
    fma.rn.f32 %Result, %AValue, %XValue, %YValue;
    st.global.f32 [%XAddr], %Result;
    ret;
  }
)";
/// [Example saxpy host PTX]

int main() {
  /// [Example saxpy host main]
  namespace se = ::streamexecutor;
  namespace cg = ::__compilergen;

  // Create some host data.
  float A = 42.0f;
  std::vector<float> HostX = {0, 1, 2, 3};
  std::vector<float> HostY = {4, 5, 6, 7};
  size_t ArraySize = HostX.size();

  // Get a device object.
  se::Platform *Platform =
      getOrDie(se::PlatformManager::getPlatformByName("CUDA"));
  if (Platform->getDeviceCount() == 0) {
    return EXIT_FAILURE;
  }
  se::Device *Device = getOrDie(Platform->getDevice(0));

  // Load the kernel onto the device.
  cg::SaxpyKernel Kernel =
      getOrDie(Device->createKernel<cg::SaxpyKernel>(cg::SaxpyLoaderSpec));

  // Allocate memory on the device.
  se::GlobalDeviceMemory<float> X =
      getOrDie(Device->allocateDeviceMemory<float>(ArraySize));
  se::GlobalDeviceMemory<float> Y =
      getOrDie(Device->allocateDeviceMemory<float>(ArraySize));

  // Run operations on a stream.
  se::Stream Stream = getOrDie(Device->createStream());
  Stream.thenCopyH2D<float>(HostX, X)
      .thenCopyH2D<float>(HostY, Y)
      .thenLaunch(ArraySize, 1, Kernel, A, X, Y)
      .thenCopyD2H<float>(X, HostX);
  // Wait for the stream to complete.
  se::dieIfError(Stream.blockHostUntilDone());

  // Process output data in HostX.
  std::vector<float> ExpectedX = {4, 47, 90, 133};
  assert(std::equal(ExpectedX.begin(), ExpectedX.end(), HostX.begin()));
  /// [Example saxpy host main]
}
