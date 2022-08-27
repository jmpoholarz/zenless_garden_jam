extends PanelContainer


var customer_panel_scene: PackedScene = preload("res://UIElements/CustomerPanel.tscn")
var harvested_plant_particle_scene: PackedScene = preload("res://UIElements/CustomerPanel/HarvestedPlantParticle.tscn")

onready var vboxcontainer = $VBoxContainer

const MAX_CUSTOMERS = 6
const CARROT_SPAWN = 0
const TURNIP_SPAWN = 3
const PUMPKIN_SPAWN = 6

var time_since_last_tick: float = 10.0
var tick_rate: float = 10.0
var ticks_so_far: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _err = EventBus.connect("plant_harvested", self, "apply_crop")
	

func _process(delta: float) -> void:
	time_since_last_tick += delta
	if time_since_last_tick > tick_rate:
		time_since_last_tick -= tick_rate
		ticks_so_far += 1
		generate_new_customer()


func generate_new_customer() -> void:
	if vboxcontainer.get_child_count() >= MAX_CUSTOMERS:
		return
	var max_veggies = int(max(1.0, min(ticks_so_far / 2.0, 10.0)))
	
	var veggies_chosen = randi() % max_veggies + 1
	var veggies_so_far = 0
	
	var new_customer = customer_panel_scene.instance()
	vboxcontainer.add_child(new_customer)
	if ticks_so_far > PUMPKIN_SPAWN:
		var pumpkins = randi() % veggies_chosen
		veggies_so_far += pumpkins
		new_customer.set_crop_requirement(GameState.SEED_PUMPKIN, pumpkins)
	if ticks_so_far > TURNIP_SPAWN && veggies_so_far < veggies_chosen:
		var turnips = randi() % (veggies_chosen - veggies_so_far)
		veggies_so_far += turnips
		new_customer.set_crop_requirement(GameState.SEED_TURNIP, turnips)
	if ticks_so_far > CARROT_SPAWN && veggies_so_far < veggies_chosen:
		new_customer.set_crop_requirement(GameState.SEED_CARROT, veggies_chosen - veggies_so_far)
	

func apply_crop(crop_id: int, from_pos: Vector2) -> void:
	var to_pos: Vector2
	var min_patience = 101.0
	var min_child = null
	
	for child in vboxcontainer.get_children():
		if child.needs_crop(crop_id) and child.get_patience() < min_patience:
			to_pos = child.rect_global_position
			min_patience = child.get_patience()
			min_child = child
	
	if min_child == null:
		return
	
	min_child.apply_crop(crop_id)
	var particle = harvested_plant_particle_scene.instance()
	add_child(particle)
	particle.particle(from_pos, to_pos, crop_id)
