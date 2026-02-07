.intel_syntax noprefix
.altmacro

.include "macro.s"

.section .text

.weak main
.weak __ww_init
.weak __ww_fini
.globl _ARGC
.globl _ARGV
.globl _ENV

#
# _start - Entry Point
#
# Entry point of the program. Initializes the environment, calls initializers,
# main, and finalizers.
#
.globl _start
.type _start, @function
_start:
  .cfi_startproc

  xor rbp, rbp
  
  # Save argc, argv, envp to global variables
  mov rdi, [rsp]           # argc
  lea rsi, [rsp + 8]       # argv
  lea rdx, [rsi + rdi * 8] # envp

  mov [_ARGC], rdi
  mov [_ARGV], rsi
  mov [_ENV], rdx

  # Align stack to 16 bytes
  and rsp, -16

  call_weak __ww_init
  call_weak main
  
  # Result of main (or 0 if main didn't exist) is in rax
  mov rdi, rax

  call_weak __ww_fini
  
  call _exit

  .cfi_endproc
.size _start, . - _start

#
# _exit - Exit Program
#
# Exits the program with a status code.
#
# rdi: Exit status code
#
.globl _exit
.type _exit, @function
_exit:
  .cfi_startproc

  sys_exit_group rdi
  hlt

  .cfi_endproc
.size _exit, . - _exit

#
# _panic - Panic
#
# Prints a panic message and exists with status 1.
#
# rdi: Pointer to the panic message string
#
.globl _panic
.type _panic, @function
_panic:
  .cfi_startproc

  push rdi

  sys_write 2, <offset __ww_panic_msg>, <offset __ww_panic_msg_len>

  mov rdi, [rsp]
  strlen rdi, rdx

  pop rsi
  sys_write 2, rsi, rdx

  mov rdi, 1
  call _exit

  .cfi_endproc
.size _panic, . - _panic

.section .rodata
__ww_panic_msg: .ascii "\x1b[1;31mpanic\x1b[1;0m:\x1b[0m "
__ww_panic_msg_len = . - __ww_panic_msg

.section .data
.align 8
_ARGC: .quad 0
_ARGV: .quad 0
_ENV: .quad 0

.section .note.GNU-stack,"",@progbits
