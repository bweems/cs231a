function b=max3(newtop, newleft, newbottom, newright,summatrix)
            if(newtop~=1 && newleft~=1)
                sum1=summatrix(newbottom,newright)+summatrix(newtop-1,newleft-1)-summatrix(newbottom,newleft-1)-summatrix(newtop-1,newright);
            end
            if(newleft==1 && newtop==1)
                sum1=summatrix(newbottom,newright);
            end
            if(newleft==1 && newtop~=1)
                sum1=summatrix(newbottom,newright)-summatrix(newtop-1,newright);
            end
            if(newleft~=1 && newtop==1)
                sum1=summatrix(newbottom,newright)-summatrix(newbottom,newleft-1);
            end
            b=sum1;
end