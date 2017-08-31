function file_class(suffix)
% if nargin==0 %default value
%     bTest = 0;
%     suffix='*.bmp';
% elseif nargin < 2
%     bTest = 0;
% end

if(nargin<1)
    suffix='*.bmp';
end

% if bTest == 0 % ����ѵ������
% %     fatherPath='ORL\train';
% else
% %     fatherPath='ORL\test';
% end

fatherPath='www';
subfiles = dir(fullfile(fatherPath,'',suffix));   
for ii = 1:length(subfiles)
    filename = subfiles(ii).name;
    if ~isdir(filename)
        dd=filename(7:8);
        if isempty(dir([fatherPath '\' dd]))   % ����Ŀ¼�Ƿ���
            mkdir([fatherPath '\' dd]);        % ����Ŀ¼
        end
        ofn = [fatherPath '\' filename];             % Դ�ļ�ȫ·����
        nfn = [fatherPath,'\',dd,'\',filename];      % Ŀ���ļ�ȫ·����
        
        copyfile(ofn,nfn);          % �����ļ�
        delete(ofn);                % ɾ��Դ�ļ�
    end
    
end

% %��һ���ļ�������ļ������ļ������ิ�Ƶ���ͬ���ļ���
% pth = 'd:\tem\';        % ·��
% fns = '*.bmp';          % ��չ��      
% % 
% fdt = dir([pth fns]);   % �����·���µ�ָ����չ���ļ�
% for k = 1:length(fdt)
%     fn = fdt(k).name;
%     if ~isdir(fn)       % �����Ƿ�Ŀ¼����Ŀ¼����
%         dd = fn(1);     % �ļ����ĵ�һ���ַ���ΪĿ¼��
%         if isempty(dir([pth dd]))   % ����Ŀ¼�Ƿ���
%             mkdir([pth dd]);        % ����Ŀ¼
%         end
%         ofn = [pth fn];             % Դ�ļ�ȫ·����
%         nfn = [pth dd '\' fn];      % Ŀ���ļ�ȫ·����
%         copyfile(ofn,nfn);          % �����ļ�
%         delete(ofn);                % ɾ��Դ�ļ�
%     end
% end

% %����ȥ����β�Ķ���ո�
% str = deblank(str)
% 
% %��1�����⼸���ַ��������Ʊ���ָ��ģ���������������
% S = regexp(str, '\t', 'split')
% 
% %��2������Щ�ַ�������һ�������ո�ָ��ģ�������������ʽ��������
% S = regexp(str, '\s+', 'split')
% str='orl_001_001.bmp';
% S = regexp(str, '_', 'split');%�õ�����cell����
% cc=str2num(char(S(2)));