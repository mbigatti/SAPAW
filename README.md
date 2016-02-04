# Sviluppare Applicazioni per Apple Watch

Apple Watch è il dispositivo più personale mai realizzato da Apple. Questo orologio decisamente smart e il suo sistema operativo watchOS sono profondamente integrati con iOS e iPhone, ma necessitano di app realizzate con strumenti specifici. Il primo è WatchKit, un framework che consente di gestire le componenti core di un’applicazione. A esso se ne affiancano altri dedicati al rilevamento di movimento e alla continuità operativa, all’uso di contat-ti e calendari e alle funzionalità per fitness e salute, senza dimenticare due caratteristiche salienti di Apple Watch: le complicazioni, quello che nel quadrante di un orologio non riguarda l’orario, e gli sguardi, schermate che riassumono le informazioni essenziali di un'applicazione.

In questo progetto sono raccolti i codici sorgenti illustrati nel [testo](http://www.apogeonline.com/libri/9788850333660/scheda).

Il codice è stato testato per la corretta ricompilazione con Xcode 7.2 (7C68).

## Contenuti
Qui di seguito l'elenco dei progetti d'esempio suddivisi per capitolo.


### Capitolo 1

#### Hello World
Implementazione del classico programma d'esempio per Apple Watch.

---
### Capitolo 2

#### UICatalog
Applicazione catalogo che l'illustra l'uso di tutti i componenti visuali messi a disposizione da WatchKit.

![UICatalog](http://cl.ly/1q2c3L1L2t3Y/UICatalog.png)

#### HierarchyNavigationExample
Esempio di navigazione gerarchica.

#### PageNavigationExample
Esempio di navigazione a pagine.

![PageNavigationExample](http://cl.ly/2f3u0H1h2r1U/PageNavigationExample.png)

#### AnimationExample
Applicazione catalogo che illustra diverse tecniche di animazione possibili su Apple Watch.

![image](http://cl.ly/2O0T0t1N1T2l/AnimationExample.png)

----

### Capitoli 3, 4 e 5
#### NotesApp
Applicazione iPhone per la gestione di un elenco di note e applicazione Apple Watch per la visualizzazione delle stesse. Illustra la comunicazione tra dispositivi (iPhone e Apple Watch), l'implementazione della continuità operativa tramite Handoff e la creazione di schermate di sguardo personalizzate.

![NotesApp](http://cl.ly/1R3W1A2r0u10/NotesApp.png)

---
### Capitolo 6
#### TimerApp
Applicazione watchOS e iOS che implementa un conto alla rovescia da 1 a 60 minuti. Mostra l'implementazione di notifiche personalizzate e la comunicazione tra dispositivi.

![TimerApp](http://cl.ly/3u2M260s283Y/TimerApp.png)

---
### Capitolo 7

#### WeatherApp
Applicazione per la visualizzazione delle previsioni del tempo nella posizione attuale sia in un'applicazione Apple Watch sia in una complicazione.

![WeatherApp](http://cl.ly/3q0J443V0x3x/WeatherApp.png)

#### ComplicationExample
Semplice esempio di complicazione che mostra la progressione attuale all'interno della giornata di lavoro. Può essere considerato l'_Hello World_ delle complicazioni.

#### GitHubExample
Semplice complicazione che mostra il numero di follower di un profilo GitHub (cablato nel codice). Mostra come aggiornare la complicazione utilizzando una chiamata asincrona.

---
### Capitolo 8
#### MoviePlaybackExample
Mostra come utilizzare WatchKit per presentare contenuti multimediali su Apple Watch presentando un catalogo locale di filmati presenti nell'applicazione e consentendone la riproduzione.

![MoviePlaybackExample](http://cl.ly/0Q1A3f2H2R0z/MoviePlaybackExample.png)

#### AudioNotesApp
Applicazione per la registrazione e riproduzione di note audio.

![AudioNotesApp](http://cl.ly/1E322z2R2y2H/AudioNotesApp.png)

---
### Capitolo 9
#### CoreLocationCatalog
Applicazione catalogo che illustra l'utilizzo delle API Core Location implementate in watchOS (sottoinsieme di quelle di iOS).

![CoreLocationCatalog](http://cl.ly/2A2r1c0S2O3J/CoreLocationCatalog.png)

#### RegionMonitoringExample
Applicazione d'esempio che mostra come utilizzare Core Location per controllare l'entrata o uscita da una regione su iPhone e gestire l'informazione su Apple Watch.

![RegionMonitoringExample](http://cl.ly/3O1M3K1W0M0q/RegionMonitoringExample.png)

#### CoreMotionCatalog
Applicazione catalogo che illustra l'utilizzo delle API Core Motion implementate in watchOS (sottoinsieme di quelle di iOS).

![CoreMotionCatalog](http://cl.ly/060D2n2r2B2L/CoreMotionCatalog.png)

---
### Capitolo 10
#### FitnessApp
Applicazione che consente di gestire allenamenti, registrando il battito cardiaco rilevato da Apple Watch e salvando le informazioni ottenute nel database HealthKit.

![FitnessApp](http://cl.ly/1C3t2w1s1m3D/FitnessApp.png)

---
### Capitolo 11
#### BirthdayReminderApp
Applicazione che accede al database dei contatti del dispositivo e li mostra a partire dal prossimo compleanno.

![BirthdayReminderApp](http://cl.ly/0P1n0u253y06/BirthdayReminderApp.png)

#### CalendarApp
Applicazione che accede al database dei calendari e mostra gli appuntamenti del giorno.

![CalendarApp](http://cl.ly/1o1k353Y0S3o/CalendarApp.png)

#### ReminderApp
Applicazione che accede al database dei promemoria e ne visualizza le informazioni.

![ReminderApp](http://cl.ly/3d2a1x1r2j37/ReminderApp.png)

---
### Appendice A

#### LocalizationHelloWorld
Progetto di esempio utilizzato per illustrare le funzionalità di base di localizzazione di Xcode.

#### AudioNotesApp
Aggiunta di un bundle di configurazione all'applicazione AudioNotesApp.

---
### Contact
[http://bigatti.it](http://bigatti.it)  
[@mbigatti](https://twitter.com/mbigatti)
