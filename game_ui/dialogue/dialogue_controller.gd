extends CanvasLayer

signal dialogue_started
signal dialogue_ended
signal line_started(line: DialogueLine)
signal line_finished(line: DialogueLine)

@export var characters_per_second: float = 45.0

@onready var dialogue_box: Control = $DialogueBox
@onready var name_label: Label = \
	$DialogueBox/MarginContainer/VBoxContainer/NameLabel

@onready var portrait: TextureRect = \
	$DialogueBox/MarginContainer/VBoxContainer/Content/Portrait

@onready var what_label: RichTextLabel = \
	$DialogueBox/MarginContainer/VBoxContainer/Content/What

@onready var ctc: Label = \
	$DialogueBox/MarginContainer/VBoxContainer/Footer/CTC


var active: bool = false
var typing: bool = false

var lines: Array[DialogueLine] = []
var line_index: int = -1

var character_progress: float = 0.0
var can_accept_input: bool = true

var previous_game_state: int = Game.State.EXPLORATION


func _ready() -> void:
	dialogue_box.visible = false
	ctc.visible = false


func _process(delta: float) -> void:
	if not active:
		return

	if typing:
		_update_typewriter(delta)

	elif ctc.visible:
		_update_ctc_animation()


func _unhandled_input(event: InputEvent) -> void:
	if not active:
		return

	if not can_accept_input:
		return

	if not event.is_action_pressed("interact"):
		return

	get_viewport().set_input_as_handled()

	if typing:
		_finish_typing()
	else:
		_advance()


func say(
	who: String,
	what: String,
	portrait_texture: Texture2D = null
) -> void:
	var line := DialogueLine.new()

	line.who = who
	line.what = what
	line.portrait = portrait_texture

	var dialogue_lines: Array[DialogueLine] = [line]

	play(dialogue_lines)


func play(dialogue_lines: Array[DialogueLine]) -> void:
	if dialogue_lines.is_empty():
		return

	lines.clear()

	for line in dialogue_lines:
		lines.append(line)

	previous_game_state = Game.state

	active = true
	line_index = -1

	dialogue_box.visible = true

	Game.set_state(Game.State.DIALOGUE)

	dialogue_started.emit()

	_advance()

	# Evita que o mesmo Z usado para iniciar o diálogo
	# também avance imediatamente a fala.
	can_accept_input = false
	call_deferred("_unlock_input")


func _advance() -> void:
	line_index += 1

	if line_index >= lines.size():
		close_dialogue()
		return

	_show_line(lines[line_index])


func _show_line(line: DialogueLine) -> void:
	name_label.text = line.who
	name_label.visible = not line.who.is_empty()

	if line.portrait != null:
		portrait.texture = line.portrait
		portrait.visible = true
	else:
		portrait.texture = null
		portrait.visible = false

	what_label.text = line.what
	what_label.visible_characters = 0

	character_progress = 0.0
	typing = true

	ctc.visible = false
	ctc.modulate.a = 1.0

	line_started.emit(line)


func _update_typewriter(delta: float) -> void:
	character_progress += characters_per_second * delta

	var total_characters := what_label.get_total_character_count()

	what_label.visible_characters = min(
		int(character_progress),
		total_characters
	)

	if what_label.visible_characters >= total_characters:
		_finish_typing()


func _finish_typing() -> void:
	if not typing:
		return

	what_label.visible_characters = -1

	typing = false
	ctc.visible = true

	line_finished.emit(lines[line_index])


func _update_ctc_animation() -> void:
	var time := Time.get_ticks_msec() / 250.0

	ctc.modulate.a = 0.65 + sin(time) * 0.35


func close_dialogue() -> void:
	if not active:
		return

	active = false
	typing = false

	dialogue_box.visible = false
	ctc.visible = false

	lines.clear()
	line_index = -1

	Game.set_state(previous_game_state)

	dialogue_ended.emit()


func _unlock_input() -> void:
	can_accept_input = true
