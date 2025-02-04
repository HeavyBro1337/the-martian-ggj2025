extends Sprite2D


@export var sprites: Array[Sprite2D]


@export var n_sprite: int
@export var ar_sprite: int
@export var co2_sprite: int


func _process(delta: float) -> void:
    var argon := Backpack.instance.argon_unit
    var carbon := Backpack.instance.carbon_unit
    var nitro := Backpack.instance.nitro_unit
    
    for s in sprites:
        s.hide()
    
    for i in sprites.size():
        var item := sprites[i]
        if argon > 0:
            argon -= 1
            item.show()
            item.frame = ar_sprite
        elif nitro > 0:
            nitro -= 1
            item.show()
            item.frame = n_sprite
        elif carbon > 0:
            carbon -= 1
            item.show()
            item.frame = co2_sprite
