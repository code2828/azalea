;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                             ;
;       ***       *********     ***          **         *********    ***      ;
;      ** **           **      ** **        **         **           ** **     ;
;     **  **         **       **  **       **         **           **  **     ;
;    ********      **        ********     **         *********    ********    ;
;   **     **    **         **     **    **         **           **     **    ;
;  **      **   *********  **      **   *********  **********   **      **    ;
;                                                                             ;
;  Version 0.0.0 "Haidian, Haidian, Beijing"                                  ;
;                                                                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                             ;
;                             PROGRAM  STRUCTURE                              ;
;                                                                             ;
; The unit of an azalea program is called an invocable. Each invocable may    ;
; perform some action (e.g. allocate memory), or return some value. One or    ;
; two of the action and return value can be nothing. The whole program        ;
; consists of one invocable. Its return value will be the program's return    ;
; value. This means in most cases you need to surround the program with a     ;
; of parentheses.                                                             ;
;          
; Invocables can be classified depending on whether they have a return value  ;
; or performs some action. An evaluable has a return value; and an executable ;
; performs some task. An evocable can be either, both, or none. In the        ;
; **BUILTIN COMMANDS** section, value or address refers to an evaluable, and  ;
; operation refers to an executable.                                          ;
;                                                                             ;
; Each invocable starts with a command whose first and last characters must   ;
; NOT be one of A-Za-z0-9_,;(){} that defines what to do. Then one or more    ;
; operands (also invocables) separted by ',' follows. Some commands accept    ;
; any positive number of operands, similar to vaargs, and these are denoted   ;
; as "..." in the **BUILTIN COMMANDS** section. "address, size" can replace a ;
; list of values. At the end of an invocable, most commands does not require  ;
; or have an enclosing character, except the () command, so sometimes it's    ;
; convenient to use ';' to signal the ending of the current invocable.        ;
;                                                                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                             ;
;                              BUILTIN COMMANDS                               ;
;  # id [, size]                                                              ;
;     Allocates 4 * size bytes of memory and assign it to id.                 ;
;     Returns nothing.                                                        ;
;  @ address [, offset]                                                       ;
;     Does nothing.                                                           ;
;     Returns the value located at id+offset.                                 ;
;  $ value                                                                    ;
;     Does nothing.                                                           ;
;     Returns the value as an address.                                        ;
; $$ id...                                                                    ;
;     Frees memory allocated for ids.                                         ;
;     Returns dwords of memory freed.                                         ;
;  = address, value...                                                        ;
;     Puts values into memory starting from address.                          ;
;     Returns the first value.                                                ;
; << value...                                                                 ;
;     Prints values as chars.                                                 ;
;     Returns nothing.                                                        ;
; >> address [, size]                                                         ;
;     Reads from stdin and puts one or size characters into memory starting   ;
;         from address.                                                       ;
;     Returns the last character read as a value.                             ;
;  ] value...                                                                 ;
;     Pushes values into the stack.                                           ;
;     Returns the address of the top of the stack.                            ;
;  [ address [, size]                                                         ;
;     Pops one or size values at the top of the stack into the memory         ;
;          starting from address.                                             ;
;     Returns the address of the top of the stack.                            ;
;  + value...                                                                 ;
;     Does nothing.                                                           ;
;     Returns the sum of all values.                                          ;
;  - [sub, ] val                                                              ;
;     Does nothing.                                                           ;
;     Returns sub - val; if sub is not given, returns val negated.            ;
;  * value...                                                                 ;
;     Does nothing.                                                           ;
;     Returns the product of all values.                                      ;
;  / dvs, dvd                                                                 ;
;     Does nothing.                                                           ;
;     Returns dvs / dvd.                                                      ;
;  % val [, mod]                                                              ;
;     Does nothing.                                                           ;
;     Returns val % mod. mod is 2 when not given.                             ;
;  ! value                                                                    ;
;     Does nothing.                                                           ;
;     Returns 0 if value != 0; 1 if value == 0                                ;
;  ~ value                                                                    ;
;     Does nothing.                                                           ;
;     Returns value's one's complement.                                       ;
;  & value...                                                                 ;
;     Does nothing.                                                           ;
;     Returns bitwise and of all values.                                      ;
;  | value...                                                                 ;
;     Does nothing.                                                           ;
;     Returns bitwise or of all values.                                       ;
;  ^ abc, def                                                                 ;
;     Does nothing.                                                           ;
;     Returns bitwise xor of two values.                                      ;
;  < fst, snd                                                                 ;
;     Does nothing.                                                           ;
;     Returns 1 if fst < snd, 0 otherwise.                                    ;
;  > fst, snd                                                                 ;
;     Does nothing.                                                           ;
;     Returns 1 if fst > snd, 0 otherwise.                                    ;
; == fst, snd                                                                 ;
;     Does nothing.                                                           ;
;     Returns 1 if fst = snd, 0 otherwise.                                    ;
;  ( invocable... )                                                           ;
;     Invokes each invocable in order.                                        ;
;     Returns value of the last invocable between the parentheses.            ;
;  ? value, opthen [, opelse]                                                 ;
;     If value is not 0, then invoke opthen, else invoke opelse if specified. ;
;     Returns value of the invocable invoked.                                 ;
;  : label                                                                    ;
;     Defines a label here.                                                   ;
;     Returns nothing.                                                        ;
; -> label                                                                    ;
;     Jumps to label.                                                         ;
;     Returns nothing.                                                        ;
;  {string} operation                                                         ;
;     Defines a custom command "string" that can take parameters and invoke   ;
;         operation. Parameters are referred to as _1, _2, _3, ...            ;
;     Returns the return value of the operation.                              ;
;  0 `any number literal`                                                     ;
;     Does nothing.                                                           ;
;     Returns its value.                                                      ;
; id `any identifier`                                                         ;
;     Does nothing.                                                           ;
;     Returns the address the identifier is assigned to, or nothing if freed  ;
;         or not assigned.                                                    ;
; lb `any label`                                                              ;
;     Does nothing.                                                           ;
;     Used in -> commands.                                                    ;
;                                                                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                             ;
;                                 DELIMITERS                                  ;
;                                                                             ;
;  ,                                                                          ;
;    Plain delimiter. Separates invocables.                                   ;
;  ;                                                                          ;
;    Enclosing delimiter. Ends the inner-most invocable, then separates       ;
;        invocables.                                                          ;
;  .                                                                          ;
;    Breaking delimiter. Ends the inner-most invocable repeatedly until it    ;
;        reaches an () command, then separates invocables.                    ;
;                                                                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                             ;
;                                  COMMENTS                                   ;
;                                                                             ;
; Anything between ` (grave) characters are comments and will be removed by   ;
; preprocessor. It can be on a single line or across multiple lines.          ;
;                                                                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

format ELF64 executable 3

segment readable executable

entry $
    lea rbx, [txt+2]
    call preprocessor
    sub rsi, rbx
    mov word [txt], si
    xor rdx, rdx
    lea rsi, [txt+2]
    mov dx, word [txt]
    mov edi, 1
    mov eax, 1
    syscall

    mov dil, 10
    call print_char

    ; debug: test add_trie and search_trie
    jmp .dont_test
    lea rsi, [trietest]
    mov rax, 0x0123456789ABCDEF
    push rax
    mov rax, 3
    mov rbp, rsp
    mov r9, 28
    call add_trie
    pop rax ; reset stack
    mov r9, 28
@@: inc r9
    mov rdi, qword [trie+9*r9]
    mov rcx, 16
    call print_int
    mov dil, ','
    call print_char
    cmp r9, 33
    jle @b
    lea rsi, [trietest]
    call search_trie
    mov rdi, rax
    mov rcx, 10
    call print_int
    mov dil, '-'
    call print_char
    lea rdi, [trie]
    call print_int
    mov dil, 10
    call print_char


    mov rbx, 0
@@:
    mov rcx, 16
    movzx rdi, byte [trie+rbx]
    call print_int
    inc rbx
    mov rax, rbx
    xor rdx, rdx
    mov rcx, 9
    div rcx
    mov dil, ','
    cmp rdx, 0
    jnz .not_ninth_0
    mov dil, 10
.not_ninth_0:
    call print_char
    cmp rbx, 333
    jl @b

    mov dil, 10
    call print_char
    jmp kill


.dont_test:
    call interpreter
    
    mov rbx, 0
@@:
    mov rcx, 16
    movzx rdi, byte [trie+rbx]
    call print_int
    inc rbx
    mov rax, rbx
    xor rdx, rdx
    mov rcx, 9
    div rcx
    mov dil, ','
    cmp rdx, 0
    jnz .not_ninth
    mov dil, 10
.not_ninth:
    call print_char
    cmp rbx, 333
    jl @b

    mov dil, 10
    call print_char
    xor rbx, rbx
@@:
    mov rcx, 16
    movzx rdi, byte [i+rbx]
    call print_int
    inc rbx
    mov rax, rbx
    xor rdx, rdx
    mov rcx, 10
    div rcx
    mov dil, ','
    cmp rdx, 0
    jnz .not_tenth
    mov dil, 10
.not_tenth:
    call print_char
    cmp rbx, 2000
    jl @b

    xor edi, edi
kill:
    mov eax, 60
    syscall

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                             ;
;                                PREPROCESSOR                                 ;
;                                                                             ;
; The preprocessor performs four tasks:                                       ;
;   1. Expand any string into list of ints separated by commas.               ;
;   2. Expand any char into an int.                                           ;
;   3. Remove whitespaces (\n, \r, \t & spaces).                              ;
;   4. Remove comments (anything between a pair of `).                        ;
; It writes preprocessed program into txt, whose size is 64K. Any program     ;
; longer than that are unsupported.                                           ;
;                                                                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

preprocessor:
    xor rdi, rdi
    lea rsi, [txt+2] ; counter for preprocessed text
                     ; first two bytes stores length
    lea rcx, [prog2]
.iterator:
    mov dil, [rcx]
    cmp dil, 0 ; \0
    jz .done
    cmp dil, -1 ; EOF
    jz .done
    
    ; strings: convert to ints
    cmp dil, '"'
    jne .not_string
.string:
    inc rcx
    mov dil, [rcx]
    cmp dil, '"'
    je .continue
    cmp dil, '\' ; an escape character?
    jne .string_normal_char
    inc rcx
    mov dil, [rcx]
    push rcx ; write_xxx alters rcx
    lea rcx, [escape_map]
    add rcx, rdi
    mov dil, [rcx]
    cmp dil, 0xFF
    jne @f
    pop rcx
    mov dil, [rcx]
    jmp err_unknown_escape_char
@@: call write_int
    pop rcx
.write_comma:
    cmp byte [rcx+1], '"' ; if we're at the last char, dont write an ','
    je .string
    mov dil, ','
    push rcx
    call write_char
    pop rcx
    jmp .string
.string_normal_char:
    movzx rdi, dil
    push rcx
    call write_int
    pop rcx
    jmp .write_comma
.not_string:

    ; characters: also convert to ints
    cmp dil, 39
    jne .not_character
    inc rcx
    mov dil, [rcx]
    cmp dil, '\'
    jne .normal_char
    inc rcx
    mov dil, [rcx]
    push rcx ; write syscall alters rcx
    lea rcx, [escape_map]
    add rcx, rdi
    mov dil, [rcx]
    cmp dil, 0xFF
    jne @f
    mov dil, [rcx]
    jmp err_unknown_escape_char
.normal_char:
    push rcx
@@: call write_int
    pop rcx
    inc rcx
    cmp byte [rcx], 39
    jne err_char_too_long
    jmp .continue
.not_character:

    ; whitespaces: continue
    cmp dil, ' '
    je .continue
    cmp dil, 10 ; LF
    je .continue
    cmp dil, 13 ; CR
    je .continue
    cmp dil, 9  ; tab
    je .continue

    ; comments: continue until next grave
    cmp dil, '`'
    jne .not_comment
.comment:
    inc rcx
    cmp byte [rcx], '`'
    je .continue
    jmp .comment
.not_comment:

    ; not a special char
    push rcx
    call write_char
    pop rcx

.continue:
    inc rcx
    jmp .iterator
.done:
    ret
;;; END OF preprocessor ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                                                             ;
;                                INTERPRETER                                  ;
;                                                                             ;
; The interpreter breaks a program into invocables. The data structure of an  ;
; invocable is as follows:                                                    ;
;                                                                             ;
;   command                               | 16 bits =  2B                     ;
;   value                                 | 32 bits =  4B                     ;
;   ptr to first child invocable          | 16 bits =  2B                     ;
;   ptr to next invocable (same level)    | 16 bits =  2B                     ;
;   --------------------------------------+--------------                     ;
;   total                                 | 80 bits = 10B                     ;
;                                                                             ;
; command: number = DFFF                                                      ;
; rsi: pointer to text; rdi (dil): current char                               ;
;                                                                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

interpreter:
    lea rsi, [txt+2]
    xor rdi, rdi
    xor rcx, rcx ; counter: how many invocables have we met this round?
    xor r8, r8 ; indexer for i
    mov r9, 28 ; indexer for trie
    xor r10, r10 ; immediately preceding sibling
    xor r11, r11 ; indexer for var
    mov r12, 0x8000 ; indexer for label
    mov r13, 0xE000 ; indexer for custom command
    mov rbp, rsp
    sub rbp, 8 ; return address
    call read_from_pos
    ret

read_from_pos:
    mov dil, byte [rsi]
    cmp dil, 0
    je .eof
    cmp dil, -1
    je .eof
    jmp @f
.eof:
    mov rsp, rbp ; clear the stack
    ret
@@: ; is it an existing identifier?
    call search_trie
    cmp rax, 0
    je @f
    movzx rbx, r8w
    imul rbx, 10
    lea rbx, [i+rbx]
    push word [rax+1]
    pop word [rbx]
    push word [rax+3]
    pop word [rbx+2]
    mov dword [rbx+6], 0xFFFFFFFF
    push r8w
    push cx
    cmp r10w, 0
    jz .no_prev_sibling
    mov rbx, r10
    imul rbx, 10
    lea rbx, [i+rbx]
    mov word [rbx+8], r8w
    jmp .has_prev_sibling
.no_prev_sibling:
    movzx rbx, word [rsp+6]
    imul rbx, 10
    lea rbx, [i+rbx]
    mov word [rbx+6], r8w
.has_prev_sibling:
    xor rcx, rcx
    xor r10, r10
    inc r8w
    jmp .continue_dont_inc_rsi
@@: ; if not found, may be a number
    cmp dil, '0'
    jl @f
    cmp dil, '9'
    jg @f
    call read_number_from_pos
    movzx rbx, r8w
    imul rbx, 10
    lea rbx, [i+rbx]
    mov word [rbx], 0xDFFF
    mov dword [rbx+2], eax
    cmp r10w, 0
    jz .no_prev_sibling_2
    mov rbx, r10
    imul rbx, 10
    lea rbx, [i+rbx]
    mov word [rbx+8], r8w
    jmp .has_prev_sibling_2
.no_prev_sibling_2:
    movzx rbx, word [rsp+2]
    imul rbx, 10
    lea rbx, [i+rbx]
    mov word [rbx+6], r8w
.has_prev_sibling_2:
    inc rcx
    mov r10, r8
    inc r8w
    jmp .continue_dont_inc_rsi
@@: cmp dil, '_' ; special id?
    jne @f
    inc rsi
    call read_number_from_pos
    cmp rax, 0 ; not a special id after all
    jnz .special_id
    dec rsi
    jmp @f
.special_id:
    movzx rbx, r8w
    imul rbx, 10
    lea rbx, [i+rbx]
    mov word [rbx], 0xDFFC
    mov dword [rbx+2], eax
    cmp r10w, 0
    jz .no_prev_sibling_3
    mov rbx, r10
    imul rbx, 10
    lea rbx, [i+rbx]
    mov word [rbx+8], r8w
    jmp .has_prev_sibling_3
.no_prev_sibling_3:
    movzx rbx, word [rsp+2]
    imul rbx, 10
    lea rbx, [i+rbx]
    mov word [rbx+6], r8w
.has_prev_sibling_3:
    inc rcx
    mov r10, r8
    inc r8w
    jmp .continue_dont_inc_rsi
@@: movzx rbx, word [rsp+2] ; may be a new identifier
    imul rbx, 10
    lea rbx, [i+rbx]
    mov bx, word [rbx]
    cmp bx, 0xC000
    je .new_var
    cmp bx, 0xC028
    je .new_label
    jmp @f
.new_var:
    movzx rbx, r8w
    imul rbx, 10
    lea rbx, [i+rbx]
    mov word [rbx], r11w
    mov dword [rbx+2], 0xFFFFFFFF
    call read_identifier_from_pos
    cmp rax, 0
    jz @f
    push rbp
    sub rsp, 8
    mov word [rsp+2], 0xFFFF
    mov word [rsp], r11w
    inc r11w
    mov rbp, rsp
    call add_trie
    add rsp, 8
    pop rbp
    jmp .new_var_end
.new_label:
    movzx rbx, r8w
    imul rbx, 10
    lea rbx, [i+rbx]
    mov word [rbx], r12w
    mov dword [rbx+2], 0xFFFFFFFF
    call read_identifier_from_pos
    cmp rax, 0
    jz @f
    push rbp
    sub rsp, 8
    mov word [rsp+2], r8w
    mov word [rsp], r12w
    inc r12w
    mov rbp, rsp
    call add_trie
    add rsp, 8
    pop rbp
.new_var_end:
    cmp r10w, 0
    jz .no_prev_sibling_4
    mov rbx, r10
    imul rbx, 10
    lea rbx, [i+rbx]
    mov word [rbx+8], r8w
    jmp .has_prev_sibling_4
.no_prev_sibling_4:
    movzx rbx, word [rsp+2]
    imul rbx, 10
    lea rbx, [i+rbx]
    mov word [rbx+6], r8w
.has_prev_sibling_4:
    inc rcx
    mov r10, r8
    inc r8w
    jmp .continue_dont_inc_rsi
@@: cmp dil, ',' ; should be a delimiter now, if not, that's an error!
    jne @f
    movzx rbx, word [rsp+2]
    imul rbx, 10
    lea rbx, [i+rbx]
    movzx rbx, word [rbx]
    cmp rbx, 0xE000 ; builtin commands?
    jnl .no_max_argument
    cmp cx, word [max_arg+2*rbx]
    jne .set_prev_sibling
.no_max_argument:
    cmp rsp, rbp
    jge .set_prev_sibling
.comma_terminate_current_invocable:
    movzx rbx, word [rsp+2]
    mov r10, rbx
    imul rbx, 10
    lea rbx, [i+rbx]
    movzx rbx, word [rbx]
    mov cx, word [rsp]
    add rsp, 4
    inc cx
    cmp rbx, 0xE000
    jnl .no_max_argument_loop
    cmp cx, word [max_arg+2*rbx]
    jne .continue
.no_max_argument_loop:
    cmp rsp, rbp
    jge .continue
    jmp .comma_terminate_current_invocable
.set_prev_sibling:
    mov r10, r8
    dec r10
    jmp .continue
@@: cmp dil, ';'
    jne @f
    cmp rsp, rbp
    jge err_stack_empty
.semicolon_terminate_current_invocable:
    movzx rbx, word [rsp+2]
    mov r10, rbx
    cmp r10, 4
    je test_output_stack
    imul rbx, 10
    lea rbx, [i+rbx]
    movzx rbx, word [rbx]
    mov cx, word [rsp]
    add rsp, 4
    inc cx
    cmp rbx, 0xE000
    jnl .no_max_argument_loop_2
    cmp cx, word [max_arg+2*rbx]
    jne .continue
.no_max_argument_loop_2:
    cmp rsp, rbp
    jge .continue
    jmp .semicolon_terminate_current_invocable
@@: cmp dil, '.'
    jne @f
    cmp rsp, rbp
    jge err_stack_empty
.period_terminate_current_invocable:
    movzx rbx, word [rsp+2]
    push rbx
    imul rbx, 10
    lea rbx, [i+rbx]
    cmp word [rbx], 0xC025
    je .continue
    pop r10
    mov cx, word [rsp]
    add rsp, 4
    inc cx
    cmp rsp, rbp
    jge .continue
    jmp .period_terminate_current_invocable
@@: cmp dil, ')'
    jne err_ukn_id
    cmp rsp, rbp
    jge err_stack_empty
.closing_parenthesis_terminate_current_invocable:
    movzx rbx, word [rsp+2]
    push rbx
    imul rbx, 10
    lea rbx, [i+rbx]
    cmp word [rbx], 0xC025
    je .closing_parenthesis_break
    pop r10
    mov cx, word [rsp]
    add rsp, 4
    inc cx
    cmp rsp, rbp
    jge .closing_parenthesis_break
    jmp .closing_parenthesis_terminate_current_invocable
.closing_parenthesis_break:
    cmp rsp, rbp
    jge err_stack_empty
    mov r10w, word [rsp+2]
    mov cx, word [rsp]
    add rsp, 4
    inc cx
    jmp .continue
.continue:
    inc rsi
.continue_dont_inc_rsi:
    jmp read_from_pos
@@: ret
;;; END OF interpreter ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; rsi: pointer to read from. rax stores result. rsi points to the next char ;;;
read_number_from_pos:
    xor rax, rax
.loop:
    mov dil, byte [rsi]
    cmp dil, '0'
    jl .break
    cmp dil, '9'
    jg .break
    mov rdx, 10
    mul rdx
    sub dil, '0'
    add rax, rdi
    inc rsi
    jmp .loop
.break:
    ret
;;; END OF read_next_number ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; rsi: pointer to read from. rax stores length. rsi is not modified ;;;;;;;;;;;
read_identifier_from_pos:
    xor rax, rax
.loop:
    mov dil, byte [rsi]
    cmp dil, ','
    je @f
    cmp dil, ';'
    je @f
    cmp dil, '.'
    je @f
    cmp dil, ')'
    je @f
    cmp dil, '}'
    je @f
    cmp dil, 0
    je @f
    cmp dil, -1
    je @f
    inc rsi
    inc rax
    jmp .loop
@@: sub rsi, rax
    ret
;;; END OF read_identifier_from_pos ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; ax: length of string. rsi: pointer to the string to be added. top 2 bytes ;;;
; of stack (rbp): uid. top 3-4 bytes: data. top 5-8 bytes: not used. ;;;;;;;;;;
add_trie:
    push rbx
    lea rbx, [trie]
    mov [rsp-8], rbx
    movzx rbx, word [rbx+5]
    lea rbx, [trie+9*rbx]
.iterate_children:
    mov dil, byte [rbx]
    cmp dil, byte [rsi]
    jne .next_sibling
    mov [rsp-8], rbx
    dec ax
    jz .maybe_redef_id
    inc rsi
    cmp word [rbx+5], 0xFFFF
    je .add ; no more children, recursively add
    movzx rbx, word [rbx+5]
    lea rbx, [trie+9*rbx]
    jmp .iterate_children
.next_sibling:
    cmp word [rbx+7], 0xFFFF
    je .add ; no more siblings
    movzx rbx, word [rbx+7]
    lea rbx, [trie+9*rbx]
    jmp .iterate_children

.add: ; [rsp-8] is a pointer to the current father
    mov dil, byte [rsi]
    mov rbx, [rsp-8]
    cmp word [rbx+5], 0xFFFF ; if no children then add one
    je .no_child
    movzx rbx, word [rbx+5]
    lea rbx, [trie+9*rbx]
.find_last_sibling: ; else append
    cmp word [rbx+7], 0xFFFF
    je .append
    movzx rbx, word [rbx+7]
    lea rbx, [trie+9*rbx]
    jmp .find_last_sibling
.append:
    mov word [rbx+7], r9w
    jmp .add_new
.no_child:
    mov word [rbx+5], r9w
.add_new:
    lea rbx, [trie+9*r9]
    mov byte [rbx], dil
    mov qword [rbx+1], 0xFFFFFFFFFFFFFFFF
    inc r9w
    inc rsi
    dec ax
    jz .end
.add_new_loop:
    mov dil, byte [rsi]
    mov byte [trie+9*r9], dil
    mov qword [trie+9*r9+1], 0xFFFFFFFFFFFFFFFF
    mov word [rbx+5], r9w
    lea rbx, [trie+9*r9]
    inc r9w
    inc rsi
    dec ax
    jnz .add_new_loop
    jmp .end
.maybe_redef_id:
    cmp word [rbx+1], 0xFFFF ; actually just an empty node
    je .end
    pop rbx
    jmp err_redef_id
.end:
    mov eax, dword [rbp] ; uid + data
    mov dword [rbx+1], eax
    pop rbx
    ret
;;; END OF add_trie ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; rsi: pointer to text. rax stores the pointer to the result, 0 if not found ;;
; TODO: BUG! say we have 'for' and 'foreach'. when querying 'forea', the stub ;
; node (uid = 0xFFFF) will be returned. ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
search_trie:
    push rbx
    xor rbx, rbx
    push 0
    mov bx, word [trie+5]
    cmp bx, 0xFFFF ; has child?
    je .found
.loop_children:
    lea rax, [trie+9*rbx]
    mov bl, byte [rax]
    cmp bl, byte [rsi] ; correct branch?
    jne .next_loop_children
    cmp word [rax+1], 0xFFFF ; valid node?
    je .dont_update_rax
    add rsp, 8
    push rax
.dont_update_rax:
    mov bx, word [rax+5]
    cmp bx, 0xFFFF
    je .found
    inc rsi
    jmp .loop_children
.next_loop_children:
    mov bx, word [rax+7]
    cmp bx, 0xFFFF
    jne .loop_children
    cmp qword [rsp], 0
    jz .found
    dec rsi

.found:
    pop rax
    cmp rax, 0
    jz .actually_not_found
    inc rsi
.actually_not_found:
    pop rbx
    ret
;;; END OF search_trie ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; rdi: the int to write. rsi: pointer to memory location. rcx: base ;;;;;;;;;;;
write_int:
    cmp rcx, 16
    je .hex_begin
    mov rcx, 10
.hex_begin:
    push rbp
    mov rbp, rsp
    bt rdi, 63 ; signed?
    jnc .not_negative
    push rdi
    mov dil, '-'
    call write_char ; write a minus sign
    pop rdi
    neg rdi
.not_negative:
    cmp rdi, 0
    jnz .not_zero
    mov byte [rsi], '0'
    inc rsi
    jmp .end
.not_zero:
    mov rax, rdi
@@: xor rdx, rdx
    div rcx
    cmp rdx, 10
    jnl .hex
    add rdx, '0'
    jmp .dec
.hex:
    add rdx, 55
.dec:
    dec rsp
    mov byte [rsp], dl
    cmp rax, 0
    jnz @b
.write:
    mov dil, byte [rsp]
    mov byte [rsi], dil
    inc rsp
    inc rsi
    cmp rsp, rbp
    jne .write
.end:
    pop rbp
    ret
;;; END OF write_int ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; dil: the char to write. rsi: pointer to memory location ;;;;;;;;;;;;;;;;;;;;;
write_char:
    mov byte [rsi], dil
    inc rsi
    ret
;;; END OF write_char ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; rdi: the int to print ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_int:
    ; write_int to stack
    push rsi
    sub rsp, 32 ; 1<<64 < 1e32
    mov rsi, rsp
    push rsi
    call write_int
    mov rdx, rsi
    pop rsi
    sub rdx, rsi
    mov edi, 1
    mov eax, 1
    syscall
    add rsp, 32
    pop rsi
    ret
;;; END OF print_int ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; dil: the char to print ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_char:
    push rsi
    push rcx
    push rdi ; dil is the lowest byte
    mov rsi, rsp
    mov edx, 1
    mov edi, 1
    mov eax, 1
    syscall
    pop rdi
    pop rcx
    pop rsi
    ret
;;; END OF print_char ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; dil: char to print. ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
safe_print_char:
    sub rsp, 128
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push rbp
    push r8
    push r9
    push r10
    push r11
    call print_char
    pop r11
    pop r10
    pop r9
    pop r8
    pop rbp
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    add rsp, 128
    ret
;;; END OF safe_print_char ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


err_illegal_char:
    ; output the char (in dil)
    mov rdi, 1
    jmp kill
err_char_unexp_eof:
    mov rdi, 2
    jmp kill
err_char_too_long:
    mov rdi, 3
    jmp kill
err_str_unexp_eof:
    mov rdi, 4
    jmp kill
err_unknown_escape_char:
    mov rdi, 5
    jmp kill
err_ukn_command:
    mov rdi, 6
    jmp kill
err_redef_id:
    mov rdi, 7
    jmp kill
err_stack_empty:
    mov rdi, 8
    jmp kill
err_ukn_id:
    mov rdi, 9
    jmp kill
test_output_stack:
    movzx rdi, word [rsp]
    call print_int
    mov dil, ','
    call print_char
    movzx rdi, word [rsp+2]
    call print_int
    mov dil, 10
    call print_char
    add rsp, 4
    cmp rsp, rbp
    jne test_output_stack
    mov rdi, 10
    jmp kill

segment readable writeable

prog db "(#abcde;=abcde,97;<<@abcde)", 0
trietest db "for"
prog2 db "(", 10, \
        "<<", 34, "Hello, World!\n", 34, ";", 10, \
        "#p, 26;", 10, \
        "#i;", 10, \
        "#number;", 10, \
        "#counter;", 10, \
        "#remainder;", 10, 10, \
        "=p, 2;", 10, \
        "=number, 3;", 10, \
        "=counter, 1;", 10, 10, \
        ":acc;", 10, \
        "    =i, 0;", 10, \
        "    :try_divide;", 10, \
        "        (=remainder, %@number; @p, i),", 10, \
        "        ?==@remainder; 0,", 10, \
        "        (", 10, \
        "            =number, +@number; 1;;", 10, \
        "            ->acc", 10, \
        "        );", 10, \
        "        =i, (+@i; 1);", 10, \
        "        ?&<@i; @counter; <*@p,i,@p,i; @number;", 10, \
        "            ->try_divide,", 10, \
        "    =$(+p, @counter), @number;", 10, \
        "    =counter, (+@counter; 1);", 10, \
        "    =number,  (+@number;  1);", 10, \
        "    ?<@number; 100,", 10, \
        "        ->acc;", 10, 10, \
        "$$p, i, number, counter;", 10, "0", 10, ")", 10, -1
escape_map db 34 dup (0xFF), 34, 4 dup (0xFF), 39, 8 dup (0xFF), 0, \
              43 dup (0xFF), 92, 17 dup (0xFF), 10, 0xFF, 0xFF, 0xFF, 13, \
              0xFF, 9, 11 dup (0xFF)
illegal_char_prefix   db "Illegal character: '"
illegal_char_prefix_l =  $-illegal_char_prefix
illegal_char_infix    db "' ("
illegal_char_infix_l  =  $-illegal_char_infix
illegal_char_suffix   db ").", 10
illegal_char_suffix_l =  $-illegal_char_suffix
char_unexp_eof        db "Unexpected EOF after '''.", 10
char_unexp_eof_l      =  $-char_unexp_eof
str_unexp_eof         db "Unexpected EOF after '", 34, "'.", 10
str_unexp_eof_l       =  $-str_unexp_eof
txt rb 65535 ; preprocessed program (64KB), 0xFFFF is reserved
i db 65536 dup \ ; interpreted program (640KB)
    (0xFF, 0xFF, 0, 0, 0, 0, 0xFF, 0xFF, 0xFF, 0xFF)
; each element in trie has 9B
; this char             1B
; unique id             2B   (0xFFFF = not assigned)
;   id = 0*,            max 32768
;   label = 10,         max 16384
;   command = 11,       max 16383
;     builtin = 110,    max 8192
;     custom = 111,     max 8191
; ptr to data           2B
;   if id, points to the memory location
;   if label, points to the index of the label command
;   if custom command, points to the "operation" invocable of the definition
; ptr to first child    2B
; ptr to next sibling   2B
trie db 0, 4 dup (0xFF), 1, 0, 0xFF, 0xFF, \
        '#', 0, 0xC0, 4 dup (0xFF), 2, 0, \
        '@', 2, 0xC0, 4 dup (0xFF), 3, 0, \
        '$', 4, 0xC0, 0xFF, 0xFF, 4, 0, 5, 0, \
        '$', 0x2B, 0xC0, 6 dup (0xFF), \
        '=', 5, 0xC0, 0xFF, 0xFF, 0x17, 0, 6, 0, \
        '<', 0x22, 0xC0, 0xFF, 0xFF, 7, 0, 8, 0, \
        '<', 8, 0xC0, 6 dup (0xFF), \
        '>', 0x23, 0xC0, 0xFF, 0xFF, 9, 0, 0xA, 0, \
        '>', 0xB, 0xC0, 6 dup (0xFF), \
        ']', 0xD, 0xC0, 4 dup (0xFF), 0xB, 0, \
        '[', 0x10, 0xC0, 4 dup (0xFF), 0xC, 0, \
        '+', 0x12, 0xC0, 4 dup (0xFF), 0xD, 0, \
        '-', 0x15, 0xC0, 0xFF, 0xFF, 0xE, 0, 0xF, 0, \
        '>', 0x29, 0xC0, 6 dup (0xFF), \
        '*', 0x17, 0xC0, 4 dup (0xFF), 0x10, 0, \
        '/', 0x1A, 0xC0, 4 dup (0xFF), 0x11, 0, \
        '%', 0x1B, 0xC0, 4 dup (0xFF), 0x12, 0, \
        '!', 0x1D, 0xC0, 4 dup (0xFF), 0x13, 0, \
        '~', 0x1E, 0xC0, 4 dup (0xFF), 0x14, 0, \
        '&', 0x1F, 0xC0, 4 dup (0xFF), 0x15, 0, \
        '|', 0x20, 0xC0, 4 dup (0xFF), 0x16, 0, \
        '^', 0x21, 0xC0, 4 dup (0xFF), 0x18, 0, \
        '=', 0x24, 0xC0, 6 dup (0xFF), \
        '(', 0x25, 0xC0, 4 dup (0xFF), 0x19, 0, \
        '?', 0x26, 0xC0, 4 dup (0xFF), 0x1A, 0, \
        ':', 0x28, 0xC0, 4 dup (0xFF), 0x1B, 0, \
        '{', 0x2A, 0xC0, 6 dup (0xFF), \
        65507 dup (0, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF)
max_arg db 0xC000 dup (0, 0), 2, 0, 0xFF, 0xFF, 2, 0, 0xFF, 0xFF, 1, 0, 0xFF, \
           0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x3FF7 dup (0xFF, 0xFF)
