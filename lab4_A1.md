Die NIOS II CPU verwendet "rdctl" und "wrctl", um auf CPU-Steuerregister zuzugreifen, während "mov" für den Transfer zwischen allgemeinen Zweckregistern genutzt wird. "rdctl" liest ein Steuerregister in ein allgemeines Zweckregister, während "wrctl" den umgekehrten Vorgang ermöglicht.
    
"trap" wird verwendet, um eine Software-Exception auszulösen und spezielle Behandlungen durchzuführen.

 Wenn die NIOS II CPU die für "div r5, r4, r3" benötigte Hardware nicht hat, kann entweder ein Fehler gemeldet oder eine spezielle Unterbrechung oder Exception ausgelöst werden.
 
Im Exception-Handler kann überprüft werden, ob die Ursache für eine Exception ein Interrupt war, indem das entsprechende Interrupt-Steuerregister überprüft wird.
