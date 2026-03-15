Progettazione di memoria a stack (LIFO)

Membri: <br>
-Edoardo Nicitra <br> 
-Ismaele Negri

<br>Ultima Modifica : Finita implementazione e organizzati moduli per logica hardware-like + TB adeguati + Finita implementazione

DOMANDE
- se dout può essere aggiornato in base a cosa c'è sempre sul puntatore dello stack. (parte commentata in fondo a memory)
- clear e rst chiarimento finale (reset di msig => others (others <=0) )
- se si vuole logica con mux esplicitati come moduli
- se isEmpty & isFull vanno aggiornati nello stesso ciclo di clock o con un ciclo di ritardo.

RISPOSTE
- Rst è non pilotato (non di ingresso) è un segnale "esterno" che resetta, quindi va bene usarlo come asincrono e fargli un solo test all'inizio per far vedere che funziona. 
- Clear invece è sincrono e pilotato, quindi tutti i ragionamenti che abbiamo fatto vanno bene. 
- La memoria non c'è bisogno di settarla tutta con 0 dopo clear, basta spostare il puntatore, poichè tanto sovrascrive quando si fa push, MA non importa anche se si fa con reset.

-Secondo quello che dobbiamo fare è avere una sintesi (un design), che dal top-level vede i moduli (connessi) che compongono lo stack. Quindi no ai mux esposti, solo moduli dall'esterno e poi all'interno dei vari  moduli quello che deve esserci (quindi anche i mux esposti).

-Per quanto riguarda la presentazione, Iinanzitutto devo fare un disegno abbastanza semplificato del top-level. Poi per i moduli semplici cioè RCA e FULLADDER basta una semplicissima descrizione. Per i moduli più complessi si vuole il funzionamento e un disegno incentrato per lo più sulle parti che non sono componenti basi (con un disegno anche lì semplificato (no mux, or, and o roba specifica)). 
  Infine anche le operazioni dello stack (quelle "pilotate"), quindi clear, pop, push e gli errori, vanno spiegati con disegno (ovviamente spiegazione semplice di cosa accade quando si attivano). In più aggiungo che su disegno pop e push e meglio farli con doppio pop e push, cosi sa che funziona anche in quel caso.
