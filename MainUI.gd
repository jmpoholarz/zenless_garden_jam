extends Control

onready var carrot_seeds = $MarginContainer/VBoxContainer/HBoxContainer/SeedPanel/VBoxContainer/InventoryCrop
onready var turnip_seeds = $MarginContainer/VBoxContainer/HBoxContainer/SeedPanel/VBoxContainer/InventoryCrop2
onready var pumpkin_seeds = $MarginContainer/VBoxContainer/HBoxContainer/SeedPanel/VBoxContainer/InventoryCrop3

onready var shovel_tool = $MarginContainer/VBoxContainer/HBoxContainer/ToolPanel/HBoxContainer/InventoryTool
onready var watering_can = $MarginContainer/VBoxContainer/HBoxContainer/ToolPanel/HBoxContainer/InventoryTool2
onready var weeding_fork = $MarginContainer/VBoxContainer/HBoxContainer/ToolPanel/HBoxContainer/InventoryTool4

onready var customer_window = $MarginContainer/VBoxContainer/HBoxContainer/CustomerWindow

onready var title_label = $TitleLabel
onready var tip1 = $TutSeed1
onready var tip2 = $TutSeed2
onready var tip3 = $TutSeed3
onready var tip4 = $TutSeed4
onready var tip5 = $TutSeed5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _err = EventBus.connect("tutorial_seeds_picked", self, "hide_seed_tip")
	_err = EventBus.connect("tutorial_seeds_planted", self, "hide_soil_tip")
	_err = EventBus.connect("tutorial_customer_served", self, "update_customers")
	_err = EventBus.connect("tutorial_tool_needed", self, "show_tool_tip")
	_err = EventBus.connect("flag_first_tool_used", self, "hide_tool_tip")
	_err = EventBus.connect("flag_first_turnip", self, "enable_turnips")
	_err = EventBus.connect("flag_first_pumpkin", self, "enable_pumpkins")
	_err = EventBus.connect("flag_first_watering", self, "enable_watering_can")
	_err = EventBus.connect("flag_first_weeds", self, "enable_weeding_fork")
	_err = EventBus.connect("flag_first_shovel", self, "enable_shovel")
	
	_err = $Timer.connect("timeout", self, "hide_title")
	
	$Tween.interpolate_property(title_label, "modulate", Color(1,1,1,0), Color(1,1,1,1),
			2.0, Tween.TRANS_CUBIC)
	$Tween.start()
	title_label.visible = true

func hide_title() -> void:
	$Tween.interpolate_property(title_label, "modulate", Color(1,1,1,1), Color(1,1,1,0),
			2.0, Tween.TRANS_CUBIC)
	$Tween.start()
	yield(get_tree().create_timer(2.0), "timeout")
	enable_carrots()

func enable_carrots() -> void:
	$Tween.interpolate_property(carrot_seeds, "modulate", Color(1,1,1,0), Color(1,1,1,1),
			1.0, Tween.TRANS_CUBIC)
	$Tween.interpolate_property(tip1, "modulate", Color(1,1,1,0), Color(1,1,1,1),
			1.0, Tween.TRANS_CUBIC)
	$Tween.start()
	carrot_seeds.visible = true
	tip1.visible = true

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

func show_tool_tip() -> void:
	if tip4.visible == true:
		return
	tip4.visible = true
	$Tween.interpolate_property(tip4, "modulate", Color(1,1,1,0), Color(1,1,1,1),
			1.0, Tween.TRANS_CUBIC)
	$Tween.start()


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
	$Tween.start()
	customer_window.start_customers()

func hide_request_tip() -> void:
	$Tween.interpolate_property(tip3, "modulate", Color(1,1,1,1), Color(1,1,1,0),
			1.0, Tween.TRANS_CUBIC)
	$Tween.start()

func hide_tool_tip() -> void:
	$Tween.interpolate_property(tip4, "modulate", Color(1,1,1,1), Color(1,1,1,0),
			1.0, Tween.TRANS_CUBIC)
	$Tween.interpolate_property(tip3, "modulate", Color(1,1,1,0), Color(1,1,1,1),
			1.0, Tween.TRANS_CUBIC)
	$Tween.start()
	tip3.visible = true
	yield(get_tree().create_timer(20.0), "timeout")
	hide_request_tip()

func hide_fertilizer_tip() -> void:
	pass


func update_customers(value) -> void:
	var customer_label = $PanelContainer/TotalCustomerLabel
	if customer_label.visible == false:
		$Tween.interpolate_property(customer_label, "modulate", Color(1,1,1,0), Color(1,1,1,1),
			1.0, Tween.TRANS_CUBIC)
		$Tween.start()
		customer_label.visible = true
	match value:
		1: $PanelContainer/TotalCustomerLabel.text = "1 Order Completed."
		_: $PanelContainer/TotalCustomerLabel.text = str(value) + " Orders Completed."
