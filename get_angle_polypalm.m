function org=get_angle_w(str)

%参考文献：D. Zhang, W.K. Kong, J. You, M. Wong, On-line palmprint
%identification, IEEE Trans. Patt. Anal. Mach. Intell. 25 pp.1041-1050. 2003
% 过程：
% 1.高斯低通滤波，并二值化
% 2.边缘跟踪找到两个指窝的边界点
% 3.通过计算直线方程找到关键点A.B使得其余的边界点都在直线的一端
% 4.旋转图像并分割ROI
org=str;
fs=fspecial('gaussian',[5 5]);
org=conv2(double(org),fs,'same');
edg=org>28;
edg=medfilt2(edg,[7,7]);
edg1=edg;
edg=edge(uint8(edg),'sobel');

% for i=1:7
%     edg(i,:)=0;           %in case the thumb is out of range 
% end
     
edg(1:7,:)=0;
edg(:,1:25)=0;

%2,find edge and make a sequence along with the outline

edg2=edg;
X1=[];
Y1=[];

% start=1200;   %ahhh,i don't know how to describ this....
start1=45;  %ahhh,i don't know how to describ this....
a=find(edg2(start1,:)>0);
X1=[X1 start1];
Y1=[Y1 a(1)];
edg2(start1,a(1))=0;
if(size(a,2)>1)&(a(2)-a(1))<2
    X1=[X1 start1];
    Y1=[Y1 a(2)];
else
    start1=start1+1;
    a=find(edg2(start1,:)>0);
    X1=[X1 start1];
    Y1=[Y1 a(1)];
end
edg2(start1,a(1))=0;
while(1)
    len=size(X1,2);
    [x y]=get_neigh(edg2,X1(len),Y1(len),X1(len-1),Y1(len-1),1);
    edg2(x,y)=0;
    X1=[X1 x];
    Y1=[Y1 y];
    max_y=max(Y1);
    if (isempty(x))||((max_y>100)&(max_y-Y1(len+1)>10))||(max_y-Y1(len+1)>15)
        break
    end
end
pos=find((Y1-max_y)>-15);
X1=X1(pos);
Y1=Y1(pos);
X1=fliplr(X1);
Y1=fliplr(Y1);

X2=[];
Y2=[];
start2=255;  %ahhh,i don't know how to describ this....
a=find(edg2(start2,:)>0);
X2=[X2 start2];
Y2=[Y2 a(1)];
edg2(start2,a(1))=0;
if(size(a,2)>1)&(a(2)-a(1))<2
    X2=[X2 start2];
    Y2=[Y2 a(2)];
    edg2(start2,a(2))=0;
else
    start2=start2-1;
    a=find(edg2(start2,:)>0);
    X2=[X2 start2];
    Y2=[Y2 a(1)];
    edg2(start2,a(1))=0;
end
while(1)
    len=size(X2,2);
    [x y]=get_neigh(edg2,X2(len),Y2(len),X2(len-1),Y2(len-1),2);
    edg2(x,y)=0;
    X2=[X2 x];
    Y2=[Y2 y];
    max_y=max(Y2);
    if(isempty(x))||(max_y>90&(max_y-Y2(len+1)>10))||(max_y-Y2(len+1)>15)
        break
    end
end
pos=find((Y2-max_y)>-15);
X2=X2(pos);
Y2=Y2(pos);
X2=fliplr(X2);
Y2=fliplr(Y2);

X=[X1 X2];
Y=[Y1 Y2];
for i=1:size(X1,2)
    xx1=X1(i);
    yy1=Y1(i);
    for j=1:size(X2,2)
        xx2=X2(j);
        yy2=Y2(j);
        k=(yy2-yy1)/(xx2-xx1);
        for m=1:size(X,2)
            if Y(m)>k*(X(m)-xx1)+yy1
                break
            end
        end
        if m>=size(X,2)
            break
        end
    end
    if m>=size(X,2)
        break
    end
end
angle = atan(k);%小于0，逆时针旋转，大于0，顺时针旋转
rotation = angle*180/pi;
str=imrotate(str,-rotation);
if angle<0
    angle=-angle;
    x1 = xx1/cos(angle)+(384-xx1*tan(angle)-yy1)*sin(angle);  %384为掌纹图像的宽，284为高
    y1 = yy1/cos(angle)+(xx1-yy1*tan(angle))*sin(angle);
    x2 = xx2/cos(angle)+(384-xx2*tan(angle)-yy2)*sin(angle);
    y2 = yy2/cos(angle)+(xx2-yy2*tan(angle))*sin(angle);
else
    x1 = xx1/cos(angle)+(yy1-xx1*tan(angle))*sin(angle);
    y1 = yy1/cos(angle)+(284-yy1*tan(angle)-xx1)*sin(angle);
    x2 = xx2/cos(angle)+(yy2-xx2*tan(angle))*sin(angle);
    y2 = yy2/cos(angle)+(284-yy2*tan(angle)-xx2)*sin(angle);
end
x1=ceil(x1);
y1=ceil(y1);
x2=ceil(x2);
y2=ceil(y2);
len=x2-x1;
org = str(x1:x2,y1+ceil(len/4):y1+ceil(len/4)+len);
% str(xx1-1:xx1+1,yy1-1:yy1+1)=255;
% str(xx2-1:xx2+1,yy2-1:yy2+1)=255;
% org=str;
return