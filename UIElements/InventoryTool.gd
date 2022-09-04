
class_name InventoryTool
extends InventoryIcon


export(int) var tool_id = -1


const TOOL_SHOVEL = 1
const TOOL_WATERING_CAN = 2
const TOOL_FERTILIZER = 3
const TOOL_WEEDING_FORK = 4

var shovel_icon = preload("res://UsedAssets/ui_icons/genericItem_color_022.png")
var watering_can_icon = preload("res://UsedAssets/ui_icons/genericItem_color_125.png")
var fertilizer_icon = preload("res://UsedAssets/ui_icons/genericItem_color_108.png")
var weeding_fork_icon = preload("res://UsedAssets/ui_icons/genericItem_color_006.png")

onready var texture_rect = $Button/TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_tool_id_changed(tool_id)
	


func _on_tool_id_changed(value) -> void:
	if !texture_rect: return
	tool_id = value
	match tool_id:
		TOOL_SHOVEL:
			texture_rect.texture = shovel_icon
		TOOL_WATERING_CAN:
			texture_rect.texture = watering_can_icon
		TOOL_FERTILIZER:
			texture_rect.texture = fertilizer_icon
		TOOL_WEEDING_FORK:
			texture_rect.texture = weeding_fork_icon


func _on_ObjectLabel_text_matched() -> void:
	._on_ObjectLabel_text_matched()
	GameState.set_active_tool(GameState.CLASS_TOOL + tool_id)
	theme = green_theme
