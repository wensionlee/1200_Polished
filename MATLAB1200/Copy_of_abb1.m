clear
close all

data = load('data1.txt');
st=0.2;
v = data(:,1:3);
v1 = v;
v2 = v;
v1(2:end,:) = v(1:end-1,:);
v2(2:end,:) = v(2:end,:);
v3=v(:,2);

v = (v2-v1);

vn = sqrt(v(:,1).^2+v(:,2).^2+v(:,3).^2)/st;
t = (0:length(vn)-1)*st;
aa = data(:,1);
figure(5)
plot(t,aa,'.')
title('abb a')
axis([0,t(end),0,110])
grid on

c = data(:,2);
figure(3)
plot(t,c)
title('abb c')
grid on
axis([0,t(end),-2,2])

difference = data(:,3);
figure(12)
plot(t,difference)
title('abb difference')
grid on
axis([0,t(end),-10,10])

vdifference = data(:,4);
figure(14)
plot(t,vdifference)
title('vdifference vel')
grid on
axis([0,t(end),-1,1])