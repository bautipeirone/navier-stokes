	.text
	.file	"solver.c"
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function dens_step
.LCPI0_0:
	.long	0x40800000                      # float 4
.LCPI0_1:
	.long	0x3f800000                      # float 1
	.text
	.globl	dens_step
	.p2align	4, 0x90
	.type	dens_step,@function
dens_step:                              # @dens_step
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$56, %rsp
	.cfi_def_cfa_offset 112
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	vmovss	%xmm1, (%rsp)                   # 4-byte Spill
	vmovss	%xmm0, 48(%rsp)                 # 4-byte Spill
	movq	%r8, %r14
	movq	%rcx, %r15
	movq	%rdx, %r13
	movq	%rsi, %rbp
	movl	%edi, %ebx
	vmovss	%xmm1, 16(%rsp)
	leal	2(%rbx), %eax
	imull	%eax, %eax
	movl	%eax, 8(%rsp)
	movq	%rsi, 32(%rsp)
	movq	%rdx, 24(%rsp)
	subq	$8, %rsp
	.cfi_adjust_cfa_offset 8
	leaq	32(%rsp), %r10
	leaq	.L__unnamed_1(%rip), %rdi
	leaq	add_source.omp_outlined(%rip), %rdx
	leaq	16(%rsp), %rcx
	leaq	40(%rsp), %r12
	leaq	24(%rsp), %r9
	movl	$4, %esi
	movq	%r12, %r8
	xorl	%eax, %eax
	pushq	%r10
	.cfi_adjust_cfa_offset 8
	callq	__kmpc_fork_call@PLT
	addq	$16, %rsp
	.cfi_adjust_cfa_offset -16
	movl	%ebx, %eax
	vcvtsi2ss	%rax, %xmm2, %xmm0
	vmovss	%xmm0, 44(%rsp)                 # 4-byte Spill
	vmulss	%xmm0, %xmm0, %xmm0
	vmovss	48(%rsp), %xmm1                 # 4-byte Reload
                                        # xmm1 = mem[0],zero,zero,zero
	vmulss	(%rsp), %xmm1, %xmm1            # 4-byte Folded Reload
	vmulss	%xmm1, %xmm0, %xmm0
	vmovss	.LCPI0_0(%rip), %xmm1           # xmm1 = [4.0E+0,0.0E+0,0.0E+0,0.0E+0]
	vfmadd213ss	.LCPI0_1(%rip), %xmm0, %xmm1 # xmm1 = (xmm0 * xmm1) + mem
	movl	%ebx, %edi
	xorl	%esi, %esi
	movq	%r13, %rdx
	movq	%rbp, %rcx
	callq	lin_solve
	movl	%ebx, 4(%rsp)
	movq	%rbp, 32(%rsp)
	movq	%r13, 24(%rsp)
	movq	%r15, 16(%rsp)
	movq	%r14, 8(%rsp)
	vmovss	44(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	(%rsp), %xmm0, %xmm0            # 4-byte Folded Reload
	vmovss	%xmm0, 52(%rsp)
	subq	$8, %rsp
	.cfi_adjust_cfa_offset 8
	leaq	.L__unnamed_2(%rip), %rdi
	leaq	advect.omp_outlined(%rip), %rdx
	leaq	12(%rsp), %rcx
	leaq	60(%rsp), %r8
	leaq	24(%rsp), %r9
	movl	$6, %esi
	xorl	%eax, %eax
	leaq	32(%rsp), %r10
	pushq	%r10
	.cfi_adjust_cfa_offset 8
	pushq	%r12
	.cfi_adjust_cfa_offset 8
	leaq	32(%rsp), %r10
	pushq	%r10
	.cfi_adjust_cfa_offset 8
	callq	__kmpc_fork_call@PLT
	addq	$32, %rsp
	.cfi_adjust_cfa_offset -32
	movl	4(%rsp), %edi
	movq	32(%rsp), %rdx
	xorl	%esi, %esi
	callq	set_bnd
	addq	$56, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	dens_step, .Lfunc_end0-dens_step
	.cfi_endproc
                                        # -- End function
	.p2align	4, 0x90                         # -- Begin function add_source.omp_outlined
	.type	add_source.omp_outlined,@function
add_source.omp_outlined:                # @add_source.omp_outlined
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$24, %rsp
	.cfi_def_cfa_offset 80
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%r9, %r14
	movq	%r8, %rbx
	movq	%rcx, %r15
	movq	%rdx, %r12
	movq	%rdi, %r13
	callq	omp_get_thread_num@PLT
	leaq	.L.str(%rip), %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movl	(%r12), %r12d
	movl	(%r13), %ebp
	testl	%r12d, %r12d
	je	.LBB1_10
# %bb.1:
	decl	%r12d
	movl	$0, 12(%rsp)
	movl	%r12d, 8(%rsp)
	movl	$1, 20(%rsp)
	movl	$0, 16(%rsp)
	subq	$8, %rsp
	.cfi_adjust_cfa_offset 8
	leaq	28(%rsp), %rax
	leaq	.L__unnamed_3(%rip), %rdi
	leaq	24(%rsp), %rcx
	leaq	20(%rsp), %r8
	leaq	16(%rsp), %r9
	movl	%ebp, %esi
	movl	$34, %edx
	pushq	$1
	.cfi_adjust_cfa_offset 8
	pushq	$1
	.cfi_adjust_cfa_offset 8
	pushq	%rax
	.cfi_adjust_cfa_offset 8
	callq	__kmpc_for_static_init_4u@PLT
	addq	$32, %rsp
	.cfi_adjust_cfa_offset -32
	movl	8(%rsp), %eax
	cmpl	%r12d, %eax
	cmovbl	%eax, %r12d
	movl	%r12d, 8(%rsp)
	movl	12(%rsp), %r9d
	cmpl	%r9d, %r12d
	jb	.LBB1_9
# %bb.2:
	movq	(%r14), %rax
	movq	(%r15), %rcx
	movl	%r12d, %esi
	subl	%r9d, %esi
	cmpl	$31, %esi
	jae	.LBB1_4
# %bb.3:
	movq	%r9, %rdx
	jmp	.LBB1_7
.LBB1_4:
	incq	%rsi
	movq	%rsi, %rdi
	andq	$-32, %rdi
	leaq	(%rdi,%r9), %rdx
	leaq	(%rax,%r9,4), %r8
	addq	$96, %r8
	leaq	(%rcx,%r9,4), %r9
	addq	$96, %r9
	xorl	%r10d, %r10d
	.p2align	4, 0x90
.LBB1_5:                                # =>This Inner Loop Header: Depth=1
	vbroadcastss	(%rbx), %ymm0
	vmovups	-96(%r8,%r10,4), %ymm1
	vmovups	-64(%r8,%r10,4), %ymm2
	vmovups	-32(%r8,%r10,4), %ymm3
	vmovups	(%r8,%r10,4), %ymm4
	vfmadd213ps	-96(%r9,%r10,4), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vfmadd213ps	-64(%r9,%r10,4), %ymm0, %ymm2 # ymm2 = (ymm0 * ymm2) + mem
	vfmadd213ps	-32(%r9,%r10,4), %ymm0, %ymm3 # ymm3 = (ymm0 * ymm3) + mem
	vfmadd213ps	(%r9,%r10,4), %ymm0, %ymm4 # ymm4 = (ymm0 * ymm4) + mem
	vmovups	%ymm1, -96(%r9,%r10,4)
	vmovups	%ymm2, -64(%r9,%r10,4)
	vmovups	%ymm3, -32(%r9,%r10,4)
	vmovups	%ymm4, (%r9,%r10,4)
	addq	$32, %r10
	cmpq	%r10, %rdi
	jne	.LBB1_5
# %bb.6:
	cmpq	%rdi, %rsi
	je	.LBB1_9
.LBB1_7:
	leaq	(%rax,%rdx,4), %rax
	leaq	(%rcx,%rdx,4), %rcx
	subl	%edx, %r12d
	incl	%r12d
	xorl	%edx, %edx
	.p2align	4, 0x90
.LBB1_8:                                # =>This Inner Loop Header: Depth=1
	vmovss	(%rbx), %xmm0                   # xmm0 = mem[0],zero,zero,zero
	vmovss	(%rax,%rdx,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
	vfmadd213ss	(%rcx,%rdx,4), %xmm0, %xmm1 # xmm1 = (xmm0 * xmm1) + mem
	vmovss	%xmm1, (%rcx,%rdx,4)
	incq	%rdx
	cmpl	%edx, %r12d
	jne	.LBB1_8
.LBB1_9:
	leaq	.L__unnamed_4(%rip), %rdi
	movl	%ebp, %esi
	vzeroupper
	callq	__kmpc_for_static_fini@PLT
.LBB1_10:
	leaq	.L__unnamed_5(%rip), %rdi
	movl	%ebp, %esi
	callq	__kmpc_barrier@PLT
	addq	$24, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	add_source.omp_outlined, .Lfunc_end1-add_source.omp_outlined
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function lin_solve
.LCPI2_0:
	.long	0x3f800000                      # float 1
	.text
	.p2align	4, 0x90
	.type	lin_solve,@function
lin_solve:                              # @lin_solve
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$264, %rsp                      # imm = 0x108
	.cfi_def_cfa_offset 320
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%rcx, %r15
	movq	%rdx, %rbx
	movl	%esi, 80(%rsp)                  # 4-byte Spill
	movl	%edi, %r14d
	leal	1(%r14), %eax
	cmpl	$3, %eax
	movl	$2, %ecx
	cmovael	%eax, %ecx
	movq	%rcx, 136(%rsp)                 # 8-byte Spill
	testl	%edi, %edi
	je	.LBB2_47
# %bb.1:
	leal	2(%r14), %ecx
	movl	%ecx, %r13d
	shrl	%r13d
	leal	-1(%r13), %edx
	testq	%rdx, %rdx
	je	.LBB2_48
# %bb.2:
	vmovaps	%xmm0, %xmm2
	movq	%r14, 144(%rsp)                 # 8-byte Spill
	movl	%r13d, %eax
	imull	%ecx, %eax
	leaq	(%r15,%rax,4), %rbp
	leaq	(%rbx,%rax,4), %r12
	movabsq	$8589934592, %r14               # imm = 0x200000000
	leaq	-1(%rdx), %rax
	andl	$-2, %ecx
	movq	%rcx, 128(%rsp)                 # 8-byte Spill
	movq	%rdx, 40(%rsp)                  # 8-byte Spill
                                        # kill: def $edx killed $edx killed $rdx def $rdx
	andl	$-8, %edx
	movq	%rdx, 88(%rsp)                  # 8-byte Spill
	vbroadcastss	%xmm0, %ymm3
	vmovss	.LCPI2_0(%rip), %xmm0           # xmm0 = [1.0E+0,0.0E+0,0.0E+0,0.0E+0]
	vdivss	%xmm1, %xmm0, %xmm1
	vbroadcastss	%xmm1, %ymm4
	leal	(,%r13,2), %ecx
	movl	%ecx, 84(%rsp)                  # 4-byte Spill
	xorl	%ecx, %ecx
	leaq	1(%r13), %rdx
	movq	%rdx, 112(%rsp)                 # 8-byte Spill
	movq	%rax, 96(%rsp)                  # 8-byte Spill
	shrq	$32, %rax
	movq	%rax, 120(%rsp)                 # 8-byte Spill
	movq	%r13, 104(%rsp)                 # 8-byte Spill
	vmovaps	%xmm2, 176(%rsp)                # 16-byte Spill
	vmovups	%ymm3, 224(%rsp)                # 32-byte Spill
	vmovaps	%xmm1, 160(%rsp)                # 16-byte Spill
	vmovups	%ymm4, 192(%rsp)                # 32-byte Spill
	jmp	.LBB2_4
	.p2align	4, 0x90
.LBB2_3:                                #   in Loop: Header=BB2_4 Depth=1
	movq	144(%rsp), %rdi                 # 8-byte Reload
                                        # kill: def $edi killed $edi killed $rdi
	movl	80(%rsp), %esi                  # 4-byte Reload
	movq	%rbx, %rdx
	vzeroupper
	callq	set_bnd
	vmovups	192(%rsp), %ymm4                # 32-byte Reload
	vmovaps	160(%rsp), %xmm1                # 16-byte Reload
	vmovups	224(%rsp), %ymm3                # 32-byte Reload
	vmovaps	176(%rsp), %xmm2                # 16-byte Reload
	movq	152(%rsp), %rcx                 # 8-byte Reload
	incl	%ecx
	cmpl	$20, %ecx
	je	.LBB2_46
.LBB2_4:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_6 Depth 2
                                        #       Child Loop BB2_14 Depth 3
                                        #       Child Loop BB2_23 Depth 3
                                        #     Child Loop BB2_27 Depth 2
                                        #       Child Loop BB2_35 Depth 3
                                        #       Child Loop BB2_44 Depth 3
	movq	%rcx, 152(%rsp)                 # 8-byte Spill
	movl	$1, %eax
	movq	%rax, 56(%rsp)                  # 8-byte Spill
	xorl	%r9d, %r9d
	movq	112(%rsp), %rax                 # 8-byte Reload
	movq	%rax, 72(%rsp)                  # 8-byte Spill
	xorl	%eax, %eax
	movq	%rax, 32(%rsp)                  # 8-byte Spill
	movl	%r13d, %eax
	movl	%r13d, 12(%rsp)                 # 4-byte Spill
	movl	84(%rsp), %eax                  # 4-byte Reload
                                        # kill: def $eax killed $eax def $rax
	movq	%rax, 24(%rsp)                  # 8-byte Spill
	movq	%r13, 48(%rsp)                  # 8-byte Spill
	movl	$1, %eax
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	xorl	%ecx, %ecx
	jmp	.LBB2_6
	.p2align	4, 0x90
.LBB2_5:                                #   in Loop: Header=BB2_6 Depth=2
	movq	56(%rsp), %rax                  # 8-byte Reload
	incq	%rax
	movq	16(%rsp), %rcx                  # 8-byte Reload
	negl	%ecx
	movq	%rcx, 16(%rsp)                  # 8-byte Spill
	movl	$1, %ecx
	subl	%r11d, %ecx
	movl	68(%rsp), %r9d                  # 4-byte Reload
	incl	%r9d
	movq	104(%rsp), %r13                 # 8-byte Reload
	addq	%r13, 48(%rsp)                  # 8-byte Folded Spill
	movq	24(%rsp), %rdx                  # 8-byte Reload
	addl	%r13d, %edx
	movq	%rdx, 24(%rsp)                  # 8-byte Spill
	addl	%r13d, 12(%rsp)                 # 4-byte Folded Spill
	movq	32(%rsp), %rdx                  # 8-byte Reload
	addl	%r13d, %edx
	movq	%rdx, 32(%rsp)                  # 8-byte Spill
	addq	%r13, 72(%rsp)                  # 8-byte Folded Spill
	movq	%rax, 56(%rsp)                  # 8-byte Spill
	cmpq	136(%rsp), %rax                 # 8-byte Folded Reload
	je	.LBB2_25
.LBB2_6:                                #   Parent Loop BB2_4 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_14 Depth 3
                                        #       Child Loop BB2_23 Depth 3
	movl	%ecx, %r11d
	cmpl	$16, 40(%rsp)                   # 4-byte Folded Reload
	movl	%r9d, 68(%rsp)                  # 4-byte Spill
	jae	.LBB2_8
.LBB2_7:                                #   in Loop: Header=BB2_6 Depth=2
	xorl	%ecx, %ecx
	movq	%rcx, %r13
	testb	$1, 40(%rsp)                    # 1-byte Folded Reload
	jne	.LBB2_20
	jmp	.LBB2_21
	.p2align	4, 0x90
.LBB2_8:                                #   in Loop: Header=BB2_6 Depth=2
	movl	%r13d, %ecx
	imull	%r9d, %ecx
	leal	(%r11,%rcx), %edx
	movq	96(%rsp), %r8                   # 8-byte Reload
	addl	%r8d, %edx
	setb	%dl
	movq	128(%rsp), %rax                 # 8-byte Reload
	leal	(%r11,%rax), %esi
	addl	%ecx, %esi
	addl	%r8d, %esi
	jb	.LBB2_7
# %bb.9:                                #   in Loop: Header=BB2_6 Depth=2
	addl	%r11d, %ecx
	addl	%r13d, %ecx
	movq	16(%rsp), %rax                  # 8-byte Reload
	leal	(%rcx,%rax), %esi
	leal	(%rsi,%r8), %edi
	cmpl	%esi, %edi
	jl	.LBB2_7
# %bb.10:                               #   in Loop: Header=BB2_6 Depth=2
	leal	(%rcx,%r8), %esi
	cmpl	%ecx, %esi
	jl	.LBB2_18
# %bb.11:                               #   in Loop: Header=BB2_6 Depth=2
	testb	%dl, %dl
	jne	.LBB2_7
# %bb.12:                               #   in Loop: Header=BB2_6 Depth=2
	movl	$0, %ecx
	cmpq	$0, 120(%rsp)                   # 8-byte Folded Reload
	jne	.LBB2_19
# %bb.13:                               #   in Loop: Header=BB2_6 Depth=2
	movq	48(%rsp), %rax                  # 8-byte Reload
	leal	(%rax,%r11), %ecx
	shlq	$32, %rcx
	movq	24(%rsp), %rax                  # 8-byte Reload
	leal	(%r11,%rax), %edx
	movq	16(%rsp), %rax                  # 8-byte Reload
	leal	(%r11,%rax), %esi
	addl	12(%rsp), %esi                  # 4-byte Folded Reload
	movq	32(%rsp), %rax                  # 8-byte Reload
	leal	(%r11,%rax), %edi
	movq	88(%rsp), %r8                   # 8-byte Reload
	movabsq	$34359738368, %rax              # imm = 0x800000000
	.p2align	4, 0x90
.LBB2_14:                               #   Parent Loop BB2_4 Depth=1
                                        #     Parent Loop BB2_6 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movq	%rcx, %r9
	sarq	$30, %r9
	movl	%edi, %r13d
	vmovups	(%r12,%r9), %ymm0
	vaddps	(%r12,%r13,4), %ymm0, %ymm0
	movslq	%esi, %rsi
	vaddps	(%r12,%rsi,4), %ymm0, %ymm0
	movl	%edx, %r13d
	vaddps	(%r12,%r13,4), %ymm0, %ymm0
	vfmadd213ps	(%r15,%r9), %ymm3, %ymm0 # ymm0 = (ymm3 * ymm0) + mem
	vmulps	%ymm4, %ymm0, %ymm0
	vmovups	%ymm0, (%rbx,%r9)
	addq	%rax, %rcx
	addl	$8, %edx
	addl	$8, %esi
	addl	$8, %edi
	addq	$-8, %r8
	jne	.LBB2_14
# %bb.15:                               #   in Loop: Header=BB2_6 Depth=2
	movq	88(%rsp), %rax                  # 8-byte Reload
	movq	%rax, %rcx
	cmpq	40(%rsp), %rax                  # 8-byte Folded Reload
	je	.LBB2_5
	.p2align	4, 0x90
.LBB2_19:                               #   in Loop: Header=BB2_6 Depth=2
	movq	%rcx, %r13
	testb	$1, 40(%rsp)                    # 1-byte Folded Reload
	je	.LBB2_21
.LBB2_20:                               #   in Loop: Header=BB2_6 Depth=2
	movq	56(%rsp), %rdx                  # 8-byte Reload
	movq	104(%rsp), %rax                 # 8-byte Reload
	imulq	%rax, %rdx
	addq	%r11, %rdx
	addq	%rcx, %rdx
	movslq	%edx, %rdx
	movl	%edx, %esi
	subl	%eax, %esi
	vmovss	(%r12,%rdx,4), %xmm0            # xmm0 = mem[0],zero,zero,zero
	vaddss	(%r12,%rsi,4), %xmm0, %xmm0
	movq	16(%rsp), %rsi                  # 8-byte Reload
	addl	%edx, %esi
	movslq	%esi, %rsi
	vaddss	(%r12,%rsi,4), %xmm0, %xmm0
	leal	(%rax,%rdx), %esi
	vaddss	(%r12,%rsi,4), %xmm0, %xmm0
	vfmadd213ss	(%r15,%rdx,4), %xmm2, %xmm0 # xmm0 = (xmm2 * xmm0) + mem
	vmulss	%xmm1, %xmm0, %xmm0
	vmovss	%xmm0, (%rbx,%rdx,4)
	movq	%rcx, %r13
	orq	$1, %r13
.LBB2_21:                               #   in Loop: Header=BB2_6 Depth=2
	cmpq	96(%rsp), %rcx                  # 8-byte Folded Reload
	je	.LBB2_5
# %bb.22:                               #   in Loop: Header=BB2_6 Depth=2
	movq	40(%rsp), %rcx                  # 8-byte Reload
	subq	%r13, %rcx
	movq	48(%rsp), %rax                  # 8-byte Reload
	addl	%r11d, %eax
	addl	%r13d, %eax
	shlq	$32, %rax
	movq	24(%rsp), %rdx                  # 8-byte Reload
	leal	(%r11,%rdx), %esi
	addl	%r13d, %esi
	movq	16(%rsp), %rdx                  # 8-byte Reload
	leal	(%rdx,%r11), %edi
	addl	12(%rsp), %edi                  # 4-byte Folded Reload
	addl	%r13d, %edi
	movq	32(%rsp), %rdx                  # 8-byte Reload
	leal	(%r11,%rdx), %r8d
	addl	%r13d, %r8d
	movq	72(%rsp), %rdx                  # 8-byte Reload
	leal	(%rdx,%r11), %r9d
	addl	%r13d, %r9d
	shlq	$32, %r9
	xorl	%r13d, %r13d
	.p2align	4, 0x90
.LBB2_23:                               #   Parent Loop BB2_4 Depth=1
                                        #     Parent Loop BB2_6 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movq	%rax, %rdx
	sarq	$30, %rdx
	leal	(%r8,%r13), %r10d
	vmovss	(%r12,%rdx), %xmm0              # xmm0 = mem[0],zero,zero,zero
	vaddss	(%r12,%r10,4), %xmm0, %xmm0
	leal	(%rdi,%r13), %r10d
	movslq	%r10d, %r10
	vaddss	(%r12,%r10,4), %xmm0, %xmm0
	leal	(%rsi,%r13), %r10d
	vaddss	(%r12,%r10,4), %xmm0, %xmm0
	vfmadd213ss	(%r15,%rdx), %xmm2, %xmm0 # xmm0 = (xmm2 * xmm0) + mem
	vmulss	%xmm1, %xmm0, %xmm0
	vmovss	%xmm0, (%rbx,%rdx)
	movq	%r9, %rdx
	sarq	$30, %rdx
	leal	(%r8,%r13), %r10d
	incl	%r10d
	vmovss	(%r12,%rdx), %xmm0              # xmm0 = mem[0],zero,zero,zero
	vaddss	(%r12,%r10,4), %xmm0, %xmm0
	leal	1(%rdi,%r13), %r10d
	movslq	%r10d, %r10
	vaddss	(%r12,%r10,4), %xmm0, %xmm0
	leal	1(%rsi,%r13), %r10d
	vaddss	(%r12,%r10,4), %xmm0, %xmm0
	vfmadd213ss	(%r15,%rdx), %xmm2, %xmm0 # xmm0 = (xmm2 * xmm0) + mem
	vmulss	%xmm1, %xmm0, %xmm0
	vmovss	%xmm0, (%rbx,%rdx)
	addq	$2, %r13
	addq	%r14, %rax
	addq	%r14, %r9
	cmpq	%r13, %rcx
	jne	.LBB2_23
	jmp	.LBB2_5
.LBB2_18:                               #   in Loop: Header=BB2_6 Depth=2
	xorl	%ecx, %ecx
	movq	%rcx, %r13
	testb	$1, 40(%rsp)                    # 1-byte Folded Reload
	je	.LBB2_21
	jmp	.LBB2_20
	.p2align	4, 0x90
.LBB2_25:                               #   in Loop: Header=BB2_4 Depth=1
	movl	$1, %edx
	movl	$-1, %eax
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	movl	$1, %eax
	movq	%rax, 56(%rsp)                  # 8-byte Spill
	xorl	%r9d, %r9d
	movq	112(%rsp), %rax                 # 8-byte Reload
	movq	%rax, 72(%rsp)                  # 8-byte Spill
	xorl	%eax, %eax
	movq	%rax, 32(%rsp)                  # 8-byte Spill
	movl	%r13d, %eax
	movl	%r13d, 12(%rsp)                 # 4-byte Spill
	movl	84(%rsp), %eax                  # 4-byte Reload
                                        # kill: def $eax killed $eax def $rax
	movq	%rax, 24(%rsp)                  # 8-byte Spill
	movq	%r13, 48(%rsp)                  # 8-byte Spill
	jmp	.LBB2_27
	.p2align	4, 0x90
.LBB2_26:                               #   in Loop: Header=BB2_27 Depth=2
	movq	56(%rsp), %rcx                  # 8-byte Reload
	incq	%rcx
	movq	16(%rsp), %rax                  # 8-byte Reload
	negl	%eax
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	movl	$1, %edx
	subl	%r11d, %edx
	movl	68(%rsp), %r9d                  # 4-byte Reload
	incl	%r9d
	movq	104(%rsp), %r13                 # 8-byte Reload
	addq	%r13, 48(%rsp)                  # 8-byte Folded Spill
	movq	24(%rsp), %rax                  # 8-byte Reload
	addl	%r13d, %eax
	movq	%rax, 24(%rsp)                  # 8-byte Spill
	addl	%r13d, 12(%rsp)                 # 4-byte Folded Spill
	movq	32(%rsp), %rax                  # 8-byte Reload
	addl	%r13d, %eax
	movq	%rax, 32(%rsp)                  # 8-byte Spill
	addq	%r13, 72(%rsp)                  # 8-byte Folded Spill
	movq	%rcx, 56(%rsp)                  # 8-byte Spill
	cmpq	136(%rsp), %rcx                 # 8-byte Folded Reload
	je	.LBB2_3
.LBB2_27:                               #   Parent Loop BB2_4 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_35 Depth 3
                                        #       Child Loop BB2_44 Depth 3
	movl	%edx, %r11d
	cmpl	$16, 40(%rsp)                   # 4-byte Folded Reload
	movl	%r9d, 68(%rsp)                  # 4-byte Spill
	jae	.LBB2_29
.LBB2_28:                               #   in Loop: Header=BB2_27 Depth=2
	xorl	%edx, %edx
	movq	%rdx, %r13
	testb	$1, 40(%rsp)                    # 1-byte Folded Reload
	jne	.LBB2_41
	jmp	.LBB2_42
	.p2align	4, 0x90
.LBB2_29:                               #   in Loop: Header=BB2_27 Depth=2
	movl	%r13d, %edx
	imull	%r9d, %edx
	leal	(%r11,%rdx), %esi
	movq	96(%rsp), %rcx                  # 8-byte Reload
	addl	%ecx, %esi
	setb	%sil
	movq	128(%rsp), %rax                 # 8-byte Reload
	leal	(%r11,%rax), %edi
	addl	%edx, %edi
	addl	%ecx, %edi
	jb	.LBB2_28
# %bb.30:                               #   in Loop: Header=BB2_27 Depth=2
	addl	%r11d, %edx
	addl	%r13d, %edx
	movq	16(%rsp), %rax                  # 8-byte Reload
	leal	(%rdx,%rax), %edi
	leal	(%rdi,%rcx), %r8d
	cmpl	%edi, %r8d
	jl	.LBB2_28
# %bb.31:                               #   in Loop: Header=BB2_27 Depth=2
	leal	(%rdx,%rcx), %edi
	cmpl	%edx, %edi
	jl	.LBB2_39
# %bb.32:                               #   in Loop: Header=BB2_27 Depth=2
	testb	%sil, %sil
	jne	.LBB2_28
# %bb.33:                               #   in Loop: Header=BB2_27 Depth=2
	movl	$0, %edx
	cmpq	$0, 120(%rsp)                   # 8-byte Folded Reload
	jne	.LBB2_40
# %bb.34:                               #   in Loop: Header=BB2_27 Depth=2
	movq	48(%rsp), %rax                  # 8-byte Reload
	leal	(%rax,%r11), %edx
	shlq	$32, %rdx
	movq	24(%rsp), %rax                  # 8-byte Reload
	leal	(%r11,%rax), %esi
	movq	16(%rsp), %rax                  # 8-byte Reload
	leal	(%r11,%rax), %edi
	addl	12(%rsp), %edi                  # 4-byte Folded Reload
	movq	32(%rsp), %rax                  # 8-byte Reload
	leal	(%r11,%rax), %r8d
	movq	88(%rsp), %r9                   # 8-byte Reload
	movabsq	$34359738368, %rax              # imm = 0x800000000
	.p2align	4, 0x90
.LBB2_35:                               #   Parent Loop BB2_4 Depth=1
                                        #     Parent Loop BB2_27 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movq	%rdx, %r10
	sarq	$30, %r10
	movl	%r8d, %r13d
	vmovups	(%rbx,%r10), %ymm0
	vaddps	(%rbx,%r13,4), %ymm0, %ymm0
	movslq	%edi, %rdi
	vaddps	(%rbx,%rdi,4), %ymm0, %ymm0
	movl	%esi, %r13d
	vaddps	(%rbx,%r13,4), %ymm0, %ymm0
	vfmadd213ps	(%rbp,%r10), %ymm3, %ymm0 # ymm0 = (ymm3 * ymm0) + mem
	vmulps	%ymm4, %ymm0, %ymm0
	vmovups	%ymm0, (%r12,%r10)
	addq	%rax, %rdx
	addl	$8, %esi
	addl	$8, %edi
	addl	$8, %r8d
	addq	$-8, %r9
	jne	.LBB2_35
# %bb.36:                               #   in Loop: Header=BB2_27 Depth=2
	movq	88(%rsp), %rax                  # 8-byte Reload
	movq	%rax, %rdx
	cmpq	40(%rsp), %rax                  # 8-byte Folded Reload
	je	.LBB2_26
	.p2align	4, 0x90
.LBB2_40:                               #   in Loop: Header=BB2_27 Depth=2
	movq	%rdx, %r13
	testb	$1, 40(%rsp)                    # 1-byte Folded Reload
	je	.LBB2_42
.LBB2_41:                               #   in Loop: Header=BB2_27 Depth=2
	movq	56(%rsp), %rsi                  # 8-byte Reload
	movq	104(%rsp), %rax                 # 8-byte Reload
	imulq	%rax, %rsi
	addq	%r11, %rsi
	addq	%rdx, %rsi
	movslq	%esi, %rsi
	movl	%esi, %edi
	subl	%eax, %edi
	vmovss	(%rbx,%rsi,4), %xmm0            # xmm0 = mem[0],zero,zero,zero
	vaddss	(%rbx,%rdi,4), %xmm0, %xmm0
	movq	16(%rsp), %rcx                  # 8-byte Reload
	leal	(%rcx,%rsi), %edi
	movslq	%edi, %rdi
	vaddss	(%rbx,%rdi,4), %xmm0, %xmm0
	leal	(%rax,%rsi), %edi
	vaddss	(%rbx,%rdi,4), %xmm0, %xmm0
	vfmadd213ss	(%rbp,%rsi,4), %xmm2, %xmm0 # xmm0 = (xmm2 * xmm0) + mem
	vmulss	%xmm1, %xmm0, %xmm0
	vmovss	%xmm0, (%r12,%rsi,4)
	movq	%rdx, %r13
	orq	$1, %r13
.LBB2_42:                               #   in Loop: Header=BB2_27 Depth=2
	cmpq	96(%rsp), %rdx                  # 8-byte Folded Reload
	je	.LBB2_26
# %bb.43:                               #   in Loop: Header=BB2_27 Depth=2
	movq	40(%rsp), %rdx                  # 8-byte Reload
	subq	%r13, %rdx
	movq	48(%rsp), %rax                  # 8-byte Reload
	addl	%r11d, %eax
	addl	%r13d, %eax
	shlq	$32, %rax
	movq	24(%rsp), %rcx                  # 8-byte Reload
	leal	(%r11,%rcx), %edi
	addl	%r13d, %edi
	movq	16(%rsp), %rcx                  # 8-byte Reload
	leal	(%rcx,%r11), %r8d
	addl	12(%rsp), %r8d                  # 4-byte Folded Reload
	addl	%r13d, %r8d
	movq	32(%rsp), %rcx                  # 8-byte Reload
	leal	(%r11,%rcx), %r9d
	addl	%r13d, %r9d
	movq	72(%rsp), %rcx                  # 8-byte Reload
	leal	(%rcx,%r11), %r10d
	addl	%r13d, %r10d
	shlq	$32, %r10
	xorl	%r13d, %r13d
	.p2align	4, 0x90
.LBB2_44:                               #   Parent Loop BB2_4 Depth=1
                                        #     Parent Loop BB2_27 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movq	%rax, %rsi
	sarq	$30, %rsi
	leal	(%r9,%r13), %ecx
	vmovss	(%rbx,%rsi), %xmm0              # xmm0 = mem[0],zero,zero,zero
	vaddss	(%rbx,%rcx,4), %xmm0, %xmm0
	leal	(%r8,%r13), %ecx
	movslq	%ecx, %rcx
	vaddss	(%rbx,%rcx,4), %xmm0, %xmm0
	leal	(%rdi,%r13), %ecx
	vaddss	(%rbx,%rcx,4), %xmm0, %xmm0
	vfmadd213ss	(%rbp,%rsi), %xmm2, %xmm0 # xmm0 = (xmm2 * xmm0) + mem
	vmulss	%xmm1, %xmm0, %xmm0
	vmovss	%xmm0, (%r12,%rsi)
	movq	%r10, %rcx
	sarq	$30, %rcx
	leal	(%r9,%r13), %esi
	incl	%esi
	vmovss	(%rbx,%rcx), %xmm0              # xmm0 = mem[0],zero,zero,zero
	vaddss	(%rbx,%rsi,4), %xmm0, %xmm0
	leal	1(%r8,%r13), %esi
	movslq	%esi, %rsi
	vaddss	(%rbx,%rsi,4), %xmm0, %xmm0
	leal	1(%rdi,%r13), %esi
	vaddss	(%rbx,%rsi,4), %xmm0, %xmm0
	vfmadd213ss	(%rbp,%rcx), %xmm2, %xmm0 # xmm0 = (xmm2 * xmm0) + mem
	vmulss	%xmm1, %xmm0, %xmm0
	vmovss	%xmm0, (%r12,%rcx)
	addq	$2, %r13
	addq	%r14, %rax
	addq	%r14, %r10
	cmpq	%r13, %rdx
	jne	.LBB2_44
	jmp	.LBB2_26
.LBB2_39:                               #   in Loop: Header=BB2_27 Depth=2
	xorl	%edx, %edx
	movq	%rdx, %r13
	testb	$1, 40(%rsp)                    # 1-byte Folded Reload
	je	.LBB2_42
	jmp	.LBB2_41
.LBB2_46:
	addq	$264, %rsp                      # imm = 0x108
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	vzeroupper
	retq
.LBB2_47:
	.cfi_def_cfa_offset 320
	xorl	%r14d, %r14d
.LBB2_48:
	movl	%r14d, %edi
	movl	80(%rsp), %ebp                  # 4-byte Reload
	movl	%ebp, %esi
	movq	%rbx, %rdx
	callq	set_bnd
	movl	%r14d, %edi
	movl	%ebp, %esi
	movq	%rbx, %rdx
	callq	set_bnd
	movl	%r14d, %edi
	movl	%ebp, %esi
	movq	%rbx, %rdx
	callq	set_bnd
	movl	%r14d, %edi
	movl	%ebp, %esi
	movq	%rbx, %rdx
	callq	set_bnd
	movl	%r14d, %edi
	movl	%ebp, %esi
	movq	%rbx, %rdx
	callq	set_bnd
	movl	%r14d, %edi
	movl	%ebp, %esi
	movq	%rbx, %rdx
	callq	set_bnd
	movl	%r14d, %edi
	movl	%ebp, %esi
	movq	%rbx, %rdx
	callq	set_bnd
	movl	%r14d, %edi
	movl	%ebp, %esi
	movq	%rbx, %rdx
	callq	set_bnd
	movl	%r14d, %edi
	movl	%ebp, %esi
	movq	%rbx, %rdx
	callq	set_bnd
	movl	%r14d, %edi
	movl	%ebp, %esi
	movq	%rbx, %rdx
	callq	set_bnd
	movl	%r14d, %edi
	movl	%ebp, %esi
	movq	%rbx, %rdx
	callq	set_bnd
	movl	%r14d, %edi
	movl	%ebp, %esi
	movq	%rbx, %rdx
	callq	set_bnd
	movl	%r14d, %edi
	movl	%ebp, %esi
	movq	%rbx, %rdx
	callq	set_bnd
	movl	%r14d, %edi
	movl	%ebp, %esi
	movq	%rbx, %rdx
	callq	set_bnd
	movl	%r14d, %edi
	movl	%ebp, %esi
	movq	%rbx, %rdx
	callq	set_bnd
	movl	%r14d, %edi
	movl	%ebp, %esi
	movq	%rbx, %rdx
	callq	set_bnd
	movl	%r14d, %edi
	movl	%ebp, %esi
	movq	%rbx, %rdx
	callq	set_bnd
	movl	%r14d, %edi
	movl	%ebp, %esi
	movq	%rbx, %rdx
	callq	set_bnd
	movl	%r14d, %edi
	movl	%ebp, %esi
	movq	%rbx, %rdx
	callq	set_bnd
	movl	%r14d, %edi
	movl	%ebp, %esi
	movq	%rbx, %rdx
	addq	$264, %rsp                      # imm = 0x108
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	jmp	set_bnd                         # TAILCALL
.Lfunc_end2:
	.size	lin_solve, .Lfunc_end2-lin_solve
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0                          # -- Begin function set_bnd
.LCPI3_0:
	.quad	5                               # 0x5
	.quad	6                               # 0x6
	.quad	7                               # 0x7
	.quad	8                               # 0x8
.LCPI3_1:
	.quad	1                               # 0x1
	.quad	2                               # 0x2
	.quad	3                               # 0x3
	.quad	4                               # 0x4
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI3_2:
	.quad	1                               # 0x1
.LCPI3_4:
	.quad	8                               # 0x8
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI3_3:
	.long	0x80000000                      # float -0
.LCPI3_5:
	.long	0x3f000000                      # float 0.5
	.text
	.p2align	4, 0x90
	.type	set_bnd,@function
set_bnd:                                # @set_bnd
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$568, %rsp                      # imm = 0x238
	.cfi_def_cfa_offset 624
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
                                        # kill: def $edi killed $edi def $rdi
	leal	1(%rdi), %eax
	movl	%edi, %r10d
	shrl	%r10d
	movl	%edi, %r11d
	addl	$2, %edi
	movl	%edi, %r8d
	shrl	%r8d
	cmpl	$1, %eax
	jbe	.LBB3_1
# %bb.2:
	movq	%r10, -32(%rsp)                 # 8-byte Spill
	leaq	(%rdx,%r10,4), %rbp
	movl	%eax, %ebx
	movl	%eax, %ecx
	shrl	%ecx
	movq	%rcx, -40(%rsp)                 # 8-byte Spill
	leaq	(%rdx,%rcx,4), %r14
	leaq	1(%rdi), %rcx
	movq	%rcx, -112(%rsp)                # 8-byte Spill
	movl	$1, %r15d
	cmpl	$9, %eax
	jb	.LBB3_44
# %bb.3:
	leaq	-1(%rbx), %r12
	cmpl	$2, %esi
	sete	%al
	cmpl	$1, %esi
	sete	%r10b
	movq	%r12, -16(%rsp)                 # 8-byte Spill
	andq	$-8, %r12
	leaq	1(%r12), %r15
	vmovq	%rdi, %xmm0
	vpbroadcastq	%xmm0, %ymm0
	vmovdqu	%ymm0, 48(%rsp)                 # 32-byte Spill
	vmovq	%r8, %xmm0
	vpbroadcastq	%xmm0, %ymm1
	vmovd	%r10d, %xmm0
	vpbroadcastb	%xmm0, %xmm2
	vmovq	%r11, %xmm0
	vpbroadcastq	%xmm0, %ymm0
	vmovdqu	%ymm0, 240(%rsp)                # 32-byte Spill
	vmovq	%rbx, %xmm0
	vpbroadcastq	%xmm0, %ymm0
	vmovdqu	%ymm0, 208(%rsp)                # 32-byte Spill
	vmovsd	-112(%rsp), %xmm0               # 8-byte Reload
                                        # xmm0 = mem[0],zero
	vbroadcastsd	%xmm0, %ymm0
	vmovups	%ymm0, 336(%rsp)                # 32-byte Spill
	vmovd	%eax, %xmm0
	vpbroadcastb	%xmm0, %xmm3
	vpcmpeqd	%xmm0, %xmm0, %xmm0
	vpxor	%xmm0, %xmm2, %xmm4
	vpextrb	$2, %xmm4, %eax
	movl	%eax, -44(%rsp)                 # 4-byte Spill
	vpextrb	$4, %xmm4, %eax
	movl	%eax, -48(%rsp)                 # 4-byte Spill
	vpextrb	$6, %xmm4, %eax
	movl	%eax, -52(%rsp)                 # 4-byte Spill
	vpextrb	$8, %xmm4, %eax
	movl	%eax, -56(%rsp)                 # 4-byte Spill
	vpextrb	$10, %xmm4, %eax
	movl	%eax, -60(%rsp)                 # 4-byte Spill
	vmovd	%xmm4, -64(%rsp)                # 4-byte Folded Spill
	vpextrb	$12, %xmm4, %eax
	movl	%eax, -68(%rsp)                 # 4-byte Spill
	vmovdqa	%xmm4, 96(%rsp)                 # 16-byte Spill
	vpextrb	$14, %xmm4, %eax
	movl	%eax, -72(%rsp)                 # 4-byte Spill
	vmovdqa	%xmm3, 112(%rsp)                # 16-byte Spill
	vpxor	%xmm0, %xmm3, %xmm3
	vpextrb	$2, %xmm3, %eax
	movl	%eax, -76(%rsp)                 # 4-byte Spill
	vpextrb	$4, %xmm3, %eax
	movl	%eax, -80(%rsp)                 # 4-byte Spill
	vpextrb	$6, %xmm3, %eax
	movl	%eax, -84(%rsp)                 # 4-byte Spill
	vmovd	%xmm3, -88(%rsp)                # 4-byte Folded Spill
	vmovdqa	.LCPI3_0(%rip), %ymm9           # ymm9 = [5,6,7,8]
	vmovdqa	.LCPI3_1(%rip), %ymm10          # ymm10 = [1,2,3,4]
	vbroadcastsd	.LCPI3_2(%rip), %ymm0   # ymm0 = [1,1,1,1]
	vmovups	%ymm0, 176(%rsp)                # 32-byte Spill
	vpbroadcastd	.LCPI3_3(%rip), %ymm0   # ymm0 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
	vmovdqu	%ymm0, 16(%rsp)                 # 32-byte Spill
	vmovdqa	%xmm2, 128(%rsp)                # 16-byte Spill
	vpunpckhwd	%xmm2, %xmm2, %xmm0     # xmm0 = xmm2[4,4,5,5,6,6,7,7]
	vpslld	$31, %xmm0, %xmm0
	vpmovsxdq	%xmm0, %ymm0
	vmovdqu	%ymm0, 304(%rsp)                # 32-byte Spill
	vpbroadcastq	.LCPI3_4(%rip), %ymm0   # ymm0 = [8,8,8,8]
	vmovdqu	%ymm0, 272(%rsp)                # 32-byte Spill
	vpextrb	$8, %xmm3, %eax
	movl	%eax, -92(%rsp)                 # 4-byte Spill
	vpextrb	$10, %xmm3, %eax
	movl	%eax, -96(%rsp)                 # 4-byte Spill
	vpextrb	$12, %xmm3, %eax
	movl	%eax, -100(%rsp)                # 4-byte Spill
	vmovdqa	%xmm3, 80(%rsp)                 # 16-byte Spill
	vpextrb	$14, %xmm3, %eax
	movl	%eax, -104(%rsp)                # 4-byte Spill
	movq	%r12, -24(%rsp)                 # 8-byte Spill
	movq	%r11, 8(%rsp)                   # 8-byte Spill
	movq	%rdi, (%rsp)                    # 8-byte Spill
	movl	%esi, -116(%rsp)                # 4-byte Spill
	movq	%rbp, -8(%rsp)                  # 8-byte Spill
	movq	(%rsp), %rdi                    # 8-byte Reload
	jmp	.LBB3_4
	.p2align	4, 0x90
.LBB3_40:                               #   in Loop: Header=BB3_4 Depth=1
	vpmovzxwd	112(%rsp), %ymm0        # 16-byte Folded Reload
                                        # ymm0 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpslld	$31, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm5
	vpxor	%xmm11, %xmm11, %xmm11
	vgatherqps	%xmm5, (,%ymm8), %xmm11
	vmovdqa	%xmm0, %xmm5
	vxorps	%xmm8, %xmm8, %xmm8
	vgatherqps	%xmm5, (,%ymm7), %xmm8
	vinsertf128	$1, %xmm11, %ymm8, %ymm5
	vxorps	16(%rsp), %ymm5, %ymm5          # 32-byte Folded Reload
	vblendvps	%ymm0, %ymm5, %ymm2, %ymm2
	vmovdqu	208(%rsp), %ymm5                # 32-byte Reload
	vpaddq	400(%rsp), %ymm5, %ymm0         # 32-byte Folded Reload
	vpaddq	496(%rsp), %ymm5, %ymm5         # 32-byte Folded Reload
	vpmuludq	%ymm1, %ymm5, %ymm7
	vpsrlq	$32, %ymm5, %ymm5
	vpmuludq	%ymm1, %ymm5, %ymm5
	vpsllq	$32, %ymm5, %ymm5
	vpaddq	%ymm5, %ymm7, %ymm5
	vpmuludq	%ymm1, %ymm0, %ymm7
	vpsrlq	$32, %ymm0, %ymm0
	vpmuludq	%ymm1, %ymm0, %ymm0
	vpsllq	$32, %ymm0, %ymm0
	vpaddq	%ymm0, %ymm7, %ymm0
	vmovq	%xmm0, %rcx
	vpextrq	$1, %xmm0, %rax
	vextracti128	$1, %ymm0, %xmm0
	vpextrq	$1, %xmm0, %r13
	vmovq	%xmm0, %r9
	vmovq	%xmm3, %r10
	vpextrq	$1, %xmm3, %r11
	vpextrq	$1, %xmm13, %rbp
	vmovq	%xmm13, %rbx
	leaq	(%rdx,%rcx,4), %rcx
	vmovss	%xmm2, (%rcx,%r10,4)
	leaq	(%rdx,%rax,4), %rax
	leaq	(%rdx,%r9,4), %rcx
	vextractps	$1, %xmm2, (%rax,%r11,4)
	vmovq	%xmm5, %rax
	vpextrq	$1, %xmm5, %r9
	vextracti128	$1, %ymm5, %xmm0
	vextractps	$2, %xmm2, (%rcx,%rbx,4)
	vpextrq	$1, %xmm0, %rcx
	vmovq	%xmm0, %r10
	leaq	(%rdx,%r13,4), %r11
	vextractps	$3, %xmm2, (%r11,%rbp,4)
	vmovq	%xmm6, %r11
	vpextrq	$1, %xmm6, %rbx
	leaq	(%rdx,%rax,4), %rax
	vextractf128	$1, %ymm2, %xmm0
	vmovss	%xmm0, (%rax,%r11,4)
	leaq	(%rdx,%r9,4), %rax
	vextractps	$1, %xmm0, (%rax,%rbx,4)
	vpextrq	$1, %xmm4, %rax
	vmovq	%xmm4, %r9
	leaq	(%rdx,%r10,4), %r10
	vextractps	$2, %xmm0, (%r10,%r9,4)
	leaq	(%rdx,%rcx,4), %rcx
	vextractps	$3, %xmm0, (%rcx,%rax,4)
	vmovdqu	272(%rsp), %ymm0                # 32-byte Reload
	vpaddq	%ymm0, %ymm10, %ymm10
	vpaddq	%ymm0, %ymm9, %ymm9
	addq	$-8, %r12
	movq	8(%rsp), %r11                   # 8-byte Reload
	movq	%rsi, %rbx
	movl	-116(%rsp), %esi                # 4-byte Reload
	movq	-8(%rsp), %rbp                  # 8-byte Reload
	je	.LBB3_41
.LBB3_4:                                # =>This Inner Loop Header: Depth=1
	vmovdqu	176(%rsp), %ymm0                # 32-byte Reload
	vpand	%ymm0, %ymm10, %ymm4
	vpand	%ymm0, %ymm9, %ymm2
	vpxor	%xmm7, %xmm7, %xmm7
	vpcmpeqq	%ymm7, %ymm2, %ymm3
	vmovdqu	48(%rsp), %ymm8                 # 32-byte Reload
	vpand	%ymm3, %ymm8, %ymm0
	vpaddq	%ymm0, %ymm9, %ymm0
	vpmuludq	%ymm1, %ymm0, %ymm5
	vpsrlq	$32, %ymm0, %ymm0
	vpmuludq	%ymm1, %ymm0, %ymm0
	vpsllq	$32, %ymm0, %ymm0
	vpaddq	%ymm0, %ymm5, %ymm0
	vpcmpeqd	%xmm5, %xmm5, %xmm5
	vxorps	%xmm6, %xmm6, %xmm6
	vgatherqps	%xmm5, (%rdx,%ymm0,4), %xmm6
	vpcmpeqq	%ymm7, %ymm4, %ymm13
	vpand	%ymm8, %ymm13, %ymm0
	vpaddq	%ymm0, %ymm10, %ymm0
	vpmuludq	%ymm1, %ymm0, %ymm5
	vpsrlq	$32, %ymm0, %ymm0
	vpmuludq	%ymm1, %ymm0, %ymm0
	vpsllq	$32, %ymm0, %ymm0
	vpaddq	%ymm0, %ymm5, %ymm0
	vpcmpeqd	%xmm5, %xmm5, %xmm5
	vpxor	%xmm7, %xmm7, %xmm7
	vgatherqps	%xmm5, (%rdx,%ymm0,4), %xmm7
	vinsertf128	$1, %xmm6, %ymm7, %ymm6
	vpandn	%ymm8, %ymm13, %ymm0
	vmovdqu	%ymm0, 144(%rsp)                # 32-byte Spill
	vpaddq	%ymm0, %ymm10, %ymm0
	vpmuludq	%ymm1, %ymm0, %ymm5
	vpsrlq	$32, %ymm0, %ymm0
	vpmuludq	%ymm1, %ymm0, %ymm0
	vpsllq	$32, %ymm0, %ymm0
	vpaddq	%ymm0, %ymm5, %ymm5
	testb	$1, -64(%rsp)                   # 1-byte Folded Reload
	jne	.LBB3_5
# %bb.6:                                #   in Loop: Header=BB3_4 Depth=1
	testb	$1, -44(%rsp)                   # 1-byte Folded Reload
	jne	.LBB3_7
.LBB3_8:                                #   in Loop: Header=BB3_4 Depth=1
	vextracti128	$1, %ymm5, %xmm0
	testb	$1, -48(%rsp)                   # 1-byte Folded Reload
	jne	.LBB3_9
.LBB3_10:                               #   in Loop: Header=BB3_4 Depth=1
	testb	$1, -52(%rsp)                   # 1-byte Folded Reload
	je	.LBB3_12
.LBB3_11:                               #   in Loop: Header=BB3_4 Depth=1
	vpextrq	$1, %xmm0, %rax
	vextractps	$3, %xmm6, (%rdx,%rax,4)
.LBB3_12:                               #   in Loop: Header=BB3_4 Depth=1
	vpandn	48(%rsp), %ymm3, %ymm0          # 32-byte Folded Reload
	vmovdqu	%ymm0, 528(%rsp)                # 32-byte Spill
	vpaddq	%ymm0, %ymm9, %ymm0
	vpmuludq	%ymm1, %ymm0, %ymm5
	vpsrlq	$32, %ymm0, %ymm0
	vpmuludq	%ymm1, %ymm0, %ymm0
	vpsllq	$32, %ymm0, %ymm0
	vpaddq	%ymm0, %ymm5, %ymm7
	vextractf128	$1, %ymm6, %xmm5
	testb	$1, -56(%rsp)                   # 1-byte Folded Reload
	jne	.LBB3_13
# %bb.14:                               #   in Loop: Header=BB3_4 Depth=1
	testb	$1, -60(%rsp)                   # 1-byte Folded Reload
	jne	.LBB3_15
.LBB3_16:                               #   in Loop: Header=BB3_4 Depth=1
	vextracti128	$1, %ymm7, %xmm0
	testb	$1, -68(%rsp)                   # 1-byte Folded Reload
	jne	.LBB3_17
.LBB3_18:                               #   in Loop: Header=BB3_4 Depth=1
	testb	$1, -72(%rsp)                   # 1-byte Folded Reload
	je	.LBB3_20
.LBB3_19:                               #   in Loop: Header=BB3_4 Depth=1
	vpextrq	$1, %xmm0, %rax
	vextractps	$3, %xmm5, (%rdx,%rax,4)
.LBB3_20:                               #   in Loop: Header=BB3_4 Depth=1
	vmovdqu	240(%rsp), %ymm5                # 32-byte Reload
	vpxor	%ymm5, %ymm9, %ymm0
	vpxor	%ymm5, %ymm10, %ymm7
	vpsllq	$63, %ymm0, %ymm0
	vpxor	%xmm15, %xmm15, %xmm15
	vpcmpgtq	%ymm0, %ymm15, %ymm0
	vmovdqu	48(%rsp), %ymm14                # 32-byte Reload
	vpand	%ymm0, %ymm14, %ymm0
	vmovdqu	%ymm0, 432(%rsp)                # 32-byte Spill
	vpaddq	%ymm0, %ymm9, %ymm0
	vpmuludq	%ymm1, %ymm0, %ymm5
	vpsrlq	$32, %ymm0, %ymm0
	vpmuludq	%ymm1, %ymm0, %ymm0
	vpsllq	$32, %ymm0, %ymm0
	vpaddq	%ymm0, %ymm5, %ymm5
	vpmovzxwd	96(%rsp), %ymm0         # 16-byte Folded Reload
                                        # ymm0 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpslld	$31, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm8
	vxorps	%xmm11, %xmm11, %xmm11
	vgatherqps	%xmm8, (%rbp,%ymm5,4), %xmm11
	vpsllq	$63, %ymm7, %ymm7
	vpcmpgtq	%ymm7, %ymm15, %ymm7
	vpand	%ymm7, %ymm14, %ymm7
	vmovdqu	%ymm7, 464(%rsp)                # 32-byte Spill
	vpaddq	%ymm7, %ymm10, %ymm7
	vpmuludq	%ymm1, %ymm7, %ymm8
	vpsrlq	$32, %ymm7, %ymm7
	vpmuludq	%ymm1, %ymm7, %ymm7
	vpsllq	$32, %ymm7, %ymm7
	vpaddq	%ymm7, %ymm8, %ymm8
	vpxor	%xmm7, %xmm7, %xmm7
	vgatherqps	%xmm0, (%rbp,%ymm8,4), %xmm7
	vinsertf128	$1, %xmm11, %ymm7, %ymm7
	vpcmpgtq	%ymm15, %ymm4, %ymm0
	vpand	%ymm0, %ymm14, %ymm12
	vpcmpgtq	%ymm15, %ymm2, %ymm0
	vpand	%ymm0, %ymm14, %ymm4
	cmpl	$1, %esi
	jne	.LBB3_22
# %bb.21:                               #   in Loop: Header=BB3_4 Depth=1
	vpaddq	%ymm10, %ymm12, %ymm0
	vpaddq	%ymm4, %ymm9, %ymm2
	vpmuludq	%ymm1, %ymm0, %ymm11
	vpsrlq	$32, %ymm0, %ymm0
	vpmuludq	%ymm1, %ymm0, %ymm0
	vpsllq	$32, %ymm0, %ymm0
	vpaddq	%ymm0, %ymm11, %ymm0
	vxorps	16(%rsp), %ymm6, %ymm6          # 32-byte Folded Reload
	vmovq	%xmm0, %rax
	vmovss	%xmm6, (%rdx,%rax,4)
	vpmuludq	%ymm1, %ymm2, %ymm11
	vpextrq	$1, %xmm0, %rax
	vextractps	$1, %xmm6, (%rdx,%rax,4)
	vpsrlq	$32, %ymm2, %ymm2
	vextracti128	$1, %ymm0, %xmm0
	vmovq	%xmm0, %rax
	vextractps	$2, %xmm6, (%rdx,%rax,4)
	vpmuludq	%ymm1, %ymm2, %ymm2
	vpextrq	$1, %xmm0, %rax
	vextractps	$3, %xmm6, (%rdx,%rax,4)
	vpsllq	$32, %ymm2, %ymm0
	vpaddq	%ymm0, %ymm11, %ymm0
	vmovq	%xmm0, %rax
	vextractf128	$1, %ymm6, %xmm2
	vmovss	%xmm2, (%rdx,%rax,4)
	vpextrq	$1, %xmm0, %rax
	vextractps	$1, %xmm2, (%rdx,%rax,4)
	vextracti128	$1, %ymm0, %xmm0
	vmovq	%xmm0, %rax
	vextractps	$2, %xmm2, (%rdx,%rax,4)
	vpextrq	$1, %xmm0, %rax
	vextractps	$3, %xmm2, (%rdx,%rax,4)
.LBB3_22:                               #   in Loop: Header=BB3_4 Depth=1
	vmovdqa	128(%rsp), %xmm14               # 16-byte Reload
	vpmovzxwd	%xmm14, %ymm0           # ymm0 = xmm14[0],zero,xmm14[1],zero,xmm14[2],zero,xmm14[3],zero,xmm14[4],zero,xmm14[5],zero,xmm14[6],zero,xmm14[7],zero
	vpslld	$31, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm2
	vxorps	%xmm6, %xmm6, %xmm6
	vgatherqps	%xmm2, (%rbp,%ymm5,4), %xmm6
	vmovdqa	%xmm0, %xmm2
	vxorps	%xmm5, %xmm5, %xmm5
	vgatherqps	%xmm2, (%rbp,%ymm8,4), %xmm5
	vinsertf128	$1, %xmm6, %ymm5, %ymm2
	vxorps	16(%rsp), %ymm2, %ymm2          # 32-byte Folded Reload
	vblendvps	%ymm0, %ymm2, %ymm7, %ymm2
	vmovdqu	208(%rsp), %ymm5                # 32-byte Reload
	vpxor	%ymm5, %ymm10, %ymm0
	vpxor	%ymm5, %ymm9, %ymm5
	vpsllq	$63, %ymm5, %ymm5
	vxorps	%xmm7, %xmm7, %xmm7
	vpcmpgtq	%ymm5, %ymm7, %ymm5
	vmovdqu	48(%rsp), %ymm6                 # 32-byte Reload
	vpand	%ymm6, %ymm5, %ymm5
	vpsllq	$63, %ymm0, %ymm0
	vpcmpgtq	%ymm0, %ymm7, %ymm0
	vpand	%ymm6, %ymm0, %ymm0
	vmovdqu	%ymm0, 400(%rsp)                # 32-byte Spill
	vpaddq	%ymm0, %ymm10, %ymm0
	vmovdqu	%ymm5, 496(%rsp)                # 32-byte Spill
	vpaddq	%ymm5, %ymm9, %ymm5
	vpmuludq	%ymm1, %ymm5, %ymm6
	vpsrlq	$32, %ymm5, %ymm5
	vpmuludq	%ymm1, %ymm5, %ymm5
	vpsllq	$32, %ymm5, %ymm5
	vpaddq	%ymm5, %ymm6, %ymm5
	vpmuludq	%ymm1, %ymm0, %ymm6
	vpsrlq	$32, %ymm0, %ymm0
	vpmuludq	%ymm1, %ymm0, %ymm0
	vpsllq	$32, %ymm0, %ymm0
	vpaddq	%ymm0, %ymm6, %ymm0
	vpextrq	$1, %xmm0, %rax
	vmovq	%xmm0, %r13
	vextracti128	$1, %ymm0, %xmm0
	vmovq	%xmm0, %r10
	vpextrq	$1, %xmm0, %rbp
	vmovq	%xmm5, %r11
	vpextrq	$1, %xmm5, %rcx
	vextracti128	$1, %ymm5, %xmm0
	vmovq	%xmm0, %r9
	vmovss	%xmm2, (%r14,%r13,4)
	vextractps	$1, %xmm2, (%r14,%rax,4)
	vextractps	$2, %xmm2, (%r14,%r10,4)
	vextractps	$3, %xmm2, (%r14,%rbp,4)
	vextractf128	$1, %ymm2, %xmm2
	vmovss	%xmm2, (%r14,%r11,4)
	vextractps	$1, %xmm2, (%r14,%rcx,4)
	vextractps	$2, %xmm2, (%r14,%r9,4)
	vpextrq	$1, %xmm0, %rax
	vextractps	$3, %xmm2, (%r14,%rax,4)
	vpsrlq	$1, %ymm9, %ymm6
	vmovupd	336(%rsp), %ymm7                # 32-byte Reload
	vmovupd	176(%rsp), %ymm11               # 32-byte Reload
	vblendvpd	%ymm3, %ymm7, %ymm11, %ymm0
	vpmuludq	%ymm1, %ymm0, %ymm2
	vpsrlq	$32, %ymm0, %ymm0
	vpmuludq	%ymm1, %ymm0, %ymm0
	vpsllq	$32, %ymm0, %ymm0
	vpaddq	%ymm0, %ymm2, %ymm0
	vpsllq	$2, %ymm0, %ymm0
	vmovq	%rdx, %xmm2
	vpbroadcastq	%xmm2, %ymm2
	vpsllq	$2, %ymm6, %ymm3
	vpaddq	%ymm3, %ymm2, %ymm8
	vpaddq	%ymm0, %ymm8, %ymm0
	vpcmpeqd	%xmm3, %xmm3, %xmm3
	vpxor	%xmm5, %xmm5, %xmm5
	vgatherqps	%xmm3, (,%ymm0), %xmm5
	vpsrlq	$1, %ymm10, %ymm3
	vblendvpd	%ymm13, %ymm7, %ymm11, %ymm0
	vpmuludq	%ymm1, %ymm0, %ymm7
	vpsrlq	$32, %ymm0, %ymm0
	vpmuludq	%ymm1, %ymm0, %ymm0
	vpsllq	$32, %ymm0, %ymm0
	vpaddq	%ymm0, %ymm7, %ymm0
	vpsllq	$2, %ymm0, %ymm0
	vpsllq	$2, %ymm3, %ymm7
	vpaddq	%ymm7, %ymm2, %ymm2
	vmovdqu	%ymm2, 368(%rsp)                # 32-byte Spill
	vpaddq	%ymm0, %ymm2, %ymm0
	vpcmpeqd	%xmm2, %xmm2, %xmm2
	vxorpd	%xmm11, %xmm11, %xmm11
	vgatherqps	%xmm2, (,%ymm0), %xmm11
	vpmovzxwd	%xmm14, %xmm0           # xmm0 = xmm14[0],zero,xmm14[1],zero,xmm14[2],zero,xmm14[3],zero
	vpslld	$31, %xmm0, %xmm0
	vpmovsxdq	%xmm0, %ymm0
	vmovupd	144(%rsp), %ymm2                # 32-byte Reload
	vblendvpd	%ymm0, %ymm12, %ymm2, %ymm0
	vinsertf128	$1, %xmm5, %ymm11, %ymm12
	vmovupd	%ymm0, 144(%rsp)                # 32-byte Spill
	vpmuludq	%ymm1, %ymm0, %ymm11
	testb	$1, -88(%rsp)                   # 1-byte Folded Reload
	je	.LBB3_24
# %bb.23:                               #   in Loop: Header=BB3_4 Depth=1
	vmovq	%xmm11, %rax
	leaq	(%rdx,%rax,4), %rax
	vmovq	%xmm3, %rcx
	vmovss	%xmm12, (%rax,%rcx,4)
.LBB3_24:                               #   in Loop: Header=BB3_4 Depth=1
	testb	$1, -76(%rsp)                   # 1-byte Folded Reload
	je	.LBB3_26
# %bb.25:                               #   in Loop: Header=BB3_4 Depth=1
	vpextrq	$1, %xmm11, %rax
	leaq	(%rdx,%rax,4), %rax
	vpextrq	$1, %xmm3, %rcx
	vextractps	$1, %xmm12, (%rax,%rcx,4)
.LBB3_26:                               #   in Loop: Header=BB3_4 Depth=1
	vextracti128	$1, %ymm11, %xmm2
	vextracti128	$1, %ymm3, %xmm13
	testb	$1, -80(%rsp)                   # 1-byte Folded Reload
	movl	-116(%rsp), %r9d                # 4-byte Reload
	je	.LBB3_28
# %bb.27:                               #   in Loop: Header=BB3_4 Depth=1
	vmovq	%xmm2, %rax
	leaq	(%rdx,%rax,4), %rax
	vmovq	%xmm13, %rcx
	vextractps	$2, %xmm12, (%rax,%rcx,4)
.LBB3_28:                               #   in Loop: Header=BB3_4 Depth=1
	testb	$1, -84(%rsp)                   # 1-byte Folded Reload
	je	.LBB3_30
# %bb.29:                               #   in Loop: Header=BB3_4 Depth=1
	vpextrq	$1, %xmm2, %rax
	leaq	(%rdx,%rax,4), %rax
	vpextrq	$1, %xmm13, %rcx
	vextractps	$3, %xmm12, (%rax,%rcx,4)
.LBB3_30:                               #   in Loop: Header=BB3_4 Depth=1
	vmovupd	304(%rsp), %ymm0                # 32-byte Reload
	vmovupd	528(%rsp), %ymm2                # 32-byte Reload
	vblendvpd	%ymm0, %ymm4, %ymm2, %ymm5
	vpmuludq	%ymm1, %ymm5, %ymm14
	vextractf128	$1, %ymm12, %xmm2
	testb	$1, -92(%rsp)                   # 1-byte Folded Reload
	jne	.LBB3_31
# %bb.32:                               #   in Loop: Header=BB3_4 Depth=1
	testb	$1, -96(%rsp)                   # 1-byte Folded Reload
	jne	.LBB3_33
.LBB3_34:                               #   in Loop: Header=BB3_4 Depth=1
	vextracti128	$1, %ymm14, %xmm0
	vextracti128	$1, %ymm6, %xmm4
	testb	$1, -100(%rsp)                  # 1-byte Folded Reload
	jne	.LBB3_35
.LBB3_36:                               #   in Loop: Header=BB3_4 Depth=1
	testb	$1, -104(%rsp)                  # 1-byte Folded Reload
	je	.LBB3_38
.LBB3_37:                               #   in Loop: Header=BB3_4 Depth=1
	vpextrq	$1, %xmm0, %rax
	leaq	(%rdx,%rax,4), %rax
	vpextrq	$1, %xmm4, %rcx
	vextractps	$3, %xmm2, (%rax,%rcx,4)
.LBB3_38:                               #   in Loop: Header=BB3_4 Depth=1
	movq	%rbx, %rsi
	vmovdqu	240(%rsp), %ymm7                # 32-byte Reload
	vpaddq	432(%rsp), %ymm7, %ymm0         # 32-byte Folded Reload
	vpmuludq	%ymm1, %ymm0, %ymm2
	vpsrlq	$32, %ymm0, %ymm0
	vpmuludq	%ymm1, %ymm0, %ymm0
	vpsllq	$32, %ymm0, %ymm0
	vpaddq	%ymm0, %ymm2, %ymm0
	vpsllq	$2, %ymm0, %ymm0
	vpaddq	%ymm0, %ymm8, %ymm8
	vpmovzxwd	80(%rsp), %ymm0         # 16-byte Folded Reload
                                        # ymm0 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpslld	$31, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm2
	vpxor	%xmm15, %xmm15, %xmm15
	vgatherqps	%xmm2, (,%ymm8), %xmm15
	vpaddq	464(%rsp), %ymm7, %ymm2         # 32-byte Folded Reload
	vpmuludq	%ymm1, %ymm2, %ymm7
	vpsrlq	$32, %ymm2, %ymm2
	vpmuludq	%ymm1, %ymm2, %ymm2
	vpsllq	$32, %ymm2, %ymm2
	vpaddq	%ymm2, %ymm7, %ymm2
	vpsllq	$2, %ymm2, %ymm2
	vpaddq	368(%rsp), %ymm2, %ymm7         # 32-byte Folded Reload
	vpxor	%xmm2, %xmm2, %xmm2
	vgatherqps	%xmm0, (,%ymm7), %xmm2
	vinsertf128	$1, %xmm15, %ymm2, %ymm2
	cmpl	$2, %r9d
	jne	.LBB3_40
# %bb.39:                               #   in Loop: Header=BB3_4 Depth=1
	vpsrlq	$32, %ymm5, %ymm0
	vpmuludq	%ymm1, %ymm0, %ymm0
	vpsllq	$32, %ymm0, %ymm0
	vmovdqu	144(%rsp), %ymm5                # 32-byte Reload
	vpsrlq	$32, %ymm5, %ymm5
	vpmuludq	%ymm1, %ymm5, %ymm5
	vpsllq	$32, %ymm5, %ymm5
	vpaddq	%ymm5, %ymm11, %ymm5
	vxorps	16(%rsp), %ymm12, %ymm11        # 32-byte Folded Reload
	vmovq	%xmm5, %rax
	leaq	(%rdx,%rax,4), %rax
	vmovq	%xmm3, %rcx
	vmovss	%xmm11, (%rax,%rcx,4)
	vpaddq	%ymm0, %ymm14, %ymm0
	vpextrq	$1, %xmm5, %rax
	leaq	(%rdx,%rax,4), %rax
	vpextrq	$1, %xmm3, %rcx
	vextractps	$1, %xmm11, (%rax,%rcx,4)
	vextracti128	$1, %ymm5, %xmm5
	vmovq	%xmm5, %rax
	leaq	(%rdx,%rax,4), %rax
	vmovq	%xmm13, %rcx
	vextractps	$2, %xmm11, (%rax,%rcx,4)
	vpextrq	$1, %xmm5, %rax
	leaq	(%rdx,%rax,4), %rax
	vpextrq	$1, %xmm13, %rcx
	vextractps	$3, %xmm11, (%rax,%rcx,4)
	vmovq	%xmm0, %rax
	leaq	(%rdx,%rax,4), %rax
	vmovq	%xmm6, %rcx
	vextractf128	$1, %ymm11, %xmm5
	vmovss	%xmm5, (%rax,%rcx,4)
	vpextrq	$1, %xmm0, %rax
	leaq	(%rdx,%rax,4), %rax
	vpextrq	$1, %xmm6, %rcx
	vextractps	$1, %xmm5, (%rax,%rcx,4)
	vextracti128	$1, %ymm0, %xmm0
	vmovq	%xmm0, %rax
	leaq	(%rdx,%rax,4), %rax
	vmovq	%xmm4, %rcx
	vextractps	$2, %xmm5, (%rax,%rcx,4)
	vpextrq	$1, %xmm0, %rax
	leaq	(%rdx,%rax,4), %rax
	vpextrq	$1, %xmm4, %rcx
	vextractps	$3, %xmm5, (%rax,%rcx,4)
	jmp	.LBB3_40
	.p2align	4, 0x90
.LBB3_5:                                #   in Loop: Header=BB3_4 Depth=1
	vmovq	%xmm5, %rax
	vmovss	%xmm6, (%rdx,%rax,4)
	testb	$1, -44(%rsp)                   # 1-byte Folded Reload
	je	.LBB3_8
.LBB3_7:                                #   in Loop: Header=BB3_4 Depth=1
	vpextrq	$1, %xmm5, %rax
	vextractps	$1, %xmm6, (%rdx,%rax,4)
	vextracti128	$1, %ymm5, %xmm0
	testb	$1, -48(%rsp)                   # 1-byte Folded Reload
	je	.LBB3_10
.LBB3_9:                                #   in Loop: Header=BB3_4 Depth=1
	vmovq	%xmm0, %rax
	vextractps	$2, %xmm6, (%rdx,%rax,4)
	testb	$1, -52(%rsp)                   # 1-byte Folded Reload
	jne	.LBB3_11
	jmp	.LBB3_12
	.p2align	4, 0x90
.LBB3_13:                               #   in Loop: Header=BB3_4 Depth=1
	vmovq	%xmm7, %rax
	vmovss	%xmm5, (%rdx,%rax,4)
	testb	$1, -60(%rsp)                   # 1-byte Folded Reload
	je	.LBB3_16
.LBB3_15:                               #   in Loop: Header=BB3_4 Depth=1
	vpextrq	$1, %xmm7, %rax
	vextractps	$1, %xmm5, (%rdx,%rax,4)
	vextracti128	$1, %ymm7, %xmm0
	testb	$1, -68(%rsp)                   # 1-byte Folded Reload
	je	.LBB3_18
.LBB3_17:                               #   in Loop: Header=BB3_4 Depth=1
	vmovq	%xmm0, %rax
	vextractps	$2, %xmm5, (%rdx,%rax,4)
	testb	$1, -72(%rsp)                   # 1-byte Folded Reload
	jne	.LBB3_19
	jmp	.LBB3_20
	.p2align	4, 0x90
.LBB3_31:                               #   in Loop: Header=BB3_4 Depth=1
	vmovq	%xmm14, %rax
	leaq	(%rdx,%rax,4), %rax
	vmovq	%xmm6, %rcx
	vmovss	%xmm2, (%rax,%rcx,4)
	testb	$1, -96(%rsp)                   # 1-byte Folded Reload
	je	.LBB3_34
.LBB3_33:                               #   in Loop: Header=BB3_4 Depth=1
	vpextrq	$1, %xmm14, %rax
	leaq	(%rdx,%rax,4), %rax
	vpextrq	$1, %xmm6, %rcx
	vextractps	$1, %xmm2, (%rax,%rcx,4)
	vextracti128	$1, %ymm14, %xmm0
	vextracti128	$1, %ymm6, %xmm4
	testb	$1, -100(%rsp)                  # 1-byte Folded Reload
	je	.LBB3_36
.LBB3_35:                               #   in Loop: Header=BB3_4 Depth=1
	vmovq	%xmm0, %rax
	leaq	(%rdx,%rax,4), %rax
	vmovq	%xmm4, %rcx
	vextractps	$2, %xmm2, (%rax,%rcx,4)
	testb	$1, -104(%rsp)                  # 1-byte Folded Reload
	jne	.LBB3_37
	jmp	.LBB3_38
.LBB3_1:
	leaq	1(%rdi), %rcx
	movl	%eax, %ebx
	xorl	%r14d, %r14d
	jmp	.LBB3_43
.LBB3_41:
	movq	-24(%rsp), %rax                 # 8-byte Reload
	cmpq	%rax, -16(%rsp)                 # 8-byte Folded Reload
	jne	.LBB3_44
.LBB3_42:
	movq	-32(%rsp), %r10                 # 8-byte Reload
	movq	-40(%rsp), %r14                 # 8-byte Reload
	movq	-112(%rsp), %rcx                # 8-byte Reload
.LBB3_43:
	movq	%r8, %rax
	imulq	%rdi, %rax
	imulq	%r8, %rcx
	vmovss	(%rdx,%rcx,4), %xmm0            # xmm0 = mem[0],zero,zero,zero
	vaddss	(%rdx,%rax,4), %xmm0, %xmm1
	vmovss	.LCPI3_5(%rip), %xmm0           # xmm0 = [5.0E-1,0.0E+0,0.0E+0,0.0E+0]
	vmulss	%xmm0, %xmm1, %xmm1
	vmovss	%xmm1, (%rdx)
	movl	%r11d, %eax
	andl	$1, %eax
	negl	%eax
	andl	%edi, %eax
	movq	%rax, %rcx
	imulq	%r8, %rcx
	leaq	(%rdx,%rcx,4), %rcx
	xorl	%esi, %esi
	testb	$1, %bl
	cmoveq	%rdi, %rsi
	leaq	1(%rsi), %r9
	imulq	%r8, %r9
	leaq	(%rdx,%r9,4), %r9
	vmovss	(%r9,%r14,4), %xmm1             # xmm1 = mem[0],zero,zero,zero
	vaddss	(%rcx,%r10,4), %xmm1, %xmm1
	vmulss	%xmm0, %xmm1, %xmm1
	movl	%ebx, %ecx
	andl	$1, %ecx
	negl	%ecx
	andl	%edi, %ecx
	movq	%rcx, %r9
	imulq	%r8, %r9
	leaq	(%rdx,%r9,4), %r9
	vmovss	%xmm1, (%r9,%r14,4)
	addq	%rbx, %rsi
	imulq	%r8, %rsi
	addq	%r11, %rax
	imulq	%r8, %rax
	vmovss	(%rdx,%rax,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
	vaddss	(%rdx,%rsi,4), %xmm1, %xmm1
	vmulss	%xmm0, %xmm1, %xmm1
	addq	%rbx, %rcx
	imulq	%r8, %rcx
	vmovss	%xmm1, (%rdx,%rcx,4)
	movl	%ebx, %eax
	xorl	%r11d, %eax
	andl	$1, %eax
	negl	%eax
	andl	%edi, %eax
	leaq	(%rax,%rbx), %rcx
	imulq	%r8, %rcx
	leaq	(%rdx,%rcx,4), %rcx
	addq	%r11, %rax
	imulq	%r8, %rax
	leaq	(%rdx,%rax,4), %rax
	vmovss	(%rax,%r14,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
	vaddss	(%rcx,%r10,4), %xmm1, %xmm1
	vmulss	%xmm0, %xmm1, %xmm0
	imulq	%rbx, %r8
	leaq	(%rdx,%r8,4), %rax
	vmovss	%xmm0, (%rax,%r14,4)
	addq	$568, %rsp                      # imm = 0x238
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	vzeroupper
	retq
.LBB3_44:
	.cfi_def_cfa_offset 624
	vpbroadcastd	.LCPI3_3(%rip), %xmm0   # xmm0 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
	jmp	.LBB3_45
	.p2align	4, 0x90
.LBB3_50:                               #   in Loop: Header=BB3_45 Depth=1
	imulq	%r8, %rax
	leaq	(%rdx,%rax,4), %rax
	vmovd	%xmm1, (%rax,%r13,4)
	movl	%r15d, %eax
	xorl	%r11d, %eax
	andl	$1, %eax
	negl	%eax
	andl	%edi, %eax
	addq	%r11, %rax
	imulq	%r8, %rax
	leaq	(%rdx,%rax,4), %rax
	vmovd	(%rax,%r13,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
.LBB3_51:                               #   in Loop: Header=BB3_45 Depth=1
	addq	%rbx, %r12
	imulq	%r8, %r12
	leaq	(%rdx,%r12,4), %rax
	vmovd	%xmm1, (%rax,%r13,4)
	incq	%r15
	cmpq	%r15, %rbx
	je	.LBB3_42
.LBB3_45:                               # =>This Inner Loop Header: Depth=1
	testb	$1, %r15b
	movl	$0, %eax
	cmoveq	%rdi, %rax
	addq	%r15, %rax
	imulq	%r8, %rax
	vmovd	(%rdx,%rax,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
	cmpl	$1, %esi
	jne	.LBB3_47
# %bb.46:                               #   in Loop: Header=BB3_45 Depth=1
	vpxor	%xmm0, %xmm1, %xmm1
	testb	$1, %r15b
	sete	%r10b
	movl	%r15d, %eax
	andl	$1, %eax
	negl	%eax
	andl	%edi, %eax
	leaq	(%rax,%r15), %rcx
	imulq	%r8, %rcx
	vmovd	%xmm1, (%rdx,%rcx,4)
	movl	%r11d, %ecx
	xorl	%r15d, %ecx
	andl	$1, %ecx
	negl	%ecx
	andl	%edi, %ecx
	addq	%r15, %rcx
	imulq	%r8, %rcx
	vmovd	(%rbp,%rcx,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
	vpxor	%xmm0, %xmm1, %xmm1
	jmp	.LBB3_48
	.p2align	4, 0x90
.LBB3_47:                               #   in Loop: Header=BB3_45 Depth=1
	testb	$1, %r15b
	sete	%r10b
	movl	%r15d, %eax
	andl	$1, %eax
	negl	%eax
	andl	%edi, %eax
	leaq	(%rax,%r15), %rcx
	imulq	%r8, %rcx
	vmovd	%xmm1, (%rdx,%rcx,4)
	movl	%r11d, %ecx
	xorl	%r15d, %ecx
	andl	$1, %ecx
	negl	%ecx
	andl	%edi, %ecx
	addq	%r15, %rcx
	imulq	%r8, %rcx
	vmovd	(%rbp,%rcx,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
.LBB3_48:                               #   in Loop: Header=BB3_45 Depth=1
	movl	%r15d, %r12d
	xorl	%ebx, %r12d
	andl	$1, %r12d
	negl	%r12d
	andl	%edi, %r12d
	leaq	(%r12,%r15), %rcx
	imulq	%r8, %rcx
	movq	%r15, %r13
	shrq	%r13
	testb	%r10b, %r10b
	movl	$1, %r9d
	cmovneq	-112(%rsp), %r9                 # 8-byte Folded Reload
	imulq	%r8, %r9
	vmovd	%xmm1, (%r14,%rcx,4)
	leaq	(%rdx,%r9,4), %rcx
	vmovd	(%rcx,%r13,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
	cmpl	$2, %esi
	jne	.LBB3_50
# %bb.49:                               #   in Loop: Header=BB3_45 Depth=1
	vpxor	%xmm0, %xmm1, %xmm1
	imulq	%r8, %rax
	leaq	(%rdx,%rax,4), %rax
	vmovd	%xmm1, (%rax,%r13,4)
	movl	%r15d, %eax
	xorl	%r11d, %eax
	andl	$1, %eax
	negl	%eax
	andl	%edi, %eax
	addq	%r11, %rax
	imulq	%r8, %rax
	leaq	(%rdx,%rax,4), %rax
	vmovd	(%rax,%r13,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
	vpxor	%xmm0, %xmm1, %xmm1
	jmp	.LBB3_51
.Lfunc_end3:
	.size	set_bnd, .Lfunc_end3-set_bnd
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function advect.omp_outlined
.LCPI4_0:
	.long	0x3f000000                      # float 0.5
.LCPI4_4:
	.long	1258291200                      # 0x4b000000
.LCPI4_5:
	.long	1392508928                      # 0x53000000
.LCPI4_6:
	.long	0x53000080                      # float 5.49764202E+11
.LCPI4_7:
	.long	0x3f800000                      # float 1
.LCPI4_10:
	.long	8                               # 0x8
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0
.LCPI4_1:
	.quad	5                               # 0x5
	.quad	6                               # 0x6
	.quad	7                               # 0x7
	.quad	8                               # 0x8
.LCPI4_2:
	.quad	1                               # 0x1
	.quad	2                               # 0x2
	.quad	3                               # 0x3
	.quad	4                               # 0x4
.LCPI4_3:
	.long	1                               # 0x1
	.long	2                               # 0x2
	.long	3                               # 0x3
	.long	4                               # 0x4
	.long	5                               # 0x5
	.long	6                               # 0x6
	.long	7                               # 0x7
	.long	8                               # 0x8
.LCPI4_11:
	.zero	32
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI4_8:
	.quad	-4                              # 0xfffffffffffffffc
.LCPI4_9:
	.quad	8                               # 0x8
	.text
	.p2align	4, 0x90
	.type	advect.omp_outlined,@function
advect.omp_outlined:                    # @advect.omp_outlined
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$424, %rsp                      # imm = 0x1A8
	.cfi_def_cfa_offset 480
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%r9, %r14
	movq	%r8, %r15
	movq	%rcx, %rbx
	movq	%rdx, %r12
	callq	omp_get_thread_num@PLT
	movl	%eax, %ebp
	callq	omp_get_num_threads@PLT
	movl	%eax, %ecx
	movl	(%r12), %edi
	leal	(%rcx,%rdi), %eax
	decl	%eax
	xorl	%edx, %edx
	divl	%ecx
	imull	%eax, %ebp
	addl	%ebp, %eax
	cmpl	%edi, %eax
	cmovael	%edi, %eax
	incl	%eax
	incl	%ebp
	cmpl	%eax, %ebp
	jae	.LBB4_9
# %bb.1:
	testl	%edi, %edi
	je	.LBB4_9
# %bb.2:
	movq	488(%rsp), %rsi
	movq	480(%rsp), %r10
	leal	2(%rdi), %ecx
	movl	%ecx, %edx
	shrl	%edx
	movq	(%r15), %r11
	movl	%edi, %r8d
	vcvtsi2ss	%r8, %xmm0, %xmm0
	movq	%rdi, %r8
	vaddss	.LCPI4_0(%rip), %xmm0, %xmm5
	movq	(%r14), %rdi
	movq	(%rsi), %r9
	movq	(%r10), %r10
	incl	%r8d
	cmpl	$3, %r8d
	movl	$2, %esi
	cmovael	%r8d, %esi
	movq	%rsi, 56(%rsp)                  # 8-byte Spill
	movl	%ebp, %r14d
	movl	%eax, %eax
	movq	%rax, 48(%rsp)                  # 8-byte Spill
	leaq	-1(%rsi), %rax
	movq	%rax, 32(%rsp)                  # 8-byte Spill
	andq	$-8, %rax
	movq	%rax, (%rsp)                    # 8-byte Spill
	incq	%rax
	movq	%rax, 24(%rsp)                  # 8-byte Spill
	vmovq	%rcx, %xmm0
	vpbroadcastq	%xmm0, %ymm15
	vmovq	%rdx, %xmm0
	vpbroadcastq	%xmm0, %ymm2
	vbroadcastss	%xmm5, %ymm6
	vmovss	.LCPI4_0(%rip), %xmm7           # xmm7 = [5.0E-1,0.0E+0,0.0E+0,0.0E+0]
	vmovss	.LCPI4_7(%rip), %xmm8           # xmm8 = [1.0E+0,0.0E+0,0.0E+0,0.0E+0]
	vpxor	%xmm14, %xmm14, %xmm14
	movq	%r11, 16(%rsp)                  # 8-byte Spill
	movq	%rdi, 8(%rsp)                   # 8-byte Spill
	movq	%r8, 40(%rsp)                   # 8-byte Spill
	vmovaps	%xmm5, 64(%rsp)                 # 16-byte Spill
	vmovups	%ymm6, 160(%rsp)                # 32-byte Spill
	jmp	.LBB4_4
	.p2align	4, 0x90
.LBB4_3:                                #   in Loop: Header=BB4_4 Depth=1
	incq	%r14
	cmpq	48(%rsp), %r14                  # 8-byte Folded Reload
	jae	.LBB4_9
.LBB4_4:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB4_6 Depth 2
                                        #     Child Loop BB4_8 Depth 2
	movl	%r14d, %eax
	vcvtsi2ss	%rax, %xmm12, %xmm9
	movl	$1, %r13d
	cmpl	$9, %r8d
	jb	.LBB4_8
# %bb.5:                                #   in Loop: Header=BB4_4 Depth=1
	vmovq	%r14, %xmm0
	vpbroadcastq	%xmm0, %ymm0
	vmovdqu	%ymm0, 224(%rsp)                # 32-byte Spill
	vmovaps	%xmm9, 80(%rsp)                 # 16-byte Spill
	vbroadcastss	%xmm9, %ymm0
	vmovups	%ymm0, 192(%rsp)                # 32-byte Spill
	movq	(%rsp), %rbp                    # 8-byte Reload
	vmovdqa	.LCPI4_2(%rip), %ymm1           # ymm1 = [1,2,3,4]
	vmovdqa	.LCPI4_1(%rip), %ymm3           # ymm3 = [5,6,7,8]
	vmovdqa	.LCPI4_3(%rip), %ymm8           # ymm8 = [1,2,3,4,5,6,7,8]
	.p2align	4, 0x90
.LBB4_6:                                #   Parent Loop BB4_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmovdqu	%ymm3, 96(%rsp)                 # 32-byte Spill
	vmovdqu	%ymm1, 128(%rsp)                # 32-byte Spill
	vmovdqu	224(%rsp), %ymm5                # 32-byte Reload
	vpxor	%ymm5, %ymm1, %ymm0
	vpxor	%ymm5, %ymm3, %ymm1
	vpsllq	$63, %ymm1, %ymm1
	vpcmpgtq	%ymm1, %ymm14, %ymm1
	vpand	%ymm1, %ymm15, %ymm1
	vpsllq	$63, %ymm0, %ymm0
	vpcmpgtq	%ymm0, %ymm14, %ymm0
	vpand	%ymm0, %ymm15, %ymm0
	vmovdqu	96(%rsp), %ymm3                 # 32-byte Reload
	vpsrlq	$1, %ymm3, %ymm3
	vmovdqu	128(%rsp), %ymm4                # 32-byte Reload
	vpsrlq	$1, %ymm4, %ymm4
	vpaddq	%ymm5, %ymm0, %ymm0
	vpaddq	%ymm5, %ymm1, %ymm1
	vpmuludq	%ymm2, %ymm1, %ymm5
	vpaddq	%ymm3, %ymm5, %ymm3
	vpsrlq	$32, %ymm1, %ymm1
	vpmuludq	%ymm2, %ymm1, %ymm1
	vpsllq	$32, %ymm1, %ymm1
	vpmuludq	%ymm2, %ymm0, %ymm5
	vpaddq	%ymm4, %ymm5, %ymm4
	vpaddq	%ymm1, %ymm3, %ymm5
	vpsrlq	$32, %ymm0, %ymm0
	vpmuludq	%ymm2, %ymm0, %ymm0
	vpcmpeqd	%xmm1, %xmm1, %xmm1
	vpxor	%xmm3, %xmm3, %xmm3
	vgatherqps	%xmm1, (%r11,%ymm5,4), %xmm3
	vmovups	%ymm5, 384(%rsp)                # 32-byte Spill
	vpsllq	$32, %ymm0, %ymm0
	vpaddq	%ymm0, %ymm4, %ymm7
	vmovdqu	%ymm7, 352(%rsp)                # 32-byte Spill
	vpcmpeqd	%xmm0, %xmm0, %xmm0
	vxorps	%xmm1, %xmm1, %xmm1
	vgatherqps	%xmm0, (%r11,%ymm7,4), %xmm1
	vpcmpeqd	%xmm0, %xmm0, %xmm0
	vpxor	%xmm4, %xmm4, %xmm4
	vgatherqps	%xmm0, (%rdi,%ymm5,4), %xmm4
	vpcmpeqd	%xmm0, %xmm0, %xmm0
	vxorps	%xmm5, %xmm5, %xmm5
	vgatherqps	%xmm0, (%rdi,%ymm7,4), %xmm5
	vpbroadcastd	.LCPI4_4(%rip), %ymm0   # ymm0 = [1258291200,1258291200,1258291200,1258291200,1258291200,1258291200,1258291200,1258291200]
	vpblendw	$170, %ymm0, %ymm8, %ymm0       # ymm0 = ymm8[0],ymm0[1],ymm8[2],ymm0[3],ymm8[4],ymm0[5],ymm8[6],ymm0[7],ymm8[8],ymm0[9],ymm8[10],ymm0[11],ymm8[12],ymm0[13],ymm8[14],ymm0[15]
	vpsrld	$16, %ymm8, %ymm9
	vpbroadcastd	.LCPI4_5(%rip), %ymm10  # ymm10 = [1392508928,1392508928,1392508928,1392508928,1392508928,1392508928,1392508928,1392508928]
	vpblendw	$170, %ymm10, %ymm9, %ymm9      # ymm9 = ymm9[0],ymm10[1],ymm9[2],ymm10[3],ymm9[4],ymm10[5],ymm9[6],ymm10[7],ymm9[8],ymm10[9],ymm9[10],ymm10[11],ymm9[12],ymm10[13],ymm9[14],ymm10[15]
	vbroadcastss	.LCPI4_6(%rip), %ymm10  # ymm10 = [5.49764202E+11,5.49764202E+11,5.49764202E+11,5.49764202E+11,5.49764202E+11,5.49764202E+11,5.49764202E+11,5.49764202E+11]
	vsubps	%ymm10, %ymm9, %ymm9
	vaddps	%ymm0, %ymm9, %ymm0
	vbroadcastss	(%rbx), %ymm9
	vinsertf128	$1, %xmm3, %ymm1, %ymm1
	vfnmadd213ps	%ymm0, %ymm9, %ymm1     # ymm1 = -(ymm9 * ymm1) + ymm0
	vinsertf128	$1, %xmm4, %ymm5, %ymm0
	vbroadcastss	.LCPI4_0(%rip), %ymm3   # ymm3 = [5.0E-1,5.0E-1,5.0E-1,5.0E-1,5.0E-1,5.0E-1,5.0E-1,5.0E-1]
	vfnmadd213ps	192(%rsp), %ymm9, %ymm0 # 32-byte Folded Reload
                                        # ymm0 = -(ymm9 * ymm0) + mem
	vmaxps	%ymm3, %ymm1, %ymm1
	vminps	%ymm6, %ymm1, %ymm1
	vmovups	%ymm1, 320(%rsp)                # 32-byte Spill
	vcvttps2dq	%ymm1, %ymm4
	vmaxps	%ymm3, %ymm0, %ymm0
	vminps	%ymm6, %ymm0, %ymm0
	vmovups	%ymm0, 288(%rsp)                # 32-byte Spill
	vcvttps2dq	%ymm0, %ymm11
	vpcmpeqd	%ymm6, %ymm6, %ymm6
	vpsubd	%ymm6, %ymm11, %ymm7
	vmovdqu	%ymm7, 256(%rsp)                # 32-byte Spill
	vpmovsxdq	%xmm4, %ymm9
	vpmovsxdq	%xmm11, %ymm1
	vpxor	%ymm1, %ymm9, %ymm0
	vpsllq	$63, %ymm0, %ymm0
	vpcmpgtq	%ymm0, %ymm14, %ymm0
	vpand	%ymm0, %ymm15, %ymm0
	vpaddq	%ymm1, %ymm0, %ymm0
	vpmuludq	%ymm2, %ymm0, %ymm5
	vpsrlq	$32, %ymm0, %ymm0
	vpmuludq	%ymm2, %ymm0, %ymm0
	vpsllq	$32, %ymm0, %ymm10
	vmovq	%r9, %xmm0
	vpbroadcastq	%xmm0, %ymm3
	vpaddq	%ymm9, %ymm9, %ymm12
	vpbroadcastq	.LCPI4_8(%rip), %ymm0   # ymm0 = [18446744073709551612,18446744073709551612,18446744073709551612,18446744073709551612]
	vpand	%ymm0, %ymm12, %ymm12
	vpaddq	%ymm5, %ymm10, %ymm10
	vpaddq	%ymm3, %ymm12, %ymm12
	vpcmpeqd	%xmm13, %xmm13, %xmm13
	vpmovsxdq	%xmm7, %ymm5
	vpxor	%ymm5, %ymm9, %ymm9
	vpsllq	$63, %ymm9, %ymm9
	vpsllq	$2, %ymm10, %ymm10
	vpcmpgtq	%ymm9, %ymm14, %ymm9
	vpand	%ymm15, %ymm9, %ymm9
	vpaddq	%ymm5, %ymm9, %ymm9
	vpmuludq	%ymm2, %ymm9, %ymm14
	vpsrlq	$32, %ymm9, %ymm9
	vpaddq	%ymm10, %ymm12, %ymm10
	vpmuludq	%ymm2, %ymm9, %ymm9
	vpsllq	$32, %ymm9, %ymm9
	vpaddq	%ymm9, %ymm14, %ymm14
	vpxor	%xmm9, %xmm9, %xmm9
	vgatherqps	%xmm13, (,%ymm10), %xmm9
	vpsllq	$2, %ymm14, %ymm10
	vpaddq	%ymm10, %ymm12, %ymm10
	vpcmpeqd	%xmm13, %xmm13, %xmm13
	vpxor	%xmm12, %xmm12, %xmm12
	vgatherqps	%xmm13, (,%ymm10), %xmm12
	vpsubd	%ymm6, %ymm4, %ymm13
	vpmovsxdq	%xmm13, %ymm10
	vpxor	%ymm1, %ymm10, %ymm14
	vpsllq	$63, %ymm14, %ymm14
	vpxor	%xmm6, %xmm6, %xmm6
	vpcmpgtq	%ymm14, %ymm6, %ymm14
	vpand	%ymm15, %ymm14, %ymm14
	vpaddq	%ymm1, %ymm14, %ymm1
	vpmuludq	%ymm2, %ymm1, %ymm14
	vpsrlq	$32, %ymm1, %ymm1
	vpmuludq	%ymm2, %ymm1, %ymm1
	vpsllq	$32, %ymm1, %ymm1
	vpaddq	%ymm1, %ymm14, %ymm1
	vpaddq	%ymm10, %ymm10, %ymm14
	vpand	%ymm0, %ymm14, %ymm14
	vpsllq	$2, %ymm1, %ymm1
	vpaddq	%ymm3, %ymm14, %ymm14
	vpaddq	%ymm1, %ymm14, %ymm7
	vpcmpeqd	%xmm6, %xmm6, %xmm6
	vpxor	%xmm1, %xmm1, %xmm1
	vgatherqps	%xmm6, (,%ymm7), %xmm1
	vpxor	%ymm5, %ymm10, %ymm6
	vpsllq	$63, %ymm6, %ymm6
	vpxor	%xmm7, %xmm7, %xmm7
	vpcmpgtq	%ymm6, %ymm7, %ymm6
	vpand	%ymm6, %ymm15, %ymm6
	vpaddq	%ymm5, %ymm6, %ymm5
	vpmuludq	%ymm2, %ymm5, %ymm6
	vpsrlq	$32, %ymm5, %ymm5
	vpmuludq	%ymm2, %ymm5, %ymm5
	vpsllq	$32, %ymm5, %ymm5
	vpaddq	%ymm5, %ymm6, %ymm5
	vpsllq	$2, %ymm5, %ymm5
	vpaddq	%ymm5, %ymm14, %ymm6
	vpcmpeqd	%xmm7, %xmm7, %xmm7
	vpxor	%xmm5, %xmm5, %xmm5
	vgatherqps	%xmm7, (,%ymm6), %xmm5
	vextracti128	$1, %ymm4, %xmm4
	vpmovsxdq	%xmm4, %ymm6
	vextracti128	$1, %ymm11, %xmm4
	vpmovsxdq	%xmm4, %ymm4
	vpxor	%ymm6, %ymm4, %ymm7
	vpsllq	$63, %ymm7, %ymm7
	vpxor	%xmm10, %xmm10, %xmm10
	vpcmpgtq	%ymm7, %ymm10, %ymm7
	vpand	%ymm7, %ymm15, %ymm7
	vpaddq	%ymm4, %ymm7, %ymm7
	vpmuludq	%ymm2, %ymm7, %ymm10
	vpsrlq	$32, %ymm7, %ymm7
	vpmuludq	%ymm2, %ymm7, %ymm7
	vpsllq	$32, %ymm7, %ymm7
	vpaddq	%ymm7, %ymm10, %ymm7
	vpaddq	%ymm6, %ymm6, %ymm10
	vpand	%ymm0, %ymm10, %ymm10
	vpsllq	$2, %ymm7, %ymm7
	vpaddq	%ymm3, %ymm10, %ymm10
	vpaddq	%ymm7, %ymm10, %ymm7
	vpcmpeqd	%xmm14, %xmm14, %xmm14
	vpxor	%xmm11, %xmm11, %xmm11
	vgatherqps	%xmm14, (,%ymm7), %xmm11
	vmovdqu	256(%rsp), %ymm7                # 32-byte Reload
	vextracti128	$1, %ymm7, %xmm7
	vpmovsxdq	%xmm7, %ymm7
	vpxor	%ymm6, %ymm7, %ymm6
	vpsllq	$63, %ymm6, %ymm6
	vxorps	%xmm14, %xmm14, %xmm14
	vpcmpgtq	%ymm6, %ymm14, %ymm6
	vpand	%ymm6, %ymm15, %ymm6
	vpaddq	%ymm7, %ymm6, %ymm6
	vpmuludq	%ymm2, %ymm6, %ymm14
	vpsrlq	$32, %ymm6, %ymm6
	vpmuludq	%ymm2, %ymm6, %ymm6
	vpsllq	$32, %ymm6, %ymm6
	vpaddq	%ymm6, %ymm14, %ymm6
	vpxor	%xmm14, %xmm14, %xmm14
	vpsllq	$2, %ymm6, %ymm6
	vextracti128	$1, %ymm13, %xmm13
	vpaddq	%ymm6, %ymm10, %ymm6
	vpmovsxdq	%xmm13, %ymm10
	vpaddq	%ymm10, %ymm10, %ymm13
	vpand	%ymm0, %ymm13, %ymm0
	vpaddq	%ymm0, %ymm3, %ymm0
	vpxor	%ymm7, %ymm10, %ymm3
	vpcmpeqd	%xmm13, %xmm13, %xmm13
	vpsllq	$63, %ymm3, %ymm3
	vpcmpgtq	%ymm3, %ymm14, %ymm3
	vpand	%ymm3, %ymm15, %ymm3
	vpaddq	%ymm7, %ymm3, %ymm3
	vpmuludq	%ymm2, %ymm3, %ymm7
	vpsrlq	$32, %ymm3, %ymm3
	vpmuludq	%ymm2, %ymm3, %ymm3
	vpsllq	$32, %ymm3, %ymm3
	vpaddq	%ymm3, %ymm7, %ymm3
	vpxor	%xmm7, %xmm7, %xmm7
	vgatherqps	%xmm13, (,%ymm6), %xmm7
	vpsllq	$2, %ymm3, %ymm3
	vpaddq	%ymm3, %ymm0, %ymm3
	vpcmpeqd	%xmm6, %xmm6, %xmm6
	vxorps	%xmm13, %xmm13, %xmm13
	vgatherqps	%xmm6, (,%ymm3), %xmm13
	vpxor	%ymm4, %ymm10, %ymm3
	vpsllq	$63, %ymm3, %ymm3
	vpcmpgtq	%ymm3, %ymm14, %ymm3
	vpand	%ymm3, %ymm15, %ymm3
	vpaddq	%ymm4, %ymm3, %ymm3
	vpmuludq	%ymm2, %ymm3, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	vpmuludq	%ymm2, %ymm3, %ymm3
	vpsllq	$32, %ymm3, %ymm3
	vpaddq	%ymm3, %ymm4, %ymm3
	vpsllq	$2, %ymm3, %ymm3
	vpaddq	%ymm3, %ymm0, %ymm0
	vpcmpeqd	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	vgatherqps	%xmm3, (,%ymm0), %xmm4
	vmovups	288(%rsp), %ymm3                # 32-byte Reload
	vroundps	$11, %ymm3, %ymm0
	vsubps	%ymm0, %ymm3, %ymm0
	vinsertf128	$1, %xmm11, %ymm9, %ymm3
	vinsertf128	$1, %xmm7, %ymm12, %ymm6
	vbroadcastss	.LCPI4_7(%rip), %ymm7   # ymm7 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
	vsubps	%ymm0, %ymm7, %ymm7
	vmulps	%ymm6, %ymm0, %ymm6
	vfmadd231ps	%ymm3, %ymm7, %ymm6     # ymm6 = (ymm7 * ymm3) + ymm6
	vinsertf128	$1, %xmm4, %ymm1, %ymm1
	vinsertf128	$1, %xmm13, %ymm5, %ymm3
	vmulps	%ymm3, %ymm0, %ymm0
	vmovdqu	96(%rsp), %ymm3                 # 32-byte Reload
	vfmadd231ps	%ymm1, %ymm7, %ymm0     # ymm0 = (ymm7 * ymm1) + ymm0
	vmovups	320(%rsp), %ymm4                # 32-byte Reload
	vroundps	$11, %ymm4, %ymm1
	vsubps	%ymm1, %ymm4, %ymm1
	vsubps	%ymm6, %ymm0, %ymm0
	vfmadd213ps	%ymm6, %ymm1, %ymm0     # ymm0 = (ymm1 * ymm0) + ymm6
	vmovups	160(%rsp), %ymm6                # 32-byte Reload
	vmovdqu	352(%rsp), %ymm1                # 32-byte Reload
	vmovq	%xmm1, %rax
	vpextrq	$1, %xmm1, %rsi
	vextracti128	$1, %ymm1, %xmm1
	vmovq	%xmm1, %r11
	vpextrq	$1, %xmm1, %r15
	vmovdqu	384(%rsp), %ymm1                # 32-byte Reload
	vmovq	%xmm1, %r12
	vpextrq	$1, %xmm1, %r13
	vextracti128	$1, %ymm1, %xmm1
	movq	%rbx, %r8
	vpextrq	$1, %xmm1, %rbx
	vmovq	%xmm1, %rdi
	vmovdqu	128(%rsp), %ymm1                # 32-byte Reload
	vmovss	%xmm0, (%r10,%rax,4)
	vextractps	$1, %xmm0, (%r10,%rsi,4)
	vextractps	$2, %xmm0, (%r10,%r11,4)
	movq	16(%rsp), %r11                  # 8-byte Reload
	vextractps	$3, %xmm0, (%r10,%r15,4)
	vextractf128	$1, %ymm0, %xmm0
	vmovss	%xmm0, (%r10,%r12,4)
	vextractps	$1, %xmm0, (%r10,%r13,4)
	vextractps	$2, %xmm0, (%r10,%rdi,4)
	movq	8(%rsp), %rdi                   # 8-byte Reload
	vextractps	$3, %xmm0, (%r10,%rbx,4)
	movq	%r8, %rbx
	vpbroadcastq	.LCPI4_9(%rip), %ymm0   # ymm0 = [8,8,8,8]
	vpaddq	%ymm0, %ymm1, %ymm1
	vpaddq	%ymm0, %ymm3, %ymm3
	vpbroadcastd	.LCPI4_10(%rip), %ymm0  # ymm0 = [8,8,8,8,8,8,8,8]
	vpaddd	%ymm0, %ymm8, %ymm8
	addq	$-8, %rbp
	jne	.LBB4_6
# %bb.7:                                #   in Loop: Header=BB4_4 Depth=1
	movq	24(%rsp), %r13                  # 8-byte Reload
	movq	(%rsp), %rax                    # 8-byte Reload
	cmpq	%rax, 32(%rsp)                  # 8-byte Folded Reload
	movq	40(%rsp), %r8                   # 8-byte Reload
	vmovaps	64(%rsp), %xmm5                 # 16-byte Reload
	vmovss	.LCPI4_0(%rip), %xmm7           # xmm7 = [5.0E-1,0.0E+0,0.0E+0,0.0E+0]
	vmovss	.LCPI4_7(%rip), %xmm8           # xmm8 = [1.0E+0,0.0E+0,0.0E+0,0.0E+0]
	vmovaps	80(%rsp), %xmm9                 # 16-byte Reload
	je	.LBB4_3
	.p2align	4, 0x90
.LBB4_8:                                #   Parent Loop BB4_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	%r13d, %eax
	vcvtsi2ss	%rax, %xmm12, %xmm0
	vmovss	(%rbx), %xmm1                   # xmm1 = mem[0],zero,zero,zero
	movl	%r13d, %ebp
	xorl	%r14d, %ebp
	andl	$1, %ebp
	negl	%ebp
	andl	%ecx, %ebp
	movq	%r13, %rax
	shrq	%rax
	addq	%r14, %rbp
	imulq	%rdx, %rbp
	addq	%rax, %rbp
	vfnmadd231ss	(%r11,%rbp,4), %xmm1, %xmm0 # xmm0 = -(xmm1 * mem) + xmm0
	vfnmadd132ss	(%rdi,%rbp,4), %xmm9, %xmm1 # xmm1 = -(xmm1 * mem) + xmm9
	vmaxss	%xmm7, %xmm0, %xmm0
	vminss	%xmm5, %xmm0, %xmm0
	vcvttss2si	%xmm0, %r12d
	movslq	%r12d, %r15
	vmaxss	%xmm7, %xmm1, %xmm1
	vminss	%xmm5, %xmm1, %xmm1
	vcvttss2si	%xmm1, %eax
	vroundss	$11, %xmm1, %xmm1, %xmm3
	leaq	(%r15,%r15), %r11
	vsubss	%xmm3, %xmm1, %xmm3
	vsubss	%xmm3, %xmm8, %xmm1
	movslq	%eax, %rsi
	incl	%eax
	andq	$-4, %r11
	movl	%eax, %edi
	xorl	%r15d, %edi
	andl	$1, %edi
	negl	%edi
	andl	%ecx, %edi
	addq	%rsi, %rdi
	incq	%rdi
	imulq	%rdx, %rdi
	leaq	(%r9,%rdi,4), %rdi
	vmulss	(%r11,%rdi), %xmm3, %xmm4
	movl	%esi, %edi
	xorl	%r15d, %edi
	andl	$1, %edi
	negl	%edi
	andl	%ecx, %edi
	addq	%rsi, %rdi
	imulq	%rdx, %rdi
	leaq	(%r9,%rdi,4), %rdi
	vfmadd231ss	(%r11,%rdi), %xmm1, %xmm4 # xmm4 = (xmm1 * mem) + xmm4
	movq	8(%rsp), %rdi                   # 8-byte Reload
	incl	%r12d
	movl	%esi, %r11d
	xorl	%r12d, %r11d
	xorl	%r12d, %eax
	andl	$1, %r11d
	negl	%r11d
	andl	%ecx, %r11d
	addq	%rsi, %r11
	andl	$1, %eax
	negl	%eax
	andl	%ecx, %eax
	addq	%rsi, %rax
	incq	%rax
	leaq	2(,%r15,2), %rsi
	andq	$-4, %rsi
	imulq	%rdx, %rax
	leaq	(%r9,%rax,4), %rax
	vmulss	(%rsi,%rax), %xmm3, %xmm3
	imulq	%rdx, %r11
	leaq	(%r9,%r11,4), %rax
	movq	16(%rsp), %r11                  # 8-byte Reload
	vfmadd231ss	(%rsi,%rax), %xmm1, %xmm3 # xmm3 = (xmm1 * mem) + xmm3
	vroundss	$11, %xmm0, %xmm0, %xmm1
	vsubss	%xmm1, %xmm0, %xmm0
	vsubss	%xmm4, %xmm3, %xmm1
	vfmadd213ss	%xmm4, %xmm0, %xmm1     # xmm1 = (xmm0 * xmm1) + xmm4
	vmovss	%xmm1, (%r10,%rbp,4)
	incq	%r13
	cmpq	%r13, 56(%rsp)                  # 8-byte Folded Reload
	jne	.LBB4_8
	jmp	.LBB4_3
.LBB4_9:
	addq	$424, %rsp                      # imm = 0x1A8
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	vzeroupper
	retq
.Lfunc_end4:
	.size	advect.omp_outlined, .Lfunc_end4-advect.omp_outlined
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function vel_step
.LCPI5_0:
	.long	0x40800000                      # float 4
.LCPI5_1:
	.long	0x3f800000                      # float 1
	.text
	.globl	vel_step
	.p2align	4, 0x90
	.type	vel_step,@function
vel_step:                               # @vel_step
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$72, %rsp
	.cfi_def_cfa_offset 128
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	vmovss	%xmm1, 8(%rsp)                  # 4-byte Spill
	vmovss	%xmm0, 32(%rsp)                 # 4-byte Spill
	movq	%r8, %rbx
	movq	%rcx, %r14
	movq	%rdx, %r12
	movq	%rsi, 64(%rsp)                  # 8-byte Spill
	movl	%edi, %r13d
	vmovss	%xmm1, 24(%rsp)
	leal	2(%r13), %ebp
	imull	%ebp, %ebp
	movl	%ebp, 40(%rsp)
	movq	%rsi, 16(%rsp)
	movq	%rcx, 48(%rsp)
	subq	$8, %rsp
	.cfi_adjust_cfa_offset 8
	leaq	56(%rsp), %r15
	leaq	.L__unnamed_1(%rip), %rdi
	leaq	add_source.omp_outlined(%rip), %rdx
	leaq	48(%rsp), %rcx
	leaq	24(%rsp), %r8
	leaq	32(%rsp), %r9
	movl	$4, %esi
	xorl	%eax, %eax
	pushq	%r15
	.cfi_adjust_cfa_offset 8
	callq	__kmpc_fork_call@PLT
	addq	$16, %rsp
	.cfi_adjust_cfa_offset -16
	vmovss	8(%rsp), %xmm0                  # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmovss	%xmm0, 24(%rsp)
	movl	%ebp, 40(%rsp)
	movq	%r12, %rbp
	movq	%r12, 16(%rsp)
	movq	%rbx, 48(%rsp)
	subq	$8, %rsp
	.cfi_adjust_cfa_offset 8
	leaq	48(%rsp), %rcx
	leaq	24(%rsp), %r8
	leaq	32(%rsp), %r9
	leaq	.L__unnamed_1(%rip), %rdi
	movl	$4, %esi
	leaq	add_source.omp_outlined(%rip), %rdx
	xorl	%eax, %eax
	pushq	%r15
	.cfi_adjust_cfa_offset 8
	callq	__kmpc_fork_call@PLT
	addq	$16, %rsp
	.cfi_adjust_cfa_offset -16
	movl	%r13d, %eax
	vcvtsi2ss	%rax, %xmm2, %xmm0
	vmovss	%xmm0, 60(%rsp)                 # 4-byte Spill
	vmulss	%xmm0, %xmm0, %xmm0
	vmovss	32(%rsp), %xmm1                 # 4-byte Reload
                                        # xmm1 = mem[0],zero,zero,zero
	vmulss	8(%rsp), %xmm1, %xmm1           # 4-byte Folded Reload
	vmulss	%xmm1, %xmm0, %xmm0
	vmovss	%xmm0, 32(%rsp)                 # 4-byte Spill
	vmovss	.LCPI5_0(%rip), %xmm1           # xmm1 = [4.0E+0,0.0E+0,0.0E+0,0.0E+0]
	vfmadd213ss	.LCPI5_1(%rip), %xmm0, %xmm1 # xmm1 = (xmm0 * xmm1) + mem
	vmovss	%xmm1, 56(%rsp)                 # 4-byte Spill
	movl	%r13d, %edi
	movl	$1, %esi
	movq	%r14, %rdx
	movq	64(%rsp), %r12                  # 8-byte Reload
	movq	%r12, %rcx
	callq	lin_solve
	movl	%r13d, %edi
	movl	$2, %esi
	movq	%rbx, %rdx
	movq	%rbp, %rcx
	vmovss	32(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmovss	56(%rsp), %xmm1                 # 4-byte Reload
                                        # xmm1 = mem[0],zero,zero,zero
	callq	lin_solve
	movl	%r13d, %edi
	movq	%r14, %rsi
	movq	%rbx, %rdx
	movq	%r12, %rcx
	movq	%rbp, %r8
	callq	project
	movl	%r13d, 12(%rsp)
	movq	%r12, 16(%rsp)
	movq	%r14, 48(%rsp)
	movq	%r14, 24(%rsp)
	movq	%rbx, 40(%rsp)
	vmovss	60(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	8(%rsp), %xmm0, %xmm0           # 4-byte Folded Reload
	vmovss	%xmm0, 8(%rsp)                  # 4-byte Spill
	vmovss	%xmm0, 36(%rsp)
	subq	$8, %rsp
	.cfi_adjust_cfa_offset 8
	leaq	.L__unnamed_2(%rip), %rdi
	leaq	advect.omp_outlined(%rip), %rdx
	leaq	20(%rsp), %rcx
	leaq	44(%rsp), %r8
	leaq	32(%rsp), %r9
	movl	$6, %esi
	xorl	%eax, %eax
	pushq	%r15
	.cfi_adjust_cfa_offset 8
	leaq	32(%rsp), %r15
	pushq	%r15
	.cfi_adjust_cfa_offset 8
	leaq	64(%rsp), %r12
	pushq	%r12
	.cfi_adjust_cfa_offset 8
	callq	__kmpc_fork_call@PLT
	addq	$32, %rsp
	.cfi_adjust_cfa_offset -32
	movl	12(%rsp), %edi
	movq	16(%rsp), %rdx
	movl	$1, %esi
	callq	set_bnd
	movl	%r13d, 12(%rsp)
	movq	%rbp, 16(%rsp)
	movq	%rbx, 48(%rsp)
	movq	%r14, 24(%rsp)
	movq	%rbx, 40(%rsp)
	vmovss	8(%rsp), %xmm0                  # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmovss	%xmm0, 36(%rsp)
	subq	$8, %rsp
	.cfi_adjust_cfa_offset 8
	leaq	20(%rsp), %rcx
	leaq	44(%rsp), %r8
	leaq	32(%rsp), %r9
	leaq	.L__unnamed_2(%rip), %rdi
	movl	$6, %esi
	leaq	advect.omp_outlined(%rip), %rdx
	xorl	%eax, %eax
	leaq	56(%rsp), %r10
	pushq	%r10
	.cfi_adjust_cfa_offset 8
	pushq	%r15
	.cfi_adjust_cfa_offset 8
	pushq	%r12
	.cfi_adjust_cfa_offset 8
	callq	__kmpc_fork_call@PLT
	addq	$32, %rsp
	.cfi_adjust_cfa_offset -32
	movl	12(%rsp), %edi
	movq	16(%rsp), %rdx
	movl	$2, %esi
	callq	set_bnd
	movl	%r13d, %edi
	movq	64(%rsp), %rsi                  # 8-byte Reload
	movq	%rbp, %rdx
	movq	%r14, %rcx
	movq	%rbx, %r8
	callq	project
	addq	$72, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end5:
	.size	vel_step, .Lfunc_end5-vel_step
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function project
.LCPI6_0:
	.long	0x3f800000                      # float 1
.LCPI6_1:
	.long	0x40800000                      # float 4
	.text
	.p2align	4, 0x90
	.type	project,@function
project:                                # @project
	.cfi_startproc
# %bb.0:
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%r12
	.cfi_def_cfa_offset 32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	subq	$40, %rsp
	.cfi_def_cfa_offset 80
	.cfi_offset %rbx, -40
	.cfi_offset %r12, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	movl	%edi, 4(%rsp)
	movq	%rsi, 32(%rsp)
	movq	%rdx, 24(%rsp)
	movq	%rcx, 16(%rsp)
	movq	%r8, 8(%rsp)
	leaq	16(%rsp), %rbx
	leaq	24(%rsp), %r12
	leaq	.L__unnamed_6(%rip), %rdi
	leaq	project.omp_outlined(%rip), %rdx
	leaq	4(%rsp), %r14
	leaq	8(%rsp), %r8
	leaq	32(%rsp), %r15
	movl	$5, %esi
	movq	%r14, %rcx
	movq	%r15, %r9
	xorl	%eax, %eax
	pushq	%rbx
	.cfi_adjust_cfa_offset 8
	pushq	%r12
	.cfi_adjust_cfa_offset 8
	callq	__kmpc_fork_call@PLT
	addq	$16, %rsp
	.cfi_adjust_cfa_offset -16
	movl	4(%rsp), %edi
	movq	8(%rsp), %rdx
	xorl	%esi, %esi
	callq	set_bnd
	movl	4(%rsp), %edi
	movq	16(%rsp), %rdx
	xorl	%esi, %esi
	callq	set_bnd
	movl	4(%rsp), %edi
	movq	16(%rsp), %rdx
	movq	8(%rsp), %rcx
	vmovss	.LCPI6_0(%rip), %xmm0           # xmm0 = [1.0E+0,0.0E+0,0.0E+0,0.0E+0]
	vmovss	.LCPI6_1(%rip), %xmm1           # xmm1 = [4.0E+0,0.0E+0,0.0E+0,0.0E+0]
	xorl	%esi, %esi
	callq	lin_solve
	subq	$8, %rsp
	.cfi_adjust_cfa_offset 8
	leaq	.L__unnamed_7(%rip), %rdi
	leaq	project.omp_outlined.1(%rip), %rdx
	movl	$4, %esi
	movq	%r14, %rcx
	movq	%r15, %r8
	movq	%rbx, %r9
	xorl	%eax, %eax
	pushq	%r12
	.cfi_adjust_cfa_offset 8
	callq	__kmpc_fork_call@PLT
	addq	$16, %rsp
	.cfi_adjust_cfa_offset -16
	movl	4(%rsp), %edi
	movq	32(%rsp), %rdx
	movl	$1, %esi
	callq	set_bnd
	movl	4(%rsp), %edi
	movq	24(%rsp), %rdx
	movl	$2, %esi
	callq	set_bnd
	addq	$40, %rsp
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end6:
	.size	project, .Lfunc_end6-project
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function project.omp_outlined
.LCPI7_0:
	.long	0x3f800000                      # float 1
.LCPI7_3:
	.long	0xbf000000                      # float -0.5
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0
.LCPI7_1:
	.quad	5                               # 0x5
	.quad	6                               # 0x6
	.quad	7                               # 0x7
	.quad	8                               # 0x8
.LCPI7_2:
	.quad	1                               # 0x1
	.quad	2                               # 0x2
	.quad	3                               # 0x3
	.quad	4                               # 0x4
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI7_4:
	.quad	8                               # 0x8
	.text
	.p2align	4, 0x90
	.type	project.omp_outlined,@function
project.omp_outlined:                   # @project.omp_outlined
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$264, %rsp                      # imm = 0x108
	.cfi_def_cfa_offset 320
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%r9, %r14
	movq	%r8, %rbx
	movq	%rcx, %r15
	movq	%rdx, %r13
	callq	omp_get_thread_num@PLT
	movl	%eax, %r12d
	callq	omp_get_num_threads@PLT
	movl	%eax, %ecx
	movl	(%r13), %r8d
	leal	(%rcx,%r8), %eax
	decl	%eax
	xorl	%edx, %edx
	divl	%ecx
	imull	%eax, %r12d
	addl	%r12d, %eax
	cmpl	%r8d, %eax
	cmovael	%r8d, %eax
	incl	%eax
	leal	1(%r12), %ecx
	cmpl	%eax, %ecx
	jae	.LBB7_9
# %bb.1:
	leal	1(%r8), %edx
	movl	%edx, 12(%rsp)                  # 4-byte Spill
	cmpl	$2, %edx
	jb	.LBB7_9
# %bb.2:
	movq	320(%rsp), %r10
	leal	2(%r8), %edx
	movl	%edx, %esi
	shrl	%esi
	movq	(%rbx), %r13
	movq	(%r14), %rdi
	movq	%rdi, 104(%rsp)                 # 8-byte Spill
	movq	(%r15), %r9
	movq	(%r10), %r10
	movl	%r8d, %r8d
	vcvtsi2ss	%r8, %xmm0, %xmm2
	movl	%ecx, %ebx
	movl	%eax, %r8d
	movl	12(%rsp), %r15d                 # 4-byte Reload
	leaq	-1(%r15), %rax
	movq	%rax, 48(%rsp)                  # 8-byte Spill
	andq	$-8, %rax
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	incq	%rax
	movq	%rax, 40(%rsp)                  # 8-byte Spill
	vmovq	%rdx, %xmm0
	vpbroadcastq	%xmm0, %ymm0
	vmovq	%rsi, %xmm1
	vpbroadcastq	%xmm1, %ymm1
	vmovss	.LCPI7_0(%rip), %xmm3           # xmm3 = [1.0E+0,0.0E+0,0.0E+0,0.0E+0]
	vdivss	%xmm2, %xmm3, %xmm4
	vbroadcastss	%xmm4, %ymm6
	vmovss	.LCPI7_3(%rip), %xmm5           # xmm5 = [-5.0E-1,0.0E+0,0.0E+0,0.0E+0]
	vpxor	%xmm7, %xmm7, %xmm7
	movq	%r13, 72(%rsp)                  # 8-byte Spill
	movq	%r8, 64(%rsp)                   # 8-byte Spill
	movq	%r15, 56(%rsp)                  # 8-byte Spill
	vmovaps	%xmm4, 112(%rsp)                # 16-byte Spill
	vmovups	%ymm6, 128(%rsp)                # 32-byte Spill
	jmp	.LBB7_3
	.p2align	4, 0x90
.LBB7_8:                                #   in Loop: Header=BB7_3 Depth=1
	movl	%ebx, %r12d
	leaq	1(%rbx), %rax
	movq	%rax, %rbx
	cmpq	%r8, %rax
	jae	.LBB7_9
.LBB7_3:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB7_5 Depth 2
                                        #     Child Loop BB7_7 Depth 2
	leal	2(%r12), %ebp
	movl	%ebp, %eax
	shrl	%eax
	movl	%r12d, %edi
	shrl	%r12d
	movq	%rbx, %r11
	shrq	%r11
	leaq	(,%rax,4), %r14
	addq	%r13, %r14
	leaq	(%r13,%r12,4), %rax
	movq	%rax, 32(%rsp)                  # 8-byte Spill
	movq	104(%rsp), %rax                 # 8-byte Reload
	leaq	(%rax,%r11,4), %rax
	movl	$1, %r12d
	cmpl	$9, 12(%rsp)                    # 4-byte Folded Reload
	movq	%rdi, 24(%rsp)                  # 8-byte Spill
	jb	.LBB7_7
# %bb.4:                                #   in Loop: Header=BB7_3 Depth=1
	movq	%rbp, 96(%rsp)                  # 8-byte Spill
	vmovq	%rbp, %xmm2
	vpbroadcastq	%xmm2, %ymm2
	vmovdqu	%ymm2, 224(%rsp)                # 32-byte Spill
	vmovq	%rdi, %xmm2
	vpbroadcastq	%xmm2, %ymm2
	vmovdqu	%ymm2, 192(%rsp)                # 32-byte Spill
	movq	%rbx, 80(%rsp)                  # 8-byte Spill
	vmovq	%rbx, %xmm2
	vpbroadcastq	%xmm2, %ymm11
	movq	%r11, 88(%rsp)                  # 8-byte Spill
	vmovq	%r11, %xmm2
	vpbroadcastq	%xmm2, %ymm2
	vmovdqu	%ymm2, 160(%rsp)                # 32-byte Spill
	movq	16(%rsp), %r12                  # 8-byte Reload
	vmovdqa	.LCPI7_2(%rip), %ymm13          # ymm13 = [1,2,3,4]
	vmovdqa	.LCPI7_1(%rip), %ymm14          # ymm14 = [5,6,7,8]
	movq	%r14, %r11
	.p2align	4, 0x90
.LBB7_5:                                #   Parent Loop BB7_3 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmovdqu	224(%rsp), %ymm3                # 32-byte Reload
	vpxor	%ymm3, %ymm14, %ymm2
	vpxor	%ymm3, %ymm13, %ymm3
	vpsllq	$63, %ymm3, %ymm3
	vpcmpgtq	%ymm3, %ymm7, %ymm3
	vpand	%ymm0, %ymm3, %ymm3
	vpsllq	$63, %ymm2, %ymm2
	vpcmpgtq	%ymm2, %ymm7, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpaddq	%ymm2, %ymm14, %ymm2
	vpaddq	%ymm3, %ymm13, %ymm3
	vpmuludq	%ymm1, %ymm3, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	vpmuludq	%ymm1, %ymm3, %ymm3
	vpmuludq	%ymm1, %ymm2, %ymm5
	vpsrlq	$32, %ymm2, %ymm2
	vpmuludq	%ymm1, %ymm2, %ymm2
	vpsllq	$32, %ymm2, %ymm2
	vpaddq	%ymm2, %ymm5, %ymm2
	vxorps	%xmm15, %xmm15, %xmm15
	vpcmpeqd	%xmm5, %xmm5, %xmm5
	vgatherqps	%xmm5, (%r11,%ymm2,4), %xmm15
	vpsllq	$32, %ymm3, %ymm2
	vpaddq	%ymm2, %ymm4, %ymm2
	vxorps	%xmm5, %xmm5, %xmm5
	vpcmpeqd	%xmm3, %xmm3, %xmm3
	vgatherqps	%xmm3, (%r11,%ymm2,4), %xmm5
	vmovdqu	192(%rsp), %ymm3                # 32-byte Reload
	vpxor	%ymm3, %ymm14, %ymm2
	vpxor	%ymm3, %ymm13, %ymm3
	vpsllq	$63, %ymm3, %ymm3
	vpcmpgtq	%ymm3, %ymm7, %ymm3
	vpand	%ymm0, %ymm3, %ymm3
	vpsllq	$63, %ymm2, %ymm2
	vpcmpgtq	%ymm2, %ymm7, %ymm2
	vpand	%ymm0, %ymm2, %ymm2
	vpaddq	%ymm2, %ymm14, %ymm2
	vpaddq	%ymm3, %ymm13, %ymm3
	vpmuludq	%ymm1, %ymm3, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	vpmuludq	%ymm1, %ymm3, %ymm3
	vpxor	%xmm12, %xmm12, %xmm12
	vpmuludq	%ymm1, %ymm2, %ymm6
	vpsrlq	$32, %ymm2, %ymm2
	vpmuludq	%ymm1, %ymm2, %ymm2
	vpsllq	$32, %ymm2, %ymm2
	vpaddq	%ymm2, %ymm6, %ymm2
	vpxor	%xmm6, %xmm6, %xmm6
	vpcmpeqd	%xmm8, %xmm8, %xmm8
	movq	32(%rsp), %rcx                  # 8-byte Reload
	vgatherqps	%xmm8, (%rcx,%ymm2,4), %xmm6
	vpsllq	$32, %ymm3, %ymm2
	vpaddq	%ymm2, %ymm4, %ymm2
	vpxor	%xmm4, %xmm4, %xmm4
	vpcmpeqd	%xmm3, %xmm3, %xmm3
	vgatherqps	%xmm3, (%rcx,%ymm2,4), %xmm4
	vpcmpeqd	%ymm7, %ymm7, %ymm7
	vpsubq	%ymm7, %ymm13, %ymm2
	vpsubq	%ymm7, %ymm14, %ymm3
	vpxor	%ymm3, %ymm11, %ymm8
	vpxor	%ymm2, %ymm11, %ymm9
	vpsllq	$63, %ymm9, %ymm9
	vpcmpgtq	%ymm9, %ymm12, %ymm9
	vpand	%ymm0, %ymm9, %ymm9
	vpsllq	$63, %ymm8, %ymm8
	vpcmpgtq	%ymm8, %ymm12, %ymm8
	vpand	%ymm0, %ymm8, %ymm8
	vpaddq	%ymm3, %ymm8, %ymm3
	vpaddq	%ymm2, %ymm9, %ymm2
	vpmuludq	%ymm1, %ymm2, %ymm8
	vpsrlq	$32, %ymm2, %ymm2
	vpmuludq	%ymm1, %ymm2, %ymm2
	vpmuludq	%ymm1, %ymm3, %ymm9
	vpsrlq	$32, %ymm3, %ymm3
	vpmuludq	%ymm1, %ymm3, %ymm3
	vpsllq	$32, %ymm3, %ymm3
	vpaddq	%ymm3, %ymm9, %ymm9
	vpxor	%xmm3, %xmm3, %xmm3
	vpcmpeqd	%xmm10, %xmm10, %xmm10
	vgatherqps	%xmm10, (%rax,%ymm9,4), %xmm3
	vpsllq	$32, %ymm2, %ymm2
	vpaddq	%ymm2, %ymm8, %ymm8
	vpxor	%xmm2, %xmm2, %xmm2
	vpcmpeqd	%xmm9, %xmm9, %xmm9
	vgatherqps	%xmm9, (%rax,%ymm8,4), %xmm2
	vpaddq	%ymm7, %ymm14, %ymm8
	vpxor	%ymm11, %ymm8, %ymm9
	vpsllq	$63, %ymm9, %ymm9
	vpcmpgtq	%ymm9, %ymm12, %ymm9
	vpand	%ymm0, %ymm9, %ymm9
	vpaddq	%ymm8, %ymm9, %ymm8
	vpmuludq	%ymm1, %ymm8, %ymm9
	vpsrlq	$32, %ymm8, %ymm8
	vpmuludq	%ymm1, %ymm8, %ymm8
	vpsllq	$32, %ymm8, %ymm8
	vpaddq	%ymm8, %ymm9, %ymm8
	vpxor	%xmm9, %xmm9, %xmm9
	vpcmpeqd	%xmm10, %xmm10, %xmm10
	vgatherqps	%xmm10, (%rax,%ymm8,4), %xmm9
	vpaddq	%ymm7, %ymm13, %ymm8
	vpxor	%ymm11, %ymm8, %ymm10
	vpsllq	$63, %ymm10, %ymm10
	vpcmpgtq	%ymm10, %ymm12, %ymm10
	vpand	%ymm0, %ymm10, %ymm10
	vpaddq	%ymm8, %ymm10, %ymm8
	vpmuludq	%ymm1, %ymm8, %ymm10
	vpsrlq	$32, %ymm8, %ymm8
	vpmuludq	%ymm1, %ymm8, %ymm8
	vpsllq	$32, %ymm8, %ymm8
	vpaddq	%ymm8, %ymm10, %ymm8
	vpxor	%xmm10, %xmm10, %xmm10
	vpcmpeqd	%xmm12, %xmm12, %xmm12
	vgatherqps	%xmm12, (%rax,%ymm8,4), %xmm10
	vinsertf128	$1, %xmm15, %ymm5, %ymm5
	vinsertf128	$1, %xmm6, %ymm4, %ymm4
	vmovups	128(%rsp), %ymm6                # 32-byte Reload
	vpxor	%xmm7, %xmm7, %xmm7
	vinsertf128	$1, %xmm3, %ymm2, %ymm2
	vaddps	%ymm2, %ymm5, %ymm2
	vinsertf128	$1, %xmm9, %ymm10, %ymm3
	vaddps	%ymm3, %ymm4, %ymm3
	vsubps	%ymm3, %ymm2, %ymm2
	vbroadcastss	.LCPI7_3(%rip), %ymm3   # ymm3 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
	vmulps	%ymm6, %ymm3, %ymm3
	vmulps	%ymm3, %ymm2, %ymm2
	vpxor	%ymm11, %ymm14, %ymm3
	vpxor	%ymm11, %ymm13, %ymm4
	vpsllq	$63, %ymm4, %ymm4
	vpcmpgtq	%ymm4, %ymm7, %ymm4
	vpand	%ymm0, %ymm4, %ymm4
	vpsllq	$63, %ymm3, %ymm3
	vpcmpgtq	%ymm3, %ymm7, %ymm3
	vpand	%ymm0, %ymm3, %ymm3
	vpaddq	%ymm3, %ymm14, %ymm3
	vpaddq	%ymm4, %ymm13, %ymm4
	vpmuludq	%ymm1, %ymm3, %ymm5
	vpsrlq	$32, %ymm3, %ymm3
	vpmuludq	%ymm1, %ymm3, %ymm3
	vpsllq	$32, %ymm3, %ymm3
	vmovdqu	160(%rsp), %ymm8                # 32-byte Reload
	vpaddq	%ymm5, %ymm8, %ymm5
	vpaddq	%ymm3, %ymm5, %ymm3
	vpmuludq	%ymm1, %ymm4, %ymm5
	vpsrlq	$32, %ymm4, %ymm4
	vpmuludq	%ymm1, %ymm4, %ymm4
	vpsllq	$32, %ymm4, %ymm4
	vpaddq	%ymm5, %ymm8, %ymm5
	vpaddq	%ymm4, %ymm5, %ymm4
	vmovq	%xmm4, %rcx
	vpextrq	$1, %xmm4, %rdi
	vextracti128	$1, %ymm4, %xmm4
	vmovq	%xmm4, %r14
	vpextrq	$1, %xmm4, %r13
	vmovq	%xmm3, %rbp
	vpextrq	$1, %xmm3, %r15
	vextracti128	$1, %ymm3, %xmm3
	vmovq	%xmm3, %r8
	vpextrq	$1, %xmm3, %rbx
	vmovss	%xmm2, (%r9,%rcx,4)
	vextractps	$1, %xmm2, (%r9,%rdi,4)
	vextractps	$2, %xmm2, (%r9,%r14,4)
	vextractps	$3, %xmm2, (%r9,%r13,4)
	vextractf128	$1, %ymm2, %xmm2
	vmovss	%xmm2, (%r9,%rbp,4)
	vextractps	$1, %xmm2, (%r9,%r15,4)
	vextractps	$2, %xmm2, (%r9,%r8,4)
	vextractps	$3, %xmm2, (%r9,%rbx,4)
	movl	$0, (%r10,%rcx,4)
	movl	$0, (%r10,%rdi,4)
	movl	$0, (%r10,%r14,4)
	movl	$0, (%r10,%r13,4)
	movl	$0, (%r10,%rbp,4)
	movl	$0, (%r10,%r15,4)
	vpbroadcastq	.LCPI7_4(%rip), %ymm2   # ymm2 = [8,8,8,8]
	vpaddq	%ymm2, %ymm13, %ymm13
	vpaddq	%ymm2, %ymm14, %ymm14
	movl	$0, (%r10,%r8,4)
	movl	$0, (%r10,%rbx,4)
	addq	$-8, %r12
	jne	.LBB7_5
# %bb.6:                                #   in Loop: Header=BB7_3 Depth=1
	movq	40(%rsp), %r12                  # 8-byte Reload
	movq	16(%rsp), %rcx                  # 8-byte Reload
	cmpq	%rcx, 48(%rsp)                  # 8-byte Folded Reload
	movq	72(%rsp), %r13                  # 8-byte Reload
	movq	64(%rsp), %r8                   # 8-byte Reload
	movq	56(%rsp), %r15                  # 8-byte Reload
	vmovaps	112(%rsp), %xmm4                # 16-byte Reload
	vmovss	.LCPI7_3(%rip), %xmm5           # xmm5 = [-5.0E-1,0.0E+0,0.0E+0,0.0E+0]
	movq	96(%rsp), %rbp                  # 8-byte Reload
	movq	24(%rsp), %rdi                  # 8-byte Reload
	movq	%r11, %r14
	movq	88(%rsp), %r11                  # 8-byte Reload
	movq	80(%rsp), %rbx                  # 8-byte Reload
	je	.LBB7_8
	.p2align	4, 0x90
.LBB7_7:                                #   Parent Loop BB7_3 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	%r12d, %ecx
	xorl	%ebp, %ecx
	andl	$1, %ecx
	negl	%ecx
	andl	%edx, %ecx
	addq	%r12, %rcx
	imulq	%rsi, %rcx
	vmovss	(%r14,%rcx,4), %xmm2            # xmm2 = mem[0],zero,zero,zero
	movl	%r12d, %ecx
	xorl	%edi, %ecx
	andl	$1, %ecx
	negl	%ecx
	andl	%edx, %ecx
	addq	%r12, %rcx
	imulq	%rsi, %rcx
	movq	32(%rsp), %rdi                  # 8-byte Reload
	vmovss	(%rdi,%rcx,4), %xmm3            # xmm3 = mem[0],zero,zero,zero
	leaq	1(%r12), %rcx
	movl	%ecx, %edi
	xorl	%ebx, %edi
	andl	$1, %edi
	negl	%edi
	andl	%edx, %edi
	addq	%r12, %rdi
	incq	%rdi
	imulq	%rsi, %rdi
	vaddss	(%rax,%rdi,4), %xmm2, %xmm2
	leal	-2(%rcx), %edi
	xorl	%ebx, %edi
	andl	$1, %edi
	negl	%edi
	andl	%edx, %edi
	addq	%r12, %rdi
	decq	%rdi
	imulq	%rsi, %rdi
	vaddss	(%rax,%rdi,4), %xmm3, %xmm3
	leal	-1(%rcx), %edi
	xorl	%ebx, %edi
	andl	$1, %edi
	negl	%edi
	andl	%edx, %edi
	addq	%r12, %rdi
	vsubss	%xmm3, %xmm2, %xmm2
	vmulss	%xmm5, %xmm2, %xmm2
	vmulss	%xmm4, %xmm2, %xmm2
	imulq	%rsi, %rdi
	addq	%r11, %rdi
	vmovss	%xmm2, (%r9,%rdi,4)
	movl	$0, (%r10,%rdi,4)
	movq	24(%rsp), %rdi                  # 8-byte Reload
	movq	%rcx, %r12
	cmpq	%r15, %rcx
	jne	.LBB7_7
	jmp	.LBB7_8
.LBB7_9:
	addq	$264, %rsp                      # imm = 0x108
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	vzeroupper
	retq
.Lfunc_end7:
	.size	project.omp_outlined, .Lfunc_end7-project.omp_outlined
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function project.omp_outlined.1
.LCPI8_0:
	.long	0x3f000000                      # float 0.5
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0
.LCPI8_1:
	.quad	5                               # 0x5
	.quad	6                               # 0x6
	.quad	7                               # 0x7
	.quad	8                               # 0x8
.LCPI8_2:
	.quad	1                               # 0x1
	.quad	2                               # 0x2
	.quad	3                               # 0x3
	.quad	4                               # 0x4
.LCPI8_4:
	.zero	32
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI8_3:
	.quad	8                               # 0x8
	.text
	.p2align	4, 0x90
	.type	project.omp_outlined.1,@function
project.omp_outlined.1:                 # @project.omp_outlined.1
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$312, %rsp                      # imm = 0x138
	.cfi_def_cfa_offset 368
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%r9, %r14
	movq	%r8, %r12
	movq	%rcx, %r15
	movq	%rdx, %r13
	callq	omp_get_thread_num@PLT
	movl	%eax, %ebx
	callq	omp_get_num_threads@PLT
	movl	%eax, %ecx
	movl	(%r13), %r13d
	leal	(%rcx,%r13), %eax
	decl	%eax
	xorl	%edx, %edx
	divl	%ecx
	imull	%eax, %ebx
	addl	%ebx, %eax
	cmpl	%r13d, %eax
	cmovael	%r13d, %eax
	incl	%eax
	leal	1(%rbx), %esi
	cmpl	%eax, %esi
	jae	.LBB8_9
# %bb.1:
	testl	%r13d, %r13d
	je	.LBB8_9
# %bb.2:
	leal	2(%r13), %ecx
	movl	%ecx, %edx
	movl	%r13d, %edi
	vcvtsi2ss	%rdi, %xmm0, %xmm0
	shrl	%edx
	vmulss	.LCPI8_0(%rip), %xmm0, %xmm3
	movq	(%r12), %r12
	movq	(%r15), %r8
	movq	(%r14), %r9
	incl	%r13d
	cmpl	$3, %r13d
	movl	$2, %r14d
	cmovael	%r13d, %r14d
	movl	%esi, %r11d
	movl	%eax, %ebp
	leaq	-1(%r14), %rax
	movq	%rax, 56(%rsp)                  # 8-byte Spill
	andq	$-8, %rax
	movq	%rax, (%rsp)                    # 8-byte Spill
	incq	%rax
	movq	%rax, 48(%rsp)                  # 8-byte Spill
	vmovq	%rcx, %xmm0
	vpbroadcastq	%xmm0, %ymm6
	vmovq	%rdx, %xmm0
	vpbroadcastq	%xmm0, %ymm2
	vbroadcastss	%xmm3, %ymm4
	movq	%r13, 88(%rsp)                  # 8-byte Spill
	vmovaps	%xmm3, 96(%rsp)                 # 16-byte Spill
	movq	%r12, 80(%rsp)                  # 8-byte Spill
	movq	%r14, 72(%rsp)                  # 8-byte Spill
	movq	%rbp, 64(%rsp)                  # 8-byte Spill
	vmovups	%ymm4, 112(%rsp)                # 32-byte Spill
	jmp	.LBB8_4
	.p2align	4, 0x90
.LBB8_3:                                #   in Loop: Header=BB8_4 Depth=1
	movl	%r11d, %ebx
	leaq	1(%r11), %rax
	movq	%rax, %r11
	cmpq	%rbp, %rax
	jae	.LBB8_9
.LBB8_4:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB8_6 Depth 2
                                        #     Child Loop BB8_8 Depth 2
	leal	2(%rbx), %r10d
	movl	%r10d, %eax
	shrl	%eax
	movl	%ebx, %r15d
	shrl	%ebx
	movq	%r11, %rsi
	shrq	%rsi
	leaq	(%r12,%rax,4), %rax
	movq	%rax, 40(%rsp)                  # 8-byte Spill
	leaq	(%r12,%rbx,4), %rax
	movq	%rax, 32(%rsp)                  # 8-byte Spill
	movq	%rsi, %rbx
	leaq	(%r12,%rsi,4), %rax
	movl	$1, %esi
	cmpl	$9, %r13d
	movq	%r10, 24(%rsp)                  # 8-byte Spill
	movq	%r15, 16(%rsp)                  # 8-byte Spill
	movq	%rbx, 8(%rsp)                   # 8-byte Spill
	jb	.LBB8_8
# %bb.5:                                #   in Loop: Header=BB8_4 Depth=1
	vmovq	%r10, %xmm0
	vpbroadcastq	%xmm0, %ymm0
	vmovdqu	%ymm0, 240(%rsp)                # 32-byte Spill
	vmovq	%r15, %xmm0
	vpbroadcastq	%xmm0, %ymm0
	vmovdqu	%ymm0, 208(%rsp)                # 32-byte Spill
	vmovq	%r11, %xmm0
	vpbroadcastq	%xmm0, %ymm0
	vmovdqu	%ymm0, 176(%rsp)                # 32-byte Spill
	vmovq	%rbx, %xmm0
	vpbroadcastq	%xmm0, %ymm0
	vmovdqu	%ymm0, 144(%rsp)                # 32-byte Spill
	movq	(%rsp), %r15                    # 8-byte Reload
	vmovdqa	.LCPI8_2(%rip), %ymm12          # ymm12 = [1,2,3,4]
	vmovdqa	.LCPI8_1(%rip), %ymm13          # ymm13 = [5,6,7,8]
	.p2align	4, 0x90
.LBB8_6:                                #   Parent Loop BB8_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmovdqu	240(%rsp), %ymm3                # 32-byte Reload
	vpxor	%ymm3, %ymm13, %ymm0
	vpxor	%ymm3, %ymm12, %ymm3
	vpsllq	$63, %ymm3, %ymm3
	vxorps	%xmm4, %xmm4, %xmm4
	vpcmpgtq	%ymm3, %ymm4, %ymm3
	vpand	%ymm6, %ymm3, %ymm3
	vpsllq	$63, %ymm0, %ymm0
	vpcmpgtq	%ymm0, %ymm4, %ymm0
	vpxor	%xmm10, %xmm10, %xmm10
	vpand	%ymm6, %ymm0, %ymm0
	vpaddq	%ymm0, %ymm13, %ymm0
	vpaddq	%ymm3, %ymm12, %ymm3
	vpmuludq	%ymm2, %ymm3, %ymm4
	vpsrlq	$32, %ymm3, %ymm3
	vpmuludq	%ymm2, %ymm0, %ymm7
	vpmuludq	%ymm2, %ymm3, %ymm3
	vpsrlq	$32, %ymm0, %ymm0
	vpmuludq	%ymm2, %ymm0, %ymm0
	vpcmpeqd	%xmm14, %xmm14, %xmm14
	vxorps	%xmm5, %xmm5, %xmm5
	vpcmpeqd	%xmm8, %xmm8, %xmm8
	vpsllq	$32, %ymm3, %ymm3
	vxorps	%xmm15, %xmm15, %xmm15
	vmovdqu	208(%rsp), %ymm11               # 32-byte Reload
	vpxor	%ymm11, %ymm13, %ymm9
	vpxor	%ymm11, %ymm12, %ymm11
	vpsllq	$63, %ymm11, %ymm11
	vpcmpgtq	%ymm11, %ymm10, %ymm11
	vpsllq	$32, %ymm0, %ymm0
	vpand	%ymm6, %ymm11, %ymm11
	vpsllq	$63, %ymm9, %ymm9
	vpcmpgtq	%ymm9, %ymm10, %ymm9
	vpand	%ymm6, %ymm9, %ymm9
	vpaddq	%ymm13, %ymm9, %ymm9
	vpaddq	%ymm3, %ymm4, %ymm4
	vpaddq	%ymm12, %ymm11, %ymm3
	vpmuludq	%ymm2, %ymm3, %ymm11
	vpsrlq	$32, %ymm3, %ymm3
	vpmuludq	%ymm2, %ymm3, %ymm3
	vpsllq	$32, %ymm3, %ymm3
	vpaddq	%ymm0, %ymm7, %ymm0
	vpaddq	%ymm3, %ymm11, %ymm11
	vpmuludq	%ymm2, %ymm9, %ymm3
	vpsrlq	$32, %ymm9, %ymm7
	vpmuludq	%ymm2, %ymm7, %ymm7
	movq	40(%rsp), %rsi                  # 8-byte Reload
	vgatherqps	%xmm14, (%rsi,%ymm0,4), %xmm5
	vpsllq	$32, %ymm7, %ymm0
	vpaddq	%ymm0, %ymm3, %ymm0
	vpcmpeqd	%xmm9, %xmm9, %xmm9
	vpxor	%xmm3, %xmm3, %xmm3
	vgatherqps	%xmm8, (%rsi,%ymm4,4), %xmm15
	vpcmpeqd	%xmm4, %xmm4, %xmm4
	vpxor	%xmm7, %xmm7, %xmm7
	vmovdqu	176(%rsp), %ymm1                # 32-byte Reload
	vpxor	%ymm1, %ymm12, %ymm8
	vpxor	%ymm1, %ymm13, %ymm14
	vpsllq	$63, %ymm14, %ymm14
	vpcmpgtq	%ymm14, %ymm10, %ymm14
	vpand	%ymm6, %ymm14, %ymm14
	vpsllq	$63, %ymm8, %ymm8
	vpcmpgtq	%ymm8, %ymm10, %ymm8
	vpand	%ymm6, %ymm8, %ymm8
	movq	32(%rsp), %rsi                  # 8-byte Reload
	vgatherqps	%xmm9, (%rsi,%ymm0,4), %xmm3
	vpaddq	%ymm12, %ymm8, %ymm0
	vpaddq	%ymm13, %ymm14, %ymm8
	vpmuludq	%ymm2, %ymm8, %ymm9
	vpsrlq	$32, %ymm8, %ymm8
	vgatherqps	%xmm4, (%rsi,%ymm11,4), %xmm7
	vpmuludq	%ymm2, %ymm8, %ymm4
	vpsllq	$32, %ymm4, %ymm4
	vpmuludq	%ymm2, %ymm0, %ymm8
	vpsrlq	$32, %ymm0, %ymm0
	vpmuludq	%ymm2, %ymm0, %ymm0
	vpsllq	$32, %ymm0, %ymm0
	vmovdqu	144(%rsp), %ymm11               # 32-byte Reload
	vpaddq	%ymm11, %ymm9, %ymm9
	vpaddq	%ymm4, %ymm9, %ymm14
	vpcmpeqd	%xmm4, %xmm4, %xmm4
	vpxor	%xmm9, %xmm9, %xmm9
	vgatherqps	%xmm4, (%r8,%ymm14,4), %xmm9
	vpaddq	%ymm11, %ymm8, %ymm4
	vpaddq	%ymm0, %ymm4, %ymm10
	vpcmpeqd	%xmm0, %xmm0, %xmm0
	vpxor	%xmm8, %xmm8, %xmm8
	vgatherqps	%xmm0, (%r8,%ymm10,4), %xmm8
	vinsertf128	$1, %xmm5, %ymm15, %ymm0
	vpsllq	$2, %ymm14, %ymm4
	vmovdqu	%ymm4, 272(%rsp)                # 32-byte Spill
	vinsertf128	$1, %xmm3, %ymm7, %ymm3
	vmovq	%r8, %xmm5
	vpbroadcastq	%xmm5, %ymm7
	vpaddq	%ymm4, %ymm7, %ymm11
	vpsllq	$2, %ymm10, %ymm5
	vpaddq	%ymm5, %ymm7, %ymm7
	vsubps	%ymm0, %ymm3, %ymm0
	vinsertf128	$1, %xmm9, %ymm8, %ymm3
	vmovq	%xmm7, %rsi
	vpextrq	$1, %xmm7, %rdi
	vextracti128	$1, %ymm7, %xmm7
	vfmadd231ps	112(%rsp), %ymm0, %ymm3 # 32-byte Folded Reload
                                        # ymm3 = (ymm0 * mem) + ymm3
	vmovq	%xmm7, %r10
	vpextrq	$1, %xmm7, %rbp
	vmovq	%xmm11, %r13
	vmovss	%xmm3, (%rsi)
	vpextrq	$1, %xmm11, %rsi
	vextracti128	$1, %ymm11, %xmm0
	vextractps	$1, %xmm3, (%rdi)
	vmovq	%xmm0, %rdi
	vpextrq	$1, %xmm0, %r12
	vextractps	$2, %xmm3, (%r10)
	vpcmpeqd	%ymm4, %ymm4, %ymm4
	vpsubq	%ymm4, %ymm12, %ymm0
	vpsubq	%ymm4, %ymm13, %ymm7
	vpxor	%ymm1, %ymm7, %ymm8
	vextractps	$3, %xmm3, (%rbp)
	vpxor	%ymm1, %ymm0, %ymm9
	vpsllq	$63, %ymm9, %ymm9
	vpxor	%xmm11, %xmm11, %xmm11
	vpcmpgtq	%ymm9, %ymm11, %ymm9
	vpand	%ymm6, %ymm9, %ymm9
	vpsllq	$63, %ymm8, %ymm8
	vextractf128	$1, %ymm3, %xmm3
	vpcmpgtq	%ymm8, %ymm11, %ymm8
	vpand	%ymm6, %ymm8, %ymm8
	vpaddq	%ymm7, %ymm8, %ymm7
	vpaddq	%ymm0, %ymm9, %ymm0
	vmovss	%xmm3, (%r13)
	vpmuludq	%ymm2, %ymm0, %ymm8
	vpsrlq	$32, %ymm0, %ymm0
	vpmuludq	%ymm2, %ymm0, %ymm0
	vextractps	$1, %xmm3, (%rsi)
	vpsllq	$32, %ymm0, %ymm0
	vpaddq	%ymm0, %ymm8, %ymm0
	vpmuludq	%ymm2, %ymm7, %ymm8
	vextractps	$2, %xmm3, (%rdi)
	vpsrlq	$32, %ymm7, %ymm7
	vpmuludq	%ymm2, %ymm7, %ymm7
	vpsllq	$32, %ymm7, %ymm7
	vextractps	$3, %xmm3, (%r12)
	vpaddq	%ymm7, %ymm8, %ymm7
	vpcmpeqd	%xmm8, %xmm8, %xmm8
	vxorps	%xmm3, %xmm3, %xmm3
	vpcmpeqd	%xmm9, %xmm9, %xmm9
	vgatherqps	%xmm8, (%rax,%ymm7,4), %xmm3
	vxorps	%xmm7, %xmm7, %xmm7
	vpaddq	%ymm4, %ymm13, %ymm8
	vpxor	%ymm1, %ymm8, %ymm11
	vpsllq	$63, %ymm11, %ymm11
	vxorps	%xmm15, %xmm15, %xmm15
	vpcmpgtq	%ymm11, %ymm15, %ymm11
	vpand	%ymm6, %ymm11, %ymm11
	vpaddq	%ymm8, %ymm11, %ymm8
	vpmuludq	%ymm2, %ymm8, %ymm11
	vpsrlq	$32, %ymm8, %ymm8
	vpmuludq	%ymm2, %ymm8, %ymm8
	vgatherqps	%xmm9, (%rax,%ymm0,4), %xmm7
	vpsllq	$32, %ymm8, %ymm0
	vpaddq	%ymm0, %ymm11, %ymm0
	vpcmpeqd	%xmm8, %xmm8, %xmm8
	vxorps	%xmm9, %xmm9, %xmm9
	vgatherqps	%xmm8, (%rax,%ymm0,4), %xmm9
	vpaddq	%ymm4, %ymm12, %ymm0
	vpxor	%ymm1, %ymm0, %ymm8
	vpsllq	$63, %ymm8, %ymm8
	vpcmpgtq	%ymm8, %ymm15, %ymm8
	vpand	%ymm6, %ymm8, %ymm8
	vpaddq	%ymm0, %ymm8, %ymm0
	vpsrlq	$32, %ymm0, %ymm8
	vpmuludq	%ymm2, %ymm8, %ymm8
	vpmuludq	%ymm2, %ymm0, %ymm0
	vpsllq	$32, %ymm8, %ymm8
	vpaddq	%ymm0, %ymm8, %ymm0
	vpcmpeqd	%xmm8, %xmm8, %xmm8
	vpxor	%xmm11, %xmm11, %xmm11
	vgatherqps	%xmm8, (%rax,%ymm0,4), %xmm11
	vpcmpeqd	%xmm0, %xmm0, %xmm0
	vxorps	%xmm8, %xmm8, %xmm8
	vgatherqps	%xmm0, (%r9,%ymm14,4), %xmm8
	vpcmpeqd	%xmm0, %xmm0, %xmm0
	vxorps	%xmm14, %xmm14, %xmm14
	vgatherqps	%xmm0, (%r9,%ymm10,4), %xmm14
	vinsertf128	$1, %xmm3, %ymm7, %ymm0
	vinsertf128	$1, %xmm9, %ymm11, %ymm3
	vsubps	%ymm0, %ymm3, %ymm3
	vmovq	%r9, %xmm0
	vpbroadcastq	%xmm0, %ymm0
	vpaddq	272(%rsp), %ymm0, %ymm4         # 32-byte Folded Reload
	vpaddq	%ymm5, %ymm0, %ymm5
	vinsertf128	$1, %xmm8, %ymm14, %ymm0
	vpextrq	$1, %xmm5, %rsi
	vmovq	%xmm5, %rdi
	vextracti128	$1, %ymm5, %xmm5
	vmovq	%xmm5, %r10
	vpextrq	$1, %xmm5, %r12
	vfmadd231ps	112(%rsp), %ymm3, %ymm0 # 32-byte Folded Reload
                                        # ymm0 = (ymm3 * mem) + ymm0
	vmovq	%xmm4, %r13
	vpextrq	$1, %xmm4, %rbp
	vextracti128	$1, %ymm4, %xmm3
	vpextrq	$1, %xmm3, %r14
	vmovq	%xmm3, %rbx
	vmovss	%xmm0, (%rdi)
	vextractps	$1, %xmm0, (%rsi)
	vextractps	$2, %xmm0, (%r10)
	vextractps	$3, %xmm0, (%r12)
	vextractf128	$1, %ymm0, %xmm0
	vmovss	%xmm0, (%r13)
	vextractps	$1, %xmm0, (%rbp)
	vextractps	$2, %xmm0, (%rbx)
	vextractps	$3, %xmm0, (%r14)
	vpbroadcastq	.LCPI8_3(%rip), %ymm0   # ymm0 = [8,8,8,8]
	vpaddq	%ymm0, %ymm12, %ymm12
	vpaddq	%ymm0, %ymm13, %ymm13
	addq	$-8, %r15
	jne	.LBB8_6
# %bb.7:                                #   in Loop: Header=BB8_4 Depth=1
	movq	48(%rsp), %rsi                  # 8-byte Reload
	movq	(%rsp), %rdi                    # 8-byte Reload
	cmpq	%rdi, 56(%rsp)                  # 8-byte Folded Reload
	movq	88(%rsp), %r13                  # 8-byte Reload
	vmovaps	96(%rsp), %xmm3                 # 16-byte Reload
	movq	80(%rsp), %r12                  # 8-byte Reload
	movq	72(%rsp), %r14                  # 8-byte Reload
	movq	64(%rsp), %rbp                  # 8-byte Reload
	movq	24(%rsp), %r10                  # 8-byte Reload
	movq	16(%rsp), %r15                  # 8-byte Reload
	movq	8(%rsp), %rbx                   # 8-byte Reload
	je	.LBB8_3
	.p2align	4, 0x90
.LBB8_8:                                #   Parent Loop BB8_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	%esi, %edi
	xorl	%r10d, %edi
	andl	$1, %edi
	negl	%edi
	andl	%ecx, %edi
	addq	%rsi, %rdi
	imulq	%rdx, %rdi
	movl	%esi, %r10d
	xorl	%r15d, %r10d
	andl	$1, %r10d
	negl	%r10d
	andl	%ecx, %r10d
	addq	%rsi, %r10
	imulq	%rdx, %r10
	movq	32(%rsp), %r15                  # 8-byte Reload
	vmovss	(%r15,%r10,4), %xmm0            # xmm0 = mem[0],zero,zero,zero
	movq	40(%rsp), %r10                  # 8-byte Reload
	vsubss	(%r10,%rdi,4), %xmm0, %xmm0
	movl	%esi, %r15d
	xorl	%r11d, %r15d
	andl	$1, %r15d
	negl	%r15d
	andl	%ecx, %r15d
	addq	%rsi, %r15
	imulq	%rdx, %r15
	addq	%rbx, %r15
	vfmadd213ss	(%r8,%r15,4), %xmm3, %xmm0 # xmm0 = (xmm3 * xmm0) + mem
	vmovss	%xmm0, (%r8,%r15,4)
	leaq	1(%rsi), %rdi
	movl	%edi, %r10d
	xorl	%r11d, %r10d
	andl	$1, %r10d
	negl	%r10d
	andl	%ecx, %r10d
	addq	%rsi, %r10
	incq	%r10
	leal	-2(%rdi), %ebx
	xorl	%r11d, %ebx
	andl	$1, %ebx
	negl	%ebx
	andl	%ecx, %ebx
	addq	%rbx, %rsi
	decq	%rsi
	movq	8(%rsp), %rbx                   # 8-byte Reload
	imulq	%rdx, %rsi
	vmovss	(%rax,%rsi,4), %xmm0            # xmm0 = mem[0],zero,zero,zero
	imulq	%rdx, %r10
	vsubss	(%rax,%r10,4), %xmm0, %xmm0
	movq	24(%rsp), %r10                  # 8-byte Reload
	vfmadd213ss	(%r9,%r15,4), %xmm3, %xmm0 # xmm0 = (xmm3 * xmm0) + mem
	vmovss	%xmm0, (%r9,%r15,4)
	movq	16(%rsp), %r15                  # 8-byte Reload
	movq	%rdi, %rsi
	cmpq	%r14, %rdi
	jne	.LBB8_8
	jmp	.LBB8_3
.LBB8_9:
	addq	$312, %rsp                      # imm = 0x138
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	vzeroupper
	retq
.Lfunc_end8:
	.size	project.omp_outlined.1, .Lfunc_end8-project.omp_outlined.1
	.cfi_endproc
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"threadId: %d\n"
	.size	.L.str, 14

	.type	.L__unnamed_8,@object           # @0
.L__unnamed_8:
	.asciz	";src/solver.c;add_source;58;7;;"
	.size	.L__unnamed_8, 32

	.type	.L__unnamed_3,@object           # @1
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L__unnamed_3:
	.long	0                               # 0x0
	.long	514                             # 0x202
	.long	0                               # 0x0
	.long	31                              # 0x1f
	.quad	.L__unnamed_8
	.size	.L__unnamed_3, 24

	.type	.L__unnamed_9,@object           # @2
	.section	.rodata.str1.1,"aMS",@progbits,1
.L__unnamed_9:
	.asciz	";src/solver.c;add_source;58;22;;"
	.size	.L__unnamed_9, 33

	.type	.L__unnamed_4,@object           # @3
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L__unnamed_4:
	.long	0                               # 0x0
	.long	514                             # 0x202
	.long	0                               # 0x0
	.long	32                              # 0x20
	.quad	.L__unnamed_9
	.size	.L__unnamed_4, 24

	.type	.L__unnamed_5,@object           # @4
	.p2align	3, 0x0
.L__unnamed_5:
	.long	0                               # 0x0
	.long	66                              # 0x42
	.long	0                               # 0x0
	.long	31                              # 0x1f
	.quad	.L__unnamed_8
	.size	.L__unnamed_5, 24

	.type	.L__unnamed_10,@object          # @5
	.section	.rodata.str1.1,"aMS",@progbits,1
.L__unnamed_10:
	.asciz	";src/solver.c;add_source;55;5;;"
	.size	.L__unnamed_10, 32

	.type	.L__unnamed_1,@object           # @6
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L__unnamed_1:
	.long	0                               # 0x0
	.long	2                               # 0x2
	.long	0                               # 0x0
	.long	31                              # 0x1f
	.quad	.L__unnamed_10
	.size	.L__unnamed_1, 24

	.type	.L__unnamed_11,@object          # @7
	.section	.rodata.str1.1,"aMS",@progbits,1
.L__unnamed_11:
	.asciz	";src/solver.c;advect;202;5;;"
	.size	.L__unnamed_11, 29

	.type	.L__unnamed_2,@object           # @8
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L__unnamed_2:
	.long	0                               # 0x0
	.long	2                               # 0x2
	.long	0                               # 0x0
	.long	28                              # 0x1c
	.quad	.L__unnamed_11
	.size	.L__unnamed_2, 24

	.type	.L__unnamed_12,@object          # @9
	.section	.rodata.str1.1,"aMS",@progbits,1
.L__unnamed_12:
	.asciz	";src/solver.c;project;232;5;;"
	.size	.L__unnamed_12, 30

	.type	.L__unnamed_6,@object           # @10
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L__unnamed_6:
	.long	0                               # 0x0
	.long	2                               # 0x2
	.long	0                               # 0x0
	.long	29                              # 0x1d
	.quad	.L__unnamed_12
	.size	.L__unnamed_6, 24

	.type	.L__unnamed_13,@object          # @11
	.section	.rodata.str1.1,"aMS",@progbits,1
.L__unnamed_13:
	.asciz	";src/solver.c;project;251;5;;"
	.size	.L__unnamed_13, 30

	.type	.L__unnamed_7,@object           # @12
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L__unnamed_7:
	.long	0                               # 0x0
	.long	2                               # 0x2
	.long	0                               # 0x0
	.long	29                              # 0x1d
	.quad	.L__unnamed_13
	.size	.L__unnamed_7, 24

	.ident	"Ubuntu clang version 18.1.3 (1ubuntu1)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym add_source.omp_outlined
	.addrsig_sym advect.omp_outlined
	.addrsig_sym project.omp_outlined
	.addrsig_sym project.omp_outlined.1
