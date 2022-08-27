extends Control

signal text_matched

const MATCHING_TEXT_COLOR: Color = Color(0.2, 0.9, 0.2, 1.0)
const DEFAULT_TEXT_COLOR: Color = Color(0.9, 0.9, 0.9, 1.0)
const SELF_MODULATE_HIDDEN: Color = Color(1.0, 1.0, 1.0, 0.0)
const SELF_MODULATE_VISIBLE: Color = Color(1.0, 1.0, 1.0, 1.0)


onready var rich_text_label: RichTextLabel = $RichTextLabel

var label_text: String = ""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _err = EventBus.connect("input_text_changed", self, "_on_EventBus_input_text_changed")
	_err = EventBus.connect("input_text_sent", self, "_on_EventBus_input_text_sent")
	
	get_new_word()

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		Corpus.release_word(label_text)


func _on_EventBus_input_text_changed(new_text: String) -> void:
	if new_text == "" || !label_text.begins_with(new_text):
		rich_text_label.bbcode_text = "[center][color=#" + DEFAULT_TEXT_COLOR.to_html(false) + "]" + label_text + "[/color]"
	else:
		rich_text_label.bbcode_text = "[center][color=#" + MATCHING_TEXT_COLOR.to_html(false) + "]" + new_text + "[/color]" \
			+ "[color=#" + DEFAULT_TEXT_COLOR.to_html(false) + "]" + label_text.substr(new_text.length()) + "[/color]"

func _on_EventBus_input_text_sent(sent_text: String) -> void:
	if sent_text == label_text:
		modulate = SELF_MODULATE_HIDDEN
		emit_signal("text_matched")
		Corpus.release_word(sent_text)
	else:
		_on_EventBus_input_text_changed("")


func get_new_word() -> void:
	label_text = Corpus.lock_word(4)
	_on_EventBus_input_text_changed("")


func deselect() -> void:
	modulate = SELF_MODULATE_VISIBLE
	get_new_word()
