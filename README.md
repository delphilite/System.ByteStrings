# System.ByteStrings

Unofficial ByteStrings Patch To Enable AnsiString Support In Delphi Next Generation

# Description

System.ByteStrings for Delphi 10.2-10.3

Delphi 10.1+ Berlin reintroduces UTF8String and RawByteString for the NextGen compilers (Android, iOS, Linux). But ShortString and AnsiString are still missing. The compiler has full support for them but you can't use them because they are declared with a leading underscore in the System.pas unit what makes them inaccessible because "_" is compiled to "@" what you can't use for an identifier.

By patching DCU files it is possible to make those hidden types accessible.

The unit System.ByteStrings for 10.2-10.3 reintroduces

*  ShortString
*  AnsiString
*  AnsiChar
*  PAnsiChar
*  PPAnsiChar

# Usage

Add the System.ByteStrings.dcu's path to the compiler's search path and add the unit to your uses clauses.

# Sources

There is no System.ByteStrings.pas file because the DCU is patched with a hex editor to get access to the hidden types.

# About Delphi 10.4+

Overall, System.ByteStrings is no longer needed on 10.4+, For compatibility, you can use it like this:

uses
{$IF RTLVersion < 34.0}
  System.ByteStrings,
{$ENDIF}
  ...

See Delphi 10.4: https://www.embarcadero.com/products/rad-studio/whats-new-in-10-4-sydney

Unified Memory Management

Delphi memory management is now unified across all supported platforms – mobile, desktop and server – using the classic implementation of object memory management. Compared to Automatic Reference Counting (ARC), this offers better compatibility with existing code and simpler coding for components, libraries and end user applications. The ARC model remains for string management and interface type references for all platforms. For C++, this change means that the creation and deletion of Delphi-style classes in C++ follows normal memory management just like any heap-allocated C++ class, significantly reducing complexity.