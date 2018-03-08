clear
close all

data = load('data6.txt');
st=0.15;
v = data(:,1:3);
v1 = v;
v2 = v;
v1(2:end,:) = v(1:end-1,:);
v2(2:end,:) = v(2:end,:);
v3=v(:,2);

v = (v2-v1);

vn = sqrt(v(:,1).^2+v(:,2).^2+v(:,3).^2)/st;
t = (0:length(vn)-1)*st;
figure(1)
plot(t,vn)
title('matlab vel')
axis([0,t(end),0,14])
grid on

% figure(10)
% plot(t,v3)
% title('Y÷·')
% grid on


acc = zeros(length(vn),1);
acc(2:end) = (vn(2:end)-vn(1:end-1))/st;
figure(2)
plot(t,acc);
title('matlab acc')
axis([0,t(end),-50,50])
grid on

vabb = data(:,4);
figure(3)
plot(t,vabb)
title('abb vel')
grid on
axis([0,t(end),0,15])

accabb = data(:,6);
figure(4)
plot(t,accabb)
title('abb acc')
axis([0,t(end),-50,50])
grid on

accabb = data(:,5);
figure(5)
plot(t,accabb,'.')
title('abb a')
axis([0,t(end),0,110])
grid on

accabb = data(:,7);
figure(6)
plot(t,accabb','.')
% plot(t,accabb)
title('abb vdifference')
axis([0,t(end),-0.5,0.5])
grid on


C = data(:,8);
figure(7)
plot(t,C','.')
% plot(t,accabb)
title('C')
axis([0,t(end),-5,5])
grid on