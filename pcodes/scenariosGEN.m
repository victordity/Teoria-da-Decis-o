
function scenariosGEN()

m = (1+0.025).^(1:10) - 1;
s = (1+0.012).^(1:10) - 1;
N = 2000;

year = 10;
scenarios = m(year) + s(year)*randn(1,N);
save scen scenarios

minx = min(scenarios); 
maxx = max(scenarios); 
step = (maxx-minx)/10000;
pdf  = normpdf(minx:step:maxx,m(year),s(year));
plot(minx:step:maxx, pdf, 'b-', 'LineWidth', 2)





% % Illustration of the increase in model uncertainty
% m = (1+0.025).^(1:10) - 1;
% s = (1+0.012).^(1:10) - 1;
% 
% hold on
% for k = [1 5 10]
%     year = k;
%     minx = m(year) - 4*s(year); 
%     maxx = m(year) + 4*s(year); 
%     step = (maxx-minx)/10000;
%     pdf  = normpdf(minx:step:maxx,m(year),s(year));    
%     plot(minx:step:maxx, pdf, 'b-', 'LineWidth', 2)
% end
% hold off


