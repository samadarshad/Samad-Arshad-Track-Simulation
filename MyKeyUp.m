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