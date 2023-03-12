extends Control

var save_path = "user://learnt_data.csv"
@onready var items_list = $MarginContainer/VBoxContainer/Panel/MarginContainer/chat_area/VBoxContainer
@onready var data_text = $MarginContainer/VBoxContainer/HBoxContainer/LineEdit
@onready var item = preload("res://item.tscn")
@onready var progress = preload("res://progress.tscn").instantiate()

func _ready():
	_load()

func _on_add_item_pressed():
	if data_text.text != null:
		var time = Time.get_datetime_dict_from_system()
		var new_item = item.instantiate()
		new_item.date = str("[",time["day"],"-",time["month"],"-",time["year"],"]")
		new_item.time = str("[",time["hour"],":",time["minute"],":",time["second"],"]")
		new_item.item_name = data_text.text
		data_text.text = ""
		items_list.add_child(new_item)
		save()

func save():
	var save_items = get_tree().get_nodes_in_group("Persist")
	var file = FileAccess.open(save_path,FileAccess.WRITE)
	if save_items != []:
		for items in save_items:
			var temp_str = []
			temp_str.append(items.date)
			temp_str.append(items.time)
			temp_str.append(items.item_name)
			file.store_csv_line(PackedStringArray(temp_str))
	else:
		file.store_csv_line(PackedStringArray())
	file.close()

func _load():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path,FileAccess.READ)
		if file is Object:
			var delete_items = get_tree().get_nodes_in_group("Persist")
			for items in delete_items:
				items.queue_free()
			while !file.eof_reached():
					var line = Array(file.get_csv_line())
					if line.size() > 1:
						var new_item = item.instantiate()
						new_item.date = line[0]
						new_item.time = line[1]
						new_item.item_name = line[2]
						items_list.add_child(new_item)
						#return 0
					else:
						#return 0
						pass
			file.close()
			#return 0
		else:
			#return 1
			pass
	else:
		var file = FileAccess.open(save_path,FileAccess.WRITE)
		file.close()
		#return 0

func dialogue():
	var dialoguef = preload("res://delete_item_dialogue.tscn").instantiate()
	dialoguef.item_node = self
	dialoguef.prompt = "Are you sure you want to clear your data?"
	dialoguef.state = 2
	get_tree().current_scene.add_child(dialoguef)

func clear():
	var group = get_tree().get_nodes_in_group("Persist")
	for items in group:
		items.remove_from_group("Persist")
		items.queue_free()
	save()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_on_add_item_pressed()
