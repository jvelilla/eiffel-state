indexing
	description: "Summary description for {POSITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	POSITION
create
	make

feature -- Access
	x: INTEGER
	y: INTEGER

feature -- Initialization
	make(a, b: INTEGER) is
			-- Creates object with given position
		do
			x := a
			y := b
		end

end
