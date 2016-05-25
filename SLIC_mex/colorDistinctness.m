function [cd] = colorDistinctness(l, Sp)
    cd = [];
    for i=1:max(l(:))
        total_dist = 0;
        p1 = Sp(i);
        for j=1:max(l(:))
            p2 = Sp(j);
            total_dist = total_dist + distance(p1, p2);
        end
        cd = [cd total_dist];
    end
end

function [dist] = distance(p1, p2)
    a = [p1.L, p1.a, p1.b];
    b = [p2.L, p2.a, p2.b];
    dist = sqrt(sum((a - b) .^ 2));
end