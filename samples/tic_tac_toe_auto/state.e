indexing
	description: "Summary description for {STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATE

create
	make

feature {NONE} -- Initialization

	make (init_state_id: INTEGER; init_state_name: STRING; init_transitions: FUNCTION [ANY, TUPLE, INTEGER]) is
			-- Initialization for `Current'.
		do
			state_id := init_state_id
			state_name := init_state_name
			transitions := init_transitions
		end

	state_id: INTEGER -- id of the state
	state_name: STRING -- name of the state
	transitions: FUNCTION [ANY, TUPLE, INTEGER] -- transitions from state

feature -- Queries

	get_state_id: INTEGER is
			-- returns id of the state
		do
			Result := state_id
		end

	get_state_name: STRING is
			-- returns name of the state
		do
			Result := state_name
		end

	get_new_state_id (args: HASH_TABLE [INTEGER, STRING]): INTEGER is
			-- returns new state id
		local
			new_state: INTEGER
		do
			if transitions = Void then
				Result := state_id
			else
				new_state := transitions.item ([args, state_id])
				Result := new_state
			end
		end


end
