

###############################################
# Definition von Symbolen und Konstanten
###############################################
.equ LEDS_BASE, 0xFF200000  # Base address of LED PIO

###############################################
# DATA SECTION
###############################################
.data
DELAY: .word 5000


###############################################
# TEXT SECTION
###############################################
.text
.global _start
_start:
# Input: r4 - Delay value (number of clock cycles mutiplied my 10ns)

movia r8, DELAY
ldw r4, (r8)


movi r5, 1
call update_leds
call wait

movi r5, 3
call update_leds
call wait

movi r5, 7
call update_leds
call wait

movi r5, 15
call update_leds
call wait

call End

init_timer:
    movia r16, 0xFF202004   # Load the address of the control register into r16
    movia r17, 0xFF202000   # Load the address of the status register into r17
    movia r18, 0xFF202008   # Load the address of the periodl register into r18
    movia r5, 0xFF20200C   # Load the address of the periodh register into r5

    andi r20, r4, 0xFFFF    # Mask out the upper 16 bits of the delay value (lower 16 bits remain)
    srli r21, r4, 16        # Shift right the delay value by 16 bits (to extract the upper 16 bits)

    stw r20, (r18)          # Store the lower 16 bits of the delay value to periodl register
    stw r21, (r5)          # Store the upper 16 bits of the delay value to periodh register

    movi r22, 4             # Set the START bit (bit 2) in the control register
    stw r22, (r16)          # Start the timer by writing to the control register
    ret

wait_timer:
    ldw r23, (r17)          # Read the value of the status register
    andi r23, r23, 1        # Mask out all bits except the TO bit (bit 0)
    beq r23, r0, wait_timer # Repeat the loop if the TO bit is not set

    ret

wait:
    movia r11, 10000
    mul r4, r4, r11     # Multiply r4 by 10000 to have 0.1 ms cycles
    call init_timer        # Call the init_timer subroutine to set up the timer with the desired delay
    call wait_timer        # Call the wait_timer subroutine to wait for the specified time

    ret



update_leds:
    # Update LED display based on the counter value
    movia r18, LEDS_BASE        # Load base address of LED PIO into r18
    stw r5, (r18)          # Store counter value to LED PIO
    ret                     # Return from the subroutine


###############################################
End:
    br End
