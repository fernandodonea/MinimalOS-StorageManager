.data
    nrOp: .long 0
    index_main: .long 0
    Op: .long 0

    nrFis: .long 0
    index_citire_add_loop: .long 0
    id: .long 0
    dim: .long 0

    blocksNec: .long 0
    blocksDisp: .long 0
    start: .long 0
    end: .long 0
    ok: .long 0
    index_verificare_memorie: .long 0

    v_i: .long 0
    v_iplus1: .long 0
    index_delete: .long 0

    index_defragmentation: .long 0
    ct: .long 0

    aux: .space 4096
    v: .space 4096
    fr: .space 1024
    st: .space 1024
    dr: .space 1024
    

    formatRead: .asciz "%d"
    formatAfisAdd: .asciz "%d: (%d, %d)\n"
    formatAfisDejaExista: .asciz "%d: (0, 0)\n";
    formatAfisGet: .asciz "(%d, %d)\n"


    formatAfis2: .asciz "%d "
    formatNewLine: .asciz "\n"

.text
.global main


//OPERATIA ADD

et_citire_add:

    //citire numar fisiere
    pushl $nrFis
    pushl $formatRead
    call scanf
    addl $8, %esp

    movl $0, index_citire_add_loop


et_citire_add_loop:

    movl index_citire_add_loop, %ebx
    cmpl nrFis, %ebx
    je et_citire_add_exit

    //citire id si dimensiune
    pushl $id
    pushl $formatRead
    call scanf
    addl $8, %esp

    pushl $dim
    pushl $formatRead
    call scanf
    addl $8, %esp

    //verificare_frecventa fr[id]!=0
    movl id, %ecx
    lea fr, %edi
    movl (%edi,%ecx,4), %ebx

    cmpl $0, %ebx
    jne et_deja_exista


    jmp verificare_memorie


et_post_verificare_memorie:

    cmpl $1, ok
    je et_adaugare


et_cont_citire_add_loop:

    // afisare id : (start, end\n)
    push end
    push start
    push id
    push $formatAfisAdd
    call printf
    addl $16, %esp

    pushl $0
    call fflush
    popl %eax
    
    incl index_citire_add_loop
    jmp et_citire_add_loop


et_citire_add_exit:

    jmp cont_main_loop


et_deja_exista:

    // afisare id : (0, 0\n)
    push id
    push $formatAfisDejaExista
    call printf
    addl $8, %esp

    pushl $0
    call fflush
    popl %eax

    jmp et_citire_add_exit


verificare_memorie:

    //blocksNec = (dim+7)/8
    movl $8, %ebx
    movl dim, %eax
    xorl %edx, %edx
    addl $7, %eax
    divl %ebx
    movl %eax, blocksNec
    
    //blocksDisp=0
    movl $0, blocksDisp

    //ok=false
    movl $0, ok

    movl $0, start
    movl $0, end

    lea v, %edi
    movl $0, index_verificare_memorie


verificare_memorie_loop:
    
    cmpl $1024, index_verificare_memorie
    je verificare_memorie_exit

    movl index_verificare_memorie, %ecx
    movl (%edi,%ecx,4),%ebx

    // if v[i]==0
    cmpl $0, %ebx
    je et_block_liber
    jmp et_block_ocupat


et_block_liber:

    cmpl $0, blocksDisp
    je et_block_liber_initializare

    jmp et_block_liber_incrementare


et_block_liber_initializare:

    //start=i
    movl index_verificare_memorie, %ebx
    movl %ebx, start

    //blocksDisp=1
    movl $1, blocksDisp

    jmp cont_block_liber


et_block_liber_incrementare:

    //blocksDisp++
    incl blocksDisp

    jmp cont_block_liber


cont_block_liber:

    // Verificam daca avem suficeiente blocuri
    movl blocksNec, %ebx
    cmpl blocksDisp, %ebx
    je et_block_liber_exit

    jmp cont_verificare_memorie_loop


et_block_liber_exit:

    //ok=true
    movl $1, ok

    //end=start+blocksNec-1;
    movl start, %ebx
    addl blocksNec, %ebx
    subl $1, %ebx
    movl %ebx, end

    jmp verificare_memorie_exit


et_block_ocupat:

    //v[i]!=0
    movl $0, blocksDisp


cont_verificare_memorie_loop:

    incl index_verificare_memorie
    jmp verificare_memorie_loop


verificare_memorie_exit:

    cmpl $0, ok
    je et_spatiu_insuficient

    jmp et_verificare_memorie_exit


et_spatiu_insuficient:

    movl $0, start
    movl $0, end
    jmp et_verificare_memorie_exit

et_verificare_memorie_exit:
    jmp et_post_verificare_memorie




//adaugarea propriu-zisa in memomrie
et_adaugare:

    movl id, %ecx
    
    //fr[id]=dim
    movl dim, %ebx
    lea fr, %edi
    movl %ebx, (%edi,%ecx,4)

    //st[id]=start
    movl start, %ebx
    lea st, %edi
    movl %ebx, (%edi,%ecx,4)

    //dr[id]=end
    movl end, %ebx
    lea dr, %edi
    movl %ebx, (%edi,%ecx,4)


    movl start, %ecx


et_adaugare_loop:

    cmpl end, %ecx
    jg et_adaugare_exit

    //v[i]=id
    movl id, %ebx
    lea v, %edi
    movl %ebx, (%edi,%ecx,4)

    incl %ecx
    jmp et_adaugare_loop

et_adaugare_exit:
    jmp et_cont_citire_add_loop






//OPERATIA GET

et_get:

    //citire id
    pushl $id
    pushl $formatRead
    call scanf
    addl $8, %esp

    lea dr, %edi
    movl id, %ecx
    movl (%edi,%ecx,4), %ebx
    push %ebx

    lea st, %edi
    movl id, %ecx
    movl (%edi,%ecx,4), %ebx
    push %ebx

    //afisare (st[id], dr[id])
    push $formatAfisGet
    call printf
    addl $12, %esp

    pushl $0
    call fflush
    popl %eax

    jmp cont_main_loop







//OPERATIA DELETE

et_delete:

    pushl $id
    pushl $formatRead
    call scanf
    addl $8, %esp

    //verificare_frecventa
    movl id, %ecx
    lea fr, %edi
    movl (%edi,%ecx,4), %ebx

    cmpl $0, %ebx
    je et_afisare_neschimbata

    //start=st[id]
    lea st, %edi
    movl id, %ecx
    movl (%edi,%ecx,4), %ebx
    movl %ebx, start

    //end=dr[id]
    lea dr, %edi
    movl id, %ecx
    movl (%edi,%ecx,4), %ebx
    movl %ebx, end

    movl start, %ecx

//stergerea din memorie a blocurilor 
et_delete_vector_loop:
    cmp end, %ecx
    jg et_cont_delete

    lea v, %edi
    movl $0, (%edi,%ecx,4)

    inc %ecx
    jmp et_delete_vector_loop

et_cont_delete:

    //fr[id]=0
    lea fr, %edi
    movl id, %ecx
    movl $0, (%edi,%ecx,4)

    //st[id]=0
    lea st, %edi
    movl id, %ecx
    movl $0, (%edi,%ecx,4)

    //dr[id]=0
    lea dr, %edi
    movl id, %ecx
    movl $0, (%edi,%ecx,4)

et_afisare_neschimbata:

    movl $0, index_delete
    lea v, %edi

et_afisare_delete_loop:

    movl index_delete, %ecx
    cmpl $1024, %ecx
    je et_delete_exit

    lea v, %edi
    movl (%edi,%ecx,4), %ebx
    movl %ebx, v_i

    incl %ecx
    movl (%edi,%ecx,4), %ebx
    movl %ebx, v_iplus1

    //if v[i]!=0 && v[i]!=v[i+1]
    cmpl $0, v_i
    je cont_afisare_delete_loop

    movl v_iplus1, %ebx
    cmpl v_i, %ebx
    je cont_afisare_delete_loop

    
    movl v_i, %ecx

    lea st, %edi
    movl (%edi,%ecx,4), %ebx

    lea dr, %edi
    movl (%edi,%ecx,4), %eax

    push %eax
    push %ebx
    push v_i
    push $formatAfisAdd
    call printf
    addl $16, %esp

    pushl $0
    call fflush
    popl %eax

cont_afisare_delete_loop:
    incl index_delete
    jmp et_afisare_delete_loop

et_delete_exit:

    jmp cont_main_loop








//OPERATIA DEFRAGMENTATION

et_defragmentation:

    lea aux, %edi
    movl $0, %ecx
    
//aux=[0]*1024
et_zero_aux_loop:

    cmp $1024, %ecx
    je et_copiere_in_aux

    movl $0, (%edi,%ecx,4)

    incl %ecx
    jmp et_zero_aux_loop



et_copiere_in_aux:

    movl $0, %ecx
    movl $0, ct

et_copiere_in_aux_loop:

    cmp $1024, %ecx
    je et_copiere_in_v


    lea v, %edi
    movl (%edi,%ecx,4), %ebx

    //if v[i]!=0 adauga in aux
    cmp $0, %ebx
    jne et_copie
    jmp cont_copiere_in_aux_loop

    et_copie:

        movl ct, %edx
        lea aux, %edi
        movl %ebx, (%edi,%edx,4)
        incl ct
    
cont_copiere_in_aux_loop:

    incl %ecx
    jmp et_copiere_in_aux_loop

//v=aux
et_copiere_in_v:

    movl $0, %ecx

et_copiere_in_v_loop:

    cmp $1024, %ecx
    je et_zero_st_dr

    lea aux, %edi
    movl (%edi,%ecx,4), %ebx

    lea v, %edi
    movl %ebx, (%edi,%ecx,4)

    incl %ecx
    jmp et_copiere_in_v_loop


et_zero_st_dr:

    movl $0, %ecx


//st=dr=[0]*256
et_zero_st_dr_loop:

    cmp $256, %ecx
    je et_defragmentare

    lea st, %edi
    movl $0, (%edi,%ecx,4)

    lea dr, %edi
    movl $0, (%edi,%ecx,4)

    incl %ecx
    jmp et_zero_st_dr_loop


et_defragmentare:

    movl $0, %ecx

et_defragmentare_loop:

    cmp ct, %ecx
    je et_defragmentation_exit

    lea v, %edi
    movl (%edi, %ecx, 4), %ebx
    movl %ebx, id
    
    movl %ecx, start

    //st[id]=start
    lea st, %edi
    movl id, %ebx
    movl start, %eax
    movl %eax, (%edi, %ebx, 4)

    //dim=fr[id]
    lea fr, %edi
    movl id, %ebx
    movl (%edi,%ebx,4), %eax
    movl %eax, dim

    //blocksNec = (dim+7)/8
    movl $8, %ebx
    movl dim, %eax
    xorl %edx, %edx
    addl $7, %eax
    divl %ebx
    movl %eax, blocksNec

    //end=start+blocksNec-1
    movl start, %ebx
    addl blocksNec, %ebx
    subl $1, %ebx
    movl %ebx, end


    //dr[id]=end
    lea dr, %edi
    movl id, %ebx
    movl end, %eax
    movl %eax, (%edi, %ebx, 4)


    push end
    push start
    push id
    push $formatAfisAdd
    call printf
    addl $16, %esp

    pushl $0
    call fflush
    popl %eax

    movl end, %ecx
    incl %ecx

    jmp et_defragmentare_loop


et_defragmentation_exit:

    jmp cont_main_loop






//MAIN
main:
    //citim numarul de operatii
    push $nrOp
    push $formatRead
    call scanf
    addl $8, %esp

    movl $0, index_main
    
main_loop:

    movl nrOp, %ebx
    cmpl index_main, %ebx
    je et_exit

    //citim operatia
    push $Op
    push $formatRead
    call scanf
    addl $8, %esp

    cmpl $1, Op
    je et_citire_add

    cmpl $2, Op
    je et_get

    cmpl $3, Op
    je et_delete

    cmpl $4, Op
    je et_defragmentation


cont_main_loop:

    incl index_main
    jmp main_loop


et_exit:
    pushl $0
    call fflush
    popl %eax

    movl $1, %eax
    movl $0, %ebx
    int $0x80
