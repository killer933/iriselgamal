clear all
clc
DATADIR='D:\www\';
SYSDIR='d:\why';
TESTDIR='d:\why\PolyU_Palmprint_ROI5\';
TESTDIR2='d:\why\PolyU_Palmprint_ROI5\';
cd(SYSDIR);
dirinfo=dir(DATADIR);
Name={dirinfo.name};
Name(1:2)=[];

[nouse num_of_person]=size(Name);
pics={};
person={};
for person_cnt=1:2 %num_of_person

    temp=Name(person_cnt);
    temp=char(temp);
    Name(person_cnt)={horzcat(DATADIR,temp)};
    savename1=temp;

    mkdir(TESTDIR2,savename1);
    subdir2=horzcat(TESTDIR2,savename1);
    palmData(person_cnt).name=Name{person_cnt};          
    
    subdirinfo=dir(char(Name(person_cnt)));              
    filename={subdirinfo.name};
    filename(1:2)=[];
     
    [nouse num_of_img]=size(filename);
    
     counter=0;
   for file_cnt=1:num_of_img
%    for file_cnt=1:6
            
        temp1=filename{file_cnt};
        check=find(temp1=='T');
        if isempty(check)
            counter=counter+1;
            palmData(person_cnt).files{file_cnt}=filename{file_cnt};
            temp=horzcat(Name{person_cnt},'\',filename{file_cnt});
            palm=imread(temp);
            org=get_angle_polypalm(palm);
            org=imresize(org,[128 128],'bicubic');
            savename2=horzcat(subdir2,'\',sprintf('%s',filename{file_cnt}));
            imwrite(org,savename2,'bmp');
         %   disp('writing');
           pics{1,file_cnt}=imresize(palm,[128 128],'bicubic');
           pics{2,file_cnt}=org;
        end
    end 
    savename=[];
  
% pic1=cat(2,pics{1,1},pics{1,2},pics{1,3},pics{1,4},pics{1,5},pics{1,6});
% pic2=cat(2,pics{2,1},pics{2,2},pics{2,3},pics{2,4},pics{2,5},pics{2,6});
% pic=cat(1,pic1,pic2);
% imshow(pic)
    
    picMat=[];
for j=1:6
    b=pics{2,j};
    tempp=b(:)';
    picMat=[picMat; tempp];  %把ROI矩阵序列化成行向量，且六个行向量组成一个矩阵
%     pics{2,j}= pics{2,j}';
end
picMat=im2double(picMat);    %归一化
%picMat=picMat-repmat(mean(picMat),[6,1]);%减去平均脸

alphabet = [1 0 -1];
prob = [1/6 2/3 1/6];
u=randsrc(100,128*128,[alphabet; prob]);  %投影矩阵为100*16384维
vectors=u*double(picMat');
vectors(vectors>=0) = 3;  %为加密做准备
vectors(vectors<0) = 5;
person{1,person_cnt}=vectors;  %将每个人的六张图片的特征向量存储为一个100*6的矩阵明文
end

%D =pdist2(person{1,1}(:,5)',person{1,1}(:,3)','hamming') %特征向量明文的汉明距离

%ElGamal 加密方案，取p=150001，本原元a=7，密钥d=113，  y=a^d mod p=66436
%cipertext={};
%素数p=19,生成元a=2,私钥d=9,则公钥y=2^9 mod 19=18
AAA=rand(100,6);

p=19;    %   150001;
a=2;    %7;
d=9;
pk=mc(a,d,p);    %基于二分法的降幂乘运算

cipertext=zeros(2,100,6,2);
for person_cnt=1:2
    for i=1:100
        for j=1:6
           k= unidrnd(10);
           c1=mc(a, k, p);    %mod(a^k,p)   基于二分法的降幂乘运算
           c2=person{1,person_cnt}(i,j)*mc(pk, k, p);  %mod(person{1,person_cnt}(i,j)*66436^k,p);
           cipertext(person_cnt,i,j,1)=c1;
           cipertext(person_cnt,i,j,2)=c2;  
        end
    end
end

%比对解密阶段
c=ones(100,1);
counter=0;
 
 for person_cnt=1:2
     for j=1:6
         for q=1:6
           for i=1:100
       ciptime1=cipertext(1,i,j,1).*cipertext(person_cnt,i,q,1);   %a
       ciptime2=cipertext(1,i,j,2).*cipertext(person_cnt,i,q,2);   %b
     result=inv_ele(ciptime1^d, p);
     c(i,1)=mod(ciptime2*result,p);
               if mod(c(i,1),15)==0
                  counter=counter+1;
               end
            end
        
 %disp(['第' num2str(1) '个人的第' num2str(j) '幅掌纹图像与第' num2str(person_cnt) '个人的第' num2str(q) '幅掌纹图像的海明距离为：' num2str(counter/100)]); 
%counter=0;

 disp(['The Hamming distance between the ' num2str(j) ' palmprint of the ' num2str(1) ' person and the '  num2str(q) ' palmprint of the ' num2str(person_cnt) ' person is: ' num2str(counter/100)]); 
counter=0;
          end
     end
 end

