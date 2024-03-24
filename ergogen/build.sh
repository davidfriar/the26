ergogen -d --clean . 

cp output/pcbs/left_pcb.kicad_pcb ../pcbs/left/left.kicad_pcb
cp output/pcbs/right_pcb.kicad_pcb ../pcbs/right/right.kicad_pcb

kicad-cli pcb export step -f --subst-models -o ../case/left_pcb.step    ../pcbs/left/left.kicad_pcb
kicad-cli pcb export step -f --subst-models -o ../case/right_pcb.step    ../pcbs/right/right.kicad_pcb
kicad-cli pcb export step -f --subst-models -o ../case/daughterboard_left_pcb.step    ../pcbs/daughterboard_left/daughterboard_left.kicad_pcb
kicad-cli pcb export step -f --subst-models -o ../case/daughterboard_right_pcb.step    ../pcbs/daughterboard_right/daughterboard_right.kicad_pcb

python ../utils/convert3d/stepToSTL.py -d -o ../case ../case/left_pcb.step
python ../utils/convert3d/stepToSTL.py -d -o ../case ../case/right_pcb.step
python ../utils/convert3d/stepToSTL.py -d -o ../case ../case/daughterboard_left_pcb.step
python ../utils/convert3d/stepToSTL.py -d -o ../case ../case/daughterboard_right_pcb.step

cp output/outlines/left_plate.svg ../case/
cp output/outlines/right_plate.svg ../case/
./generateOpenScad.sh > ../case/keys.scad
