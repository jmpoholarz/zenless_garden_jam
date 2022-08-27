extends LineEdit





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _err = connect("text_changed", self, "_on_text_changed")
	_err = connect("text_entered", self, "send_word")
	
	grab_focus()

func _process(_delta: float) -> void:
	if !GameState.is_in_menu():
		grab_focus()


func _on_text_changed(new_text: String) -> void:
	# Check if last character was a space, if so, submit the word
	#print(new_text)
	if new_text.ends_with(" "):
		
		send_word(new_text.substr(0, new_text.length() - 1))
		return
	EventBus.emit_signal("input_text_changed", new_text)


func send_word(new_text: String) -> void:
	#print("sending word: " + new_text)
	EventBus.emit_signal("input_text_sent", new_text)
	text = ""
