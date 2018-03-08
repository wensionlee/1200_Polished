filelist = dir('C:\Users\SZAR\Desktop\imageandpc\*U0.bmp'); % 切记再次测量时，应当删除该文件夹中的所有内容
img = imread(['C:\Users\SZAR\Desktop\imageandpc\',filelist.name]);

% filelist = dir('C:\Users\SZAR\Desktop\img1\*U0.bmp'); % 切记再次测量时，应当删除该文件夹中的所有内容
% img = imread(['C:\Users\SZAR\Desktop\img1\',filelist.name]);

% filelist = dir('C:\Users\SZAR\Desktop\img2\*U0.bmp'); % 切记再次测量时，应当删除该文件夹中的所有内容
% img = imread(['C:\Users\SZAR\Desktop\img2\',filelist.name]);

img0 = imread('compare.bmp');  % 原图
imgsub = img0-img;
[hei,wid] = size(img);
disp('image loaded')

% 找轮廓
imgsub(imgsub<80) = 0;
BW=edge(imgsub,'canny',0.7);
b = bwboundaries(BW);

sizeOfCon = zeros(size(b,1),1);
for i=1:size(b,1)
    sizeOfCon(i) = size(b{i},1);
end
% 最大轮廓判断为目标特征
[aa, sd] = max(sizeOfCon);
disp('fault detected')
% 写边界坐标
xbnt = max(b{sd}(:,1))+40;
ybnt = max(b{sd}(:,2))+50;
xtop = min(b{sd}(:,1))-40;
ytop = min(b{sd}(:,2))-50;
feabox = [xtop ytop xbnt ybnt];
fid = fopen('C:\PartialReconstruct\quavertex.txt','w+');
ROIBox = [ytop xtop ybnt xtop ybnt xbnt ytop xbnt];
fprintf(fid,'%d %d %d %d %d %d %d %d',ROIBox);
fclose(fid);
disp('ROI sent');
% 绘制BOX
des = drawRect(img,[ytop xtop],[ybnt-ytop xbnt-xtop],2 );
redes = imresize(des,0.3);
hold off
imshow(redes)
disp('please wait until commond line prompt')
% 运行部分重构程序
open('C:\PartialReconstruct\PartialReconstruct.exe')

