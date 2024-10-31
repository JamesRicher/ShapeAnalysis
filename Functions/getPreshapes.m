function preshapes = getPreshapes(shapes,type)
%getPreshapes takes in a collection of configurations and returns a matrix of pre-shapes (k-1)xm matrices or centred-pre shapes kxn matrices

    k = size(shapes,1);
    m = size(shapes,2);
    n = size(shapes,3);

    switch type
        case "helmert"
            H = helm(k);
            preshapes = zeros(k-1,m,n);
            for i = 1:n
                preshapes(:,:,i) = H*shapes(:,:,i);
                preshapes(:,:,i) = preshapes(:,:,i)/(norm(preshapes(:,:,i),'fro'));
            end
        case "centred"
            preshapes = scaleShapes(translateShapes(shapes));
    end
end

