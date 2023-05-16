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
    movia r16, counter        # Load counter address into r16
    movi r17, 1              # Constant value 1 for incrementing
    movi r20, -1

loop:
call read_buttons

    # Check if KEY0 (Zähltaste) is pressed
    andi r8, r2, 1          # Mask to check KEY0 state
    bne r8, r0, wait_increment  # Branch if KEY0 is pressed

    # Check if KEY1 (Runterzähltaste) is pressed
    andi r8, r2, 2          # Mask to check KEY1 state
    bne r8, r0, wait_decrement  # Branch if KEY1 is pressed

    # Check if KEY3 (Löschtaste) is pressed
    andi r8, r2, 8          # Mask to check KEY3 state
    beq r8, r0, loop        # Continue the loop if KEY3 is not pressed

    # Reset counter if KEY3 is pressed
    movia r19, 0             # Set counter value to 0
    stw r19, (r16)           # Store reset counter value
    call update_leds        # Call the subroutine to update LEDs
    br loop             # Repeat the loop

                   # Return from the subroutine

wait_increment:
    call read_buttons
    # Check if KEY0 (Zähltaste) is pressed
    andi r8, r2, 1          # Mask to check KEY0 state
    bne r8, r0, wait_increment  # Branch if KEY0 is pressed
    br increment_counter  


wait_decrement:
    call read_buttons
    # Check if KEY1 (Zähltaste) is pressed
    andi r8, r2, 2          # Mask to check KEY1 state
    bne r8, r0, wait_decrement  # Branch if KEY1 is pressed
    br decrement_counter  

increment_counter:
    # Increment counter if KEY0 is pressed
    ldw r19, (r16)           # Load counter value into r19
    add r19, r19, r17          # Add 1 to counter value
    stw r19, (r16)           # Store updated counter value
    call update_leds        # Call the subroutine to update LEDs
    br loop             # Repeat the loop

decrement_counter:
    # Decrement counter if KEY1 is pressed
    ldw r19, (r16)           # Load counter value into r19
    add r19, r19, r20          # Add 1 to counter value
    stw r19, (r16)           # Store updated counter value
    call update_leds        # Call the subroutine to update LEDs
    br loop             # Repeat the loop

read_buttons:
# Read button inputs
    movia r15, BUTTONS_BASE      # Load base address of button PIO into r15
    ldw r2, (r15)           # Read button states into r2
ret  

update_leds:
    # Update LED display based on the counter value
    movia r18, LEDS_BASE        # Load base address of LED PIO into r18
    stw r19, (r18)          # Store counter value to LED PIO
    ret                     # Return from the subroutine

###############################################
.end
