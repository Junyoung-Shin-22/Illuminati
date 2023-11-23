extends MarginContainer

var gateCardStock = [10, 8, 5, 4, 4, 2, 1]
enum {Identity, Not, Hadamard, Conditional, NotConditional, Swap, Observe} # card idx idk if needed
enum {InHand, MovingToDumped, Dumped, InMouse, FocusInHand, MoveDrawnCardToHand, ReOrganizeHand} # card states
var cardTypes = [["Identity", 0, 0, 1], ["Not", 1, 0, 2], ["Hadamard", 2, 0, 3], ["Conditional", 3, 0, 4], ["NotConditional", 4, 0, 4], ["Swap", 5, 0, 8], ["Observe", 6, 0, 10]]
var moneyTypes = [["Bronze", 0, 0, 1], ["Silver", 1, 0, 2], ["Gold", 2, 0, 3]]
const cardSize = Vector2(125, 175) * 0.4
const cardButton = preload("res://Scenes/card_button.tscn")

signal quitShop

# Called when the node enters the scene tree for the first time.
func _ready():
	quitShop.connect($'../'.quitShop)

func showPurchasePower(purchasePower):
	$Control/VBoxContainer/userInfoContainer/MarginContainer/money.text = "money: " + str(purchasePower)
func resetPurchasePower():
	$Control/VBoxContainer/userInfoContainer/MarginContainer/money.text = "money: X"
func showPrice(price):
	$Control/VBoxContainer/userInfoContainer/MarginContainer2/price.text = "price: " + str(price)
func resetSelected():
	$Control/VBoxContainer/userInfoContainer/MarginContainer2/price.text = "price: X"

func _on_button_pressed():
	quitShop.emit()
