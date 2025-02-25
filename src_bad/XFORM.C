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

Add APIENTRY for all exposed functions into DLL GLAUX.DLL (each prefix by "__declspec(dllexport)"), if necessary.

And force "C" linkage by adding in each sources file and include file (if necessary), at the beginning and at the end :

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
#include <math.h>
#include <stdio.h>
#include <GL/gl.h>
#include "3d.h"

#define static

#ifdef __cplusplus
extern "C" {
#endif

#define STACKDEPTH 10

typedef struct {
    GLdouble	mat[4][4];
    GLdouble	norm[3][3];
} mat_t;

static mat_t matstack[STACKDEPTH] = {
    {{{1.0, 0.0, 0.0, 0.0},
    {0.0, 1.0, 0.0, 0.0},
    {0.0, 0.0, 1.0, 0.0},
    {0.0, 0.0, 0.0, 1.0}},
    {{1.0, 0.0, 0.0},
    {0.0, 1.0, 0.0},
    {0.0, 0.0, 1.0}}}
};
static int identitymat = 1;

static int mattop = 0;

void m_xformpt(GLdouble pin[3], GLdouble pout[3],
    GLdouble nin[3], GLdouble nout[3])
{
    int	i;
    GLdouble	ptemp[3], ntemp[3];
    mat_t	*m = &matstack[mattop];

    if (identitymat) {
	for (i = 0; i < 3; i++) {
	    pout[i] = pin[i];
	    nout[i] = nin[i];
	}
	return;
    }
    for (i = 0; i < 3; i++) {
	ptemp[i] = pin[0]*m->mat[0][i] +
		   pin[1]*m->mat[1][i] +
		   pin[2]*m->mat[2][i] +
		   m->mat[3][i];
	ntemp[i] = nin[0]*m->norm[0][i] +
		   nin[1]*m->norm[1][i] +
		   nin[2]*m->norm[2][i];
    }
    for (i = 0; i < 3; i++) {
	pout[i] = ptemp[i];
	nout[i] = ntemp[i];
    }
    normalize(nout);
}

void m_xformptonly(GLdouble pin[3], GLdouble pout[3])
{
    int	i;
    GLdouble	ptemp[3];
    mat_t	*m = &matstack[mattop];

    if (identitymat) {
	for (i = 0; i < 3; i++) {
	    pout[i] = pin[i];
	}
	return;
    }
     for (i = 0; i < 3; i++) {
	ptemp[i] = pin[0]*m->mat[0][i] +
		   pin[1]*m->mat[1][i] +
		   pin[2]*m->mat[2][i] +
		   m->mat[3][i];
    }
    for (i = 0; i < 3; i++) {
	pout[i] = ptemp[i];
    }
}

void m_pushmatrix(void)
{
    if (mattop < STACKDEPTH-1) {
	matstack[mattop+1] = matstack[mattop];
	mattop++;
    } else
	error("m_pushmatrix: stack overflow\n");
}

void m_popmatrix(void)
{
    if (mattop > 0)
	mattop--;
    else
	error("m_popmatrix: stack underflow\n");
}

void m_translate(GLdouble x, GLdouble y, GLdouble z)
{
    int	i;
    mat_t	*m = &matstack[mattop];

    identitymat = 0;
    for (i = 0; i < 4; i++)
	m->mat[3][i] = x*m->mat[0][i] +
				 y*m->mat[1][i] +
				 z*m->mat[2][i] +
				 m->mat[3][i];
}

void m_scale(GLdouble x, GLdouble y, GLdouble z)
{
    int	i;
    mat_t	*m = &matstack[mattop];

    identitymat = 0;
    for (i = 0; i < 3; i++) {
	m->mat[0][i] *= x;
	m->mat[1][i] *= y;
	m->mat[2][i] *= z;
    }
    for (i = 0; i < 3; i++) {
	m->norm[0][i] /= x;
	m->norm[1][i] /= y;
	m->norm[2][i] /= z;
    }
}

#ifdef __cplusplus
}
#endif
