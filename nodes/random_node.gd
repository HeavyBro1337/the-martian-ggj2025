extends Node2D


@export var scenes: Array[PackedScene]


func _ready() -> void:
    var scene := scenes.pick_random() as PackedScene
    queue_free()
    var instance := scene.instantiate() as Node2D
    instance.global_position = global_position
    get_parent().add_child(instance)
