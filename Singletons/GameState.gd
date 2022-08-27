extends Node

const NONE = -1

const CLASS_TOOL = 0
const TOOL_SHOVEL = 1
const TOOL_WATERING_CAN = 2
const TOOL_FERTILIZER = 3
const TOOL_WEEDING_FORK = 4

const CLASS_SEED = 100
const SEED_CARROT = 101
const SEED_TURNIP = 102
const SEED_PUMPKIN = 103


var flag_used_seeds = false
var flag_planted_seeds = false
var flag_served_customer = false
var flag_first_turnip = false
var flag_first_pumpkin = false
var flag_first_watering = false
var flag_first_weeds = false
var flag_first_shovel = false


var _active_tool: int = NONE
var _in_menu: bool = false

var _customers_served = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()

func reset_game_state() -> void:
	flag_used_seeds = false
	flag_planted_seeds = false
	flag_served_customer = false
	flag_first_turnip = false
	flag_first_pumpkin = false
	flag_first_watering = false
	flag_first_weeds = false
	flag_first_shovel = false
	_customers_served = 0

func set_active_tool(tool_id) -> void:
	if flag_used_seeds == false:
		flag_used_seeds = true
		EventBus.emit_signal("tutorial_seeds_picked")
	
	_active_tool = tool_id
	EventBus.emit_signal("active_tool_changed", tool_id)

func get_active_tool() -> int:
	return _active_tool

func is_in_menu() -> bool:
	return _in_menu

func increment_customers_served() -> void:
	_customers_served += 1
	if flag_served_customer == false:
		flag_served_customer = true
		EventBus.emit_signal("tutorial_customer_served")

func get_customers_served() -> int:
	return _customers_served
