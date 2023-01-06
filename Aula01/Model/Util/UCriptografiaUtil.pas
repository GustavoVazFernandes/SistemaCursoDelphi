unit UCriptografiaUtil;

interface

uses Sysutils;

type
   TCriptografia = class
      private
         function  charNum(pCh: Char): Integer;
         function  numChar(N: Integer): Char;
         function  encriptaByte(B: Byte; pChave: Word): String;
         function  decriptaByte(pValor: String; pChave: Word): Byte;
         procedure proximaChave(var pChave: Word; pPos: Integer);
         function Asc(pString: String): Integer;

      public
         function encriptaString(pValor: String; pTamanho: Integer): String;
         function decriptaString(pValor: String): String;
         function DecriptaASCII(pString: String; pTamanho: Word): String;
         function EncriptaASCII(pString: String; pTamanho: Word): String;
   end;
   
implementation

uses UClassFuncoes;

const
   DICIONARIO : array[0..35] of Char =
      ('0','1','2','3','4','5',
       '6','7','8','9','A','B',
       'C','D','E','F','G','H',
       'I','J','K','L','M','N',
       'O','P','Q','R','S','T',
       'U','V','W','X','Y','Z');
   CHAVE: string = 'TETATS';

function TCriptografia.charNum(pCh: Char): Integer;
var
   i : Integer;
begin
   Result := 0;

   for i := 0 To 35 do
      if pCh = DICIONARIO[i] then
      begin
         Result := i;
         Exit;
      end;
end;

function TCriptografia.numChar(N: Integer): Char;
begin
   Result := DICIONARIO[N];
end;

function TCriptografia.encriptaByte(B: Byte; pChave: Word): String;
begin
   B := B xor (pChave and $FF);
   Result := numChar((B and $0F) + ((pChave shr 8) mod 19)) +
             numChar((B shr 4) + ((pChave shr 8) mod 19));
end;

function TCriptografia.decriptaByte(pValor: String; pChave: Word): Byte;
begin
   If Length(pValor) < 2 Then
      Begin
      Result := 0;
      Exit;
   End;

   Result := (charNum(pValor[1]) - ((pChave shr 8) mod 19)) +
             ((charNum(pValor[2]) - ((pChave shr 8) mod 19)) shl 4);
   Result := Result xor (pChave and $FF);
end;

procedure TCriptografia.proximaChave(var pChave: Word; pPos: Integer);
begin
   pChave := ((pChave+Ord(CHAVE[(pPos mod Length(CHAVE))+1])) * 17) mod $4321;
end;

function TCriptografia.encriptaString(pValor: String; pTamanho: Integer): String;
var
   vChave : Word;
   i      : Integer;
begin
   pValor := pValor + StringOfChar(#0,pTamanho-Length(pValor));

   Result := '';
   vChave := 0;
   For i := 1 To Length(pValor) Do
      Begin
      Result := Result + encriptaByte(Ord(pValor[i]),vChave);
      vChave := vChave xor Ord(pValor[i]);
      proximaChave(vChave,i);
   End;
end;

function TCriptografia.decriptaString(pValor: String): String;
var
   vChave : Word;
   i      : Integer;
   vByte  : Byte;
begin
   Result := '';
   vChave := 0;
   i      := 1;

   while i <= Length(pValor) do
   begin
      vByte  := decriptaByte(Copy(pValor,i,2),vChave);
      Result := Result + Chr(vByte);
      vChave := vChave xor vByte;
      proximaChave(vChave,(i div 2)+1);
      Inc(i,2);
   end;

   if Pos(#0,Result) <> 0 then
      Result := Copy(Result, 1, Pos(#0,Result)-1);
end;

function TCriptografia.EncriptaASCII(pString: String;pTamanho : Word) : String;
var
   xSeq2 : Integer;
   xComp : Integer;
begin
   If pTamanho < 10 Then
      For xComp := Length(pString) To 10 Do
          pString := pString + ' ';

   Result := '';

   For xSeq2 := pTamanho DownTo 1 Do
       Result := Result + TFuncoes.StrZero(IntToStr(Asc(Copy(pString,xSeq2,1))),3);

end;

function TCriptografia.Asc(pString : String) : Integer;
var
   VFS: String;
begin
   VFS    := pString;
   Result := Ord(VFS[1]);
end;

function TCriptografia.DecriptaASCII(pString: String;pTamanho:Word) : String;
var
   xSeq2 : Integer;
begin
   Result := '';

   For xSeq2 := pTamanho DownTo 1 Do
       Result := Result + Chr(StrToInt(Copy(pString,xSeq2*3-2,3)));
end;

end.
