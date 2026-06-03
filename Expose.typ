#import "@preview/grape-suite:4.0.0": subtype.essay

#set text(lang: "de")
#show: essay.with(
    title:  [Was ist für Echtzeit-Layouting nötig?],
    university: [Universität Rostock],
    institute: [Institut für Informatik],
    seminar: [Beauty is our Business],
    instructor: [Sophie Wallner],

    semester: [Sommersemester 2026],
    author: [Tristan Pieper],
    date: [\12. Mai 2026],
)

= Abstract
Was braucht man eigentlich, um wirkungsvolles Echtzeit-Layouting für Texte zu ermöglichen? Warum ist dies bei LaTeX so schwierig? Um das zu erklären, möchte ich im Vortrag auf drei verschiedene Punkte eingehen:

#set enum(numbering: "1.", full: true)

+ Algorithmen effizienter machen: die Idee von Caching und Parallelisierung

+ Programmiersprachdesign: Was brauche ich, um eine Programmiersprache zu bauen?
    + grobe Erklärung Lexing, Parsing, Evaluation
    + Vertiefung Evaluation anhand von TeX

+ Kontext: Was muss ein Container wissen, um gelayouted zu werden?
    + TeX-Makroexpansion als limitierender Faktor
    + ein Alternativmodell ohne Kontext: Typst's Layoutalgorithmus und Möglichkeiten zum Caching und Parallelisierung



= Informatische Themengebiete
- Compilerbau:
    - Tokenization/Lexing
    - Parsing
    - Evaluation
- Caching (überschneidet sich mit Martens Thema)
- Parallelisierung

#pagebreak()
#set heading(numbering: none)
// https://www.overleaf.com/learn/latex/How_TeX_macros_actually_work%3A_Part_6
#bibliography("bibliography.bib", full: true)
