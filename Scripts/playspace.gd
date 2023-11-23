extends Node2D

const cardSize = Vector2(125, 175)
const cardBase = preload("res://Scenes/CardBase.tscn")

var Deck = [
	"Identity", 
	"Hadamard",
	"Conditional",
	"NotConditional",
	"Not",
	"Swap",
	"Observe",
	"Bronze",
	"Silver",
	"Gold"
]

var Hand = []

var DumpedCards = []

var cardSelected = null
@onready var deckSize = Deck.size()
@onready var centreCardOval = Vector2(get_viewport().size) * Vector2(0.53, 1.3)
@onready var horRad = get_viewport().size.x * 0.45
@onready var verRad = get_viewport().size.y * 0.4
var angle = 0
var cardSpace = 0.25
var handCardNum = 0
var cardNum = 0
var ovalAngleVector = Vector2()

enum {InHand, InPlay, InMouse, FocusInHand, MoveDrawnCardToHand, ReOrganizeHand}

func drawCard():
	angle = PI/2 + cardSpace * (float(handCardNum)/2 - handCardNum)
	var newCard = cardBase.instantiate()
	cardSelected = randi()%deckSize
	ovalAngleVector = Vector2(horRad * cos(angle), - verRad * sin(angle))
	newCard.cardName = Deck[cardSelected]
	newCard.startPos = $Deck/DeckDraw.position
	newCard.targetPos = centreCardOval + ovalAngleVector - newCard.size/2
	newCard.defaultPos = newCard.targetPos
	newCard.startRot = 0
	newCard.targetRot = (90 - rad_to_deg(angle))/4
	newCard.origRot = newCard.targetRot
	newCard.scale *= cardSize/newCard.size
	newCard.pivot_offset = Vector2(0,0)
	newCard.state = MoveDrawnCardToHand
	newCard.cardNum = handCardNum
	
	cardNum = 0
	for card in $Cards.get_children(): # reorganize cards
		angle = PI/2 + cardSpace * (float(handCardNum)/2 - cardNum)
		ovalAngleVector = Vector2(horRad * cos(angle), - verRad * sin(angle))
		
		card.startPos = card.position
		card.targetPos = centreCardOval + ovalAngleVector - cardSize
		card.defaultPos = card.targetPos
		card.startRot = card.rotation_degrees
		card.targetRot = (90 - rad_to_deg(angle))/4
		card.origRot = card.targetRot
		card.cardNum = cardNum
		
		cardNum += 1
		if card.state == InHand:
			card.state = ReOrganizeHand
			card.startPos = card.position
		elif card.state == MoveDrawnCardToHand:
			card.startPos = card.targetPos - (card.targetPos - card.position)/(1-card.t)
			
	$Cards.add_child(newCard)
	Deck.remove_at(cardSelected)
	Hand.insert(0, newCard.cardName)
	print(Hand)
	angle += 0.2
	deckSize -= 1
	handCardNum += 1
	return deckSize
