SECTION .data

    inputBuf:
        db  0x83,0x6A,0x88,0xDE,0x9A,0xC3,0x54,0x9A

    inputlen equ $ - inputBuf

    countIN:
        dd 0x8 

SECTION .bss

    outputBuf: resb 80

section .text
    global _start

_start:

    XOR ESI, ESI ;input buffer
    XOR EDI, EDI ;output buffer
    
     


;; converts to ascii and then adds to output buffer
while: ;; use a while loop to go through input buffer

    
    CMP ESI, inputlen ;;until loop is at the end of input buffer
    JGE Print_Output

    MOVZX EAX, byte [inputBuf + ESI]
    mov edx, eax

;;Reads the first four bits of hex digit
    
High:
    mov ecx, edx         ; Copy input byte
    and ecx, 0xF0        ; Mask high nibble
    shr ecx, 4           ; Shift to low position
;
;if statement
    cmp cl, 9
    jle else ;;less than or equal to
    add cl, 0x37         ; ASCII 'A' to 'F'
    mov [outputBuf + edi], cl
    inc edi
    JMP Low

else: ;converts ascii sigit to 0-9
    add cl, 0x30         ; ASCII '0' to '9'
    mov [outputBuf + edi], cl
    inc edi

;Reads the last 4 bits of the hex digits
Low:

    mov ecx, edx         ; Copy
    and ecx, 0x0F        ; Mask low 4 bits

;if statement
    cmp cl, 9
    jle Low_else
    add cl, 0x37         ; ASCII 'A' to 'F'
    mov [outputBuf + edi], cl
    inc edi
    JMP store

;;if the digit is a number
Low_else:
    add cl, 0x30         ; ASCII '0' to '9'
    mov [outputBuf + edi], cl
    inc edi
   
store:;;adds the bits to the output buffer(edi)
    mov byte [outputBuf + edi], 0x20 ;add space character to buffer
    inc edi



    
End_While: 
;end of while loop section that increments the
;input buffer to move on

    INC ESI
    JMP while

;;Prints out ascii characters
Print_Output:

    mov byte [outputBuf + edi], 0
    
    ; Write output buffer to be outputted on screen
    mov eax, 4         ; syscall: write
    mov ebx, 1         
    mov ecx, outputBuf ; buffer to write
    mov edx, edi       
    int 0x80
    
    
    ; Exit program
    mov eax, 1         
    xor ebx, ebx       
    int 0x80

