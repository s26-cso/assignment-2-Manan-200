.section .rodata
fmt_out:
    .string "%lld "
newline:
    .string "\n"
.text
.globl main
main:
    addi sp, sp, -16
    sd ra, 0(sp)

    addi s5, a0, -1 # s5 = n
    addi a1, a1, 8 # skip argv[0]
    mv s4, a1 # s4 = argv ptr

    slli a0, s5, 3 # n * 8
    call malloc
    mv s3, a0 # s3 = arr ptr
    mv s7, a0 # s7 = arr base

    slli a0, s5, 3
    call malloc
    mv s6, a0 # s6 = result base

    slli a0, s5, 3
    call malloc
    mv s0, a0 # s0 = stack top
    mv s1, a0 # s1 = stack base

    mv s2, s5 # s2 = counter

arg_loop:
    beqz s2, arg_done
    ld a0, 0(s4)
    call atoi
    sd a0, 0(s3)
    addi s4, s4, 8 # argv ptr++
    addi s3, s3, 8 # arr ptr++
    addi s2, s2, -1 # n--
    j arg_loop

arg_done:
    mv s3, s6 # s3 = &result[0]
    mv s2, s5
init_loop:
    beqz s2, algo
    li t0, -1
    sd t0, 0(s3)
    addi s3, s3, 8
    addi s2, s2, -1
    j init_loop

algo:
    addi s2, s5, -1 # i = n - 1
algo_loop:
    bltz s2, done_algo
while_loop:
    call is_empty
    bnez a0, while_done
    call top
    slli t0, a0, 3
    add t0, t0, s7 # &arr[top]
    ld t1, 0(t0) # t1 = arr[top]
    slli t0, s2, 3
    add t2, t0, s7 # &arr[i]
    ld t2, 0(t2) # t2 = arr[i]
    bgt t1, t2, while_done
    call pop
    j while_loop

while_done:
    call is_empty
    bnez a0, skip_assign
    call top
    slli t0, s2, 3
    add t1, t0, s6 # &result[i]
    sd a0, 0(t1) # result[i] = top()
skip_assign:
    mv a0, s2
    call push
    addi s2, s2, -1 # i--
    j algo_loop

done_algo:
    mv s3, s6 # s3 = &result[0]
    mv s2, s5
print_result:
    beqz s2, done
    lla a0, fmt_out
    ld a1, 0(s3)
    call printf
    addi s3, s3, 8
    addi s2, s2, -1
    j print_result

done:
    lla a0, newline
    call printf
    ld ra, 0(sp)
    addi sp, sp, 16
    ret

top:
    ld a0, -8(s0)
    ret

push:
    sd a0, 0(s0)
    addi s0, s0, 8
    ret

pop:
    addi s0, s0, -8
    ld a0, 0(s0)
    ret

is_empty:
    beq s0, s1, is_empty_true
    li a0, 0
    ret
is_empty_true:
    li a0, 1
    ret
