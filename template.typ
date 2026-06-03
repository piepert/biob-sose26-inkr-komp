#import "@preview/touying:0.7.3": *
#import "@preview/cetz:0.5.2"
#import "@preview/cetz-plot:0.1.3"
#import "@preview/codly:1.3.0": *
#import "@preview/pillar:0.3.3"

#import "@preview/grape-suite:4.0.0": todo, colors, elements
#import todo: *
#import elements: *

#let (grape-suite-theme, slide, title-slide, focus-slide, outline-slide, new-section-slide) = {
    import "@preview/grape-suite:4.0.0": colors, german-dates

    let footer(focus-slide: false, self) = context {
        set std.align(bottom)
        set text(fill: if focus-slide { colors.get-colors().accent } else { colors.get-colors().primary-light })

        pad(
            x: 2cm,
            bottom: 1cm,
            components.left-and-right(
                {
                    set text(size: 0.5em)
                    utils.call-or-display(self, self.store.footer)
                },
                utils.call-or-display(
                    self,
                    {
                        set text(size: 0.75em)
                        text(weight: "bold", context utils.slide-counter.display())
                        text(size: 0.75em, sym.space.thin + "/" + sym.space.thin + utils.last-slide-number)
                    },
                ),
            ),
        )

        if self.store.footer-progress {
            place(bottom, dy: 2pt, components.progress-bar(
                height: 6pt,
                colors.get-colors().accent,
                colors.get-colors().primary,
            ))
        }
    }

    let header(self) = {
        return

        set std.align(top)
        // show: components.cell.with(fill: self.colors.secondary, inset: 1em)
        set std.align(horizon)
        set text(fill: self.colors.neutral-lightest, weight: "medium", size: 0.5em)

        if title != auto {
            utils.fit-to-width(grow: false, 100%, self.info.title)
        } else {
            utils.call-or-display(self, self.store.header)
        }
    }

    let slide(
        title: auto,
        align: auto,
        config: (:),
        repeat: auto,
        setting: body => body,
        composer: auto,
        ..bodies,
    ) = touying-slide-wrapper(self => {
        if align != auto {
            self.store.align = align
        }

        let self = utils.merge-dicts(
            self,
            config-page(
                fill: self.colors.neutral-lightest,
                header: header,
                footer: footer,
            ),
        )

        let new-setting = body => {
            show: std.align.with(self.store.align)
            set text(fill: self.colors.neutral-darkest)
            show: setting
            body
        }

        touying-slide(
            self: self,
            config: config,
            repeat: repeat,
            setting: new-setting,
            composer: composer,
            ..bodies,
        )
    })

    let title-slide(
        config: (:),
        extra: none,
        date: datetime.today(),
        date-format: date => if type(date)
            == type(
                datetime.today(),
            ) {
            context {
                if text.lang == "de" {
                    [#german-dates.weekday(date.weekday()), #date.display("[day].[month].[year]")]
                } else {
                    date.display("[weekday], [year]-[month]-[day]")
                }
            }
        } else {
            date
        },
        show-semester: false,
        no: none,
        ..args,
    ) = touying-slide-wrapper(self => {
        self = utils.merge-dicts(
            self,
            config-common(freeze-slide-counter: true),
            config-page(fill: self.colors.neutral-lightest),
            config,
        )

        let info = (series: none, no: no, date: date, date-format: date-format) + self.info + args.named()
        let body = {
            set std.align(horizon)

            block(inset: (left: 1cm, top: 3cm), {
                if info.title != none {
                    block(
                        below: if info.subtitle != none { 0.65em } else { auto },
                        context text(
                            fill: colors.get-colors().primary,
                            size: 2em,
                            strong[#info.title #if info.no != none [ \##info.no]],
                        ),
                    )
                }

                if info.subtitle != none {
                    block(context text(
                        fill: colors.get-colors().primary-light,
                        strong(info.subtitle),
                    ))
                }

                set text(size: 0.75em)
                if info.author != none [#info.author #if info.contact != none [--- #info.contact ] \ ]
                if info.institution != none [#info.institution \ ]
                if info.date != none and show-semester [#german-dates.semester(info.date) \ ]
                if info.date != none { date-format(info.date) }
            })
        }

        touying-slide(self: self, body)
    })

    let new-section-slide(
        config: (:),
        level: 1,
        numbered: true,
        body,
    ) = touying-slide-wrapper(self => context {
        let self = utils.merge-dicts(
            self,
            config-page(fill: colors.get-colors().primary, footer: footer.with(focus-slide: true), margin: 2cm),
        )

        let slide-body = {
            set std.align(horizon + center)
            show: pad.with(20%)
            set text(size: 2.5em, fill: white, weight: "bold")

            utils.display-current-heading(
                level: level,
                numbered: numbered,
                style: auto,
            )

            text(self.colors.neutral-dark, body)
        }

        touying-slide(self: self, config: config, slide-body)
    })

    let focus-slide(
        config: (:),
        composer: auto,
        align: horizon + center,
        body,
    ) = touying-slide-wrapper(self => context {
        let self = utils.merge-dicts(
            self,
            config-page(fill: colors.get-colors().primary, footer: footer.with(focus-slide: true), margin: 2cm),
        )

        let body = {
            set std.align(center + horizon)
            set text(fill: self.colors.neutral-lightest, size: 1.75em, weight: "bold")
            body
        }

        touying-slide(
            self: self,
            config: config,
            composer: composer,
            body,
        )
    })

    let outline-slide(
        config: (:),
        depth: 1,
        numbered: true,
    ) = touying-slide-wrapper(self => {
        let slide-body = {
            set std.align(horizon)
            show: pad.with(10%)
            outline(depth: depth)
        }

        self = utils.merge-dicts(
            self,
            config-page(fill: self.colors.neutral-lightest),
        )

        touying-slide(self: self, config: config, slide-body)
    })

    let grape-suite-theme(
        aspect-ratio: "16-9",
        align: top,
        slide-level: 1,
        header: self => utils.display-current-heading(
            setting: utils.fit-to-width.with(grow: false, 100%),
            depth: self.slide-level,
        ),
        header-right: self => self.info.logo,
        footer: self => {
            if self.info.title != none {
                self.info.title
                if self.info.subtitle != none [ --- ]
            }
            self.info.subtitle
        },
        footer-progress: false,
        headings-as-sections: false,
        ..args,
        body,
    ) = {
        set text(size: 24pt, font: "Atkinson Hyperlegible Next")

        set heading(hanging-indent: 0em)
        show heading: it => context {
            set text(fill: colors.get-colors().primary)
            it
        }

        show footnote.entry: set text(size: 0.5em)

        show: touying-slides.with(
            config-page(
                ..utils.page-args-from-aspect-ratio(aspect-ratio),
                header-ascent: 2cm,
                footer-descent: 0cm,
                margin: (y: 2cm, x: 2cm),
            ),

            config-common(
                slide-level: slide-level,
                slide-fn: slide,
                new-section-slide-fn: new-section-slide,
            ),

            config-methods(
                // alert: utils.alert-with-primary-color,
            ),

            // config-colors(
            //     primary: rgb("#f74f55"),
            //     primary-light: rgb("#f74f55").lighten(75%),
            // ),

            // save the variables for later use
            config-store(
                align: align,
                header: header,
                footer: footer,
                footer-progress: footer-progress,
            ),

            ..args,
        )

        set quote(block: true)
        show quote: set block(below: 0.65em, above: 0.65em)
        show quote.where(block: true): it => {
            set text(size: 1em)

            it.body

            if it.attribution != none {
                show: block
                set text(size: 0.75em)
                h(1fr)
                it.attribution
            }
        }

        body
    }

    (grape-suite-theme, slide, title-slide, focus-slide, outline-slide, new-section-slide)
}


#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))
