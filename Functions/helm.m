function helmert = helm(k)
    helmert = zeros(k-1,k);
    
    for i=1:(k-1)
        hi = -1/(sqrt(i*(i+1)));
        helmert(i,1:i) = hi;
        helmert(i,i+1) = -i*hi;
    end
end

