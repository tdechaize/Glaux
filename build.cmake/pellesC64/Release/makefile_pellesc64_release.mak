APP      = $(NAME_APPLI)
EXEFILE  = $(APP).exe
OBJFILES = $(APP).obj 
RESFILES = $(APP).res
LIBFILES =
DEFFILE  =
RCFILE   = $(APP).rc

CC= pocc        # compiler
RCC= porc       # resource compiler
LINK= polink	# linker

CFLAGS = /nologo /Zi /Ze /c /DNDEBUG /DWIN32_LEAN_AND_MEAN -Tx64-coff /D_AMD64_ /D_WIN64  

RCFLAGS = /IC:\pellesC\include\Win /IC:\pellesC\include

LFLAGS = /nologo /subsystem:windows /MACHINE:X64
LIBS = glu32.lib opengl32.lib user32.lib advapi32.lib comdlg32.lib winmm.lib gdi32.lib shell32.lib kernel32.lib

all : $(APP).exe
	
$(APP).exe: $(APP).res $(APP).obj
	polink $(LFLAGS) $(APP).obj $(APP).res /LIBPATH:C:\PellesC\lib\Win64 /LIBPATH:C:\PellesC\lib $(LIBS)
	
$(APP).res: src\$(APP).rc
	porc $(RCFLAGS) src\$(APP).rc /IC:\pellesC\include\Win /IC:\pellesC\include /Fo$(APP).res
	
$(APP).obj: src\$(APP).c
	pocc $(CFLAGS) src\$(APP).c /IC:\pellesC\include\Win /IC:\pellesC\include /Fo$(APP).obj
	
clean:
	del $(APP).exe $(APP).res $(APP).obj
