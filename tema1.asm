%include "/home/learning/Desktop/Anul_2/IOCLA/iocla-tema1-resurse/includes/io.inc"
                                            ; Am pus calea absoluta pentru io.inc
extern getAST
extern freeAST

section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1

section .text
global main
main:
    mov ebp, esp; for correct debugging
    ; NU MODIFICATI
    push ebp
    mov ebp, esp
    
    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST
    mov [root], eax

    
    ; Implementati rezolvarea aici:

    mov ebx, [root]         ; Stocam adresa root-ului in reg general ebx
    xor eax, eax

_rec_:

    push ebx                ; Salvam pe stiva root-ul
    push ebp
    mov ebp, esp
    
    mov ecx, [ebx + 4]      ; Node *left
    mov edx, [ebx + 8]      ; Node *right
    
    test ecx, ecx           ; Verificam daca e frunza: ecx == 0x0
    jz _leaf_
    
    call _l_adv_ 
    mov ecx, [ebx + 4]      ; Node *left update
    mov edx, [ebx + 8]      ; Node *right update
    
    call _r_adv_            
                            ; RETURN ADDRESS WHEN COMING BACK FROM RIGHT RECURSIVE
    
_l_adv_:
    mov ebx, [ecx]          ; root = root->left
    call _rec_
    pop ebp
    pop ebx
    mov esi, eax            ; Mutam rezultatul din eax in esi
    push esi                ; Save the result
    
    ret
    
_r_adv_:
    mov ebx, [edx]
    call _rec_
    ret
   
   
_leaf_:
    mov eax, ebx            ; Salvam in eax adresa de inceput a char*
    call _pre_atoi_
    ret                     ; Ne intoarcem la 
    
    
    
_pre_atoi_:                 ; Foloseste ebx, ecx, edx, edi si implicit eax
                            ; Pregatire pentru executia procedurii atoi
                             
    push ebx                ; Salvam valorile pe stiva din procedura anterioara
    push ecx                ;
    push edx                ;
                                
    xor ebx, ebx            ; Partea lower va stoca byte-ul citit
    xor ecx, ecx            ; Va stoca numarul rezultat pe 4 bytes
    xor edx, edx            ; Auxiliar pentru inmultirea cu 10
    xor edi, edi            ; Trigger pentru numar negativ
    
_atoi_:                     ; Transforma din string in int
                            ; Functioneaza pt. signed/unsigned                           
    mov bl, byte [eax]      ; Mutam primul char din *data
    
    cmp bl, 0x2d            ; Verificam dac byte-ul e '-'
    jz _mem_neg_            ; Numarul e negativ
    
    test bl, bl             ; Verificam daca byte-ul e '\0'
    jz _is_neg_
    jmp _tran_
            
_mem_neg_:
    mov edi, 0x1            ; Tinem evidenta daca numarul e negativ
    jmp _nx_chr_            ; Trecem la urmatorul char
    
_is_neg_:                   
    cmp edi, 0x1            ; Verifica daca trigger-ul e activ
    jnz _div_
                  
_neg_:
    neg ecx                 ; Neaga intregul final stocat in ecx
    mov eax, ecx            ; Mutam valoarea de return in eax
    
    pop edx                 ; Scoatem de pe stiva vechile valori
    pop ecx
    pop ebx
    ret                     ; Ne intoarcem unde pointeaza eip si cu
                            ; valoarea transformata a nodului in eax
            
_tran_:
    sub bl, 48              ; Transformare din string in int
    mov edx, ecx            ; Pastram acelasi ecx pana la shiftare
                            ; Mul cu 10: (x << 3) + (x << 1)
    shl edx, 1              ;               :     :  x << 1
    shl ecx, 3              ;             x << 3  :    :
    add ecx, edx            ;               :     +    :

    movzx ebx, bl           ; Extindem semnul pentru a opera
    add ecx, ebx            ; Adaugam cifra transformata la numar
    
_nx_chr_:    
    inc eax                 ; Trecem la urmatorul char din string
    jmp _atoi_


_op_:                       ; Stabilim ce tip de operatie se executa
                            ; Intre left child si right child
                                                                                    
    cmp bl, 0x2d            ; Char '-', ASCII: 45
    jz _sub_                
    cmp bl, 0x2b            ; Char '+', ASCII: 43    
    jz _add_
    cmp bl, 0x2a            ; Char '*', ASCII: 42
    jz _mul_
    cmp bl, 0x2f            ; Char '/', ASCII: 47
    jz _div_

_sub_:   
    
_add_:

_mul_:
    PRINT_STRING "its null"

_div_: 
  
   

    
    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    call freeAST
    
    xor eax, eax
    leave
    ret