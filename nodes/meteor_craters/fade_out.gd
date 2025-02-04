extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
    modulate.a -= delta / 3
    if modulate.a <= 0.0:
        queue_free()
