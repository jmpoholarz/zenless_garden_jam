
class_name InventoryIcon
extends Control

const THEME_BLUE = 0
const THEME_GREEN = 1
const THEME_RED = 2

var blue_theme: Theme = preload("res://UsedAssets/blue_theme.tres")
var green_theme: Theme = preload("res://UsedAssets/green_theme.tres")
var red_theme: Theme = preload("res://UsedAssets/red_theme.tres")

var button_group: ButtonGroup = preload("res://UIElements/ButtonGroup.tres")

onready var button: Button = $Button
onready var object_label: Control = $ObjectLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _err = object_label.connect("text_matched", self, "_on_ObjectLabel_text_matched")
	_err = button.connect("button_up", self, "_on_Button_button_up")
	
	button.group = button_group


func _on_ObjectLabel_text_matched() -> void:
	if button.pressed == true:
		return
	for b in button.group.get_buttons():
		if b.pressed == true:
			b.pressed = false
			b.emit_signal("button_up")
	button.pressed = true

func _on_Button_button_up() -> void:
	object_label.deselect()
	theme = blue_theme
