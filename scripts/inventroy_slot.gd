extends Panel

@onready var item_visuals: Sprite2D = $CenterContainer/Panel/items_display

func update(item: InventoryItem):
	if item:
		item_visuals.visible = true
		item_visuals.texture = item.texture
	else:
		item_visuals.visible = false
		
