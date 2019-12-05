% function pal=redblue(n, expon);
%
% passed to colormap() function to set magenta-->blue-->cyan palette
%
% expon is the exponent of coloration. 
% (ie, 1= linear, <1 more blue, >1 more color)
function pal = magentacyanmap(n,expon)
if ~exist('n', 'var')
  n = 32;
end

if ~exist('expon','var')
  expon=1.5;
end
skbottom=[linspace(1,0,n).^expon' zeros(n,1) linspace(0,1,n).^expon'];
sktop=[ones(n,1) zeros(n,1) linspace(1,0,n).^expon'];
pal=[sktop;skbottom];
end