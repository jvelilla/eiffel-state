note
	description: "Sawmills that produce LUMBER from FELLED_TREE."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAWMILL

inherit
	PRODUCTION

create {WORKER}
	make

feature -- Access
	type : STRING is "Sawmill"

	creation_time: DOUBLE is 20.0

	felled_tree_amount: INTEGER

	is_enough_trees: BOOLEAN is
		do
			Result := felled_tree_amount > 0
		end

feature -- Basic operations
	deliver_felled_tree (tree: FELLED_TREE) is
			-- Worker should deliver `FELLED_TREE' before producing `LUMBER'
		do
			felled_tree_amount := felled_tree_amount + 1
		end

	produce: LUMBER is
			-- Produce resource and store it into `last_lumber'
		require else
			is_enough_trees
		do
			felled_tree_amount := felled_tree_amount - 1
			create Result
		ensure then
			Result /= Void
		end

end
