note
	description : "FSM application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
		local
			inventory : INVENTORY_FLOW
		do
			create inventory
			print ( "%N" + inventory.state_name + "%N")
			inventory.execute
			print ("%N" + inventory.state_name + "%N")
			inventory.execute
			print ("%N" + inventory.state_name + "%N")
			inventory.execute
			print ("%N" + inventory.state_name + "%N")

		end

end
