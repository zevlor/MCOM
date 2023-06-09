# Input: r4 - Delay value (number of clock cycles)
init_timer:
    movia r16, 0xFF202004   # Load the address of the control register into r16
    movia r17, 0xFF202000   # Load the address of the status register into r17
    movia r18, 0xFF202008   # Load the address of the periodl register into r18
    movia r19, 0xFF20200C   # Load the address of the periodh register into r19

    andi r20, r4, 0xFFFF    # Mask out the upper 16 bits of the delay value (lower 16 bits remain)
    srli r21, r4, 16        # Shift right the delay value by 16 bits (to extract the upper 16 bits)

    stw r20, (r18)          # Store the lower 16 bits of the delay value to periodl register
    stw r21, (r19)          # Store the upper 16 bits of the delay value to periodh register

    movi r22, 2             # Set the START bit (bit 2) in the control register
    stw r22, (r16)          # Start the timer by writing to the control register
    ret

wait_timer:
    ldw r23, (r17)          # Read the value of the status register
    andi r23, r23, 1        # Mask out all bits except the TO bit (bit 0)
    beq r23, r0, wait_timer # Repeat the loop if the TO bit is not set

    ret

