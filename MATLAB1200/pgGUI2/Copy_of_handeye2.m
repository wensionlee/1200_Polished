function [sCal,Te2h] = handeye2()
% 5月11号数据 亲测可用
% 手眼数据
eye0 = [ 
    30,273,-881;
    172,212,-754;
    98,193,-743;
    -26,72,-738;
    224,121-755;
    154,262,-814;
    -41,304,764;
    -88,189,-713;
    3,136,-727;
    -8,214,-749;
    75,239,-781;

    ];
eye = ones(size(eye0,1),4);
eye(:,1:3) = eye0;
hand0 = [
    523,46,208;
    522,-141,181;
    549,-54,182;
    673,62,148;
    618,-200,134;
    439,-123,136;
    425,98,218;
    567,159,231;
    619,53,190;
    524,64,199;
    481,-27,168;
    
    
    

];
hand = ones(size(hand0,1),4);
hand(:,1:3) = hand0;
% hand 所有点到第一个点的距离
for i = 1:size(hand,1)
    dh(i) = norm(hand(i,:)-hand(1,:));
end
% eye 所有点到第一个点的距离
for i = 1:size(eye,1)
    de(i) = norm(eye(i,:)-eye(1,:));
end
% 距离比值，也就是缩放比例
sCal = mean(dh(2:end)./de(2:end));
% eye 乘以缩放系数
eye(:,1:3) = eye(:,1:3)*sCal;

% 用最小二乘求解Te2h
lb = [-1.001,-1.001,-1.001,-2000];
ub = [1.001,1.001,1.001,2000];
options = optimoptions(@lsqlin,'Algorithm','interior-point','Display','iter');
r1 = lsqlin(eye,hand(:,1),[],[],[],[],lb,ub,[0.1 0.1 0.1 1]);
r2 = lsqlin(eye,hand(:,2),[],[],[],[],lb,ub,[0.1 0.1 0.1 1]);
r3 = lsqlin(eye,hand(:,3),[],[],[],[],lb,ub,[0.1 0.1 0.1 1]);

Te2h = [r1';r2';r3';0,0,0,1];
disp('calibration done')

% 误差分析
Htest = Te2h*eye';
Err = mean(mean(abs((Htest(1:3,:) - hand(:,1:3)')./hand(:,1:3)'*100)))
ErrM = Htest(1:3,:) - hand(:,1:3)';
% plot3(hand(:,1),hand(:,2),hand(:,3),'bx'); hold on
% plot3(Htest(1,:),Htest(2,:),Htest(3,:),'rx'); hold off
% plot3(eye(:,1),eye(:,2),eye(:,3),'bx');
,% xlabel('x');ylabel('y');zlabel('z')