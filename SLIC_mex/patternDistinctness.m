function [pd] = patternDistinctness(l, Sp, coeff)
    pd = [];
    avg_p = 0;
    for i=1:max(l(:))
        total_dist = 0;
        p1 = Sp(i);
        a = [p1.L; p1.a; p1.b];
        a_pca = coeff * a;
        for j=1:max(l(:))
            p2 = Sp(j);
            b = [p2.L; p2.a; p2.b];
            b_pca = coeff * b;
            total_dist = total_dist + distance(a_pca, b_pca);
        end
        pd = [pd total_dist];
    end
end

function [dist] = distance(a, b)
    dist = sum(abs(a - b));
end