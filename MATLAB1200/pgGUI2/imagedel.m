filelist = dir('C:\Users\SZAR\Desktop\imageandpc\*.bmp'); % 切记再次测量时，应当删除该文件夹中的所有内容

if size(filelist,1) ~= 0
    for i = 1:size(filelist,1)
        delete(['C:\Users\SZAR\Desktop\imageandpc\',filelist(i).name]);
    end
end

filelist = dir('C:\Users\SZAR\Desktop\imageandpc\*.xyz'); % 切记再次测量时，应当删除该文件夹中的所有内容
if size(filelist,1) ~= 0
    for i = 1:size(filelist,1)
        delete(['C:\Users\SZAR\Desktop\imageandpc\',filelist(i).name]);
    end
end 
