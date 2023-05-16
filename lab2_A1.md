a) **Sinn und Zweck des vom CPU-Hersteller definierten ABI:**
   Der Sinn und Zweck des vom CPU-Hersteller definierten ABI besteht darin, eine einheitliche Methode zur Interaktion zwischen Software und Hardware bereitzustellen. Es ermöglicht die Kompatibilität von Programmen mit dem CPU-Design und erleichtert die Portabilität von Software auf verschiedenen Plattformen, die das ABI unterstützen.

b) **Wesentliche Festlegungen des ABI:**pukpuk
   Das ABI trifft wesentliche Festlegungen bezüglich der Nutzung der CPU-Register. Es gibt spezifische Register für die Rückgabewerte von Funktionen (r2 und r3) und für die Übertragung von Parametern an Unterprogramme (r4 bis r7). Es definiert auch die Nutzung der allgemein nutzbaren Register r8 bis r23, indem es Regeln für ihre Verwendung festlegt, um die Konsistenz und Sicherheit bei der Nutzung dieser Register zu gewährleisten.

c) **Parameterübergabe für NIOS II CPU:**
   Für die NIOS II CPU werden die Parameter int x und float y des Unterprogramms "double sub1(int x, float y)" in den Registern r4 und r5 übergeben. Der Rückgabewert vom Typ double wird in den Registern r2 und r3 zurückgegeben.

d) **Nutzung der Registergruppe 2 (r16 bis r23):**
   Eine elementare Regel bei der Nutzung der zur Gruppe 2 gehörenden Register r16 bis r23 besteht darin, dass der Inhalt dieser Register vor dem Überschreiben auf dem Stack gesichert und nach dem Unterprogrammaufruf wiederhergestellt werden muss. Dies gewährleistet, dass die in den Registern gespeicherten Daten nach dem Unterprogrammaufruf erhalten bleiben und das aufrufende Programm auf sie zugreifen kann.
