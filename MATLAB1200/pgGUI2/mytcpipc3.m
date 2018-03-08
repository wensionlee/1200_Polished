% a = [1,0,0]; % +x
a = [0,-1,0];  %-Y
t = tcpip('192.168.125.1', 1025, 'NetworkRole', 'client');
t.OutputBufferSize = 1024;
t.ByteOrder = 'littleEndian';

% if strcmp(t.Status,'closed')
fopen(t);
% end
datalen = 16;
% clear the path buffer in robot memory
fwrite(t,[0 1],'float')
while 1
    if t.BytesAvailable >=8
        data = fread(t, t.BytesAvailable);
        break;
    end
end

nSumOfData = 0;
for i= 1:size(cc,2)
    nSumOfData = nSumOfData + size(cc{i},1);
end

posQue = zeros(nSumOfData,datalen);
iPosQue = 1;
for i= 1:size(cc,2)
    for j = 1:size(cc{i},1)
        %         a = [0 -1 0];
        %         b = -cc{i}(j,4:6)/norm(cc{i}(j,4:6));
        %         b(1) = 0;
        %         c = [a(2)*b(3)-a(3)*b(2);...
        %             a(3)*b(1)-a(1)*b(3);...x
        %             a(1)*b(2)-a(2)*b(1)];
        %         c = c/norm(c);
        %         thtaZ = acos(dot(a,b)/(norm(a)*norm(b)));
        %
        %         a = [0 0 -1];
        %         b = -cc{i}(j,4:6)/norm(cc{i}(j,4:6));
        %         b(2) = 0;
        %         c = [a(2)*b(3)-a(3)*b(2);...
        %             a(3)*b(1)-a(1)*b(3);...x
        %             a(1)*b(2)-a(2)*b(1)];
        %         c = c/norm(c);
        %         thtaX = acos(dot(a,b)/(norm(a)*norm(b)));
        %
        %         R1 = pi/2;
        %         R2 = thtaZ;
        %         %R3 = thtaX;
        %         R3 = 0;
        %
        %         Q = angle2quat(R1,R2,R3,'YZX');
        %
        %         posQue(iPosQue,1) = iPosQue;
        %         posQue(iPosQue,2:5) = Q;
        %         posQue(iPosQue,6:8) = cc{i}(j,1:3);
        %         iPosQue = iPosQue+1;
        b = -cc{i}(j,4:6)/norm(cc{i}(j,4:6));
        b(1) = 0;
        c = [a(2)*b(3)-a(3)*b(2);...
            a(3)*b(1)-a(1)*b(3);...x
            a(1)*b(2)-a(2)*b(1)];
        c = c/norm(c);
        thta = acos(dot(a,b)/(norm(a)*norm(b)));
        e1 = c(1)*sin(thta/2);
        e2 = c(2)*sin(thta/2);
        e3 = c(3)*sin(thta/2);
        e4 = cos(thta/2);
        [R1,R2,R3]=quat2angle([e4,e1,e2,e3],'YZX');
        %         R3 = 0; % +x
        Rtmp = [R1,R2,R3];
        R1 = pi/2;
        R2 = Rtmp(3);
        R3 = 0;
        Q = angle2quat(R1,R2,R3,'YZX');
        posQue(iPosQue,1) = iPosQue;
        posQue(iPosQue,2:5) = Q;
        posQue(iPosQue,6:8) = cc{i}(j,1:3);
        iPosQue = iPosQue+1;
    end
end
OriPosQue = posQue;
% 8*4 = 32
nnn = floor((iPosQue-1)/5); % 采样
posQue = zeros(nnn,datalen);
for i = 1:nnn;
    posQue(i,:) = OriPosQue(i*5,:); % 采样
end
nSumOfData = nnn;
nMaxSendBuf = 1024;
nMaxInOneSend = floor(nMaxSendBuf/(datalen*4));
npatch = floor(nSumOfData/(1024/(datalen*4)));
npatchtail = mod(nSumOfData,(1024/(datalen*4)));

datasend = zeros(nMaxInOneSend*datalen,1);

for i = 0:npatch-1
    i
    for j = 0:nMaxInOneSend-1
        datasend(j*datalen+1:(j+1)*datalen) = posQue(i*nMaxInOneSend+j+1,:);
    end
    fwrite(t,datasend,'float32');
    while 1
        if t.BytesAvailable >=8
            data = fread(t, t.BytesAvailable);
            break;
        end
    end
end

if npatchtail >0
    datatail = zeros(npatchtail*datalen,1);
    for j = 0:npatchtail-1
        datatail(j*datalen+1:(j+1)*datalen) = posQue(end-npatchtail+j+1,:);
    end
    
    fwrite(t,datatail,'float32');
    while 1
        if t.BytesAvailable >=8
            data = fread(t, t.BytesAvailable);
            break;
        end
    end
end

% fwrite(t,[0 0],'float') % dong

disp('something')

% fwrite(t, 'end');
fclose(t);

