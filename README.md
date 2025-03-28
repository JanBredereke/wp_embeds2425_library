# Überblick: Code zur Veröffentlichung "Sprachkommandoerkennung auf einem FPGA"

## Zusammenfassung

Wir untersuchen am Beispiel einer Sprachkommandoerkennung, wie man ein neuronales Netz in einer stark leistungsbeschränkten Umgebung am besten nutzen kann, indem man ein feldprogrammierbares Gate-Array (FPGA) einsetzt. Das im vorliegenden Bericht beschriebene Projekt baut auf Projekten in früheren Semestern auf, und es wird fortgesetzt werden. Im aktuellen Semester wurden die nötigen Verarbeitungsschritte an neue Audio-Hardware angepasst sowie detaillierter identifiziert und festgelegt. Aus einem aufgetretenen Schnittstellenproblem heraus ergab sich eine neue Einsicht zu einer Systemarchitektur für eine effiziente Verarbeitung auf einem FPGA. Bei den einzelnen Teilaufgaben wurden ansonsten bedauerlicherweise keine wesentlichen Fortschritte gegenüber dem Vorgängerprojekt erzielt. Im Ausblick am Ende fassen wir den aktuellen Stand der Ideen zusammen, wie die laufende Serie von Mini-Projekten fortgesetzt werden kann.

## Links auf die Veröffentlichung zum Code

* https://homepages.on.hs-bremen.de/~jbredereke/de/forschung/veroeffentlichungen/sprachkommandoerkennung-auf-einem-fpga-wp_embeds-2025.html
* https://doi.org/10.26092/elib/3777

## Liste aller zugehörigen Repositories auf GitHub

* https://github.com/JanBredereke/wp_embeds2425_ki
* https://github.com/JanBredereke/wp_embeds2425_library
* https://github.com/JanBredereke/wp_embeds2425_pl-definition

Für eine Beschreibung siehe Anhang A auf Seite 87 der obigen Veröffentlichung.

# Anleitung für dieses Code-Repository

## Library
(Author: David Schulz)

Das Library Repo beinhaltet alle in Python geschriebene Dateien, die eingesetzt wurden zur Berechnung von MFCC und zur Erstellung eines IP-Blocks aus einem Neuronalen Netzes.
Desweiteren sind Jupyter Notebooks vorhanden, die direkt auf dem Board genutzt wurden (mit Außnahme der Jupyter Notebooks im Ordner `finn-framework`) im Zusammenhang mit dem `fft_block_projekt`.
Außerdem beinhaltet das Repo Projekte für einzelne Komponenten, die auf dem FPGA-Board ausgeführt werden können, z.B. das `fft_block_projekt` und `fpga_umsetzung`.
