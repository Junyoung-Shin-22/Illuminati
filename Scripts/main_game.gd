extends Node2D

#Phase 시작 시, shopsprite 및 currentphase initialize 해줄 것.


# state that a card can have
enum {InHand, MovingToDumped, Dumped, InMouse, FocusInHand, MoveDrawnCardToHand, ReOrganizeHand}

# phase enum
enum {DrawPhase, PurchasePhase, ActionPhase, EndPhase}

var cardBase = preload("res://Scenes/CardBase.tscn")
# initial Deck for each player. To be edited for game balance
var Deck = []

var currentRound = 1
var currentPhase = DrawPhase

# list of cards in hand
var Hand = []

# list of used cards
var DumpedCards = []

# oppenent used cards
var EnemyDumpedCards = []

# will maintain information of gates as (gate, gate_owner)
# gate owner 0, 1 will indicate each player
# gate owner 2 is owned to noone
var applied_gates = {
	0:[],
	1:[],
	2:[],
	3:[],
	4:[],
	5:[],
	6:[],
	7:[],
	8:[],
	9:[]
}


@onready var socket = AutoloadSocket.global_socket
@onready var my_player_index = AutoloadSocket.my_player_index
@onready var my_ip = AutoloadSocket.my_ip
var my_player_color

func _ready():
	var lamps = $Rotary/Lamps.get_children()
	if my_player_index == 1:
		my_player_color = "red"
	else:
		my_player_color = "blue"
	$Label.text = "you are " + my_player_color + '\n' + "turn: " + str(currentRound)
	for i in range(len(lamps)):
		var lamp_light = lamps[i].get_child(0)
		if i % 2 == 0:
			lamp_light.color.r = 1
			lamp_light.color.g = 0
			lamp_light.color.b = 0
		else:
			lamp_light.color.r = 0
			lamp_light.color.g = 0
			lamp_light.color.b = 1
	
	var to_add_to_deck = [
		"Identity", 
		"Identity",
		"Identity",
		"Not",
		"Not",
		"Hadamard",
		"Bronze",
		"Bronze",
		"Bronze",
		"Bronze",
	]
	for name in to_add_to_deck:
		var new_card = cardBase.instantiate()
		new_card.initialize(name)
		Deck.push_back(new_card)
	
	if my_player_index == 2:
		currentPhase = EndPhase
		end_sent = true	
	
var end_sent = false

func _process(delta):
	_process_socket()
	
	if currentPhase == EndPhase:
		if not end_sent:
			socket.send_text(my_ip + " end_turn")
			end_sent = true
		$Waiting.visible = true
##		
	else:
		$Waiting.visible = false

func _process_socket():
	socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var packet = socket.get_packet()
			_process_packet(packet)

func _process_packet(packet):
	var data = packet.get_string_from_utf8()
	var args = data.split(" ")
	print(args)
	
	if args[0] == "end_turn":
		if int(args[2]) != my_player_index:
			currentPhase = DrawPhase
			end_sent = false
	
	if args[0] == "current_turn":
		currentRound = int(args[1])

func game_end():
	applied_gates
	#확률 계산...
	pass

# variable to store the index of the card in deck. 
var cardSelected = null
func drawCard():
	if currentPhase != DrawPhase:
		return
	if len(Deck) <= 0:
		return
	
	if currentRound==1:
		if len(Hand)>=7:
			currentPhase = PurchasePhase
			return
	elif len(Hand) >= 5:
		currentPhase = PurchasePhase
		return
	
	var card = Deck.pop_at(randi_range(0, len(Deck)-1))
	
	Hand.push_back(card)
	$Cards.add_child(card)
	card.scale = Vector2(1, 1) * 100/250
	card.position.x += ($Cards.get_child_count()-1) * 100
	
	organize_hand()
	
	if len(Deck) == 0:
		deck_refill()
		
	

func organize_hand():
	var idx = 0
	for card in Hand:
		card.position.x = $Cards.global_position.x - 300 + idx * 100
		idx += 1

func _on_back_pressed():
	drawCard()

func deck_refill():
	for card in DumpedCards:
		print(card.cardName)
		Deck.append(card)
	DumpedCards = []

func _on_shop_button_pressed():
	if currentPhase == ActionPhase or currentPhase == EndPhase:
		return
	$Shop.visible = true

func _on_my_discard_button_pressed():
	var grid = $MyDiscarded/MarginContainer/GridContainer
	for child in grid.get_children():
		grid.remove_child(child)
	for card in DumpedCards:
		var sprite = card.get_child(0).duplicate()
		sprite.scale = Vector2.ONE * 0.4
		grid.add_child(sprite)
		sprite.position.x += ((grid.get_child_count()-1) % 6) * 100
		sprite.position.y += floor((grid.get_child_count()-1) / 6) * 140
	$MyDiscarded.visible = true

func _on_button_pressed():
	$StateTable.visible = true

func apply_gate(lamp):
	var selected_gate = $'Cards'.selected_child
	if not selected_gate: 
		return
	
	if currentPhase == EndPhase:
		return
	
	# apply gate to lamp
	applied_gates[int(str(lamp.name))].append(selected_gate.cardName)
	
	selected_gate.shader_off()
	Hand.erase(selected_gate)
	DumpedCards.append(selected_gate)
	$'Cards'.remove_child(selected_gate)
	
	organize_hand()
#	print(applied_gates[int(str(lamp.name))])
	$shop_sprite/Label.visible = false
	$shop_sprite/PointLight2D.visible = false
	currentPhase = EndPhase


func _on_end_phase_pressed():
	if currentPhase == EndPhase : return
	$shop_sprite/Label.visible = false
	$shop_sprite/PointLight2D.visible = false
	currentPhase = EndPhase
	
