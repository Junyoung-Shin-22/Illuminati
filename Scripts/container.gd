extends VBoxContainer

var on = false

signal selectedItem

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.visible = false
	#selectedItem.connect($'../../../../../'.onSelectedItem)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mousePosition = get_local_mouse_position()
	if mousePosition.x < size.x and mousePosition.y < size.y and mousePosition.x > 0 and mousePosition.y > 0:
		$Button.visible = true
	else:
		$Button.visible = false

func _on_button_pressed():
	selectedItem.emit(self.name)
