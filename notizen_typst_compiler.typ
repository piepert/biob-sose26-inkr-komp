Export:
- export_pdf/svg/png/html
-

= Ressourcen und Elemente
`#image`-Funktion:
- PDFs:
    - PDF Datei laden (raw Bytes des Dokuments)
    - einzelne Seite extrahieren (PDF-Dokument, Seitennummer)
- laden von Dateien
- Bibliographie: laden, anzeigen, ..., Zitierstil laden

`#raw`:
- einmal gerendertes Syntax-Highlight
- laden von Syntaxspezifikationen aus Dateien
- farbthemes

shapes:
- aus einer Geometrie erstellter Pfad (Geometrie)

Schriften:
- Laden von Schriftarten
- intern-kompilierte Version der Schriftart

Lokalisierungsstrings

... (so gut wie jede interne Repräsentation)

= Compiler:
- eval: Dateien und Strings werden memoized
- eval_closure: Typst-Funktionen
- layout_page
- layout_document


= Offene Fragen:
- `crates/typst-layout/src/pages/run.rs`:

    Wie layoutet Typst einzelne Seiten? Wenn die Margins von der Seitenzahl abhängig sind z.B. (oder Code context-bezogen ist), kann es auftreten, dass bei der ersten Kompilierung nicht genug Informationen vorhanden sind, um die Seitenränder zu setzen. Wenn der Text gelayoutet wird, passt er nicht auf die Seite → kommt auf nächste Seite. Beim zweiten Durchgang nochmal neu layouten, wie wird bestimmt, ob Text jetzt auf die Seite passt oder nicht? Warum klappt das (häufig) in 5 Iterationen?

- d
