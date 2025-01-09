#ifndef __GLOS_H__
#define __GLOS_H__                 // Header guard

// GLOS.H
//
// This is an OS specific header file

#include <windows.h>

// disable data conversion warnings : IS IT GOOD PRACTICE ???
// Add test about compiler used (because #pragma warning(disable : nnnn) isn't recognize by all free compilers C/C++ on Windows)
#if defined(_MSC_VER)
#pragma warning(disable : 4305)     // MIPS
#pragma warning(disable : 4244)     // MIPS
#pragma warning(disable : 4136)     // X86
#pragma warning(disable : 4309)     // X86
#pragma warning(disable : 4051)     // ALPHA
#endif

#endif          // Header guard : __GLOS_H__
