program demo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
{$IF RTLVersion < 34.0}
  System.ByteStrings,
{$ENDIF}
  System.RTLConsts,
  System.SysUtils;

const
  conBase64Out: array[0..64] of AnsiChar = (
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
    'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/', '='
  );

  conBase64In: array[0..127] of Byte = (
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 62, 255, 255, 255, 63, 52, 53, 54, 55,
    56, 57, 58, 59, 60, 61, 255, 255, 255, 64, 255, 255, 255,
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
    13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
    255, 255, 255, 255, 255, 255, 26, 27, 28, 29, 30, 31, 32,
    33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45,
    46, 47, 48, 49, 50, 51, 255, 255, 255, 255, 255
  );

function Base64Decode(const AInput: AnsiString): AnsiString;
var
  nIndex, nLength, nSize: Integer;
  pBuffer: PAnsiChar;
  DataIn0, DataIn1, DataIn2, DataIn3: Byte;
begin
  Result := '';
  if AInput = '' then
    Exit;
  nLength := Length(AInput);
  if nLength and 3 <> 0 then
    raise EConvertError.Create(SInvalidStringLength);
  nSize := 3 * (nLength div 4);
  if AInput[nLength - 1] = '=' then
    Dec(nSize);
  if AInput[nLength] = '=' then
    Dec(nSize);
  SetLength(Result, nSize);
  if nSize = 0 then
    Exit;
  pBuffer := PAnsiChar(Result);
  nIndex := 1;
  while nIndex < nLength do
  begin
    DataIn0 := conBase64In[Byte(AInput[nIndex])];
    DataIn1 := conBase64In[Byte(AInput[nIndex + 1])];
    DataIn2 := conBase64In[Byte(AInput[nIndex + 2])];
    DataIn3 := conBase64In[Byte(AInput[nIndex + 3])];
    pBuffer^ := AnsiChar(((DataIn0 and $3F) shl 2) + ((DataIn1 and $30) shr 4));
    Inc(pBuffer);
    if DataIn2 <> $40 then
    begin
      pBuffer^ := AnsiChar(((DataIn1 and $0F) shl 4) + ((DataIn2 and $3C) shr 2));
      Inc(pBuffer);
      if DataIn3 <> $40 then
      begin
        pBuffer^ := AnsiChar(((DataIn2 and $03) shl 6) + (DataIn3 and $3F));
        Inc(pBuffer);
      end;
    end;
    nIndex := nIndex + 4;
  end;
end;

function Base64Encode(const AInput: AnsiString): AnsiString;
var
  nIndex, nLength, nSize: Integer;
  pBuffer: PAnsiChar;
begin
  nLength := Length(AInput);
  nSize := 4 * ((nLength + 2) div 3);
  SetLength(Result, nSize);
  if nSize = 0 then Exit;
  pBuffer := PAnsiChar(Result);
  nIndex := 1;
  while nIndex <= nLength do
  begin
    pBuffer[0] := conBase64Out[(Byte(AInput[nIndex]) and $FC) shr 2];
    if (nIndex + 1) <= nLength then
    begin
      pBuffer[1] := conBase64Out[((Byte(AInput[nIndex]) and $03) shl 4) +
        ((Byte(AInput[nIndex + 1]) and $F0) shr 4)];
      if (nIndex + 2) <= nLength then
      begin
        pBuffer[2] := conBase64Out[((Byte(AInput[nIndex + 1]) and $0F) shl 2) +
          ((Byte(AInput[nIndex + 2]) and $C0) shr 6)];
        pBuffer[3] := conBase64Out[(Byte(AInput[nIndex + 2]) and $3F)];
      end
      else begin
        pBuffer[2] := conBase64Out[(Byte(AInput[nIndex + 1]) and $0F) shl 2];
        pBuffer[3] := '=';
      end
    end
    else begin
      pBuffer[1] := conBase64Out[(Byte(AInput[nIndex]) and $03) shl 4];
      pBuffer[2] := '=';
      pBuffer[3] := '=';
    end;
    Inc(pBuffer, 4);
    Inc(nIndex, 3);
  end;
end;

var
  B: string;
  S, T: AnsiString;
begin
  B := '1234';
  try
    S := Base64Encode(AnsiString(B));
    T := Base64Decode(S);
    if B = T then
      Writeln('test ok')
    else Writeln('test error!');
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  if DebugHook <> 0 then Readln;
end.
