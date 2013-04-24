indexing
	description: "Cells of the game field."
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
			cell_value := 0
		ensure then
			is_empty: is_empty
		end

feature -- State dependent: Element change
	put_cross is
			-- Put cross into the cell
		do
			cell_value := 1
		end

	put_circle is
			-- Put circle into the cell
		do
			cell_value := -1
		end

feature -- Indicators
	is_empty: BOOLEAN is
			-- Is the cell empty?
		do
			Result := (cell_value = 0)
		end

	is_cross: BOOLEAN is
			-- Is the cell cross?
		do
			Result := (cell_value = 1)
		end

	is_circle: BOOLEAN is
			-- Is the cell circle?
		do
			Result := (cell_value = -1)
		end

feature -- Output
	out: STRING is
			-- String representation of the cell
		do
			Result := ""
			if (is_cross) then
				Result := "X"
			end
			if (is_circle) then
				Result := "O"
			end
		end

feature -- Variables
	cell_value: INTEGER_8;

end
