class_name Crater extends Area2D

@export var gas_type: Base.Gas
@export var location_id: int


@onready var timer: Timer = $Timer
@onready var bubble: Sprite2D = $Bubble

const DEFAULT_CAPACITY := 5.0
const DEFAULT_SPEED_UP := 2.0

static var current_crater: Area2D
static var active_craters: Dictionary = {
    Base.Gas.AR: 0,
    Base.Gas.N: 0,
    Base.Gas.CO2: 0
}

var cap: float = 0
var is_rich: bool = false


func _ready() -> void:
    bubble.modulate.a = 0
    timer.start(randf() * timer.wait_time)
    timer.timeout.connect(func():
        if active_craters[gas_type] >= (2 if gas_type != Base.Gas.AR else 1):
            timer.start()
            return
        active_craters[gas_type] += 1
        var t := create_tween()
        t.tween_property(bubble, "modulate:a", 1, 0.5)
        is_rich = true
        cap = DEFAULT_CAPACITY
    )


func collect_gas() -> void:
    if not is_rich: return
    var delta := get_process_delta_time()
    Backpack.instance.collect_gas(gas_type)
    if not Backpack.instance.is_collecting: 
        return
    current_crater = self
    await Backpack.instance.interrupted
    var t := create_tween()
    t.tween_property(bubble, "modulate:a", 0, 0.5)
    timer.start()
    is_rich = false
    active_craters[gas_type] -= 1
    


func _process(delta: float) -> void:
    if current_crater != self: return
    cap -= delta
    if cap > 0.0:
        Backpack.instance.currently_collecting = gas_type
        Backpack.instance._collect(delta * DEFAULT_SPEED_UP)
    else:
        current_crater = null
        Backpack.instance.stop_collecting()
