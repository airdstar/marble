extends Control

signal new_part_selected
signal new_shape_selected

func _ready() -> void:
	load_part(0, "res://Editor/Shapes/")
	load_part(1, "res://Editor/Parts/Misc/")
	load_part(2, "res://Editor/Parts/Important/")

func load_part(type : int, path : String) -> void:
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var current : String = dir.get_next()
	while current != "":
		if '.remap' in current:
			current = current.trim_suffix('.remap')
		
		
		if '.import' in current or dir.current_is_dir() or '.uid' in current:
			current = dir.get_next()
			continue
		
		var holder = load(path + current)
		var button = create_button()
		
		if type == 0:
			holder = holder.new()
			button.text = current.trim_suffix(".gd")
			$PartContainer/ScrollContainer/Shapes.add_child(button)
			button.pressed.connect(shape_selected.bind(holder))
		else:
			holder = holder.instantiate()
			button.text = holder.part_name
			match type:
				1:
					$PartContainer/ScrollContainer/Misc.add_child(button)
				2:
					$PartContainer/ScrollContainer/Important.add_child(button)
			button.pressed.connect(part_selected.bind(path + current))
		
		current = dir.get_next()
	dir.list_dir_end()

func create_button() -> Button:
	var button = Button.new()
	button.custom_minimum_size = Vector2(100,100)
	return button

func part_selected(part_path : String) -> void:
	var holder = load(part_path)
	holder = holder.instantiate()
	new_part_selected.emit(holder)

func shape_selected(shape : Resource) -> void:
	new_shape_selected.emit(shape)

func tab_changed(toggled_on : bool, tab: int) -> void:
	if toggled_on:
		$PartContainer.show()
		match tab:
			0:
				$PartContainer/ScrollContainer/Shapes.show()
				$PartContainer/ScrollContainer/Important.hide()
				$PartContainer/ScrollContainer/Misc.hide()
				$Buttons/VBoxContainer/Important.set_pressed_no_signal(false)
				$Buttons/VBoxContainer/Misc.set_pressed_no_signal(false)
				
			1:
				$PartContainer/ScrollContainer/Shapes.hide()
				$PartContainer/ScrollContainer/Important.show()
				$PartContainer/ScrollContainer/Misc.hide()
				$Buttons/VBoxContainer/Misc.set_pressed_no_signal(false)
				$Buttons/VBoxContainer/Shapes.set_pressed_no_signal(false)
			2:
				$PartContainer/ScrollContainer/Shapes.hide()
				$PartContainer/ScrollContainer/Important.hide()
				$PartContainer/ScrollContainer/Misc.show()
				$Buttons/VBoxContainer/Important.set_pressed_no_signal(false)
				$Buttons/VBoxContainer/Shapes.set_pressed_no_signal(false)
	else:
		$PartContainer.hide()
