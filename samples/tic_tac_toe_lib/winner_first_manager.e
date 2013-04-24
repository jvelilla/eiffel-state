indexing
	description: "Game managers that let the winner of the previous game do the first turn and change the first player in case of draw."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WINNER_FIRST_MANAGER

inherit
	GAME_MANAGER
		redefine
			default_create
		end

feature -- Initialization
	default_create is
			-- Create a manager with first turn cross
		do
			build_sd_start_new_game
			state := First_turn_cross
		end

feature -- State dependent: basic operations
	build_sd_start_new_game is
			-- Build `sd_start_new_game'
		do
			create sd_start_new_game.make (4)
			sd_start_new_game.add_behavior (First_turn_cross,
				agent: BOOLEAN do Result := True end,
				agent do create current_game.make_first_cross end,
				First_turn_circle)
			sd_start_new_game.add_behavior (First_turn_circle,
				agent: BOOLEAN do Result := True end,
				agent do create current_game.make_first_circle end,
				First_turn_cross)
			sd_start_new_game.add_behavior (First_turn_cross,
				agent: BOOLEAN do Result := current_game /= Void and then current_game.circle_won end,
				agent do create current_game.make_first_circle end,
				First_turn_cross)
			sd_start_new_game.add_behavior (First_turn_circle,
				agent: BOOLEAN do Result := current_game /= Void and then current_game.cross_won end,
				agent do create current_game.make_first_cross end,
				First_turn_circle)

		end
end
