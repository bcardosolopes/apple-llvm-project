; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=X64

define void @knownbits_zext_in_reg(i8*) nounwind {
; X32-LABEL: knownbits_zext_in_reg:
; X32:       # %bb.0: # %BB
; X32-NEXT:    pushl %ebp
; X32-NEXT:    pushl %ebx
; X32-NEXT:    pushl %edi
; X32-NEXT:    pushl %esi
; X32-NEXT:    subl $16, %esp
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movzbl (%eax), %ecx
; X32-NEXT:    imull $101, %ecx, %eax
; X32-NEXT:    shrl $14, %eax
; X32-NEXT:    imull $177, %ecx, %ecx
; X32-NEXT:    shrl $14, %ecx
; X32-NEXT:    movzbl %al, %eax
; X32-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; X32-NEXT:    vpinsrd $1, %eax, %xmm0, %xmm1
; X32-NEXT:    vbroadcastss {{.*#+}} xmm2 = [3.57331108E-43,3.57331108E-43,3.57331108E-43,3.57331108E-43]
; X32-NEXT:    vpand %xmm2, %xmm1, %xmm1
; X32-NEXT:    movzbl %cl, %eax
; X32-NEXT:    vpinsrd $1, %eax, %xmm0, %xmm0
; X32-NEXT:    vpand %xmm2, %xmm0, %xmm0
; X32-NEXT:    vpextrd $1, %xmm1, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Folded Spill
; X32-NEXT:    vpextrd $1, %xmm0, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Folded Spill
; X32-NEXT:    xorl %ecx, %ecx
; X32-NEXT:    vmovd %xmm1, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Folded Spill
; X32-NEXT:    vmovd %xmm0, (%esp) # 4-byte Folded Spill
; X32-NEXT:    vpextrd $2, %xmm1, %edi
; X32-NEXT:    vpextrd $2, %xmm0, %esi
; X32-NEXT:    vpextrd $3, %xmm1, %ebx
; X32-NEXT:    vpextrd $3, %xmm0, %ebp
; X32-NEXT:    .p2align 4, 0x90
; X32-NEXT:  .LBB0_1: # %CF
; X32-NEXT:    # =>This Loop Header: Depth=1
; X32-NEXT:    # Child Loop BB0_2 Depth 2
; X32-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X32-NEXT:    xorl %edx, %edx
; X32-NEXT:    divl {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Folded Reload
; X32-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X32-NEXT:    xorl %edx, %edx
; X32-NEXT:    divl (%esp) # 4-byte Folded Reload
; X32-NEXT:    movl %edi, %eax
; X32-NEXT:    xorl %edx, %edx
; X32-NEXT:    divl %esi
; X32-NEXT:    movl %ebx, %eax
; X32-NEXT:    xorl %edx, %edx
; X32-NEXT:    divl %ebp
; X32-NEXT:    .p2align 4, 0x90
; X32-NEXT:  .LBB0_2: # %CF237
; X32-NEXT:    # Parent Loop BB0_1 Depth=1
; X32-NEXT:    # => This Inner Loop Header: Depth=2
; X32-NEXT:    testb %cl, %cl
; X32-NEXT:    jne .LBB0_2
; X32-NEXT:    jmp .LBB0_1
;
; X64-LABEL: knownbits_zext_in_reg:
; X64:       # %bb.0: # %BB
; X64-NEXT:    pushq %rbp
; X64-NEXT:    pushq %rbx
; X64-NEXT:    movzbl (%rdi), %eax
; X64-NEXT:    imull $101, %eax, %ecx
; X64-NEXT:    shrl $14, %ecx
; X64-NEXT:    imull $177, %eax, %eax
; X64-NEXT:    shrl $14, %eax
; X64-NEXT:    movzbl %cl, %ecx
; X64-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; X64-NEXT:    vpinsrd $1, %ecx, %xmm0, %xmm1
; X64-NEXT:    vbroadcastss {{.*#+}} xmm2 = [3.57331108E-43,3.57331108E-43,3.57331108E-43,3.57331108E-43]
; X64-NEXT:    vpand %xmm2, %xmm1, %xmm1
; X64-NEXT:    movzbl %al, %eax
; X64-NEXT:    vpinsrd $1, %eax, %xmm0, %xmm0
; X64-NEXT:    vpand %xmm2, %xmm0, %xmm0
; X64-NEXT:    vpextrd $1, %xmm1, %r8d
; X64-NEXT:    vpextrd $1, %xmm0, %r9d
; X64-NEXT:    xorl %esi, %esi
; X64-NEXT:    vmovd %xmm1, %r10d
; X64-NEXT:    vmovd %xmm0, %r11d
; X64-NEXT:    vpextrd $2, %xmm1, %edi
; X64-NEXT:    vpextrd $2, %xmm0, %ebx
; X64-NEXT:    vpextrd $3, %xmm1, %ecx
; X64-NEXT:    vpextrd $3, %xmm0, %ebp
; X64-NEXT:    .p2align 4, 0x90
; X64-NEXT:  .LBB0_1: # %CF
; X64-NEXT:    # =>This Loop Header: Depth=1
; X64-NEXT:    # Child Loop BB0_2 Depth 2
; X64-NEXT:    movl %r8d, %eax
; X64-NEXT:    xorl %edx, %edx
; X64-NEXT:    divl %r9d
; X64-NEXT:    movl %r10d, %eax
; X64-NEXT:    xorl %edx, %edx
; X64-NEXT:    divl %r11d
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    xorl %edx, %edx
; X64-NEXT:    divl %ebx
; X64-NEXT:    movl %ecx, %eax
; X64-NEXT:    xorl %edx, %edx
; X64-NEXT:    divl %ebp
; X64-NEXT:    .p2align 4, 0x90
; X64-NEXT:  .LBB0_2: # %CF237
; X64-NEXT:    # Parent Loop BB0_1 Depth=1
; X64-NEXT:    # => This Inner Loop Header: Depth=2
; X64-NEXT:    testb %sil, %sil
; X64-NEXT:    jne .LBB0_2
; X64-NEXT:    jmp .LBB0_1
BB:
  %L5 = load i8, i8* %0
  %Sl9 = select i1 true, i8 %L5, i8 undef
  %B21 = udiv i8 %Sl9, -93
  %B22 = udiv i8 %Sl9,  93
  br label %CF

CF:                                               ; preds = %CF246, %BB
  %I40 = insertelement <4 x i8> zeroinitializer, i8 %B21, i32 1
  %I41 = insertelement <4 x i8> zeroinitializer, i8 %B22, i32 1
  %B41 = srem <4 x i8> %I40, %I41
  br label %CF237

CF237:                                            ; preds = %CF237, %CF
  %Cmp73 = icmp ne i1 undef, undef
  br i1 %Cmp73, label %CF237, label %CF246

CF246:                                            ; preds = %CF237
  %Cmp117 = icmp ult <4 x i8> %B41, undef
  %E156 = extractelement <4 x i1> %Cmp117, i32 2
  br label %CF
}

define i32 @knownbits_mask_add_lshr(i32 %a0, i32 %a1) nounwind {
; X32-LABEL: knownbits_mask_add_lshr:
; X32:       # %bb.0:
; X32-NEXT:    xorl %eax, %eax
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_mask_add_lshr:
; X64:       # %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    retq
  %1 = and i32 %a0, 32767
  %2 = and i32 %a1, 32766
  %3 = add i32 %1, %2
  %4 = lshr i32 %3, 17
  ret i32 %4
}

define i128 @knownbits_mask_addc_shl(i64 %a0, i64 %a1, i64 %a2) nounwind {
; X32-LABEL: knownbits_mask_addc_shl:
; X32:       # %bb.0:
; X32-NEXT:    pushl %edi
; X32-NEXT:    pushl %esi
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X32-NEXT:    movl $-1024, %esi # imm = 0xFC00
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X32-NEXT:    andl %esi, %edi
; X32-NEXT:    andl {{[0-9]+}}(%esp), %esi
; X32-NEXT:    addl %edi, %esi
; X32-NEXT:    adcl {{[0-9]+}}(%esp), %edx
; X32-NEXT:    adcl $0, %ecx
; X32-NEXT:    shldl $22, %edx, %ecx
; X32-NEXT:    shldl $22, %esi, %edx
; X32-NEXT:    movl %edx, 8(%eax)
; X32-NEXT:    movl %ecx, 12(%eax)
; X32-NEXT:    movl $0, 4(%eax)
; X32-NEXT:    movl $0, (%eax)
; X32-NEXT:    popl %esi
; X32-NEXT:    popl %edi
; X32-NEXT:    retl $4
;
; X64-LABEL: knownbits_mask_addc_shl:
; X64:       # %bb.0:
; X64-NEXT:    andq $-1024, %rdi # imm = 0xFC00
; X64-NEXT:    andq $-1024, %rsi # imm = 0xFC00
; X64-NEXT:    addq %rdi, %rsi
; X64-NEXT:    adcl $0, %edx
; X64-NEXT:    shldq $54, %rsi, %rdx
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    retq
  %1 = and i64 %a0, -1024
  %2 = zext i64 %1 to i128
  %3 = and i64 %a1, -1024
  %4 = zext i64 %3 to i128
  %5 = add i128 %2, %4
  %6 = zext i64 %a2 to i128
  %7 = shl i128 %6, 64
  %8 = add i128 %5, %7
  %9 = shl i128 %8, 54
  ret i128 %9
}

define {i32, i1} @knownbits_uaddo_saddo(i64 %a0, i64 %a1) nounwind {
; X32-LABEL: knownbits_uaddo_saddo:
; X32:       # %bb.0:
; X32-NEXT:    pushl %ebx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl %ecx, %edx
; X32-NEXT:    addl %eax, %edx
; X32-NEXT:    setb %bl
; X32-NEXT:    testl %eax, %eax
; X32-NEXT:    setns %al
; X32-NEXT:    testl %ecx, %ecx
; X32-NEXT:    setns %cl
; X32-NEXT:    cmpb %al, %cl
; X32-NEXT:    sete %al
; X32-NEXT:    testl %edx, %edx
; X32-NEXT:    setns %dl
; X32-NEXT:    cmpb %dl, %cl
; X32-NEXT:    setne %dl
; X32-NEXT:    andb %al, %dl
; X32-NEXT:    orb %bl, %dl
; X32-NEXT:    xorl %eax, %eax
; X32-NEXT:    popl %ebx
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_uaddo_saddo:
; X64:       # %bb.0:
; X64-NEXT:    shlq $32, %rdi
; X64-NEXT:    shlq $32, %rsi
; X64-NEXT:    addq %rdi, %rsi
; X64-NEXT:    setb %al
; X64-NEXT:    seto %dl
; X64-NEXT:    orb %al, %dl
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    retq
  %1 = shl i64 %a0, 32
  %2 = shl i64 %a1, 32
  %u = call {i64, i1} @llvm.uadd.with.overflow.i64(i64 %1, i64 %2)
  %uval = extractvalue {i64, i1} %u, 0
  %uovf = extractvalue {i64, i1} %u, 1
  %s = call {i64, i1} @llvm.sadd.with.overflow.i64(i64 %1, i64 %2)
  %sval = extractvalue {i64, i1} %s, 0
  %sovf = extractvalue {i64, i1} %s, 1
  %sum = add i64 %uval, %sval
  %3 = trunc i64 %sum to i32
  %4 = or i1 %uovf, %sovf
  %ret0 = insertvalue {i32, i1} undef, i32 %3, 0
  %ret1 = insertvalue {i32, i1} %ret0, i1 %4, 1
  ret {i32, i1} %ret1
}

define {i32, i1} @knownbits_usubo_ssubo(i64 %a0, i64 %a1) nounwind {
; X32-LABEL: knownbits_usubo_ssubo:
; X32:       # %bb.0:
; X32-NEXT:    pushl %ebx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl %ecx, %edx
; X32-NEXT:    subl %eax, %edx
; X32-NEXT:    setb %bl
; X32-NEXT:    testl %eax, %eax
; X32-NEXT:    setns %al
; X32-NEXT:    testl %ecx, %ecx
; X32-NEXT:    setns %cl
; X32-NEXT:    cmpb %al, %cl
; X32-NEXT:    setne %al
; X32-NEXT:    testl %edx, %edx
; X32-NEXT:    setns %dl
; X32-NEXT:    cmpb %dl, %cl
; X32-NEXT:    setne %dl
; X32-NEXT:    andb %al, %dl
; X32-NEXT:    orb %bl, %dl
; X32-NEXT:    xorl %eax, %eax
; X32-NEXT:    popl %ebx
; X32-NEXT:    retl
;
; X64-LABEL: knownbits_usubo_ssubo:
; X64:       # %bb.0:
; X64-NEXT:    shlq $32, %rdi
; X64-NEXT:    shlq $32, %rsi
; X64-NEXT:    cmpq %rsi, %rdi
; X64-NEXT:    setb %al
; X64-NEXT:    seto %dl
; X64-NEXT:    orb %al, %dl
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    retq
  %1 = shl i64 %a0, 32
  %2 = shl i64 %a1, 32
  %u = call {i64, i1} @llvm.usub.with.overflow.i64(i64 %1, i64 %2)
  %uval = extractvalue {i64, i1} %u, 0
  %uovf = extractvalue {i64, i1} %u, 1
  %s = call {i64, i1} @llvm.ssub.with.overflow.i64(i64 %1, i64 %2)
  %sval = extractvalue {i64, i1} %s, 0
  %sovf = extractvalue {i64, i1} %s, 1
  %sum = add i64 %uval, %sval
  %3 = trunc i64 %sum to i32
  %4 = or i1 %uovf, %sovf
  %ret0 = insertvalue {i32, i1} undef, i32 %3, 0
  %ret1 = insertvalue {i32, i1} %ret0, i1 %4, 1
  ret {i32, i1} %ret1
}

declare {i64, i1} @llvm.uadd.with.overflow.i64(i64, i64) nounwind readnone
declare {i64, i1} @llvm.sadd.with.overflow.i64(i64, i64) nounwind readnone
declare {i64, i1} @llvm.usub.with.overflow.i64(i64, i64) nounwind readnone
declare {i64, i1} @llvm.ssub.with.overflow.i64(i64, i64) nounwind readnone
