#import "/template.typ": *
#import "@preview/fontawesome:0.6.1": *

// Erarbeitung (10 min)
// - Was bietet Typst?
//      1. inkrementelle Kompilierung
//      2. Parallelisierung
// - Was muss Typst dafür designtechnisch eingehen?
//      1. pure functions
//      2. pure functions
// - Wie setzt Typst dies konkret um?
//      1. Sprachdesign: pure functions
//      2. comemo
//      3. states, counter als Ausweichmanöver

#focus-slide[
    Wie macht Typst das?
]

// induktives Vorgehen → wir zeigen anhand von Beispielen, wie das Prinzip ist
= Funktionen in Typst
#grid(columns: 2, column-gutter: 1em)[

    ```typ
    #let global = 3

    #let increment() = {
        global = global + 1
    }

    #increment()
    ```
][
    #pause
    #set align(top)
    #no-codly(```
    error: variables from outside the function are read-only and cannot be modified
      ┌─ test.typ:4:4
      │
    4 │     global = global + 1
      │     ^^^^^^
    ```)
]

---
= Funktionen in Typst

#definition[
    Eine Funktion ist _wirkungsfrei_ (ohne "side-effects"), gdw. sie den Zustand des Programmes nicht verändert.
]

#pause
Bsp.: alle mathematischen Funktionen sind wirkungsfrei

---
// Grundidee der inkrementellen Kompilierung: Caching
= Inkrementelle Kompilierung
- jede Funktion in Typst ist $f: "Value"^n -> "Value"$ #pause
- Cache konstruieren:

#figure(table(
    columns: 2,
    ..pillar.cols("c|l"),
    inset: 10pt,

    $"hash"(chevron.l f, v_1, v_2, ...chevron.r)$, $v_"ret"$, table.hline(),
    `1011172c6` + [...], [[Hallo]],
    `bad8c0dc4` + [...], [4],
    `12fccd699` + [...], repr(table(columns: 2)[]).replace(" ", "").replace("\n", "").slice(0, 30) + [...],
))

// sortierte Hashmap bietet sogar O(log n) Zugriffszeit (durch Binärsuche)!
// aber das ist nur der Anfang...


---
// Problem: das reicht nicht
// Idee: nicht nur der Typst-Code ist cachegeeignet, auch der gesamte Compiler ist cachegeeignet (inkrementell)
// dafür:
// 1. zeigen, was module sind (wie z.B. die main-Datei kompiliert wird, wenn sie module importiert/inkludiert)
// 2. zeigen, wie comemo funktioniert
= Inkrementelle Kompilierung
#pdfpc.speaker-note(```
    - Problem: hier keine user-defined functions, also auch kein Caching... oder?
```)

In main.typ:
```typ
#image("bookcover.pdf")
#include "chapters/chap01.typ"
#include "chapters/chap02.typ"
...
```
// hier keine user-defined functions, also auch kein caching, oder doch? wo inkrementelle kompilierung?
// ...

// schreibe eval-Funktion um Datei auszuwerten. Was ist nötig, damit ich main.typ genau dann neu kompiliere, wenn sich eine der Abhängigkeiten geändert hat?
// Problem: normale Memoization nicht möglich, wenn wir nicht alle Dateiinhalte in Fs speichern wollen...
// Dafür:
// 1. erklären, wie comemo::memoize funktioniert
// 2. erklären, wie comemo::track funkitoniert

---
// 1. erklären, wie comemo::memoize funktioniert
#slide[
    #pdfpc.speaker-note(```
        - wir können auch Funktionen _im_ Typst compiler cachen, nicht nur im Typst-Dokument
        - eingabe erzeugt immer gleiche Ausgabe
    ```)
    #set text(size: 1em)
    #figure(cetz-canvas({
        import cetz.draw: *
        import cetz.decorations: *
        set-style(line: (stroke: 2pt, mark: (end: ">", fill: black)), padding: 0.5)

        content((0, 0), text(size: 2em, fa-icon("file-pdf")), name: "datei", padding: (right: 1))
        content((7, 0), [Daten], name: "daten")
        content((14, 0), [PDF-Objekt], name: "objekt")
        content((22, 0), [Rastergrafik], name: "rastergrafik")

        line("datei.east", "daten.west", name: "lesen")
        line("daten.east", "objekt.west", name: "parsen")
        line("objekt.east", "rastergrafik.west", name: "umwandlung")

        content("lesen", text(size: 0.75em)[lesen], padding: (bottom: 1))
        content("parsen", text(size: 0.75em)[parsen], padding: (bottom: 1))
        content("umwandlung", text(size: 0.75em)[umwandeln], padding: (bottom: 1))

        (pause,)
        brace((24.25, -1), (8.5, -1), stroke: 1.25pt, name: "brace_caching")
        content("brace_caching.south", align(center)[Cache!\ (selbes Prinzip)], anchor: "north", padding: 0)
    }))
]

---
#touying-raw(```rust
impl PdfDocument {
    // pause
    #[comemo::memoize]
    // meanwhile
    pub fn new(data: Bytes) -> PdfDocument {
        ...
```)

---
// 2. erklären, wie comemo::track funktioniert
#pdfpc.speaker-note(```
- Idee: könnten intuitiv folgende Funktion für Kompilierung vorstellen
- geht da attribut memoize ran?
- nein → müssen den Cache invalidieren, aber wie?
```)

#touying-raw(```rust
// pause
#[comemo::memoize]
// meanwhile
fn eval(sourceCode: &Source) -> Value {
    ...
}
```)

#pause
```typ
#image("bookcover.pdf")
#include "chapters/chap01.typ"
#include "chapters/chap02.typ"
...
```

#pause
⇒ im Cache nicht alle Abhängigkeiten berücksichtigt

---
// jetzt: vielleicht einfach den Sourcecode aller Dateien mit in die eval-Funktion aufnehmen?
// dann zu track überleiten
#slide[
    #pdfpc.speaker-note(```
        - vielleicht nehmen wir dann einfach den sourcecode aller Dateien mit als Parameter in die eval-Funktion?
        - Problem: wenn wir gesamtes Fs mit als Parameter für memoization nehmen, invalidiert JEDE dateiänderung ALLE eval-calls
        - also schlechte idee
    ```)

    #touying-raw(```rust
    #[comemo::memoize]
    fn eval(sourceCode: &Source, fs: &Fs) -> Value { ... }
    ```)

    #uncover(2, move(dx: 2.5cm, dy: -0.5cm, cetz.canvas({
        import cetz.draw: *
        import cetz.decorations: *

        line((0, 0), (0, 1), mark: (end: ">", fill: black), stroke: 2pt, name: "aload")
        content("aload", anchor: "west", `fs.load(path)`, padding: 0.5)

        content((0.25, -2.5), table(columns: 2,
            [path], [source],
            `/chapters/chap01.typ`, [The palace still shook occasionally as ...],
            `/chapters/chap02.typ`, [The Wheel of Time turns, and Ages ...],
            [...], [...]))
    })))
]

// #slide[
//     #set raw(lang: "rust")
//     #show table: set text(size: 0.5em)
//     #show table: set raw(lang: "")
//     #pdfpc.speaker-note(```
//     Erste Version:
//     1. kopieren
//     2. einspeisen
//
//     Probleme: caching verbraucht nun noch mehr speicher als vorher schon, außerdem invalidiert jede änderung den cache
//     ```)
//
//     #cetz-canvas({
//         import cetz.draw: *
//
//         scale(3)
//
//         content((5, -0), name: "main", anchor: "north-west", [(`main.typ` evaluieren) \ `eval(mainSource, fsCopy)`])
//
//         content((5, -1.25), name: "c1", anchor: "north-west", [(`chap01.typ` evaluieren) \ `eval(chap01Source, fsCopy)`])
//
//         content((5, -2.5), name: "c2", anchor: "north-west", [(`chap02.typ` evaluieren) \ `eval(chap02Source, fsCopy)`])
//
//         content((0, 0), name: "fsmain", anchor: "north-west", table(columns: 2,
//             [path], [source],
//             `/chapters/chap01.typ`, [The palace still shook occasionally as ...],
//             `/chapters/chap02.typ`, [The Wheel of Time turns, and Ages ...],
//             [...], [...]))
//
//         (pause,)
//         content((0, -1.25), name: "fsc1", anchor: "north-west", table(columns: 2,
//             [path], [source],
//             `/chapters/chap01.typ`, [The palace still shook occasionally as ...],
//             `/chapters/chap02.typ`, [The Wheel of Time turns, and Ages ...],
//             [...], [...]))
//
//         content((0, -2.5), name: "fsc2", anchor: "north-west", table(columns: 2,
//             [path], [source],
//             `/chapters/chap01.typ`, [The palace still shook occasionally as ...],
//             `/chapters/chap02.typ`, [The Wheel of Time turns, and Ages ...],
//             [...], [...]))
//
//         set-style(mark: (end: ">", fill: black))
//
//         (pause,)
//         line("fsmain.south", (2.5, -1), (6, -1), (7.5, -0.6))
//         line("fsc1.south", (2.5, -2.25), (6, -2.25), (7.75, -1.9))
//         line("fsc2.south", (2.5, -3.5), (6, -3.5), (7.75, -3.2))
//     })
// ]

---
// jetzt: globales Fs-Objekt, wobei jede eval-Funktion entscheidet, ob Fs noch "ähnlich genug" ist, um gecached zu bleiben
// das sind die constraints
#slide[
    #pdfpc.speaker-note(```
    ```)
    // problem: wenn eine datei nicht neu eingelesen wird, wie wird dann sichergestellt, dass load() dasselbe ergebnis liefert? wie stellen wir sicher, dass immernoch dasselbe in den dateien drinsteht? → ist aktuell egal, es geht nur darum, dass wir uns eben einen ausschnitt aus der anzahl der gesamtdaten anschauen müssen. der compiler sieht dann zu, dass die konkreten daten aktuell bleiben (z.B. indem alle 100ms alle dateien neu eingelesen werden)

    #[
    #set text(size: 0.925em)
    #touying-raw(```rust
    #[comemo::memoize]
    fn eval(sourceCode: &Source, fs: Tracked<&Fs>) -> Value { ... }
    ```)
    ]

    #uncover("2-", move(dx: 9.5cm, dy: -1cm, cetz.canvas({
        import cetz.draw: *
        import cetz.decorations: *

        line((0, 0), (0, 1), mark: (start: ">", fill: black), stroke: 2pt, name: "aload")
        content("aload", `fs.load(path)`, anchor: "west", padding: 0.5)

        content((0.25, -2.5), table(columns: 2, inset: 7pt,
            [path], [$"hash"(V_"ret")$],
            place(fa-eye(), dx: -2em, dy: -0.35em) + `/chapters/chap01.typ`, `03f200a3b8bb`+[...], // [The palace still shook occasionally as ...],
            place(fa-eye(), dx: -2em, dy: -0.35em) + [`/chapters/chap02.typ`], `2084ff93ce00`+[...], // repr([#rect]).slice(0, 40) + [...],
            [...], [...]))
    })))

    #pause
    ⇒ nur relevantes Verhalten von `fs` wird getracked #pause \
    ⇒ getrackte Argumente bilden "Constraints" für Cache-Validität
]

---
// jetzt nochmal visuell dargestellt
#slide[
    #pdfpc.speaker-note(```
jeder beobachtet nur den, den er tatsächlich im cache auch braucht, nicht das gesamte Fs ist im cache
    ```)
    #let file-icon = text(size: 2.5em, fa-file())
    #let file(body) = align(center, file-icon + [\ #body])
    #set align(center)

    #let line-eye(from, to, n) = {
        import cetz.draw: *
        line(from, to, name: str(n))
        content(str(n), text(size: 0.75em, fa-eye()), padding: if n == 3 { (left: 1.5) } else { (bottom: 1.75) })
    }

    #cetz-canvas({
        import cetz.draw: *

        set-style(padding: 0.5)

        content((0, 0), file[main.typ], name: "main")
        content((7.5, -5), file[chap02.typ], name: "chap02")
        content((-7.5, -5), file[chap01.typ], name: "chap01")
        content((0, -7.5), file[template.typ], name: "template")

        (pause,)
        set-style(mark: (end: ">", fill: black), line: (stroke: 2pt))
        line-eye("main", "chap01", 1)
        line-eye("main", "chap02", 2)
        line-eye("main", "template", 3)
        line-eye("chap01", "template", 4)
        line-eye("chap02", "template", 5)
    })
]

#slide[
    = Inkrementelle Kompilierung
    - Wirkungsfreiheit beschreibt unabhängigen Code
    - Typst nutzt Wirkungsfreiheit um Funktionen zu cachen
    - Constraints ermöglichen effiziente Validierung des Caches

    #set text(size: 0.75em)
    (Diese Folien wurde in 2#h(0.166em)s und mit Caching in 120#h(0.166em)ms kompiliert.)
]
