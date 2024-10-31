function tris = getRandomTriangles(n)
    tris = zeros(3,2,n);
    for i=1:n
        for j=1:3
            tris(j,:,i) = [normrnd(0, 1) normrnd(0,1)];
        end
    end
end

