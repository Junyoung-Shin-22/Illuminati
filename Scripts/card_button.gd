extends MarginContainer

@export var cardName = 'Identity'

@onready var cardDB = preload("res://Scripts/CardDB.gd")
@onready var cardInfo = cardDB.CARDS[cardName]
@onready var cardImage = str("res://Assets/Cards/", cardInfo[0], "/", cardName, ".png")

@onready var purchasePower = str(cardInfo[2])
@onready var price = str(cardInfo[3])

# Called when the node enters the scene tree for the first time.
func _ready():
	var cardSize = size
	$Border.scale *= cardSize/$Border.texture.get_size()
	$Card.texture = load(cardImage)
	$Card.scale *= cardSize/$Card.texture.get_size()
	$CardBack.scale *= cardSize/$CardBack.texture.get_size()
	$Focus.scale *= cardSize/$Focus.size
	$TextContainer/horizontal/PriceContainer/Price.text = price
	$TextContainer/horizontal/PurchasePowerContainer/PurchasePower.text = purchasePower
	
#	selected.connect($'../../'._on_card_selected)

signal selected

func _input(event):
	if event.is_action_pressed("leftclick"):
		emit_signal("selected", cardName)

func _on_focus_mouse_entered():
	$Focus.disabled = true

func _on_focus_mouse_exited():
	$Focus.disabled = false
