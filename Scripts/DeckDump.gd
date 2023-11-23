extends TextureButton

var deckEmpty = false
var dumpedNotEmpty = false
signal reFilled

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = $'../../'.cardSize/size
	disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _gui_input(event):
	if Input.is_action_just_released("leftclick"):
		if deckEmpty:
			var count = 0
			for cardname in $'../../'.DumpedCards:
				$'../../'.Deck.append(cardname)
				count += 1
			$'../../'.DumpedCards = []
			reFilled.emit(count)
			deckEmpty = false
			disabled = true


func _on_deck_draw_deck_empty(dsize):
	if dsize == 0:
		deckEmpty = true
		disabled = false
