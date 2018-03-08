MODULE SCKT
    PERS num quat{4};
    PERS num xyz{3};
    PERS bool ismove;
    PERS bool isloop;
    PERS num pathBuf{65535,15};
    PERS num sPathBuf:=1;
    PERS num ePathBuf:=103;
    VAR rawbytes recRawBytes;

    FUNC num rawBytesParse()
        VAR num floatdata;
        VAR string toscreen;
        VAR num dataLen;
        VAR num lenMod;
        VAR num nitem;

        UnpackRawBytes recRawBytes,1,floatdata,\Float4;
        toscreen:=valtostr(RawBytesLen(recRawBytes))+",";
        toscreen:=toscreen+ValToStr(floatdata);
        tpwrite toscreen;

        IF floatdata=0 THEN
            UnpackRawBytes recRawBytes,5,floatdata,\Float4;
            IF floatdata=0 THEN
                ismove:=TRUE;
                RETURN 2;
            ENDIF
            IF floatdata=1 THEN
                sPathBuf:=1;
                ePathBuf:=1;
                RETURN 3;
            ENDIF
            IF floatdata=10 THEN
                isloop := TRUE;
                RETURN 3;
            ENDIF

        ENDIF


        dataLen:=RawBytesLen(recRawBytes);
        lenMod:=dataLen MOD 16*4;   !16 is the length of the parameters
        IF not lenMod=0 THEN
            RETURN -1;
        ENDIF
        nitem:=dataLen/(16*4);
        FOR i FROM 0 TO nitem-1 DO
            FOR j FROM 1 TO 10 DO
                UnpackRawBytes recRawBytes,i*(16*4)+1+j*4,floatdata,\Float4;
                pathBuf{ePathBuf,j}:=floatdata;
            ENDFOR
            ePathBuf:=ePathBuf+1;

        ENDFOR

        RETURN 0;
    ENDFUNC
FUNC num rawBytesParse2()
        VAR num floatdata;
        VAR string toscreen;
        VAR num dataLen;
        VAR num lenMod;
        VAR num nitem;

        UnpackRawBytes recRawBytes,1,floatdata,\Float4;
        toscreen:=valtostr(RawBytesLen(recRawBytes))+",";
        toscreen:=toscreen+ValToStr(floatdata);
        tpwrite toscreen;

        IF floatdata=0 THEN
            UnpackRawBytes recRawBytes,5,floatdata,\Float4;
            IF floatdata=0 THEN
                ismove:=TRUE;
                RETURN 2;
            ENDIF
            IF floatdata=1 THEN
                sPathBuf:=1;
                ePathBuf:=1;
                RETURN 3;
            ENDIF
            IF floatdata=10 THEN
                isloop := TRUE;
                RETURN 3;
            ENDIF

        ENDIF


        dataLen:=RawBytesLen(recRawBytes);
        lenMod:=dataLen MOD 32;
        IF not lenMod=0 THEN
            RETURN -1;
        ENDIF
        nitem:=dataLen/32;
        FOR i FROM 0 TO nitem-1 DO
            FOR j FROM 1 TO 7 DO
                UnpackRawBytes recRawBytes,i*32+1+j*4,floatdata,\Float4;
                pathBuf{ePathBuf,j}:=floatdata;
            ENDFOR
            ePathBuf:=ePathBuf+1;

        ENDFOR

        RETURN 0;
    ENDFUNC
    
    FUNC num cmdParse(string cmd)
        VAR num buf{7};
        VAR num numcmd;
        VAR num sTart;
        VAR num eNd;
        VAR bool ok;
        TPWrite cmd;
        IF ismove THEN
            RETURN 4;
        ENDIF
        numcmd:=StrMatch(cmd,1,"start");
        IF numcmd=1 THEN
            TPWrite cmd;
            sPathBuf:=1;
            ePathBuf:=1;
            RETURN 1;
        ENDIF
        numcmd:=StrMatch(cmd,1,"end");
        IF numcmd=1 THEN
            TPWrite cmd;
            ismove:=TRUE;
            RETURN 2;
        ENDIF
        IF ePathBuf>65535 THEN
            RETURN 3;
        ENDIF

        sTart:=StrMatch(cmd,1,"q1:");
        eNd:=StrMatch(cmd,1,"_");
        ok:=StrToVal(StrPart(cmd,sTart+3,eNd-sTart-3),pathBuf{ePathBuf,1});
        IF NOT ok THEN
            RETURN -1;
        ENDIF
        sTart:=StrMatch(cmd,eNd+1,"q2:");
        eNd:=StrMatch(cmd,eNd+1,"_");
        ok:=StrToVal(StrPart(cmd,sTart+3,eNd-sTart-3),pathBuf{ePathBuf,2});
        IF NOT ok THEN
            RETURN -1;
        ENDIF
        sTart:=StrMatch(cmd,eNd+1,"q3:");
        eNd:=StrMatch(cmd,eNd+1,"_");
        ok:=StrToVal(StrPart(cmd,sTart+3,eNd-sTart-3),pathBuf{ePathBuf,3});
        IF NOT ok THEN
            RETURN -1;
        ENDIF
        sTart:=StrMatch(cmd,eNd+1,"q4:");
        eNd:=StrMatch(cmd,eNd+1,"_");
        ok:=StrToVal(StrPart(cmd,sTart+3,eNd-sTart-3),pathBuf{ePathBuf,4});
        IF NOT ok THEN
            RETURN -1;
        ENDIF
        sTart:=StrMatch(cmd,eNd+1,"x:");
        eNd:=StrMatch(cmd,eNd+1,"_");
        ok:=StrToVal(StrPart(cmd,sTart+2,eNd-sTart-2),pathBuf{ePathBuf,5});
        IF NOT ok THEN
            RETURN -1;
        ENDIF
        sTart:=StrMatch(cmd,eNd+1,"y:");
        eNd:=StrMatch(cmd,eNd+1,"_");
        ok:=StrToVal(StrPart(cmd,sTart+2,eNd-sTart-2),pathBuf{ePathBuf,6});
        IF NOT ok THEN
            RETURN -1;
        ENDIF
        sTart:=StrMatch(cmd,eNd+1,"z:");
        eNd:=StrMatch(cmd,eNd+1,"_");
        ok:=StrToVal(StrPart(cmd,sTart+2,eNd-sTart-2),pathBuf{ePathBuf,7});
        IF NOT ok THEN
            RETURN -1;
        ENDIF
        ePathBuf:=ePathBuf+1;

        RETURN 0;
    ENDFUNC


    PROC main()


        VAR socketdev server_socket;
        VAR socketdev client_socket;
        VAR string receive_string;
        VAR string client_ip;
        VAR num errcode;
        VAR string send;



        SocketCreate server_socket;
        SocketBind server_socket,"192.168.125.1",1025;
        SocketListen server_socket;
        ePathBuf:=1;
        ismove:=FALSE;
        isloop:=FALSE;
        WHILE TRUE DO
            SocketAccept server_socket,client_socket\ClientAddress:=client_ip,\Time:=WAIT_MAX;
            WHILE TRUE DO
                !SocketReceive client_socket\Str:=receive_string\Time:=WAIT_MAX;
                SocketReceive client_socket\RawData:=recRawBytes,\Time:=WAIT_MAX;
                errcode:=rawBytesParse();
                !+"  "+receive_string;
                ! Wait for client acknowledge
                !errcode :=cmdParse (receive_string);
                SocketSend client_socket\Str:="copythat";
                !send :=NumToStr(ePathBuf,5);
                !TPWrite send;
            ENDWHILE
            SocketClose client_socket;
        ENDWHILE

    ERROR
        IF ERRNO=ERR_SOCK_TIMEOUT THEN
            RETRY;
        ELSEIF ERRNO=ERR_SOCK_CLOSED THEN
            SocketClose server_socket;
            SocketClose client_socket;
            SocketCreate server_socket;
            SocketBind server_socket,"192.168.125.1",1025;
            SocketListen server_socket;
            SocketAccept server_socket,client_socket\ClientAddress:=client_ip\Time:=WAIT_MAX;
!            WHILE TRUE DO
!                SocketReceive client_socket\Str:=receive_string\Time:=WAIT_MAX;
!                !+"  "+receive_string;
!                ! Wait for client acknowledge
!                errcode:=rawBytesParse();   
!                SocketSend client_socket\Str:="copythat";
!                !send:=NumToStr(ePathBuf,5);
!                !TPWrite send;
!            ENDWHILE
!            SocketClose client_socket;
            RETRY;
        ELSE
            ! No error recovery handling
        ENDIF

    UNDO
        SocketClose server_socket;
        SocketClose client_socket;


    ENDPROC
ENDMODULE