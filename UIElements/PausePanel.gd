extends PanelContainer



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if visible:
			_on_Button_pressed()
		else:
			get_tree().paused = true
			visible = true


func _on_Button_pressed() -> void:
	get_tree().paused = false
	visible = false
