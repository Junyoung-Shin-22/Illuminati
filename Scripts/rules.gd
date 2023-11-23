extends Control

@onready var cursor = Sprite2D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	cursor.texture = load("res://src/white_cursor.png")
	cursor.scale *= 0.075
	add_child(cursor)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cursor.position = get_global_mouse_position()



func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/how_to_play.tscn")
