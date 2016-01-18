# Sviluppare Applicazioni per Apple Watch

Apple Watch è il dispositivo più personale mai realizzato da Apple. Questo orologio decisamente smart e il suo sistema operativo watchOS sono profondamente integrati con iOS e iPhone, ma necessitano di app realizzate con strumenti specifici. Il primo è WatchKit, un framework che consente di gestire le componenti core di un’applicazione. A esso se ne affiancano altri dedicati al rilevamento di movimento e alla continuità operativa, all’uso di contat-ti e calendari e alle funzionalità per fitness e salute, senza dimenticare due caratteristiche salienti di Apple Watch: le complicazioni, quello che nel quadrante di un orologio non riguarda l’orario, e gli sguardi, schermate che riassumono le informazioni essenziali di un'applicazione.

In questo progetto sono raccolti i codici sorgenti illustrati nel [testo](http://www.apogeonline.com/libri/9788850333660/scheda).

## Contenuti
Qui di seguito l'elenco dei progetti d'esempio suddivisi per capitolo.


### Capitolo 1

#### Hello World
Implementazione del classico programma d'esempio per Apple Watch.

---
### Capitolo 2

#### UICatalog
Applicazione catalogo che l'illustra l'uso di tutti i componenti visuali messi a disposizione da WatchKit.

![UICatalog](https://raw.githubusercontent.com/mbigatti/SAPAW/master/cap02/UICatalog/WatchApp/Assets.xcassets/AppIcon.appiconset/88x88.png?token=ABhgegsm_VCBJjRcwnAjLbJj7UZ-nQvVks5Wph8_wA%3D%3D)

#### HierarchyNavigationExample
Esempio di navigazione gerarchica.

#### PageNavigationExample
Esempio di navigazione a pagine.

![PageNavigationExample](https://raw.githubusercontent.com/mbigatti/SAPAW/master/cap02/PageNavigationExample/WatchApp/Assets.xcassets/AppIcon.appiconset/88x88.png?token=ABhgeo0kmhvuJAFKsrwsY17hYMKM5P4xks5WpiJ5wA%3D%3D)

#### AnimationExample
Applicazione catalogo che illustra diverse tecniche di animazione possibili su Apple Watch.

![image](https://raw.githubusercontent.com/mbigatti/SAPAW/master/cap02/AnimationExample/AnimationExample/Assets.xcassets/AppIcon.appiconset/Icon-Small%403x.png?token=ABhgegzDG5YLHjC3du9JPPyFIcITx7zvks5WphyAwA%3D%3D)

----

### Capitoli 3, 4 e 5
#### NotesApp
Applicazione iPhone per la gestione di un elenco di note e applicazione Apple Watch per la visualizzazione delle stesse. Illustra la comunicazione tra dispositivi (iPhone e Apple Watch), l'implementazione della continuità operativa tramite Handoff e la creazione di schermate di sguardo personalizzate.

![NotesApp](https://raw.githubusercontent.com/mbigatti/SAPAW/master/cap03/NotesApp/WatchApp/Assets.xcassets/AppIcon.appiconset/88x88.png?token=ABhgeu2cu-mDyXnb-tVlyRVY4ADAjnVWks5Wph2MwA%3D%3D)

---
### Capitolo 6
#### TimerApp
Applicazione watchOS e iOS che implementa un conto alla rovescia da 1 a 60 minuti. Mostra l'implementazione di notifiche personalizzate e la comunicazione tra dispositivi.

![TimerApp](https://raw.githubusercontent.com/mbigatti/SAPAW/master/cap06/TimerApp/WatchApp/Assets.xcassets/AppIcon.appiconset/88x88.png?token=ABhgeowaV3x69du7bzREIMLjCtdVgV5Mks5Wph52wA%3D%3D)

---
### Capitolo 7

#### WeatherApp
Applicazione per la visualizzazione delle previsioni del tempo nella posizione attuale sia in un'applicazione Apple Watch sia in una complicazione.

![WeatherApp](https://raw.githubusercontent.com/mbigatti/SAPAW/master/cap07/WeatherApp/WatchApp/Assets.xcassets/AppIcon.appiconset/88x88.png?token=ABhgelqkNJ8iKY6lToKIIm654-N4MULxks5WpiAGwA%3D%3D)

#### ComplicationExample
Semplice esempio di complicazione che mostra la progressione attuale all'interno della giornata di lavoro. Può essere considerato l'_Hello World_ delle complicazioni.

#### GitHubExample
Semplice complicazione che mostra il numero di follower di un profilo GitHub (cablato nel codice). Mostra come aggiornare la complicazione utilizzando una chiamata asincrona.

---
### Capitolo 8
#### MoviePlaybackExample
Mostra come utilizzare WatchKit per presentare contenuti multimediali su Apple Watch presentando un catalogo locale di filmati presenti nell'applicazione e consentendone la riproduzione.

![MoviePlaybackExample](https://raw.githubusercontent.com/mbigatti/SAPAW/master/cap08/MoviePlaybackExample/WatchApp/Assets.xcassets/AppIcon.appiconset/88x88.png?token=ABhgepiUC77HfUFGEx8cGeStlZlWo3Smks5WpiQpwA%3D%3D)

#### AudioNotesApp
Applicazione per la registrazione e riproduzione di note audio.

![AudioNotesApp](https://raw.githubusercontent.com/mbigatti/SAPAW/master/cap08/AudioNotesApp/WatchApp/Assets.xcassets/AppIcon.appiconset/88x88.png?token=ABhgemD9AcFkS8XmPTVqBW-8nSTUirzpks5WpiSNwA%3D%3D)

---
### Capitolo 9
#### CoreLocationCatalog
Applicazione catalogo che illustra l'utilizzo delle API Core Location implementate in watchOS (sottoinsieme di quelle di iOS).

![CoreLocationCatalog](https://raw.githubusercontent.com/mbigatti/SAPAW/master/cap09/CoreLocationCatalog/WatchApp/Assets.xcassets/AppIcon.appiconset/88x88.png?token=ABhgerZGBUBUTLU7s_XEroQTbwRe2n4jks5WpiT-wA%3D%3D)

#### RegionMonitoringExample
Applicazione d'esempio che mostra come utilizzare Core Location per controllare l'entrata o uscita da una regione su iPhone e gestire l'informazione su Apple Watch.

![RegionMonitoringExample](https://raw.githubusercontent.com/mbigatti/SAPAW/master/cap09/RegionMonitoringExample/WatchApp/Assets.xcassets/AppIcon.appiconset/88x88.png?token=ABhgepDHqSjJJ5TtN2mdS2bIYq0bV-gtks5WpiUVwA%3D%3D)

#### CoreMotionCatalog
Applicazione catalogo che illustra l'utilizzo delle API Core Motion implementate in watchOS (sottoinsieme di quelle di iOS).

![CoreMotionCatalog](https://raw.githubusercontent.com/mbigatti/SAPAW/master/cap09/CoreMotionCatalog/WatchApp/Assets.xcassets/AppIcon.appiconset/88x88.png?token=ABhgesteJN4tpVxLZAot5CNhOOhzHTnoks5WpiUwwA%3D%3D)

---
### Capitolo 10
#### FitnessApp
Applicazione che consente di gestire allenamenti, registrando il battito cardiaco rilevato da Apple Watch e salvando le informazioni ottenute nel database HealthKit.

![FitnessApp](https://raw.githubusercontent.com/mbigatti/SAPAW/master/cap10/FitnessApp/WatchApp/Assets.xcassets/AppIcon.appiconset/88x88.png?token=ABhgejDt_2hsf0yiNa4akN2O1JDt6JqGks5WpiWTwA%3D%3D)

---
### Capitolo 11
#### BirthdayReminderApp
Applicazione che accede al database dei contatti del dispositivo e li mostra a partire dal prossimo compleanno.

![BirthdayReminderApp](https://raw.githubusercontent.com/mbigatti/SAPAW/master/cap11/BirthdayReminderApp/WatchApp/Assets.xcassets/AppIcon.appiconset/88x88.png?token=ABhgegrcQIhihsu7KPKKXtSpbTMPJKdKks5WpiYXwA%3D%3D)

#### CalendarApp
Applicazione che accede al database dei calendari e mostra gli appuntamenti del giorno.

![CalendarApp](https://raw.githubusercontent.com/mbigatti/SAPAW/master/cap11/CalendarApp/WatchApp/Assets.xcassets/AppIcon.appiconset/88x88.png?token=ABhgevgNEdIdnAUCaPYrDA6qDLdMxxwAks5WpiaKwA%3D%3D)

#### ReminderApp
Applicazione che accede al database dei promemoria e ne visualizza le informazioni.

![ReminderApp](https://raw.githubusercontent.com/mbigatti/SAPAW/master/cap11/ReminderApp/WatchApp/Assets.xcassets/AppIcon.appiconset/88x88.png?token=ABhgerk4VIy1iujWhNnY11p9HFoIdLvNks5Wpib2wA%3D%3D)

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