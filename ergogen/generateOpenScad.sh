
yq --raw-output '"key_points="+([.[]|[.x,.y]]|tostring)+";"'  output/points/points.yaml
yq --raw-output '"left_key_points="+([.[]|select(.meta.mirrored==false)|[.x,.y]]|tostring)+";"'  output/points/points.yaml
yq --raw-output '"right_key_points="+([.[]|select(.meta.mirrored==true)|[.x,.y]]|tostring)+";"'  output/points/points.yaml


yq --raw-output '"key_rotations="+([.[]|.r]|tostring)+";"'  output/points/points.yaml
yq --raw-output '"left_key_rotations="+([.[]|select(.meta.mirrored==false)|.r]|tostring)+";"'  output/points/points.yaml
yq --raw-output '"right_key_rotations="+([.[]|select(.meta.mirrored==true)|.r]|tostring)+";"'  output/points/points.yaml

yq --raw-output '.|to_entries|map("\(.key)=[\(.value.x),\(.value.y)];")|.[]' output/points/points.yaml

yq --raw-output '"top_row_left=\([.[]|select(.meta.row=="top")|select(.meta.mirrored==false)|.meta.name]);"' output/points/points.yaml | sed -s 's/"//g'
yq --raw-output '"top_row_right=\([.[]|select(.meta.row=="top")|select(.meta.mirrored==true)|.meta.name]);"' output/points/points.yaml | sed -s 's/"//g'
yq --raw-output '"bottom_row_left=\([.[]|select(.meta.row=="bottom")|select(.meta.mirrored==false)|.meta.name]);"' output/points/points.yaml | sed -s 's/"//g'
yq --raw-output '"bottom_row_right=\([.[]|select(.meta.row=="bottom")|select(.meta.mirrored==true)|.meta.name]);"' output/points/points.yaml | sed -s 's/"//g'
yq --raw-output '"thumb_row_left=\([.[]|select(.meta.row=="thumb")|select(.meta.mirrored==false)|.meta.name]);"' output/points/points.yaml | sed -s 's/"//g'
yq --raw-output '"thumb_row_right=\([.[]|select(.meta.row=="thumb")|select(.meta.mirrored==true)|.meta.name]);"' output/points/points.yaml | sed -s 's/"//g'

