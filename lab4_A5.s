###############################################################
#            MCOM-Labor: assembly language template 2
#
# HAVE CARE:
# Because exception handler will be located at the beginning of
# sdram memory (address 0x800020), .text section is not allowed
# to use this memory area. Therefore we have to specify an 
# offset of 0x200 for the .text section. Therefore exception
# handler size should not exceed 0x200 bytes!!!
#
# Edition History:
# 28-04-2009: Getting Started                            - ms
# 12-03-2014: Stack organization changed                 - ms
# 2016-05-25: Code cosmetics                             - ms
# 2017-04-29: Adapted to DE1-SoC board                   - ms
# 2023-05-16: Adapted to CPUlator                        - ms
# 2023-05-16: Template extraction                        - ms
###############################################################

###############################################
# Definition von symbolen Konstanten
###############################################
	.equ STACK_SIZE, 0x400		# stack size
	.equ	LEDS, 	 0xFF200000	# base address of port LEDS
	.equ	BUTTONS, 0xFF200050	# base address of port Buttons
	
	.equ	BUTTONS_IRQ, 0x02	# Buttons PIO IRQ Level
	.equ	KEY3, 		0x8		# KEY3 BITMASK
	.equ	KEY0, 		0x1		# BITMASK für KEY0
	.equ	PIE, 		0x1		# CPU's interrupt enable bit

# push and pop macros
.macro push rX
	subi sp, sp, 4
	stw \rX, (sp)
.endm

.macro pop rX
	ldw \rX, (sp)
	addi sp, sp, 4
.endm

###############################################################
# DATA SECTION
# Assumption: 12 kByte data section (0 - 0x2fff) stack is 
# located in data section and starts directly behind used data
# items at address STACK_END.
# Stack is growing downwards. Stack size is given by STACK_SIZE.
# A full descending stack is used, accordingly first stack item
# is stored at address STACK_END+(STACKSIZE).
###############################################################
	.data
TST_PAK1:
	.word 0x11112222	# test data
tp_adr:
	.word 20			# LED on time in 0.1 ms steps

STACK_END:
	.skip STACK_SIZE	# stack area filled with 0

LEDS_BASE: .word    0xFF200000
status: .word   0xFF202000
control:    .word   0xFF202004
periodl:    .word   0xFF202008
periodh:    .word   0xFF20200C
snapl:  .word   0xFF202010
snaph:  .word   0xFF202014

###############################################################
# EXCEPTIONS SECTION
# Note: By using keyword ".exceptions" this section will
# automatically be placed at the correct position, which 
# normally is address 0x20.
###############################################################
.section .exceptions, "ax"
interrupt_handler:

	# Save used registers on stacks, r31 must be saved because
	# subroutines are used, r8 has to be saved because we are
	# executing an ISR
	push r8
	push r31
	
	# Check if a Buttons PIO interrupt has occured	
	rdctl et, ctl4				# read interrupt pending reg.
	andi r8, et, BUTTONS_IRQ	# check Buttons interrupt
	beq r8, zero, end_ir		# if no Buttons interrupt
								# exit exception handler

	# Check if KEY0 is the source for Buttons interrupt
	movia et, BUTTONS
	ldw r8, 0xC(et)				# read Buttons PIO edgecapture register
	andi r8, r8, KEY0			# mask KEY0 related bit
	beq r8, zero, btn3_isr
	call KEY0_ISR				# KEY0 has been pressed, do the
								# corresponding interuupt handling

	# clear KEY0 related interrupt
	movi r8, KEY0				# by setting the corresponding bit
	stw r8, 0xC(et)				# in edgecapture register
	br end_ir


	# Check if KEY3 is the source for Buttons interrupt
btn3_isr:
	movia et, BUTTONS
	ldw r8, 0xc(et)				# read Buttons PIO edgecapture reg.
	andi r8, r8, KEY3			# mask KEY3 related bit
	beq r8, zero, end_ir
	call KEY3_ISR				# KEY3 has been pressed, do the
								# corresponding interrupt handling
	
	# clear KEY3 related interrupt
	movi r8, KEY3				# by setting the corresponding bit
	stw r8, 0xC(et)				# in edgecapture register

end_ir:
	# restore used registers from stack
	pop r31
	pop r8
	
	# Leave exception handler
	subi ea, ea, 4
	eret

	
###############################################################
# KEY0_ISR: KEY0 related interrupt handler.
# PWM period time is 100 x 0.1 ms. If LED on-time value is 
# smaller than 100, which means that the delay is smaller than 
# 10 ms, than this value will be incremented in order to 
# increase LEDs intensity.
###############################################################
KEY0_ISR:
		push r8
		push r15
		push r9
		
		movi r9, 100
        movia r8, tp_adr
        ldw r8, (r8)
		
		bge r8, r9, KEY0_SKIP
		
        addi r8, r8, 1
		KEY0_SKIP:
		movia r15, tp_adr
        stw r8, (r15)
		
		
		pop r9
        pop r15
		pop r8
	ret
	
###############################################################
# KEY3_ISR: KEY3 related interrupt handler.
# PWM period time is 100 x 0.1 ms. If LED on-time value is 
# greater or equal to 0, than this value will be incremented 
# in order to decrease LEDs intensity.
###############################################################
KEY3_ISR:
		push r8
		push r15
		
        movia r8, tp_adr
        ldw r8, (r8)
		
		ble r8, r0, KEY3_SKIP
		
        subi r8, r8, 1
		KEY3_SKIP:
		movia r15, tp_adr
        stw r8, (r15)
		
		pop r15
		pop r8
	ret
	
###############################################################
# TEXT SECTION
# Executable code follows
###############################################################
	.global _start
	.text
_start:
	#######################################
	# stack setup:
	# HAVE Care: By default JNiosEmu sets stack pointer sp = 0x40000.
	# That stack is not used here, because SoPC does not support
	# such an address range. I. e. you should ignore the STACK
	# section in JNiosEmu's memory window.
	
	movia	sp, STACK_END		# load data section's start address
	addi	sp, sp, STACK_SIZE	# stack start position should
								# begin at end of section

	# Enter your code here ...
call init_intController
call init_Buttons_PIO


loop:

    movia r8, 100
    movia r15, tp_adr
    ldw r15, (r15)
    sub r9, r8, r15
    
    movi r5, 3
    call update_leds
    mov r4, r9
    call wait
    
    
    movi r5, 15
    call update_leds
    movia r15, tp_adr
    ldw r4, (r15)
    call wait
    
    br loop

init_timer:
    
    movia r15, status
    ldw r15, (r15)
    stwio r0, (r15)
    
    andi r8, r4, 0xFFFF    
    srli r9, r4, 16
    
    movia r15, periodl
    ldw r15, (r15)
    stwio r8, (r15)   
    movia r15, periodh
    ldw r15, (r15)      
    stwio r9, (r15)         
    
    movi r8, 4
    movia r15, control
    ldw r15, (r15)  
    stwio r8, (r15)          
    ret

wait_timer:
    movia r15, status
    ldw r15, (r15)
    ldwio r8, (r15)          
    andi r8, r8, 1        
    beq r8, r0, wait_timer 

    ret




wait:
    movia r11, 10000
    mul r4, r4, r11     
    push ra
    
    call init_timer     
    call wait_timer
    
    pop ra
    ret
update_leds:

    movia r15, LEDS_BASE
    ldw r15, (r15)              
    stwio r5, (r15)          
    ret



endloop:
	br endloop		# that's it


###############################################################
# init_Buttons_PIO
# Initialize Buttons PIO for interrupt
# generation. KEY0 and KEY3 related interrupts
# will be enabled.
###############################################################
init_Buttons_PIO:
	# enable KEY0 and KEY3 interrupts in Buttons PIO
	# interrupt mask register
	movia r8, KEY3
	movia r9, KEY0
	or r9, r9, r8
	movia r8, BUTTONS
	stw r9, 8(r8)
	ret

###############################################################
# init_intController
###############################################################
init_intController:
	# enable (unmask) Buttons PIO interupts
	movia r8, BUTTONS_IRQ
	rdctl r9, ctl3
	or r9, r9, r8
	wrctl ctl3, r9

	# enable CPU interrupts
	movia r8, PIE
	rdctl r9, ctl0
	or r9, r9, r8
	wrctl ctl0, r9
 
	ret

###############################################################

	.end

