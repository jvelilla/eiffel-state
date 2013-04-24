indexing
	description: "TIC TAC TOE games"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME

create
	make

feature {NONE} -- Initialization

	make is
			-- Create an empty field
		local
			i: INTEGER
			j: INTEGER
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
					field.item (i, j) := create {FIELD_CELL}.make;
					j := j + 1
				end
				i := i + 1
			end

			current_turn := Cross_code
		--TODO: fix ensure statement
		--ensure
		--	field_empty: field.for_all (agent (x: INTEGER): BOOLEAN do Result := x = Empty_code end)
		end

feature -- Constants
	Dimension: INTEGER is 3
			-- Number of rows and columns on the field

    Cross_code: INTEGER is -1
    		-- Code of cross

    Circle_code: INTEGER is 1
    		-- Code of circle

    Empty_code: INTEGER is 0
    		-- Code of empty cell

feature -- Access
	item (i, j: INTEGER): INTEGER  is
			-- Value of (`i', `j') cell
		require
			i_not_too_small: i >= 1
			i_not_too_large: i <= Dimension
			j_not_too_small: j >= 1
			j_not_too_large: j <= Dimension
		do
			Result := field.item (i, j).cell_value
		ensure
			result_valid: valid_code (Result)
		end

	winner: INTEGER
			-- Code of the winner		

feature -- Status report

	valid_code (code: INTEGER): BOOLEAN is
			-- Is `code' a valid code of cell value?
		do
			Result := code = Cross_code or code = Circle_code or code = Empty_code
		end

	is_over: BOOLEAN
			-- Is game over?		

feature {NONE} -- Status report
	has_winner: BOOLEAN is
			-- Is there a winner?
		do
			Result := winner /= Empty_code
		end

	has_empty: BOOLEAN is
			-- Are there any empty cells left?
		local
			i: INTEGER
			j: INTEGER
		do
			from
				i := 1
			until
				i > Dimension or Result
			loop
				from
					j := 1
				until
					j > Dimension or Result
				loop
					if field.item (i, j).cell_value = Empty_code then
						Result := True
					end
					j := j + 1
				end
				i := i + 1
			end
		end

feature -- Basic operations
	make_turn (i, j: INTEGER) is
			-- Make turn, filling cell (`i', `j')
		require
			i_not_too_small: i >= 1
			i_not_too_large: i <= Dimension
			j_not_too_small: j >= 1
			j_not_too_large: j <= Dimension
		do
			if item (i, j) = Empty_code then
				if current_turn = Cross_code then
					--field.put (Cross_code, i, j)
					field.item (i, j).make_turn (current_turn)
					current_turn := Circle_code
				else -- current_turn = Circle_code
					--field.put (Circle_code, i, j)
					field.item (i, j).make_turn (current_turn)
					current_turn := Cross_code
				end
				check_game_over
			end
		ensure
			not_same_turn: current_turn /= old current_turn
		end

feature {NONE} -- Implementation
	check_horizontal is
			-- Check if there is a winning combination on horizontal
			-- Set `winner' accordingly
		local
			i: INTEGER
			j: INTEGER
		do
			from
				i := 1
			until
				i > Dimension or has_winner
			loop
				winner := field.item (i, 1).cell_value
				from
					j := 2
				until
					j > Dimension or not has_winner
				loop
					if winner /= field.item (i, j).cell_value then
						winner := Empty_code
					end
					j := j + 1
				end
				i := i + 1
			end
		end

	check_vertical is
			-- Check if there is a winning combination on horizontal
			-- Set `winner' accordingly
		local
			i: INTEGER
			j: INTEGER
		do
			from
				i := 1
			until
				i > Dimension or has_winner
			loop
				winner := field.item (1, i).cell_value
				from
					j := 2
				until
					j > Dimension or not has_winner
				loop
					if winner /= field.item (j, i).cell_value then
						winner := Empty_code
					end
					j := j + 1
				end
				i := i + 1
			end
		end

	check_diagonal is
			-- Check if there is a winning combination on diogonals
			-- Set `winner' accordingly
		local
			i: INTEGER
		do
			winner := field.item (1, 1).cell_value
			from
				i := 2
			until
				i > 3 or not has_winner
			loop
				if winner /= field.item (i, i).cell_value then
					winner := Empty_code
				end
				i := i + 1
			end

			if not has_winner then
				winner := field.item (1, Dimension).cell_value
				from
					i := 2
				until
					i > 3
				loop
					if winner /= field.item (i, Dimension + 1 - i).cell_value then
						winner := Empty_code
					end
					i := i + 1
				end
			end
		end

	check_game_over is
			-- Check if game is over and set `game_over' accordingly
		do
			check_horizontal
			if has_winner then
				is_over := True
			else
				check_vertical
				if has_winner then
					is_over := True
				else
					check_diagonal
					if has_winner then
						is_over := True
					else
						if not has_empty then -- Draw
							is_over := True
						end
					end
				end
			end
		end

	field : ARRAY2 [FIELD_CELL]

	current_turn: INTEGER

invariant
	field_exists: field /= Void
	field_width_correct: field.width = Dimension
	field_height_correct: field.height = Dimension
	current_turn_one_of_two: current_turn = Cross_code or current_turn = Circle_code
	winner_valid: valid_code (winner)
	empty_code_is_default_integer: Empty_code = Empty_code.default
end
