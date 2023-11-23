extends Control

var num_soldout = 0
var Inventory = { # [type, name, purchase power, price, stock]
	"Identity" :
		["Gate", "Identity", 0, 1, 10], 
	"Not" :
		["Gate", "Not", 0, 2, 8], 
	"Hadamard" :
		["Gate", "Hadamard", 0, 3, 5], 
	"Conditional" :
		["Gate", "Conditional", 0, 5, 5], 
	"NotConditional" :
		["Gate", "NotConditional", 0, 5, 5], 
	"Swap" :
		["Gate", "Swap", 0, 8, 2], 
	"Observe" :
		["Gate", "Observe", 0, 10, 1], 
	"Bronze" :
		["Money", "Bronze", 1, 0, INF], 
	"Silver" :
		["Money", "Silver", 2, 3, INF], 
	"Gold" :
		["Money", "Gold", 3, 6, INF], 
}

signal shop_button_clicked(item)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("shop_button_clicked", handle_shop_button_clicked)
	update_stock_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_exit_button_pressed():
	clean_and_exit()

var selected_money = 0
var selected_item = null

func clean_and_exit():
	selected_money = 0
	selected_item = null
	$BackgroundText/Money.text = "money: 0"
	$BackgroundText/Price.text = "price: 0"
	visible = false

func update_money_label():
	var selected_money_cards = $"../Cards".selected_children
	selected_money = 0
	for i in range(len(selected_money_cards)):
		var card = selected_money_cards[i]
		selected_money += card.cardInfo[2]
	$BackgroundText/Money.text = "money: " + str(selected_money)

func update_stock_label():
	var gate_buttons = $GateButtons.get_children()
	for button in gate_buttons:
		var gate_name = button.name.substr(0, len(str(button.name))-6)
		var label = button.get_child(0)
		label.text = "x"+str(Inventory[gate_name][4])

func handle_shop_button_clicked(item):
	selected_item = item
	$BackgroundText/Price.text = "price: " + str(Inventory[item][3])


func _on_confirm_button_pressed():
	if selected_item == null:
		return
	if Inventory[selected_item][4] < 1:
		return
	if selected_money != Inventory[selected_item][3]:
		return
	
	# 잔고 처리 
	Inventory[selected_item][4] -= 1
	update_stock_label()
	
	# 재화 카드 사용
	for money_card in $'../Cards'.selected_children:
		money_card.shader_off()
		$'../Cards'.remove_child(money_card)
		$'../'.Hand.erase(money_card)
		$'../'.DumpedCards.append(money_card)
	
	# 아이템 겟또
	var new_card = $"../".cardBase.instantiate()
	new_card.initialize(selected_item)
	$'../'.DumpedCards.append(new_card)
	
	$'../'.organize_hand()
	
	clean_and_exit()
	
	$'../'.currentPhase = 2 # 2 = ActionPhase
	$'../shop_sprite/Label'.visible = false
	$'../shop_sprite/PointLight2D'.visible = false
	

func _on_gold_button_pressed():
	shop_button_clicked.emit("Gold")
func _on_silver_button_pressed():
	shop_button_clicked.emit("Silver")
func _on_bronze_button_pressed():
	shop_button_clicked.emit("Bronze")
func _on_swap_button_pressed():
	shop_button_clicked.emit("Swap")
func _on_not_conditional_button_pressed():
	shop_button_clicked.emit("NotConditional")
func _on_observe_button_pressed():
	shop_button_clicked.emit("Observe")
func _on_conditional_button_pressed():
	shop_button_clicked.emit("Conditional")
func _on_hadamard_button_pressed():
	shop_button_clicked.emit("Hadamard")
func _on_not_button_pressed():
	shop_button_clicked.emit("Not")
func _on_identity_button_pressed():
	shop_button_clicked.emit("Identity")
