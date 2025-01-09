#   Example Makefile

APP      = $(NAME_APPLI)
EXEFILE  = $(APP).exe
OBJFILES = $(APP).obj 
RESFILES = $(APP).res
LIBFILES =
DEFFILE  =
RCFILE   = $(APP).rc

CFLAGS = -mn -c -WA -H -g -D_DEBUG -DDEBUG -IC:\dm\include\win32 -IC:\dm\stlport\stlport -IC:\dm\include 
RCFLAGS = -32 -IC:\dm\include\win32 -IC:\dm\include

LFLAGS = /NOLOGO /subsystem:windows
LIBS = glu32.lib opengl32.lib user32.lib advapi32.lib comdlg32.lib winmm.lib gdi32.lib shell32.lib kernel32.lib

all : $(APP).exe
	
$(APP).exe: $(APP).res $(APP).obj
	link $(LFLAGS) $(APP).obj, $(APP).exe, , $(LIBS), , $(APP).res 
	
$(APP).res: src\$(APP).rc
	rcc $(RCFLAGS) -o$(APP).res  src\$(APP).rc 
	
$(APP).obj: src\$(APP).c
	dmc $(CFLAGS) -o$(APP).obj src\$(APP).c

clean:
	del $(APP).exe $(APP).res $(APP).obj
