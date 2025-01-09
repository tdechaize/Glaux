#   Example Makefile

APP      = $(NAME_APPLI)
EXEFILE  = $(APP).exe
OBJFILES = $(APP).obj 
RESFILES = $(APP).res
LIBFILES =
DEFFILE  =
RCFILE   = $(APP).rc

CFLAGS = -DNDEBUG -DWIN32_LEAN_AND_MEAN

RCFLAGS = -IC:\lcc\include
LIBS = glu32.lib opengl32.lib user32.lib advapi32.lib comdlg32.lib winmm.lib gdi32.lib shell32.lib kernel32.lib

all : $(APP).exe
	
$(APP).exe: $(APP).res $(APP).obj
	lcclnk $(APP).obj $(APP).res -LC:\lcc\lib $(LIBS)
	
$(APP).res: src\$(APP).rc
	lrc $(RCFLAGS) src\$(APP).rc -IC:\lcc\include
	
$(APP).obj: src\$(APP).c
	lcc $(CFLAGS) src\$(APP).c -IC:\lcc\include
 
clean:
	del $(APP).exe $(APP).res $(APP).obj
