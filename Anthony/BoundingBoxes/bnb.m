
%Priority Queue
PQ2 = PriorityQueue();

img = imread('original.jpg');
S = double(imread('GMM.png'));

%Normalize Saliency map
%S = S*1.0/max(max(S));

[nocols,norows,z]=size(S);

% sum matrix
summatrix=cumsum(cumsum(S)')';

totalsum=summatrix(nocols,norows);

%Initialization
tlow=1; thi=(nocols); llow=1; lhi=norows; blow=1; bhi=nocols; rlow=1; rhi=norows;

%Tunable Parameter
C=0.2 *nocols*norows;

%Branch and Bound
iter = 0;
while(thi-tlow>0 || lhi-llow>0 || bhi-blow>0 || rhi-rlow>0)
        iter = iter + 1
  
        largest=maxi(thi-tlow,lhi-llow,bhi-blow,rhi-rlow);
      
        switch largest
            case 0
                tlow1=tlow;
                thi1=tlow + floor((thi-tlow)/2);
                tlow2=thi1+1;
                thi2=thi;
                llow1=llow;
                lhi1=lhi;
                llow2=llow;
                lhi2=lhi;
                blow1=blow;
                bhi1=bhi;
                blow2=blow;
                bhi2=bhi;
                rlow1=rlow;
                rhi1=rhi;
                rlow2=rlow;
                rhi2=rhi;
            case 1
                llow1=llow;
                lhi1=llow + floor((lhi-llow)/2);
                llow2=lhi1+1;
                lhi2=lhi;
                tlow1=tlow;
                thi1=thi;
                tlow2=tlow;
                thi2=thi;
                blow1=blow;
                bhi1=bhi;
                blow2=blow;
                bhi2=bhi;
                rlow1=rlow;
                rhi1=rhi;
                rlow2=rlow;
                rhi2=rhi;
            case 2
                blow1=blow;
                bhi1=blow + floor((bhi-blow)/2);
                blow2=bhi1+1;
                bhi2=bhi;
                llow1=llow;
                lhi1=lhi;
                llow2=llow;
                lhi2=lhi;
                tlow1=tlow;
                thi1=thi;
                tlow2=tlow;
                thi2=thi;
                rlow1=rlow;
                rhi1=rhi;
                rlow2=rlow;
                rhi2=rhi;
            case 3
                rlow1=rlow;
                rhi1=rlow + floor((rhi-rlow)/2);
                rlow2=rhi1+1;
                rhi2=rhi;
                llow1=llow;
                lhi1=lhi;
                llow2=llow;
                lhi2=lhi;
                blow1=blow;
                bhi1=bhi;
                blow2=blow;
                bhi2=bhi;
                tlow1=tlow;
                thi1=thi;
                tlow2=tlow;
                thi2=thi;
        end
     
        minarea1=1.0*minarea(tlow1,thi1,llow1,lhi1,blow1,bhi1,rlow1,rhi1);
        minarea2=1.0*minarea(tlow2,thi2,llow2,lhi2,blow2,bhi2,rlow2,rhi2);

        max1=1.0*maxs(tlow1,thi1,llow1,lhi1,blow1,bhi1,rlow1,rhi1,summatrix);
        max2=1.0*maxs(tlow2,thi2,llow2,lhi2,blow2,bhi2,rlow2,rhi2,summatrix);

        f1=(max1/totalsum) + (max1/(C+minarea1));
        f2=(max2/totalsum) + (max2/(C+minarea2));
       
        x1=[f1,tlow1,thi1,llow1,lhi1,blow1,bhi1,rlow1,rhi1];
        x2=[f2,tlow2,thi2,llow2,lhi2,blow2,bhi2,rlow2,rhi2];

        PQ2.push(-x1(1),x1);
        PQ2.push(-x2(1),x2);
        z = PQ2.pop();
        
             tlow=z(2);
             thi=z(3);
             llow=z(4);
             lhi=z(5);
             blow=z(6);
             bhi=z(7);
             rlow=z(8);
             rhi=z(9);
        
        

end


%% Showing the output
figure

load clown

imagesc(img)
colormap(map)
axis off
%show box in image
hold on
x1 = floor(llow - (rhi-llow)*0.1);
y1 = floor(tlow - (bhi-tlow)*0.1);
xr = ceil((rhi-llow)*1.2);
yr = ceil((bhi-tlow)*1.2);
rectangle('Position',[x1 y1 xr yr ], 'LineWidth',2, 'EdgeColor','b');
set(gca,'position',[0 0 1 1],'units','normalized')
f=getframe(gca)
[X, map] = frame2im(f);


%% Cropping the saliency Map
figure
S1 = zeros(nocols,norows);
S1(y1:y1+yr,x1:x1+xr) = S(y1:y1+yr,x1:x1+xr);
set(gca,'position',[0 0 1 1],'units','normalized')
imshow(S1,[])
                
            
                
        

        
                

