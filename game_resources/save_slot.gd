extends Control
@onready var empty_slot: TextureButton = $EmptySlot
@onready var filled_slot: TextureButton = $FilledSlot

@onready var save_question: Label = $EmptySlot/SaveQuestion
@onready var overwrite_question: Label = $FilledSlot/OverwriteQuestion
@onready var slot_full: Label = $FilledSlot/SlotFull
@onready var lovemeter_gauge: Control = $FilledSlot/LovemeterGauge


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_empty_slot_pressed() -> void:
	empty_slot.visible = false
	filled_slot.visible = true
	slot_full.visible = true
	lovemeter_gauge.visible = true
	filled_slot.grab_focus()
	pass # Replace with function body.

#-------------------------

func _on_empty_slot_focus_entered() -> void:
	save_question.visible = true
	
	pass # Replace with function body.


func _on_empty_slot_focus_exited() -> void:
	save_question.visible = false
	pass # Replace with function body.


func _on_empty_slot_mouse_entered() -> void:
	save_question.visible = true
	pass # Replace with function body.


func _on_empty_slot_mouse_exited() -> void:
	save_question.visible = false
	pass # Replace with function body.
	
#--------------------------------------

func _on_filled_slot_focus_entered() -> void:
	overwrite_question.visible = true
	slot_full.visible = false
	pass # Replace with function body.

func _on_filled_slot_mouse_entered() -> void:
	overwrite_question.visible = true
	slot_full.visible = true
	pass # Replace with function body.
	
#------------------

func _on_filled_slot_focus_exited() -> void:
	overwrite_question.visible = false
	slot_full.visible = true
	pass # Replace with function body.

func _on_filled_slot_mouse_exited() -> void:
	overwrite_question.visible = false
	slot_full.visible = true
	pass # Replace with function body.
