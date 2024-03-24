FREECADPATH = '/usr/lib/freecad/lib'

import sys
sys.path.append(FREECADPATH)

import argparse
import sys
import os

import FreeCAD
import Part
import Mesh

def create_parser():
    parser=argparse.ArgumentParser(description="Simple converter from .step file to .stl file")
    parser.add_argument("inputFile", help="file path for the input file")
    parser.add_argument("-o", "--output-dir", default=".", help="path of the directory to output converted file")
    parser.add_argument("-d", "--dimensions", action="store_true")
    return parser


arg_parser = create_parser()
args = arg_parser.parse_args(sys.argv[1:])

input = args.inputFile
name = os.path.basename(input).split(".")[0]
output = os.path.join(args.output_dir, name + ".stl")


if(not os.path.exists(args.inputFile)):
   sys.exit("Cannot find file" + args.inputFile)

if(not os.path.exists(args.output_dir)):
   sys.exit("Output dir '" + args.output_dir + "' does not exist")

print("writing " + output)

shape = Part.Shape()
shape.read(args.inputFile)
bb=shape.BoundBox
print(bb)
print(bb.Center)
shape.translate(App.Vector(-bb.Center.x, -bb.Center.y, 0))
doc = App.newDocument('Doc')
pf = doc.addObject("Part::Feature", "MyShape")
pf.Shape = shape
Mesh.export([pf], output)
if(args.dimensions):
    dimensionsFile = os.path.join(args.output_dir, name + "_dimensions.scad")
    with open(dimensionsFile, "w") as f:
        f.write(f"{name}_size=[{bb.XLength},{bb.YLength}, {bb.ZLength}];\n")

print("done")
