extends Node2D

signal selected

@export var is_yourturn = true

func _ready():
	selected.connect($'../../../'.apply_gate)
	$PointLight2D.energy = 8
	$GPUParticles2D.emitting = false

func _on_area_2d_mouse_entered():
	if is_yourturn:
		$PointLight2D.energy = 16

func _on_area_2d_mouse_exited():
	$PointLight2D.energy = 8

func _on_button_pressed():
	if is_yourturn:
		selected.emit(self)

func set_effect_image(name):
	$GPUParticles2D.setImage(name)

func play():
	$GPUParticles2D.play()
