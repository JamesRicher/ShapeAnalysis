function p = plotShapesLabelled(shapes,colour,icon,joinline,closed,width)
%PLOTSHAPES
%   Takes in array of the form k landmarks, m dimensions, n individuals and
%   plots them as a scatter graph.
    k=size(shapes,1);
    m=size(shapes,2);
    n=size(shapes,3);
    
    if joinline == true
        style='-'+icon;
    else
        style=icon;
    end
    
    hold on;
    labels = {'1','2','3','4','5','6','7','8','9','10','11','12','13'};
    %labels = {'1','2','3','4','5','6','7','8'};
    for i=1:n
        h1 = plot(shapes(:,1,i), shapes(:,2,i), style, 'color', colour, 'Linewidth',width);
        %text(shapes(:,1,i), shapes(:,2,i), labels,'SE',0.2,0.2,'FontSize',14);
        labelpoints(shapes(:,1,i),shapes(:,2,i),labels,'E',0.7,'FontSize',14);
        set(h1, 'markerfacecolor',get(h1,'color'));
        if closed
            line(shapes([1 end],1,i), shapes([1 end],2,i),'Color',colour, 'Linewidth',width);
        end
    end
    hold off;
end