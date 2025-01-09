#ifndef __GLAUX_H__
#define __GLAUX_H__

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

/*             Added by Thierry DECHAIZE

Add APIENTRY for all exposed functions into DLL GLAUX.DLL (each prefix by "__declspec(dllexport)")

What is definition of CALLBACK in C ?

It's #defined as __stdcall, because that's what the Win32 API assumes about callback functions.
It's a calling convention - it describes the way a function call is arranged on the low level -
how are parameters arranged on the CPU stack, and suchlike.
The assumptions about the expected stack layout (i. e. the calling convention) must match between
the caller and the callee, otherwise all kinds of fun consequences might ensue.

Historically, on the Intel CPUs there were multiple calling conventions; more if you count
non-Microsoft compilers. Even more if you count languages other than C[++] that are capable of
calling and getting called by Windows API. Making sure your Windows API callbacks are explicitly
marked as __stdcall to match the WinAPI expectation is a good practice.
In some cases, depending on compiler and settings, __stdcall is the default calling convention
(i. e. you can safely omit CALLBACK), but not always.

Back in Win16, CALLBACK was defined as far pascal. That's even less likely to be the default for
user functions, especially in a C program. The fact that callbacks were assumed to have a Pascal
calling convention was an historical artifact. It also worked as a microoptimization.

And force "C" linkage by adding in each sources file and include file, at the beginning and at the end :

#ifdef __cplusplus
extern "C" {
#endif
...
...
...
#ifdef __cplusplus
}
#endif

 */

#include <windows.h>
#include <GL/gl.h>
#include <GL/glu.h>

#ifdef __cplusplus
extern "C" {
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

#define AUX_SETCOLOR(x, y) (AUX_WIND_IS_RGB((x)) ? glColor3fv(auxRGBMap[(y)]) : glIndexf((y)))

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

__declspec(dllexport) void APIENTRY auxInitDisplayMode(GLenum);
__declspec(dllexport) void APIENTRY auxInitPosition(int, int, int, int);

/* GLenum APIENTRY auxInitWindow(LPCTSTR); */
#ifdef UNICODE
#define auxInitWindow auxInitWindowW
#else
#define auxInitWindow auxInitWindowA
#endif
__declspec(dllexport) GLenum APIENTRY auxInitWindowA(LPCSTR);
__declspec(dllexport) GLenum APIENTRY auxInitWindowW(LPCWSTR);

__declspec(dllexport) void APIENTRY auxCloseWindow(void);
__declspec(dllexport) void APIENTRY auxQuit(void);
__declspec(dllexport) void APIENTRY auxSwapBuffers(void);

typedef void (CALLBACK* AUXMAINPROC)(void);
__declspec(dllexport) void APIENTRY auxMainLoop(AUXMAINPROC);

typedef void (CALLBACK* AUXEXPOSEPROC)(int, int);
__declspec(dllexport) void APIENTRY auxExposeFunc(AUXEXPOSEPROC);

typedef void (CALLBACK* AUXRESHAPEPROC)(GLsizei, GLsizei);
__declspec(dllexport) void APIENTRY auxReshapeFunc(AUXRESHAPEPROC);

typedef void (CALLBACK* AUXIDLEPROC)(void);
__declspec(dllexport) void APIENTRY auxIdleFunc(AUXIDLEPROC);

typedef void (CALLBACK* AUXKEYPROC)(void);
__declspec(dllexport) void APIENTRY auxKeyFunc(int, AUXKEYPROC);

typedef void (CALLBACK* AUXMOUSEPROC)(AUX_EVENTREC *);
__declspec(dllexport) void APIENTRY auxMouseFunc(int, int, AUXMOUSEPROC);

__declspec(dllexport) int  APIENTRY auxGetColorMapSize(void);
__declspec(dllexport) void APIENTRY auxGetMouseLoc(int *, int *);
__declspec(dllexport) void APIENTRY auxSetOneColor(int, float, float, float);
__declspec(dllexport) void APIENTRY auxSetFogRamp(int, int);
__declspec(dllexport) void APIENTRY auxSetGreyRamp(void);
__declspec(dllexport) void APIENTRY auxSetRGBMap(int, float *);

/* AUX_RGBImageRec * APIENTRY auxRGBImageLoad(LPCTSTR); */
#ifdef UNICODE
#define auxRGBImageLoad auxRGBImageLoadW
#else
#define auxRGBImageLoad auxRGBImageLoadA
#endif
__declspec(dllexport) APIENTRY AUX_RGBImageRec *auxRGBImageLoadA(LPCSTR filename);
__declspec(dllexport) APIENTRY AUX_RGBImageRec *auxRGBImageLoadW(LPCWSTR filename);

#ifdef UNICODE
#define auxDIBImageLoad auxDIBImageLoadW
#else
#define auxDIBImageLoad auxDIBImageLoadA
#endif
__declspec(dllexport) APIENTRY AUX_RGBImageRec *auxDIBImageLoadA(LPCSTR);
__declspec(dllexport) APIENTRY AUX_RGBImageRec *auxDIBImageLoadW(LPCWSTR);

__declspec(dllexport) void APIENTRY auxCreateFont(void);
/* __declspec(dllexport) void APIENTRY auxDrawStr(LPCTSTR); */
#ifdef UNICODE
#define auxDrawStr auxDrawStrW
#else
#define auxDrawStr auxDrawStrA
#endif
__declspec(dllexport) void APIENTRY auxDrawStrA(LPCSTR);
__declspec(dllexport) void APIENTRY auxDrawStrW(LPCWSTR);

__declspec(dllexport) void APIENTRY auxWireSphere(GLdouble);
__declspec(dllexport) void APIENTRY auxSolidSphere(GLdouble);
__declspec(dllexport) void APIENTRY auxWireCube(GLdouble);
__declspec(dllexport) void APIENTRY auxSolidCube(GLdouble);
__declspec(dllexport) void APIENTRY auxWireBox(GLdouble, GLdouble, GLdouble);
__declspec(dllexport) void APIENTRY auxSolidBox(GLdouble, GLdouble, GLdouble);
__declspec(dllexport) void APIENTRY auxWireTorus(GLdouble, GLdouble);
__declspec(dllexport) void APIENTRY auxSolidTorus(GLdouble, GLdouble);
__declspec(dllexport) void APIENTRY auxWireCylinder(GLdouble, GLdouble);
__declspec(dllexport) void APIENTRY auxSolidCylinder(GLdouble, GLdouble);
__declspec(dllexport) void APIENTRY auxWireIcosahedron(GLdouble);
__declspec(dllexport) void APIENTRY auxSolidIcosahedron(GLdouble);
__declspec(dllexport) void APIENTRY auxWireOctahedron(GLdouble);
__declspec(dllexport) void APIENTRY auxSolidOctahedron(GLdouble);
__declspec(dllexport) void APIENTRY auxWireTetrahedron(GLdouble);
__declspec(dllexport) void APIENTRY auxSolidTetrahedron(GLdouble);
__declspec(dllexport) void APIENTRY auxWireDodecahedron(GLdouble);
__declspec(dllexport) void APIENTRY auxSolidDodecahedron(GLdouble);
__declspec(dllexport) void APIENTRY auxWireCone(GLdouble, GLdouble);
__declspec(dllexport) void APIENTRY auxSolidCone(GLdouble, GLdouble);
__declspec(dllexport) void APIENTRY auxWireTeapot(GLdouble);
__declspec(dllexport) void APIENTRY auxSolidTeapot(GLdouble);

/*
** Window specific functions
** hwnd, hdc, and hglrc valid after auxInitWindow()
*/
__declspec(dllexport) HWND  APIENTRY auxGetHWND(void);
__declspec(dllexport) HDC   APIENTRY auxGetHDC(void);
__declspec(dllexport) HGLRC APIENTRY auxGetHGLRC(void);

/*
** Viewperf support functions and constants
*/
/* Display Mode Selection Criteria */
enum {
    AUX_USE_ID = 1,
    AUX_EXACT_MATCH,
    AUX_MINIMUM_CRITERIA
};
/*
void   APIENTRY auxInitDisplayModePolicy(GLenum);
GLenum APIENTRY auxInitDisplayModeID(GLint);
GLenum APIENTRY auxGetDisplayModePolicy(void);
GLint  APIENTRY auxGetDisplayModeID(void);
GLenum APIENTRY auxGetDisplayMode(void);
*/
#ifdef __cplusplus
}
#endif

#endif /* __GLAUX_H__ : Header guard */


