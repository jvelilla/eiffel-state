indexing
	description: "Cells of the TIC TAC TOE field."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FIELD_CELL

inherit
	ANY
		redefine
			default_create,
			out
		end

feature {NONE} -- Initialization
	default_create is
			-- Create an empty cell
		do
			state := Empty
		ensure then
			is_empty: is_empty
		end

feature -- State dependent: Element change
	put_cross is
			-- Put cross into the cell
		do
			if state = Empty then
				state := Cross
			end
		end

	put_circle is
			-- Put circle into the cell
		do
			if state = Empty then
				state := Circle
			end
		end

feature -- State dependent: Status report
	is_empty: BOOLEAN is
			-- Is the cell empty?
		do
			Result := (state = Empty)
		end

	is_cross: BOOLEAN is
			-- Is the cell cross?
		do
			Result := (state = Cross)
		end

	is_circle: BOOLEAN is
			-- Is the cell circle?
		do
			Result := (state = Circle)
		end

feature -- State dependent: Output
	out: STRING is
			-- String representation of the cell
		do
			if state = Empty then
				Result := ""
			elseif state = Cross then
				Result := "X"
			elseif state = Circle then
				Result := "O"
			end
		end

feature {NONE} -- States
	Empty: INTEGER is 1
	Cross: INTEGER is 2
	Circle: INTEGER is 3

	state: INTEGER
end
