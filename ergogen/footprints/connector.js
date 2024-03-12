module.exports = {
  params: {
    designator: "J",
    p1: { type: "net", value: "p1" },
    p2: { type: "net", value: "p2" },
    p3: { type: "net", value: "p3" },
    p4: { type: "net", value: "p4" },
    p5: { type: "net", value: "p5" },
    p6: { type: "net", value: "p6" },
    p7: { type: "net", value: "p7" },
    p8: { type: "net", value: "p8" },
    p9: { type: "net", value: "p9" },
    p10: { type: "net", value: "p10" },
  },

  body: (p) => {
    return `
(module Molex2004850410 (layer F.Cu) (tedit 60CE555C)
  (attr smd)
  ${p.at}
  (fp_text reference "${p.ref}" (at 0 -2.54) (layer F.SilkS)
    (effects (font (size 1 1) (thickness 0.15)))
  )
  (fp_text value "Molex 2004850410" (at -0.05 7.3) (layer F.Fab)
    (effects (font (size 1 1) (thickness 0.15)))
  )
  (fp_line (start -3 -0.98) (end 3 -0.98) (layer F.SilkS) (width 0.12))
  (fp_line (start 9.1 6.1) (end -9.1 6.12) (layer F.SilkS) (width 0.12))
  (fp_line (start -9.11 6.1) (end -9.11 0.76) (layer F.SilkS) (width 0.12))
  (fp_line (start 9.16 6.1) (end 9.11 0.76) (layer F.SilkS) (width 0.12))
  (fp_line (start -9.11 0.76) (end -3 0.76) (layer F.SilkS) (width 0.12))
  (fp_line (start 9.11 0.76) (end 3 0.76) (layer F.SilkS) (width 0.12))
  (fp_line (start -3 0.76) (end -3 -0.98) (layer F.SilkS) (width 0.12))
  (fp_line (start 3 0.76) (end 3 -0.98) (layer F.SilkS) (width 0.12))
  (fp_line (start -9.35 -1.2) (end 9.35 -1.2) (layer F.CrtYd) (width 0.05))
  (fp_line (start 9.35 -1.2) (end 9.35 8.6) (layer F.CrtYd) (width 0.05))
  (fp_line (start -9.35 8.6) (end 9.35 8.6) (layer F.CrtYd) (width 0.05))
  (fp_line (start -9.35 -1.2) (end -9.35 8.6) (layer F.CrtYd) (width 0.05))
  (pad 1 smd rect (at -2.25 0) (size 0.25 1.6) (layers F.Cu F.Paste F.Mask) ${p.p1})
  (pad 2 smd rect (at -1.75 0) (size 0.25 1.6) (layers F.Cu F.Paste F.Mask) ${p.p2})
  (pad 3 smd rect (at -1.25 0) (size 0.25 1.6) (layers F.Cu F.Paste F.Mask) ${p.p3})
  (pad 4 smd rect (at -0.75 0) (size 0.25 1.6) (layers F.Cu F.Paste F.Mask) ${p.p4})
  (pad 5 smd rect (at -0.25 0) (size 0.25 1.6) (layers F.Cu F.Paste F.Mask) ${p.p5})
  (pad 6 smd rect (at 0.25 0) (size 0.25 1.6) (layers F.Cu F.Paste F.Mask) ${p.p6})
  (pad 7 smd rect (at 0.75 0) (size 0.25 1.6) (layers F.Cu F.Paste F.Mask) ${p.p7})
  (pad 8 smd rect (at 1.25 0) (size 0.25 1.6) (layers F.Cu F.Paste F.Mask) ${p.p8})
  (pad 9 smd rect (at 1.75 0) (size 0.25 1.6) (layers F.Cu F.Paste F.Mask) ${p.p9})
  (pad 10 smd rect (at 2.25 0) (size 0.25 1.6) (layers F.Cu F.Paste F.Mask) ${p.p10})
  (pad 0 smd rect (at -7.25 3.27) (size 2 2) (layers F.Cu F.Paste F.Mask))
  (pad 0 smd rect (at 7.25 3.27) (size 2 2) (layers F.Cu F.Paste F.Mask))
  (model \${ERGOGEN_MODELS}/2004850410.stp
    (offset (xyz 0 -3 1.85))
    (scale (xyz 1 1 1))
    (rotate (xyz -90 0 0))
  )
)

    `;
  },
};
