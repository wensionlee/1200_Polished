clear; clc;clf;figure(1)



% ���۱궨
handeye2; 


% ȱ�ݼ��
faultdetection
a = input('Y','s');

% ���Ʒָ�
PntSeg;
% a = input('Y','s');

% ·���滮
pathforpointclouds2


% ������ͨѶ
disp('press any to send the data')
a = input('Y','s');
mytcpip4
disp('waiting for action')
a = input('Y','s');

% ����moveָ��
fopen(t);
fwrite(t,[0 0],'float') 
fclose(t);
