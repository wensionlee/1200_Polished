function [blob] = PntSeg(data,ROIbox)
% 标定
[sCal,Te2h] = handeye2();
% 读取目标区域数据
% pointsScanRaw = load('C:\PartialReconstruct\AB.xyz');
pointsSampled = data;
% ttt = load('C:\PartialReconstruct\ABC.xyz');
% pointsScanRaw = ttt(:,1:3);
disp('data read')
% handles.figure1.UserData.ROIbox = [xtop ytop xbnt ytop xbnt ybnt xtop ybnt];
rangeBox = pointsSampled(:,1)>ROIbox(1) & pointsSampled(:,1)<ROIbox(2) & ...
    pointsSampled(:,2)>ROIbox(3) & pointsSampled(:,2)<ROIbox(4) & ...
    pointsSampled(:,3)>10 & pointsSampled(:,3)<1000;
pointsInBox = pointsSampled(rangeBox,:);

% 点云包分割，最终默认判断最大的是目标物体
pointsInboxTmp = pointsInBox;
rNeibor = 10;
nPointsInboxTmp = size(pointsInboxTmp,1);
iBlobSeed = randperm(nPointsInboxTmp,1);

blobSeed = pointsInboxTmp(iBlobSeed,:);
pointsInboxTmp(iBlobSeed,:) = [];
blob{1} = blobSeed;

nPointsInboxTmp = size(pointsInboxTmp,1);
cSeeds{1} = blobSeed;

nCSeeds = size(cSeeds{1},1);
while nCSeeds ~= 0
    nextSeeds{1} = [];
    for iCSeeds = 1:nCSeeds
        seed = cSeeds{1}(iCSeeds,:);
        cneibor{1} = [];
        cNeiborIndex{1} = [];
        for i = 1:nPointsInboxTmp
            distant =  norm (pointsInboxTmp(i,:) - seed);
            if distant < rNeibor
                cneibor{1} = [cneibor{1} ;pointsInboxTmp(i,:)];
                cNeiborIndex{1} = [cNeiborIndex{1} i];
            end
        end
        pointsInboxTmp(cNeiborIndex{1},:) = [];
        nPointsInboxTmp = size(pointsInboxTmp,1);
        blob{1} = [blob{1}; cneibor{1}];
        nextSeeds{1} = [nextSeeds{1}; cneibor{1}];
    end
    cSeeds{1} = nextSeeds{1};
    nCSeeds = size(cSeeds{1},1);
end
nPointsInboxTmp = size(pointsInboxTmp,1);
% clf;
plot3(blob{1}(:,1),blob{1}(:,2),blob{1}(:,3),'rx')
axis equal
hold off