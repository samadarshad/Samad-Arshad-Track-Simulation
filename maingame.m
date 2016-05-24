function MainGame()
h_obj = figure;

    KeyStatus = false(1,6);    % Suppose you are using 6 keys in the game
    KeyNames = {'w', 'a','s', 'd', 'j', 'k'};
    KEY.UP = 1;
    KEY.DOWN = 2;
    KEY.LEFT = 3;
    KEY.RIGHT = 4;
    KEY.BULLET = 5;
    KEY.BOMB = 6;
    
        gameWin = figure(h_obj,'KeyPressFcn', @MyKeyDown, 'KeyReleaseFcn', @MyKeyUp)
        
    % Main game loop
    while GameNotOver
        if KeyStatus(KEY.UP)  % If left key is pressed
            player.y = player.y - ystep;
        end
        if KeyStatus(KEY.LEFT)  % If left key is pressed
            player.x = player.x - xstep;
        end
        if KeyStatus(KEY.RIGHT)  % If left key is pressed
            %..
        end
        %...
    end

    % Nested callbacks...
        function MyKeyDown(hObject, event, handles)
            key = get(hObject,'CurrentKey');
            % e.g., If 'd' and 'j' are already held down, and key == 's'is
            % pressed now
            % then KeyStatus == [0, 0, 0, 1, 1, 0] initially
            % strcmp(key, KeyNames) -> [0, 0, 1, 0, 0, 0, 0]
            % strcmp(key, KeyNames) | KeyStatus -> [0, 0, 1, 1, 1, 0]
            KeyStatus = (strcmp(key, KeyNames) | KeyStatus);
        end
        function MyKeyUp(hObject, event, handles)
            key = get(hObject,'CurrentKey');
            % e.g., If 'd', 'j' and 's' are already held down, and key == 's'is
            % released now
            % then KeyStatus == [0, 0, 1, 1, 1, 0] initially
            % strcmp(key, KeyNames) -> [0, 0, 1, 0, 0, 0]
            % ~strcmp(key, KeyNames) -> [1, 1, 0, 1, 1, 1]
            % ~strcmp(key, KeyNames) & KeyStatus -> [0, 0, 0, 1, 1, 0]
            KeyStatus = (~strcmp(key, KeyNames) & KeyStatus);
        end

    end