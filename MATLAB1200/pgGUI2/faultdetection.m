filelist = dir('C:\Users\SZAR\Desktop\imageandpc\*U0.bmp'); % �м��ٴβ���ʱ��Ӧ��ɾ�����ļ����е���������
img = imread(['C:\Users\SZAR\Desktop\imageandpc\',filelist.name]);

% filelist = dir('C:\Users\SZAR\Desktop\img1\*U0.bmp'); % �м��ٴβ���ʱ��Ӧ��ɾ�����ļ����е���������
% img = imread(['C:\Users\SZAR\Desktop\img1\',filelist.name]);

% filelist = dir('C:\Users\SZAR\Desktop\img2\*U0.bmp'); % �м��ٴβ���ʱ��Ӧ��ɾ�����ļ����е���������
% img = imread(['C:\Users\SZAR\Desktop\img2\',filelist.name]);

img0 = imread('compare.bmp');  % ԭͼ
imgsub = img0-img;
[hei,wid] = size(img);
disp('image loaded')

% ������
imgsub(imgsub<80) = 0;
BW=edge(imgsub,'canny',0.7);
b = bwboundaries(BW);

sizeOfCon = zeros(size(b,1),1);
for i=1:size(b,1)
    sizeOfCon(i) = size(b{i},1);
end
% ��������ж�ΪĿ������
[aa, sd] = max(sizeOfCon);
disp('fault detected')
% д�߽�����
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
% ����BOX
des = drawRect(img,[ytop xtop],[ybnt-ytop xbnt-xtop],2 );
redes = imresize(des,0.3);
hold off
imshow(redes)
disp('please wait until commond line prompt')
% ���в����ع�����
open('C:\PartialReconstruct\PartialReconstruct.exe')

