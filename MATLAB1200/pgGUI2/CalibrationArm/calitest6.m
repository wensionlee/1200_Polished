clear
clc
aveXX = 0;
ntest = 1; % �궨������� һ��1�ξͿ���
for ii = 1:ntest;
    rawP = [ %   �궨������
        2 9 0;
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
    p = p*30;  % �궨��1��30mm
    p(:,3) = -250; % z�᲻�궨,��һ������ֵ.
    % % % % % % % % % % % % % % % % % % % % % %
    
    rawAng = [ % ����Ƕ� �������
        26.496		163.796		291
        42.726		170.378		280
        50.335		171.363		276
        57.276		158.778		268
        62.062		156.496		264
        63.262		144.606		258
        61.852		200.046		267
        61.090		185.910		269
        57.379		171.412		271
        44.818		142.366		275
        23.758		97.682		277
        ];
    
    
    rawAng(:,3) = 272 *360/4095;  % ����ǶȻ���
    Ang = rawAng;
    Ang(:,1) = -Ang(:,1);  % 1��Ƕȷ�ת
    Ang = Ang*pi/180; % ת����
    
    yy2 = [Ang,p];  % �궨���
    xxx = [0 288.54 71.7 262.9 ... % �궨���̳�ʼֵ
        0 0 pi/2 -pi/2 ...
        0 -223 0 -50 ...
        0 0 0 -pi/2 ...
        -300 -300 300];
    
    lb = [-300 200.54 61.7 202.9 0-0.01 0-0.01 pi/2-0.01 -340 -380 -10 -100 -0.1 -0.1 -0.1 ]; % �½�
    ub = [0 388.54 171.7 362.9 0+0.01 0+0.01 pi/2+0.01 340 -180 10 10 0.1 0.1 0.1]; % �Ͻ�    
    
    options = optimoptions(@lsqnonlin,'MaxFunEvals',10000,'Display','iter'); %'Algorithm','levenberg-marquardt'
    [xx2,resnorm,residual,exitflag,output]  = lsqnonlin(@(xx) funForKine4(xx,yy2),xxx+rand(1,19)*0,[],[],options);
    aveXX = aveXX+xx2;
    
end

aveXX = aveXX/ntest;

% ��ӡ����
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


% �궨�����ͼ
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
plot(ppp(:,1),ppp(:,2),'b.'); %����,�궨��������˶����
hold on
plot(p(:,1),p(:,2),'r.'); %���,�궨��

