extends Node2D



@export var deathParticle: PackedScene
@export var crater: PackedScene
var vertical_speed: float = 100
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    position += Vector2(0, vertical_speed * delta)


func _on_body_entered(body: Node2D) -> void:
    if body is inv_floor:
        killer()
    
    
func killer() -> void:
    var particle = deathParticle.instantiate() as GPUParticles2D
    particle.emitting = true
    get_parent().add_child(particle)
    particle.global_position = global_position
    var cr := crater.instantiate() as Node2D
    get_parent().add_child.call_deferred(cr)
    cr.global_position = global_position
    sprite.hide()
    queue_free()
