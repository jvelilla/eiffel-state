indexing
	description: "Managers that may start games, collect statistics, etc."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GAME_MANAGER

inherit
	AUTOMATED

feature -- Access
	current_game: GAME

feature -- State dependent: basic operations
	start_new_game is
			-- Start a new game
		do
			sd_start_new_game.call([], state)
			state := sd_start_new_game.next_state
		end

feature {NONE} -- Automaton
	First_turn_cross: STATE is once create Result.make ("First turn cross") end
	First_turn_circle: STATE is once create Result.make ("First turn circle") end

	sd_start_new_game: STATE_DEPENDENT_PROCEDURE [TUPLE]
			-- State-dependent procedure for `start_new_game'

	build_sd_start_new_game is
			-- Build `sd_start_new_game'
		deferred
		end
end
