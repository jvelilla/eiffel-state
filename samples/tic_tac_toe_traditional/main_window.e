indexing
    description : "Main window for this application"
    author      : "Dmitry Kochelaev"
    date        : "$Date$"
    revision    : "$Revision$"

class
    MAIN_WINDOW

inherit
    EV_TITLED_WINDOW
        redefine
            initialize
        end

    INTERFACE_NAMES
        export
            {NONE} all
        undefine
            default_create, copy
        end
create
    default_create

feature {NONE} -- Initialization
    initialize is
            -- Build the interface for this window.
        do
            Precursor {EV_TITLED_WINDOW}

--            create {INTERCHANGE_MANAGER} game_manager
            create {WINNER_FIRST_MANAGER} game_manager

            build_main_container
            extend (main_container)
            close_request_actions.extend (agent close_window)
            set_title (Window_title)
            set_size (Window_width, Window_height)

            game_manager.start_new_game
        end

feature {NONE} -- Model
    game_manager: GAME_MANAGER
            -- Game manager

    update_buttons is
            -- Update `buttons' according to `game'
        local
            i, j: INTEGER
        do
            from
                i := 1
            until
                i > {GAME}.Dimension
            loop
                from
                    j := 1
                until
                    j > {GAME}.Dimension
                loop
                    buttons.item (i, j).set_text (game_manager.current_game.item (i, j).out)
                    j := j + 1
                end
                i := i + 1
            end
        end

    on_button_click (i: INTEGER; j: INTEGER) is
            -- Process i j button click
        require
            i_not_too_small: i >= 1
            i_not_too_large: i <= {GAME}.Dimension
            j_not_too_small: j >= 1
            j_not_too_large: j <= {GAME}.Dimension
        do
            game_manager.current_game.make_turn (i, j)
            update_buttons
            if game_manager.current_game.is_over then
                request_new_game
            end
        end

feature {NONE} -- View
    build_main_container is
            -- Create and populate `main_container'.
        require
            main_container_not_yet_created: main_container = Void
        local
            i: INTEGER
            j: INTEGER
            button: EV_BUTTON
            vertical_boxes: ARRAY [EV_VERTICAL_BOX]
        do
            create main_container
            create vertical_boxes.make (1, {GAME}.Dimension)
            create buttons.make ({GAME}.Dimension, {GAME}.Dimension)

            from
                j := 1
            until
                j > {GAME}.Dimension
            loop
                vertical_boxes.put (create {EV_VERTICAL_BOX}, j)
                main_container.extend (vertical_boxes.item (j))
                from
                    i := 1
                until
                    i > {GAME}.Dimension
                loop
                    create button
                    buttons.put (button, i, j)
                    button.select_actions.extend (agent on_button_click (i, j))
                    vertical_boxes.item (j).extend (button)
                    i := i + 1
                end
                j := j + 1
            end
        ensure
            main_container_created: main_container /= Void
        end


    request_new_game is
            -- Ask, whether user wants to start new game
        local
            question_dialog: EV_CONFIRMATION_DIALOG
        do
            create question_dialog.make_with_text (Label_confirm_new_game)
            question_dialog.show_modal_to_window (Current)

            if question_dialog.selected_button.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_ok) then
                game_manager.start_new_game
                update_buttons
            else
                close_window
            end
        end

    close_window is
            -- Close the window
        do
            destroy;
            (create {EV_ENVIRONMENT}).application.destroy
        end

    main_container: EV_HORIZONTAL_BOX
            -- Main container (contains all widgets displayed in this window)

    buttons: ARRAY2 [EV_BUTTON]
            -- Buttons for cells

feature {NONE} -- Constants

    Window_title: STRING is "Tic Tac Toe sample. Implemented using automata-based programming (manual, static)."
            -- Title of the window.

    Window_width: INTEGER is 400
            -- Initial width for this window.

    Window_height: INTEGER is 400
            -- Initial height for this window.

invariant
    game_manager_exists: game_manager /= Void
    main_container_exists: main_container /= Void
    buttons_exists: buttons /= Void
    each_button_exists: not buttons.has (Void)
end -- class MAIN_WINDOW
