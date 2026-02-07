#
# System call macros for x86_64
#
# These macros simplify making system calls by handling register setup.
# They clobber rcx and r11 (as per syscall instruction) and rax (return value).
#

#
# sys_write - Write to a file descriptor
#
# fd:    File descriptor
# buf:   Buffer to write
# count: Number of bytes to write
#
.macro sys_write fd, buf, count
  mov rdi, \fd
  mov rsi, \buf
  mov rdx, \count
  mov rax, 1
  syscall
.endm

#
# sys_exit_group - Exit the process
#
# code: Exit status code
#
.macro sys_exit_group code
  mov rdi, \code
  mov rax, 231
  syscall
.endm

#
# strlen - String Length
#
# Calculates the length of a null-terminated string.
#
# str_reg: Register containing the string pointer
# len_reg: Register to store the result length
#
# Clobbers: rcx, al, rdi
#
.macro strlen str_reg, len_reg
  mov rdi, \str_reg
  xor al, al
  mov rcx, -1
  cld
  repne scasb
  mov \len_reg, -2
  sub \len_reg, rcx
.endm

#
# call_weak - Call Weak Symbol
#
# Checks if a weak symbol exists (offset != 0) and calls it.
#
# func: Name of the weak function symbol
#
# Clobbers: rax
#
.macro call_weak func
  mov rax, offset \func
  test rax, rax
  jz 1f
  call rax
1:
.endm
