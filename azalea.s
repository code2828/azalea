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
; Each invocable starts with a command whose first and last characters must  ;
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
; $$ id                                                                       ;
;     Frees memory allocated for id.                                          ;
;     Returns sizeof memory / 4.                                              ;
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
;     Returns sbu - val; if sub is not given, returns val negated.            ;
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
;  : id                                                                       ;
;     Defines a label named id here.                                          ;
;     Returns nothing.                                                        ;
; -> label                                                                    ;
;     Jumps to label.                                                         ;
;     Returns nothing.                                                        ;
;  { string [, parameter...] } operation                                      ;
;     Defines a custom command "string" that can take parameters and invoke   ;
;         operation. The first and last char of string must not be one of     ;
;         A-Za-z0-9_,;(){}.                                                   ;
;     Returns the return value of the operation.                              ;
;  0 `any number literal`                                                     ;
;     Does nothing.                                                           ;
;     Returns its value.                                                      ;
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
    cmp rsi, rbx
    sub rsi, rbx
    mov word [txt], si
    xor rdx, rdx
    lea rsi, [txt+2]
    mov dx, word [txt]
    mov edi, 1
    mov eax, 1
    syscall
    xor edi, edi
    jmp kill
debug:
    push rdi
    mov dil, '!'
    call print_char
    pop rdi
    ret
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
    movsx rdi, dil
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
    pop rcx
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


; rdi: the int to write. rsi: pointer to memory location ;;;;;;;;;;;;;;;;;;;;;;
write_int:
    mov rcx, 10
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
    add rdx, '0'
    mov byte [rsp], dl
    dec rsp
    cmp rax, 0
    jnz @b
.write:
    inc rsp
    mov dil, byte [rsp]
    mov byte [rsi], dil
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
    mov byte [rsp], dil
    mov rsi, rsp
    mov edx, 1
    mov edi, 1
    mov eax, 1
    syscall
    pop rcx
    pop rsi
    ret
;;; END OF print_char ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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

segment readable writeable

prog db 34, "Hello, World!", 10, 34, 10, 39, "j", 39, 10, 0
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
txt rb 65536 ; preprocessed program (64KB)
stk rd 65536 ; stack (256KB)

