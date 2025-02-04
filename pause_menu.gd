extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    visible = false
    visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed() -> void:
    get_tree().paused = visible
    
    
func _process(delta: float) -> void:
    if Input.is_action_just_pressed("escape"):
        visible = not visible
