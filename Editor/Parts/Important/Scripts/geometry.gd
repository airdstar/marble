extends part
class_name geometry

@export var geometry_base : MeshInstance3D

func add_shape(shape : shape_resource) -> void:
	geometry_base.add_shape(shape)

func remove_shape(shape : shape_resource) -> void:
	geometry_base.remove_shape(shape)

func set_shape_info(shapes : Array[shape_resource]) -> void:
	geometry_base.shape_info = shapes
	regenerate_mesh()

func get_shape_info() -> Array[shape_resource]:
	return geometry_base.shape_info

func regenerate_mesh() -> void:
	geometry_base.regenerate_mesh()

func create_collision() -> void:
	collider.shape = geometry_base.array_mesh.create_trimesh_shape()
