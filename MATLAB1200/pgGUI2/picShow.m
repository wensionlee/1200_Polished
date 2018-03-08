function varargout = picShow(varargin)
% PICSHOW MATLAB code for picShow.fig
%      PICSHOW, by itself, creates a new PICSHOW or raises the existing
%      singleton*.
%
%      H = PICSHOW returns the handle to a new PICSHOW or the handle to
%      the existing singleton*.
%
%      PICSHOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PICSHOW.M with the given input arguments.
%
%      PICSHOW('Property','Value',...) creates a new PICSHOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before picShow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to picShow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help picShow

% Last Modified by GUIDE v2.5 26-Jun-2017 20:05:27
% Global



% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @picShow_OpeningFcn, ...
    'gui_OutputFcn',  @picShow_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before picShow is made visible.
function picShow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figuree
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to picShow (see VARARGIN)

% Choose default command line output for picShow
handles.output = hObject;
load('ppdata.mat','data');
data = struct('state',0,'mstate',0,'mdownpos',[],'mcurpos',[],'img',[],'ROIbox',[],'blob',cell(1),'cc',cell(1),'pp',data);
set(handles.figure1,'UserData',data);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes picShow wait for user response (see UIRESUME)
% uiwait(handles.figure1);
t = -5:.1:5;
y = sinc(t);
plot(t,y,'gd','Parent', handles.fig_1);
set( gcf, 'toolbar', 'figure' )


% --- Outputs from this function are returned to the command line. 
function varargout = picShow_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in btn_step_1.
function btn_step_1_Callback(hObject, eventdata, handles)
% hObject    handle to btn_step_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plot(handles.figure1.UserData.pp(:,2),handles.figure1.UserData.pp(:,1),'r.','Parent', handles.fig_1);
set(gca,'XDir','reverse');
handles.figure1.UserData.state = 1;

% --- Executes on button press in bnt_step_2.
function bnt_step_2_Callback(hObject, eventdata, handles)
% hObject    handle to bnt_step_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.figure1.UserData.state >=1.5
%     open('C:\PartialReconstruct\PartialReconstruct.exe');
    handles.figure1.UserData.state = 2;
else
    helpdlg('单击提取后鼠标选择范围','提示');
end

% --- Executes on button press in bnt_step_3.
function bnt_step_3_Callback(hObject, eventdata, handles)
% hObject    handle to bnt_step_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.figure1.UserData.state >=1
    axes(handles.fig_1);
    [handles.figure1.UserData.blob] = PntSeg(handles.figure1.UserData.pp,handles.figure1.UserData.ROIbox);
    handles.figure1.UserData.state = 3;
else
    helpdlg('先执行分割','提示');
end

% plot3(handles.figure1.UserData.blob{1}(:,1),...
%     handles.figure1.UserData.blob{1}(:,2),...
%     handles.figure1.UserData.blob{1}(:,3),...
%     'rx','Parent', handles.fig_1);
% axis equal

% --- Executes on button press in bnt_step_4.
function bnt_step_4_Callback(hObject, eventdata, handles)
% hObject    handle to bnt_step_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.figure1.UserData.state >=3
    axes(handles.fig_1);
    handles.figure1.UserData.cc = pathforpointclouds2(handles.figure1.UserData.blob);
    handles.figure1.UserData.state = 4;
else
    helpdlg('先执行分离','提示');
end

% --- Executes on button press in bnt_step_5.
function bnt_step_5_Callback(hObject, eventdata, handles)
% hObject    handle to bnt_step_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.figure1.UserData.state >=4
    if strcmp(questdlg('确定发送路径？','问题提示','Yes','No','Yes'),'Yes')
        mytcpip4(handles.figure1.UserData.cc);
        handles.figure1.UserData.state = 5;
    end
else
    helpdlg('先执行规划','提示');
end

% --- Executes on button press in bnt_step_6.
function bnt_step_6_Callback(hObject, eventdata, handles)
% hObject    handle to bnt_step_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.figure1.UserData.state >=5
    if strcmp(questdlg('确定开始打磨？','问题提示','Yes','No','Yes'),'Yes')
        robmove;
        handles.figure1.UserData.state = 6;
    end
else
    helpdlg('先发送路径','提示');
end


% --- Executes on button press in bnt_clear_pic.
function bnt_clear_pic_Callback(hObject, eventdata, handles)
% hObject    handle to bnt_clear_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(questdlg('确定清除历史图像？','问题提示','Yes','No','Yes'),'Yes')
%     imagedel;
end

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.figure1.UserData.state >= 1 && handles.figure1.UserData.state<= 1.5
    if(strcmp(get(gcf,'SelectionType'),'normal'))%判断鼠标按下的类型，mormal为左键
        handles.figure1.UserData.mdownpos = get(handles.fig_1,'CurrentPoint');%获取坐标轴上鼠标的位置
%         if handles.figure1.UserData.mdownpos(1,1) >=0 && handles.figure1.UserData.mdownpos(1,2) >=0 ...
%                 && handles.figure1.UserData.mdownpos(1,1) <= size(handles.figure1.UserData.img,2) ...
%                 && handles.figure1.UserData.mdownpos(1,2) <= size(handles.figure1.UserData.img,1)
            handles.figure1.UserData.mstate = 1;
%         end
        handles.figure1.UserData.mdownpos;
    end
end


% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.figure1.UserData.state >= 1 && handles.figure1.UserData.state<= 1.5
    if handles.figure1.UserData.mstate == 1
        if(strcmp(get(gcf,'SelectionType'),'normal'))%判断鼠标按下的类型，normal为左键
            handles.figure1.UserData.mcurpos = get(handles.fig_1,'CurrentPoint');%获取坐标轴上鼠标的位置
            plot(handles.figure1.UserData.pp(:,2),handles.figure1.UserData.pp(:,1),'r.','Parent', handles.fig_1);
            set(gca,'XDir','reverse');
            hold on;
            p1 = handles.figure1.UserData.mdownpos(1,1:2);
            p2 = [handles.figure1.UserData.mdownpos(1,1),handles.figure1.UserData.mcurpos(1,2)];
            p3 = handles.figure1.UserData.mcurpos(1,1:2);
            p4 = [handles.figure1.UserData.mcurpos(1,1),handles.figure1.UserData.mdownpos(1,2)];
            p5 = handles.figure1.UserData.mdownpos(1,1:2);
            p = [p1;p2;p3;p4;p5];
            plot(p(:,1),p(:,2),'b','Parent', handles.fig_1)
            hold off
            ymin = min(p1(1),p3(1));
            xmin = min(p1(2),p3(2));
            ymax = max(p1(1),p3(1));
            xmax = max(p1(2),p3(2));

            handles.figure1.UserData.ROIbox = [xmin,xmax,ymin,ymax]
%             handles.figure1.UserData.ROIbox = [xtop,ytop,xbnt,ybnt];
%             fprintf(fid,'%d %d %d %d %d %d %d %d',handles.figure1.UserData.ROIbox);
%             fclose(fid);
%             des = drawRect(handles.figure1.UserData.img,[xtop ytop],[xbnt-xtop ybnt-ytop ],3 );
%             imshow(des, 'Parent', handles.fig_1)
%             get(handles.fig_1,'CurrentPoint')
        end
    end
    
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.figure1.UserData.state >= 1 && handles.figure1.UserData.state<= 1.5
    if(strcmp(get(gcf,'SelectionType'),'normal'))%判断鼠标按下的类型，normal为左键
        handles.figure1.UserData.mcurpos = get(handles.fig_1,'CurrentPoint');%获取坐标轴上鼠标的位置
        handles.figure1.UserData.mstate = 0;
        if isempty(handles.figure1.UserData.ROIbox) == 0
            handles.figure1.UserData.state = 1.5
        end
    end
end


% --- Executes on button press in bnt_step_2_2
function bnt_step_2_2_Callback(hObject, eventdata, handles)
% hObject    handle to bnt_step_2_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot(handles.figure1.UserData.pp(:,2),handles.figure1.UserData.pp(:,1),'r.','Parent', handles.fig_1);