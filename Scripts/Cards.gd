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

signal selected_cards_updated

var selected_child = null
var selected_children = []

func _ready():
	connect("selected_cards_updated", $"../Shop".update_money_label)

func _on_select(card):
	# ControlPhase means that control gate was already appied to some lamp
	if $"..".currentPhase == $"..".ControlPhase:
		if card.cardName == "Identity" or card.cardName == "Not" or card.cardName == "Hadamard" : 
			pass
		else:
			return
			
	if $"..".currentPhase == $"..".SwapPhase:	
		return
	var shop_open = $'../Shop'.visible
	if shop_open:
		if CARDS[card.cardName][0] != "Money": return
		if card in selected_children : 
			card.shader_off()
			var idx = selected_children.find(card)
			selected_children.pop_at(idx)
			selected_cards_updated.emit()
			return
		else:
			card.shader_on()
			selected_children.append(card)
			selected_cards_updated.emit()
	else:
		if CARDS[card.cardName][0] != "Gate" : return

		if selected_child: 
			if card == selected_child:
				card.shader_off()
				selected_child = null
				return
			selected_child.shader_off()
			card.shader_on()
			selected_child = card
		card.shader_on()
		selected_child = card
#		print(selected_child)


func _on_shop_button_pressed():
	for cards in get_children():
		cards.shader_off()
	selected_child = null
	selected_children = []
	selected_cards_updated.emit()
