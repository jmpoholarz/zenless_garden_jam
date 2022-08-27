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

const GUI_VISIBLE_COLOR = Color(0.0, 0.0, 0.0, 0.24)
const GUI_NOT_VISIBLE_COLOR = Color(0.0, 0.0, 0.0, 0.0)

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


func set_crop_type(id: int) -> void:
	match id:
		GameState.SEED_CARROT:
			crop_icon.texture = carrot_icon
		GameState.SEED_TURNIP:
			crop_icon.texture = turnip_icon
		GameState.SEED_PUMPKIN:
			crop_icon.texture = pumpkin_icon


func set_plant_health(value: float) -> void:
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


func show_status_bars() -> void:
	health_container.visible = true
	size_container.visible = true
	color = GUI_VISIBLE_COLOR


func hide_status_bars() -> void:
	health_container.visible = false
	size_container.visible = false
	color = GUI_NOT_VISIBLE_COLOR


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _err = object_label.connect("text_matched", self, "_on_ObjectLabel_text_matched")
	
	hide_status_bars()


func _on_ObjectLabel_text_matched() -> void:
	emit_signal("text_matched")
	object_label.deselect()
