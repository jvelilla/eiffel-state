note
	description: "Units that can be created by the players."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	UNIT

inherit
	AUTOMATED
		rename
			state as health_state
		redefine
			out
		select
			out,
			default_create
		end
	ENVIRONMENT
		rename
			out as env_out
		end

feature -- Initialization
	make (p: POSITION; team: STRING) is
			-- Create nonselected unit at position `p',
			-- set his `team_name' to `team' and health to maximum
		require
			p_exists: p /= Void
		do
			team_name := team
			create team_state.make(team)
			health_state := Alive
			selected_state := Nonselected
			position := p
		ensure
			position_set: position = p
			team_state_set: team_state /= Void
		end

feature -- Access
	creation_time: DOUBLE is
			-- Time required to create current unit
		deferred
		end

	team_name: STRING

	position: POSITION
			-- Current position of the unit in the game world

	type: STRING is
			-- Type of the unit
		deferred
		end

	actions: LIST [ACTION [TUPLE]]
			-- Returns actions, which current unit can complete.
			-- TODO: make this STATE_DEPENDENT
		deferred
		ensure
			Result /= Void
		end

feature -- Output
	draw is
			-- Draw unit
		do
			map_manager.draw_cell_at_position (position)
			sd_draw.call ([], selected_state)
		end

	draw_nonselected is
			-- Draw unit when it isn't selected
		do
			gui_manager.drawable_widget.set_foreground_color (create {EV_COLOR}.make_with_rgb (0, 0, 0))
			common_draw
		end

	draw_selected is
			-- Draw unit when it is selected
		do
			gui_manager.drawable_widget.set_foreground_color (create {EV_COLOR}.make_with_rgb (1, 0, 0))
			common_draw
		end

	out: STRING is
			-- String representation
		do
			Result := type + "[" + team_name + "]"
		end

feature -- Status report
	is_healthy: BOOLEAN is
			-- Does the unit have maximum amount of hit points?
		do
			Result := health_state = Alive
		end

	is_selected: BOOLEAN is
			-- Is this unit selected by mouse?
		do
			Result := selected_state = Selected
		end

feature -- Basic operations
	reduce_health is
			-- Reduce health when unit is under attack
		do
			sd_reduce_health.call([], health_state)
			health_state := sd_reduce_health.next_state
		ensure
			health_state /= Void
		end

	improve_health is
			-- Improve health when unit is healed
			-- and return time needed for this operation
		do
			sd_improve_health.call([], health_state)
			health_state := sd_improve_health.next_state
		ensure
			health_state /= Void
		end

	change_selected_state is
			-- Set unit's `selected_state' to `Selected' when unit wasn't selected and vice versa
		do
			sd_change_selected_state.call ([], selected_state)
			selected_state := sd_change_selected_state.next_state
			draw
		end

feature {NONE} -- Output
	common_draw is
			-- Draws text in the cell where unit is situated
		local
			x, y, size: INTEGER
			unit_coordinates: ARRAY [INTEGER]
				-- Absolute coordinates got from `map_manager'
		do
			gui_manager.drawable_widget.set_font (
				create {EV_FONT}.make_with_values ({EV_FONT_CONSTANTS}.Family_roman,
												   {EV_FONT_CONSTANTS}.Weight_bold,
												   {EV_FONT_CONSTANTS}.Shape_regular,
												   8)
			)
			unit_coordinates := map_manager.cell_center_coordinates (position)
			x := unit_coordinates @ 1
			y := unit_coordinates @ 2
			size := map_manager.cell_size
			gui_manager.drawable_widget.draw_text (x - size // 2 + 2, y + 2, type.substring (1, type.count.min (5)))
			gui_manager.drawable_widget.draw_ellipse (x - size // 2, y - size // 2, size, size)
		end

feature {NONE} -- States
	Alive: STATE is once create Result.make ("Alive") end
	Injured: STATE is once create Result.make ("Injured") end
	Seriously_injured: STATE is once create Result.make ("Seriously injured") end
	Dead: STATE is once create Result.make ("Dead") end

	selected_state: STATE
			-- Is this unit selected in the game?
	Selected: STATE is once create Result.make ("Selected") end
	Nonselected: STATE is once create Result.make ("Nonselected") end

	team_state: STATE
			-- This unit belongs to `team_state'

feature {NONE} -- State dependent implementation

	sd_improve_health: STATE_DEPENDENT_PROCEDURE [TUPLE] is
			-- State dependent procedure which changes state when unit is being healed
		once
			create Result.make (3)

			Result.add_behavior (Alive, agent true_agent, agent do_nothing, Alive)
			Result.add_behavior (Injured, agent true_agent, agent do_nothing, Alive)
			Result.add_behavior (Seriously_injured, agent true_agent, agent do_nothing, Injured)
		end

	sd_reduce_health: STATE_DEPENDENT_PROCEDURE [TUPLE] is
			-- State dependent procedure which changes state when unit is under attack
		once
			create Result.make(3)
			Result.add_behavior (Alive, agent true_agent, agent do end, Injured)
			Result.add_behavior (Injured, agent true_agent, agent do end, Seriously_injured)
			Result.add_behavior (Seriously_injured, agent true_agent, agent do end, Dead)
		end

	sd_draw: STATE_DEPENDENT_PROCEDURE [TUPLE] is
			-- Draws unit according to his `selected_state'
		do
			create Result.make (2)
			Result.add_behavior (Selected, agent true_agent, agent draw_selected, Selected)
			Result.add_behavior (Nonselected, agent true_agent, agent draw_nonselected, Nonselected)
		end

	sd_change_selected_state: STATE_DEPENDENT_PROCEDURE [TUPLE] is
		once
			create Result.make (2)
			Result.add_behavior (Nonselected, agent true_agent, agent do end, Selected)
			Result.add_behavior (Selected, agent true_agent, agent do end, Nonselected)
		end

	sd_ability_reduction: STATE_DEPENDENT_FUNCTION [TUPLE, DOUBLE] is
			-- State-dependent function which changes abilities of beings: movement speed, attack accuracy
		once
			create Result.make(4)
			Result.add_result (Alive, agent true_agent, 1.0)
			Result.add_result (Injured, agent true_agent, 0.7)
			Result.add_result (Seriously_injured, agent true_agent, 0.3)
			Result.add_result (Dead, agent true_agent, 0.0)
		end

invariant
	position_exists: position /= Void
	type_exists: type /= Void
	type_nonempty: not type.is_empty
	health_state_exists: health_state /= Void
	team_state_exists: team_state /= Void
	selected_state_exists: selected_state /= Void
end
