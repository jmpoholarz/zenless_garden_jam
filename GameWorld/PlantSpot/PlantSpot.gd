extends Spatial



onready var plant_gui: ColorRect = $PlantGui
onready var plant_model: MeshInstance = $PlantModel
onready var weed_model: MeshInstance = $WeedModel

const PLANT_REQUEST_NONE = 0
const PLANT_REQUEST_WATER = 1
const PLANT_REQUEST_FERTILIZER = 2
const PLANT_REQUEST_SHOVEL = 3
const PLANT_REQUEST_WEEDS = 4
const PLANT_REQUEST_HARVEST = 5

var dead_material: SpatialMaterial = preload("res://UsedAssets/dead_material.tres")

var event_chance_per_tick: float = 3.0
var tick_rate: float = 0.5
var time_since_last_tick: float = 0.0
var plant_size: float = 0.0
var plant_health: float = 50.0
var active_plant_request: int = PLANT_REQUEST_NONE
var full_grown: bool = false
var is_growing: bool = false
var plant_id: int = -1



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _err = plant_gui.connect("text_matched", self, "_on_PlantGui_text_matched")
	_err = get_tree().get_root().connect("size_changed", self, "set_plant_gui_location")
	
	# Center plant gui on plant
	set_plant_gui_location()
	set_plant_size(plant_size)
	set_plant_health(plant_health)

func _process(delta: float) -> void:
	time_since_last_tick += delta
	if time_since_last_tick > tick_rate:
		time_since_last_tick -= tick_rate
		do_plant_tick()

func _on_PlantGui_text_matched() -> void:
	#print("text matched " + str(GameState.get_active_tool()))
	if GameState.get_active_tool() == GameState.TOOL_WATERING_CAN:
		water_plant()
	elif GameState.get_active_tool() == GameState.TOOL_WEEDING_FORK:
		deweed_plant()
	elif GameState.get_active_tool() == GameState.TOOL_SHOVEL:
		if full_grown:
			harvest_plant()
		else:
			dig_up_plant()
	
	elif GameState.get_active_tool() == GameState.SEED_CARROT:
		plant_seed(GameState.SEED_CARROT)
	elif GameState.get_active_tool() == GameState.SEED_TURNIP:
		plant_seed(GameState.SEED_TURNIP)
	elif GameState.get_active_tool() == GameState.SEED_PUMPKIN:
		plant_seed(GameState.SEED_PUMPKIN)


func set_plant_gui_location() -> void:
	var pos: Vector2 = get_viewport().get_camera().unproject_position(global_translation)
	plant_gui.rect_global_position = pos - Vector2(plant_gui.rect_size.x / 2.0, plant_gui.rect_size.y / 2.0)


func do_plant_tick() -> void:
	if !is_growing:
		return
	if active_plant_request == PLANT_REQUEST_SHOVEL:
		return
	
	set_plant_size(plant_size + 0.25)
	if active_plant_request != PLANT_REQUEST_NONE:
		set_plant_health(plant_health - 1.0)
		return
	else:
		set_plant_health(plant_health + 1.0)
		set_plant_size(plant_size + 0.75) #grow extra when healthy
		try_roll_event()
	

func try_roll_event() -> void:
	var new_event_value: float = randf() * 100
	if new_event_value < event_chance_per_tick:
		var chosen_event = randi() % 2
		if chosen_event == 0:
			set_plant_needs_water()
		else:
			set_weeds()


func set_plant_health(value) -> void:
	plant_health = value
	plant_gui.set_plant_health(plant_health)
	if plant_health < 0.0:
		plant_health = 0.0
		kill_plant()
	if plant_health > 100.0:
		plant_health = 100.0

func set_plant_size(value) -> void:
	plant_size = value
	plant_model.scale = Vector3(1.0, 1.0, 1.0) * plant_size / 50.0
	plant_gui.set_plant_size(plant_size)
	if plant_size > 100:
		plant_size = 100
		set_ready_to_harvest()

func set_plant_crop_type(value) -> void:
	plant_gui.set_crop_type(value)

func plant_seed(seed_id: int) -> void:
	if plant_id != -1:
		return
	
	if GameState.flag_planted_seeds == false:
		GameState.flag_planted_seeds = true
		EventBus.emit_signal("tutorial_seeds_planted")
	
	plant_gui.show_status_bars()
	set_plant_size(0.0)
	set_plant_health(50.0)
	set_plant_crop_type(seed_id)
	plant_model.set_surface_material(0, null)
	plant_id = seed_id
	is_growing = true
	plant_gui.update_textbox_opacity(GameState.get_active_tool())

func set_plant_needs_water() -> void:
	active_plant_request = PLANT_REQUEST_WATER
	plant_gui.set_active_quest(PLANT_REQUEST_WATER)
	if GameState.flag_first_watering == false:
		GameState.flag_first_watering = true
		EventBus.emit_signal("flag_first_watering")
	if GameState.flag_tool_used == false:
		EventBus.emit_signal("tutorial_tool_needed")

func water_plant() -> void:
	if active_plant_request == PLANT_REQUEST_WATER:
		active_plant_request = PLANT_REQUEST_NONE
		plant_gui.set_active_quest(PLANT_REQUEST_NONE)
		if GameState.flag_tool_used == false:
			GameState.flag_tool_used = true
			EventBus.emit_signal("flag_first_tool_used")

func set_weeds() -> void:
	weed_model.visible = true
	active_plant_request = PLANT_REQUEST_WEEDS
	plant_gui.set_active_quest(PLANT_REQUEST_WEEDS)
	if GameState.flag_first_weeds == false:
		GameState.flag_first_weeds = true
		EventBus.emit_signal("flag_first_weeds")
	if GameState.flag_tool_used == false:
		EventBus.emit_signal("tutorial_tool_needed")


func deweed_plant() -> void:
	if active_plant_request == PLANT_REQUEST_WEEDS:
		weed_model.visible = false
		active_plant_request = PLANT_REQUEST_NONE
		plant_gui.set_active_quest(PLANT_REQUEST_NONE)
		if GameState.flag_tool_used == false:
			GameState.flag_tool_used = true
			EventBus.emit_signal("flag_first_tool_used")

func set_ready_to_harvest() -> void:
	full_grown = true
	active_plant_request = PLANT_REQUEST_SHOVEL
	plant_gui.set_active_quest(PLANT_REQUEST_SHOVEL)
	plant_gui.set_gui_theme(plant_gui.THEME_GREEN)
	#TODO: change plant gui color theme to successful plant
	if GameState.flag_first_shovel == false:
		GameState.flag_first_shovel = true
		EventBus.emit_signal("flag_first_shovel")

func harvest_plant() -> void:
	plant_gui.hide_status_bars()
	full_grown = false
	is_growing = false
	set_plant_size(0.0)
	active_plant_request = PLANT_REQUEST_NONE
	plant_gui.set_active_quest(PLANT_REQUEST_NONE)
	plant_gui.set_gui_theme(plant_gui.THEME_BLUE)
	weed_model.visible = false
	EventBus.emit_signal("plant_harvested", plant_id, 
			get_viewport().get_camera().unproject_position(global_translation))
	plant_id = -1

func kill_plant() -> void:
	plant_model.set_surface_material(0, dead_material)
	active_plant_request = PLANT_REQUEST_SHOVEL
	plant_gui.set_active_quest(PLANT_REQUEST_SHOVEL)
	plant_gui.set_gui_theme(plant_gui.THEME_RED)
	#TODO: change plant gui color theme to dead plant
	is_growing = false
	if GameState.flag_first_shovel == false:
		GameState.flag_first_shovel = true
		EventBus.emit_signal("flag_first_shovel")

func dig_up_plant() -> void:
	plant_gui.hide_status_bars()
	full_grown = false
	is_growing = false
	set_plant_size(0.0)
	plant_id = -1
	active_plant_request = PLANT_REQUEST_NONE
	plant_gui.set_active_quest(PLANT_REQUEST_NONE)
	plant_gui.set_gui_theme(plant_gui.THEME_BLUE)
	weed_model.visible = false
