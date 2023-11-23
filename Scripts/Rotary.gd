extends Node2D

signal apply_initiate
signal apply_terminate
signal lamp_selected
signal show_gate_scene

func _on_button_pressed():
	emit_signal("show_gate_scene")

func _on_cancel_button_pressed():
	emit_signal("apply_terminate")
	

func _on_test_button_pressed():
	emit_signal("apply_initiate")

# It feels like i'm commiting sin
func lamp_access_on():
	$Lamp0.is_yourturn = true
	$Lamp1.is_yourturn = true
	$Lamp2.is_yourturn = true
	$Lamp3.is_yourturn = true
	$Lamp4.is_yourturn = true
	$Lamp5.is_yourturn = true
	$Lamp6.is_yourturn = true
	$Lamp7.is_yourturn = true
	$Lamp8.is_yourturn = true

func lamp_access_off():
	$Lamp0.is_yourturn = false
	$Lamp1.is_yourturn = false
	$Lamp2.is_yourturn = false
	$Lamp3.is_yourturn = false
	$Lamp4.is_yourturn = false
	$Lamp5.is_yourturn = false
	$Lamp6.is_yourturn = false
	$Lamp7.is_yourturn = false
	$Lamp8.is_yourturn = false


func _on_lamp_0_selected():
	lamp_selected.emit(0)

func _on_lamp_1_selected():
	lamp_selected.emit(1)


func _on_lamp_2_selected():
	lamp_selected.emit(2)


func _on_lamp_3_selected():
	lamp_selected.emit(3)


func _on_lamp_4_selected():
	lamp_selected.emit(4)


func _on_lamp_5_selected():
	lamp_selected.emit(5)


func _on_lamp_6_selected():
	lamp_selected.emit(6)


func _on_lamp_7_selected():
	lamp_selected.emit(7)


func _on_lamp_8_selected():
	lamp_selected.emit(8)
