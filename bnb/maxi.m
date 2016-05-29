
function y=maxi(a,b,c,d)
if(b>=a && b>=c && b>=d)
    y=1;
elseif (a>=c && a>=d && a>=b)
    y=0;
elseif (c>=d && c>=a && c>=b)
    y=2;
else
    y=3;
end
end