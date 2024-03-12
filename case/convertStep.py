import trimesh


mesh = trimesh.Trimesh(**trimesh.interfaces.gmsh.load_gmsh(file_name = 'leftpcb.step', gmsh_args = [
            ("Mesh.Algorithm", 1), #Different algorithm types, check them out
            ("Mesh.CharacteristicLengthFromCurvature", 50), #Tuning the smoothness, + smothness = + time
            ("General.NumThreads", 10), #Multithreading capability
            ("Mesh.MinimumCirclePoints", 32)])) 
print("Mesh volume: ", mesh.volume)
print("Mesh Bounding Box volume: ", mesh.bounding_box_oriented.volume)
print("Mesh Area: ", mesh.area)
mesh.export('leftpcb.stl')
