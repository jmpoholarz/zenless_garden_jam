extends TextureRect


var shovel_icon = preload("res://UsedAssets/ui_icons/genericItem_color_022.png")
var watering_can_icon = preload("res://UsedAssets/ui_icons/genericItem_color_125.png")
var fertilizer_icon = preload("res://UsedAssets/ui_icons/genericItem_color_108.png")
var weeding_fork_icon = preload("res://UsedAssets/ui_icons/genericItem_color_006.png")

var carrot_icon = preload("res://UsedAssets/ui_icons/crop_carrot.png")
var turnip_icon = preload("res://UsedAssets/ui_icons/crop_turnip.png")
var pumpkin_icon = preload("res://UsedAssets/ui_icons/crop_pumpkin.png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _err = EventBus.connect("active_tool_changed", self, "_on_EventBus_active_tool_changed")


func _on_EventBus_active_tool_changed(tool_id: int) -> void:
	match tool_id:
		GameState.TOOL_SHOVEL:
			texture = shovel_icon
		GameState.TOOL_WATERING_CAN:
			texture = watering_can_icon
		GameState.TOOL_FERTILIZER:
			texture = fertilizer_icon
		GameState.TOOL_WEEDING_FORK:
			texture = weeding_fork_icon
		
		GameState.SEED_CARROT:
			texture = carrot_icon
		GameState.SEED_TURNIP:
			texture = turnip_icon
		GameState.SEED_PUMPKIN:
			texture = pumpkin_icon
		
		_:
			texture = null
