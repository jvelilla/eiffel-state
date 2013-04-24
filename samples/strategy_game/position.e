note
	description: "Position of some unit in the game world."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	POSITION

inherit
	AUTOMATED
		rename
			state as relief_state
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

create
	make

feature -- Initialization
	make (new_x, new_y, relief_type: INTEGER) is
			-- Set `x' to `new_x' and `y' to `new_y',
			-- set `state' value according to `relief_type'
		require
			non_negative_x: new_x >= 0
			non_negative_y: new_y >= 0
			proper_relief_type: relief_type >= 1 and relief_type <= relief_types
		do
			x := new_x
			y := new_y
			relief_state := get_relief_state (relief_type)
		ensure
			x_set: x = new_x
			y_set: y = new_y
			state_set: relief_state /= Void
		end

feature -- Access
	x: INTEGER
	y: INTEGER

	relief_types: INTEGER is 5

	relief_name (relief_type: INTEGER): STRING is
			-- Returns name of relief corresponding to `relief_type' type
		do
			Result := get_relief_state(relief_type).name
		end

	relief: STRING is
		do
			Result := relief_state.name
		end

feature -- Status report
	equals (other: POSITION) : BOOLEAN is
			-- Are these two positions equal?
		do
			Result := x = other.x and y = other.y
		end

feature -- State dependent: Status report
	crossing_time: INTEGER is
			-- It takes `crossing_time' to cross cell with this coordinates according to its relief
		do
			Result := sd_crossing_time.item ([], relief_state)
		end

	color: EV_COLOR is
			-- Draws current cell, using its' relief
		do
			Result := sd_color.item ([], relief_state)
		end

	passable: BOOLEAN is
			-- Returns if being can pass through this POSITION
		do
			Result := sd_passable.item ([], relief_state)
		end


feature -- Output
	out: STRING is
			-- String representation in form (`x', `y', `relief')
		do
			Result := "(" + x.out + ", " + y.out + ", " + relief + ")"
		end

feature {NONE} -- Implementation

	sd_crossing_time: STATE_DEPENDENT_FUNCTION [TUPLE, INTEGER] is
			-- State-dependent function for `crossing_time' function
		local
			i: INTEGER
		once
			create Result.make(States.count)
			from
				i := 1
			until
				i = States.count + 1
			loop
				Result.add_result (States @ i, agent true_agent, Crossing_times @ i)
				i := i + 1
			end
		end

	sd_color: STATE_DEPENDENT_FUNCTION [TUPLE, EV_COLOR] is
			-- State-dependent function for `color' function
		local
			i: INTEGER
		once
			create Result.make(States.count)
			from
				i := 1
			until
				i = States.count + 1
			loop
				Result.add_result (States @ i, agent true_agent, Colors @ i)
				i := i + 1
			end
		end

	sd_passable: STATE_DEPENDENT_FUNCTION [TUPLE, BOOLEAN] is
		once
			create Result.make (5)
			Result.add_result (States.item (1), agent true_agent, True)
			Result.add_result (States.item (2), agent true_agent, True)
			Result.add_result (States.item (3), agent true_agent, True)
			Result.add_result (States.item (4), agent true_agent, False)
			Result.add_result (States.item (5), agent true_agent, True)
		end

	get_relief_state (relief_type: INTEGER): STATE is
			-- Returns name of relief corresponding to `relief_type' type
		do
			Result := States @ relief_type
		end

	States: ARRAY [STATE] is
			-- Array with states for all relief types
		once
			Result := <<
				create {STATE}.make ("Field"),
				create {STATE}.make ("Forest"),
				create {STATE}.make ("Jungle"),
				create {STATE}.make ("Lake"),
				create {STATE}.make ("Mountain")
			>>
		end

	Crossing_times: ARRAY[INTEGER] is
			-- Times required to cross cells
		once
			Result := <<50, 100, 150, 200, 300>>
		end

	Colors: ARRAY[EV_COLOR] is
			-- Colors to fill cell in the window
		once
			Result := <<
				create {EV_COLOR}.make_with_rgb (1, 1, 0),
				create {EV_COLOR}.make_with_rgb (0.28, 0.72, 0.3),
				create {EV_COLOR}.make_with_rgb (0.14, 1, 0.07),
				create {EV_COLOR}.make_with_rgb (0.11, 0.73, 0.89),
				create {EV_COLOR}.make_with_rgb (0.56, 0.5, 0.44)
			>>
		end

invariant
	proper_relief: not relief.is_empty
	not out.is_empty
end
