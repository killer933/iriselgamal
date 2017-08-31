function [x y]=get_neigh(edg2,x1,y1,x2,y2,flag)

% edg2(x1,y1)=0;
% edg2(x2,y2)=0;
matr = edg2(x1-1:x1+1,y1-1:y1+1);
% matr=matr';
[a b] = find(matr>0);
% if(length(a)>1)
%     a=a(length(a));
%     b=b(length(b));
% end
if(length(a)>=1)
    if flag==1
        x = x1+a(1)-2;
        y = y1+b(1)-2;
    else
        x = x1+a(length(a))-2;
        y = y1+b(length(b))-2;
    end
else
    matr = edg2(x1-2:x1+2,y1-2:y1+2);
%     matr=matr';
    [a b] = find(matr>0);
    if(length(a)>=1)
        if flag==1
            x = x1+a(1)-2;
            y = y1+b(1)-2;
        else
            x = x1+a(length(a))-2;
            y = y1+b(length(b))-2;
        end
    else
        x=[];
        y=[];
    end
end