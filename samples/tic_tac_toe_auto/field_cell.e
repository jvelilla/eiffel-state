indexing
	description: "Summary description for {FIELD_CELL}."
	author: "Dmitry Kochelaev"
	date: "$Date$"
	revision: "$Revision$"

class
	FIELD_CELL

create
	make

feature {NONE} -- Initialization

	make is
			-- Initialization for `Current'.
		require
			current_state_is_undefinied: state = Void
			states_are_undefinied: states = Void
		local
			empty_state: STATE
			cross_state: STATE
			circle_state: STATE
		do
			states := create {HASH_TABLE [STATE, INTEGER]}.make (10)
			create cross_state.make (1, "Cross", Void)
			create circle_state.make (-1, "Circle", Void)
			create empty_state.make (0, "Empty", agent empty_transitions(?, ?))
			states.put (empty_state, empty_state.get_state_id)
			states.put (cross_state, cross_state.get_state_id)
			states.put (circle_state, circle_state.get_state_id)
			state := empty_state
		ensure
			states.valid_key (state.get_state_id)
		end

feature -- Command

	make_turn (player: INTEGER) is
			-- makes turn for player
		require
			{GAME}.circle_code = player or {GAME}.cross_code = player
		local
			args: HASH_TABLE [INTEGER, STRING]
		do
			create args.make (2)
			args.put (player, "turn")
			state := states.item (state.get_new_state_id(args))
		end

feature -- Access
	cell_value: INTEGER is
		do
			Result := state.get_state_id
		end

feature {NONE} -- Transitions

	empty_transitions (args: TABLE[INTEGER, STRING]; state_id: INTEGER) : INTEGER is
			-- transition from empty to cross
		do
			if not args.valid_key ("turn") then
				Result := state_id
			else
				if  args.item ("turn") = {GAME}.circle_code then
					Result := {GAME}.circle_code
				else
					Result := {GAME}.cross_code
				end
			end
		end



feature {NONE} -- States description

	state: STATE -- Current state
	states: TABLE[STATE, INTEGER] -- All states present in system

feature {NONE} -- Constants
	default_state_id: INTEGER -- Default state id

invariant
	states_exist: states /= Void
	state_is_valid: states.valid_key (state.get_state_id)
end
