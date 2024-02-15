; RUN: if [ %llvmver -lt 16 ] && [ %llvmver -gt 11 ]; then %opt < %s %loadEnzyme -print-type-analysis -type-analysis-func=smax0 -o /dev/null | FileCheck %s; fi
; RUN: if [ %llvmver -gt 11 ]; then %opt < %s %newLoadEnzyme -passes="print-type-analysis" -type-analysis-func=smax0 -S -o /dev/null | FileCheck %s

define i32 @smax0(i32 %a, i32 %b) {
entry:
  %0 = call i32 @llvm.smax.i32(i32 %a, i32 0)
  %1 = call i32 @getint()
  %2 = call i32 @llvm.smax.i32(i32 %1, i32 0)
  ret i32 %2
}

declare i32 @llvm.smax.i32(i32, i32)

declare i32 @getint()

; CHECK: smax0 - {[-1]:Integer} |{[-1]:Integer}:{} {[-1]:Integer}:{}
; CHECK-NEXT: i32 %a: {[-1]:Integer}
; CHECK-NEXT: i32 %b: {[-1]:Integer}
; CHECK-NEXT: entry
; CHECK-NEXT: %0 = call i32 @llvm.smax.i32(i32 %a, i32 0): {[-1]:Integer}
; CHECK-NEXT: %1 = call i32 @getint(): {[-1]:Integer}
; CHECK-NEXT: %2 = call i32 @llvm.smax.i32(i32 %1, i32 0): {[-1]:Integer}
; CHECK-NEXT: ret i32 %2: {}
