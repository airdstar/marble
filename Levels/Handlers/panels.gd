extends Node

enum style {
	LEFT,
	RIGHT,
	OTHER,
	TWO
}

var pivots : Array[Node3D]
var speed : int = 5
var chosen_style : style

func _ready() -> void:
	choose_random()
	for m in 15:
		var pivot = Node3D.new()
		add_child(pivot)
		pivots.append(pivot)
		for n in 50:
			var holder = MeshInstance3D.new()
			holder.mesh = ResourceLoader.load("res://Levels/Parts/Panel.obj")
			holder.position = Vector3(-cos(PI * (n + (float(m) / 3)) / 25) * (17.5 - float(m) / 5), 15 - m * 2, sin(PI * (n + (float(m) / 3)) / 25) * (17.5 - float(m) / 5))
			holder.rotation = Vector3(0, PI * 2.0 * (float(n + float(m) / 3) / 50), deg_to_rad(20))
			holder.set_layer_mask_value(7, true)
			holder.set_layer_mask_value(1, false)
			pivot.add_child(holder)

func choose_random() -> void:
	pass

func _process(delta: float) -> void:
	for n in pivots:
		n.rotate_y(speed * delta)
