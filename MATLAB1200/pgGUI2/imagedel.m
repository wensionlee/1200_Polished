filelist = dir('C:\Users\SZAR\Desktop\imageandpc\*.bmp'); % �м��ٴβ���ʱ��Ӧ��ɾ�����ļ����е���������

if size(filelist,1) ~= 0
    for i = 1:size(filelist,1)
        delete(['C:\Users\SZAR\Desktop\imageandpc\',filelist(i).name]);
    end
end

filelist = dir('C:\Users\SZAR\Desktop\imageandpc\*.xyz'); % �м��ٴβ���ʱ��Ӧ��ɾ�����ļ����е���������
if size(filelist,1) ~= 0
    for i = 1:size(filelist,1)
        delete(['C:\Users\SZAR\Desktop\imageandpc\',filelist(i).name]);
    end
end 
