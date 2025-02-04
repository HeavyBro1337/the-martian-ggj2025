class_name Backpack extends Node


static var instance: Backpack


@export var gas_capacity: int = 3
@export var o2_cap: float = 5.0
@onready var deathsound: AudioStreamPlayer2D = $"../DeathSound"


@onready var oxygen: float = o2_cap:
	set(v):
		oxygen = v
		oxygen = clamp(oxygen, 0, o2_cap)
		
		if oxygen == 0 and not died_already:
			suffocated.emit()
			died_already = true
			deathsound.play()
			
			
			
var carbon_dioxide: float
var nitrogen: float
var argon: float


var argon_unit: int
var nitro_unit: int
var carbon_unit: int


var deposit_time: float


signal interrupted()
signal suffocated()
signal damaged()


var died_already: bool


func damage(percentage: float) -> void:
	oxygen -= percentage * o2_cap
	damaged.emit()

var currently_collecting: Base.Gas
var is_collecting: bool
var is_depositing: bool


func stop_collecting() -> void:
	is_collecting = false
	is_depositing = false
	interrupted.emit()


func _ready() -> void:
	instance = self


func collect_gas(g: Base.Gas) -> void:
	if argon_unit + nitro_unit + carbon_unit >= gas_capacity: 
		is_collecting = false
		return 
	currently_collecting = g
	is_collecting = true


const DEFAULT_DEPOSIT := 2


func deposit_gas(g: Base.Gas) -> void:
	if not has_gas(g): 
		return
	deposit_time = DEFAULT_DEPOSIT
	is_depositing = true
	currently_collecting = g
	
	
func has_gas(g: Base.Gas) -> bool:
	match g:
		Base.Gas.CO2:
			return carbon_unit > 0 
		Base.Gas.N: 
			return nitro_unit > 0
		Base.Gas.AR: 
			return argon_unit > 0
	return false
		


func _process(delta: float) -> void:
	oxygen -= delta
	# _collect(delta)
	_deposit(delta)
	
	
func _deposit(delta: float) -> void:
	if not is_depositing: return
	if deposit_time > 0.0:
		deposit_time -= delta
		return
	deposit_time = DEFAULT_DEPOSIT
	match currently_collecting:
		Base.Gas.CO2:
			if carbon_unit <= 0: return
			carbon_unit -= 1
			Base.instance.carbon_dioxide += 5
			carbon_unit = max(carbon_unit, 0)
			if carbon_unit == 0: 
				stop_collecting()
		Base.Gas.N: 
			if nitro_unit <= 0: return
			nitro_unit -= 1
			Base.instance.nitrogen += 5
			nitro_unit = max(nitro_unit, 0)
			if nitro_unit == 0: 
				stop_collecting()
		Base.Gas.AR: 
			if argon_unit <= 0: return
			argon_unit -= 1
			Base.instance.argon += 5
			argon_unit = max(argon_unit, 0)
			if argon_unit == 0: 
				stop_collecting()


func _collect(delta: float) -> void:
	if not is_collecting: return
	var gas_sum := argon_unit + carbon_unit + nitro_unit
	if gas_sum >= gas_capacity: return
	match currently_collecting:
		Base.Gas.CO2:
			carbon_dioxide += delta
			carbon_dioxide = min(carbon_dioxide, gas_capacity)
			if carbon_dioxide == gas_capacity: 
				carbon_unit += 1
				carbon_dioxide = 0
				stop_collecting()
		Base.Gas.N: 
			nitrogen += delta
			nitrogen = min(nitrogen, gas_capacity)
			if nitrogen == gas_capacity: 
				nitro_unit += 1
				nitrogen = 0
				stop_collecting()
		Base.Gas.AR: 
			argon += delta
			argon = min(argon, gas_capacity)
			if argon == gas_capacity: 
				argon_unit += 1
				argon = 0
				stop_collecting()
