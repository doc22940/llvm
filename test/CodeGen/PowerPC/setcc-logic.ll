; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -verify-machineinstrs -mtriple=powerpc64le-unknown-unknown | FileCheck %s

define zeroext i1 @all_bits_clear(i32 %P, i32 %Q)  {
; CHECK-LABEL: all_bits_clear:
; CHECK:       # BB#0:
; CHECK-NEXT:    or 3, 3, 4
; CHECK-NEXT:    cntlzw 3, 3
; CHECK-NEXT:    rlwinm 3, 3, 27, 31, 31
; CHECK-NEXT:    blr
  %a = icmp eq i32 %P, 0
  %b = icmp eq i32 %Q, 0
  %c = and i1 %a, %b
  ret i1 %c
}

define zeroext i1 @all_sign_bits_clear(i32 %P, i32 %Q)  {
; CHECK-LABEL: all_sign_bits_clear:
; CHECK:       # BB#0:
; CHECK-NEXT:    or 3, 3, 4
; CHECK-NEXT:    nor 3, 3, 3
; CHECK-NEXT:    srwi 3, 3, 31
; CHECK-NEXT:    blr
  %a = icmp sgt i32 %P, -1
  %b = icmp sgt i32 %Q, -1
  %c = and i1 %a, %b
  ret i1 %c
}

define zeroext i1 @all_bits_set(i32 %P, i32 %Q)  {
; CHECK-LABEL: all_bits_set:
; CHECK:       # BB#0:
; CHECK-NEXT:    and 3, 3, 4
; CHECK-NEXT:    li 5, 0
; CHECK-NEXT:    li 12, 1
; CHECK-NEXT:    cmpwi 0, 3, -1
; CHECK-NEXT:    isel 3, 12, 5, 2
; CHECK-NEXT:    blr
  %a = icmp eq i32 %P, -1
  %b = icmp eq i32 %Q, -1
  %c = and i1 %a, %b
  ret i1 %c
}

define zeroext i1 @all_sign_bits_set(i32 %P, i32 %Q)  {
; CHECK-LABEL: all_sign_bits_set:
; CHECK:       # BB#0:
; CHECK-NEXT:    and 3, 3, 4
; CHECK-NEXT:    srwi 3, 3, 31
; CHECK-NEXT:    blr
  %a = icmp slt i32 %P, 0
  %b = icmp slt i32 %Q, 0
  %c = and i1 %a, %b
  ret i1 %c
}

define zeroext i1 @any_bits_set(i32 %P, i32 %Q)  {
; CHECK-LABEL: any_bits_set:
; CHECK:       # BB#0:
; CHECK-NEXT:    or 3, 3, 4
; CHECK-NEXT:    cntlzw 3, 3
; CHECK-NEXT:    nor 3, 3, 3
; CHECK-NEXT:    rlwinm 3, 3, 27, 31, 31
; CHECK-NEXT:    blr
  %a = icmp ne i32 %P, 0
  %b = icmp ne i32 %Q, 0
  %c = or i1 %a, %b
  ret i1 %c
}

define zeroext i1 @any_sign_bits_set(i32 %P, i32 %Q)  {
; CHECK-LABEL: any_sign_bits_set:
; CHECK:       # BB#0:
; CHECK-NEXT:    or 3, 3, 4
; CHECK-NEXT:    srwi 3, 3, 31
; CHECK-NEXT:    blr
  %a = icmp slt i32 %P, 0
  %b = icmp slt i32 %Q, 0
  %c = or i1 %a, %b
  ret i1 %c
}

define zeroext i1 @any_bits_clear(i32 %P, i32 %Q)  {
; CHECK-LABEL: any_bits_clear:
; CHECK:       # BB#0:
; CHECK-NEXT:    and 3, 3, 4
; CHECK-NEXT:    li 5, 1
; CHECK-NEXT:    cmpwi 0, 3, -1
; CHECK-NEXT:    isel 3, 0, 5, 2
; CHECK-NEXT:    blr
  %a = icmp ne i32 %P, -1
  %b = icmp ne i32 %Q, -1
  %c = or i1 %a, %b
  ret i1 %c
}

define zeroext i1 @any_sign_bits_clear(i32 %P, i32 %Q)  {
; CHECK-LABEL: any_sign_bits_clear:
; CHECK:       # BB#0:
; CHECK-NEXT:    and 3, 3, 4
; CHECK-NEXT:    nor 3, 3, 3
; CHECK-NEXT:    srwi 3, 3, 31
; CHECK-NEXT:    blr
  %a = icmp sgt i32 %P, -1
  %b = icmp sgt i32 %Q, -1
  %c = or i1 %a, %b
  ret i1 %c
}

; PR3351 - (P == 0) & (Q == 0) -> (P|Q) == 0
define i32 @all_bits_clear_branch(i32* %P, i32* %Q)  {
; CHECK-LABEL: all_bits_clear_branch:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    or. 3, 3, 4
; CHECK-NEXT:    bne 0, .LBB8_2
; CHECK-NEXT:  # BB#1: # %bb1
; CHECK-NEXT:    li 3, 4
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB8_2: # %return
; CHECK-NEXT:    li 3, 192
; CHECK-NEXT:    blr
entry:
  %a = icmp eq i32* %P, null
  %b = icmp eq i32* %Q, null
  %c = and i1 %a, %b
  br i1 %c, label %bb1, label %return

bb1:
  ret i32 4

return:
  ret i32 192
}

define i32 @all_sign_bits_clear_branch(i32 %P, i32 %Q)  {
; CHECK-LABEL: all_sign_bits_clear_branch:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    or 3, 3, 4
; CHECK-NEXT:    cmpwi 0, 3, 0
; CHECK-NEXT:    blt 0, .LBB9_2
; CHECK-NEXT:  # BB#1: # %bb1
; CHECK-NEXT:    li 3, 4
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB9_2: # %return
; CHECK-NEXT:    li 3, 192
; CHECK-NEXT:    blr
entry:
  %a = icmp sgt i32 %P, -1
  %b = icmp sgt i32 %Q, -1
  %c = and i1 %a, %b
  br i1 %c, label %bb1, label %return

bb1:
  ret i32 4

return:
  ret i32 192
}

define i32 @all_bits_set_branch(i32 %P, i32 %Q)  {
; CHECK-LABEL: all_bits_set_branch:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    and 3, 3, 4
; CHECK-NEXT:    cmpwi 0, 3, -1
; CHECK-NEXT:    bne 0, .LBB10_2
; CHECK-NEXT:  # BB#1: # %bb1
; CHECK-NEXT:    li 3, 4
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB10_2: # %return
; CHECK-NEXT:    li 3, 192
; CHECK-NEXT:    blr
entry:
  %a = icmp eq i32 %P, -1
  %b = icmp eq i32 %Q, -1
  %c = and i1 %a, %b
  br i1 %c, label %bb1, label %return

bb1:
  ret i32 4

return:
  ret i32 192
}

define i32 @all_sign_bits_set_branch(i32 %P, i32 %Q)  {
; CHECK-LABEL: all_sign_bits_set_branch:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    and 3, 3, 4
; CHECK-NEXT:    cmpwi 0, 3, -1
; CHECK-NEXT:    bgt 0, .LBB11_2
; CHECK-NEXT:  # BB#1: # %bb1
; CHECK-NEXT:    li 3, 4
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB11_2: # %return
; CHECK-NEXT:    li 3, 192
; CHECK-NEXT:    blr
entry:
  %a = icmp slt i32 %P, 0
  %b = icmp slt i32 %Q, 0
  %c = and i1 %a, %b
  br i1 %c, label %bb1, label %return

bb1:
  ret i32 4

return:
  ret i32 192
}

; PR3351 - (P != 0) | (Q != 0) -> (P|Q) != 0
define i32 @any_bits_set_branch(i32* %P, i32* %Q)  {
; CHECK-LABEL: any_bits_set_branch:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    or. 3, 3, 4
; CHECK-NEXT:    beq 0, .LBB12_2
; CHECK-NEXT:  # BB#1: # %bb1
; CHECK-NEXT:    li 3, 4
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB12_2: # %return
; CHECK-NEXT:    li 3, 192
; CHECK-NEXT:    blr
entry:
  %a = icmp ne i32* %P, null
  %b = icmp ne i32* %Q, null
  %c = or i1 %a, %b
  br i1 %c, label %bb1, label %return

bb1:
  ret i32 4

return:
  ret i32 192
}

define i32 @any_sign_bits_set_branch(i32 %P, i32 %Q)  {
; CHECK-LABEL: any_sign_bits_set_branch:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    or 3, 3, 4
; CHECK-NEXT:    cmpwi 0, 3, -1
; CHECK-NEXT:    bgt 0, .LBB13_2
; CHECK-NEXT:  # BB#1: # %bb1
; CHECK-NEXT:    li 3, 4
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB13_2: # %return
; CHECK-NEXT:    li 3, 192
; CHECK-NEXT:    blr
entry:
  %a = icmp slt i32 %P, 0
  %b = icmp slt i32 %Q, 0
  %c = or i1 %a, %b
  br i1 %c, label %bb1, label %return

bb1:
  ret i32 4

return:
  ret i32 192
}

define i32 @any_bits_clear_branch(i32 %P, i32 %Q)  {
; CHECK-LABEL: any_bits_clear_branch:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    and 3, 3, 4
; CHECK-NEXT:    cmpwi 0, 3, -1
; CHECK-NEXT:    beq 0, .LBB14_2
; CHECK-NEXT:  # BB#1: # %bb1
; CHECK-NEXT:    li 3, 4
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB14_2: # %return
; CHECK-NEXT:    li 3, 192
; CHECK-NEXT:    blr
entry:
  %a = icmp ne i32 %P, -1
  %b = icmp ne i32 %Q, -1
  %c = or i1 %a, %b
  br i1 %c, label %bb1, label %return

bb1:
  ret i32 4

return:
  ret i32 192
}

define i32 @any_sign_bits_clear_branch(i32 %P, i32 %Q)  {
; CHECK-LABEL: any_sign_bits_clear_branch:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    and 3, 3, 4
; CHECK-NEXT:    cmpwi 0, 3, 0
; CHECK-NEXT:    blt 0, .LBB15_2
; CHECK-NEXT:  # BB#1: # %bb1
; CHECK-NEXT:    li 3, 4
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB15_2: # %return
; CHECK-NEXT:    li 3, 192
; CHECK-NEXT:    blr
entry:
  %a = icmp sgt i32 %P, -1
  %b = icmp sgt i32 %Q, -1
  %c = or i1 %a, %b
  br i1 %c, label %bb1, label %return

bb1:
  ret i32 4

return:
  ret i32 192
}

