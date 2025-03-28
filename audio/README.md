# Audio

> Verfasst von Jesse Gollub

Dieses Verzeichnis enthält den Code zur Audioaufnahme mit [PYNQ](https://github.com/Xilinx/PYNQ) in Python.

## Entwicklung

Um alle Abhängigkeiten zu installieren, führen Sie den folgenden Befehl aus:

```bash
nix develop
```

Alternativ kann direnv verwendet werden, um die Umgebung automatisch zu laden. Dazu gibt es eine .envrc-Datei, die mit folgendem Befehl aktiviert wird:

```bash
direnv allow
```

> ⚠ Hinweis: Die devShell enthält nicht die PYNQ-Bibliothek, da diese nicht über herkömmliche Paketmanager installiert werden kann.

Alternativ kann die Entwicklung direkt auf dem PYNQ-Board erfolgen, da dort bereits alle benötigten Bibliotheken vorliegen.

## Nutzung

Zum Starten des Projekts führen Sie folgenden Befehl aus:

```bash
python -m src
```

## Tests

Die Testdateien befinden sich im Verzeichnis tests und können mit folgendem Befehl ausgeführt werden:

```bash
python -m tests
```
