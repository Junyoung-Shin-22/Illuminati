extends Label

var count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dot_timer_timeout():
	if count == 0:
		text = "."
	else:
		text += "."
	count = (count + 1) % 3
