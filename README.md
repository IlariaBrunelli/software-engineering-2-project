# 🎓 S&C – Software Engineering 2 Project

Progetto di gruppo per il corso di **Software Engineering 2**, **Politecnico di Milano**, A.A. 2024/25.

**S&C (Students & Companies)** è una piattaforma che semplifica la ricerca e la gestione dei tirocini mettendo in contatto **studenti**, **aziende** e **università**. Il progetto copre l'intera fase di analisi e progettazione del software: dalla raccolta dei requisiti alla verifica formale con Alloy, fino al design dell'architettura e dell'interfaccia.

📄 **[RASD – Requirements Analysis and Specification Document](./RASD.pdf)** · 📄 **[DD – Design Document](./DD.pdf)**

## Il problema

Trovare il tirocinio giusto, o il candidato giusto, è spesso lento e dispersivo per tutti: gli studenti faticano a individuare le offerte adatte al proprio profilo, le aziende a selezionare i candidati e le università a seguire l'andamento dei tirocini e gestire eventuali problemi. S&C riunisce tutto il processo in un'unica piattaforma, con un sistema di raccomandazione che suggerisce le offerte più adatte agli studenti e i candidati più adatti alle aziende.

## Utenti e funzionalità

- **Studenti**: si autenticano tramite il Single Sign-On dell'università, caricano il CV e compilano un questionario su competenze e preferenze, cercano tirocini con filtri e parole chiave, ricevono raccomandazioni personalizzate, si candidano, chattano con le aziende e lasciano feedback mensili e finali.
- **Aziende**: pubblicano offerte di tirocinio (con suggerimenti per la compilazione), consultano le candidature con una classifica dei candidati suggerita dal sistema, avviano chat, conducono i colloqui con moduli strutturati e selezionano il candidato finale.
- **Università**: approvano o rifiutano gli abbinamenti studente–tirocinio, monitorano i tirocini in corso, gestiscono i reclami e possono interrompere un tirocinio in caso di problemi.

## RASD – Analisi dei requisiti

- **Analisi del dominio** secondo il modello di Jackson e Zave (fenomeni del mondo, condivisi e della macchina);
- **10 obiettivi**, **22 requisiti funzionali** e le relative assunzioni sul dominio, con una verifica di completezza che collega ogni obiettivo ai requisiti e alle assunzioni che lo garantiscono;
- **scenari d'uso**, **diagramma delle classi di dominio** e **diagrammi di stato**;
- **21 casi d'uso** con i relativi diagrammi e una **matrice di tracciabilità** requisiti–casi d'uso;
- requisiti non funzionali: prestazioni, vincoli di progetto, affidabilità, disponibilità, sicurezza, manutenibilità e portabilità.

### Verifica formale con Alloy

Il modello del dominio è stato formalizzato in **Alloy** ([`AlloyS&C.als`](./AlloyS&C.als)) con signature, fatti, asserzioni e predicati, per verificare che i vincoli del sistema siano coerenti e che le proprietà richieste valgano davvero.

## DD – Progettazione

**Architettura.** Il sistema è progettato come applicazione **client-server a tre livelli** (presentazione, applicazione, dati), con il livello applicativo suddiviso in **microservizi** per ottenere scalabilità indipendente, manutenibilità e isolamento dei guasti. I componenti principali sono:

| Componente | Responsabilità |
|---|---|
| User Manager | Registrazione, login, profili, CV e questionari |
| SSO (esterno) | Autenticazione degli studenti e verifica dell'iscrizione |
| Internship Manager | Pubblicazione, ricerca e candidatura ai tirocini |
| Recommendation Manager | Raccomandazioni per studenti e classifica dei candidati per le aziende |
| Notification Manager | Notifiche ed email (match, candidature, promemoria, chat) |
| Chat Manager | Comunicazione tra studenti e aziende, esito della selezione |
| Interview Manager | Moduli di colloquio e punteggio dei candidati |
| Feedback Manager | Raccolta dei feedback e statistiche sulle aziende |
| Monitoring Manager | Approvazione degli abbinamenti e monitoraggio dei tirocini |
| Complaint Manager | Gestione dei reclami e notifica alle università |

**Viste.** Il documento include il diagramma dei componenti, la **deployment view** (firewall, load balancer, application server, DBMS), **21 runtime view** con diagrammi di sequenza per tutti i flussi principali e la specifica delle **interfacce** di ogni componente.

**Stili e pattern.** API **RESTful**, architettura a livelli, microservizi ed **event-driven** per notifiche e chat in tempo reale; design pattern **MVC**, **Repository**, **Adapter**, **Observer**, **Factory**, **Strategy** e **Proxy**.

**Altre scelte.** **PostgreSQL** per i dati strutturati e transazionali e **MongoDB** per feedback e dati delle raccomandazioni; un motore di raccomandazione che combina **collaborative filtering** e **content-based filtering**; conformità al **GDPR** con cifratura dei dati.

**Interfaccia e piano di sviluppo.** Il DD presenta i mockup delle schermate per i tre tipi di utente, la tracciabilità tra requisiti e componenti e un piano di implementazione, integrazione e test: sviluppo bottom-up con priorità ai servizi fondamentali, integrazione incrementale con Docker e Kubernetes, e una strategia di test basata sul **V-Model**, dall'analisi statica e dinamica fino ai test di sistema, accettazione, prestazioni e sicurezza.

## Mockup

I mockup delle schermate dell'interfaccia si trovano nella cartella [`mockups`](./mockups).

## Il team

**Ilaria Brunelli**, Giulia Mengoli, Tommaso Neri.
