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

(module "Connector_FFC-FPC:Hirose_FH12-10S-0.5SH_1x10-1MP_P0.50mm_Horizontal" (layer "F.Cu")
  
  ${p.at}
  (attr smd)
 
  (fp_text reference "${p.ref}" (at 0 0 180) (layer "F.SilkS")
      (effects (font (size 1 1) (thickness 0.15)))
    
  )
  (fp_line (start -4.15 -1.3) (end -4.15 0.04)
    (stroke (width 0.12) (type solid)) (layer "F.SilkS") )
  (fp_line (start -4.15 2.76) (end -4.15 4.5)
    (stroke (width 0.12) (type solid)) (layer "F.SilkS") )
  (fp_line (start -4.15 4.5) (end 4.15 4.5)
    (stroke (width 0.12) (type solid)) (layer "F.SilkS") )
  (fp_line (start -2.66 -1.3) (end -4.15 -1.3)
    (stroke (width 0.12) (type solid)) (layer "F.SilkS") )
  (fp_line (start -2.66 -1.3) (end -2.66 -2.5)
    (stroke (width 0.12) (type solid)) (layer "F.SilkS") )
  (fp_line (start 2.66 -1.3) (end 4.15 -1.3)
    (stroke (width 0.12) (type solid)) (layer "F.SilkS") )
  (fp_line (start 4.15 -1.3) (end 4.15 0.04)
    (stroke (width 0.12) (type solid)) (layer "F.SilkS") )
  (fp_line (start 4.15 4.5) (end 4.15 2.76)
    (stroke (width 0.12) (type solid)) (layer "F.SilkS") )
  (fp_line (start -5.55 -3) (end -5.55 4.9)
    (stroke (width 0.05) (type solid)) (layer "F.CrtYd") )
  (fp_line (start -5.55 4.9) (end 5.55 4.9)
    (stroke (width 0.05) (type solid)) (layer "F.CrtYd") )
  (fp_line (start 5.55 -3) (end -5.55 -3)
    (stroke (width 0.05) (type solid)) (layer "F.CrtYd") )
  (fp_line (start 5.55 4.9) (end 5.55 -3)
    (stroke (width 0.05) (type solid)) (layer "F.CrtYd") )
  (fp_line (start -4.05 -1.2) (end -4.05 3.4)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start -4.05 3.4) (end -3.45 3.4)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start -3.95 3.7) (end -3.95 4.4)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start -3.95 4.4) (end 0 4.4)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start -3.45 3.4) (end -3.45 3.7)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start -3.45 3.7) (end -3.95 3.7)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start -2.75 -1.2) (end -2.25 -0.492893)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start -2.25 -0.492893) (end -1.75 -1.2)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start 0 -1.2) (end -4.05 -1.2)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start 0 -1.2) (end 4.05 -1.2)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start 3.45 3.4) (end 3.45 3.7)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start 3.45 3.7) (end 3.95 3.7)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start 3.95 3.7) (end 3.95 4.4)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start 3.95 4.4) (end 0 4.4)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start 4.05 -1.2) (end 4.05 3.4)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (fp_line (start 4.05 3.4) (end 3.45 3.4)
    (stroke (width 0.1) (type solid)) (layer "F.Fab") )
  (pad "1" smd rect (at -2.25 -1.85 180) (size 0.3 1.3) (layers "F.Cu" "F.Paste" "F.Mask")
    ${p.p1} (pinfunction "Pin_1") (pintype "passive") )
  (pad "2" smd rect (at -1.75 -1.85 180) (size 0.3 1.3) (layers "F.Cu" "F.Paste" "F.Mask")
    ${p.p2} (pinfunction "Pin_2") (pintype "passive") )
  (pad "3" smd rect (at -1.25 -1.85 180) (size 0.3 1.3) (layers "F.Cu" "F.Paste" "F.Mask")
    ${p.p3} (pinfunction "Pin_3") (pintype "passive") )
  (pad "4" smd rect (at -0.75 -1.85 180) (size 0.3 1.3) (layers "F.Cu" "F.Paste" "F.Mask")
    ${p.p4} (pinfunction "Pin_4") (pintype "passive") )
  (pad "5" smd rect (at -0.25 -1.85 180) (size 0.3 1.3) (layers "F.Cu" "F.Paste" "F.Mask")
    ${p.p5} (pinfunction "Pin_5") (pintype "passive") )
  (pad "6" smd rect (at 0.25 -1.85 180) (size 0.3 1.3) (layers "F.Cu" "F.Paste" "F.Mask")
    ${p.p6} (pinfunction "Pin_6") (pintype "passive") )
  (pad "7" smd rect (at 0.75 -1.85 180) (size 0.3 1.3) (layers "F.Cu" "F.Paste" "F.Mask")
    ${p.p7} (pinfunction "Pin_7") (pintype "passive") )
  (pad "8" smd rect (at 1.25 -1.85 180) (size 0.3 1.3) (layers "F.Cu" "F.Paste" "F.Mask")
    ${p.p8} (pinfunction "Pin_8") (pintype "passive") )
  (pad "9" smd rect (at 1.75 -1.85 180) (size 0.3 1.3) (layers "F.Cu" "F.Paste" "F.Mask")
    ${p.p9} (pinfunction "Pin_9") (pintype "passive") )
  (pad "10" smd rect (at 2.25 -1.85 180) (size 0.3 1.3) (layers "F.Cu" "F.Paste" "F.Mask")
    ${p.p10} (pinfunction "Pin_10") (pintype "passive") )
  (pad "MP" smd rect (at -4.15 1.4 180) (size 1.8 2.2) (layers "F.Cu" "F.Paste" "F.Mask") )
  (pad "MP" smd rect (at 4.15 1.4 180) (size 1.8 2.2) (layers "F.Cu" "F.Paste" "F.Mask") )
  (model "\${KICAD6_3DMODEL_DIR}/Connector_FFC-FPC.3dshapes/Hirose_FH12-10S-0.5SH_1x10-1MP_P0.50mm_Horizontal.wrl"
    (offset (xyz 0 0 0))
    (scale (xyz 1 1 1))
    (rotate (xyz 0 0 0))
  )
)

 `;
  },
};
