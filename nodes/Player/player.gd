class_name Player extends CharacterBody2D


static var instance: Player


@onready var sprite: AnimatedSprite2D = $Sprite
@onready var backpack: Sprite2D = $Sprite/Sprite2D
@onready var suck_sound: AudioStreamPlayer2D = $SuckSound


func _ready() -> void:
    instance = self


const SPEED = 150.0

signal moved()


func disable() -> void:
    set_physics_process(false)

func _physics_process(delta: float) -> void:
    suck_sound.stream_paused = not (Backpack.instance.is_collecting or Backpack.instance.is_depositing)
        
    #Movement-------------------------------------------------------------------------
    var movement: Vector2 = Input.get_vector("left", "right", "up", "down")
    
    if movement:
        sprite.play("walk")
        if movement.x:
            sprite.flip_h = movement.x < 0
            backpack.scale.x = -1 if movement.x < 0 else 1
        moved.emit()
    else:
        if not Backpack.instance.is_collecting and not Backpack.instance.is_depositing:
            if not sprite.animation in ["damaged", "dead"]:
                sprite.play("idle")
        elif not sprite.animation in ["damaged", "dead"]:
            sprite.play("suck", _get_suck_speed())
    velocity = movement * SPEED
    
    move_and_slide()
    #---------------------------------------------------------------------------------


func _get_suck_speed() -> float:
    if Backpack.instance.is_collecting:
        return 1.0
    if Backpack.instance.is_depositing:
        return -1.0
    return 1.0


func damaged() -> void:
    if sprite.animation == "dead": return
    sprite.play("damaged")
    await sprite.animation_finished
    sprite.play("idle")
