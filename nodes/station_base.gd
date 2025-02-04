extends Node2D


@export var gas_type: Base.Gas
@export var canister_filled_right: Texture2D
@export var canister_filled_left: Texture2D

@onready var tank_right: Sprite2D = %TankRight
@onready var tank_left: Sprite2D = %TankLeft


func deposit_gas() -> void:
    Backpack.instance.deposit_gas(gas_type)


func _ready() -> void:
    Base.instance.half_filled_tank.connect(_half_filled_tank)
    tank_left.texture = canister_filled_left
    tank_right.texture = canister_filled_right
    
    
func _half_filled_tank(g: Base.Gas) -> void:
    if gas_type != g: return
    var fills := Base.instance.get_fills(g)
    if fills <= 4:
        tank_left.visible = fills in [1, 2, 3, 4]
        tank_right.visible = fills in [2, 4]
    if fills == 2:
        $Sprite2D/HalfWay.show()
        $Sprite2D/Empty.hide()
    elif fills == 4:
        $Sprite2D/HalfWay.hide()
        $Sprite2D/Done.show()
