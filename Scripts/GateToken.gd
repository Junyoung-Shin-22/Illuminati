extends Control

var identity_sprite = preload("res://Assets/Cards/Symbols/SymbolIdentity.png")
var not_sprite = preload("res://Assets/Cards/Symbols/SymbolNot.png")
var hadamard_sprite = preload("res://Assets/Cards/Symbols/SymbolHadamard.png")
var conditional_sprite = preload("res://Assets/Cards/Symbols/SymbolConditional.png")
var not_conditional_sprite = preload("res://Assets/Cards/Symbols/SymbolNotConditional.png")
var Swap_sprite = preload("res://Assets/Cards/Symbols/SymbolSwap.png")
var observe_sprite = preload("res://Assets/Cards/Symbols/SymbolObserve.png")
var empty_sprite = preload("res://Assets/Cards/Symbols/SymbolEmpty.png")

func change_type(gateName):
	match gateName:
		"Identity":
			$Sprite2D.set_texture(identity_sprite)
		"Not":
			$Sprite2D.set_texture(not_sprite)
		"Hadamard":
			$Sprite2D.set_texture(hadamard_sprite)
		"Conditional":
			$Sprite2D.set_texture(conditional_sprite)
		"NotConditional":
			$Sprite2D.set_texture(not_conditional_sprite)
		"Swap":
			$Sprite2D.set_texture(Swap_sprite)
		"Observe":
			$Sprite2D.set_texture(observe_sprite)
		"Empty":
			$Sprite2D.set_texture(empty_sprite)
