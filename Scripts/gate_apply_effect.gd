extends GPUParticles2D

@export var cardName = 'Identity'

@onready var cardDB = preload("res://Scripts/CardDB.gd")
@onready var symbolImage = str("res://Assets/Cards/Symbols/", "/Symbol", cardName, ".png")

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = load(symbolImage)

func setImage(name):
	cardName = name
	symbolImage = str("res://Assets/Cards/Symbols/", "/Symbol", cardName, ".png")
	texture = load(symbolImage)

func play():
	$AnimationPlayer.play("apply")
