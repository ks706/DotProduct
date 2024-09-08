    .section .note.GNU-stack, ""
    .global dot_double
    .global map_poly_double
    .global dot_single
    .global map_poly_single
    .global dot_double_vec
    .global dot_single_vec
    .global map_poly_double_vec
    .global map_poly_single_vec
    .text

dot_double:
    push %r12 #length
    mov %rdx, %r12 
    push %r13
    mov $0, %r13  # = i
    pxor %xmm1, %xmm1 #sum = 0
dot_loop:
    movq (%rdi, %r13, 8), %xmm0 #puts arr1[i] into xmm0
    mulsd (%rsi, %r13, 8), %xmm0 # *= arr2[i]
    addsd %xmm0, %xmm1 #add to sum 
    inc %r13 #i++
    cmp %r13, %r12 # while n > i
    je loop_end
    jmp dot_loop
loop_end:
    movq %xmm1, %xmm0
    pop %r13
    pop %r12
    ret
map_poly_double:
    push %r12 #length
    mov %rdx, %r12 
    push %r13
    mov $0, %r13  # = i
poly_loop: #x*(x*(a*x + b) + c) + d.
    movq (%rdi, %r13, 8), %xmm4 #puts arr1[i] into xmm4 for x
    movq %xmm4, %xmm5 #copies x for calculation 
    mulsd %xmm0, %xmm5 #a*x
    addsd %xmm1, %xmm5 #(a*x + b)
    mulsd %xmm4, %xmm5 #x*(a*x + b) 
    addsd %xmm2, %xmm5 #x*(a*x + b) + c 
    mulsd %xmm4, %xmm5 #x*(x*(a*x + b) + c) 
    addsd %xmm3, %xmm5 #x*(x*(a*x + b) + c) + d.
    movq %xmm5, (%rsi, %r13, 8) #puts value in output arr[i] 
    inc %r13 #i++
    cmp %r13, %r12 # while n > i
    je end_loop
    jmp poly_loop
end_loop:
    pop %r13
    pop %r12
    ret
dot_single: 
    push %r12 #length
    mov %rdx, %r12 
    push %r13
    mov $0, %r13  # = i
    pxor %xmm1, %xmm1 #sum = 0
dot_s_loop:
    movd (%rdi, %r13, 4), %xmm0 #puts arr1[i] into xmm0
    mulss (%rsi, %r13, 4), %xmm0 # *= arr2[i]
    addss %xmm0, %xmm1 #add to sum 
    inc %r13 #i++
    cmp %r13, %r12 # while n > i
    je loop_s_end
    jmp dot_s_loop
loop_s_end:
    movq %xmm1, %xmm0
    pop %r13
    pop %r12
    ret
map_poly_single: 
    push %r12 #length
    mov %rdx, %r12 
    push %r13
    mov $0, %r13  # = i
poly_s_loop: #x*(x*(a*x + b) + c) + d.
    movd (%rdi, %r13, 4), %xmm4 #puts arr1[i] into xmm4 for x
    movq %xmm4, %xmm5 #copies x for calculation 
    mulss %xmm0, %xmm5 #a*x
    addss %xmm1, %xmm5 #(a*x + b)
    mulss %xmm4, %xmm5 #x*(a*x + b) 
    addss %xmm2, %xmm5 #x*(a*x + b) + c 
    mulss %xmm4, %xmm5 #x*(x*(a*x + b) + c) 
    addss %xmm3, %xmm5 #x*(x*(a*x + b) + c) + d.
    movd %xmm5, (%rsi, %r13, 4) #puts value in output arr[i] 
    inc %r13 #i++
    cmp %r13, %r12 # while n > i
    je end_s_loop
    jmp poly_s_loop
end_s_loop:
    pop %r13
    pop %r12
    ret
dot_double_vec:
    push %r12 #length
    mov %rdx, %r12 
    push %r13
    mov $0, %r13  # = i
    vxorpd %ymm0, %ymm0, %ymm0 #clear register
    vxorpd %ymm1, %ymm1, %ymm1
    vxorpd %ymm2, %ymm2, %ymm2
dot_dv_loop:
    vmovupd (%rdi, %r13, 8), %ymm1  #Load 4 from arr1[i] into ymm1
    vmovupd (%rsi, %r13, 8), %ymm2  #Load 4 from arr2[i] into ymm2
    vmulpd %ymm1, %ymm2, %ymm1      #Multiply elements in ymm1 with ymm2
    vaddpd %ymm1, %ymm0, %ymm0  #Accumulate products in ymm0
    add $4, %r13 #i+=4
    cmp %r13, %r12 # while n > i
    je loop_dv_end
    jmp dot_dv_loop
loop_dv_end:
    pop %r13
    pop %r12
    vextractf128 $0x1, %ymm0, %xmm1
    vaddpd %xmm1, %xmm0, %xmm0
    vshufpd $0b01, %xmm0, %xmm0, %xmm1
    vaddsd %xmm1, %xmm0, %xmm0    
    ret
dot_single_vec: 
    push %r12 #length
    mov %rdx, %r12 
    push %r13
    mov $0, %r13  # = i
    vxorps %ymm0, %ymm0, %ymm0 #clear register
    vxorps %ymm1, %ymm1, %ymm1
    vxorps %ymm2, %ymm2, %ymm2
dot_sv_loop:
    vmovups (%rdi, %r13, 4), %ymm1  #Load 4 from arr1[i] into ymm1
    vmovups (%rsi, %r13, 4), %ymm2  #Load 4 from arr2[i] into ymm2
    vmulps %ymm1, %ymm2, %ymm1      #Multiply elements in ymm1 with ymm2
    vaddps %ymm1, %ymm0, %ymm0  #Accumulate products in ymm0
    add $8, %r13 #i+=4
    cmp %r13, %r12 # while n > i
    je loop_sv_end
    jmp dot_sv_loop
loop_sv_end:
    pop %r13
    pop %r12
    vextractf128 $0x1, %ymm0, %xmm1
    vaddps %xmm1, %xmm0, %xmm0
    vshufps $0b00001110, %xmm0, %xmm0, %xmm1
    vaddps %xmm1, %xmm0, %xmm0
    vshufps $0b00000001, %xmm0, %xmm0, %xmm1
    vaddss %xmm1, %xmm0, %xmm0
    ret
map_poly_double_vec:
    push %r12 #length
    mov %rdx, %r12 
    push %r13
    mov $0, %r13  # = i
    vxorpd %ymm0, %ymm0, %ymm0 #clear register
    vxorpd %ymm1, %ymm1, %ymm1 #clear register
    vxorpd %ymm2, %ymm2, %ymm2 #clear register
    vxorpd %ymm3, %ymm3, %ymm3 #clear register
    vxorpd %ymm4, %ymm4, %ymm4 #clear register
    vxorpd %ymm5, %ymm5, %ymm5 #clear register
poly_loop_v: #x*(x*(a*x + b) + c) + d.
    vmovupd (%rdi, %r13, 8), %ymm0 #puts arr1[i] into ymm0 for x
    vmovupd %ymm0, %ymm1 #copies x for calculation 
    vbroadcastsd %xmm0, %ymm2 #copies a into ymm2
    vmulpd %ymm0, %ymm2, %ymm0 #a * x
    vbroadcastsd %xmm1, %ymm3 #copies b into ymm3
    vaddpd %ymm0, %ymm3, %ymm0 #(a * x) + b
    vmulpd %ymm1, %ymm0, %ymm0 #x*(a*x + b) 
    vbroadcastsd %xmm2, %ymm4 #copies c into ymm4
    vaddpd %ymm4, %ymm0, %ymm0 #x*(a*x + b) + c 
    vbroadcastsd %xmm3, %ymm5 #copies d into ymm5
    vmulpd %ymm1, %ymm0, %ymm0 #x*(x*(a*x + b) + c) 
    vaddpd %ymm5, %ymm0, %ymm0 #x*(x*(a*x + b) + c) + d.
    vmovupd %ymm0, (%rsi, %r13, 8) #puts value in output arr[i] 
    add $4, %r13 #i++
    cmp %r13, %r12 # while n > i
    je end_loop_v
    jmp poly_loop_v
end_loop_v:
    pop %r13
    pop %r12
    ret
map_poly_single_vec:
    push %r12 #length
    mov %rdx, %r12 
    push %r13
    mov $0, %r13  # = i
    vxorps %ymm0, %ymm0, %ymm0 #clear register
    vxorps %ymm1, %ymm1, %ymm1 #clear register
    vxorps %ymm2, %ymm2, %ymm2 #clear register
    vxorps %ymm3, %ymm3, %ymm3 #clear register
    vxorps %ymm4, %ymm4, %ymm4 #clear register
    vxorps %ymm5, %ymm5, %ymm5 #clear register
poly_sv_loop: #x*(x*(a*x + b) + c) + d.
    vmovups (%rdi, %r13, 4), %ymm0 #puts arr1[i] into ymm0 for x
    vmovups %ymm0, %ymm1 #copies x for calculation 
    vbroadcastss %xmm0, %ymm2 #copies a into ymm2
    vmulps %ymm0, %ymm2, %ymm0 #a * x
    vbroadcastss %xmm1, %ymm3 #copies b into ymm3
    vaddps %ymm0, %ymm3, %ymm0 #(a * x) + b
    vmulps %ymm1, %ymm0, %ymm0 #x*(a*x + b) 
    vbroadcastss %xmm2, %ymm4 #copies c into ymm4
    vaddps %ymm4, %ymm0, %ymm0 #x*(a*x + b) + c 
    vbroadcastss %xmm3, %ymm5 #copies d into ymm5
    vmulps %ymm1, %ymm0, %ymm0 #x*(x*(a*x + b) + c) 
    vaddps %ymm5, %ymm0, %ymm0 #x*(x*(a*x + b) + c) + d.
    vmovups %ymm0, (%rsi, %r13, 4) #puts value in output arr[i] 
    add $8, %r13 #i++
    cmp %r13, %r12 # while n > i
    je end_sv_loop
    jmp poly_sv_loop
end_sv_loop:
    pop %r13
    pop %r12
    ret

