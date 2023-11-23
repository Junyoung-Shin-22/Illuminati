extends Node2D

var who_won = 0 #0 is red, 1 is blue
var you_won = 0

func _ready():
	await get_tree().create_timer(3.0).timeout 
	if who_won:$PointLight2D.color = Color("ff0000")
	else: $PointLight2D.color = Color("0000ff")
	if you_won: $Label.text = "you won"
	else: $Label.text = "you lost"
	$PointLight2D.visible = true
	$Label.visible = true
