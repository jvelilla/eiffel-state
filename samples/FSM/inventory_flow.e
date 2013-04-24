note
	description: "Summary description for {INVENTORY_FLOW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INVENTORY_FLOW
inherit
	ANY
	rename
			default_create as any_default_create
	end
	AUTOMATED
	rename
			state as turn_state
	redefine
			default_create
	select
			default_create
	end

create
	default_create


feature -- Access
	state_name : STRING
		do
			Result := turn_state.name
		end

	execute
		do
			transition.call ([], turn_state)
			if attached  transition.next_state as l_next_state then
				turn_state := l_next_state
			end

		end
feature {NONE} -- Initialization
	default_create
		do
			turn_state := Stock
		end

	restart
			-- Restarts game
		require
			turn_state = Returned
		do
			sd_restart.call ([], turn_state)
			if attached  sd_restart.next_state as l_next_state then
				turn_state := l_next_state
			end
		ensure
			turn_state = Stock
		end

feature -- State Implementation

	Stock:  STATE  once create Result.make ("Stock") end
	Back_ordered:  STATE  once create Result.make ("Back_ordered") end
	Shipped:  STATE  once create Result.make ("Shipped") end
	Returned:  STATE  once create Result.make ("Returned") end

	transition: STATE_DEPENDENT_PROCEDURE [TUPLE]
			--
		once
			create Result.make (3)
			Result.add_behavior (Stock, agent can_fill_order, agent update_order, Back_ordered )
			Result.add_behavior (Back_ordered, agent allow_ship, agent update_order, Shipped)
			Result.add_behavior (Shipped, agent can_return, agent update_order, Returned)
		end

	sd_restart: STATE_DEPENDENT_PROCEDURE [ TUPLE]
		once
			create Result.make (1)
			Result.add_behavior (Returned, agent true_agent, agent do_nothing, Stock)
		end

	true_agent: BOOLEAN
			--
		once
			Result := True
		end


	can_fill_order: BOOLEAN
			--
		do
			Result := True
		end

	can_return: BOOLEAN
			--
		do
			Result := True
		end

	allow_ship: BOOLEAN
			--
		do
			Result := True
		end

	update_order
			-- Update order
		do
			if turn_state = Stock then
				print ("Update the current order from Stock to BackOrdered")
			end
			if turn_state = Back_ordered then
				print ("Update the current order from BackOrdered to shipped")
			end
			if turn_state = shipped then
				print ("Update the current order from Shipped to returned")
			end
		end

end
