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

loop:
    # Read button inputs
    movia r6, BUTTONS_BASE      # Load base address of button PIO into r6
    ldw r7, (r6)           # Read button states into r7

    # Check if KEY0 (Zähltaste) is pressed
    andi r8, r7, 1          # Mask to check KEY0 state
    bne r8, r0, wait_increment  # Branch if KEY0 is pressed

    # Check if KEY3 (Löschtaste) is pressed
    andi r8, r7, 8          # Mask to check KEY3 state
    beq r8, r0, loop        # Continue the loop if KEY3 is not pressed

    # Reset counter if KEY3 is pressed
    movia r9, 0             # Set counter value to 0
    stw r9, (r4)           # Store reset counter value
    call update_leds        # Call the subroutine to update LEDs
    br loop             # Repeat the loop

wait_icrement:
	# Read button inputs
    movia r6, BUTTONS_BASE      # Load base address of button PIO into r6
    ldw r7, (r6)           # Read button states into r7
	
	# Check if KEY0 (Zähltaste) is pressed
    andi r8, r7, 1          # Mask to check KEY0 state
    bne r8, r0, wait_increment  # Branch if KEY0 is pressed
	br increment_counter  


increment_counter:
    # Increment counter if KEY0 is pressed
    ldw r9, (r4)           # Load counter value into r9
    add r9, r9, r5          # Add 1 to counter value
    stw r9, (r4)           # Store updated counter value
    call update_leds        # Call the subroutine to update LEDs
    br loop             # Repeat the loop

update_leds:
    # Update LED display based on the counter value
    movia r10, LEDS_BASE        # Load base address of LED PIO into r10
    stw r9, (r10)          # Store counter value to LED PIO
    ret                     # Return from the subroutine

###############################################
.end
