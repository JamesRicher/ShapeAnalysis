function p = plotShapes3(shapes,colour,joinline,closed,width,dotSize)
%PLOTSHAPES
%   Takes in array of the form k landmarks, m dimensions, n individuals and
%   plots them as a scatter graph.
    m=size(shapes,1);
    k=size(shapes,2);
    n=size(shapes,3);
        
    hold on;
    for i=1:n
        h1 = scatter(shapes(1,:,i), shapes(2,:,i), dotSize,colour,"filled");
        
        if joinline
            for j=1:(k-1)
                line(shapes(1,[j j+1],i), shapes(2,[j j+1],i),'Color',colour, 'Linewidth',width);
            end
        end
        
        if closed
            line(shapes(1,[1 end],i), shapes(2,[1 end],i),'Color',colour, 'Linewidth',width);
        end
    end
    hold off;
end