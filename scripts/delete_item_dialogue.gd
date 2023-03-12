extends Control

var item_node = Object
var prompt = ""
var state = 0
@onready var head_label = $VBoxContainer/Control/ColorRect/Label

func _ready():
	head_label.text = prompt

func _on_confirm_pressed():
	if state == 1:
		item_node.remove_from_group("Persist")
		item_node.queue_free()
		get_tree().current_scene.save()
		queue_free()
	elif state == 2:
		item_node.clear()
	queue_free()

func _on_disprove_pressed():
	queue_free()
