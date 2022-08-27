extends TextureRect


onready var label: Label = $Label


func set_counter(value: int) -> void:
	label.text = "x" + str(value)
