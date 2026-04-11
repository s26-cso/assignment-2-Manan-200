.text
.globl make_node
make_node:
    addi sp, sp, -32
    sd ra, 0(sp)
    sd s0, 8(sp)

    mv s0, a0 # s0 = val

    li a0, 24 # 24 bytes (val: 8, left: 8, right: 8)
    call malloc # a0 = pointer to new node

    sw s0, 0(a0) # node->val = val
    sd x0, 8(a0) # node->left = NULL
    sd x0, 16(a0) # node->right = NULL

    ld ra, 0(sp)
    ld s0, 8(sp)
    addi sp, sp, 32
    ret

.globl insert
insert:
    addi sp, sp, -32
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)

    mv s0, a0 # s0 = root ptr
    mv s1, a1 # s1 = val

    beqz s0, insert_null # basecase

    lw t0, 0(s0) # t0 = root->val
    blt s1, t0, go_left
    bge s1, t0, go_right

go_left:
    ld a0, 8(s0) # a0 = root->left
    mv a1, s1
    call insert
    sd a0, 8(s0) # root->left = insert(root->left, val)
    mv a0, s0 # return root
    j insert_done

go_right:
    ld a0, 16(s0)
    mv a1, s1
    call insert
    sd a0, 16(s0)
    mv a0, s0
    j insert_done

insert_null:
    mv a0, s1
    call make_node

insert_done:
    ld ra, 0(sp)
    ld s0, 8(sp)
    ld s1, 16(sp)
    ld s2, 24(sp)
    addi sp, sp, 32
    ret

.globl get
get:
    addi sp, sp, -24
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)

    mv s0, a0 # s0 = root
    mv s1, a1 # s1 = val

    beqz s0, get_null # if root == NULL: return NULL

    lw t0, 0(s0) # t0 = root->val
    beq s1, t0, get_found
    blt s1, t0, get_left

get_right:
    ld a0, 16(s0) # a0 = root->right
    mv a1, s1
    call get
    j get_done

get_left:
    ld a0, 8(s0)
    mv a1, s1
    call get
    j get_done

get_null:
    li a0, 0 # return NULL
    j get_done

get_found:
    mv a0, s0 # return root

get_done:
    ld ra, 0(sp)
    ld s0, 8(sp)
    ld s1, 16(sp)
    addi sp, sp, 24
    ret

.globl getAtMost
getAtMost:
    addi sp, sp, -32
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)
    sd s2, 24(sp)

    mv s0, a0 # s0 = val
    mv s1, a1 # s1 = root

    beqz s1, getAtMost_null

    lw t0, 0(s1) # t0 = root->val
    beq s0, t0, getAtMost_found # if val == root->val: return val
    blt s0, t0, getAtMost_left # if val < root->val: go left

getAtMost_right:
    mv s2, t0 # s2 = current best answer = root->val
    mv a0, s0
    ld a1, 16(s1) # a1 = root->right
    call getAtMost
    li t0, -1
    bne a0, t0, getAtMost_done
    mv a0, s2
    j getAtMost_done

getAtMost_left:
    mv a0, s0
    ld a1, 8(s1) # a1 = root->left
    call getAtMost
    j getAtMost_done

getAtMost_null:
    li a0, -1
    j getAtMost_done

getAtMost_found:
    mv a0, s0 # return val

getAtMost_done:
    ld ra, 0(sp)
    ld s0, 8(sp)
    ld s1, 16(sp)
    ld s2, 24(sp)
    addi sp, sp, 32
    ret
