function d = lineSphereIntersect(o,u,c,r)
%All vectors must be column vectors in three dimensions
    d = zeros(1,2);
    t1 = -dot(u,o-c);
    t2 = sqrt(t1^2 - (norm(u)^2*(norm(o-c)^2-r^2)));
    d(1) = (t1 + t2)/(norm(u)^2);
    d(2) = (t1 - t2)/(norm(u)^2);
end