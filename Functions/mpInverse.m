function mpInv = mpInverse(A)
%mpInverse returns the Moore-Penrose generalised inverse of A where A is assumed to be a symmetric matrix

    tol = 0.000000001;
    [V,D] = eig(A);
    n=size(D,1);
    mpInv = zeros(size(A',1),size(A',2));
    for i=1:n
        if D(i,i) > tol
            mpInv = mpInv + (1/D(i,i))*(V(:,i)*V(:,i)');
        end
    end
end

