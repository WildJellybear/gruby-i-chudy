
extends Node

## ============================================================
## CHARACTER MANAGER - ZARZĄDZANIE GRYWALNYMI POSTACIAMI
## ============================================================
##
## Odpowiada za:
## - wybór aktywnej postaci przy uruchomieniu mapy,
## - przełączanie sterowania klawiszem Tab,
## - włączanie i wyłączanie sterowania,
## - informowanie innych systemów o zmianie postaci.
##
## Na razie nieaktywna postać stoi w miejscu.
## ============================================================


# ------------------------------------------------------------
# SYGNAŁY
# ------------------------------------------------------------

## Emitowany po zmianie aktywnej postaci.
signal active_character_changed(character: Player)


# ------------------------------------------------------------
# REFERENCJE DO POSTACI
# ------------------------------------------------------------

@export var gruby: Player
@export var chudy: Player

var active_player: Player


# ------------------------------------------------------------
# INICJALIZACJA
# ------------------------------------------------------------

## Ustawia Grubego jako postać startową.
##
## Obie postacie początkowo nie przyjmują sterowania.
## Następnie aktywujemy Grubego.
func _ready() -> void:

	if gruby == null or chudy == null:
		push_error(
			"CharacterManager: Nie przypisano Grubego lub Chudego!"
		)
		return

	# Wyłączamy sterowanie obu postaci.
	gruby.set_player_controlled(false)
	chudy.set_player_controlled(false)

	# Gruby jest domyślną postacią startową.
	set_active_character(gruby)


# ------------------------------------------------------------
# OBSŁUGA KLAWIATURY
# ------------------------------------------------------------

## Obsługuje akcję switch_character (Tab).
## (ustawiona globalnie w projekcie)
func _unhandled_input(event: InputEvent) -> void:

	if event.is_action_pressed("switch_character"):
		if not event.is_echo():
			switch_character()


# ------------------------------------------------------------
# PRZEŁĄCZANIE POSTACI
# ------------------------------------------------------------

## Zamienia aktywną postać na drugą.
##
## Gruby -> Chudy
## Chudy -> Gruby
func switch_character() -> void:

	if active_player == gruby:
		set_active_character(chudy)

	else:
		set_active_character(gruby)


## Ustawia wskazaną postać jako aktywną.
##
## 1. Zatrzymuje poprzednią postać.
## 2. Zapamiętuje nową aktywną postać.
## 3. Włącza jej sterowanie.
## 4. Wysyła sygnał do innych systemów.
##
## Nie przenosi żadnej postaci na inną pozycję.
func set_active_character(character: Player) -> void:

	if character == null:
		return

	# Wyłączamy poprzednią postać.
	if active_player != null:
		active_player.set_player_controlled(false)

	# Zapamiętujemy nową postać.
	active_player = character

	# Przekazujemy jej kontrolę z klawiatury.
	active_player.set_player_controlled(true)

	# Informujemy pozostałe systemy o zmianie.
	active_character_changed.emit(active_player)
