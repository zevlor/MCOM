# An die PIO-Ausgabeeinheit LEDs sind zehn LEDs angeschlossen (Abbildung 2-1). Im
# Simulator sind diese LEDs im rechten oberen Bereich des Benutzerfensters dargestellt
# (Abbildung 3-1). Die PIO verfügt über nur ein Datenregister. Bit 0 dieses Registers
# steuert LED0, Bit 1 steuert LED1 usw.. Ist eines dieser Bits gesetzt (logisch '1') so
# leuchtet die korrespondierende LED, andernfalls nicht.
# Erstellen Sie ein Unterprogramm 'write_LED'. Im Register r4 soll dem Unterprogramm
# ein Zahlenwert übergeben. Die Bits dieses Zahlenwerts werden mit Hilfe der LEDs
# visualisiert. Ist Bit 0 des Zahlenwertes gesetzt, so soll LED0 leuchten, ist Bit 1 gesetzt, so
# soll LED1 leuchten usw..

# Load the base address of the PIO into a register (let's use r5).
# Load the LED mask into another register (let's use r7).
# Set the bit position to 0 (let's use r6).
# Loop through the bits of the value in r4, starting with the least significant bit.
# Extract the current bit of the value using a bitwise AND operation with the mask.
# Shift the bit to the correct position using a shift left logical (SLL) operation with the bit position.
# Write the resulting value to the PIO using a store word (STW) operation with the base address in r5.
# Increase the bit position by 1.
# If there are more bits to process, go back to step 5.
# Restore the values of r5, r6, and r7 from the stack.
# Return to the calling code using the return (RET) instruction.

.global _start
_start:
