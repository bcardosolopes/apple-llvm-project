# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -iterations=1 -timeline < %s | FileCheck %s

# LLVM-MCA-BEGIN
imul %rax, %rax
cmpxchgq %rcx, (%rdx)
# LLVM-MCA-END

# LLVM-MCA-BEGIN
imul %rcx, %rcx
cmpxchgq %rcx, (%rdx)
# LLVM-MCA-END

# LLVM-MCA-BEGIN
imul %rax, %rax
lock cmpxchgq %rcx, (%rdx)
# LLVM-MCA-END

# LLVM-MCA-BEGIN
imul %rcx, %rcx
lock cmpxchgq %rcx, (%rdx)
# LLVM-MCA-END

# CHECK:      [0] Code Region

# CHECK:      Iterations:        1
# CHECK-NEXT: Instructions:      2
# CHECK-NEXT: Total Cycles:      17
# CHECK-NEXT: Total uOps:        8

# CHECK:      Dispatch Width:    2
# CHECK-NEXT: uOps Per Cycle:    0.47
# CHECK-NEXT: IPC:               0.12
# CHECK-NEXT: Block RThroughput: 4.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      6     4.00                        imulq	%rax, %rax
# CHECK-NEXT:  6      11    1.50    *      *            cmpxchgq	%rcx, (%rdx)

# CHECK:      Resources:
# CHECK-NEXT: [0]   - JALU0
# CHECK-NEXT: [1]   - JALU1
# CHECK-NEXT: [2]   - JDiv
# CHECK-NEXT: [3]   - JFPA
# CHECK-NEXT: [4]   - JFPM
# CHECK-NEXT: [5]   - JFPU0
# CHECK-NEXT: [6]   - JFPU1
# CHECK-NEXT: [7]   - JLAGU
# CHECK-NEXT: [8]   - JMul
# CHECK-NEXT: [9]   - JSAGU
# CHECK-NEXT: [10]  - JSTC
# CHECK-NEXT: [11]  - JVALU0
# CHECK-NEXT: [12]  - JVALU1
# CHECK-NEXT: [13]  - JVIMUL

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]
# CHECK-NEXT: 3.00   1.00    -      -      -      -      -     1.00   4.00   1.00    -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]   Instructions:
# CHECK-NEXT:  -     1.00    -      -      -      -      -      -     4.00    -      -      -      -      -     imulq	%rax, %rax
# CHECK-NEXT: 3.00    -      -      -      -      -      -     1.00    -     1.00    -      -      -      -     cmpxchgq	%rcx, (%rdx)

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeeeeER .    ..   imulq	%rax, %rax
# CHECK-NEXT: [0,1]     .D==eeeeeeeeeeeER   cmpxchgq	%rcx, (%rdx)

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     1     1.0    1.0    0.0       imulq	%rax, %rax
# CHECK-NEXT: 1.     1     3.0    0.0    0.0       cmpxchgq	%rcx, (%rdx)

# CHECK:      [1] Code Region

# CHECK:      Iterations:        1
# CHECK-NEXT: Instructions:      2
# CHECK-NEXT: Total Cycles:      17
# CHECK-NEXT: Total uOps:        8

# CHECK:      Dispatch Width:    2
# CHECK-NEXT: uOps Per Cycle:    0.47
# CHECK-NEXT: IPC:               0.12
# CHECK-NEXT: Block RThroughput: 4.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      6     4.00                        imulq	%rcx, %rcx
# CHECK-NEXT:  6      11    1.50    *      *            cmpxchgq	%rcx, (%rdx)

# CHECK:      Resources:
# CHECK-NEXT: [0]   - JALU0
# CHECK-NEXT: [1]   - JALU1
# CHECK-NEXT: [2]   - JDiv
# CHECK-NEXT: [3]   - JFPA
# CHECK-NEXT: [4]   - JFPM
# CHECK-NEXT: [5]   - JFPU0
# CHECK-NEXT: [6]   - JFPU1
# CHECK-NEXT: [7]   - JLAGU
# CHECK-NEXT: [8]   - JMul
# CHECK-NEXT: [9]   - JSAGU
# CHECK-NEXT: [10]  - JSTC
# CHECK-NEXT: [11]  - JVALU0
# CHECK-NEXT: [12]  - JVALU1
# CHECK-NEXT: [13]  - JVIMUL

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]
# CHECK-NEXT: 3.00   1.00    -      -      -      -      -     1.00   4.00   1.00    -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]   Instructions:
# CHECK-NEXT:  -     1.00    -      -      -      -      -      -     4.00    -      -      -      -      -     imulq	%rcx, %rcx
# CHECK-NEXT: 3.00    -      -      -      -      -      -     1.00    -     1.00    -      -      -      -     cmpxchgq	%rcx, (%rdx)

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeeeeER .    ..   imulq	%rcx, %rcx
# CHECK-NEXT: [0,1]     .D==eeeeeeeeeeeER   cmpxchgq	%rcx, (%rdx)

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     1     1.0    1.0    0.0       imulq	%rcx, %rcx
# CHECK-NEXT: 1.     1     3.0    0.0    0.0       cmpxchgq	%rcx, (%rdx)

# CHECK:      [2] Code Region

# CHECK:      Iterations:        1
# CHECK-NEXT: Instructions:      2
# CHECK-NEXT: Total Cycles:      23
# CHECK-NEXT: Total uOps:        8

# CHECK:      Dispatch Width:    2
# CHECK-NEXT: uOps Per Cycle:    0.35
# CHECK-NEXT: IPC:               0.09
# CHECK-NEXT: Block RThroughput: 17.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      6     4.00                        imulq	%rax, %rax
# CHECK-NEXT:  6      17    17.00   *      *            lock		cmpxchgq	%rcx, (%rdx)

# CHECK:      Resources:
# CHECK-NEXT: [0]   - JALU0
# CHECK-NEXT: [1]   - JALU1
# CHECK-NEXT: [2]   - JDiv
# CHECK-NEXT: [3]   - JFPA
# CHECK-NEXT: [4]   - JFPM
# CHECK-NEXT: [5]   - JFPU0
# CHECK-NEXT: [6]   - JFPU1
# CHECK-NEXT: [7]   - JLAGU
# CHECK-NEXT: [8]   - JMul
# CHECK-NEXT: [9]   - JSAGU
# CHECK-NEXT: [10]  - JSTC
# CHECK-NEXT: [11]  - JVALU0
# CHECK-NEXT: [12]  - JVALU1
# CHECK-NEXT: [13]  - JVIMUL

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]
# CHECK-NEXT: 3.00   1.00    -      -      -      -      -     17.00  4.00   17.00   -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]   Instructions:
# CHECK-NEXT:  -     1.00    -      -      -      -      -      -     4.00    -      -      -      -      -     imulq	%rax, %rax
# CHECK-NEXT: 3.00    -      -      -      -      -      -     17.00   -     17.00   -      -      -      -     lock		cmpxchgq	%rcx, (%rdx)

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789
# CHECK-NEXT: Index     0123456789          012

# CHECK:      [0,0]     DeeeeeeER .    .    . .   imulq	%rax, %rax
# CHECK-NEXT: [0,1]     .D==eeeeeeeeeeeeeeeeeER   lock		cmpxchgq	%rcx, (%rdx)

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     1     1.0    1.0    0.0       imulq	%rax, %rax
# CHECK-NEXT: 1.     1     3.0    0.0    0.0       lock		cmpxchgq	%rcx, (%rdx)

# CHECK:      [3] Code Region

# CHECK:      Iterations:        1
# CHECK-NEXT: Instructions:      2
# CHECK-NEXT: Total Cycles:      23
# CHECK-NEXT: Total uOps:        8

# CHECK:      Dispatch Width:    2
# CHECK-NEXT: uOps Per Cycle:    0.35
# CHECK-NEXT: IPC:               0.09
# CHECK-NEXT: Block RThroughput: 17.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      6     4.00                        imulq	%rcx, %rcx
# CHECK-NEXT:  6      17    17.00   *      *            lock		cmpxchgq	%rcx, (%rdx)

# CHECK:      Resources:
# CHECK-NEXT: [0]   - JALU0
# CHECK-NEXT: [1]   - JALU1
# CHECK-NEXT: [2]   - JDiv
# CHECK-NEXT: [3]   - JFPA
# CHECK-NEXT: [4]   - JFPM
# CHECK-NEXT: [5]   - JFPU0
# CHECK-NEXT: [6]   - JFPU1
# CHECK-NEXT: [7]   - JLAGU
# CHECK-NEXT: [8]   - JMul
# CHECK-NEXT: [9]   - JSAGU
# CHECK-NEXT: [10]  - JSTC
# CHECK-NEXT: [11]  - JVALU0
# CHECK-NEXT: [12]  - JVALU1
# CHECK-NEXT: [13]  - JVIMUL

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]
# CHECK-NEXT: 3.00   1.00    -      -      -      -      -     17.00  4.00   17.00   -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]   Instructions:
# CHECK-NEXT:  -     1.00    -      -      -      -      -      -     4.00    -      -      -      -      -     imulq	%rcx, %rcx
# CHECK-NEXT: 3.00    -      -      -      -      -      -     17.00   -     17.00   -      -      -      -     lock		cmpxchgq	%rcx, (%rdx)

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789
# CHECK-NEXT: Index     0123456789          012

# CHECK:      [0,0]     DeeeeeeER .    .    . .   imulq	%rcx, %rcx
# CHECK-NEXT: [0,1]     .D==eeeeeeeeeeeeeeeeeER   lock		cmpxchgq	%rcx, (%rdx)

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     1     1.0    1.0    0.0       imulq	%rcx, %rcx
# CHECK-NEXT: 1.     1     3.0    0.0    0.0       lock		cmpxchgq	%rcx, (%rdx)
