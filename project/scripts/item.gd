extends HBoxContainer

var date = ""
var time = ""
var item_name = ""

func _ready():
	$date.text = date
	$time.text = time
	$item_name.text = item_name

func serialize():
	var save_data = {
		"date":get_node("date").text,
		"item_name":get_node("item_name").text
	}
	return save_data


func _on_delete_pressed():
	var dialogue = preload("res://delete_item_dialogue.tscn").instantiate()
	dialogue.item_node = self
	dialogue.prompt = "Are you sure you want to delete this Item"
	dialogue.state = 1
	get_tree().current_scene.add_child(dialogue)
