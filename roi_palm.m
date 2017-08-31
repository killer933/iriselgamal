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
    picMat=[picMat; tempp];  %��ROI�������л��������������������������һ������
%     pics{2,j}= pics{2,j}';
end
picMat=im2double(picMat);    %��һ��
%picMat=picMat-repmat(mean(picMat),[6,1]);%��ȥƽ����

alphabet = [1 0 -1];
prob = [1/6 2/3 1/6];
u=randsrc(100,128*128,[alphabet; prob]);  %ͶӰ����Ϊ100*16384ά
vectors=u*double(picMat');
vectors(vectors>=0) = 3;  %Ϊ������׼��
vectors(vectors<0) = 5;
person{1,person_cnt}=vectors;  %��ÿ���˵�����ͼƬ�����������洢Ϊһ��100*6�ľ�������
end

%D =pdist2(person{1,1}(:,5)',person{1,1}(:,3)','hamming') %�����������ĵĺ�������

%ElGamal ���ܷ�����ȡp=150001����ԭԪa=7����Կd=113��  y=a^d mod p=66436
%cipertext={};
%����p=19,����Ԫa=2,˽Կd=9,��Կy=2^9 mod 19=18
AAA=rand(100,6);

p=19;    %   150001;
a=2;    %7;
d=9;
pk=mc(a,d,p);    %���ڶ��ַ��Ľ��ݳ�����

cipertext=zeros(2,100,6,2);
for person_cnt=1:2
    for i=1:100
        for j=1:6
           k= unidrnd(10);
           c1=mc(a, k, p);    %mod(a^k,p)   ���ڶ��ַ��Ľ��ݳ�����
           c2=person{1,person_cnt}(i,j)*mc(pk, k, p);  %mod(person{1,person_cnt}(i,j)*66436^k,p);
           cipertext(person_cnt,i,j,1)=c1;
           cipertext(person_cnt,i,j,2)=c2;  
        end
    end
end

%�ȶԽ��ܽ׶�
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
        
 %disp(['��' num2str(1) '���˵ĵ�' num2str(j) '������ͼ�����' num2str(person_cnt) '���˵ĵ�' num2str(q) '������ͼ��ĺ�������Ϊ��' num2str(counter/100)]); 
%counter=0;

 disp(['The Hamming distance between the ' num2str(j) ' palmprint of the ' num2str(1) ' person and the '  num2str(q) ' palmprint of the ' num2str(person_cnt) ' person is: ' num2str(counter/100)]); 
counter=0;
          end
     end
 end

