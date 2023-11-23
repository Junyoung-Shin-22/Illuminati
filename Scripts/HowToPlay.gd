extends Node2D

var root_scene = preload("res://Scenes/root.tscn")

var cursor_pos
var cursor_sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	cursor_sprite = $CursorSprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cursor_pos = get_viewport().get_mouse_position()

	cursor_sprite.position.x = cursor_pos.x
	cursor_sprite.position.y = cursor_pos.y

func _on_back_button_pressed():
	get_tree().change_scene_to_packed(root_scene)
