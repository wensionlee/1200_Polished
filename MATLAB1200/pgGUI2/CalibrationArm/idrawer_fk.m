function p = idrawer_fk(robot,t)

a1 = robot(1);
a2 = robot(2);
a3 = robot(3);
d1 = robot(4);
d2 = robot(5);

% a1 = 0.2485; a2 = 0.1; a3 = 0.4; d1 = -0.2485; d2 = -0.08;

t1 = t(1); t2 = t(2); t3 = t(3);

% motorResolution = 0.088*pi/180;
% t1 = round(t1/motorResolution)  *motorResolution;
% t2 = round(t2/motorResolution)  *motorResolution;
% t3 = round(t3/motorResolution)  *motorResolution;



x = a2*cos(t1 + t2) + a1*cos(t1) + a3*cos(t1 + t2)*cos(t3) - d2*cos(t1 + t2)*sin(t3);
y = a2*sin(t1 + t2) + a1*sin(t1) + a3*sin(t1 + t2)*cos(t3) - d2*sin(t1 + t2)*sin(t3);
z = d1 + d2*cos(t3) + a3*sin(t3);
p = [x y z];
end