
class_name InventoryCrop
extends InventoryIcon


export(int) var crop_id = -1


const CROP_CARROT = 1
const CROP_TURNIP = 2
const CROP_PUMPKIN = 3


var carrot_icon = preload("res://UsedAssets/ui_icons/seeds_carrot.png")
var turnip_icon = preload("res://UsedAssets/ui_icons/seeds_turnip.png")
var pumpkin_icon = preload("res://UsedAssets/ui_icons/seeds_pumpkin.png")


onready var texture_rect = $Button/TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_crop_id_changed(crop_id)
	


func _on_crop_id_changed(value) -> void:
	if !texture_rect: return
	crop_id = value
	match crop_id:
		CROP_CARROT:
			texture_rect.texture = carrot_icon
		CROP_TURNIP:
			texture_rect.texture = turnip_icon
		CROP_PUMPKIN:
			texture_rect.texture = pumpkin_icon

func _on_ObjectLabel_text_matched() -> void:
	._on_ObjectLabel_text_matched()
	GameState.set_active_tool(GameState.CLASS_SEED + crop_id)
