#import "/template.typ": *
#import "@preview/cades:0.3.1": qr-code

// Transfer (5 min)
// - Warum geht es bei LaTeX nicht?
#focus-slide[
    Was ist mit (La)Te!X?
]

#slide[
    #set align(horizon)
    #quote(attribution: [--- Michael Pass, Schüler von Donald Knuth, dem Erfinder von TeX], block: true)[
        "Don tried very hard not to make TeX a programming language. Unfortunately, he didn't succeed."#footnote[Norman Ramsey: Stackoverflow. https://stackoverflow.com/questions/1931238/if-tex-is-a-programming-language-how-could-i-start-programming-in-tex, letzter Zugriff: 1.6.2025, 11:39 Uhr.]
    ]
]

---
= Pure Functions/Macros möglich?
#grid(
    columns: (60%, 1fr),
    column-gutter: 1em,
    only((1, 2), ```tex
    ...
    \def\A{A}
    "\A"
    ...
    ```)
        + only((3, 4), ```tex
        ...
        \def\A{A}
        \def\B{\def\A{C}}
        "\A \B \A"
        ...
        ```),
    {
        set text(size: 1.5em)
        align(center + horizon, only(2)["A"] + only(4)["AC"])
    },
)

#[
    #set text(size: 1.25em)
    #uncover(4)[⇒ `\B` nicht wirkungsfrei]
]

#slide[
    = Inkrementelle Kompilierung
    - Neukompilierung nur dessen, was sich ändert
    - Rest mittels constrained Memoization speichern
    - durch Wirkungsfreiheit des Typst-Codes und im Compilerdesign besonders effektiv

    #set align(center)
    #stack(dir: ltr, spacing: 3cm)[
        Typst:\
        #box(qr-code("https://github.com/typst/typst"), width: 4cm)
    ][
        Diese Folien:\
        #box(qr-code("https://github.com/piepert/biob-sose26-inkr-komp", width: 4cm))
    ]
]

