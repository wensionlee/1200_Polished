% %��֪��
% ��ͨ�˲����Ľ�ֹƵ�� fl = 35Hz������ͨ����ԵΪ35Hz���趨ͨ���Ʋ�1db��
% % ����Ƶ�� fs = 400Hz��
% % �趨�����ԵΪ 44Hz��˥��Ϊ40DB��
% % Matlab��̣�
Fsam = 500; %����Ƶ��
fp = 31; %ͨ����Ե
Rp = 1; %ͨ���Ʋ�
fs = 44; %�����Ե
As = 15; %���˥��
wp = 2*fp/Fsam; %���ο�˹��Ƶ�ʣ�fsam/2����һ�� 
ws = 2*fs/Fsam; %���ο�˹��Ƶ�ʣ�fsam/2����һ��
[n,Wn]= buttord(wp,ws,Rp,As);
[b,a] = butter(n,Wn);
  %����˲����Ľ���n 
Wn = Wn*Fsam/2; %����һ���Ľ�ֹƵ�ʻ�ԭ����λΪHz��
[X,w] = freqz(b,a,512,Fsam); %��ȡϵͳƵ����Ӧ
plot(w,abs(X)) %������ƺ�ķ�Ƶ��Ӧ
grid on;
title('Butterworth Lowpass Filter');ylabel('����');xlabel('Ƶ��(Hz)');