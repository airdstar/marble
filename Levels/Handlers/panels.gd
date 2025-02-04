extends Node

var rows := 12
var columns := 60
var pivots : Array[Node3D]
var speed : float = 0.05
var current_color : Color
var chosen_style : FloorLevel.panel_style

func _ready() -> void:
	choose_random()
	for m in rows:
		var pivot = Node3D.new()
		add_child(pivot)
		pivots.append(pivot)
		for n in columns:
			var holder = MeshInstance3D.new()
			holder.mesh = ResourceLoader.load("res://Levels/Parts/Panel.obj")
			holder.position = Vector3(-cos(PI * (n + (float(m) / 3)) / (columns / 2)) * (20 - float(m) / 5), 12.5 - m * 2, sin(PI * (n + (float(m) / 3)) / (columns / 2)) * (20 - float(m) / 5))
			holder.rotation = Vector3(0, PI * 2.0 * (float(n + float(m) / 3) / columns), deg_to_rad(20))
			holder.set_layer_mask_value(7, true)
			holder.set_layer_mask_value(1, false)
			pivot.add_child(holder)

func choose_random() -> void:
	pass

func change_color() -> void:
	pass

func _process(delta: float) -> void:
	for n in pivots:
		n.rotate_y(speed * delta)
