extends Node2D

var root_scene = preload("res://Scenes/root.tscn")
var main_game_scene = preload("res://Scenes/main_game.tscn")

var cursor_pos
var cursor_sprite

var ip_text_edit
var port_text_edit

var socket
var join_flag = false
var leave_flag = false
var my_ip
# Called when the node enters the scene tree for the first time.
func _ready():
	ip_text_edit = $LabelControl/IPTextEdit
	port_text_edit = $LabelControl/PortTextEdit
	cursor_sprite = $CursorSprite
	
	socket = WebSocketPeer.new()
	my_ip = IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_process_socket()    
	cursor_pos = get_viewport().get_mouse_position()

	cursor_sprite.position.x = cursor_pos.x
	cursor_sprite.position.y = cursor_pos.y

func _process_socket():
	socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		if not join_flag:
			join_flag = true
			socket.send_text(my_ip + " connect")
		
		while socket.get_available_packet_count():
			var packet = socket.get_packet()
			_process_packet(packet)
			
	if leave_flag:
		if state == WebSocketPeer.STATE_OPEN:
			socket.send_text(my_ip + " disconnect")
			socket.close(-1)
		elif state != WebSocketPeer.STATE_CLOSING:
			get_tree().change_scene_to_packed(root_scene)

func _process_packet(packet):
	var data = packet.get_string_from_utf8()
	var args = data.split(" ")
	print(args)
	
	if args[0] == "player":
		AutoloadSocket.my_player_index = int(args[1])
	
	if args[0] == "game_start":
		AutoloadSocket.global_socket = socket
		AutoloadSocket.my_ip = my_ip
		get_tree().change_scene_to_packed(main_game_scene)

func _on_back_button_pressed():
	leave_flag = true

func _on_join_button_pressed():
	var ip = ip_text_edit.text
	var port = port_text_edit.text
	
	var url = "ws://" + ip + ":" + port
	var err = socket.connect_to_url(url)
	if err != 0:
		return
