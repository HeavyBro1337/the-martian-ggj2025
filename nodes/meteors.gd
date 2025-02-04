extends Node2D

@onready var meteor_time: Timer = $"../MeteorTime"


const METEOR := preload("res://meteor.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    meteor_time.timeout.connect(func():
        var m := METEOR.instantiate()
        m.global_position = get_children().pick_random().global_position
        get_parent().add_child(m)
        )
