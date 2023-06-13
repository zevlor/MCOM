init_timer:
  movi r5, 0xFF202008   ; Adresse des Registers periodl
  str r4, [r5]          ; Verzögerungswert in periodl schreiben
  
  movi r5, 0xFF20200C   ; Adresse des Registers periodh
  str r4, [r5]          ; Verzögerungswert in periodh schreiben
  
  ret

wait_timer:
  movi r5, 0xFF202004   ; Adresse des Registers control
  
  movi r6, 2            ; Wert 2 für das Start-Bit
  str r6, [r5]          ; Timer starten
  
  loop:
    ldr r7, [r5]        ; Control-Register auslesen
    andi r7, r7, 0x1    ; Nur das RUN-Bit überprüfen
    beq loop            ; Warten, bis das RUN-Bit auf 0 gesetzt ist
  
  ret
