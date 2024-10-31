function p = plotShapes(shapes,colour,icon,joinline,closed,width)
%plotShapes takes in array of the form k landmarks, m dimensions, n individuals and plots them as a scatter graph

    k=size(shapes,1);
    m=size(shapes,2);
    n=size(shapes,3);
    
    if joinline == true
        style='-'+icon;
    else
        style=icon;
    end
    
    hold on;
    for i=1:n
        h1 = plot(shapes(:,1,i), shapes(:,2,i), style, 'color', colour, 'Linewidth',width);
        set(h1, 'markerfacecolor',get(h1,'color'));
        if closed
            line(shapes([1 end],1,i), shapes([1 end],2,i),'Color',colour, 'Linewidth',width);
        end
    end
    hold off;
end