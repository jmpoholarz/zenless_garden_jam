extends Button


var carrot_counter: PackedScene = preload("res://UIElements/CustomerPanel/CustomerCounterCarrot.tscn")
var turnip_counter: PackedScene = preload("res://UIElements/CustomerPanel/CustomerCounterTurnip.tscn")
var pumpkin_counter: PackedScene = preload("res://UIElements/CustomerPanel/CustomerCounterPumpkin.tscn")

onready var counter_container: HBoxContainer = $MarginContainer/VBoxContainer/CounterContainer
onready var patience_bar: ProgressBar = $MarginContainer/VBoxContainer/HBoxContainer2/PatienceBar

var crops: Dictionary = {}
var crop_counters: Dictionary = {}


var tick_rate: float = 2.0
var time_since_last_tick: float = 0.0


func _ready() -> void:
	$Tween.interpolate_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 
			Color(1.0, 1.0, 1.0, 1.0), 1.0, Tween.TRANS_CUBIC)
	$Tween.start()


func _process(delta: float) -> void:
	time_since_last_tick += delta
	if time_since_last_tick > tick_rate:
		time_since_last_tick -= tick_rate
		#ticks_so_far += 1
		grow_impatient()

func grow_impatient() -> void:
	if patience_bar.value <= 0.0:
		EventBus.emit_signal("customer_timed_out", self)
	patience_bar.value -= 1.0

func get_patience() -> float:
	return patience_bar.value

func set_crop_requirement(id: int, count: int) -> void:
	if count == 0:
		return
	crops[id] = count
	match id:
		GameState.SEED_CARROT:
			var new_counter = carrot_counter.instance()
			counter_container.add_child(new_counter)
			new_counter.set_counter(count)
			crop_counters[id] = new_counter
		GameState.SEED_TURNIP:
			var new_counter = turnip_counter.instance()
			counter_container.add_child(new_counter)
			new_counter.set_counter(count)
			crop_counters[id] = new_counter
			if GameState.flag_first_turnip == false:
				GameState.flag_first_turnip = true
				EventBus.emit_signal("flag_first_turnip")
		GameState.SEED_PUMPKIN:
			var new_counter = pumpkin_counter.instance()
			counter_container.add_child(new_counter)
			new_counter.set_counter(count)
			crop_counters[id] = new_counter
			if GameState.flag_first_pumpkin == false:
				GameState.flag_first_pumpkin = true
				EventBus.emit_signal("flag_first_pumpkin")

func needs_crop(id: int) -> bool:
	return crops.has(id)

func apply_crop(id: int) -> void:
	crops[id] = crops[id] - 1
	crop_counters[id].set_counter(crops[id])
	if crops[id] == 0:
		crops.erase(id)
		crop_counters[id].queue_free()
	
	if crops.size() == 0:
		GameState.increment_customers_served()
		queue_free()
