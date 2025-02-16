extends Node

@export var rotation_amount : RichTextLabel
@export var rotation_amount_slider : HSlider

@export var rotation_speed : RichTextLabel
@export var rotation_speed_slider : HSlider

@export var rotation_downtime : RichTextLabel

@export var rotation_reverse : CheckBox

func set_values(rot_comp : rotateable_component) -> void:
	rotation_amount.text = " Rotation Deg: %d" % rot_comp.rotation_amount
	rotation_amount_slider.set_value_no_signal(rot_comp.rotation_amount)
	
	rotation_speed.text = " Secs per rotation: %.1f" % rot_comp.rotation_speed
	rotation_speed_slider.set_value_no_signal(rot_comp.rotation_speed)
	
	rotation_reverse.set_pressed_no_signal(rot_comp.reversable)
