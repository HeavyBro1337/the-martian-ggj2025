extends Control


@export_file("*.tscn") var exit_scene: String
@export_file("*.tscn") var main_scene: String


@onready var restart: Button = $VBoxContainer/Resume
@onready var exit: Button = $VBoxContainer/Exit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	Backpack.instance.suffocated.connect(show)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_pressed() -> void:
	Crater.active_craters = {
		Base.Gas.AR: 0,
		Base.Gas.N: 0,
		Base.Gas.CO2: 0
	}
	get_tree().reload_current_scene()


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file(exit_scene)
