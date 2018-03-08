% %已知：
% 低通滤波器的截止频率 fl = 35Hz；即：通带边缘为35Hz，设定通带纹波1db；
% % 采样频率 fs = 400Hz；
% % 设定阻带边缘为 44Hz，衰减为40DB；
% % Matlab编程：
Fsam = 500; %采样频率
fp = 31; %通带边缘
Rp = 1; %通带纹波
fs = 44; %阻带边缘
As = 15; %阻带衰减
wp = 2*fp/Fsam; %对奈奎斯特频率（fsam/2）归一化 
ws = 2*fs/Fsam; %对奈奎斯特频率（fsam/2）归一化
[n,Wn]= buttord(wp,ws,Rp,As);
[b,a] = butter(n,Wn);
  %输出滤波器的阶数n 
Wn = Wn*Fsam/2; %将归一化的截止频率还原，单位为Hz；
[X,w] = freqz(b,a,512,Fsam); %求取系统频率响应
plot(w,abs(X)) %画解卷绕后的幅频响应
grid on;
title('Butterworth Lowpass Filter');ylabel('幅度');xlabel('频率(Hz)');