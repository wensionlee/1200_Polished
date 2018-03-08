% pr = [0 0 0 1];
% pc = [0 0 0 1];
% 
% Trc = [ r11 r12 r13 xp;
%     r21 r22 r23 yp;
%     r31 r32 r33 zp;
%     0 0 0 1];
% 
% 
% 
% 
% known  = [xr yr zr xc yc zc];
% unknow = [r11 r12];
% 
% 
% f(1) = r11*xc +r12*yc + r13*zc + xp*1 - xr;
% f(2) = r21*xc +r22*yc + r23*zc + yp*1 - yr;
% f(3) = r31*xc +r32*yc + r33*zc + zp*1 - zr;
% 
% lsqnonneg;

% benjin = 0.35;
% sum = 0;
% for i = 0:4
%     sum = 5*1.04^(50-i)+sum
% end
% disp('..............')
% 
% sum = 0;
% for i = 0:4
%     sum = 5+5*(30-i)*0.0475+sum
% end
% 
% disp('..............')
% sum = 0;
% r1 = 1.75/100;
% r2 = 2.25/100;
% r3 = 2.75/100;
% r4 = 2.75/100;
% r5 = 2.75/100;
% rmax = 2.75/100;
%     n = 50;
%     p = 3;
% for i = 0:4
%     m = mod(n-i,p);
%     switch m
%         case 0
%             sum = benjin*(1+rmax*p)^(n/p)+sum;
%         case 4
%             sum = benjin*(1+rmax*p)^floor((n-i)/p)*(1+r4*m)+sum;
%         case 3
%             sum = benjin*(1+rmax*p)^floor((n-i)/p)*(1+r3*m)+sum;
%         case 2
%             sum = benjin*(1+rmax*p)^floor((n-i)/p)*(1+r2*m)+sum;
%         case 1
%             sum = benjin*(1+rmax*p)^floor((n-i)/p)*(1+r1*m)+sum;
%     end
%     sum
% end
% sum
isum = 0;
for i = 1:15
    isum = isum+i;
end
isum
x = (7.6-0.395*15)/0.395/120

