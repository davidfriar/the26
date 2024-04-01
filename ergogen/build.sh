ergogen -d --clean . 

cp output/pcbs/left_pcb.kicad_pcb ../pcbs/left/left.kicad_pcb
cp output/pcbs/right_pcb.kicad_pcb ../pcbs/right/right.kicad_pcb

kicad-cli pcb export step -f --subst-models -o ../case/pcbs/left_pcb.step    ../pcbs/left/left.kicad_pcb
kicad-cli pcb export step -f --subst-models -o ../case/pcbs/right_pcb.step    ../pcbs/right/right.kicad_pcb
kicad-cli pcb export step -f --subst-models -o ../case/pcbs/daughterboard_pcb.step    ../pcbs/daughterboard/daughterboard.kicad_pcb

python ../utils/convert3d/stepToSTL.py -d -o ../case/pcbs ../case/pcbs/left_pcb.step
python ../utils/convert3d/stepToSTL.py -d -o ../case/pcbs ../case/pcbs/right_pcb.step
python ../utils/convert3d/stepToSTL.py -d -o ../case/pcbs ../case/pcbs/daughterboard_pcb.step

cp output/outlines/left_board.svg ../case/pcbs/left_pcb.svg
cp output/outlines/right_board.svg ../case/pcbs/right_pcb.svg
./generateOpenScad.sh > ../case/keys.scad
