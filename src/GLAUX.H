#ifndef __GLAUX_H__
#define __GLAUX_H__                 // Header guard

/*   Warning this file has been modified to adapt it with all free compilers C/C++ on Windows.
     Note two copyrigths after by Microsoft Corporation and by Silicon Graphics, Inc.
     Note also, that this library, in original version, is only available on Win32 platforms.
     If, you want use functions available into this library (or similar functions) in your code,
     it's preferable to use another library, like GLUT, or better FreeGlut (freeware lib) that
     is available on multiple platforms : Windows, Unix and Linux (or similars), Apple and many
     game consoles.

     Majors changes :
        - add many "header guards" into include files,
        - add protection with call by compilers C++, with tests of define variable  __cplusplus
            into all files of this project (to prevent "mangling naming" of exported functions),
        - add use of scheme "__declspec(dllexport)" and "__declspec(dllimport)" before all exported
            functions of DLL. That permit creation of imported library during generation of DLL.
            (note that, in first intention, this library is designed only for use in "pure" library
            (assembly of object files to share call of functions), not in shared library).
        - and change all instructions that cause error during compilations (located by comment).
                                                                                                    */

/*++ BUILD Version: 0004    // Increment this if a change has global effects

Copyright (c) 1985-95, Microsoft Corporation

Module Name:

    glaux.h

Abstract:

    Procedure declarations, constant definitions and macros for the OpenGL
    Auxiliary Library.

--*/

/*
 * (c) Copyright 1993, Silicon Graphics, Inc.
 * ALL RIGHTS RESERVED
 * Permission to use, copy, modify, and distribute this software for
 * any purpose and without fee is hereby granted, provided that the above
 * copyright notice appear in all copies and that both the copyright notice
 * and this permission notice appear in supporting documentation, and that
 * the name of Silicon Graphics, Inc. not be used in advertising
 * or publicity pertaining to distribution of the software without specific,
 * written prior permission.
 *
 * THE MATERIAL EMBODIED ON THIS SOFTWARE IS PROVIDED TO YOU "AS-IS"
 * AND WITHOUT WARRANTY OF ANY KIND, EXPRESS, IMPLIED OR OTHERWISE,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY OR
 * FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT SHALL SILICON
 * GRAPHICS, INC.  BE LIABLE TO YOU OR ANYONE ELSE FOR ANY DIRECT,
 * SPECIAL, INCIDENTAL, INDIRECT OR CONSEQUENTIAL DAMAGES OF ANY
 * KIND, OR ANY DAMAGES WHATSOEVER, INCLUDING WITHOUT LIMITATION,
 * LOSS OF PROFIT, LOSS OF USE, SAVINGS OR REVENUE, OR THE CLAIMS OF
 * THIRD PARTIES, WHETHER OR NOT SILICON GRAPHICS, INC.  HAS BEEN
 * ADVISED OF THE POSSIBILITY OF SUCH LOSS, HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, ARISING OUT OF OR IN CONNECTION WITH THE
 * POSSESSION, USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 * US Government Users Restricted Rights
 * Use, duplication, or disclosure by the Government is subject to
 * restrictions set forth in FAR 52.227.19(c)(2) or subparagraph
 * (c)(1)(ii) of the Rights in Technical Data and Computer Software
 * clause at DFARS 252.227-7013 and/or in similar or successor
 * clauses in the FAR or the DOD or NASA FAR Supplement.
 * Unpublished-- rights reserved under the copyright laws of the
 * United States.  Contractor/manufacturer is Silicon Graphics,
 * Inc., 2011 N.  Shoreline Blvd., Mountain View, CA 94039-7311.
 *
 * OpenGL(TM) is a trademark of Silicon Graphics, Inc.
 */

/*      added by T. DECJAIZE : because many warnings appears without this new define WIN32_LEAN_AND_MEAN ->
            warning C4668: '_WIN32_WINNT_WIN10_TH2' non defini(e) comme preprocesseur ou macro, remplacement par '0' pour '#if/#elif'
            But, don't resolve warning ...                */
#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <GL/gl.h>
#include <GL/glu.h>

#ifdef __cplusplus
extern "C" {
#endif

/*   Added by T. DECHAIZE, with this "astuce", you can shared this header beetween generators of DLL and consumers of DLL.
	 Use the define variable BUILD_DLL only when you generate DLL. If define variable _LIB is defined => generation of "basic" library.	*/
#if !defined(_LIB)
#ifdef BUILD_DLL
    #define FUNCAPI  __declspec(dllexport)
#else
    #define FUNCAPI  __declspec(dllimport)
#endif
#else
    #define FUNCAPI
#endif

 /*  Added by T. DECHAIZE, define calling convention in one place, for convenience (only for 32 bit generation).
	 Note, that someone free compilers C/C++ can "force" this calling convention during generation.				*/
#if defined(__LCC__) // || defined(__WATCOMC__)  -> force calling convention during generation
    #define FUNCCALL  __stdcall
#elif defined (__BORLANDC__) || defined(__POCC__)
    #define FUNCCALL  __stdcall
#else
    #define FUNCCALL  __cdecl
# endif

/*      In original sources of this library, you can read adding parameter APIENTRY before
        declaration and instantiation of exposed functions. Why and is that usage ? Read after :

        APIENTRY is an alias for WINAPI.
        WINAPI itself is a definition for the type of calling convention used for windows API calls, the stdcall.
        Basically this is explaining to the compiler how to handle the stack and arguments when calling this function.
        You don't usually need to worry about it unless you are making function pointers to these types of functions.
*/
#if !defined(APIENTRY)
#define APIENTRY  __stdcall
#endif
/*
** ToolKit Window Types
** In the future, AUX_RGBA may be a combination of both RGB and ALPHA
*/

#define AUX_RGB             0
#define AUX_RGBA            AUX_RGB
#define AUX_INDEX           1
#define AUX_SINGLE          0
#define AUX_DOUBLE          2
#define AUX_DIRECT          0
#define AUX_INDIRECT        4

#define AUX_ACCUM           8
#define AUX_ALPHA           16
#define AUX_DEPTH24         32      /* 24-bit depth buffer */
#define AUX_STENCIL         64
#define AUX_AUX             128
#define AUX_DEPTH16         256     /* 16-bit depth buffer */
#define AUX_FIXED_332_PAL   512
#define AUX_DEPTH           AUX_DEPTH16 /* default is 16-bit depth buffer */

/*
** Window Masks
*/

#define AUX_WIND_IS_RGB(x)      (((x) & AUX_INDEX) == 0)
#define AUX_WIND_IS_INDEX(x)    (((x) & AUX_INDEX) != 0)
#define AUX_WIND_IS_SINGLE(x)   (((x) & AUX_DOUBLE) == 0)
#define AUX_WIND_IS_DOUBLE(x)   (((x) & AUX_DOUBLE) != 0)
#define AUX_WIND_IS_INDIRECT(x) (((x) & AUX_INDIRECT) != 0)
#define AUX_WIND_IS_DIRECT(x)   (((x) & AUX_INDIRECT) == 0)
#define AUX_WIND_HAS_ACCUM(x)   (((x) & AUX_ACCUM) != 0)
#define AUX_WIND_HAS_ALPHA(x)   (((x) & AUX_ALPHA) != 0)
#define AUX_WIND_HAS_DEPTH(x)   (((x) & (AUX_DEPTH24 | AUX_DEPTH16)) != 0)
#define AUX_WIND_HAS_STENCIL(x) (((x) & AUX_STENCIL) != 0)
#define AUX_WIND_USES_FIXED_332_PAL(x)  (((x) & AUX_FIXED_332_PAL) != 0)

/*
** ToolKit Event Structure
*/

typedef struct _AUX_EVENTREC {
    GLint event;
    GLint data[4];
} AUX_EVENTREC;

/*
** ToolKit Event Types
*/
#define AUX_EXPOSE      1
#define AUX_CONFIG      2
#define AUX_DRAW        4
#define AUX_KEYEVENT    8
#define AUX_MOUSEDOWN   16
#define AUX_MOUSEUP     32
#define AUX_MOUSELOC    64

/*
** Toolkit Event Data Indices
*/
#define AUX_WINDOWX             0
#define AUX_WINDOWY             1
#define AUX_MOUSEX              0
#define AUX_MOUSEY              1
#define AUX_MOUSESTATUS         3
#define AUX_KEY                 0
#define AUX_KEYSTATUS           1

/*
** ToolKit Event Status Messages
*/
#define AUX_LEFTBUTTON          1
#define AUX_RIGHTBUTTON         2
#define AUX_MIDDLEBUTTON        4
#define AUX_SHIFT               1
#define AUX_CONTROL             2

/*
** ToolKit Key Codes
*/
#define AUX_RETURN              0x0D
#define AUX_ESCAPE              0x1B
#define AUX_SPACE               0x20
#define AUX_LEFT                0x25
#define AUX_UP                  0x26
#define AUX_RIGHT               0x27
#define AUX_DOWN                0x28
#define AUX_A                   'A'
#define AUX_B                   'B'
#define AUX_C                   'C'
#define AUX_D                   'D'
#define AUX_E                   'E'
#define AUX_F                   'F'
#define AUX_G                   'G'
#define AUX_H                   'H'
#define AUX_I                   'I'
#define AUX_J                   'J'
#define AUX_K                   'K'
#define AUX_L                   'L'
#define AUX_M                   'M'
#define AUX_N                   'N'
#define AUX_O                   'O'
#define AUX_P                   'P'
#define AUX_Q                   'Q'
#define AUX_R                   'R'
#define AUX_S                   'S'
#define AUX_T                   'T'
#define AUX_U                   'U'
#define AUX_V                   'V'
#define AUX_W                   'W'
#define AUX_X                   'X'
#define AUX_Y                   'Y'
#define AUX_Z                   'Z'
#define AUX_a                   'a'
#define AUX_b                   'b'
#define AUX_c                   'c'
#define AUX_d                   'd'
#define AUX_e                   'e'
#define AUX_f                   'f'
#define AUX_g                   'g'
#define AUX_h                   'h'
#define AUX_i                   'i'
#define AUX_j                   'j'
#define AUX_k                   'k'
#define AUX_l                   'l'
#define AUX_m                   'm'
#define AUX_n                   'n'
#define AUX_o                   'o'
#define AUX_p                   'p'
#define AUX_q                   'q'
#define AUX_r                   'r'
#define AUX_s                   's'
#define AUX_t                   't'
#define AUX_u                   'u'
#define AUX_v                   'v'
#define AUX_w                   'w'
#define AUX_x                   'x'
#define AUX_y                   'y'
#define AUX_z                   'z'
#define AUX_0                   '0'
#define AUX_1                   '1'
#define AUX_2                   '2'
#define AUX_3                   '3'
#define AUX_4                   '4'
#define AUX_5                   '5'
#define AUX_6                   '6'
#define AUX_7                   '7'
#define AUX_8                   '8'
#define AUX_9                   '9'

/*
** ToolKit Gets and Sets
*/
#define AUX_FD                  1  /* return fd (long) */
#define AUX_COLORMAP            3  /* pass buf of r, g and b (unsigned char) */
#define AUX_GREYSCALEMAP        4
#define AUX_FOGMAP              5  /* pass fog and color bits (long) */
#define AUX_ONECOLOR            6  /* pass index, r, g, and b (long) */

/*
** Color Macros
*/

#define AUX_BLACK               0
#define AUX_RED                 13
#define AUX_GREEN               14
#define AUX_YELLOW              15
#define AUX_BLUE                16
#define AUX_MAGENTA             17
#define AUX_CYAN                18
#define AUX_WHITE               19

extern float auxRGBMap[20][3];

#define AUX_SETCOLOR(x, y) (AUX_WIND_IS_RGB((x)) ? \
                           glColor3fv(auxRGBMap[(y)]) : glIndexf((y)))

/*
** RGB Image Structure
*/

typedef struct _AUX_RGBImageRec {
    GLint sizeX, sizeY;
    unsigned char *data;
} AUX_RGBImageRec;

/*
** Prototypes
*/

FUNCAPI void APIENTRY auxInitDisplayMode(GLenum);
FUNCAPI void APIENTRY auxInitPosition(int, int, int, int);

/* GLenum APIENTRY auxInitWindow(LPCTSTR); */
#ifdef UNICODE
#define auxInitWindow auxInitWindowW
#else
#define auxInitWindow auxInitWindowA
#endif
GLenum APIENTRY auxInitWindowA(LPCSTR);
GLenum APIENTRY auxInitWindowW(LPCWSTR);

FUNCAPI void APIENTRY auxCloseWindow(void);
FUNCAPI void APIENTRY auxQuit(void);
FUNCAPI void APIENTRY auxSwapBuffers(void);

typedef void (CALLBACK* AUXMAINPROC)(void);
FUNCAPI void APIENTRY auxMainLoop(AUXMAINPROC);

typedef void (CALLBACK* AUXEXPOSEPROC)(int, int);
FUNCAPI void APIENTRY auxExposeFunc(AUXEXPOSEPROC);

typedef void (CALLBACK* AUXRESHAPEPROC)(GLsizei, GLsizei);
FUNCAPI void APIENTRY auxReshapeFunc(AUXRESHAPEPROC);

typedef void (CALLBACK* AUXIDLEPROC)(void);
FUNCAPI void APIENTRY auxIdleFunc(AUXIDLEPROC);

typedef void (CALLBACK* AUXKEYPROC)(void);
FUNCAPI void APIENTRY auxKeyFunc(int, AUXKEYPROC);

typedef void (CALLBACK* AUXMOUSEPROC)(AUX_EVENTREC *);
FUNCAPI void APIENTRY auxMouseFunc(int, int, AUXMOUSEPROC);

FUNCAPI int  APIENTRY auxGetColorMapSize(void);
FUNCAPI void APIENTRY auxGetMouseLoc(int *, int *);
FUNCAPI void APIENTRY auxSetOneColor(int, float, float, float);
FUNCAPI void APIENTRY auxSetFogRamp(int, int);
FUNCAPI void APIENTRY auxSetGreyRamp(void);
FUNCAPI void APIENTRY auxSetRGBMap(int, float *);

/* AUX_RGBImageRec * APIENTRY auxRGBImageLoad(LPCTSTR); */
#ifdef UNICODE
#define auxRGBImageLoad auxRGBImageLoadW
#else
#define auxRGBImageLoad auxRGBImageLoadA
#endif
FUNCAPI AUX_RGBImageRec * APIENTRY auxRGBImageLoadA(LPCSTR);
FUNCAPI AUX_RGBImageRec * APIENTRY auxRGBImageLoadW(LPCWSTR);

#ifdef UNICODE
#define auxDIBImageLoad auxDIBImageLoadW
#else
#define auxDIBImageLoad auxDIBImageLoadA
#endif
FUNCAPI AUX_RGBImageRec * APIENTRY auxDIBImageLoadA(LPCSTR);
FUNCAPI AUX_RGBImageRec * APIENTRY auxDIBImageLoadW(LPCWSTR);

FUNCAPI void APIENTRY auxCreateFont(void);
/* void APIENTRY auxDrawStr(LPCTSTR); */
#ifdef UNICODE
#define auxDrawStr auxDrawStrW
#else
#define auxDrawStr auxDrawStrA
#endif
FUNCAPI void APIENTRY auxDrawStrA(LPCSTR);
FUNCAPI void APIENTRY auxDrawStrW(LPCWSTR);

FUNCAPI void APIENTRY auxWireSphere(GLdouble);
FUNCAPI void APIENTRY auxSolidSphere(GLdouble);
FUNCAPI void APIENTRY auxWireCube(GLdouble);
FUNCAPI void APIENTRY auxSolidCube(GLdouble);
FUNCAPI void APIENTRY auxWireBox(GLdouble, GLdouble, GLdouble);
FUNCAPI void APIENTRY auxSolidBox(GLdouble, GLdouble, GLdouble);
FUNCAPI void APIENTRY auxWireTorus(GLdouble, GLdouble);
FUNCAPI void APIENTRY auxSolidTorus(GLdouble, GLdouble);
FUNCAPI void APIENTRY auxWireCylinder(GLdouble, GLdouble);
FUNCAPI void APIENTRY auxSolidCylinder(GLdouble, GLdouble);
FUNCAPI void APIENTRY auxWireIcosahedron(GLdouble);
FUNCAPI void APIENTRY auxSolidIcosahedron(GLdouble);
FUNCAPI void APIENTRY auxWireOctahedron(GLdouble);
FUNCAPI void APIENTRY auxSolidOctahedron(GLdouble);
FUNCAPI void APIENTRY auxWireTetrahedron(GLdouble);
FUNCAPI void APIENTRY auxSolidTetrahedron(GLdouble);
FUNCAPI void APIENTRY auxWireDodecahedron(GLdouble);
FUNCAPI void APIENTRY auxSolidDodecahedron(GLdouble);
FUNCAPI void APIENTRY auxWireCone(GLdouble, GLdouble);
FUNCAPI void APIENTRY auxSolidCone(GLdouble, GLdouble);
FUNCAPI void APIENTRY auxWireTeapot(GLdouble);
FUNCAPI void APIENTRY auxSolidTeapot(GLdouble);

/*
** Window specific functions
** hwnd, hdc, and hglrc valid after auxInitWindow()
*/
FUNCAPI HWND  APIENTRY auxGetHWND(void);
FUNCAPI HDC   APIENTRY auxGetHDC(void);
FUNCAPI HGLRC APIENTRY auxGetHGLRC(void);

/*
** Viewperf support functions and constants
*/
/* Display Mode Selection Criteria */
enum {
    AUX_USE_ID = 1,
    AUX_EXACT_MATCH,
    AUX_MINIMUM_CRITERIA
};
FUNCAPI void   APIENTRY auxInitDisplayModePolicy(GLenum);
FUNCAPI GLenum APIENTRY auxInitDisplayModeID(GLint);
FUNCAPI GLenum APIENTRY auxGetDisplayModePolicy(void);
FUNCAPI GLint  APIENTRY auxGetDisplayModeID(void);
FUNCAPI GLenum APIENTRY auxGetDisplayMode(void);

#ifdef __cplusplus
}
#endif

#endif /* __GLAUX_H__ */
