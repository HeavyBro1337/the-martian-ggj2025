extends Area2D


@export_range(0, 1) var damage: float


@onready var timer: Timer = $Timer


var is_in_area: bool


signal damaged_target()


func _ready() -> void:
    timer.paused = true
    timer.timeout.connect(func():
        var bodies := get_overlapping_bodies()
        for b in bodies:
            if b.is_in_group("Player"):
                Backpack.instance.damage(damage)
                damaged_target.emit()
                return
    )
    body_entered.connect(_body_entered)
    body_exited.connect(_body_exited)


func _body_entered(body: Node2D) -> void:
    if body.is_in_group("Player"):
        timer.paused = false
        damaged_target.emit()
        Backpack.instance.damage(damage)


func _body_exited(body: Node2D) -> void:
    if body.is_in_group("Player"):
        timer.paused = true
