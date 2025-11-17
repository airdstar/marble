extends Node3D

enum axis {
	NONE,
	X,
	Y,
	Z
}

enum state {
	IDLE,
	GRAB
}

enum tool {
	NONE,
	POS,
	ROT,
	SCALE
	
}

var current_tool : tool = tool.NONE
var current_state : state = state.IDLE
var grabbed : axis = axis.NONE
var hovered : axis = axis.NONE

func _physics_process(_delta: float) -> void:
	match %Info.adjusting:
		editor_info.adjustable.PART:
			position = %Info.selected_part.position
		editor_info.adjustable.SHAPE:
			position = %Info.selected_shape.total_offset
	
	if current_tool == tool.SCALE:
		match %Info.adjusting:
			editor_info.adjustable.PART:
				$X.position.x = %Info.selected_part.scale.x / 2
				$Y.position.y = %Info.selected_part.scale.y / 2
				$Z.position.z = %Info.selected_part.scale.z / 2
			editor_info.adjustable.SHAPE:
				$X.position.x = %Info.selected_shape.size.x / 2
				$Y.position.y = %Info.selected_shape.size.y / 2
				$Z.position.z = %Info.selected_shape.size.z / 2


func set_tool(_tool : tool) -> void:
	current_tool = _tool
	set_visibility()

func set_visibility() -> void:
	var visible_mesh : Mesh = null
	var collider : Shape3D = null
	if %Info.adjusting != %Info.adjustable.NONE:
		match current_tool:
			tool.POS:
				visible_mesh = CylinderMesh.new()
				visible_mesh.height = 1.8
				visible_mesh.top_radius = 0
				visible_mesh.bottom_radius = 0.1
				visible_mesh.radial_segments = 4
				
				$X.position = Vector3(1,0,0)
				$Y.position = Vector3(0,1,0)
				$Z.position = Vector3(0,0,1)
				
				$X.rotation_degrees = Vector3(0,0,-90)
				$Y.rotation = Vector3.ZERO
				$Z.rotation_degrees = Vector3(90,0,0)
				
				collider = BoxShape3D.new()
				collider.size = Vector3(0.3, 2.0, 0.3)
				
			tool.ROT:
				pass
			tool.SCALE:
				visible_mesh = SphereMesh.new()
				visible_mesh.radius = 0.1
				visible_mesh.height = 0.2
				visible_mesh.radial_segments = 16
				visible_mesh.rings = 8
				
				$X.rotation = Vector3.ZERO
				$Y.rotation = Vector3.ZERO
				$Z.rotation = Vector3.ZERO
				
				collider = BoxShape3D.new()
				collider.size = Vector3(0.3, 0.3, 0.3)
				
	
	for n in get_children():
		n.mesh = visible_mesh
		n.get_child(0).get_child(0).shape = collider

func enter(_axis: String) -> void:
	match _axis:
		"X":
			$X.get_material_override().emission = Color(1.0, 0.4, 0.4, 1.0)
			hovered = axis.X
			exit("Y")
			exit("Z")
		"Y":
			$Y.get_material_override().emission = Color(0.4, 1.0, 0.4, 1.0)
			hovered = axis.Y
			exit("X")
			exit("Z")
		"Z":
			$Z.get_material_override().emission = Color(0.4, 0.4, 1.0, 1.0)
			hovered = axis.Z
			exit("Y")
			exit("X")


func exit(_axis: String) -> void:
	match _axis:
		"X":
			$X.get_material_override().emission = Color(1.0, 0.1, 0.1, 1.0)
			if hovered == axis.X:
				hovered = axis.NONE
		"Y":
			$Y.get_material_override().emission = Color(0.1, 1.0, 0.1, 1.0)
			if hovered == axis.Y:
				hovered = axis.NONE
		"Z":
			$Z.get_material_override().emission = Color(0.1, 0.1, 1.0, 1.0)
			if hovered == axis.Z:
				hovered = axis.NONE
