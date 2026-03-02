Progettazione di memoria a stack (LIFO)

Membri: <br>
-Edoardo Nicitra <br> 
-Ismaele Negri

<br>Ultima Modifica : file ottimizzati in moduli per logica hardware-like + tb adeguati (to check)
<br>P.S possibili domande al professore:

- se dout può essere aggiornato in base a cosa c'è sempre sul puntatore dello stack. (parte commentata in fondo a memory)
- clear e rst chiarimento finale (reset di msig => others (others <=0) )
- se vuole logica con mux esplicitati come moduli 

RISPOSTE
-Prima di tutto mi ha rispiegato rst e clear, dicendomi che rst è non pilotato (non di ingresso) è un segnale "esterno" che restta. Quindi usarlo come asincrono e farrgli un solo test all'inizio per far vedere che funziona va bene. Clear invece è sincrono e pilotato, quindi tutti i ragionamenti che abbiamo fatto vanno bene. In piu aggiungo che mi ha detto che la memoria non c'è bisogno di settarla tutta con 0 dopo clear, basta spostare il puntatore, poichè tanto sovrascrive quando si fa push, MA non importa anceh se si fa con reset, poichè tutti fanno cosi e non toglie i punti per questo.

-Secondo quello che dobbiamo fare è avere una sintesi (un design), che dal top-level vede i moduli (connessi) che compongono lo stack. Quindi no ai mux esposti, solo moduli dall'esterno e poi all'interno dei vari  moduli quello che deve esserci (quindi anche i mux esposti).

-Per quanto riguarda la presentazione devo fare un po di robe. Inanzitutto devo fare un disegno abbastanza semplificato del top-levl. Poi per i moduli semplici cioè RCA e FULLADDER basta una semplicissima descrizione. Per i moduli più complessi vuole il funzionamento e un disegni incentrato perlopiù sulle parti che non sono componenti basi (con un disegno anche li semplificato (no mux, or, and o roba specifica)). Infine anche le operazioni dello stack (quelle "pilotate"), quindi clear, pop, push e gli errori, vanno spiegati con disegno (ovviamente spiegazione semplice di cosa accade quando si attivano). In piu aggiungo che su disegno pop e push e meglio farli con doppio pop e push, cosi sa che funziona anche in quel caso ed è felice.
