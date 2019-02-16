; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -bdce -S < %s | FileCheck %s

; Funnel shift based rotate test cases from PR39771

declare i32 @llvm.fshr.i32(i32, i32, i32)
declare <2 x i32> @llvm.fshr.v2i32(<2 x i32>, <2 x i32>, <2 x i32>)

; First fshr operand is dead.
define i32 @pr39771_fshr_multi_use_instr(i32 %a) {
; CHECK-LABEL: @pr39771_fshr_multi_use_instr(
; CHECK-NEXT:    [[X:%.*]] = or i32 [[A:%.*]], 0
; CHECK-NEXT:    [[B:%.*]] = tail call i32 @llvm.fshr.i32(i32 0, i32 [[X]], i32 1)
; CHECK-NEXT:    [[C:%.*]] = lshr i32 [[B]], 23
; CHECK-NEXT:    [[D:%.*]] = xor i32 [[C]], [[B]]
; CHECK-NEXT:    [[E:%.*]] = and i32 [[D]], 31
; CHECK-NEXT:    ret i32 [[E]]
;
  %x = or i32 %a, 0
  %b = tail call i32 @llvm.fshr.i32(i32 %x, i32 %x, i32 1)
  %c = lshr i32 %b, 23
  %d = xor i32 %c, %b
  %e = and i32 %d, 31
  ret i32 %e
}

; First fshr operand is dead (vector variant).
define <2 x i32> @pr39771_fshr_multi_use_instr_vec(<2 x i32> %a) {
; CHECK-LABEL: @pr39771_fshr_multi_use_instr_vec(
; CHECK-NEXT:    [[X:%.*]] = or <2 x i32> [[A:%.*]], zeroinitializer
; CHECK-NEXT:    [[B:%.*]] = tail call <2 x i32> @llvm.fshr.v2i32(<2 x i32> zeroinitializer, <2 x i32> [[X]], <2 x i32> <i32 1, i32 1>)
; CHECK-NEXT:    [[C:%.*]] = lshr <2 x i32> [[B]], <i32 23, i32 23>
; CHECK-NEXT:    [[D:%.*]] = xor <2 x i32> [[C]], [[B]]
; CHECK-NEXT:    [[E:%.*]] = and <2 x i32> [[D]], <i32 31, i32 31>
; CHECK-NEXT:    ret <2 x i32> [[E]]
;
  %x = or <2 x i32> %a, zeroinitializer
  %b = tail call <2 x i32> @llvm.fshr.v2i32(<2 x i32> %x, <2 x i32> %x, <2 x i32> <i32 1, i32 1>)
  %c = lshr <2 x i32> %b, <i32 23, i32 23>
  %d = xor <2 x i32> %c, %b
  %e = and <2 x i32> %d, <i32 31, i32 31>
  ret <2 x i32> %e
}

; First fshr operand is dead, but it comes from an argument, not instruction.
define i32 @pr39771_fshr_multi_use_arg(i32 %a) {
; CHECK-LABEL: @pr39771_fshr_multi_use_arg(
; CHECK-NEXT:    [[B:%.*]] = tail call i32 @llvm.fshr.i32(i32 [[A:%.*]], i32 [[A]], i32 1)
; CHECK-NEXT:    [[C:%.*]] = lshr i32 [[B]], 23
; CHECK-NEXT:    [[D:%.*]] = xor i32 [[C]], [[B]]
; CHECK-NEXT:    [[E:%.*]] = and i32 [[D]], 31
; CHECK-NEXT:    ret i32 [[E]]
;
  %b = tail call i32 @llvm.fshr.i32(i32 %a, i32 %a, i32 1)
  %c = lshr i32 %b, 23
  %d = xor i32 %c, %b
  %e = and i32 %d, 31
  ret i32 %e
}

; Second or operand is dead, but BDCE does not realize this.
define i32 @pr39771_expanded_fshr_multi_use(i32 %a) {
; CHECK-LABEL: @pr39771_expanded_fshr_multi_use(
; CHECK-NEXT:    [[TMP:%.*]] = lshr i32 [[A:%.*]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = shl i32 [[A]], 31
; CHECK-NEXT:    [[B:%.*]] = or i32 [[TMP]], [[TMP2]]
; CHECK-NEXT:    [[C:%.*]] = lshr i32 [[B]], 23
; CHECK-NEXT:    [[D:%.*]] = xor i32 [[C]], [[B]]
; CHECK-NEXT:    [[E:%.*]] = and i32 [[D]], 31
; CHECK-NEXT:    ret i32 [[E]]
;
  %tmp = lshr i32 %a, 1
  %tmp2 = shl i32 %a, 31
  %b = or i32 %tmp, %tmp2
  %c = lshr i32 %b, 23
  %d = xor i32 %c, %b
  %e = and i32 %d, 31
  ret i32 %e
}

; %b operand of %c will be dead initially, but later found live.
define void @dead_use_invalidation(i32 %a) {
; CHECK-LABEL: @dead_use_invalidation(
; CHECK-NEXT:    [[B:%.*]] = or i32 [[A:%.*]], 0
; CHECK-NEXT:    [[C:%.*]] = shl i32 [[B]], 31
; CHECK-NEXT:    [[D:%.*]] = and i32 [[C]], 1
; CHECK-NEXT:    [[E:%.*]] = or i32 [[C]], 0
; CHECK-NEXT:    [[F:%.*]] = or i32 [[D]], 0
; CHECK-NEXT:    call void @dummy(i32 [[E]])
; CHECK-NEXT:    call void @dummy(i32 [[F]])
; CHECK-NEXT:    call void @dummy(i32 [[B]])
; CHECK-NEXT:    ret void
;
  %b = or i32 %a, 0
  %c = shl i32 %b, 31
  %d = and i32 %c, 1
  %e = or i32 %c, 0
  %f = or i32 %d, 0
  call void @dummy(i32 %e)
  call void @dummy(i32 %f)
  call void @dummy(i32 %b)
  ret void
}
declare void @dummy(i32)
