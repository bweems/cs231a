imshow(I2);
hold on;

x1 = bbs(1,1);
x2 = bbs(1,1) + bbs(1,3);
y1 = bbs(1,2);
y2 = bbs(1,2) + bbs(1,4);

plot([x1 y1],[x1 y2],'g')
plot([x1 y2],[x2 y2],'g')
plot([x2 y1],[x2 y2],'g')
plot([x2 y2],[x1 y1],'g')