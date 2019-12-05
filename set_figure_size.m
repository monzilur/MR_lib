function set_figure_size(figure_handle,PaperPosition)
% function set_figure_size(figure_handle,PaperPosition)
% default size: [0,0,17.6,20]
    set(figure_handle,'color','w');
    if exist('PaperPosition')
        PP = PaperPosition;
    else
        PP = [0,0,17.6,20]; % Here I set the paper position in centimeters
    end
    PS = PP(end-1:end); % paper size in centimeters

    set(figure_handle,'paperpositionmode','manual','paperposition', ...
        PP,'papersize',PS, 'paperunits','centimeters');

    %if length(varargin)>0
    % So the figure is the same size on the screen as when it is printed:
    pu = get(figure_handle,'PaperUnits');
    pp = get(figure_handle,'PaperPosition');
    set(figure_handle,'Units',pu,'Position',pp)
end