function T = panel_annotation(subplot_position,annotation_string,position_offset)
% function panel_annotation(subplot_position,annotation_string,position_offset)
% defaults:
% 'FontName','Arial','FontSize',18,'LineStyle','none'
if length(position_offset) ==1
    position_offset(2) = position_offset(1);
end
T = annotation('textbox','Position',subplot_position-...
    [[subplot_position(3)*position_offset(1) -subplot_position(4)*position_offset(2)/2] 0 0],...
    'string',annotation_string,'FontName','Arial','FontSize',18,...
    'LineStyle','none');
end