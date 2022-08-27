extends Sprite3D



onready var viewport: Viewport = $Viewport


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = viewport.get_texture()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	texture = viewport.get_texture()
