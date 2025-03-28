# FINN-Framework

Dieses Unterverzeichnis enthält den Quellcode zum Umgang mit dem FINN-Framework.
Dieses Framework wird dazu verwendet, einen IP-Block aus einem quantisierten, neuronalen Netzwerk zu erzeugen.

## Inhalt

In diesem Repository sind verschiedene notwendige Dateien für die Umsetzung eines quantisierten neuronalen Netzes in einen IP-Block enthalten.

- `models`: Dieses Verzeichnis enthält sowohl das `DefaultModel.onnx`, aus welchem der IP-Block erstellt wurde, als auch die verschiedenen Zwischenergebnisse unterschiedlicher Transformationsschritte auf dem Weg zur Generierung eines IP-Blocks.
- `3-build-accelerator-with-finn.ipynb`: Dies ist das Notebook zur Erstellung eines Estimate Reports für das verwendete Model. Es ist eine leicht angepasste Version des von FINN zur Verfügung gestellten, gleichnamigen Notebooks. Die Originaldatei des FINN-Projekts befindet sich [hier](https://github.com/Xilinx/finn/blob/main/notebooks/end2end_example/cybersecurity/3-build-accelerator-with-finn.ipynb).
- `create_ip_poc.ipynb`: Dieses Notebook beinhaltet alle notwendigen Transformationsschritte, um aus einem Model einen IP-Block zu generieren und ist eine vollständige Eigenleistung.

## Anwendung

Das Jupyter-Notebook "create_ip_poc.ipynb" wird zur Erstellung eines IP-Blocks für die Vivado Design Suite aus einem quantisierten, neuronalen Netzwerk im ONNX-Format verwendet.

Die einzelnen Schritte zur Erzeugung des IP-Blocks sind im Notebook beschrieben.

Die Notebooks können nur auf einem Linux-Rechner ausgeführt werden, da diese das FINN-Framework benötigen, welches nur für Linux-Systeme verfügbar ist.

## Credits

Da bis zuletzt kein eigenes neuronales Netz verfügbar war, wurde das eingesetzte Model einer vorherigen Gruppe eingesetzt, mit dem Ziel zumindest dieses Model als IP-Block verfügbar zu machen. Daher ist das `DefaultModel.onnx` keine eigene Arbeit, sondern die Leistung der Projektgruppe aus EMBEDS im Wintersemester 2022-2023.
