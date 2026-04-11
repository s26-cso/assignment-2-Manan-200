.section .rodata
file_name:
    .string "input.txt"
method:
    .string "r"
print_num:
    .string "%d\n"

.text
.globl main
main:
    addi sp, sp, -64
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)
    sd s3, 24(sp)
    sd s4, 32(sp)
    sd s5, 40(sp)
    sd s7, 48(sp)
    sd s8, 56(sp)

    lla a0, file_name
    lla a1, method
    call fopen

    mv s1, a0 # const file handle in s0

    li s0, 0 # const s0 = n - 1 (length)

len_loop:
    mv a0, s1
    call fgetc
    li t0, -1
    beq a0, t0, len_done
    addi s0, s0, 1
    j len_loop

len_done:
    addi s0, s0, -1
    li s3, 0 # s3 = ptr1
    mv s4, s0 # s4 = ptr2
    li s5, 1 # s5 = isPalindrome

palin_loop:
    ble s4, s3, palin_done
    mv a0, s1
    mv a1, s3
    mv a2, x0
    call fseek
    mv a0, s1
    call fgetc
    mv s7, a0

    mv a0, s1
    mv a1, s4
    mv a2, x0
    call fseek
    mv a0, s1
    call fgetc
    mv s8, a0

    bne s8, s7, not_palin
    addi s3, s3, 1
    addi s4, s4, -1
    j palin_loop

not_palin:
    li s5, 0

palin_done:
    lla a0, print_num
    mv a1, s5
    call printf

    ld ra, 0(sp)
    ld s0, 8(sp)
    ld s1, 16(sp)
    ld s3, 24(sp)
    ld s4, 32(sp)
    ld s5, 40(sp)
    ld s7, 48(sp)
    ld s8, 56(sp)
    addi sp, sp, 64
    ret
