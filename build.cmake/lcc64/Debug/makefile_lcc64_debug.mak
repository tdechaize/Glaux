#   Example Makefile

APP      = $(NAME_APPLI)
EXEFILE  = $(APP).exe
OBJFILES = $(APP).obj 
RESFILES = $(APP).res
LIBFILES =
DEFFILE  =
RCFILE   = $(APP).rc

CFLAGS = -g2 -D_DEBUG -DDEBUG -DWIN32_LEAN_AND_MEAN

RCFLAGS = -IC:\lcc64\include64
LIBS = glu32.lib opengl32.lib user32.lib advapi32.lib comdlg32.lib winmm.lib gdi32.lib shell32.lib kernel32.lib

all : $(APP).exe
	
$(APP).exe: $(APP).res $(APP).obj
	lcclnk64 $(APP).obj $(APP).res -LC:\lcc64\lib64 $(LIBS)
	
$(APP).res: src\$(APP).rc
	lrc $(RCFLAGS) src\$(APP).rc -IC:\lcc64\include64
	
$(APP).obj: src\$(APP).c
	lcc64 $(CFLAGS) src\$(APP).c -IC:\lcc64\include64
	
clean:
	del $(APP).exe $(APP).res $(APP).obj
