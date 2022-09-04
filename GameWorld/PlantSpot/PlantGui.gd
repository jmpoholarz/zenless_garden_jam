extends ColorRect

signal text_matched

onready var health_container: Control = $MarginContainer/VBoxContainer/HBoxContainer3/VBoxContainer/HBoxContainer
onready var size_container: Control = $MarginContainer/VBoxContainer/HBoxContainer3
onready var health_bar: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer3/VBoxContainer/HBoxContainer/HealthBar
#onready var size_bar: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer2/SizeBar
onready var size_icon: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer3/VBoxContainer/GrowthIcon
onready var status_icon_panel: Panel = $MarginContainer/VBoxContainer/Panel
onready var status_icon: TextureRect = $MarginContainer/VBoxContainer/Panel/StatusIcon
onready var object_label: Control = $MarginContainer/VBoxContainer/ObjectLabel
onready var crop_icon: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer3/CropIcon
onready var anim_player: AnimationPlayer = $AnimationPlayer

const GUI_VISIBLE_COLOR_CLEAR = Color(0.0, 0.0, 0.0, 0.24)
const GUI_VISIBLE_COLOR_GREEN = Color(0.0, 1.0, 0.0, 0.24)
const GUI_VISIBLE_COLOR_RED = Color(1.0, 0.0, 0.0, 0.24)
const GUI_NOT_VISIBLE_COLOR = Color(0.0, 0.0, 0.0, 0.0)

const MODULATE_WRONG_TOOL = Color(1.0, 1.0, 1.0, 0.33)
const MODULATE_RIGHT_TOOL = Color(1.0, 1.0, 1.0, 1.0)

const THEME_BLUE = 0
const THEME_GREEN = 1
const THEME_RED = 2

var blue_theme: Theme = preload("res://UsedAssets/blue_theme.tres")
var green_theme: Theme = preload("res://UsedAssets/green_theme.tres")
var red_theme: Theme = preload("res://UsedAssets/red_theme.tres")

var carrot_icon = preload("res://UsedAssets/ui_icons/crop_carrot.png")
var turnip_icon = preload("res://UsedAssets/ui_icons/crop_turnip.png")
var pumpkin_icon = preload("res://UsedAssets/ui_icons/crop_pumpkin.png")

var shovel_icon = preload("res://UsedAssets/ui_icons/genericItem_color_022.png")
var watering_can_icon = preload("res://UsedAssets/ui_icons/genericItem_color_125.png")
var fertilizer_icon = preload("res://UsedAssets/ui_icons/genericItem_color_108.png")
var weeding_fork_icon = preload("res://UsedAssets/ui_icons/genericItem_color_006.png")

var grow_icon_0 = preload("res://UsedAssets/ui_icons/timer_0.png")
var grow_icon_25 = preload("res://UsedAssets/ui_icons/timer_CCW_25.png")
var grow_icon_50 = preload("res://UsedAssets/ui_icons/timer_CCW_50.png")
var grow_icon_75 = preload("res://UsedAssets/ui_icons/timer_CCW_75.png")
var grow_icon_100 = preload("res://UsedAssets/ui_icons/timer_100.png")

const PLANT_REQUEST_NONE = 0
const PLANT_REQUEST_WATER = 1
const PLANT_REQUEST_FERTILIZER = 2
const PLANT_REQUEST_SHOVEL = 3
const PLANT_REQUEST_WEEDS = 4
const PLANT_REQUEST_HARVEST = 5

var active_quest: int = PLANT_REQUEST_NONE
var status_bars_active: bool = false


func set_crop_type(id: int) -> void:
	match id:
		GameState.SEED_CARROT:
			crop_icon.texture = carrot_icon
		GameState.SEED_TURNIP:
			crop_icon.texture = turnip_icon
		GameState.SEED_PUMPKIN:
			crop_icon.texture = pumpkin_icon


func set_plant_health(value: float) -> void:
	if value > health_bar.value:# && anim_player.is_playing():
		anim_player.stop()
		anim_player.play("RESET")
	
	elif value < 15:
		anim_player.play("blink_health_bar", -1, 2.0)
	elif value < 35:
		anim_player.play("blink_health_bar", -1, 1.0)
	
	health_bar.value = value

func set_plant_size(value: float) -> void:
	#size_bar.value = value
	if value >= 100.0:
		size_icon.texture = grow_icon_100
	elif value > 75.0:
		size_icon.texture = grow_icon_75
	elif value > 50.0:
		size_icon.texture = grow_icon_50
	elif value > 25.0:
		size_icon.texture = grow_icon_25
	else:
		size_icon.texture = grow_icon_0

func set_active_quest(value: int) -> void:
	status_icon_panel.modulate = Color(1,1,1,1)
	active_quest = value
	match value:
		PLANT_REQUEST_WATER:
			status_icon.texture = watering_can_icon
		PLANT_REQUEST_SHOVEL:
			status_icon.texture = shovel_icon
		PLANT_REQUEST_WEEDS:
			status_icon.texture = weeding_fork_icon
		_:
			status_icon.texture = null
			status_icon_panel.modulate = Color(1,1,1,0)
			if anim_player.is_playing():
				anim_player.play("RESET")
	update_textbox_opacity(GameState.get_active_tool())


func set_gui_theme(theme_id) -> void:
	match theme_id:
		THEME_GREEN:
			theme = green_theme
			color = GUI_VISIBLE_COLOR_GREEN
		THEME_BLUE:
			theme = blue_theme
		THEME_RED:
			theme = red_theme
			color = GUI_VISIBLE_COLOR_RED


func show_status_bars() -> void:
	status_bars_active = true
	health_container.visible = true
	size_container.visible = true
	color = GUI_VISIBLE_COLOR_CLEAR
	update_textbox_opacity(GameState.get_active_tool())


func hide_status_bars() -> void:
	status_bars_active = false
	health_container.visible = false
	size_container.visible = false
	color = GUI_NOT_VISIBLE_COLOR
	update_textbox_opacity(GameState.get_active_tool())


func update_textbox_opacity(tool_id: int) -> void:
	if tool_id == GameState.TOOL_SHOVEL:
		if active_quest == PLANT_REQUEST_SHOVEL:
			object_label.modulate = MODULATE_RIGHT_TOOL
			object_label.set_match_text_color_right_tool(true)
			return
		elif active_quest == PLANT_REQUEST_HARVEST:
			object_label.modulate = MODULATE_RIGHT_TOOL
			object_label.set_match_text_color_right_tool(true)
			return
		elif status_bars_active == false:
			# Empty plant spot
			object_label.modulate = MODULATE_WRONG_TOOL
			object_label.set_match_text_color_right_tool(false)
		else:
			object_label.modulate = MODULATE_RIGHT_TOOL
			object_label.set_match_text_color_right_tool(false)
			return
	elif tool_id == GameState.TOOL_WATERING_CAN:
		if active_quest == PLANT_REQUEST_WATER:
			object_label.modulate = MODULATE_RIGHT_TOOL
			object_label.set_match_text_color_right_tool(true)
			return
	elif tool_id == GameState.TOOL_WEEDING_FORK:
		if active_quest == PLANT_REQUEST_WEEDS:
			object_label.modulate = MODULATE_RIGHT_TOOL
			object_label.set_match_text_color_right_tool(true)
			return
	elif tool_id > GameState.CLASS_SEED:
		if active_quest == PLANT_REQUEST_NONE && status_bars_active == false:
			object_label.modulate = MODULATE_RIGHT_TOOL
			object_label.set_match_text_color_right_tool(true)
			return
		
	object_label.modulate = MODULATE_WRONG_TOOL
	object_label.set_match_text_color_right_tool(false)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _err = object_label.connect("text_matched", self, "_on_ObjectLabel_text_matched")
	_err = EventBus.connect("active_tool_changed", self, "_on_EventBus_active_tool_changed")
	
	hide_status_bars()


func _on_ObjectLabel_text_matched() -> void:
	emit_signal("text_matched")
	object_label.get_new_word()


func _on_EventBus_active_tool_changed(tool_id: int) -> void:
	# TODO: Change text color to red when using wrong tool
	update_textbox_opacity(tool_id)
