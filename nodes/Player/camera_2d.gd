extends Camera2D


@onready var y := global_position.y


func _process(delta: float) -> void:
    global_position.y = y
