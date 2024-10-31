function p = plotShapes2(shapes,colour,joinline,closed,width,dotSize)
%PLOTSHAPES
%   Takes in array of the form k landmarks, m dimensions, n individuals and
%   plots them as a scatter graph.
    k=size(shapes,1);
    m=size(shapes,2);
    n=size(shapes,3);
        
    hold on;
    for i=1:n
        h1 = scatter(shapes(:,1,i), shapes(:,2,i), dotSize,colour,"filled");
        
        if joinline
            for j=1:(k-1)
                line(shapes([j j+1],1,i), shapes([j j+1],2,i),'Color',colour, 'Linewidth',width);
            end
        end
        
        if closed
            line(shapes([1 end],1,i), shapes([1 end],2,i),'Color',colour, 'Linewidth',width);
        end
    end
    hold off;
end