extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$cursor.position = get_global_mouse_position()



func _on_goal_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/goals.tscn")


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/root.tscn")


func _on_rule_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/rules.tscn")


func _on_gates_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/gates.tscn")


func _on_tutorial_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")
