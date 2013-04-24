indexing
	description: "Class, which describes marker and its state."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MARKER
inherit
	ENVIRONMENT
create
	make

feature -- Status
	is_white: BOOLEAN is
		do
			Result := sd_is_white.item ([], color_state)
		end

	is_free: BOOLEAN is
		do
			Result := sd_is_free.item ([], color_state)
		end

	has_hint: BOOLEAN is
		do
			Result := sd_has_hint.item ([], color_state)
		end

feature {GAME_MANAGER} -- Change status
	flip is
			-- Change color of marker if it was flipped
		do
			sd_flip.call ([], color_state)
			color_state := sd_flip.next_state
			draw
		end

	show_hint (is_white_hint: BOOLEAN) is
			-- Show hint for a player by marker which is lighter or darker than background
		do
			sd_show_hint.call ([is_white_hint], color_state)
			color_state := sd_show_hint.next_state
			draw
		end

	clear_hint is
			-- Change color of marker which contained hint for player
		do
			sd_clear_hint.call ([], color_state)
			color_state := sd_clear_hint.next_state
			draw
		end

	make_move is
			-- Player made move in this cell
		do
			sd_move_made.call ([], color_state)
			color_state := sd_move_made.next_state
			draw
		end

feature -- Initialization
	make (xc, yc: INTEGER) is
			-- Create marker given its coordinates
		do
			x := xc
			y := yc
			color_state := Empty
		end

feature -- Output
	draw is
			-- Draw marker on the board given cell size, left and upper shift
		local
			shift: INTEGER -- Distance between marker and nearest part of grid
		do
			gui_manager.drawable_widget.set_foreground_color (sd_color.item([], color_state))
			shift := gui_manager.cell_size // 10
			gui_manager.drawable_widget.fill_ellipse (gui_manager.cell_size * x + shift, gui_manager.cell_size * y + shift, gui_manager.cell_size - 2 * shift, gui_manager.cell_size - 2 * shift)
		end

feature {MARKER} -- State dependent features
	color_state: STATE

	White: STATE is once create Result.make ("White") end
	Black: STATE is once create Result.make ("Black") end
	Empty: STATE is once create Result.make ("Empty") end

	-- Black or white marker can be put there
	Black_can: STATE is once create Result.make ("Black can") end
	White_can: STATE is once create Result.make ("White can") end

	sd_color: STATE_DEPENDENT_FUNCTION [TUPLE, EV_COLOR] is
			-- Returns color of marker, according to its state
		once
			create Result.make (5)
			Result.add_result (White, agent true_agent, create {EV_COLOR}.make_with_rgb (1, 1, 1))
			Result.add_result (Black, agent true_agent, create {EV_COLOR}.make_with_rgb (0, 0, 0))
			Result.add_result (Empty, agent true_agent, gui_manager.background)
			Result.add_result (White_can, agent true_agent, gui_manager.lighter_background)
			Result.add_result (Black_can, agent true_agent, gui_manager.darker_background)
		end

	sd_is_white: STATE_DEPENDENT_FUNCTION [TUPLE, BOOLEAN] is
			-- Returns if marker is white
		once
			create Result.make (5)
			Result.add_result (White, agent true_agent, True)
			Result.add_result (Black, agent true_agent, False)
			Result.add_result (Empty, agent true_agent, False)
			Result.add_result (White_can, agent true_agent, False)
			Result.add_result (Black_can, agent true_agent, False)
		end

	sd_is_free: STATE_DEPENDENT_FUNCTION [TUPLE, BOOLEAN] is
			-- Returns if marker was already put on the board
		once
			create Result.make (5)
			Result.add_result (White, agent true_agent, False)
			Result.add_result (Black, agent true_agent, False)
			Result.add_result (Empty, agent true_agent, True)
			Result.add_result (White_can, agent true_agent, True)
			Result.add_result (Black_can, agent true_agent, True)
		end

	sd_has_hint: STATE_DEPENDENT_FUNCTION [TUPLE, BOOLEAN] is
			-- Returns if marker has hint now
		once
			create Result.make (5)
			Result.add_result (White, agent true_agent, False)
			Result.add_result (Black, agent true_agent, False)
			Result.add_result (Empty, agent true_agent, False)
			Result.add_result (White_can, agent true_agent, True)
			Result.add_result (Black_can, agent true_agent, True)
		end

	sd_flip: STATE_DEPENDENT_PROCEDURE [TUPLE] is
		once
			create Result.make (2)
			Result.add_behavior (White, agent true_agent, agent do_nothing, Black)
			Result.add_behavior (Black, agent true_agent, agent do_nothing, White)
		end

	sd_move_made: STATE_DEPENDENT_PROCEDURE [TUPLE] is
		once
			create Result.make (2)
			Result.add_behavior (White_can, agent true_agent, agent do_nothing, White)
			Result.add_behavior (Black_can, agent true_agent, agent do_nothing, Black)
		end

	sd_show_hint: STATE_DEPENDENT_PROCEDURE [TUPLE] is
		once
			create Result.make (2)
			Result.add_behavior (Empty, agent trivial_agent, agent do_nothing, White_can)
			Result.add_behavior (Empty, agent opposite_agent, agent do_nothing, Black_can)
		end

	sd_clear_hint: STATE_DEPENDENT_PROCEDURE [TUPLE] is
		once
			create Result.make (5)
			Result.add_behavior (White, agent true_agent, agent do_nothing, White)
			Result.add_behavior (Black, agent true_agent, agent do_nothing, Black)
			Result.add_behavior (Empty, agent true_agent, agent do_nothing, Empty)
			Result.add_behavior (White_can, agent true_agent, agent do_nothing, Empty)
			Result.add_behavior (Black_can, agent true_agent, agent do_nothing, Empty)
		end

feature {NONE} -- Implementation
	x, y: INTEGER -- Coordinates of marker on the board

end
