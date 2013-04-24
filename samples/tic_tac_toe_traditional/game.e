indexing
	description: "Tic-Tac-Toe games."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME

create
	make_first_cross,
	make_first_circle

feature {NONE} -- Initialization
	make_first_cross is
			-- Create a new game with first turn of crosses
		do
			create_empty_field
			turn := 1
		ensure
			field_empty: field.for_all (agent {FIELD_CELL}.is_empty)
		end

	make_first_circle is
			-- Create a new game with first turn of circles
		do
			create_empty_field
			turn := -1
		ensure
			field_empty: field.for_all (agent {FIELD_CELL}.is_empty)
		end

	create_empty_field is
			-- Create field with empty cells
		local
			i, j: INTEGER
		do
			create field.make (Dimension, Dimension)
			from
				i := 1
			until
				i > Dimension
			loop
				from
					j := 1
				until
					j > Dimension
				loop
					field.put (create {FIELD_CELL}, i, j)
					j := j + 1
				end
				i := i + 1
			end
		end

feature -- Constants
	Dimension: INTEGER is 3
			-- Number of rows and columns on the field

feature -- Access
	item (i, j: INTEGER): FIELD_CELL  is
			-- Value of (`i', `j') cell
		require
			i_not_too_small: i >= 1
			i_not_too_large: i <= Dimension
			j_not_too_small: j >= 1
			j_not_too_large: j <= Dimension
		do
			Result := field.item (i, j)
		end

feature -- indicators
	is_over: BOOLEAN is
			-- Is game over?
		do
			Result := cross_won or circle_won or draw
		end

	cross_won: BOOLEAN is
			-- Did the crosses win?
		do
			Result := has_horizontal_cross or has_vertical_cross or has_diagonal_cross
		end

	circle_won: BOOLEAN is
			-- Did the crosses win?
		do
			Result := has_horizontal_circle or has_vertical_circle or has_diagonal_circle
		end

	draw: BOOLEAN is
		do
			Result := not (cross_won or circle_won) and not has_empty
		end

feature -- State dependent: basic operations
	make_turn (i, j: INTEGER) is
			-- Make turn, filling cell (`i', `j')
		require
			i_not_too_small: i >= 1
			i_not_too_large: i <= Dimension
			j_not_too_small: j >= 1
			j_not_too_large: j <= Dimension
		do
			if item (i, j).is_empty then
				if turn = 1 then
					item (i, j).put_cross
					turn := -1
				else
					item (i, j).put_circle
					turn := 1
				end
			end
		end

feature {NONE} -- Predicates
	has_empty: BOOLEAN is
			-- Is there empty cell?
		local
			k, l:INTEGER
		do
			from
				k := 1
			until
				k > Dimension or Result
			loop
				from
					l := 1
				until
					l > Dimension or Result
				loop
					Result := item (k, l).is_empty
					l := l + 1
				end
				k := k + 1
			end
		end

	has_horizontal_cross : BOOLEAN is
			-- Is there horizontal cross-winning combination?
		local
			k: INTEGER
		do
			from
				Result := False
				k := 1
			until
				k > Dimension or Result
			loop
				Result := item (1, k).is_cross and item(2, k).is_cross and item(3, k).is_cross
				k := k + 1
			end
		end

	has_horizontal_circle : BOOLEAN is
			-- Is there horizontal circle-winning combination?
		local
			k: INTEGER
		do
			from
				Result := False
				k := 1
			until
				k > Dimension or Result
			loop
				Result := item (1, k).is_circle and item(2, k).is_circle and item(3, k).is_circle
				k := k + 1
			end
		end

	has_vertical_cross : BOOLEAN is
			-- Is there vertical cross-winning combination?
		local
			k: INTEGER
		do
			from
				Result := False
				k := 1
			until
				k > Dimension or Result
			loop
				Result := item (k, 1).is_cross and item(k, 2).is_cross and item(k, 3).is_cross
				k := k + 1
			end
		end

	has_vertical_circle : BOOLEAN is
			-- Is there vertical circle-winning combination?
		local
			k: INTEGER
		do
			from
				Result := False
				k := 1
			until
				k > Dimension or Result
			loop
				Result := item (k, 1).is_circle and item(k, 2).is_circle and item(k, 3).is_circle
				k := k + 1
			end
		end

	has_diagonal_cross : BOOLEAN is
			-- Is there diagonal cross-winning combination?
		do
			Result := item (1, 1).is_cross and item(2, 2).is_cross and item(3, 3).is_cross
			Result := Result or (item (1, 3).is_cross and item(2, 2).is_cross and item(3, 1).is_cross)
		end

	has_diagonal_circle : BOOLEAN is
			-- Is there diagonal circle-winning combination?
		do
			Result := item (1, 1).is_circle and item(2, 2).is_circle and item(3, 3).is_circle
			Result := Result or (item (1, 3).is_circle and item(2, 2).is_circle and item(3, 1).is_circle)
		end

feature {NONE} -- Implementation
	field: ARRAY2 [FIELD_CELL]
			-- Game field

	turn: INTEGER_8
			--current turn

invariant
	field_exists: field /= Void
	field_width_correct: field.width = Dimension
	field_height_correct: field.height = Dimension
end
