extends Node2D

var cursor_pos
var cursor_sprite

var logo
const logo_modulate_coef = 0.01
var logo_modulate_sign = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	cursor_sprite = $CursorSprite
	logo = $TitleControl/Logo
	
	logo.modulate.r = 0.5
	logo.modulate.g = 0
	logo.modulate.b = 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cursor_pos = get_viewport().get_mouse_position()

	cursor_sprite.position.x = cursor_pos.x
	cursor_sprite.position.y = cursor_pos.y
	
	var r = logo.modulate.r
	var b = logo.modulate.b
	if r < 0 or r > 1 or b < 0 or b > 1:
		logo_modulate_sign *= -1
	logo.modulate.r += logo_modulate_sign * logo_modulate_coef
	logo.modulate.b -= logo_modulate_sign * logo_modulate_coef

func _on_join_room_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/join_room.tscn")


func _on_how_to_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/how_to_play.tscn")
