extends Control

const CARDS = {
	"Identity" :
		["Gate", "Identity", 0, 1, "Applies identity gate to a qubit"], 
	"Not" :
		["Gate", "Not", 0, 2, "Applies not gate to a qubit"], 
	"Hadamard" :
		["Gate", "Hadamard", 0, 3, "Applies hadamard gate to a qubit"], 
	"Conditional" :
		["Gate", "Conditional", 0, 5, "Can be used with other card to apply conditional gate to a qubit"], 
	"NotConditional" :
		["Gate", "NotConditional", 0, 5, "Can be used with other card to apply not conditional gate to a qubit"], 
	"Swap" :
		["Gate", "Swap", 0, 8, "Swaps the states between two qubits"], 
	"Observe" :
		["Gate", "Observe", 0, 10, "Observes the state of a qubit and fixes its state"], 
	"Bronze" :
		["Money", "Bronze", 1, 0, "Bronze coin. Can be used to buy something at shop"], 
	"Silver" :
		["Money", "Silver", 2, 3, "Silver coin. Can be used to buy something at shop"], 
	"Gold" :
		["Money", "Gold", 3, 6, "Gold coin. Can be used to buy something at shop"], 
}

var cardName
var cardInfo
var cardImage

var purchasePower
var price

var is_selected

signal selected
func _ready():
	selected.connect($'../'._on_select)

func initialize(card_name):
	is_selected = false
	cardName = card_name
	cardInfo = CARDS[cardName]
	cardImage = str("res://Assets/Cards/", cardInfo[0], "/", cardName, ".png")
	
	purchasePower = cardInfo[2]
	price = cardInfo[3]
	
	$Card.texture = load(cardImage)
	$PurchasePower.text = str(purchasePower)
	$Price.text = str(price)

func card_free():
	queue_free()	

func flip():
	$CardBack.visible = not $CardBack.visible

func _on_focus_pressed():
	emit_signal("selected", self)

func shader_on():
	material.set_shader_parameter("shaderOn", true)
	
func shader_off():
	material.set_shader_parameter("shaderOn", false)
