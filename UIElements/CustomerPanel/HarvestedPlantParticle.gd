extends TextureRect

var carrot_icon = preload("res://UsedAssets/ui_icons/crop_carrot.png")
var turnip_icon = preload("res://UsedAssets/ui_icons/crop_turnip.png")
var pumpkin_icon = preload("res://UsedAssets/ui_icons/crop_pumpkin.png")

func particle(from: Vector2, to: Vector2, crop_id: int) -> void:
	match crop_id:
		GameState.SEED_CARROT:
			texture = carrot_icon
		GameState.SEED_TURNIP:
			texture = turnip_icon
		GameState.SEED_PUMPKIN:
			texture = pumpkin_icon
	$Tween.interpolate_property(self, "rect_global_position", from, to, 1.0, Tween.TRANS_CUBIC)
	$Tween.start()

func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	queue_free()
