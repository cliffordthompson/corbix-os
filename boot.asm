;;; ====================================================================================================
;;;
;;;  Copyright (c) 2019 Clifford Thompson
;;;
;;;  This program is free software: you can redistribute it and/or modify
;;;  it under the terms of the GNU General Public License as published by
;;;  the Free Software Foundation, either version 3 of the License, or
;;;  (at your option) any later version.
;;;
;;;  This program is distributed in the hope that it will be useful,
;;;  but WITHOUT ANY WARRANTY ; without even the implied warranty of
;;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;  GNU General Public License for more details.
;;;
;;;  You should have received a copy of the GNU General Public License
;;;  along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;;
;;; ====================================================================================================

;;; ====================================================================================================
;;; boot.asm
;;; Print OS name on the screen and hang
;;; ====================================================================================================

;; Tell the assembler that the code should be loaded
;; at address 0x7C00. This is where the BIOS will
;; start execution of bootloaders.
org 0x7C00

;; Jump over the data section and start execution of
;; the bootloader.
jmp main

;;; ====================================================================================================
;;; Data Section
;;; ====================================================================================================

welcome_string db 'Welcome to Corbix OS v0.3!', 0
cpuid_string db 'CPUID: ', 0
;;vendor_string resb 48
hang_string db 'Hanging!', 0

;;; ====================================================================================================
;;; start
;;; ====================================================================================================

main:
	call print_welcome
	call print_cpuid

.hang:				; Hang!
;;	call print_hang
	jmp .hang

;;; ====================================================================================================
;;; print_string
;;; ====================================================================================================

print_string:
	mov ah, 0x0E

.repeat:
	lodsb
	cmp al, 0x0
	je .done
	int 0x10
	jmp .repeat

.done:
	mov al, 0x0a		; nl
	int 0x10
	mov al, 0x0d 		; cr
	int 0x10
	ret

;;; ====================================================================================================
;;; print_welcome
;;; ====================================================================================================

print_welcome:
	mov si, welcome_string
	call print_string
	ret

;;; ====================================================================================================
;;; print_cpuid
;;; ====================================================================================================

print_cpuid:
	mov si, cpuid_string
	call print_string
	ret

;;; ====================================================================================================
;;; print_hang
;;; ====================================================================================================

print_hang:
	mov si, hang_string
	call print_string
	ret

;;; ====================================================================================================
;;; ====================================================================================================
;;; ====================================================================================================
;;; ====================================================================================================


;; Fill the remaining space is 0s
times	510-($-$$) db 0

;; Add the standard signature for boot sectors
dw 0x0AA55
