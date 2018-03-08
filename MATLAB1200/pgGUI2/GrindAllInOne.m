clear; clc;clf;figure(1)



% 手眼标定
handeye2; 


% 缺陷检测
faultdetection
a = input('Y','s');

% 点云分割
PntSeg;
% a = input('Y','s');

% 路径规划
pathforpointclouds2


% 机器人通讯
disp('press any to send the data')
a = input('Y','s');
mytcpip4
disp('waiting for action')
a = input('Y','s');

% 发送move指令
fopen(t);
fwrite(t,[0 0],'float') 
fclose(t);
