#import "template.typ": *

#import "@preview/touying:0.7.3": *
#import "@preview/cetz:0.5.2"
#import "@preview/cetz-plot:0.1.3"
#import "@preview/lilaq:0.6.0" as lq

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

#show: codly-init.with()
#codly(
    languages: codly-languages,
    display-name: false,
)

#show raw: set text(font: "JetBrains Mono")

#let latex-symbol = [
    #set text(font: "New Computer Modern")
    L#box[#move(dx: 0em, dy: -0.20em)[
        #box[
            #pad(left: -0.3em)[
                #text(size: 0.7em)[A]
            ]
        ]
    ]]#box[
        #pad(left: -0.15em)[T]
    ]#box[#move(dx: 0em, dy: 0.24em)[
        #box[
            #pad(left: -0.2em)[E]
        ]
    ]]#box[
        #pad(left: -0.15em)[X]
    ]
]

#let tex-symbol = [
    #set text(font: "New Computer Modern")
    #box[
        #pad(left: -0.15em)[T]
    ]#box[#move(dx: 0em, dy: 0.24em)[
        #box[
            #pad(left: -0.2em)[E]
        ]
    ]]#box[
        #pad(left: -0.15em)[X]
    ]
]

#show "La!!TeX": [La] + [!TeX]
#show "La!TeX": [#h(-0.2em)#latex-symbol#h(-0.3em)]
#show "Te!X": [#h(-0.2em)#tex-symbol#h(-0.3em)]

#set text(lang: "de")

#show: lq.set-diagram(cycle: (colors.blue, colors.yellow, colors.magenta))
// #show: lq.show_(
//   lq.tick-label.with(kind: "x"),
//   it => box(
//     width: 0pt,
//     align(right, rotate(-45deg, reflow: true, it))
//   ),
// )

#show: grape-suite-theme.with(
    aspect-ratio: "16-9",
    slide-level: 0,

    config-info(
        title: [Inkrementelle Kompilierung],
        subtitle: [Auf den Spuren des Typst-Compilers],
        author: [Tristan Pieper],
        date: datetime(year: 2026, month: 6, day: 16),
        contact: link("mailto:tristan.pieper@uni-rostock.de"),
    ),

    align: horizon,
    headings-as-sections: true,
)

#title-slide()

#include "chapters/motivierung.typ"
#include "chapters/inkrementelle-kompilierung.typ"
#include "chapters/latex.typ"


#show: appendix

#slide[
    = Bibliografie
    #set align(top)
    #set par(spacing: 0.65em)
    #set text(size: 0.5em)
    #bibliography("/bibliography.bib", full: true, title: none)
]

#focus-slide[
    Weitere Typst-Beispiele
]

#show image: block.with(stroke: 1pt)
#set align(center)
#set stack(dir: ltr, spacing: 0.5em)

#image("examples/bsp_onotation.png")

#image("examples/bsp_physica.png")

#image("examples/eti-beispiel.png")

#stack(image("examples/kuek/kuek1.svg"), image("examples/kuek/kuek54.svg"))

#stack(image("examples/petrinetze/petrinetze-notizen8.svg"), image("examples/petrinetze/petrinetze-notizen11.svg"))
