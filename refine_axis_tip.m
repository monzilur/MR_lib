function refine_axis_tip()
%REFINE_AXIS_TIP Summary of this function goes here
%   function refine_axis_tip()
axis([min(get(gca,'xlim')) max(get(gca,'XTick'))*1.1 min(get(gca,'ylim')) max(get(gca,'YTick'))*1.1]);
end

