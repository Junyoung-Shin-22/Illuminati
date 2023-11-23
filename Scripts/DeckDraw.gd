extends TextureButton

var deckSize = INF

signal deckEmpty

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = $'../../'.cardSize/size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _gui_input(event):
	if Input.is_action_just_released("leftclick"):
		if deckSize > 0:
			deckSize = $'../../'.drawCard()
			if deckSize == 0: 
				disabled = true
				deckEmpty.emit(deckSize) # deck is empty. enable shuffle for dumped cards


func _on_deck_dump_re_filled(dSize):
	$'../../'.deckSize = dSize
	deckSize = dSize
	print($'../../'.Deck)
	disabled = false
