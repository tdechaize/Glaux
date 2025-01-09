#ifndef __GLOS_H__
#define __GLOS_H__

// GLOS.H
//
// This is an OS specific header file

#include <windows.h>

// disable data conversion warnings

#if !defined(__MINGW32__) && !defined(__MINGW64__)
#pragma warning(disable : 4305)     // MIPS
#pragma warning(disable : 4244)     // MIPS
#pragma warning(disable : 4136)     // X86
#pragma warning(disable : 4309)     // X86
#pragma warning(disable : 4051)     // ALPHA
#endif

#endif // header guard

