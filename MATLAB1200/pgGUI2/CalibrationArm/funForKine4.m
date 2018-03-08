function f= funForKine4(x,y)
% a
a0 = 0; % x(1)
a1 = x(2);
a2 = x(3);
a3 = x(4);
% alpha
alpha0 = 0;  % x(5)
alpha1 = 0; %x(6)
alpha2 = pi/2; % x(7)
alpha3 = -pi/2; % X(8)
% d
d0 = 0; %x(9)
d1 = x(10); 
d2 = 0; % x(11)
d3 = x(12);
% theta0
theta10 = x(13);
theta20 = x(14);
theta30 = 0;%x(15);
theta40 = 0; % x(16)
% world offset
xw = x(17);
yw = x(18);
zw = x(19);

ny = 2;
f = zeros(1,ny*size(y,1));
for i = 1:size(y,1)
    theta1 = y(i,1);
    theta2 = y(i,2);
    theta3 = y(i,3);
    xx = y(i,4);
    yy = y(i,5);
    zz = y(i,6);
%     f(i*ny-1) = -xx +a0 + a3*(cos(theta3)*(cos(theta1)*cos(theta2) - cos(alpha1)*sin(theta1)*sin(theta2)) - cos(alpha2)*sin(theta3)*(cos(theta1)*sin(theta2) + cos(alpha1)*cos(theta2)*sin(theta1)) + sin(alpha1)*sin(alpha2)*sin(theta1)*sin(theta3)) + a2*(cos(theta1)*cos(theta2) - cos(alpha1)*sin(theta1)*sin(theta2)) + a1*cos(theta1) - d3*(sin(theta3)*(cos(theta1)*cos(theta2) - cos(alpha1)*sin(theta1)*sin(theta2)) + cos(alpha2)*cos(theta3)*(cos(theta1)*sin(theta2) + cos(alpha1)*cos(theta2)*sin(theta1)) - sin(alpha1)*sin(alpha2)*cos(theta3)*sin(theta1)) + d1*sin(alpha1)*sin(theta1) + d2*sin(alpha2)*(cos(theta1)*sin(theta2) + cos(alpha1)*cos(theta2)*sin(theta1)) + d2*cos(alpha2)*sin(alpha1)*sin(theta1);
%     f(i*ny) = -yy+a2*(cos(alpha0)*cos(theta2)*sin(theta1) - sin(alpha0)*sin(alpha1)*sin(theta2) + cos(alpha0)*cos(alpha1)*cos(theta1)*sin(theta2)) - a3*(sin(alpha2)*sin(theta3)*(cos(alpha1)*sin(alpha0) + cos(alpha0)*sin(alpha1)*cos(theta1)) - cos(theta3)*(cos(alpha0)*cos(theta2)*sin(theta1) - sin(alpha0)*sin(alpha1)*sin(theta2) + cos(alpha0)*cos(alpha1)*cos(theta1)*sin(theta2)) + cos(alpha2)*sin(theta3)*(sin(alpha0)*sin(alpha1)*cos(theta2) + cos(alpha0)*sin(theta1)*sin(theta2) - cos(alpha0)*cos(alpha1)*cos(theta1)*cos(theta2))) - d0*sin(alpha0) - d3*(sin(theta3)*(cos(alpha0)*cos(theta2)*sin(theta1) - sin(alpha0)*sin(alpha1)*sin(theta2) + cos(alpha0)*cos(alpha1)*cos(theta1)*sin(theta2)) + sin(alpha2)*cos(theta3)*(cos(alpha1)*sin(alpha0) + cos(alpha0)*sin(alpha1)*cos(theta1)) + cos(alpha2)*cos(theta3)*(sin(alpha0)*sin(alpha1)*cos(theta2) + cos(alpha0)*sin(theta1)*sin(theta2) - cos(alpha0)*cos(alpha1)*cos(theta1)*cos(theta2))) - d1*cos(alpha1)*sin(alpha0) + d2*sin(alpha2)*(sin(alpha0)*sin(alpha1)*cos(theta2) + cos(alpha0)*sin(theta1)*sin(theta2) - cos(alpha0)*cos(alpha1)*cos(theta1)*cos(theta2)) + a1*cos(alpha0)*sin(theta1) - d2*cos(alpha2)*(cos(alpha1)*sin(alpha0) + cos(alpha0)*sin(alpha1)*cos(theta1)) - d1*cos(alpha0)*sin(alpha1)*cos(theta1);
% %     f(i*ny) = -zz+d3*(sin(alpha2)*cos(theta3)*(cos(alpha0)*cos(alpha1) - sin(alpha0)*sin(alpha1)*cos(theta1)) - sin(theta3)*(cos(alpha0)*sin(alpha1)*sin(theta2) + sin(alpha0)*cos(theta2)*sin(theta1) + cos(alpha1)*sin(alpha0)*cos(theta1)*sin(theta2)) + cos(alpha2)*cos(theta3)*(cos(alpha0)*sin(alpha1)*cos(theta2) - sin(alpha0)*sin(theta1)*sin(theta2) + cos(alpha1)*sin(alpha0)*cos(theta1)*cos(theta2))) + a3*(cos(theta3)*(cos(alpha0)*sin(alpha1)*sin(theta2) + sin(alpha0)*cos(theta2)*sin(theta1) + cos(alpha1)*sin(alpha0)*cos(theta1)*sin(theta2)) + sin(alpha2)*sin(theta3)*(cos(alpha0)*cos(alpha1) - sin(alpha0)*sin(alpha1)*cos(theta1)) + cos(alpha2)*sin(theta3)*(cos(alpha0)*sin(alpha1)*cos(theta2) - sin(alpha0)*sin(theta1)*sin(theta2) + cos(alpha1)*sin(alpha0)*cos(theta1)*cos(theta2))) + d0*cos(alpha0) + a2*(cos(alpha0)*sin(alpha1)*sin(theta2) + sin(alpha0)*cos(theta2)*sin(theta1) + cos(alpha1)*sin(alpha0)*cos(theta1)*sin(theta2)) + d1*cos(alpha0)*cos(alpha1) - d2*sin(alpha2)*(cos(alpha0)*sin(alpha1)*cos(theta2) - sin(alpha0)*sin(theta1)*sin(theta2) + cos(alpha1)*sin(alpha0)*cos(theta1)*cos(theta2)) + a1*sin(alpha0)*sin(theta1) + d2*cos(alpha2)*(cos(alpha0)*cos(alpha1) - sin(alpha0)*sin(alpha1)*cos(theta1)) - d1*sin(alpha0)*sin(alpha1)*cos(theta1);
f(i*ny-1) = -xx + a0 + xw + a1*cos(theta1 + theta10) + a2*(cos(theta1 + theta10)*cos(theta2 + theta20) - sin(theta1 + theta10)*sin(theta2 + theta20)*cos(alpha1)) + a3*(cos(theta3 + theta30)*(cos(theta1 + theta10)*cos(theta2 + theta20) - sin(theta1 + theta10)*sin(theta2 + theta20)*cos(alpha1)) - sin(theta3 + theta30)*cos(alpha2)*(cos(theta1 + theta10)*sin(theta2 + theta20) + cos(theta2 + theta20)*sin(theta1 + theta10)*cos(alpha1)) + sin(theta1 + theta10)*sin(theta3 + theta30)*sin(alpha1)*sin(alpha2)) + d2*sin(alpha2)*(cos(theta1 + theta10)*sin(theta2 + theta20) + cos(theta2 + theta20)*sin(theta1 + theta10)*cos(alpha1)) + d1*sin(theta1 + theta10)*sin(alpha1) + d3*cos(alpha3)*(sin(alpha2)*(cos(theta1 + theta10)*sin(theta2 + theta20) + cos(theta2 + theta20)*sin(theta1 + theta10)*cos(alpha1)) + sin(theta1 + theta10)*cos(alpha2)*sin(alpha1)) + d3*sin(alpha3)*(sin(theta3 + theta30)*(cos(theta1 + theta10)*cos(theta2 + theta20) - sin(theta1 + theta10)*sin(theta2 + theta20)*cos(alpha1)) + cos(theta3 + theta30)*cos(alpha2)*(cos(theta1 + theta10)*sin(theta2 + theta20) + cos(theta2 + theta20)*sin(theta1 + theta10)*cos(alpha1)) - cos(theta3 + theta30)*sin(theta1 + theta10)*sin(alpha1)*sin(alpha2)) + d2*sin(theta1 + theta10)*cos(alpha2)*sin(alpha1);
f(i*ny) = -yy+ yw - d0*sin(alpha0) + a2*(cos(theta2 + theta20)*sin(theta1 + theta10)*cos(alpha0) - sin(theta2 + theta20)*sin(alpha0)*sin(alpha1) + cos(theta1 + theta10)*sin(theta2 + theta20)*cos(alpha0)*cos(alpha1)) - a3*(sin(theta3 + theta30)*cos(alpha2)*(sin(theta1 + theta10)*sin(theta2 + theta20)*cos(alpha0) + cos(theta2 + theta20)*sin(alpha0)*sin(alpha1) - cos(theta1 + theta10)*cos(theta2 + theta20)*cos(alpha0)*cos(alpha1)) - cos(theta3 + theta30)*(cos(theta2 + theta20)*sin(theta1 + theta10)*cos(alpha0) - sin(theta2 + theta20)*sin(alpha0)*sin(alpha1) + cos(theta1 + theta10)*sin(theta2 + theta20)*cos(alpha0)*cos(alpha1)) + sin(theta3 + theta30)*sin(alpha2)*(cos(alpha1)*sin(alpha0) + cos(theta1 + theta10)*cos(alpha0)*sin(alpha1))) - d3*cos(alpha3)*(cos(alpha2)*(cos(alpha1)*sin(alpha0) + cos(theta1 + theta10)*cos(alpha0)*sin(alpha1)) - sin(alpha2)*(sin(theta1 + theta10)*sin(theta2 + theta20)*cos(alpha0) + cos(theta2 + theta20)*sin(alpha0)*sin(alpha1) - cos(theta1 + theta10)*cos(theta2 + theta20)*cos(alpha0)*cos(alpha1))) + a1*sin(theta1 + theta10)*cos(alpha0) - d1*cos(alpha1)*sin(alpha0) - d2*cos(alpha2)*(cos(alpha1)*sin(alpha0) + cos(theta1 + theta10)*cos(alpha0)*sin(alpha1)) + d2*sin(alpha2)*(sin(theta1 + theta10)*sin(theta2 + theta20)*cos(alpha0) + cos(theta2 + theta20)*sin(alpha0)*sin(alpha1) - cos(theta1 + theta10)*cos(theta2 + theta20)*cos(alpha0)*cos(alpha1)) + d3*sin(alpha3)*(sin(theta3 + theta30)*(cos(theta2 + theta20)*sin(theta1 + theta10)*cos(alpha0) - sin(theta2 + theta20)*sin(alpha0)*sin(alpha1) + cos(theta1 + theta10)*sin(theta2 + theta20)*cos(alpha0)*cos(alpha1)) + cos(theta3 + theta30)*cos(alpha2)*(sin(theta1 + theta10)*sin(theta2 + theta20)*cos(alpha0) + cos(theta2 + theta20)*sin(alpha0)*sin(alpha1) - cos(theta1 + theta10)*cos(theta2 + theta20)*cos(alpha0)*cos(alpha1)) + cos(theta3 + theta30)*sin(alpha2)*(cos(alpha1)*sin(alpha0) + cos(theta1 + theta10)*cos(alpha0)*sin(alpha1))) - d1*cos(theta1 + theta10)*cos(alpha0)*sin(alpha1);
% z = zw + a3*(cos(theta3 + theta30)*(cos(theta2 + theta20)*sin(theta1 + theta10)*sin(alpha0) + sin(theta2 + theta20)*cos(alpha0)*sin(alpha1) + cos(theta1 + theta10)*sin(theta2 + theta20)*cos(alpha1)*sin(alpha0)) + sin(theta3 + theta30)*cos(alpha2)*(cos(theta2 + theta20)*cos(alpha0)*sin(alpha1) - sin(theta1 + theta10)*sin(theta2 + theta20)*sin(alpha0) + cos(theta1 + theta10)*cos(theta2 + theta20)*cos(alpha1)*sin(alpha0)) + sin(theta3 + theta30)*sin(alpha2)*(cos(alpha0)*cos(alpha1) - cos(theta1 + theta10)*sin(alpha0)*sin(alpha1))) + d0*cos(alpha0) + a2*(cos(theta2 + theta20)*sin(theta1 + theta10)*sin(alpha0) + sin(theta2 + theta20)*cos(alpha0)*sin(alpha1) + cos(theta1 + theta10)*sin(theta2 + theta20)*cos(alpha1)*sin(alpha0)) + d3*cos(alpha3)*(cos(alpha2)*(cos(alpha0)*cos(alpha1) - cos(theta1 + theta10)*sin(alpha0)*sin(alpha1)) - sin(alpha2)*(cos(theta2 + theta20)*cos(alpha0)*sin(alpha1) - sin(theta1 + theta10)*sin(theta2 + theta20)*sin(alpha0) + cos(theta1 + theta10)*cos(theta2 + theta20)*cos(alpha1)*sin(alpha0))) + d1*cos(alpha0)*cos(alpha1) + a1*sin(theta1 + theta10)*sin(alpha0) + d2*cos(alpha2)*(cos(alpha0)*cos(alpha1) - cos(theta1 + theta10)*sin(alpha0)*sin(alpha1)) - d2*sin(alpha2)*(cos(theta2 + theta20)*cos(alpha0)*sin(alpha1) - sin(theta1 + theta10)*sin(theta2 + theta20)*sin(alpha0) + cos(theta1 + theta10)*cos(theta2 + theta20)*cos(alpha1)*sin(alpha0)) - d3*sin(alpha3)*(cos(theta3 + theta30)*cos(alpha2)*(cos(theta2 + theta20)*cos(alpha0)*sin(alpha1) - sin(theta1 + theta10)*sin(theta2 + theta20)*sin(alpha0) + cos(theta1 + theta10)*cos(theta2 + theta20)*cos(alpha1)*sin(alpha0)) - sin(theta3 + theta30)*(cos(theta2 + theta20)*sin(theta1 + theta10)*sin(alpha0) + sin(theta2 + theta20)*cos(alpha0)*sin(alpha1) + cos(theta1 + theta10)*sin(theta2 + theta20)*cos(alpha1)*sin(alpha0)) + cos(theta3 + theta30)*sin(alpha2)*(cos(alpha0)*cos(alpha1) - cos(theta1 + theta10)*sin(alpha0)*sin(alpha1))) - d1*cos(theta1 + theta10)*sin(alpha0)*sin(alpha1);

end
% f(1)=3*x(1)-cos(x(2)*z)+y(i,1);
% f(2)=x(1)^2-81*(x(2)+0.1)^2+sin(z)+y(i,2);
% f(3)=exp(-x(1)*x(2))+20*z+y(i,3);
end

