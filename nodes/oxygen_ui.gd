extends TextureProgressBar


func _process(delta: float) -> void:
    max_value = Backpack.instance.o2_cap
    value = Backpack.instance.oxygen
