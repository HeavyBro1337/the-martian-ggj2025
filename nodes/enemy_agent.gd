extends NavigationAgent2D


@export var visible_range: float = 256.0
@export var wander_distance: float = 64
@export var speed: float

@onready var sprite_2d: AnimatedSprite2D = $"../Sprite2D"

var is_chasing: bool


@onready var wander: Timer = $Wander


func _ready() -> void:
    velocity_computed.connect(func(safe: Vector2):
        owner.velocity = safe
    )
    wander.start(randf() * wander.wait_time)
    wander.timeout.connect(func():
        if is_chasing: return
        target_position = owner.global_position + Vector2(randf_range(-wander_distance, wander_distance), randf_range(-wander_distance, wander_distance))
        )


func _process(delta: float) -> void:
    var player_pos := Player.instance.global_position
    var dist := player_pos.distance_to(owner.global_position)
    is_chasing = dist < visible_range
    
    var vel := owner.velocity as Vector2
    
    if vel:
        if sprite_2d.animation != "attack":
            sprite_2d.play("walk")
        if vel.x:
            sprite_2d.flip_h = vel.x < 0
    elif sprite_2d.animation != "attack":
        sprite_2d.play("idle")
    
    _handle_logic()
    
    
func _handle_logic() -> void:
    if sprite_2d.animation == "attack":
        velocity = Vector2.ZERO
        return
    var player_pos := Player.instance.global_position
    velocity = owner.global_position.direction_to(get_next_path_position()) * speed
    if is_chasing:
        target_position = player_pos
        return
    

func _physics_process(delta: float) -> void:
    owner.move_and_slide()
