note
	description: "Procedures whose behavior depends on the control state."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATE_DEPENDENT_PROCEDURE [ARGS -> detachable TUPLE create default_create end]

create
	make

feature {NONE} -- Initialization
	make (n: INTEGER)
			-- Create a procedure valid for at least `n' states
		require
			n_positive: n > 0
		do
			create behaviors.make (n)
			behaviors.compare_objects
		end

feature -- Access
	next_state: detachable STATE
			-- State to transit to after calling procedure

feature -- Basic operations
	add_behavior (state: STATE; guard: PREDICATE [ANY, ARGS]; action: PROCEDURE [ANY, ARGS]; target: STATE)
			-- Make procedure execute `action' and transit to `target' when called in `state' and `guard' holds
		local
			list: LINKED_LIST [TUPLE [guard: PREDICATE [ANY, ARGS]; action: PROCEDURE [ ANY,  ARGS]; target: STATE]]
		do
			behaviors.search (state)
			if behaviors.found then
				if attached behaviors.found_item as l_found_item then
					l_found_item.put_front ([guard, action, target])
				end

			else
				create list.make
				list.put_front ([guard, action, target])
				behaviors.extend (list, state)
			end
		end

	call (args: ARGS; state: STATE)
			-- Call procedure in `state' with `args'
		require
			behaviors.has (state)
		local
			found: BOOLEAN
		do
			found := False
			next_state := state
			behaviors.search (state)
			if behaviors.found then
				if attached behaviors.found_item as l_found_item then

					from
						l_found_item.start
					until
						l_found_item.after or found
					loop
						 if l_found_item.item.guard.item (args) then
							 found := True
							 l_found_item.item.action.call (args)
							 next_state := l_found_item.item.target
						 end
						l_found_item.forth
					end
				end
			end
		end

feature -- Implementation
	behaviors: HASH_TABLE [LINKED_LIST [TUPLE [guard: PREDICATE [ANY, ARGS]; action: PROCEDURE [ANY, ARGS]; target: STATE]], STATE]
		-- Procedure behaviors in different states, when different guards hold

invariant
	behaviors_exists: behaviors /= Void
end
