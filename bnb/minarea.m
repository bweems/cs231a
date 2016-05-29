function z=minarea(tl,th,ll,lh,bl,bh,rl,rh)

    if(rl>lh)
        rect_length = rl-lh; 
    else
       rect_length = 1;
    end
    
    if(tl<bh)
        rect_width = -tl+bh;
    else rect_width = 1;
    end
    z = rect_length*rect_width;
end