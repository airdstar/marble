extends Control

var player_dummy : player

func _ready() -> void:
	for n in Cosmetic.colors:
		var current := make_button()
		%ColorContainer.add_child(current)
		var color = TextureRect.new()
		color.texture = ResourceLoader.load("res://Assets/Circle.png")
		color.modulate = n
		current.add_child(color)
		current.pressed.connect(set_color.bind(n))
	
	for n in Cosmetic.decals:
		var current := make_button()
		%DecalContainer.add_child(current)
		current.icon = n
		current.pressed.connect(set_decal.bind(n))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		Global.close_popup()
	
	if player_dummy != null:
		player_dummy.rotate_y(0.5 * delta)

func make_button() -> Button:
	var button := Button.new()
	button.expand_icon = true
	button.custom_minimum_size = Vector2(150,150)
	return button


func set_data(playerdata : PlayerData) -> void:
	%Runs.text = str(playerdata.game_over_count)
	%Highest.text = str(playerdata.highest_level)
	player_dummy = preload("res://Main/Player.tscn").instantiate()
	player_dummy.set_customization(playerdata.player_customization)
	player_dummy.freeze = true
	$SubViewport.add_child(player_dummy)

func colors_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%Decals.button_pressed = false
		%ColorContainer.show()
		%DecalContainer.hide()
		%ScrollContainer.scroll_vertical = 0
		%CustomizationContainer.show()
	else:
		if !%Decals.button_pressed:
			%CustomizationContainer.hide()

func decals_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%Colors.button_pressed = false
		%DecalContainer.show()
		%ColorContainer.hide()
		%ScrollContainer.scroll_vertical = 0
		%CustomizationContainer.show()
	else:
		if !%Colors.button_pressed:
			%CustomizationContainer.hide()

func set_color(color : Color) -> void:
	PlayerInfo.player_data.player_customization.chosen_color = color
	update_dummy()

func set_decal(decal : Texture2D) -> void:
	PlayerInfo.player_data.player_customization.chosen_decal = decal
	player_dummy.rotation.y = 0
	update_dummy()

func update_dummy() -> void:
	PlayerInfo.save_data()
	player_dummy.set_color()
	player_dummy.set_decal()
