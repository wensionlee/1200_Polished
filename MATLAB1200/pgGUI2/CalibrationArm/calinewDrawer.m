clear
clc
aveXX = 0;
ntest = 1; % 标定运算次数 一般1次就可以
for ii = 1:ntest;
    rawP = [ %   标定板坐标
        4 7  0;
        5 6 0;
        8 5 0;
        9 4 0;
        11 3 0;
        2 3 0;
        4 4 0;
        6 5 0;
        9 7 0;
        12 9 0;
        ];
    p = rawP;
    p = p*30;  % 标定板1格30mm
    p(:,3) = -250; % z轴不标定,给一个任意值.
    % % % % % % % % % % % % % % % % % % % % % %
    
    rawAng = [ % 电机角度 舵机读数
        45.98 173.99 0
        53.08 173.46 0
        57.24 158.08 0
        60.82 153.68 0
        59.82 139.32 0
        71.20 201.9 0
        65.85 187.41 0
        59.28 171.33 0
        43.96 141.64 0
        20.58 95.27 0
        ];
    
    
    rawAng(:,3) = 272 *360/4095;  % 舵机角度换算
    Ang = rawAng;
    Ang(:,1) = -Ang(:,1);  % 1轴角度翻转
    Ang = Ang*pi/180; % 转弧度
    
    yy2 = [Ang,p];  % 标定求解
    xxx = [0 288.54 71.7 262.9 ... % 标定方程初始值
        0 0 pi/2 -pi/2 ...
        0 -223 0 -50 ...
        0 0 0 -pi/2 ...
        -300 -300 300];
    
    lb = [-300 200.54 61.7 202.9 0-0.01 0-0.01 pi/2-0.01 -340 -380 -10 -100 -0.1 -0.1 -0.1 ]; % 下界
    ub = [0 388.54 171.7 362.9 0+0.01 0+0.01 pi/2+0.01 340 -180 10 10 0.1 0.1 0.1]; % 上界    
    
    options = optimoptions(@lsqnonlin,'MaxFunEvals',10000,'Display','iter'); %'Algorithm','levenberg-marquardt'
    [xx2,resnorm,residual,exitflag,output]  = lsqnonlin(@(xx) funForKine4(xx,yy2),xxx+rand(1,19)*0,[],[],options);
    aveXX = aveXX+xx2;
    
end

aveXX = aveXX/ntest;

% 打印参数
disp(['a1 =' num2str(aveXX(2))])
disp(['a2 =' num2str(aveXX(3))])
disp(['a3 =' num2str(aveXX(4))])
disp(['d1 =' num2str(aveXX(10))])
disp(['d3 =' num2str(aveXX(12))])

disp(['xw =' num2str(aveXX(17))])
disp(['yw =' num2str(aveXX(18))])
disp(['zw =' num2str(aveXX(19))])

disp(['theta10 =' num2str(aveXX(13)*180/pi)])
disp(['theta20 =' num2str(aveXX(14)*180/pi)])
disp(['theta30 =' num2str(aveXX(15)*180/pi)])


% 标定结果绘图
a1 = aveXX(2); a2 = aveXX(3); a3 = aveXX(4);
d1 = aveXX(10); d3 = aveXX(12);
robot = [a1 a2 a3 d1 d3];
Ang(:,1) = Ang(:,1)+aveXX(13);
Ang(:,2) = Ang(:,2)+aveXX(14);
for i=1: size(rawAng,1)
    ppp(i,:) = idrawer_fk(robot, Ang(i,:));
end

clf
hold off
figure(1)
ppp(:,1) =ppp(:,1)+aveXX(17);
ppp(:,2) =ppp(:,2)+aveXX(18);
plot(ppp(:,1),ppp(:,2),'b.'); %蓝点,标定结果的正运动结果
hold on
plot(p(:,1),p(:,2),'r.'); %红点,标定板

