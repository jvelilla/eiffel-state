indexing
	description: "Functions whose behavior depends on the control state."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATE_DEPENDENT_FUNCTION [ARGS -> TUPLE, RES]

create
	make

feature {NONE} -- Initialization
	make (n: INTEGER) is
			-- Create a procedure valid for `n' states
		do
			create behaviors.make (n)
			behaviors.compare_objects
		end

feature -- Basic operations
	add_behavior (state: STATE; guard: PREDICATE [ANY, TUPLE]; function: FUNCTION [ANY, ARGS, RES]) is
			-- Make function return the result of `function' when called in `state' and `guard' holds
		local
			list: LINKED_LIST [TUPLE [guard: PREDICATE [ANY, TUPLE]; function: FUNCTION [ANY, ARGS, RES]]]
		do
			behaviors.search (state)
			if behaviors.found then
				behaviors.found_item.extend ([guard, function])
			else
				create list.make
				list.extend ([guard, function])
				behaviors.extend (list, state)
			end
		end

	add_result (state: STATE; guard: PREDICATE [ANY, TUPLE]; r: RES) is
			-- Make function return `r' when called in `state' and `guard' holds
		do
			add_behavior (state, guard, agent identity (?, r))
		end

	item (args: ARGS; state: STATE): RES is
			-- Function result in `state' with `args' (default value if no specific behavior defined)
		local
			found: BOOLEAN
		do
			behaviors.search (state)
			if behaviors.found then
				from
					behaviors.found_item.start
				until
					behaviors.found_item.after or found
				loop
					 if behaviors.found_item.item.guard.item (args) then
						 found := True
						 Result := behaviors.found_item.item.function.item (args)
					 end
					behaviors.found_item.forth
				end
			end
		end

feature -- Implementation
	behaviors: HASH_TABLE [LINKED_LIST [TUPLE [guard: PREDICATE [ANY, TUPLE]; function: FUNCTION [ANY, ARGS, RES]]], STATE]

	identity (args: ?ARGS; x: RES): RES is
			-- Identity function
		do
			Result := x
		end

invariant
	behaviors_exists: behaviors /= Void
end
