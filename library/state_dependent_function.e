note
	description: "Functions whose behavior depends on the control state."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STATE_DEPENDENT_FUNCTION  [ARGS -> detachable TUPLE create default_create end, RES]

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
			create results.make (n)
			results.compare_objects
		end

feature -- Basic operations
	add_behavior (state: STATE; guard: PREDICATE [ANY, ARGS]; function: FUNCTION [ANY, ARGS, RES])
			-- Make function return the result of `function' when called in `state' and `guard' holds
		local
			list: LINKED_LIST [TUPLE [guard: PREDICATE [ANY, ARGS]; function: FUNCTION [ANY, ARGS, RES]]]
		do
			behaviors.search (state)
			if behaviors.found then
				if attached behaviors.found_item as l_found_item then
					l_found_item.put_front ([guard, function])
				end

			else
				create list.make
				list.put_front ([guard, function])
				behaviors.extend (list, state)
			end
		end

	add_result (state: STATE; guard: PREDICATE [ANY, ARGS]; res: RES)
			-- Make function return `r' when called in `state' and `guard' holds
		local
			list: LINKED_LIST [TUPLE [guard: PREDICATE [ANY, ARGS]; res: RES]]
		do
			results.search (state)
			if results.found then
				if attached results.found_item as l_found_item then
					l_found_item.extend ([guard, res])
				end

			else
				create list.make
				list.put_front ([guard, res])
				results.extend (list, state)
			end
		end

	item (args: ARGS; state: STATE): detachable RES
			-- Function result in `state' with `args' (default value if no specific behavior defined)
		require
			  results.has (state) or behaviors.has (state) --check if function is defined in this state
		local
			found: BOOLEAN
		do
			results.search (state)
			if results.found then
				if attached results.found_item as l_found_item then

					from
						l_found_item.start
					until
						l_found_item.after or found
					loop
						if l_found_item.item.guard.item (args) then
							found := True
							Result := l_found_item.item.res
						end
						l_found_item.forth
					end
				end
			end
			behaviors.search (state)
			if behaviors.found and not found then
				if attached behaviors.found_item as l_found_item then

					from
						l_found_item.start
					until
						l_found_item.after or found
					loop
						 if l_found_item.item.guard.item (args) then
							 found := True
							 Result := l_found_item.item.function.item (args)
						 end
						l_found_item.forth
					end
				end
			end
		end

feature -- Implementation
	behaviors: HASH_TABLE [LINKED_LIST [TUPLE [guard: PREDICATE [ANY, ARGS]; function: FUNCTION [ANY, ARGS, RES]]], STATE]
			-- Function behaviors in different states, when different guards hold

	results: HASH_TABLE [LINKED_LIST [TUPLE [guard: PREDICATE [ANY, ARGS]; res: RES]], STATE]
			-- Function results in different states, when different guards hold

invariant
	behaviors_exists: behaviors /= Void
	results_exists: results /= Void
end
