.section .rodata
fmt_out:
    .string "%lld "
newline:
    .string "\n"

.section .bss
arr:
    .space 400
result:
    .space 400
stack:
    .space 400

.text
.globl main
main:
    addi sp, sp, -16
    sd ra, 0(sp)

    lla s0, stack # stack stored in s0

    addi s2, a0, -1 # var s2 = n = argc - 1 (exclude program name)
    addi a1, a1, 8 # skip argv[0] (program name)
    mv s5, s2 # const s5 = n

    lla s3, arr # var s3 = &arr[0]
    mv s4, a1 # var s4 = argv ptr

arg_loop:
    beqz s2, arg_done # input reading done
    ld a0, 0(s4) # a0 = argv[i] (pointer to string)
    call atoi # convert string to integer
    sd a0, 0(s3) # arr[i] = atoi(argv[i])
    addi s4, s4, 8 # argv ptr++
    addi s3, s3, 8 # arr ptr++
    addi s2, s2, -1 # n--
    j arg_loop

arg_done:

initResult:
    lla s3, result # var s3 = &result[0]
    mv s2, s5 # var s2 = n
initLoop:
    beqz s2, algo
    li t0, -1
    sd t0, 0(s3)
    addi s3, s3, 8
    addi s2, s2, -1
    j initLoop
algo:
    addi s2, s5, -1 # var s2 = n - 1

algo_loop:
    bltz s2, done_algo # if s2 < 0: done

while_loop:
    call is_empty
    bnez a0, while_done

    # get stack.top()
    call top
    slli t0, a0, 3 # t0 = 2 * 8 = 16
    lla t1, arr
    add t1, t1, t0
    ld t1, 0(t1) # t1 = arr[2]

    # get arr[i]
    slli t0, s2, 3 # t0 = i * 8
    lla t2, arr
    add t2, t2, t0 # t2 = &arr[i]
    ld t2, 0(t2) # t2 = arr[i]

    bgt t1, t2, while_done
    call pop
    j while_loop

while_done:
    # i f !is_empty: result[i] = top()
    call is_empty
    bnez a0, skip_assign

    call top # a0 = top index
    slli t0, s2, 3 # t0 = i * 8
    lla t1, result
    add t1, t1, t0 # t1 = &result[i]
    sd a0, 0(t1) # result = top()

skip_assign:
    mv a0, s2 # push i
    call push

    addi s2, s2, -1 # i--
    j algo_loop

done_algo:
    lla s3, result # var s3 = &result[0]
    mv s2, s5 # var s2 = n (counter)
pirnt_result:
    beqz s2, done
    lla a0, fmt_out
    ld a1, 0(s3)
    call printf
    addi s3, s3, 8
    addi s2, s2, -1
    j pirnt_result

done:
    lla a0, newline
    call printf
    ld ra, 0(sp)
    addi sp, sp, 16
    ret

# FUNCTIONS
top:
    addi sp, sp, -16
    sd ra, 0(sp)
    
    ld a0, -8(s0)

    ld ra, 0(sp)
    addi sp, sp, 16
    ret

push:
    addi sp, sp, -16
    sd ra, 0(sp)

    sd a0, 0(s0)
    addi s0, s0, 8;

    ld ra, 0(sp)
    addi sp, sp, 16
    ret

pop:
    addi s0, s0, -8
    ld a0, 0(s0)
    ret

is_empty:
    addi sp, sp, -16
    sd ra, 0(sp)

    lla t0, stack
    beq s0, t0, isEmptyTrue
    li a0, 0

exitIsEmpty:
    ld ra, 0(sp)
    addi sp, sp, 16
    ret

isEmptyTrue:
    li a0, 1
    j exitIsEmpty
