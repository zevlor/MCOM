###############################################
# MCOM-Labor: Tastendruckzählwerk
# Alaa Alnimat
###############################################

###############################################
# Definition von Symbolen und Konstanten
###############################################
.equ LEDS_BASE, 0xFF200000  # Base address of LED PIO
.equ BUTTONS_BASE, 0xFF200050  # Base address of Button PIO

###############################################
# DATA SECTION
###############################################
.data
counter:
    .word 0     # Counter variable

###############################################
# TEXT SECTION
###############################################
.text
.global _start
_start:
    movia r4, counter        # Load counter address into r4
    movi r5, 1              # Constant value 1 for incrementing
    movi r6, -1             # Constant value -1 for decrementing

loop:
    # Read button inputs
    movia r7, BUTTONS_BASE      # Load base address of button PIO into r7
    ldw r8, (r7)           # Read button states into r8

    # Check if KEY0 (Zähltaste) is pressed
    andi r9, r8, 1          # Mask to check KEY0 state
    bne r9, r0, increment_counter  # Branch if KEY0 is pressed

    # Check if KEY1 (Runterzähltaste) is pressed
    andi r9, r8, 2          # Mask to check KEY1 state
    bne r9, r0, decrement_counter  # Branch if KEY1 is pressed

    # Check if KEY3 (Löschtaste) is pressed
    andi r9, r8, 8          # Mask to check KEY3 state
    beq r9, r0, loop        # Continue the loop if KEY3 is not pressed

    # Reset counter if KEY3 is pressed
    movia r10, 0             # Set counter value to 0
    stw r10, (r4)           # Store reset counter value
    call update_leds        # Call the subroutine to update LEDs
    br loop             # Repeat the loop

increment_counter:
    # Increment counter if KEY0 is pressed
    ldw r10, (r4)           # Load counter value into r10
    add r10, r10, r5          # Add 1 to counter value
    stw r10, (r4)           # Store updated counter value
    call update_leds        # Call the subroutine to update LEDs
    br loop             # Repeat the loop

decrement_counter:
    # Decrement counter if KEY1 is pressed
    ldw r10, (r4)           # Load counter value into r10
    add r10, r10, r6          # Subtract 1 from counter value
    stw r10, (r4)           # Store updated counter value
    call update_leds        # Call the subroutine to update LEDs
    br loop             # Repeat the loop

update_leds:
    # Update LED display based on the counter value
    movia r11, LEDS_BASE        # Load base address of LED PIO into r11
    stw r10, (r11)          # Store counter value to LED PIO
    ret                     # Return from the subroutine

###############################################
.end
