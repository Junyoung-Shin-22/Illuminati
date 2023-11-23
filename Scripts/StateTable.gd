extends MarginContainer
var gatetoken = preload("res://Scenes/GateToken.tscn")

func _ready():
	var applied_gates = $"..".applied_gates
	update_values(applied_gates)

func update_values(applied_gates):
	var token 
	var format_string
	var container
	var idx 
	
	
	for i in range(9):
		container = $Control/VBoxContainer/HBoxContainer.get_child(i)
		idx = 0
		for child in container.get_children():
			if idx: container.remove_child(child)
			idx += 1
		for gates in applied_gates[i]:
			token = gatetoken.instantiate()
			token.change_type(gates)
			container.add_child(token)


func _on_button_pressed():
	visible = false


func _on_state_button_pressed():
	update_values($"..".applied_gates)
