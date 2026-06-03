#import "/template.typ": *
#import "@preview/lilaq:0.6.0" as lq

// Problematisierung (2 min)
// LaTeX-Compiler hat Probleme: ist ziemlich langsam
// Wir wollen erreichen: ein Compiler, der schnell ist
// diesen Compiler gibt es schon, er heißt "Typst"
// doch wie löst Typst das Problem?

#slide[
    #place(dy: -1em, text(size: 0.75em, [@PexelsAdult]))#image("/img/annoyed_adult.jpg")
][
    #pause
    #set align(center + horizon)
    #image(width: 100%, "/img/latex_acmproceedings_narrow.png")
]

#slide[
    = Probleme mit La!TeX
    + 40 Jahre alte Syntax #pause
    + kryptische Fehlermeldungen #pause
    + langsame Compilezeit #pause
    + uvm.

    #pause
    #place(dx: 13cm, dy: -4cm, cetz.canvas({
        import cetz.draw: *
        import cetz.decorations: *
        brace((0, 0), (0, -1.75), stroke: 1pt, name: "sub")
        brace((0, -2.25), (0, -3.25), stroke: 1pt, name: "obj")

        content("sub.east", [subjektiv], anchor: "west", padding: 0.5)
        content("obj.east", [objektiv messbar], anchor: "west", padding: 0.5)
    }))
]

---
= Typst. Eine Lösung?#footnote[Diese Folien sind in Typst erstellt.]
#cols(columns: (50%, 1fr, 30%))[
    ```typ
    _Hallo Welt._ Dies ist ein *test*.

    #table(columns: 3,
        [a], [b], [c],
        [d], [e], [f])
    ```
][
    #set align(center)
    #set text(size: 2em)
    $arrow.squiggly$
][
    _Hallo Welt._ Dies ist ein *Test*.

    #table(columns: 3,
        [a], [b], [c],
        [d], [e], [f])
]

---
= Typst. Eine Lösung?

+ modernes Sprachdesign
+ verständliche Fehlermeldungen #pause
+ schneller Compiler (Live-Preview)

---

#slide[
    #set text(size: 0.75em)

    #let (labels, data) = csv("/benchmarks/broschure_ins.csv")
    #let (_, data2) = csv("/benchmarks/tome_ins.csv")
    #let (_, data3) = csv("/benchmarks/worksheet_ins.csv")

    #(data = data.map(e => int(e)))
    #(data2 = data2.map(e => int(e)))
    #(data3 = data3.map(e => int(e)))

    #set align(center + horizon)
    #figure(lq.diagram(
        xaxis: (ticks: labels.enumerate()),
        yaxis: (exponent: 0),

        width: 20cm,
        height: 9cm,

        lq.bar(range(data.len()), width: 0.2, offset: -0.2, data, label: "Broschüre"),
        lq.bar(range(data.len()), width: 0.2, data2, label: "Tome"),
        lq.bar(range(data.len()), width: 0.2, offset: 0.2, data3, label: "Arbeitsbtlatt")
    ), caption: [Benchmark des Typst-Compilers 2022, Angaben in ms @haug_fast_2022[S. 70].])
]

#slide[
    #let (labels, data) = (("pdfLaTeX", "LuaLaTeX", "Typst"), (712, 2356,156))

    #set text(size: 0.75em)
    #set align(center + horizon)

    #figure(lq.diagram(
        xaxis: (ticks: labels.enumerate()),
        yaxis: (exponent: 0),

        width: 20cm,
        height: 9cm,

        lq.bar(range(data.len()), width: 0.5, data),
    ), caption: [Benchmark des Typst-Compilers 2026, Angaben in ms @speedata2026.])
]
