
%D =pdist2(person{1,1}(:,5)',person{1,1}(:,3)','hamming') %�����������ĵĺ�������

%ElGamal ���ܷ�����ȡp=150001����ԭԪa=7����Կd=113��  y=a^d mod p=66436
%cipertext={};
%����p=19,����Ԫa=2,˽Կd=9,��Կy=2^9 mod 19=18
clc;clear
AAA=rand(100,6);
BBB=round(AAA);
CCC=rand(100,6);
DDD=round(CCC);
temppp=xor(BBB,DDD);
key=sum(sum(temppp==1))/600;

BBB(BBB==0) = 3;  %Ϊ������׼��
BBB(BBB==1) = 5;
person{1,1}=BBB;

DDD(DDD==0) = 3;  %Ϊ������׼��
DDD(DDD==1) = 5;
person{1,2}=DDD;
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

