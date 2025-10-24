Progettazione di memoria a stack (LIFO)

Membri: <br>
-Edoardo Nicitra <br> 
-Ismaele Negri

<br>Ultima modifica: sistemato il dout e tutti i casi limite, ora dovremmo controllare la questione dei fronti di salita e discesa, più non so se altre cose da verificare
                     -aggiunto il reset del dout alla fine del ciclo di clock (non so se necessario)
                     -il rst assegna tutto a prescindere dal ciclo di clock, mentre il clear aspetta il fronte di salita => OK
                     - ho rimesso i generic (si sono scemo, li avevo tolti)
TODO: test sul modello Post Place & Route. 

<br>Ultima Modifica (da confermare): problema del generic + fare gli assert
