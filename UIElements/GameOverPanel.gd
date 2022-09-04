extends PanelContainer


onready var customer_holder: Node = $MarginContainer/VBoxContainer/HBoxContainer/CustomerHolder
onready var counter_label: Label = $MarginContainer/VBoxContainer/Label2



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.connect("customer_timed_out", self, "_on_EventBus_customer_timed_out")


func _on_EventBus_customer_timed_out(customer: Node) -> void:
	get_tree().paused = true
	#print("Customer timed out!")
	GameState._in_menu = true
	customer.get_parent().remove_child(customer)
	customer_holder.add_child(customer)
	counter_label.text = "You served " + str(GameState.get_customers_served()) + " customers."
	visible = true


func _on_Button_pressed() -> void:
	get_tree().paused = false
	GameState.reset_game_state()
	get_tree().reload_current_scene()
