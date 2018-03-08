% clear;
% % ��ȡ����
% [fout, pTri, vTri] = ReadSTLACSII('door.stl');
% % ����ͨ���������泯��
% xyz = [1 3 2];
% % ȥ���ظ��㣬��Ϊ��stl�ļ������ǵ��ƣ���������
% [pUni, IA, IC] = unique(pTri,'rows','sorted');
% % ���巨����
% vUni = zeros(size(pUni));
% % cutter curve
% CC = zeros(size(pUni));
% nRad = 10;
% clf;
% for i = 1:size(pUni,1)
%     %     ����ķ�����
%     ineibor = find(IC(IA(i))==IC);
%     vUni(i,:) = mean(vTri(ineibor,:));
%     %     ���ݷ�����������CC
%     CC = pUni+vUni*nRad;
%     %     plot3(CC(i,1),CC(i,2),CC(i,3),'.','color',-vUni(i,:)*0.5+0.5);
%     %     plot3(pUni(i,1),pUni(i,2),pUni(i,3),'.','color',vUni(i,:)*0.5+0.5);
% end
clf
% ���β�ֵ
pUni = blob{1};
% �����ã����Ըı�Ŀ������
pUni(:,1) = pUni(:,1); 
pUni(:,2) = pUni(:,2);
pUni(:,3) = pUni(:,3);
% plot3(pUni(:,1),pUni(:,2),pUni(:,3),'rx');
xyz = [1 2 3];
% ׼���������
tx = min(pUni(:,xyz(1))):1:max(pUni(:,xyz(1)));
ty = min(pUni(:,xyz(2))):1:max(pUni(:,xyz(2)));
[cx, cy] = meshgrid(tx,ty);
% �õ�z������ֵ
cz=griddata(pUni(:,xyz(1)),pUni(:,xyz(2)),pUni(:,xyz(3)),cx,cy,'natural');

% ��ֵ�˲�

cz = medfilt2(cz,[7,7]);

% mesh(cx,cy,cz);axis equal; xlabel('x');ylabel('y');zlabel('z'); %hold on;
% ������ķ�����
[vx,vy,vz] = surfnorm(cx,cy,cz);

% ȥ��������nan
cz(isnan(vz)) = NaN;

% �����ӹ���
pcx = cx(isnan(cz) == 0);
pcy = cy(isnan(cz) == 0);
pcz = cz(isnan(cz) == 0);
vcx = vx(isnan(cz) == 0);
vcy = vy(isnan(cz) == 0);
vcz = vz(isnan(cz) == 0);
vc = [vcx,vcy,vcz];
pc = [pcx,pcy,pcz];
% ���߰뾶10������Ϊ0
pc = pc+vc*3;

% �ڶ��β�ֵ ׼����ϼӹ�����
tx = min(pc(:,1)):1:max(pc(:,1));
ty = min(pc(:,2)):1:max(pc(:,2));
[cx, cy] = meshgrid(tx,ty);
% �õ�z������ֵ--�ӹ�����
cz=griddata(pc(:,1),pc(:,2),pc(:,3),cx,cy,'natural');
% cz = medfilt2(cz,[11,11]);
% mesh(cx,cy,cz);hold on;
% pause;
% ������ķ����� -- �ӹ�����
[vx,vy,vz] = surfnorm(cx,cy,cz);
% ȥ��������nan -- �ӹ�����
cz(isnan(vz)) = NaN;


% plot3(pUni(:,xyz(1)),pUni(:,xyz(2)),pUni(:,xyz(3)),'.');
% hold on;
% xlabel('x');ylabel('y');zlabel('z')

% clf

% ����켣 
% ��ȡ·��
% �켣���
gap = 5; % odd number
% ��Ե�հ�
iini = 4;
% ɨ��������
nx = ceil((size(cx,2)-iini*2)/gap)+1;
% cc�Ǹ�cell�������������ÿһ���켣
cc = cell(1,nx*2-1);
% �Ƿ��ǹ켣���
isstart = 0;
% �켣����Ӧ��mesh�����y����
istart = 0;
% �켣�յ��Ӧ��mesh�����y����
iend = 0;
% ɨ�跽��
isforward = 1;
% �߼���켣
linegap = zeros(gap+1,6);
for i = 1:nx-2;
    %     ɨ�跽�򣬾������������ķ���
    if isforward == 1
        js = 1;
        je = length(ty);
        jt = 1;
    else
        js = length(ty);
        je = 1;
        jt = -1;
    end
    %     ��ʼ��y��������
    for j = js:jt:je
        %         �Ƿ��ҵ���㣿
        if isstart == 0
            %             û�ҵ����������
            if isnan(cz(j,(i-1)*gap+iini)) == 0 && isnan(vz(j,(i-1)*gap+iini)) == 0
                %                 �ҵ����־λ��1���Ҽ�¼λ��
                isstart = 1;
                istart = j;
            end
        else
            %             �ҵ���������������յ�
            if isnan(cz(j,(i-1)*gap+iini)) == 1  || isnan(vz(j,(i-1)*gap+iini)) == 1
                %                 �ҵ��������0����¼�յ�
                isstart = 0;
                iend = j-jt;
                %                 ��ֵд��cc
                cc{i*2-1} = [cx(istart:jt:iend,(i-1)*gap+iini),...
                    cy(istart:jt:iend,(i-1)*gap+iini),...
                    cz(istart:jt:iend,(i-1)*gap+iini),...
                    vx(istart:jt:iend,(i-1)*gap+iini),...
                    vy(istart:jt:iend,(i-1)*gap+iini),...
                    vz(istart:jt:iend,(i-1)*gap+iini)];
                %                 ��ʼ������
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
                %                 ����һ�㵽��һ���켣�����
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
            %             ���û�ҵ����ѵ��߽�
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
%     ɨ�跽�򣬾������������ķ���
if isforward == 1
    js = 1;
    je = length(ty);
    jt = 1;
else
    js = length(ty);
    je = 1;
    jt = -1;
end
%     ��ʼ��y��������
for j = js:jt:je
    %         �Ƿ��ҵ���㣿
    if isstart == 0
        %             û�ҵ����������
        if isnan(cz(j,(i-1)*gap+iini)) == 0 && isnan(vz(j,(i-1)*gap+iini)) == 0
            %                 �ҵ����־λ��1���Ҽ�¼λ��
            isstart = 1;
            istart = j;
        end
    else
        %             �ҵ���������������յ�
        if isnan(cz(j,(i-1)*gap+iini)) == 1 || isnan(vz(j,(i-1)*gap+iini)) == 1
            %                 �ҵ��������0����¼�յ�
            isstart = 0;
            iend = j-jt;
            %                 ��ֵд��cc
            cc{i*2-1} = [cx(istart:jt:iend,(i-1)*gap+iini),...
                cy(istart:jt:iend,(i-1)*gap+iini),...
                cz(istart:jt:iend,(i-1)*gap+iini),...
                vx(istart:jt:iend,(i-1)*gap+iini),...
                vy(istart:jt:iend,(i-1)*gap+iini),...
                vz(istart:jt:iend,(i-1)*gap+iini)];
            %                 ��ʼ������
            isforward = ~isforward;
            break;
        end
        %             ���û�ҵ����ѵ��߽�
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




% ���һ������켣
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

% ���һ���߹켣
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

% ���ƹ켣
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



