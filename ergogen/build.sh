ergogen -d --clean . 
cp output/pcbs/left_pcb.kicad_pcb ../pcbs/the28left/the28left.kicad_pcb
cp output/outlines/left_plate.svg ../case/
cp output/outlines/right_plate.svg ../case/
./generateOpenScad.sh > ../case/keys.scad
