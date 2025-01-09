#   Example Makefile pour WMAKE

APP      = $(NAME_APPLI)
EXEFILE  = $(APP).exe
OBJFILES = $(APP).obj 
RESFILES = $(APP).res
LIBFILES =
DEFFILE  =
RCFILE   = $(APP).rc

CFLAGS = -q -c -dDEBUG -d_DEBUG -bcl=nt
LFLAGS = option quiet system nt_win 
RCFLAGS = -q -r
LIBS = glu32.lib,opengl32.lib,user32.lib,advapi32.lib,comdlg32.lib,winmm.lib,gdi32.lib,shell32.lib,kernel32.lib

all : $(APP).exe
	
$(APP).exe: $(APP).res $(APP).obj
	wlink $(LFLAGS) LIBP C:\watcom\lib386\nt;C:\watcom\lib386 file $(APP).obj name $(APP).exe library $(LIBS) option resource=$(APP).res
	
$(APP).res: src\$(APP).rc
	wrc $(RCFLAGS) -iC:\watcom\h\nt -iC:\watcom\h src\$(APP).rc -fo$(APP).res
	
$(APP).obj: src\$(APP).c
	wcl386 $(CFLAGS) src\$(APP).c -iC:\watcom\h\nt -iC:\watcom\h -fo$(APP).obj
	
clean:
	del $(APP).exe $(APP).res $(APP).obj
