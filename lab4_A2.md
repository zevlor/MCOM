init_Buttons_PIO initialisiert die Buttons-PIO für die Interrupt-Generierung und aktiviert die Interrupts für die Tasten KEY0 und KEY3.

init_intController initialisiert den Interrupt-Controller und aktiviert die Interrupts für die Buttons-PIO sowie die CPU-Interrupts.

Die Interrupt-Latenzzeit eines Systems ist die Verzögerung zwischen dem Auftreten eines Interrupts und der Ausführung des entsprechenden Interrupt-Handlers. Eine niedrige Interrupt-Latenzzeit ermöglicht eine schnellere Reaktion auf Interrupts, während eine hohe Latenzzeit zu Verzögerungen führen kann
