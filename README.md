# System.ByteStrings

Unofficial ByteStrings Patch To Enable AnsiString Support In Delphi Next Generation

Current:

System.ByteStrings for 10.2 Berlin

Delphi 10.1+ Berlin reintroduces UTF8String and RawByteString for the NextGen compilers (Android, iOS, Linux). But ShortString and AnsiString are still missing. The compiler has full support for them but you can¡¯t use them because they are declared with a leading underscore in the System.pas unit what makes them inaccessible because ¡°_¡± is compiled to ¡°@¡± what you can¡¯t use for an identifier.

By patching DCU files it is possible to make those hidden types accessible.

The unit System.ByteStrings for 10.2 Berlin reintroduces

    ShortString
    AnsiString
    AnsiChar
    PAnsiChar
    PPAnsiChar
    UTF8String (XE5-10 Seattle)
    PUTF8String (XE5-10 Seattle)
    RawByteString (XE5-10 Seattle)
    PRawByteString (XE5-10 Seattle)

Usage:

Add the System.ByteStrings.dcu¡¯s path to the compiler¡¯s search path and add the unit to your uses clauses.

There is no *.PAS file because the DCU is patched with a hex editor to get access to the hidden types.
