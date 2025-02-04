extends Area2D
class_name Intercation


signal interacted()
var is_in_area: bool


func _ready() -> void:
    body_entered.connect(_body_entered)
    body_exited.connect(_body_exited)

func _process(delta: float) -> void:
    if Input.is_action_just_pressed("collect"):
        interact()
    
func interact() -> void:
    if not is_in_area: return
    interacted.emit()
    
func _body_entered(body: Node2D) -> void:
    if body.is_in_group("Player"):
        is_in_area = true


func _body_exited(body: Node2D) -> void:
    if body.is_in_group("Player"):
        is_in_area = false
