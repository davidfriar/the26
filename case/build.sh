openscad -o output/left-plate.svg plate.scad
openscad -D '$side="right"' -o output/right-plate.svg plate.scad
sed -i -e 's/fill="[^"]*"/fill="none"/' -e 's/stroke-width="[^"]*"/stroke-width="0.09"/' output/left-plate.svg
sed -i -e 's/fill="[^"]*"/fill="none"/' -e 's/stroke-width="[^"]*"/stroke-width="0.09"/' output/right-plate.svg

