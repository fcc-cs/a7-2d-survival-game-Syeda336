extends Control

@onready var inv: Inventory = preload("res://inventoryitems/playersInv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false

func _ready() -> void:
	inv.update.connect(update_slotes)
	update_slotes()
	close()
	
func update_slotes():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_right"):
		if is_open:
			close()
		else:
			open()

func open():
	visible = true
	is_open = true
	
func close():
	visible = false 
	is_open = false
	
