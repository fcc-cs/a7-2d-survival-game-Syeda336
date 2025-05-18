extends Control

signal quest_menu_closed
@export_file("*.json") var d_file

var quest = []
var current_quest_id = -1
var d_active = false
var quest_active = false
var quest_completed = false
var completed_quests: Array[int] = []

var stick = 0
var apple = 0
var slime = 0

func _ready():
	$quest1_ui.visible = false
	$no_quest.visible = false
	$finished_quest.visible = false
	quest = load_quest()

func load_quest():
	var file = FileAccess.open("res://dialogues/quests.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content if typeof(content) == TYPE_ARRAY else []

func start():
	d_active = true
	$quest1_ui.visible = true
	next_script()

func next_script():
	var next_id = current_quest_id + 1

	while next_id < quest.size() and next_id in completed_quests:
		next_id += 1

	if next_id >= quest.size():
		d_active = false
		$quest1_ui.visible = false
		await no_quest_left()
		return

	current_quest_id = next_id

	# Show current quest
	$quest1_ui/Name.text = quest[current_quest_id].get("name", "Unknown")
	$quest1_ui/Text.text = quest[current_quest_id].get("text", "")

func _on_yes_pressed():
	$quest1_ui.visible = false
	quest_active = true
	quest_completed = false
	d_active = true

	# Reset item counters
	stick = 0
	apple = 0
	slime = 0

	emit_signal("quest_menu_closed")

func _on_no_pressed():
	$quest1_ui.visible = false
	d_active = false
	emit_signal("quest_menu_closed")

func _process(_delta):
	if quest_active:
		match current_quest_id:
			0:
				if stick >= 1:
					complete_quest()
			1:
				if apple >= 1:
					complete_quest()
			2:
				if slime >= 1:
					complete_quest()

func complete_quest():
	quest_active = false
	quest_completed = true
	await finished_quest_close()

	if current_quest_id not in completed_quests:
		completed_quests.append(current_quest_id)

func stick_collected():
	stick += 1

func apple_collected():
	apple += 1

func slime_collected():
	slime += 1

func finished_quest_close():
	$finished_quest.visible = true
	await get_tree().create_timer(3.0).timeout
	$finished_quest.visible = false

func next_quest():
	if quest_completed:
		start()
	else:
		await no_quest_left()

func no_quest_left():		
		$no_quest.visible = true
		await get_tree().create_timer(3.0).timeout
		$no_quest.visible = false
