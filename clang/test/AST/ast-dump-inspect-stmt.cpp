// RUN: %clang_cc1 -fsyntax-only -fpattern-matching -ast-dump -Wno-unused-value %s | FileCheck %s

void TestInspect(int a, int b) {
  inspect(3) {
    __ => {};
  };
  // CHECK: InspectExpr 0x{{[^ ]*}} <line:[[@LINE-3]]:3, line:[[@LINE-1]]:3> 'void' has_implicit_result_type
  // CHECK-NEXT: IntegerLiteral 0x{{[^ ]*}} <line:[[@LINE-4]]:11> 'int' 3
  // CHECK-NEXT: CompoundStmt 0x{{[^ ]*}} <col:14, line:[[@LINE-3]]:3>
  // CHECK-NEXT: WildcardPatternStmt 0x{{[^ ]*}} <line:[[@LINE-5]]:5, col:12>
  // CHECK-NEXT: CompoundStmt

  inspect(a) {
    __ if (b>0) => {};
  };
  // CHECK: InspectExpr 0x{{[^ ]*}} <line:[[@LINE-3]]:3, line:[[@LINE-1]]:3> 'void' has_implicit_result_type
  // CHECK: WildcardPatternStmt 0x{{[^ ]*}} <line:[[@LINE-3]]:5, col:21> has_guard
  // CHECK-NEXT: CompoundStmt
  // CHECK-NEXT: BinaryOperator 0x{{[^ ]*}} <col:12, col:14> 'bool' '>'

  inspect(3) -> void {
    __ => {};
  };
  // CHECK: InspectExpr 0x{{[^ ]*}} <line:[[@LINE-3]]:3, line:[[@LINE-1]]:3> 'void' has_explicit_result_type
  // CHECK-NEXT: IntegerLiteral 0x{{[^ ]*}} <line:[[@LINE-4]]:11> 'int' 3
  // CHECK-NEXT: CompoundStmt
  // CHECK-NEXT: WildcardPatternStmt 0x{{[^ ]*}} <line:[[@LINE-5]]:5, col:12>
  // CHECK-NEXT: CompoundStmt

  int x = 3;
  int w = inspect(x) -> int {
    y => y++;
  };
  // CHECK: InspectExpr {{.*}}'int' has_explicit_result_type
  // CHECK: IdentifierPatternStmt 0x{{[^ ]*}} <line:[[@LINE-3]]:5, col:11>
  // CHECK-NEXT: UnaryOperator 0x{{[^ ]*}} <col:10, col:11> 'int':'int' postfix '++'
  // CHECK-NEXT: DeclRefExpr 0x{{[^ ]*}} <col:10> 'int':'int' lvalue Var 0x{{[^ ]*}} 'y' 'int &&'
  // CHECK-NEXT: DeclStmt 0x{{[^ ]*}} <col:5>
  // CHECK-NEXT: VarDecl 0x{{.*}} used y 'int &&' auto cinit

  int v = inspect(x) -> int {
    7 => 4;
  };
  // CHECK: ExpressionPatternStmt {{.*}} <line:[[@LINE-2]]:5, col:10>
  // CHECK-NEXT: IntegerLiteral {{.*}} <col:10> 'int' 4
  // CHECK-NEXT: BinaryOperator {{.*}} <line:[[@LINE-5]]:19, line:[[@LINE-4]]:5>  'bool' '=='
  // CHECK-NEXT: ImplicitCastExpr {{.*}} <line:[[@LINE-6]]:19> 'int' <LValueToRValue>
  // CHECK-NEXT: DeclRefExpr {{.*}} <col:19> 'int' lvalue Var {{.*}} 'x' 'int'
  // CHECK-NEXT: ConstantExpr {{.*}} 'int' Int: 7
  // CHECK-NEXT: IntegerLiteral {{.*}}

  inspect(x) {
    case 7 =>;
  };
  // CHECK: ExpressionPatternStmt {{.*}} <line:[[@LINE-2]]:10, col:14> has_case

  enum class Color { Red, Green, Blue };
  enum Color2 { Red, Green, Blue };

  inspect (x) {
    (int)Color::Red => {}
    case Green => {}
    8 => {}
    Green if(x>0) => {} // should be parsed as identifier pattern
    __ => {}
  };
  // CHECK: InspectExpr {{.*}} 'void' has_implicit_result_type
  // CHECK: ExpressionPatternStmt
  // CHECK: ExpressionPatternStmt
  // CHECK: ExpressionPatternStmt
  // CHECK: IdentifierPatternStmt
  // CHECK: WildcardPatternStmt

  struct s {
    int a;
    int b;
  };
  s cond{1,2};
  inspect (cond) {
    [1, 2] => { cond.a++; };
  };
  // CHECK: InspectExpr {{.*}} 'void' has_implicit_result_type
  // CHECK: StructuredBindingPatternStmt {{.*}} <line:80:5, col:10>
  // CHECK: CompoundStmt {{.*}} <col:15, col:27>
  // CHECK: DeclStmt
  // CHECK: `-DecompositionDecl {{.*}} line:79:12 used 's &' cinit
  // CHECK:   |-BindingDecl {{.*}} <col:12> col:12 __pat_0_0 'int'
  // CHECK:     `-MemberExpr {{.*}} <col:12> 'int' lvalue .a
  // CHECK:   `-BindingDecl {{.*}} <col:12> col:12 __pat_0_1 'int'
  // CHECK:      `-MemberExpr {{.*}} <col:12> 'int' lvalue .b
  // CHECK: BinaryOperator {{.*}} 'bool' '&&'
  // CHECK: |-BinaryOperator {{.*}} 'bool' '=='
  // CHECK:   |-ImplicitCastExpr {{.*}} 'int' <LValueToRValue>
  // CHECK:   | `-MemberExpr {{.*}} 'int' lvalue .a
  // CHECK:   |   `-DeclRefExpr {{.*}} 's' lvalue Decomposition {{.*}} '' 's &'
  // CHECK:   `-ConstantExpr {{.*}} 'int' Int: 1
  // CHECK:     `-IntegerLiteral {{.*}} 'int' 1
  // CHECK: `-BinaryOperator {{.*}} 'bool' '=='
  // CHECK:   |-ImplicitCastExpr {{.*}} 'int' <LValueToRValue>
  // CHECK:   | `-MemberExpr {{.*}} 'int' lvalue .b
  // CHECK:   |   `-DeclRefExpr {{.*}} 's' lvalue Decomposition {{.*}} '' 's &'
  // CHECK:   `-ConstantExpr {{.*}} 'int' Int: 2
  // CHECK:     `-IntegerLiteral {{.*}} 'int' 2

  struct color_pack {
    Color2 c1, c2;
  };
  color_pack cp{Red, Blue};
  inspect (cp) {
    [case Red, case Green] =>;
    [Color2::Red, Color2::Blue] =>;
    [Green, case Color2::Red] =>;
  };

  // CHECK: InspectExpr {{.*}} 'void' has_implicit_result_type
  // CHECK: StructuredBindingPatternStmt
  // CHECK: `-BinaryOperator {{.*}} 'bool' '&&'
  // CHECK:   |-BinaryOperator {{.*}} 'bool' '=='
  // CHECK:     `-MemberExpr {{.*}} 'Color2' lvalue .c1
  // CHECK:       `-DeclRefExpr {{.*}} <col:11> 'Color2' EnumConstant {{.*}} 'Red' 'Color2'
  // CHECK:   `-BinaryOperator {{.*}} 'bool' '=='
  // CHECK:     `-MemberExpr {{.*}} <col:12> 'Color2' lvalue .c2
  // CHECK:       `-DeclRefExpr {{.*}} <col:21> 'Color2' EnumConstant {{.*}} 'Green' 'Color2'
  // CHECK: StructuredBindingPatternStmt
  // CHECK: `-BinaryOperator {{.*}} 'bool' '&&'
  // CHECK:   |-BinaryOperator {{.*}} 'bool' '=='
  // CHECK:     `-MemberExpr {{.*}} <col:12> 'Color2' lvalue .c1
  // CHECK:       `-DeclRefExpr {{.*}} <col:6, col:14> 'Color2' EnumConstant {{.*}} 'Red' 'Color2'
  // CHECK:   `-BinaryOperator {{.*}} 'bool' '=='
  // CHECK:     `-MemberExpr {{.*}} <col:12> 'Color2' lvalue .c2
  // CHECK:       `-DeclRefExpr {{.*}} <col:19, col:27> 'Color2' EnumConstant {{.*}} 'Blue' 'Color2'
  // CHECK: StructuredBindingPatternStmt
  // CHECK: DeclStmt
  // CHECK: `-DecompositionDecl {{.*}} 'color_pack &' cinit
  // CHECK:   |-BindingDecl {{.*}} col:6 Green 'Color2'
  // CHECK:   | `-MemberExpr {{.*}} <col:6> 'Color2' lvalue .c1
  // CHECK:   `-BindingDecl {{.*}} col:12 __pat_3_1 'Color2'
  // CHECK:     `-MemberExpr {{.*}} <col:12> 'Color2' lvalue .c2
  // CHECK: `-BinaryOperator {{.*}} 'bool' '=='
  // CHECK:   `-MemberExpr {{.*}} <col:12> 'Color2' lvalue .c2
  // CHECK:     `-DeclRefExpr {{.*}} <col:12> 'color_pack' lvalue Decomposition {{.*}} '' 'color_pack &'
  // CHECK:   `-ConstantExpr {{.*}} <col:18, col:26> 'Color2' Int: 0

  int array[2] = {2,1};
  inspect (array) {
    [1,2] =>;
  };
  // CHECK: InspectExpr
  // CHECK: StructuredBindingPatternStmt
  // CHECK: BinaryOperator {{.*}} 'bool' '&&'
  // CHECK:   BinaryOperator {{.*}} 'bool' '=='
  // CHECK:     ArraySubscriptExpr {{.*}} <col:12> 'int' lvalue
  // CHECK:       IntegerLiteral {{.*}} <col:12> 'int' 0
  // CHECK:   BinaryOperator
  // CHECK:     ArraySubscriptExpr {{.*}} <col:12> 'int' lvalue
  // CHECK:       IntegerLiteral {{.*}} <col:12> 'int' 1

  struct insn_type {
    unsigned opc : 16, imm : 16;
  };
  insn_type insn;
  inspect(insn) {
    [o, i] => { o++; };
  };
  // CHECK: InspectExpr
  // CHECK: StructuredBindingPatternStmt
  // CHECK: |-CompoundStmt {{.*}} <col:15, col:22>
  // CHECK: | `-UnaryOperator {{.*}} <col:17, col:18> 'unsigned int' postfix '++'
  // CHECK: |   `-DeclRefExpr {{.*}} <col:17> 'unsigned int' lvalue bitfield Binding {{.*}} 'o' 'unsigned int'
  // CHECK: `-DeclStmt
  // CHECK:   `-DecompositionDecl {{.*}} used 'insn_type &' cinit
  // CHECK:     |-BindingDecl {{.*}}  col:6 referenced o 'unsigned int'
  // CHECK:     | `-MemberExpr {{.*}} <col:6> 'unsigned int' lvalue bitfield .opc
  // CHECK:     `-BindingDecl {{.*}}  <col:9> col:9 i 'unsigned int'
  // CHECK:       `-MemberExpr {{.*}}  <col:9> 'unsigned int' lvalue bitfield .imm
}
