extends MarginContainer

var gatetoken = preload("res://Scenes/GateToken.tscn")


func _ready():
	# update_discarded(DumpedCards) # when its visibility is changed
	pass




func update_discarded(DumpedCards):
	# assuming DumpedCards array has lists of Cardnames
	var token
	for card_name in DumpedCards:
		token = gatetoken.instantiate()
		token.change_type(card_name)
		$MarginContainer/GridContainer.add_child(token)

func _on_button_pressed():
	queue_free()
