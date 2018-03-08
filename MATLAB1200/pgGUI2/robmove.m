t = tcpip('192.168.125.1', 1025, 'NetworkRole', 'client');
t.OutputBufferSize = 1024;
t.ByteOrder = 'littleEndian';

fopen(t);
fwrite(t,[0 0],'float')
fclose(t);
111
 