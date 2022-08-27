extends Control


onready var turnip_seeds = $MarginContainer/VBoxContainer/HBoxContainer/SeedPanel/VBoxContainer/InventoryCrop2
onready var pumpkin_seeds = $MarginContainer/VBoxContainer/HBoxContainer/SeedPanel/VBoxContainer/InventoryCrop3

onready var shovel_tool = $MarginContainer/VBoxContainer/HBoxContainer/ToolPanel/HBoxContainer/InventoryTool
onready var watering_can = $MarginContainer/VBoxContainer/HBoxContainer/ToolPanel/HBoxContainer/InventoryTool2
onready var weeding_fork = $MarginContainer/VBoxContainer/HBoxContainer/ToolPanel/HBoxContainer/InventoryTool4

onready var tip1 = $TutSeed1
onready var tip2 = $TutSeed2
onready var tip3 = $TutSeed3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _err = EventBus.connect("tutorial_seeds_picked", self, "hide_seed_tip")
	_err = EventBus.connect("tutorial_seeds_planted", self, "hide_soil_tip")
	_err = EventBus.connect("tutorial_customer_served", self, "hide_request_tip")
	_err = EventBus.connect("flag_first_turnip", self, "enable_turnips")
	_err = EventBus.connect("flag_first_pumpkin", self, "enable_pumpkins")
	_err = EventBus.connect("flag_first_watering", self, "enable_watering_can")
	_err = EventBus.connect("flag_first_weeds", self, "enable_weeding_fork")
	_err = EventBus.connect("flag_first_shovel", self, "enable_shovel")


func enable_turnips() -> void:
	$Tween.interpolate_property(turnip_seeds, "modulate", Color(1,1,1,0), Color(1,1,1,1),
			1.0, Tween.TRANS_CUBIC)
	$Tween.start()
	turnip_seeds.visible = true

func enable_pumpkins() -> void:
	$Tween.interpolate_property(pumpkin_seeds, "modulate", Color(1,1,1,0), Color(1,1,1,1),
			1.0, Tween.TRANS_CUBIC)
	$Tween.start()
	pumpkin_seeds.visible = true

func enable_shovel() -> void:
	$Tween.interpolate_property(shovel_tool, "modulate", Color(1,1,1,0), Color(1,1,1,1),
			1.0, Tween.TRANS_CUBIC)
	$Tween.start()
	shovel_tool.visible = true

func enable_watering_can() -> void:
	$Tween.interpolate_property(watering_can, "modulate", Color(1,1,1,0), Color(1,1,1,1),
			1.0, Tween.TRANS_CUBIC)
	$Tween.start()
	watering_can.visible = true

func enable_weeding_fork() -> void:
	$Tween.interpolate_property(weeding_fork, "modulate", Color(1,1,1,0), Color(1,1,1,1),
			1.0, Tween.TRANS_CUBIC)
	$Tween.start()
	weeding_fork.visible = true


func hide_seed_tip() -> void:
	$Tween.interpolate_property(tip1, "modulate", Color(1,1,1,1), Color(1,1,1,0),
			1.0, Tween.TRANS_CUBIC)
	$Tween.interpolate_property(tip2, "modulate", Color(1,1,1,0), Color(1,1,1,1),
			1.0, Tween.TRANS_CUBIC)
	$Tween.start()
	tip2.visible = true

func hide_soil_tip() -> void:
	$Tween.interpolate_property(tip2, "modulate", Color(1,1,1,1), Color(1,1,1,0),
			1.0, Tween.TRANS_CUBIC)
	$Tween.interpolate_property(tip3, "modulate", Color(1,1,1,0), Color(1,1,1,1),
			1.0, Tween.TRANS_CUBIC)
	$Tween.start()
	tip3.visible = true

func hide_request_tip() -> void:
	$Tween.interpolate_property(tip3, "modulate", Color(1,1,1,1), Color(1,1,1,0),
			1.0, Tween.TRANS_CUBIC)
	$Tween.start()
