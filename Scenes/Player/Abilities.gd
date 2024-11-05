extends Node
class_name PlayerAbilities

const BOOMERANG = preload("res://Scenes/Projectiles/boomerang.tscn")
const ARROWS = preload("res://Scenes/Projectiles/arrows_2.tscn")
const BOMBE = preload("res://Scenes/Projectiles/bombe.tscn")

enum abilities { BOOMERANG, GRAPPLE, ARROW, BOMBE}

var selected_ability = abilities.GRAPPLE
var player : Player

var boomerang_instance : Boomerang = null
var arrows_instance : Arrows = null
var bombe_instance: Bombe = null


func _ready() -> void:
	player = PlayerManager.player
	VariablesWeapons.selected_abilities.connect( _on_selected_abilities )


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed( "second_weapon" ):
		if selected_ability == abilities.BOOMERANG:
			boomerang_ability()
		elif selected_ability == abilities.ARROW:
			arrows_ability()
		elif selected_ability == abilities.BOMBE:
			bombe_ability()
			pass
	pass


func boomerang_ability() -> void:
	if boomerang_instance != null:
		return
	
	var _b = BOOMERANG.instantiate() as Boomerang
	player.add_sibling( _b )
	_b.global_position = player.global_position
	
	var throw_direction = player.direction
	if throw_direction == Vector2.ZERO:
		throw_direction = player.cardinal_direction
	
	_b.throw( throw_direction )
	boomerang_instance = _b
	pass

func arrows_ability() -> void:
	if arrows_instance != null:
		return
		
	if VariablesWeapons.arrows == true:
		var _b = ARROWS.instantiate() as Arrows
		player.add_sibling( _b )
		_b.transform = player.spawn_projectile.global_transform
		
		var shoot_direction = player.direction.rotated(player.rotation)
		if shoot_direction == Vector2.ZERO:
			shoot_direction = player.cardinal_direction
			
		_b.shoot( shoot_direction )
		arrows_instance = _b
	else :
		$"../Error_Sound".play()
	
func bombe_ability():
	#if bombe_instance != null:
		#return
	if VariablesWeapons.bombe == true:
		var _b = BOMBE.instantiate() as Bombe
		player.add_sibling( _b )
		_b.global_position = player.global_position

		_b.plant_bombe()
		bombe_instance = _b
	else:
		$"../Error_Sound".play()


func _on_selected_abilities():
	if VariablesWeapons.boomerang == true:
		selected_ability = abilities.BOOMERANG
	elif VariablesWeapons.bow == true:
		selected_ability = abilities.ARROW
	elif VariablesWeapons.bombe == true:
		selected_ability = abilities.BOMBE
