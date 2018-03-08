% clear;
% % 读取数据
% [fout, pTri, vTri] = ReadSTLACSII('door.stl');
% % 数据通道，调整面朝上
% xyz = [1 3 2];
% % 去除重复点，因为是stl文件。若是点云，可以跳过
% [pUni, IA, IC] = unique(pTri,'rows','sorted');
% % 定义法向量
% vUni = zeros(size(pUni));
% % cutter curve
% CC = zeros(size(pUni));
% nRad = 10;
% clf;
% for i = 1:size(pUni,1)
%     %     求解点的法向量
%     ineibor = find(IC(IA(i))==IC);
%     vUni(i,:) = mean(vTri(ineibor,:));
%     %     根据法向量，推算CC
%     CC = pUni+vUni*nRad;
%     %     plot3(CC(i,1),CC(i,2),CC(i,3),'.','color',-vUni(i,:)*0.5+0.5);
%     %     plot3(pUni(i,1),pUni(i,2),pUni(i,3),'.','color',vUni(i,:)*0.5+0.5);
% end
clf
% 初次插值
pUni = blob{1};
% 测试用，可以改变目标区域
pUni(:,1) = pUni(:,1); 
pUni(:,2) = pUni(:,2);
pUni(:,3) = pUni(:,3);
% plot3(pUni(:,1),pUni(:,2),pUni(:,3),'rx');
xyz = [1 2 3];
% 准备拟合曲面
tx = min(pUni(:,xyz(1))):1:max(pUni(:,xyz(1)));
ty = min(pUni(:,xyz(2))):1:max(pUni(:,xyz(2)));
[cx, cy] = meshgrid(tx,ty);
% 得到z轴的拟合值
cz=griddata(pUni(:,xyz(1)),pUni(:,xyz(2)),pUni(:,xyz(3)),cx,cy,'natural');

% 中值滤波

cz = medfilt2(cz,[7,7]);

% mesh(cx,cy,cz);axis equal; xlabel('x');ylabel('y');zlabel('z'); %hold on;
% 计算面的法向量
[vx,vy,vz] = surfnorm(cx,cy,cz);

% 去除法向量nan
cz(isnan(vz)) = NaN;

% 提升加工面
pcx = cx(isnan(cz) == 0);
pcy = cy(isnan(cz) == 0);
pcz = cz(isnan(cz) == 0);
vcx = vx(isnan(cz) == 0);
vcy = vy(isnan(cz) == 0);
vcz = vz(isnan(cz) == 0);
vc = [vcx,vcy,vcz];
pc = [pcx,pcy,pcz];
% 刀具半径10，可以为0
pc = pc+vc*3;

% 第二次插值 准备拟合加工曲面
tx = min(pc(:,1)):1:max(pc(:,1));
ty = min(pc(:,2)):1:max(pc(:,2));
[cx, cy] = meshgrid(tx,ty);
% 得到z轴的拟合值--加工曲面
cz=griddata(pc(:,1),pc(:,2),pc(:,3),cx,cy,'natural');
% cz = medfilt2(cz,[11,11]);
% mesh(cx,cy,cz);hold on;
% pause;
% 计算面的法向量 -- 加工曲面
[vx,vy,vz] = surfnorm(cx,cy,cz);
% 去除法向量nan -- 加工曲面
cz(isnan(vz)) = NaN;


% plot3(pUni(:,xyz(1)),pUni(:,xyz(2)),pUni(:,xyz(3)),'.');
% hold on;
% xlabel('x');ylabel('y');zlabel('z')

% clf

% 计算轨迹 
% 提取路径
% 轨迹间隔
gap = 5; % odd number
% 边缘空白
iini = 4;
% 扫描线数量
nx = ceil((size(cx,2)-iini*2)/gap)+1;
% cc是个cell容器，用来存放每一条轨迹
cc = cell(1,nx*2-1);
% 是否是轨迹起点
isstart = 0;
% 轨迹起点对应的mesh网格的y坐标
istart = 0;
% 轨迹终点对应的mesh网格的y坐标
iend = 0;
% 扫描方向
isforward = 1;
% 线间隔轨迹
linegap = zeros(gap+1,6);
for i = 1:nx-2;
    %     扫描方向，决定迭代计数的方向
    if isforward == 1
        js = 1;
        je = length(ty);
        jt = 1;
    else
        js = length(ty);
        je = 1;
        jt = -1;
    end
    %     开始在y方向搜索
    for j = js:jt:je
        %         是否找到起点？
        if isstart == 0
            %             没找到起点就找起点
            if isnan(cz(j,(i-1)*gap+iini)) == 0 && isnan(vz(j,(i-1)*gap+iini)) == 0
                %                 找到后标志位置1，且记录位置
                isstart = 1;
                istart = j;
            end
        else
            %             找到起点的情况，就找终点
            if isnan(cz(j,(i-1)*gap+iini)) == 1  || isnan(vz(j,(i-1)*gap+iini)) == 1
                %                 找到后起点置0，记录终点
                isstart = 0;
                iend = j-jt;
                %                 把值写入cc
                cc{i*2-1} = [cx(istart:jt:iend,(i-1)*gap+iini),...
                    cy(istart:jt:iend,(i-1)*gap+iini),...
                    cz(istart:jt:iend,(i-1)*gap+iini),...
                    vx(istart:jt:iend,(i-1)*gap+iini),...
                    vy(istart:jt:iend,(i-1)*gap+iini),...
                    vz(istart:jt:iend,(i-1)*gap+iini)];
                %                 开始反向找
                isforward = ~isforward;
                if isforward == 1
                    ms = 1;
                    me = length(ty);
                    mt = 1;
                else
                    ms = length(ty);
                    me = 1;
                    mt = -1;
                end
                %                 从这一点到下一条轨迹的起点
                linegap(1,:) = cc{i*2-1}(end,:);
                for k = 2:size(linegap,1)
                    for m = ms:mt:me
                        if isnan(cz(m,(i-1)*gap+iini+k-1)) == 0 && isnan(vz(m,(i-1)*gap+iini+k-1)) == 0
                            linegap(k,:) = [cx(m,(i-1)*gap+iini+k-1),...
                                cy(m,(i-1)*gap+iini+k-1),...
                                cz(m,(i-1)*gap+iini+k-1),...
                                vx(m,(i-1)*gap+iini+k-1),...
                                vy(m,(i-1)*gap+iini+k-1),...
                                vz(m,(i-1)*gap+iini+k-1)];
                            break;
                        end
                    end
                end
                cc{i*2} = linegap;
                break;
            end
            %             如果没找到，已到边界
            if j == je
                isstart = 0;
                iend = j;
                cc{i*2-1} = [cx(istart:jt:iend,(i-1)*gap+iini),...
                    cy(istart:jt:iend,(i-1)*gap+iini),...
                    cz(istart:jt:iend,(i-1)*gap+iini),...
                    vx(istart:jt:iend,(i-1)*gap+iini),...
                    vy(istart:jt:iend,(i-1)*gap+iini),...
                    vz(istart:jt:iend,(i-1)*gap+iini)];
                isforward = ~isforward;
                if isforward == 1
                    ms = 1;
                    me = length(ty);
                    mt = 1;
                else
                    ms = length(ty);
                    me = 1;
                    mt = -1;
                end
                linegap(1,:) = cc{i*2-1}(end,:);
                for k = 2:size(linegap,1)
                    for m = ms:mt:me
                        if isnan(cz(m,(i-1)*gap+iini+k-1)) == 0 && isnan(vz(m,(i-1)*gap+iini+k-1)) == 0
                            linegap(k,:) = [cx(m,(i-1)*gap+iini+k-1),...
                                cy(m,(i-1)*gap+iini+k-1),...
                                cz(m,(i-1)*gap+iini+k-1),...
                                vx(m,(i-1)*gap+iini+k-1),...
                                vy(m,(i-1)*gap+iini+k-1),...
                                vz(m,(i-1)*gap+iini+k-1)];
                            break;
                        end
                    end
                end
                cc{i*2} = linegap;
            end
        end
    end
    
    %     pause;
end


i = nx-1;
%     扫描方向，决定迭代计数的方向
if isforward == 1
    js = 1;
    je = length(ty);
    jt = 1;
else
    js = length(ty);
    je = 1;
    jt = -1;
end
%     开始在y方向搜索
for j = js:jt:je
    %         是否找到起点？
    if isstart == 0
        %             没找到起点就找起点
        if isnan(cz(j,(i-1)*gap+iini)) == 0 && isnan(vz(j,(i-1)*gap+iini)) == 0
            %                 找到后标志位置1，且记录位置
            isstart = 1;
            istart = j;
        end
    else
        %             找到起点的情况，就找终点
        if isnan(cz(j,(i-1)*gap+iini)) == 1 || isnan(vz(j,(i-1)*gap+iini)) == 1
            %                 找到后起点置0，记录终点
            isstart = 0;
            iend = j-jt;
            %                 把值写入cc
            cc{i*2-1} = [cx(istart:jt:iend,(i-1)*gap+iini),...
                cy(istart:jt:iend,(i-1)*gap+iini),...
                cz(istart:jt:iend,(i-1)*gap+iini),...
                vx(istart:jt:iend,(i-1)*gap+iini),...
                vy(istart:jt:iend,(i-1)*gap+iini),...
                vz(istart:jt:iend,(i-1)*gap+iini)];
            %                 开始反向找
            isforward = ~isforward;
            break;
        end
        %             如果没找到，已到边界
        if j == je
            isstart = 0;
            iend = j;
            cc{i*2-1} = [cx(istart:jt:iend,(i-1)*gap+iini),...
                cy(istart:jt:iend,(i-1)*gap+iini),...
                cz(istart:jt:iend,(i-1)*gap+iini),...
                vx(istart:jt:iend,(i-1)*gap+iini),...
                vy(istart:jt:iend,(i-1)*gap+iini),...
                vz(istart:jt:iend,(i-1)*gap+iini)];
            isforward = ~isforward;
        end
    end
end

%     pause;




% 最后一个间隔轨迹
linegaplast = zeros(size(cx,2)-iini+1 - ((nx-2)*gap+iini)+1,6);

if isforward == 1
    ms = 1;
    me = length(ty);
    mt = 1;
else
    ms = length(ty);
    me = 1;
    mt = -1;
end
linegaplast(1,:) = cc{(nx-1)*2-1}(end,:);
kk = 0;
for k = 2:size(linegaplast,1)
    for m = ms:mt:me
        if isnan(cz(m,(nx-2)*gap+iini+k-1)) == 0 && isnan(vz(m,(nx-2)*gap+iini+k-1)) == 0
            kk = k;
            linegaplast(k,:) = ...
                [cx(m,(nx-2)*gap+iini+k-1),...
                cy(m,(nx-2)*gap+iini+k-1),...
                cz(m,(nx-2)*gap+iini+k-1),...
                vx(m,(nx-2)*gap+iini+k-1)....
                vy(m,(nx-2)*gap+iini+k-1),...
                vz(m,(nx-2)*gap+iini+k-1)];
            break;
        end
    end
end
% linegaplast(end,:) = cc{end}(1,:);
cc{(nx-1)*2} = linegaplast(1:kk,:);

% 最后一条线轨迹
i = nx;
if isforward == 1
    js = 1;
    je = length(ty);
    jt = 1;
else
    js = length(ty);
    je = 1;
    jt = -1;
end
for j = js:jt:je
    if isstart == 0
        if isnan(cz(j,size(cx,2)-iini+1)) == 0 && isnan(vz(j,size(cx,2)-iini+1)) == 0
            isstart = 1;
            istart = j;
        end
    else
        if isnan(cz(j,size(cx,2)-iini+1)) == 1 || isnan(vz(j,size(cx,2)-iini+1)) == 1
            isstart = 0;
            iend = j-jt;
            cc{i*2-1} = [cx(istart:jt:iend,size(cx,2)-iini+1),...
                cy(istart:jt:iend,size(cx,2)-iini+1),...
                cz(istart:jt:iend,size(cx,2)-iini+1),...
                vx(istart:jt:iend,size(cx,2)-iini+1),...
                vy(istart:jt:iend,size(cx,2)-iini+1),...
                vz(istart:jt:iend,size(cx,2)-iini+1)];
            isforward = ~isforward;
            break;
        end
        if j == je
            isstart = 0;
            iend = j;
            cc{i*2-1} = [cx(istart:jt:iend,size(cx,2)-iini+1),...
                cy(istart:jt:iend,size(cx,2)-iini+1),...
                cz(istart:jt:iend,size(cx,2)-iini+1),...
                vx(istart:jt:iend,size(cx,2)-iini+1),...
                vy(istart:jt:iend,size(cx,2)-iini+1),...
                vz(istart:jt:iend,size(cx,2)-iini+1)];
            isforward = ~isforward;
        end
    end
end

% 绘制轨迹
for iplot = 1:size(cc,2)
    if isempty(cc{iplot}) ~=1  %double check if the path is empty
        plot3(cc{iplot}(:,1),cc{iplot}(:,2),cc{iplot}(:,3),'b');
%         pause;
%         plot(cc{iplot}(:,2),cc{iplot}(:,3));
    end
    hold on
end
axis equal
xlabel('x');ylabel('y');zlabel('z');



