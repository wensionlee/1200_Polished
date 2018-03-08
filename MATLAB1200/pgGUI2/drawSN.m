
    
        plot3(pc(:,1),pc(:,2),pc(:,3),'x')
%         pause;
%         plot(cc{iplot}(:,2),cc{iplot}(:,3));
    hold on


for iplot = 1:size(pc,1)
    
        plot3([pc(iplot,1), vc(iplot,1)*3+pc(iplot,1)],...
            [pc(iplot,2), vc(iplot,2)*3+pc(iplot,2)],...
            [pc(iplot,3), vc(iplot,3)*3+pc(iplot,3)],'r')
%         pause;
%         plot(cc{iplot}(:,2),cc{iplot}(:,3));[
    hold on
end

axis equal
xlabel('x');ylabel('y');zlabel('z');

