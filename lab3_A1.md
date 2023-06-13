• Welche Bedeutung haben die Register periodl und periodh?

• Wie kann der Timer gestartet, wie kann er gestoppt werden?

• Der Timer soll nicht im Interrupt-Modus betrieben werden. Wie kann das Erreichen einer vorgegebenen Verzögerungszeit (Timeout-Periode) festgestellt werden?

Antwort:

Die Register `periodl` und `periodh` speichern den Timeout-Wert des Timers. Der Timer zählt von diesem vorgegebenen Wert herunter. `periodl` enthält die Bits [15:0] des Timeout-Werts, während `periodh` die Bits [31:16] speichert.

Der Timer kann gestartet werden, indem das Start-Bit (Bit 2) im Steuerregister `control` auf 1 gesetzt wird. Um den Timer zu stoppen, kann das Stop-Bit (Bit 3) im Steuerregister `control` auf 1 gesetzt werden.

Um das Erreichen einer vorgegebenen Verzögerungszeit (Timeout-Periode) festzustellen, kann das Timeout-Bit (TO) im Statusregister `status` überwacht werden. Das TO-Bit wird auf 1 gesetzt, sobald der interne Zähler den Wert Null erreicht. Um das TO-Bit zurück auf 0 zu setzen, muss Null in das Statusregister `status` geschrieben werden. Auf diese Weise kann das Erreichen der vorgegebenen Verzögerungszeit über das TO-Bit festgestellt werden.
