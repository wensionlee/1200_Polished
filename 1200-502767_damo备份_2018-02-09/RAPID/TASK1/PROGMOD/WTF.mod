MODULE WTF
    CONST robtarget myRobtarget:=[[567.71,-23.52,191.98],[0.187655,0.729287,0.629811,0.190433],[-1,2,-1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    !CONST robtarget myRobtarget:=[[100,200,300],[1,0,0,0],[0,0,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
    
    
    PERS tooldata myTool:=[TRUE,[[8.77236,-172.574,105.109],[1,0,0,0]],[4,[0,0,100],[1,0,0,0],0,0,0]];
    PERS loaddata tc_load:=[1.7698,[-3.66128,-11.834,120.921],[1,0,0,0],0,0,0];
    TASK PERS wobjdata myWobj:=[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]];
    PERS loaddata TestLoad:=[4.8056,[0.434346,4.17353,67.0879],[1,0,0,0],0,0,0];

    PERS Num quat{4}:=[0.67062,-0.04721,0.73906,-0.042838];

    PERS num pathBuf{65535,15};
    PERS num sPathBuf;
    PERS num ePathBuf;


    PERS bool ismove;
    PERS bool isloop;



    TASK PERS tooldata toolg:=[TRUE,[[8.77236,-172.574,105.109],[0.429133,0.839791,0.151326,0.296137]],[4,[0,0,0],[1,0,0,0],0,0,0]];
    CONST robtarget p10:=[[185.28,295.89,399.81],[0.499854,0.499985,0.500235,0.499927],[1,1,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget p20:=[[371.03,286.35,399.77],[0.499794,0.500012,0.500274,0.499919],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget p30:=[[379.91,17.49,399.70],[0.499733,0.500081,0.500324,0.499861],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget myrt11:=[[535.62,2.37,228.78],[0.441076,0.574756,0.495546,0.479106],[-1,-1,1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    PROC main()
        
        !VAR robtarget myrt0:=[[500,-300,400],[0.7071,0.0,0.7071,0.0],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
        VAR robtarget myrt0:=[[500,-300,400],[0.5,0.5,0.5,0.5],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
        !VAR robtarget myrt0_1:=[[500,-300,420],[0.7071,0.0,0.7071,0.0],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
        !VAR robtarget myrt0_2:=[[500,-200,400],[0.7071,0.0,0.7071,0.0],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

        VAR robtarget myrt1:=[[500,0,400],[0.7071,0.0,0.7071,0.0],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
        !VAR robtarget myrt1:=[[417.42,-130.20,500.77],[0.9239,0,0.3827,0],[1,-1, -1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
        VAR robtarget myrt2:=[[417.42,30.20,500.77],[0.7071,0,0.5000,-0.5000],[-1,-1,-1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
        VAR string toscreen;
        VAR fcdamping my_damping:=[300,300,200,50,50,50];
        
        VelSet 70,50;
        !MoveL p30, v200,z0,myTool;
        !MoveL p20, v200,z0,myTool;
        MoveL p10, v100,z0,myTool;
        !MoveL myrt0, v100,z0,myTool;

        FCDeact;
           
            GripLoad TestLoad;
            SingArea\Wrist;
         
        WHILE TRUE DO

            !WHILE isloop DO
                IF ismove THEN
                    
                    MoveL p20, v100,z0,myTool;
                    MoveL p30, v100,z0,myTool;
                    !SetDO D0spindle,1;
                    myrt1:=[[pathBuf{1,5}+0,pathBuf{1,6},pathBuf{1,7}+7],[pathBuf{1,1},pathBuf{1,2},pathBuf{1,3},pathBuf{1,4}],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
                    MoveL myrt1,v100,fine,myTool\WObj:=wobj0;

                    WaitTime \InPos, 1;
                    !FCAct myTool;
                    FCCalib TestLoad;
                    
                    myrt1:=[[pathBuf{1,5}+0,pathBuf{1,6},pathBuf{1,7}+3],[pathBuf{1,1},pathBuf{1,2},pathBuf{1,3},pathBuf{1,4}],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
                    FCPress1LStart myrt1,v100\Fy:=-2,60\UseSpdFFW\PosSupvDist:=60,z30,myTool\WObj:=wobj0;
                    FOR i FROM 1 TO ePathBuf-1 DO
                        toscreen:=NumToStr(i,4)+", ";
                        toscreen:=toscreen+NumToStr(pathBuf{i,5},4)+", ";
                        toscreen:=toscreen+NumToStr(pathBuf{i,6},4)+", ";
                        toscreen:=toscreen+NumToStr(pathBuf{i,7},4)+", ";

                        TPWrite toscreen;
                        myrt1:=[[pathBuf{i,5}+0,pathBuf{i,6},pathBuf{i,7}],[pathBuf{i,1},pathBuf{i,2},pathBuf{i,3},pathBuf{i,4}],[0,0,pathBuf{i,10},1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
                        FCPressL myrt1,v5,-2,fine,myTool\WObj:=wobj0;
                        
                    ENDFOR
                    FCPressEnd myrt1,v5,myTool\WObj:=wobj0;
                    ismove:=FALSE;
                    FCDeact;
                    myrt1.trans.z := myrt1.trans.z+50;
                    MoveL myrt1,v50,z0,myTool;
                    MoveL p30, v100,z0,myTool;
                    MoveL p20, v100,z0,myTool;
                    MoveL p10, v100,z0,myTool;
                    IF isloop THEN
                        ismove:=TRUE;
                    ENDIF
                    !MoveL myrt0, v100,z0,myTool;
                ENDIF
            !ENDWHILE
            
!            IF ismove THEN
                
!                myrt1:=[[pathBuf{1,5}+0,pathBuf{1,6},pathBuf{1,7}+10],[pathBuf{1,1},pathBuf{1,2},pathBuf{1,3},pathBuf{1,4}],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
!                MoveL myrt1,v100,fine,myTool\WObj:=wobj0;
!                !FCAct myTool;
!                !!FCCalib TestLoad;
                
!                myrt1:=[[pathBuf{1,5}+0,pathBuf{1,6},pathBuf{1,7}+5],[pathBuf{1,1},pathBuf{1,2},pathBuf{1,3},pathBuf{1,4}],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
!                !!FCPress1LStart myrt1,v100\Fy:=-10,80\UseSpdFFW\PosSupvDist:=60,z30,myTool\WObj:=wobj0;
!                MoveL myrt1,v20,fine,myTool\WObj:=wobj0;
!                FOR i FROM 1 TO ePathBuf-1 DO
!                    toscreen:=NumToStr(i,4)+", ";
!                    toscreen:=toscreen+NumToStr(pathBuf{i,10},2)+", ";


!                    TPWrite toscreen;
!                    myrt1:=[[pathBuf{i,5}+0,pathBuf{i,6},pathBuf{i,7}],[pathBuf{i,1},pathBuf{i,2},pathBuf{i,3},pathBuf{i,4}],[0,0,pathBuf{i,10},1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
!                    !!FCPressL myrt1,v5,-10,fine,myTool\WObj:=wobj0;
!                    MoveL myrt1,v5,fine,myTool\WObj:=wobj0;
                    
!                ENDFOR
!                !!FCPressEnd myrt1,v5,myTool\WObj:=wobj0;
!                ismove:=FALSE;
!                !!FCDeact;
!                MoveL myrt0, v100,z0,myTool;
!            ENDIF
            
            
        ENDWHILE


    ENDPROC
PROC ForceCalib()
    TestLoad := FCLoadID(\MaxMoveAx5:=50,\MaxMoveAx6:=90);
    TPWrite "FC Calibration Done!";
ENDPROC
 PROC Test_FC()
        VAR fcdirections my_dir:=[TRUE,FALSE,FALSE,FALSE,FALSE,FALSE];
        VAR fcdamping my_damping:=[300,300,200,50,50,50];
        !FCSetDampingTune 30,30,30,30,30,30;
        FCCalib tc_Load;
        FCAct myTool;     

        FCDeact;
    ENDPROC

ENDMODULE