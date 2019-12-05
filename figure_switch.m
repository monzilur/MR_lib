function figure_switch(arg)
%
% Author: Monzilur Rahman
%
% FIGURE_ONOFF Turns DefaultFigureVisible property on and off
%
%   If there is no argument with the function it toggles the property
%   With 'on' or 'off' arguments DefaultFigureVisible property can be set
%   to on and off
%
if exist('arg') == 0
    if strcmp(get(0, 'DefaultFigureVisible'),'on');
        set(0,'DefaultFigureVisible','off');
        disp('Figure turned off');
    else
        set(0,'DefaultFigureVisible','on');
        disp('Figure turned on');
    end
else
    
    switch arg
        case 'off'
            set(0,'DefaultFigureVisible','off');
            disp('Figure turned off');
        case 'on'
            set(0,'DefaultFigureVisible','on');
            disp('Figure turned on');
        otherwise
            disp('Wrong argument of the function figure_switch.');
    end
    
end
end

