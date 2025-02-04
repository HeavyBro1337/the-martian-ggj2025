class_name Base extends Node


static var instance: Base


func _ready() -> void:
    instance = self
    Crater.active_craters = {
    Base.Gas.AR: 0,
    Base.Gas.N: 0,
    Base.Gas.CO2: 0
    }


enum Gas {
    CO2,
    N,
    AR,
}


@export var carbon_dioxide_ttc: float
@export var nitrogen_ttc: float
@export var argon_ttc: float

@export var factor: float



var tank_filled_co2: int
var tank_filled_n: int
var tank_filled_ar: int


var carbon_dioxide: float:
    set(v):
        carbon_dioxide = v
        if v >= carbon_dioxide_ttc:
            carbon_dioxide = 0
            tank_filled_co2 += 1
            Backpack.instance.oxygen += Backpack.instance.o2_cap * 0.5
            half_filled_tank.emit(Gas.CO2)
var nitrogen: float:
    set(v):
        nitrogen = v
        if v >= nitrogen_ttc:
            tank_filled_n += 1
            nitrogen = 0
            half_filled_tank.emit(Gas.N)
var argon: float:
    set(v):
        argon = v
        if v >= argon_ttc:
            tank_filled_ar += 1
            argon = 0
            half_filled_tank.emit(Gas.AR)


signal filled_tank(g: Gas)
signal half_filled_tank(g: Gas)
signal won()

var already_won: bool


func get_fills(g: Gas) -> int:
    match g:
        Gas.AR: return tank_filled_ar
        Gas.N: return tank_filled_n
        Gas.CO2: return tank_filled_co2
    return -1
    

func _process(delta: float) -> void:
    var fills := [tank_filled_co2, tank_filled_n, tank_filled_ar]
    if fills .all(func(x):return x >= 4) and not already_won:
        already_won = true
        won.emit()
        get_tree().change_scene_to_file("res://outro.tscn")
        
