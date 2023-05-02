# Erstellen Sie ein Assemblerprogramm, welches die folgenden Anforderungen erfüllt:
# Das Programm liest eine im Speicher an der Adresse AdrZahl1 abgelegte 32 Bit Ganzzahl
#Zahl1. Ist diese Zahl größer als der Maximalwert 100, wird das Programm nicht weiter
# ausgeführt. Ist die Zahl kleiner als 100, so soll die Summe aller Ganzzahlen x mit
# 0<x≤Zahl1 gebildet und im Speicher an der Adresse AdrSumme abgelegt werden.

# Symbolische Konstanten ######################

# Speicherereich für Daten #####################
.data
AdrZahl1: .word 0      # Adresse von Zahl1
AdrSumme: .word 0      # Adresse von Summe
MaxWert: .word 100     # Maximalwert

# Speicherereich für Programm #################
.global _start
.text
_start:
    # Zahl1 lesen
    movia r4, AdrZahl1  # Adresse von Zahl1 in r4 laden
    ldw r5, (r4)        # Zahl1 in r5 laden
    
    # Prüfen, ob Zahl1 größer als Maximalwert ist
    movia r6, MaxWert   # Maximalwert in r6 laden
    bge r5, r6, End     # Wenn Zahl1 >= Maximalwert, Programm beenden
    
    # Summe berechnen
    movi r2, 1          # x = 1
    movia r3, AdrSumme  # Adresse von Summe in r3 laden
    movi r7, 0          # Summe auf 0 setzen
    
Loop:
    add r7, r7, r2      # Summe = Summe + x
    addi r2, r2, 1      # x = x + 1
    bgt r2, r5, Done    # Wenn x > Zahl1, aus der Schleife aussteigen
    stw r7, (r3)        # Summe in Speicher ablegen
    br Loop             # Nächster Schleifendurchlauf
    
Done:
    stw r7, (r3)        # Endgültige Summe in Speicher ablegen
    
End:
    br End              # Programm beenden
