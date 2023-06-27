Das Unterprogramm init_Buttons_PIO initialisiert die Buttons-PIO-Interrupts, indem es die entsprechenden Bits im Interrupt-Maskenregister setzt. Es ermöglicht dem System, auf Tastenbetätigungen zu reagieren. Es sollte im Anwenderprogramm aufgerufen werden, um die Buttons-Interrupts zu initialisieren.

Das Unterprogramm init_intController initialisiert den Interrupt-Controller. Es aktiviert die Buttons-PIO-Interrupts und die CPU-Interrupts, indem es die entsprechenden Bits in den Steuerregistern setzt. Es sollte im Anwenderprogramm aufgerufen werden, um den Interrupt-Controller und die CPU für die Behandlung von Interrupts vorzubereiten.

Die Interrupt-Latenzzeit eines Systems ist die Verzögerung zwischen dem Auftreten eines Interrupts und der Ausführung des entsprechenden Interrupt-Handlers. Eine niedrige Interrupt-Latenzzeit ermöglicht eine schnellere Reaktion auf Interrupts, während eine hohe Latenzzeit zu Verzögerungen führen kann
