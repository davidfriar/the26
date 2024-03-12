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

  (fp_text reference "${p.ref}" (at -1.718 -3.1064) (layer F.SilkS)
    (effects (font (size 0.64 0.64) (thickness 0.15)))
  )
  (fp_text value "Conn_01x10_Socket" (at 3.2524 3.1936) (layer "F.Fab")
      (effects (font (size 0.64 0.64) (thickness 0.15)))
    
  )


  (fp_line (start -3.5 -1.9) (end -2.8 -1.9)
    (stroke (width 0.2) (type solid)) (layer "F.SilkS") )
  (fp_line (start -3.5 0.5) (end -3.5 -1.9)
    (stroke (width 0.2) (type solid)) (layer "F.SilkS") )
  (fp_line (start -2.65 1.9) (end 2.65 1.9)
    (stroke (width 0.2) (type solid)) (layer "F.SilkS") )
  (fp_line (start 2.8 -1.9) (end 3.5 -1.9)
    (stroke (width 0.2) (type solid)) (layer "F.SilkS") )
  (fp_line (start 3.5 -1.9) (end 3.5 0.5)
    (stroke (width 0.2) (type solid)) (layer "F.SilkS") )
  (fp_circle (center -2.25 -2.4) (end -2.15 -2.4)
    (stroke (width 0.2) (type solid)) (fill none) (layer "F.SilkS") )
  (fp_line (start -3.75 -2.15) (end -3.75 2.15)
    (stroke (width 0.05) (type solid)) (layer "F.CrtYd") )
  (fp_line (start -3.75 2.15) (end 3.75 2.15)
    (stroke (width 0.05) (type solid)) (layer "F.CrtYd") )
  (fp_line (start 3.75 -2.15) (end -3.75 -2.15)
    (stroke (width 0.05) (type solid)) (layer "F.CrtYd") )
  (fp_line (start 3.75 2.15) (end 3.75 -2.15)
    (stroke (width 0.05) (type solid)) (layer "F.CrtYd") )
  (fp_line (start -3.5 -1.9) (end 3.5 -1.9)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start -3.5 -1) (end -3.5 -1.9)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start -3.5 -1) (end 3.5 -1)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start -3.5 1.9) (end -3.5 -1)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start 3.5 -1.9) (end 3.5 -1)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start 3.5 -1) (end 3.5 1.9)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start 3.5 1.9) (end -3.5 1.9)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_circle (center -2.25 -2.4) (end -2.15 -2.4)
    (stroke (width 0.2) (type solid)) (fill none) (layer "F.Fab") )
  (pad "1" smd rect (at -2.25 -1.25 180) (size 0.3 0.8) (layers "F.Cu" "F.Paste" "F.Mask")
    ${p.p1} (pinfunction "Pin_1") (pintype "passive") (solder_mask_margin 0.102) )
  (pad "2" smd rect (at -1.75 -1.25 180) (size 0.3 0.8) (layers "F.Cu" "F.Paste" "F.Mask")
    ${p.p2} (pinfunction "Pin_2") (pintype "passive") (solder_mask_margin 0.102) )
  (pad "3" smd rect (at -1.25 -1.25 180) (size 0.3 0.8) (layers "F.Cu" "F.Paste" "F.Mask")
    ${p.p3} (pinfunction "Pin_3") (pintype "passive") (solder_mask_margin 0.102) )
  (pad "4" smd rect (at -0.75 -1.25 180) (size 0.3 0.8) (layers "F.Cu" "F.Paste" "F.Mask")
    ${p.p4} (pinfunction "Pin_4") (pintype "passive") (solder_mask_margin 0.102) )
  (pad "5" smd rect (at -0.25 -1.25 180) (size 0.3 0.8) (layers "F.Cu" "F.Paste" "F.Mask")
    ${p.p5} (pinfunction "Pin_5") (pintype "passive") (solder_mask_margin 0.102) )
  (pad "6" smd rect (at 0.25 -1.25 180) (size 0.3 0.8) (layers "F.Cu" "F.Paste" "F.Mask")
    ${p.p6} (pinfunction "Pin_6") (pintype "passive") (solder_mask_margin 0.102) )
  (pad "7" smd rect (at 0.75 -1.25 180) (size 0.3 0.8) (layers "F.Cu" "F.Paste" "F.Mask")
    ${p.p7} (pinfunction "Pin_7") (pintype "passive") (solder_mask_margin 0.102) )
  (pad "8" smd rect (at 1.25 -1.25 180) (size 0.3 0.8) (layers "F.Cu" "F.Paste" "F.Mask")
    ${p.p8} (pinfunction "Pin_8") (pintype "passive") (solder_mask_margin 0.102) )
  (pad "9" smd rect (at 1.75 -1.25 180) (size 0.3 0.8) (layers "F.Cu" "F.Paste" "F.Mask")
    ${p.p9} (pinfunction "Pin_9") (pintype "passive") (solder_mask_margin 0.102) )
  (pad "10" smd rect (at 2.25 -1.25 180) (size 0.3 0.8) (layers "F.Cu" "F.Paste" "F.Mask")
    ${p.p10} (pinfunction "Pin_10") (pintype "passive") (solder_mask_margin 0.102) )
  (pad "S1" smd rect (at -3.2 1.25 180) (size 0.4 0.8) (layers "F.Cu" "F.Paste" "F.Mask")
    (solder_mask_margin 0.102) )
  (pad "S2" smd rect (at 3.2 1.25 180) (size 0.4 0.8) (layers "F.Cu" "F.Paste" "F.Mask")
    (solder_mask_margin 0.102) )
  (model \${ERGOGEN_MODELS}/FFC2B28-10-G.step
    (offset (xyz 0 0 0))
    (scale (xyz 1 1 1))
    (rotate (xyz -90 0 0))
  )
)
    `;
  },
};
