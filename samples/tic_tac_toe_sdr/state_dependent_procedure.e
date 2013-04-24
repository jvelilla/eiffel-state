indexing
	description: "Procedures whose behavior depends on the control state."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATE_DEPENDENT_PROCEDURE [ARGS -> TUPLE]

create
	make

feature {NONE} -- Initialization
	make (n: INTEGER) is
			-- Create a procedure valid for `n' states
		do
			create behaviors.make (n)
			behaviors.compare_objects
		end

feature -- Access
	next_state: STATE
			-- State to transit to after calling procedure

feature -- Basic operations
	add_behavior (state: STATE; guard: PREDICATE [ANY, TUPLE]; action: PROCEDURE [ANY, ARGS]; target: STATE) is
			-- Make procedure execute `action' and transit to `target' when called in `state' and `guard' holds
		local
			list: LINKED_LIST [TUPLE [guard: PREDICATE [ANY, TUPLE]; action: PROCEDURE [ANY, ARGS]; target: STATE]]
		do
			behaviors.search (state)
			if behaviors.found then
				behaviors.found_item.extend ([guard, action, target])
			else
				create list.make
				list.extend ([guard, action, target])
				behaviors.extend (list, state)
			end
		end

	call (args: ARGS; state: STATE) is
			-- Call procedure in `state' with `args'
		local
			found: BOOLEAN
		do
			found := False
			next_state := state
			behaviors.search (state)
			if behaviors.found then
				from
					behaviors.found_item.start
				until
					behaviors.found_item.after or found
				loop
					 if behaviors.found_item.item.guard.item (args) then
						 found := True
						 behaviors.found_item.item.action.call (args)
						 next_state := behaviors.found_item.item.target
					 end
					behaviors.found_item.forth
				end
			end
		end

feature -- Implementation
	behaviors: HASH_TABLE [LINKED_LIST [TUPLE [guard: PREDICATE [ANY, TUPLE]; action: PROCEDURE [ANY, TUPLE]; target: STATE]], STATE]

invariant
	behaviors_exists: behaviors /= Void
end
