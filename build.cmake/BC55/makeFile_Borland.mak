!IF "$(CFG)" != "Release" && "$(CFG)" != "Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running MAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE
!MESSAGE make -DCFG=[Release | Debug] -DNAME_APPLI=name-application /f MakeFile_Borland.mak
!MESSAGE
!MESSAGE Possible choices for configuration are:
!MESSAGE
!MESSAGE "Release" (Win32 Release)
!MESSAGE "Debug" (Win32 Debug)
!MESSAGE
!ENDIF

APP      = $(NAME_APPLI)
EXEFILE  = $(APP).exe
OBJFILES = $(APP).obj 
RESFILES = $(APP).res
LIBFILES =
DEFFILE  =
RCFILE   = $(APP).rc

.AUTODEPEND
BCC32   = bcc32
ILINK32 = ilink32
BRC32   = brc32

!IF "$(CFG)" == "Release"
CFLAGS  = -c -tWM- -w -w-par -w-inl -W -a1 -O2 -6 -DNDEBUG
!ELSE
CFLAGS  = -c -tWM- -w -w-par -w-inl -W -a1 -Od -6 -D_DEBUG -DDEBUG
!ENDIF
# -I"C:\BCC55\include"
!IF "$(CFG)" == "Release"
LFLAGS  = -q -aa -V4.0 -c -x -Gn
!ELSE
LFLAGS  = -q -aa -V4.0 -c -x -Gn -v
!ENDIF

LIBDIR = -L"C:\Bcc55\lib\psdk" -L"C:\BCC55\lib"
RCFLAGS  = -X -R -I"C:\BCC55\include"
STDOBJS = c0w32.obj
STDLIBS = import32.lib cw32mti.lib
LIBRARiES = cw32.lib glu32.lib opengl32.lib gdi32.lib advapi32.lib comdlg32.lib winmm.lib user32.lib kernel32.lib

all : $(APP).exe
	
$(APP).exe: $(APP).res $(APP).obj
	ilink32 $(LFLAGS) $(LIBDIR) $(STDOBJS) $(APP).obj, $(APP).exe, , $(STDLIBS) $(LIBRARIES), , $(APP).res 
	
$(APP).res: src\$(APP).rc
	brc32 $(RCFLAGS) -fo$(APP).res src\$(APP).rc 
	
$(APP).obj: src\$(APP).c
	bcc32 $(CFLAGS) -o$(APP).obj src\$(APP).c

clean:
   del *.obj res *.tds 
#  .\binBC55\Release\*.map