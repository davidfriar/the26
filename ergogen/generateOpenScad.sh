yq --raw-output '"plate_padding="+(.units.p|tostring)+";"' output/source/canonical.yaml 
yq --raw-output '"pcb_offset_x="+(.units.offset_x|tostring)+";"' output/source/canonical.yaml 
yq --raw-output '"pcb_offset_y="+(.units.offset_y|tostring)+";"' output/source/canonical.yaml 

yq --raw-output '"key_points="+([.[]|[.x,.y]]|tostring)+";"'  output/points/points.yaml
yq --raw-output '"left_key_points="+([.[]|select(.meta.mirrored==false)|[.x,.y]]|tostring)+";"'  output/points/points.yaml
yq --raw-output '"right_key_points="+([.[]|select(.meta.mirrored==true)|[.x,.y]]|tostring)+";"'  output/points/points.yaml


yq --raw-output '"key_rotations="+([.[]|.r]|tostring)+";"'  output/points/points.yaml
yq --raw-output '"left_key_rotations="+([.[]|select(.meta.mirrored==false)|.r]|tostring)+";"'  output/points/points.yaml
yq --raw-output '"right_key_rotations="+([.[]|select(.meta.mirrored==true)|.r]|tostring)+";"'  output/points/points.yaml

sed 's/.*height="\([0-9]*\).*/left_plate_height=\1;\n/' output/outlines/left_plate.svg 
sed 's/.*height="\([0-9]*\).*/right_plate_height=\1;\n/' output/outlines/right_plate.svg 
