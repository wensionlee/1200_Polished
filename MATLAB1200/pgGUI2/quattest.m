% [r1 r2 r3] = quat2angle([posQue(1,5),posQue(1,2),posQue(1,3),posQue(1,4)],'YZX')
% [r1 r2 r3]*180/pi
% Rx = [1 0 0; 0 cos(r3) -sin(r3); 0 sin(r3) cos(r3)];
% Ry = [cos(r1) 0 sin(r1); 0 1 0; -sin(r1) 0 cos(r1)];
% Rz = [cos(r2) -sin(r2) 0; sin(r2) cos(r2) 0; 0 0 1];
ee = dcm2quat(Rr)
Rrr = quat2dcm(ee)
% Ryzx = Ry*Rz*Rx
[r1 r2 r3] = quat2angle(ee,'YZX')
[r1 r2  r3]*180/pi
