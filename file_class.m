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

% if bTest == 0 % 读入训练数据
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
        if isempty(dir([fatherPath '\' dd]))   % 检验目录是否建立
            mkdir([fatherPath '\' dd]);        % 建立目录
        end
        ofn = [fatherPath '\' filename];             % 源文件全路径名
        nfn = [fatherPath,'\',dd,'\',filename];      % 目标文件全路径名
        
        copyfile(ofn,nfn);          % 拷贝文件
        delete(ofn);                % 删除源文件
    end
    
end

% %把一个文件夹里的文件按照文件名归类复制到不同的文件夹
% pth = 'd:\tem\';        % 路径
% fns = '*.bmp';          % 扩展名      
% % 
% fdt = dir([pth fns]);   % 调入此路径下的指定扩展名文件
% for k = 1:length(fdt)
%     fn = fdt(k).name;
%     if ~isdir(fn)       % 检验是否目录，是目录跳过
%         dd = fn(1);     % 文件名的第一个字符作为目录名
%         if isempty(dir([pth dd]))   % 检验目录是否建立
%             mkdir([pth dd]);        % 建立目录
%         end
%         ofn = [pth fn];             % 源文件全路径名
%         nfn = [pth dd '\' fn];      % 目标文件全路径名
%         copyfile(ofn,nfn);          % 拷贝文件
%         delete(ofn);                % 删除源文件
%     end
% end

% %首先去除首尾的多余空格：
% str = deblank(str)
% 
% %例1：设这几个字符串是以制表符分隔的，可以这样来做：
% S = regexp(str, '\t', 'split')
% 
% %例2：设这些字符串是以一个或多个空格分隔的，可以用正则表达式来描述：
% S = regexp(str, '\s+', 'split')
% str='orl_001_001.bmp';
% S = regexp(str, '_', 'split');%得到的是cell数组
% cc=str2num(char(S(2)));