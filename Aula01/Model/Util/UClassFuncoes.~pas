unit UClassFuncoes;


interface

uses
   SysUtils, Math, WinInet, Classes, ShellAPI, Controls, TypInfo, Mask,
   Graphics, SqlExpr, Grids, DBGrids, DBClient, Windows, Types, Messages,
   TLHelp32, Comobj, Forms;

const
  CBooleanSN           : array[boolean] of Char = ('N','S');
  CBooleanSimNao       : array[boolean] of String = ('Nao','Sim');
  CARACTERES_ESPECIAIS = '&;ØøÐÞþðÆßæ¼½¡¾£©¥®§ª¤²¦³«¹¬¯µº¶´·¨°±¸»¿×¢÷^;ºª`~';
  CARACTERES_ALFA      = 'àáâãäåèéêëìíîïòóôõöùúûüçýÿñÀÁÂÃÄÅÈÉÊËÌÍÎÏÒÓÔÕÖÙÚÛÜÇÝŸÑ€';
  CARACTERES_NORMAIS   = 'aaaaaaeeeeiiiiooooouuuucyynAAAAAAEEEEIIIIOOOOOUUUUCYYNC';

type
   TTipoRecurso = (tpTXT, tpEXE, tpDLL);
   TTipoComparacao = (tcIgual, tcMaior, tcMenor);

   TFuncoes = class
      private
       class function SerialSmart: String;
       class function SerialVolume: String;
       class function KillTask(ExeFileName: string): Integer;
      public
         class function BooleanToInt(pBool: Boolean): Integer;
         class function IsNumero2(pTexto: String): Boolean;
         class function IntToBoolean(pInt: Integer): Boolean;
         class function PadL(VFString: String; VFTamanho: Integer): String;
         class function PadR(pString: String; pTamanho: Integer): String;
         class function PadC(VFString: string; VFTamanho: Integer): String;
         class function Replicar(pChr: string; pQtde: Integer) : String;
         class function RetornaEspaco(VFTamanho : Integer) : String;
         class function StrZero(VFString: String; VFTamanho: Integer): String;
         class function LocalizaStringEmOutraString(VFParte : String ; VFString : String) : Boolean;
         class function FRound(VFCasasDecimais : Integer; VFNumero : Double) : Double;
         class function FRoundCientifico(Decimals: integer; Value: Double): Double;
         class function RetornaDescontoPercEmValor(vfValorBruto, vfDescontoPerc: Double): Double;
         class function validaCodigoEAN(pCodigo: string): boolean;
         class function ValidaPrefixoGS1(pCodigo: string): Boolean;
         class function conectadoInternet(pMostraMsg : Boolean = True): Boolean;
         class function SoNumero(pValor : String): String;
         class function IIF(pCondicao : Boolean; pResultado1, pResultado2 : Variant) : Variant;
         class function ExtraiRecurso(pIDRecurso, pNomeArquivo : String; pTipoRecurso : TTipoRecurso;
                        pCaminho : String = '') : Boolean;
         class function DivisaoSegura(pDividendo, pDivisor : Double) : Double;
         class function Base26(pNumero : Integer): String;
         class function Acha(pParte : String ; pString : String) : Boolean;
         class function Troca(pString, pAnterior, pNovo: string; pManterPosicaoCampo: Boolean = False): string;
         class function ValidaLink(pUrl : String) : Boolean;
         class procedure AbrirLink(pURL : String);
         class function ComparaObjetos(pObj1, pObj2: TObject): Boolean;
         class function CopiaObjeto(pObj: TObject): TObject;
         class function fTrunc(VFCasasDecimais: Integer; VFNumero: Double): Double;
         class function ValidaDataIniFim(
                        var pDataIni  : TMaskEdit;
                        var pDataFim  : TMaskEdit;
                            pLabelIni ,
                            pLabelFim ,
                            pDataAtiva: String;
                            pIgual    : Boolean;
                            pAnoBase  : Integer;
                            pValidaDataIni: Boolean = True): Boolean;
         class function validaHora(pHora: String; var pMensagemRetorno : String): Boolean;
         class function MontaHora(pHora: String): string;
         class function MontaAno(pData: String; pAnoBase: Integer): String;
         class function RetornaNomeEstado(pUF: String; pUpperCase: Boolean = True): String;
         class function ValidaLetrasNumeros(pTexto: String; pIgnoraEspaco: Boolean): Boolean;
         class function validaEmail(const pEmail: string): Boolean;
         class function RemoveExcessoEspacos(pTexto: String): String;
         class function TrocaAcento(pTexto: String): String;
         class function IsNumero(pValor: String): Boolean;
         class function VerificaUtilizacaoCEST(pCSOSN, pCST: String;
            pSimplesNacional: Boolean = False): Boolean;
         class function NomeComputador: String;
         class function StringToStyle(pString: String): TFontStyles;
         class function removeCaracterEspecial(pTexto: string;
                                               pCaracterExtra: Boolean): string;
         class function SerialNumHd: String;
         class function validaEmailHotmail(pEmail: string): Boolean;
         class function validaEmailGmail(pEmail: string): Boolean;
         class procedure ordenaColuna(pColuna : TColumn; pDataSet : TCustomClientDataSet;
                                      pComplemento: String = '');
         class procedure ordenaTStrings(pLista : TStrings);


         class procedure DBGridImgMarcadorGenerico(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
                                                            State: TGridDrawState; ImageListMarcadores: TImageList);
         class function ListarArquivos(pDiretorio: String; pSubDir: Boolean): TStringList;
         class function RetornaTextoFormatado(
                           pTexto            : String;
                           pQtdCaracterLinha : Integer;
                           pMargem           : String = '';
                           pTrocaEnter       : String = '') : String;
         class function validaSMTPHotmail(pSMTP: string): Boolean;
         class function CriaProcesso(const pCommand: String): Cardinal;
         class function ComparaValor(
                           pValor1        ,
                           pValor2        : Double;
                           pDifPermitida  : Double;
                           pTipoComparacao: TTipoComparacao = tcIgual) : Boolean;
         class function GetHWNDFromPID(const pId: Cardinal): HWND;
         class procedure SetaFocoProcessoExterno(pHandle: HWND);
         class procedure FinalizaProcesso(pNomeExe : String);
         class function RetornaIdProcesso: Integer;
         class function ProcessoExiste(pExeName: String; pIDProcesso: Integer): Boolean;
         class function RetornaSerieConvertida(pSerie: string; pRetornarCodigo: Boolean = False; pNormalizada: Boolean = False): String;
         class function VerificaSerieContingencia(pSerie: String): Boolean;
         class function validaEstadoCidadeSUFRAMA(pEstado, pMunicipio: String; pSoEstado: Boolean = false): Boolean;
         class function possuiCaraterEspecial(pTexto : string) : Boolean;
         class function ValidaCNPJCPF(pCNPJCPF: String; pTipoPessoa: String = 'F'): Boolean;
         class function NomeMes(pMes: Integer): String;
         class function DataExtensa(pData: TDateTime): String;
         class function ShellUnzip(pArquivoZip, pPastaDestino: string;
                           pFiltro: string = ''): Boolean;
         class function ValidaNumeroNaoPermitido(
		                   pCodGerado   : String; 
						   pCodComparado: String = ''; 
						   pQtdeCaracter: Integer = 0): Boolean;
         class procedure PreenchePropriedade(pObjeto: TObject; pPropertyName: String; pValue: Variant);
         class function ValorPropriedade(pObjeto: TObject; pPropertyName: String): Variant;
         class function RetornaListaPropriedades(pObjeto: TObject): TStrings;   
         class function Base36(pNumero, pQuantidadeCasas: Integer): String;
         class function ValidaData(var pData: TMaskEdit; pLabelData: String;
            pPermiteVazio: Boolean = false; pAnoBase: Integer = 0): Boolean;
         class procedure CentralizaForm(pForm: TForm);
   end;

const
  SHCONTCH_NOPROGRESSBOX = 4;
  SHCONTCH_AUTORENAME = 8;
  SHCONTCH_RESPONDYESTOALL = 16;
  SHCONTF_INCLUDEHIDDEN = 128;
  SHCONTF_FOLDERS = 32;
  SHCONTF_NONFOLDERS = 64;
  
implementation

uses Variants, DB, StrUtils;

{ TFuncoes }

class function TFuncoes.FRound(VFCasasDecimais: Integer; VFNumero: Double): Double;
var
   i: Integer;
   MMascara,
   MNumeroConvString: String;
begin
   MMascara := '########0.';

   For i := 1 to VFCasasDecimais Do
       MMascara := MMascara + '0';

   MNumeroConvString := FormatFloat(MMascara,VFNumero);

   Result := StrToFloat(MNumeroConvString);
end;

class function TFuncoes.FRoundCientifico(Decimals: integer; Value: Double): Double;
var
  Factor, Fraction: Double;
begin
  Factor := IntPower(10, Decimals);
  { A conversão para string e depois para float evita
    erros de arredondamentos indesejáveis. }
  Value := StrToFloat(FloatToStr(Value * Factor));
  Result := Int(Value);
  Fraction := Frac(Value);

  If Fraction >= 0.5 then
     Result := Result + 1
  else if Fraction <= -0.5 then
     Result := Result - 1;

  Result := Result / Factor;
end;

class function TFuncoes.fTrunc(vfCasasDecimais : Integer; vfNumero : Double) : Double;
var
  MNumString : String;
  MPonto     : Integer;
  {$IFDEF VER320}//Delphi XE
  xFormatBr  : Tformatsettings;
  {$ENDIF}

begin
   MNumString := FloatToStr(vfNumero);

   {$IFDEF VER320}//Delphi XE
   xFormatBr  := Tformatsettings.create;
   MPonto     := Pos(xFormatBr.DecimalSeparator, MNumString);
   {$ENDIF}

   {$IFDEF VER150}//Delphi 7
   MPonto     := Pos(DecimalSeparator, MNumString);
   {$ENDIF}

   If MPonto > 0 Then
      MNumString := Copy(MNumString, 1, MPonto) +
                    Copy(MNumString, MPonto + 1, vfCasasDecimais);

   Result := StrToFloatDef(MNumString,0);
end;

class function TFuncoes.LocalizaStringEmOutraString(VFParte, VFString: String): Boolean;
var
   X,
   VFTamanhoParte : Integer;
begin
   Result         := False;
   VFTamanhoParte := Length(VFParte);

   For X := 1 To Length(VFString) Do
       If Copy(VFString,X,VFTamanhoParte) = VFParte Then
          Result := True;
end;

class function TFuncoes.PadL(VFString: String; VFTamanho: Integer): String;
Var
  VFRetorno : String;
  X         : Integer;
begin
  VFRetorno := '';

  For X := 1 To Length(VFString) Do
      Begin
      VFRetorno := Copy(VFString, Length(VFString) - (X-1), 1) + VFRetorno;
      If X = VFTamanho Then
         Break;
  End;

  Result := RetornaEspaco(VFTamanho-Length(vfRetorno)) + VFRetorno;

end;

class function TFuncoes.RetornaEspaco(VFTamanho: Integer): String;
Var
  X : Integer;
Begin
  Result := '';
  For X := 1 To VFTamanho Do
      Begin
      Result := Result + ' ';
  End;
end;

class function TFuncoes.StrZero(VFString: String;  VFTamanho: Integer): String;
Var
   VFRetorno : String;
begin
   VFRetorno := TrimLeft(TrimRight(VFString));
   If Length(VfRetorno) > VFTamanho Then
      VfRetorno := tfuncoes.PadL(VfRetorno, VFTamanho);

   While Length(VfRetorno) < VfTamanho Do
         VfRetorno := '0' + VfRetorno;

   Result := VFRetorno;
end;

class function TFuncoes.RetornaDescontoPercEmValor(vfValorBruto, vfDescontoPerc : Double): Double;
begin
   // CHAMADO 29139 - PROJETO REFACTORY
   // SEMPRE SERÃO CONSIDERADAS 2 CASAS DECIMAIS COM O VALOR TRUNCADO E NÃO DEVE
   // SER ALTERADA TAL IMPLEMENTAÇÃO PARA O TRATAMENTO DO DESCONTO PERCENTUAL
   {  A decisão para adotar tal medida foi tomada em um comitê composto por:
      Rodrigo Assunção, José Leandro, Joquim Francisco e Cleber Fonseca        }
   //Chamado 32579 - Foi validado que a função "Trunc" do Delphi está tratando
   //de forma errada os valores. Com a autorização do José Leandro, será
   //substituida pela função "FTrunc".

   Result := FTrunc(2, vfValorBruto * (vfDescontoPerc/ 100));
end;

class function TFuncoes.validaCodigoEAN(pCodigo: string): boolean;
var
  i,
  soma,
  base10,
  resultado : integer;
begin
   //Verifica se todos os caracteres de pCodigo são números
   For i:= 1 to Length(pCodigo) do
      If not (pCodigo[i] in ['0'..'9']) Then
         begin
         Result:= False;
         Exit;
     End;

   //Verifica se pCodigo tem o tamanho necessário
   If Length(pCodigo) in [8,12,13,14] Then
      Begin
      soma := 0;
      For i := 1 to (Length(pCodigo) -1) do
         Begin
         If Length(pCodigo) = 13 then
            Begin
            If Odd(i) Then
               soma:= soma + (strtoint(pCodigo[i]) * 1)
            Else
               soma:= soma + (strtoint(pCodigo[i]) * 3);
         End
         Else
            Begin
            If Odd(i) Then
               soma:= soma + (strtoint(pCodigo[i]) * 3)
            Else
               soma:= soma + (strtoint(pCodigo[i]) * 1);
         End;
      End;
      base10:= soma;

      //Verifica se base10 é múltiplo de 10
      If not (base10 mod 10 = 0) then
         Begin
         While not (base10 mod 10 = 0) do
            Begin
            base10:= base10 + 1;
         End;
      End;
      resultado:= base10 - soma;

      //Verifica se o resultado encontrado é igual ao caractere de controle
      If resultado = strtoint(pCodigo[Length(pCodigo)]) Then
         Result:= True
      Else
         Result:= False;
   End
   Else
      Result:= False;
end;

class function TFuncoes.conectadoInternet(pMostraMsg : Boolean = True): Boolean;
var
   flags : cardinal;
begin

   if not InternetGetConnectedState(@flags,0) then
   begin
      result := false;

      if pMostraMsg then
         Raise Exception.Create('Não foi encontrada conexão com a internet!             '+#13+
                                'Verifique as configurações de seus adaptadores de rede '+#13+
                                'ou seu provedor de acesso à internet.');
   end
   else
      result := true;
end;

class function TFuncoes.SoNumero(pValor: String): String;
Var
   X : Integer;
Begin
   Result := '';
   For X := 1 To Length(pValor) Do
       If Pos(Copy(pValor,X,1), '0123456789') > 0 Then
          Result := Result + Copy(pValor,X,1);

End;

class function TFuncoes.IsNumero(pValor: String) : Boolean;
begin
   try
      StrToInt(pValor);
   except
      on EConvertError do
      begin
         Result := False;
         Exit;
      end;
   end;

   Result := True;
end;

class function TFuncoes.VerificaUtilizacaoCEST(pCSOSN, pCST: String; pSimplesNacional: Boolean): Boolean;
begin
   Result := True;

   if pSimplesNacional then
   begin
      if (Length(pCSOSN) = 4) then
         Delete(pCSOSN, 1, 1);

      if (pCSOSN = '201') or
         (pCSOSN = '202') or
         (pCSOSN = '203') or
         (pCSOSN = '500') or
         (pCSOSN = '900') then
         Exit;
   end
   else
   begin
      if (Length(pCST) = 3) then
         Delete(pCST, 1, 1);

      if (pCST = '10') or
         (pCST = '30') or
         (pCST = '60') or
         (pCST = '70') or
         (pCST = '90') then
         Exit;
   end;
   
   Result := False;
end;

class function TFuncoes.IIF(pCondicao: Boolean; pResultado1,
  pResultado2: Variant): Variant;
begin
   If pCondicao Then
      Result := pResultado1
   Else
      Result := pResultado2;
end;

class function TFuncoes.ExtraiRecurso(pIDRecurso, pNomeArquivo: String; pTipoRecurso : TTipoRecurso;
   pCaminho : String = ''): Boolean;
Var
   PathToSave : String;
   Res : TResourceStream;
begin
   if pCaminho = '' then
      PathToSave := ExtractFilePath(ParamStr(0))
   else
      PathToSave := pCaminho;

   PathToSave := PathToSave + '\'+pNomeArquivo;

   If not FileExists(PathToSave) Then
   Begin
      case pTipoRecurso of
         tpTXT : Res := TResourceStream.Create(Hinstance, pIDRecurso, 'TEXT');
         tpEXE : Res := TResourceStream.Create(Hinstance, pIDRecurso, 'EXEFILE');
         tpDLL : Res := TResourceStream.Create(Hinstance, pIDRecurso, 'DLLFILE');
      end;

      Try
         Res.SavetoFile(PathToSave);//Salva imagem no caminho especificado
      Finally
         Res.Free;
      End;
   End;
end;

//Evita erro de divisão por zero
class function TFuncoes.DivisaoSegura(pDividendo, pDivisor: Double): Double;
begin
   try
      result := 0;

      if (pDivisor = 0) then
         result := 0
      else
         result := pDividendo / pDivisor;
   except
      result := 0;
   end;
end;

class function TFuncoes.Base26(pNumero: Integer): String;
begin
   Result := '';
   Dec(pNumero);
   Result  := Chr(Ord('A') + (pNumero mod 26)) + Result;
   pNumero := pNumero div 26;
   While pNumero <> 0 Do
      Begin
      Result  := Chr(Ord('A') + (pNumero mod 26) - 1) + Result;
      pNumero := pNumero div 26;
   End;
end;

class function TFuncoes.Replicar(pChr: string; pQtde: Integer): String;
var
   i : Integer;
begin
   Result := '';
   for i:=1 to pQtde do
      Result := Result + pChr;
end;

class function TFuncoes.PadC(VFString: string; VFTamanho: Integer): String;
Var
   VFRetorno : String;
Begin
   VFRetorno := VFString;
   While Length(VFRetorno) < VFTamanho Do
      VFRetorno := ' '+VFRetorno+' ';
   Result := Copy(VFRetorno, 1, VFTamanho);
End;

class function TFuncoes.BooleanToInt(pBool: Boolean): Integer;
begin
   Result := iif(pBool, 1, 0);
end;

class function TFuncoes.IntToBoolean(pInt: Integer): Boolean;
begin
   Result := (pInt > 0);
end;

// Retorna a String com o tamanho especificado, preenchendo com espaços
// a direita se necessário.
class function TFuncoes.PadR(pString: String; pTamanho: Integer): String;
Var
  xRetorno       : String;
begin
  xRetorno := Trim(Copy(pString, 1, pTamanho));
  xRetorno := xRetorno + RetornaEspaco(pTamanho-Length(xRetorno));
  Result := xRetorno;
End;

//Localiza uma pParte na pString
class function TFuncoes.Acha(pParte : String ; pString : String) : Boolean;
var
   X,
   xTamanhoParte : Integer;
begin
   Result         := False;
   xTamanhoParte := Length(pParte);

   if xTamanhoParte <= 0 then
      Exit;

   for X := 1 To Length(pString) do
   begin
      Result := Copy(pString,X,xTamanhoParte) = pParte;
      if Result then
         Break;
   end;
end;

//Substitui o texto pAnterior pelo pNovo na PString
class function TFuncoes.Troca(pString : String; pAnterior : String; pNovo : String; pManterPosicaoCampo : Boolean = False) : String;
var
   X,
   xTamanho,
   xTamanhoAntigo,
   xTamanhoNovo     : Integer;
   S                 : String;
begin
   xTamanhoAntigo := Length(pAnterior);
   xTamanho       := 0;
   S              := pString;

   If pManterPosicaoCampo Then
      Begin
      xTamanhoNovo := Length(pNovo);
      xTamanho     := (xTamanhoAntigo - xTamanhoNovo);
      If xTamanho < 0 Then
         xTamanho := 0;
   end;

   For X := 1 To Length(pString) Do
   begin
      If Copy(pString,X,xTamanhoAntigo) = pAnterior Then
      begin
         if X = 1 then
         begin
            if pManterPosicaoCampo then
            begin
               if xTamanhoNovo > xTamanhoAntigo then
                  S := pNovo+Copy(pString,X+xTamanhoNovo,Length(pString))
               else
                  S := pNovo+PadR('',xTamanho)+Copy(pString,X+xTamanhoAntigo,Length(pString));
            end
            else
               S := pNovo+Copy(pString,X+xTamanhoAntigo,Length(pString))
         end
         else
         Begin
            if pManterPosicaoCampo then
            begin
               if xTamanhoNovo > xTamanhoAntigo then
                  S := Copy(pString,1,X-1)+pNovo+Copy(pString,X+xTamanhoNovo,Length(pString))
               else
                  S := Copy(pString,1,X-1)+pNovo+PadR('',xTamanho)+Copy(pString,X+xTamanhoAntigo,Length(pString))
            end
            else
               S := Copy(pString,1,X-1)+pNovo+Copy(pString,X+xTamanhoAntigo,Length(pString));
         end;
      end;
   end;

   if (pAnterior <> pNovo) And
      (Acha(pAnterior,S)) Then
      S := Troca(S,pAnterior,pNovo);

   Result := S;
end;

class function TFuncoes.ValidaLink(pUrl: String): Boolean;
var
   hSession, hfile, hRequest: HINTERNET;
   dwindex, dwcodelen: Cardinal;
   dwcode: array[1..20] of Char;
   res: PChar;
begin
   Result := False;
   if pos('http://', lowercase(pUrl)) = 0 then
      pUrl := 'http://' + pUrl;

   hSession := InternetOpen('InetURL:/1.0', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
   if Assigned(hsession) then
   begin
      hfile := InternetOpenUrl(hsession, pchar(pUrl), nil, 0, INTERNET_FLAG_RELOAD, 0);
      dwIndex := 0;
      dwCodeLen := 10;
      HttpQueryInfo(hfile, HTTP_QUERY_STATUS_CODE, @dwcode, dwcodeLen, dwIndex);
      res := pchar(@dwcode);
      result := (res = '200') or (res = '302');
      if Assigned(hfile) then
         InternetCloseHandle(hfile);

      InternetCloseHandle(hsession);
   end;
end;

class procedure TFuncoes.AbrirLink(pURL: String);
begin
   {$IFDEF VER320}//Delphi XE
   ShellExecute(0, 'open', PwideChar(pURL), '', '', 1);
   {$ENDIF}

   {$IFDEF VER150}//Delphi 7
   ShellExecute(0, 'open', PAnsiChar(pURL), '', '', 1);
   {$ENDIF}
end;

class function TFuncoes.MontaAno(pData: String; pAnoBase: Integer) : String;
var
   xAnoData : Integer;
   xAnoFim  : String;
   xAno,
   xMes,
   xDia  : Word;

begin
   pData := StringReplace(pData, '_', ' ', [rfReplaceAll]);
   
   DecodeDate(Date, xAno, xMes, xDia);

   xAnoFim := Copy(Trim(pData),7,4);
   If Trim(xAnoFim) = ''  Then
      Begin
      If Trim(Copy(pData, 1, 2)) = '' Then
         Begin
         Result := pData;
         Exit;
      End;
      If (Trim(Copy(pData, 4, 2)) = '') Then
         Begin
         If (Copy(pData,2,1) = '/') Then
            pData := StrZero(Copy(pData,1,1),2)+'/'+StrZero(IntToStr(xMes),2)+'/'+StrZero(IntToStr(xAno),4)
         Else
            pData := StrZero(Copy(pData,1,2),2)+'/'+StrZero(IntToStr(xMes),2)+'/'+StrZero(IntToStr(xAno),4);
      End
      Else
         pData := StrZero(Copy(pData, 1,2),2)+'/'+StrZero(Copy(pData,4,2),2)+'/'+IntToStr(xAno);

      If (Copy(pData,6,1) <> '/') Then
         pData := Copy(pData,1,5)+'/'+Copy(pData,6,4);
   End;

   If Length( xAnoFim ) = 3 Then
      pData := Copy(pData, 1, 6) + Copy(IntToStr(xAno),1,1) + Copy(pData,7,3);

   xAnoData := 0;
   If Trim(Copy(pData,7,2)) <> '' Then
      xAnoData := StrToInt(Trim(Copy(pData,7,2)));

   If xAnoData = 0 Then
      If Trim(Copy(pData,9,2)) <> '' Then
         xAnoData := StrToInt(Trim(Copy(pData,9,2)));

   pData := Copy(pData, 1, 6) + Copy(StringReplace(pData,' ','', [rfReplaceAll]),7,4);

   xAnoFim  := Copy(Trim(pData),9,2);

   If Trim(xAnoFim) <> '' Then
      Begin
      If Length(xAnoFim) = 1 Then
         Raise Exception.Create('Período inválido.'+#13+pData);

      Result := pData;
      Exit;
   End;

   If Copy(Trim(pData),7,2) = ''  Then
      Begin
      Result := pData;
      Exit;
   End;

   If xAnoData >= pAnoBase Then
      Begin
      Result := Copy(pData,1,6)+'19'+StrZero(Copy(pData,7,2), 2);
   End
   Else
      Result := Copy(pData,1,6)+'20'+StrZero(Copy(pData,7,2), 2);
End;

class function TFuncoes.ValidaDataIniFim(
   var pDataIni  : TMaskEdit;
   var pDataFim  : TMaskEdit;
       pLabelIni ,
       pLabelFim ,
       pDataAtiva: String;
       pIgual    : Boolean;
       pAnoBase  : Integer;
       pValidaDataIni: Boolean = True): Boolean;
begin
    Result := False;

   If (pDataIni.Enabled) And (pDataFim.Enabled) Then
      Begin
      Try
         pDataIni.Text := MontaAno(pDataIni.Text, pAnoBase);
         pDataFim.Text := MontaAno(pDataFim.Text, pAnoBase);
         StrToDate(pDataIni.Text)
      Except
         On EConvertError do
            Begin
            If pDataAtiva = 'Ini' Then
               Begin
               If pDataIni.Text = '  /  /    ' Then
                  Begin
                  Raise Exception.Create(UpperCase(Copy(pLabelIni,1,1)) + LowerCase(Copy(pLabelIni,2, length(pLabelIni))) + ' não pode ficar em branco.');
                  If pDataIni.Parent.ClassName = 'TTabSheet' Then
                     pDataIni.Parent.Show;
                  pDataIni.SetFocus;
               End
               Else
                  Begin
                  Raise Exception.Create(UpperCase(Copy(pLabelIni,1,1)) + LowerCase(Copy(pLabelIni,2, length(pLabelIni))) + ' inválida.');
                  pDataIni.Clear;
                  If pDataIni.Parent.ClassName = 'TTabSheet' Then
                     pDataIni.Parent.Show;
                  pDataIni.SetFocus;
               End;
            End
            Else
               Result := True;

            Exit;
         End;
      End;

      Try
         StrToDate(pDataFim.Text)
      Except
         On EConvertError do
            Begin
            If pDataAtiva = 'Fim' Then
               Begin
               If pDataFim.Text = '  /  /    ' Then
                  Begin
                  Raise Exception.Create(UpperCase(Copy(pLabelFim,1,1)) + LowerCase(Copy(pLabelFim,2, length(pLabelFim))) + ' não pode ficar em branco.');
                  If pDataFim.Parent.ClassName = 'TTabSheet' Then
                     pDataFim.Parent.Show;
                  pDataFim.SetFocus;
               End
               Else
                  Begin
                  Raise Exception.Create(UpperCase(Copy(pLabelFim,1,1)) + LowerCase(Copy(pLabelFim,2, length(pLabelFim))) + ' inválida.');
                  pDataFim.Clear;

                  If pDataFim.Parent.ClassName = 'TTabSheet' Then
                     pDataFim.Parent.Show;

                  pDataFim.SetFocus;
               End;
            End
            Else
               Result := True;

            Exit;
         End;
      End;

      If ((pDataAtiva = 'Ini') and pValidaDataIni) Then
         If pIgual Then
            Begin
            If StrToDate(pDataIni.Text) > StrToDate(pDataFim.Text) Then
               Begin
               Raise Exception.Create(UpperCase(Copy(pLabelIni,1,1)) + LowerCase(Copy(pLabelIni,2, length(pLabelIni))) + LowerCase(' não pode ser maior que ' + pLabelFim) + '.');
               If pDataIni.Parent.ClassName = 'TTabSheet' Then
                  pDataIni.Parent.Show;
               pDataIni.Clear;
               pDataIni.SetFocus;
               Exit;
            End;
         End
         Else
            If StrToDate(pDataIni.Text) >  StrToDate(pDataFim.Text) Then
          //If StrToDate(DataIni.Text) >= StrToDate(DataFim.Text) Then
               Begin
               Raise Exception.Create(UpperCase(Copy(pLabelIni,1,1)) + LowerCase(Copy(pLabelIni,2, length(pLabelIni))) + LowerCase(' não pode ser maior que ' + pLabelFim) + '.');
               If pDataIni.Parent.ClassName = 'TTabSheet' Then
                  pDataIni.Parent.Show;
               pDataIni.Clear;
               pDataIni.SetFocus;
               Exit;
            End;

      If pDataAtiva = 'Fim' Then
         If pIgual Then
            Begin
            If StrToDate(pDataIni.Text) > StrToDate(pDataFim.Text) Then
               Begin
               Raise Exception.Create(UpperCase(Copy(pLabelFim,1,1)) + LowerCase(Copy(pLabelFim,2, Length(pLabelFim))) + LowerCase(' não pode ser menor que ' + pLabelIni) + '.');
               If pDataFim.Parent.ClassName = 'TTabSheet' Then
                  pDataFim.Parent.Show;
               pDataFim.Clear;
               pDataFim.SetFocus;
               Exit;
            End;
         End
         Else
            If StrToDate(pDataIni.Text) >  StrToDate(pDataFim.Text) Then
               Begin
               Raise Exception.Create(UpperCase(Copy(pLabelFim,1,1)) + LowerCase(Copy(pLabelFim,2,length(pLabelFim))) + LowerCase(' não pode ser menor que ' + pLabelIni) + '.');
               If pDataFim.Parent.ClassName = 'TTabSheet' Then
                  pDataFim.Parent.Show;
               pDataFim.Clear;
               pDataFim.SetFocus;
               Exit;
            End;
   End;

   Result := True;
end;

(*
   COMPARA DOIS OBJETOS DE MESMA CLASSE.

   PARA UTILIZAR ESSA FUNÇÃO, VERIFIQUE SE SUA CLASSE E AS PROPRIEDADES DA
   MESMA ESTÃO HERDANDO DA CLASSE "TPersistent", OU ESTÃO ENTRE AS DIRETIVAS
   {$M+}...{$M-} OU {$TYPEINFO+}...{$TYPEINFO-}, E AS PROPRIEDADES DEVEM
   ESTAR DECLARADAS COMO PUBLISHED.
*)
{$O-}
class function TFuncoes.ComparaObjetos(pObj1, pObj2: TObject): Boolean;
var
   I,
   xCount: Integer;
   xList : TPropList;
   xProp : PPropInfo;
begin
   Result := True;

   if pObj1 = pObj2 then
      Exit;

   Result := False;

   if (pObj1 = Nil) or (pObj2 = Nil) then
      Exit;

   if pObj1.ClassType <> pObj2.ClassType then
      Exit;

   xCount := GetPropList(pObj1.ClassInfo, tkProperties, @xList);

   if pObj1 is TList then
   begin
      if TList(pObj1).Count <> TList(pObj2).Count then
         Exit;

      for I := 0 to Pred(TList(pObj1).Count) do
      begin
          Result := ComparaObjetos(TList(pObj1).Items[I], TList(pObj2).Items[I]);

          if not Result then
             Exit;
      end;

      if xCount = 0 then
         Exit;
   end;

   Result := False;

   for I := 0 to Pred(xCount) do
   begin
      xProp := GetPropInfo(pObj1.ClassInfo, xList[I]^.Name);

      if xProp.PropType^.Kind = tkClass then
      begin
         if not ComparaObjetos(
            GetObjectProp(pObj1, xProp.Name),
            GetObjectProp(pObj2, xProp.Name)) then
            Exit;
      end
      else
         if GetPropValue(pObj1, xProp.Name) <>
            GetPropValue(pObj2, xProp.Name) then
            Exit;
   end;

   Result := True;
end;
{$O+}

(*
   RETORNA UMA CÓPIA DO OBJETO PASSADO POR PARÂMETRO

   PARA UTILIZAR ESSA FUNÇÃO, VERIFIQUE SE SUA CLASSE E AS PROPRIEDADES DA
   MESMA ESTÃO HERDANDO DA CLASSE "TPersistent", OU ESTÃO ENTRE AS DIRETIVAS
   {$M+}...{$M-} OU {$TYPEINFO+}...{$TYPEINFO-}, E AS PROPRIEDADES DEVEM
   ESTAR DECLARADAS COMO PUBLISHED.
*)
{$O-}
class function TFuncoes.CopiaObjeto(pObj: TObject): TObject;
var
   I, J,
   xCount: Integer;
   xList : TPropList;
   xProp : PPropInfo;
   xObj1,
   xObj2 : TObject;
begin
   Result := Nil;

   if (pObj = Nil) then
      Exit;

   if (pObj.ClassInfo = Nil) then
      Exit;

   Result := pObj.ClassType.NewInstance;

   xCount := GetPropList(pObj.ClassInfo, tkProperties, @xList);

   for I := 0 to Pred(xCount) do
   begin
      xProp := GetPropInfo(pObj.ClassInfo, xList[I]^.Name);

      if xProp.PropType^.Kind = tkClass then
         SetObjectProp(Result, xProp.Name, CopiaObjeto(GetObjectProp(pObj, xProp.Name)))
      else
      if (xProp.PropType^.Kind <> tkInterface) and  //O TRATAMENTO PARA tkInterface AINDA NÃO FOI IMPLEMENTADO, NO MOMENTO O SISTEMA ESTÁ IGNORANDO.
         Assigned(xProp^.SetProc) then
         SetPropValue(Result, xProp.Name, GetPropValue(pObj, xProp.Name));
   end;

   if pObj is TList then
   begin
      for I := 0 to Pred(TList(pObj).Count) do
      begin
         xObj1 := TList(pObj).Items[I];

         xObj2 := xObj1.ClassType.NewInstance;

         xCount := GetPropList(xObj1.ClassInfo, tkProperties, @xList);

         for J := 0 to Pred(xCount) do
         begin
            xProp := GetPropInfo(xObj1.ClassInfo, xList[J]^.Name);

            if xProp.PropType^.Kind = tkClass then
               SetObjectProp(xObj2, xProp.Name, CopiaObjeto(GetObjectProp(xObj1, xProp.Name)))
            else
            if Assigned(xProp^.SetProc) then
               SetPropValue(xObj2, xProp.Name, GetPropValue(xObj1, xProp.Name));
         end;

         TList(Result).Add(xObj2);
      end;
   end;
end;
{$O+}

(*
   PARA UTILIZAR ESSA FUNÇÃO, VERIFIQUE SE SUA CLASSE E AS PROPRIEDADES DA
   MESMA ESTÃO HERDANDO DA CLASSE "TPersistent", OU ESTÃO ENTRE AS DIRETIVAS
   {$M+}...{$M-} OU {$TYPEINFO+}...{$TYPEINFO-}, E AS PROPRIEDADES DEVEM
   ESTAR DECLARADAS COMO PUBLISHED.
*)
{$O-}
class procedure TFuncoes.PreenchePropriedade(pObjeto: TObject;
   pPropertyName: String; pValue: Variant);
var
   xProp : PPropInfo;
begin
   if (pObjeto = Nil) then
      Exit;

   if (pObjeto.ClassInfo = Nil) then
      Exit;

   xProp := GetPropInfo(pObjeto.ClassInfo, pPropertyName);

   if xProp = Nil then
      Exit;

   try
      if (xProp.PropType^.Kind <> tkInterface) and
         Assigned(xProp^.SetProc) then
         SetPropValue(pObjeto, xProp.Name, pValue);
   except
   end;
end;
{$O+}

(*
   PARA UTILIZAR ESSA FUNÇÃO, VERIFIQUE SE SUA CLASSE E AS PROPRIEDADES DA
   MESMA ESTÃO HERDANDO DA CLASSE "TPersistent", OU ESTÃO ENTRE AS DIRETIVAS
   {$M+}...{$M-} OU {$TYPEINFO+}...{$TYPEINFO-}, E AS PROPRIEDADES DEVEM
   ESTAR DECLARADAS COMO PUBLISHED.
*)
{$O-}
class function TFuncoes.ValorPropriedade(pObjeto: TObject;
   pPropertyName: String): Variant;
var
   xProp : PPropInfo;
begin
   Result := Null;

   if (pObjeto = Nil) then
      Exit;

   if (pObjeto.ClassInfo = Nil) then
      Exit;

   xProp  := GetPropInfo(pObjeto.ClassInfo, pPropertyName);

   if xProp.PropType^.Name = 'TDateTime' then
      Result := TDateTime(GetPropValue(pObjeto, xProp.Name))
   else
   if xProp.PropType^.Kind = tkEnumeration then
      Result := GetPropValue(pObjeto, xProp.Name, False)
   else
      Result := GetPropValue(pObjeto, xProp.Name);
end;
{$O+}  

(*
   PARA UTILIZAR ESSA FUNÇÃO, VERIFIQUE SE SUA CLASSE E AS PROPRIEDADES DA
   MESMA ESTÃO HERDANDO DA CLASSE "TPersistent", OU ESTÃO ENTRE AS DIRETIVAS
   {$M+}...{$M-} OU {$TYPEINFO+}...{$TYPEINFO-}, E AS PROPRIEDADES DEVEM
   ESTAR DECLARADAS COMO PUBLISHED.
*)
{$O-}
class function TFuncoes.RetornaListaPropriedades(
   pObjeto: TObject): TStrings;
var
   I,
   xCount: Integer;
   xList : TPropList;
begin
   Result := Nil;

   if (pObjeto = Nil) then
      Exit;

   if (pObjeto.ClassInfo = Nil) then
      Exit;

   xCount := GetPropList(pObjeto.ClassInfo, tkProperties, @xList);

   if xCount = 0 then
      Exit;

   Result := TStringList.Create;

   for I := 0 to Pred(xCount) do
      Result.Add(xList[I]^.Name);
end;
{$O+}

class function TFuncoes.RetornaNomeEstado(pUF: String; pUpperCase: Boolean): String;
begin
   if pUF = 'AC' then
      Result := 'Acre'
   else
   if pUF = 'AL' then
      Result := 'Alagoas'
   else
   if pUF = 'AP' then
      Result := 'Amapá'
   else
   if pUF = 'AM' then
      Result := 'Amazonas'
   else
   if pUF = 'BA' then
      Result := 'Bahia'
   else
   if pUF = 'CE' then
      Result := 'Ceará'
   else
   if pUF = 'DF' then
      Result := 'Distrito Federal'
   else
   if pUF = 'ES' then
      Result := 'Espírito Santo'
   else
   if pUF = 'GO' then
      Result := 'Goiás'
   else
   if pUF = 'MA' then
      Result := 'Maranhão'
   else
   if pUF = 'MT' then
      Result := 'Mato Grosso'
   else
   if pUF = 'MS' then
      Result := 'Mato Grosso do Sul'
   else
   if pUF = 'MG' then
      Result := 'Minas Gerais'
   else
   if pUF = 'PA' then
      Result := 'Pará'
   else
   if pUF = 'PB' then
      Result := 'Paraíba'
   else
   if pUF = 'PR' then
      Result := 'Paraná'
   else
   if pUF = 'PE' then
      Result := 'Pernambuco'
   else
   if pUF = 'PI' then
      Result := 'Piauí'
   else
   if pUF = 'RJ' then
      Result := 'Rio de Janeiro'
   else
   if pUF = 'RN' then
      Result := 'Rio Grande do Norte'
   else
   if pUF = 'RS' then
      Result := 'Rio Grande do Sul'
   else
   if pUF = 'RO' then
      Result := 'Rondônia'
   else
   if pUF = 'RR' then
      Result := 'Roraima'
   else
   if pUF = 'SC' then
      Result := 'Santa Catarina'
   else
   if pUF = 'SP' then
      Result := 'São Paulo'
   else
   if pUF = 'SE' then
      Result := 'Sergipe'
   else
   if pUF = 'TO' then
      Result := 'Tocantins';

   if pUpperCase then
      Result := UpperCase(Result);
end;

class function TFuncoes.ValidaLetrasNumeros(pTexto: String;
   pIgnoraEspaco: Boolean): Boolean;
var
   I: Integer;
begin
   for I := 1 to Length(pTexto) do
   begin
      if not (Word(pTexto[I]) in [65.. 90, 48.. 57, 96.. 105]) then
      begin
         if pIgnoraEspaco and (Word(pTexto[I]) <> 32) then
            Continue;

         Result := False;
         Exit;
      end;
   end;

   Result := True;
end;

class function TFuncoes.validaEmail(const pEmail: string): Boolean;
  function validaCaracteres(const pString: string): Boolean;
  var
    x: Integer;
  begin
    Result := False;

    for x := 1 to Length(pString) do
      if not(pString[x] in ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '_', '-', '.', '+']) then
        Exit;

    Result := True;
  end;
var
  i: Integer;
  xNamePart,
  xServerPart: string;
begin
   Result := False;

   i := Pos('@', pEmail);

   if i = 0 then
     Exit;

   xNamePart   := Copy(pEmail, 1, i - 1);
   xServerPart := Copy(pEmail, i + 1, Length(pEmail));

   if (Length(xNamePart) = 0) or
      (Length(xServerPart) < 5) then
     Exit;

   i := Pos('.', xServerPart);

   if (i = 0) or
      (i > (Length(xServerPart) - 2)) then
     Exit;

   Result := validaCaracteres(xNamePart) and validaCaracteres(xServerPart);
end;

class function TFuncoes.RemoveExcessoEspacos(pTexto: String): String;
begin
   Result := Trim(pTexto);
   
   while Pos('  ', Result) <> 0 do
      Result := StringReplace(Result, '  ', ' ', [rfReplaceAll]);
end;

class function TFuncoes.TrocaAcento(pTexto: String): String;
var
   X, I: Integer;
   xChrAtual,
   xCaracteresNormais,
   xCaracteresAlfa,
   xCaracteresEspeciais: String;
begin
   Result := '';
   pTexto := Trim(pTexto);
   
   xCaracteresNormais   := CARACTERES_NORMAIS;
   xCaracteresAlfa      := CARACTERES_ALFA;
   xCaracteresEspeciais := CARACTERES_ESPECIAIS;

   for X := 1 to Length(pTexto) do
   begin
      xChrAtual := Copy(pTexto, X, 1);

      for I := 1 to Length(xCaracteresAlfa) do
         if xChrAtual = Copy(xCaracteresAlfa, I, 1) then
         begin
            xChrAtual := Copy(xCaracteresNormais, I, 1);
            Continue;
         end;

      for I := 1 to Length(xCaracteresEspeciais) do
         if xChrAtual = Copy(xCaracteresEspeciais, I, 1) then
         begin
            xChrAtual := '';
            Continue;
         end;

      Result := Result + xChrAtual;
   end;
end;

class function TFuncoes.NomeComputador: String;
var
   lpBuffer : PChar;
   nSize : DWord;
const
   Buff_Size = MAX_COMPUTERNAME_LENGTH + 1;
begin
   nSize := Buff_Size;
   lpBuffer := StrAlloc(Buff_Size);
   GetComputerName(lpBuffer,nSize);
   Result := String(lpBuffer);
   StrDispose(lpBuffer);
end;

class function TFuncoes.StringToStyle(pString: String): TFontStyles;
var
   xStringList: TStringlist;
   xStyle: TFontStyle;
   I: Integer;
begin
   Result := [];

   if Length(pString) < 2 then
      Exit;

   if pString[1] = '[' then
      Delete(pString, 1, 1);

   if pString[Length(pString)] = ']' then
      Delete(pString, Length(pString), 1);

   if Length(pString) = 0 then
      Exit;

   xStringList:= TStringlist.Create;
   try
      xStringList.commatext := pString;
      for I := 0 to xStringList.Count-1 do
      begin
         try
            xStyle := TFontStyle(GetEnumValue(Typeinfo(TFontStyle), xStringList[I]));
            Include(Result,xStyle);
         except
         end;
      end;
   finally
      xStringList.Free;
   end;
end;

class function TFuncoes.removeCaracterEspecial(pTexto : string;
                                               pCaracterExtra: boolean): string;
const
  //Lista de caracteres especiais
  xCarEsp: array[1..41] of String = ('á', 'à', 'ã', 'â', 'ä', 'Á', 'À', 'Ã', 'Â',
                                     'Ä', 'é', 'è', 'É', 'È', 'í', 'ì', 'Í', 'Ì',
                                     'ó', 'ò', 'ö', 'õ', 'ô', 'Ó', 'Ò', 'Ö', 'Õ',
                                     'Ô', 'ú', 'ù', 'ü', 'Ú', 'Ù', 'Ü', 'ç', 'Ç',
                                     'ñ', 'Ñ', #13, 'ê', 'Ê');
  //Lista de caracteres para troca
  xCarTro: array[1..41] of String = ('a','a',   'a', 'a', 'a', 'A', 'A', 'A', 'A',
                                     'A','e',   'e', 'E', 'E', 'i', 'i', 'I', 'I',
                                     'o','o',   'o', 'o', 'o', 'O', 'O', 'O', 'O',
                                     'O','u',   'u', 'u', 'u', 'u', 'u', 'c', 'C',
                                     'n','N', ' / ', 'e', 'E');
  //Lista de Caracteres Extras
  xCarExt: array[1..24] of string = ('¨','&','~','^','´','`','¨','æ','Æ','ø','£',
                                     'Ø','ƒ','ª','º','¿','®','½','¼','ß','µ','þ',
                                     'ý','Ý');
var
  xTexto : string;
  xCount : Integer;
begin
   xTexto := pTexto;

   for xCount := 1 to 41 do
      xTexto := StringReplace(xTexto,
                              xCarEsp[xCount],
                              xCarTro[xCount],
                              [rfreplaceall]);

   if (pCaracterExtra) then
      for xCount := 1 to 24 do
          xTexto := StringReplace(xTexto,
                                  xCarExt[xCount],
                                  '',
                                  [rfreplaceall]);

   Result := xTexto;
end;

class function TFuncoes.validaEmailHotmail(pEmail: string): Boolean;
begin
   pEmail := Copy(pEmail,pos('@',pEmail),Length(pEmail));
   Result := (Pos(pEmail,'@hotmail.com.br @live.com.br @outlook.com.br') > 0);
end;

class function TFuncoes.validaSMTPHotmail(pSMTP: string): Boolean;
begin
   Result := (Pos('hotmail', pSMTP) > 0) or (Pos('outlook', pSMTP)>0);
end;

class function TFuncoes.SerialNumHd: String;
begin
   Result := '';
   Result := SerialSmart;

   If Result = '' Then
      Result := SerialVolume;

end;

class function TFuncoes.SerialVolume: String;
Var
   Serial:DWord;
   DirLen,Flags: DWord;
   DLabel : Array[0..11] of Char;
begin
   Try
      GetVolumeInformation(PChar('C:\'),dLabel,12,@Serial,DirLen,Flags,nil,0);
      Result := IntToHex(Serial,8);
   Except
      Result :='';
   End;
end;

class function TFuncoes.SerialSmart: String;
  function GetIdeDiskSerialNumber : String;
  type
   TSrbIoControl = packed record
      HeaderLength : ULONG;
      Signature    : Array[0..7] of Char;
      Timeout      : ULONG;
      ControlCode  : ULONG;
      ReturnCode   : ULONG;
      Length       : ULONG;
    end;
    SRB_IO_CONTROL = TSrbIoControl;
    PSrbIoControl = ^TSrbIoControl;

    TIDERegs = packed record
      bFeaturesReg     : Byte; // especificar "comandos" SMART
      bSectorCountReg  : Byte; // registro de contador de setor
      bSectorNumberReg : Byte; // registro de número de setores
      bCylLowReg       : Byte; // valor de cilindro (byte mais baixo)
      bCylHighReg      : Byte; // valor de cilindro (byte mais alto)
      bDriveHeadReg    : Byte; // registro de drive/cabeça
      bCommandReg      : Byte; // comando IDE
      bReserved        : Byte; // reservado- tem que ser zero
    end;
    IDEREGS   = TIDERegs;
    PIDERegs  = ^TIDERegs;

    TSendCmdInParams = packed record
      cBufferSize  : DWORD;
      irDriveRegs  : TIDERegs;
      bDriveNumber : Byte;
      bReserved    : Array[0..2] of Byte;
      dwReserved   : Array[0..3] of DWORD;
      bBuffer      : Array[0..0] of Byte;
    end;
    SENDCMDINPARAMS   = TSendCmdInParams;
    PSendCmdInParams  = ^TSendCmdInParams;

    TIdSector = packed record
      wGenConfig                 : Word;
      wNumCyls                   : Word;
      wReserved                  : Word;
      wNumHeads                  : Word;
      wBytesPerTrack             : Word;
      wBytesPerSector            : Word;
      wSectorsPerTrack           : Word;
      wVendorUnique              : Array[0..2] of Word;
      sSerialNumber              : Array[0..19] of Char;
      wBufferType                : Word;
      wBufferSize                : Word;
      wECCSize                   : Word;
      sFirmwareRev               : Array[0..7] of Char;
      sModelNumber               : Array[0..39] of Char;
      wMoreVendorUnique          : Word;
      wDoubleWordIO              : Word;
      wCapabilities              : Word;
      wReserved1                 : Word;
      wPIOTiming                 : Word;
      wDMATiming                 : Word;
      wBS                        : Word;
      wNumCurrentCyls            : Word;
      wNumCurrentHeads           : Word;
      wNumCurrentSectorsPerTrack : Word;
      ulCurrentSectorCapacity    : ULONG;
      wMultSectorStuff           : Word;
      ulTotalAddressableSectors  : ULONG;
      wSingleWordDMA             : Word;
      wMultiWordDMA              : Word;
      bReserved                  : Array[0..127] of Byte;
    end;
    PIdSector = ^TIdSector;
  const
    IDE_ID_FUNCTION               = $EC;
    IDENTIFY_BUFFER_SIZE          = 512;
    DFP_RECEIVE_DRIVE_DATA        = $0007c088;
    IOCTL_SCSI_MINIPORT           = $0004d008;
    IOCTL_SCSI_MINIPORT_IDENTIFY  = $001b0501;
    DataSize = sizeof(TSendCmdInParams)-1+IDENTIFY_BUFFER_SIZE;
    BufferSize = SizeOf(SRB_IO_CONTROL)+DataSize;
    W9xBufferSize = IDENTIFY_BUFFER_SIZE+16;
  var
    hDevice : THandle;
    cbBytesReturned : DWORD;
    pInData : PSendCmdInParams;
    pOutData : Pointer; // PSendCmdOutParams
    Buffer : Array[0..BufferSize-1] of Byte;
    srbControl : TSrbIoControl absolute Buffer;

    procedure ChangeByteOrder( var Data; Size : Integer );
    var ptr : PChar;
        i : Integer;
        c : Char;
    begin
      ptr := @Data;
      for i := 0 to (Size shr 1)-1 do
      begin
        c := ptr^;
        ptr^ := (ptr+1)^;
        (ptr+1)^ := c;
        Inc(ptr,2);
      end;
    end;
  Begin
    Result := '';
    FillChar(Buffer,BufferSize,#0);
    if Win32Platform=VER_PLATFORM_WIN32_NT then
       // Windows NT, Windows 2000, Windows XP
       begin
         // recuperar handle da porta SCSI
         hDevice := CreateFile('\\.\Scsi0:',
          // Nota: '\\.\C:' precisa de privilégios administrativos
          GENERIC_READ or GENERIC_WRITE,
          FILE_SHARE_READ or FILE_SHARE_WRITE,
          nil, OPEN_EXISTING, 0, 0);
        if hDevice=INVALID_HANDLE_VALUE then Exit;
        try
          srbControl.HeaderLength := SizeOf(SRB_IO_CONTROL);
          System.Move('SCSIDISK',srbControl.Signature,8);
          srbControl.Timeout      := 2;
          srbControl.Length       := DataSize;
          srbControl.ControlCode  := IOCTL_SCSI_MINIPORT_IDENTIFY;
          pInData := PSendCmdInParams(PChar(@Buffer)
                     +SizeOf(SRB_IO_CONTROL));
          pOutData := pInData;
          with pInData^ do
          begin
            cBufferSize  := IDENTIFY_BUFFER_SIZE;
            bDriveNumber := 0;
            with irDriveRegs do
            begin
              bFeaturesReg     := 0;
              bSectorCountReg  := 1;
              bSectorNumberReg := 1;
              bCylLowReg       := 0;
              bCylHighReg      := 0;
              bDriveHeadReg    := $A0;
              bCommandReg      := IDE_ID_FUNCTION;
            end;
          end;
          if not DeviceIoControl( hDevice, IOCTL_SCSI_MINIPORT,
            @Buffer, BufferSize, @Buffer, BufferSize,
            cbBytesReturned, nil ) then Exit;
        finally
          CloseHandle(hDevice);
        end;
      end
    else
       begin
        // Windows 95 OSR2, Windows 98, Windows ME
        hDevice := CreateFile( '\\.\SMARTVSD', 0, 0, nil,
          CREATE_NEW, 0, 0 );
        if hDevice=INVALID_HANDLE_VALUE then Exit;
        try
          pInData := PSendCmdInParams(@Buffer);
          pOutData := @pInData^.bBuffer;
          with pInData^ do
          begin
            cBufferSize  := IDENTIFY_BUFFER_SIZE;
            bDriveNumber := 0;
            with irDriveRegs do
            begin
              bFeaturesReg     := 0;
              bSectorCountReg  := 1;
              bSectorNumberReg := 1;
              bCylLowReg       := 0;
              bCylHighReg      := 0;
              bDriveHeadReg    := $A0;
              bCommandReg      := IDE_ID_FUNCTION;
            end;
          end;
          if not DeviceIoControl( hDevice, DFP_RECEIVE_DRIVE_DATA,
            pInData, SizeOf(TSendCmdInParams)-1, pOutData,
            W9xBufferSize, cbBytesReturned, nil ) then Exit;
        finally
          CloseHandle(hDevice);
        end;
      end;
      with PIdSector(PChar(pOutData)+16)^ do
      begin
        ChangeByteOrder(sSerialNumber,SizeOf(sSerialNumber));
        SetString(Result,sSerialNumber,SizeOf(sSerialNumber));
      end;
  end;
Begin
   // Esta função se chama SerialSmart porque a mesma só irá funcionar se
   // o S.M.A.R.T. estiver ativo na configuração do HD.
   Result := Trim(GetIdeDiskSerialNumber);
end;

class procedure TFuncoes.ordenaColuna(pColuna : TColumn; pDataSet : TCustomClientDataSet;
                                      pComplemento: String = '');
var
  indice: string;
  existe: boolean;
begin
   if (not pDataSet.Active) then
      exit;   
      
   //define coluna clicada para ordenação
   pDataSet := TClientDataset(pColuna.Grid.DataSource.DataSet);

   if (TClientDataSet(pDataSet).IndexFieldNames = pComplemento + pColuna.FieldName) then
   begin
      //cria um indicie invertido
      indice := AnsiUpperCase(pColuna.FieldName+'_INV');

      try
         //verifica se existe o indice invertido
         TClientDataSet(pDataSet).IndexDefs.Find(indice);
         existe := true;
      except
         existe := false;
      end;

      if not (existe) then
      begin
         with (TClientDataSet(pDataSet).IndexDefs.AddIndexDef) do
         begin
            Name := indice;
            Fields := pComplemento + pColuna.FieldName;
            Options := [ixDescending];
         end;
      end;

      TClientDataSet(pDataSet).IndexName := indice;

      //volta para primeiro registro
      TClientDataSet(pDataSet).First;
   end
   else
   begin
      TClientDataSet(pDataSet).IndexFieldNames := pComplemento + pColuna.FieldName;
      TClientDataSet(pDataSet).First;
   end;
end;

class procedure TFuncoes.DBGridImgMarcadorGenerico(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
                                                   State: TGridDrawState; ImageListMarcadores: TImageList);
begin
   // Verifica se a linha está selecionada. Se estiver muda a linha para verde,
   // caso contrário deixa branco
   If (gdSelected in State) and ((Sender as TDBGrid).DataSource.DataSet.RecordCount > 0) Then
      (Sender as TDBGrid).Canvas.Brush.Color := clSkyBlue
   Else
       (Sender as TDBGrid).Canvas.Brush.Color := clWhite;

   (Sender as TDBGrid).Canvas.Font.Color := clBlack;
   (Sender as TDBGrid).Canvas.FillRect(Rect);
   (Sender as TDBGrid).DefaultDrawColumnCell(Rect, DataCol, Column, State);

   // Simulando o checkbox no campo status
   If Column.Index = 0 Then
      Begin
      If Column.Field = (Sender as TDBGrid).Fields[0] Then
         Begin
         (Sender as TDBGrid).Canvas.FillRect(Rect);
         If (Sender as TDBGrid).DataSource.DataSet.FieldByName('MARCADOR').AsString = 'S' Then
            ImageListMarcadores.Draw((Sender as TDBGrid).Canvas, Rect.left + Trunc(Column.Width/2) - Trunc(ImageListMarcadores.Width/2), rect.top + 1, 1)
         Else
             ImageListMarcadores.Draw((Sender as TDBGrid).Canvas, Rect.left + Trunc(Column.Width/2) - Trunc(ImageListMarcadores.Width/2), rect.top + 1, 0);
      End;

      // Trocando a figura na célula com o foco
      If (gdFocused in State) And ((Sender as TDBGrid).DataSource.DataSet.FieldByName('MARCADOR').AsString = 'S') Then
         ImageListMarcadores.Draw((Sender as TDBGrid).Canvas, Rect.left + Trunc(Column.Width/2) - Trunc(ImageListMarcadores.Width/2), rect.top + 1, 1);

      If (gdFocused in State) And ((Sender as TDBGrid).DataSource.DataSet.FieldByName('MARCADOR').AsString = 'N') Then
         ImageListMarcadores.Draw((Sender as TDBGrid).Canvas, Rect.left + Trunc(Column.Width/2) - Trunc(ImageListMarcadores.Width/2), rect.top + 1, 0);
   End;
end;

class function TFuncoes.ListarArquivos (pDiretorio: String;
   pSubDir: Boolean): TStringList;

   function TemAtributo(Attr, Val: Integer): Boolean;
   begin                                                                         
      Result := Attr and Val = Val;
   end;
var
  F: TSearchRec;
  xRet: Integer;
  xTempNome: string;
  xLista  : TStringList;
begin
   xRet := FindFirst(pDiretorio + '\*.*', faAnyFile, F);
   try
      xLista   := TStringList.Create;

      while xRet = 0 do
      begin
         if TemAtributo(F.Attr, faDirectory) then
         begin
            if (F.Name <> '.') and (F.Name <> '..') then
               if pSubDir then
               begin
                  xTempNome := pDiretorio + '\' + F.Name;
                  xLista.Add(xTempNome);
               end;
         end
         else
         begin
            xLista.Add(pDiretorio + '\' + F.Name);
         end;

         xRet := FindNext(F);
      end;

      Result := xLista;
   finally
      SysUtils.FindClose(F);
   end;
end;

class function TFuncoes.RetornaTextoFormatado(pTexto: String;
  pQtdCaracterLinha: Integer; pMargem, pTrocaEnter: String): String;
var
   i          ,
   xTamanhoIni,
   xTamanhoFim: Integer;
   xTextoFormatado : String;
begin
   Result := EmptyStr;

   try
      pTexto := StringReplace(pTexto, #$D#$A, pTrocaEnter, [rfReplaceAll]);
      pTexto := StringReplace(pTexto, #13#10, pTrocaEnter, [rfReplaceAll]);

      if Length(pTexto) > pQtdCaracterLinha then
      begin
         xTamanhoIni := 0;
         xTamanhoFim := 0;
         for i:=0 to Length(pTexto)-1 do
         begin
            if xTamanhoFim > Length(pTexto) then
               Exit;

            xTamanhoFim := xTamanhoFim + pQtdCaracterLinha;

            if xTextoFormatado <> EmptyStr then
            begin
               xTextoFormatado :=
                  xTextoFormatado + pMargem +
                  Copy(pTexto, xTamanhoIni, pQtdCaracterLinha) +#13+#10;
               xTamanhoIni := xTamanhoIni + pQtdCaracterLinha;
            end
            else
            begin
               xTextoFormatado := Copy(pTexto, 1, xTamanhoFim) +#13+#10;
               xTamanhoIni := pQtdCaracterLinha+1;
            end;
         end;
      end
      else
         xTextoFormatado := pTexto;
   finally
      Result := xTextoFormatado;
   end;
end;

class function TFuncoes.validaEmailGmail(pEmail: string): Boolean;
begin
   pEmail := Copy(pEmail,pos('@',pEmail),Length(pEmail));
   Result := (Pos(pEmail,'@gmail.com.br') > 0);
end;

class function TFuncoes.CriaProcesso(const pCommand: String): Cardinal;
var
   xlStartUpInfo: TStartUpInfo;
   xlProcesso: TProcessInformation;
begin
   Result := 0;

   xlStartUpInfo.cb          := 2048;
   xlStartUpInfo.lpReserved  := Nil;
   xlStartUpInfo.lpDesktop   := Nil;
   xlStartUpInfo.lpTitle     := Nil;
   xlStartUpInfo.dwFlags     := STARTF_USESHOWWINDOW;
   xlStartUpInfo.wShowWindow := SW_HIDE;
   xlStartUpInfo.cbReserved2 := 0;
   xlStartUpInfo.lpReserved2 := Nil;

   CreateProcess(Nil, PChar(pCommand), Nil, Nil, False, 0, Nil, Nil,
      xlStartUpInfo, xlProcesso);

   Result := xlProcesso.dwProcessId;
end;

class function TFuncoes.ComparaValor(pValor1, pValor2, pDifPermitida: Double;
  pTipoComparacao: TTipoComparacao): Boolean;
begin
   Result := False;

   if pDifPermitida = 0 then
      pDifPermitida := 0.001;

   case pTipoComparacao of
      tcIgual :
      begin
         if (CompareValue(pValor1, pValor2, pDifPermitida) = EqualsValue) then
            Result := True;
      end;
      tcMaior :
      begin
         if (CompareValue(pValor1, pValor2, pDifPermitida) = GreaterThanValue) then
            Result := True;
      end;
      tcMenor :
      begin
         if (CompareValue(pValor1, pValor2, pDifPermitida) = LessThanValue) then
            Result := True;
      end;
   end;
end;

class function TFuncoes.validaHora(pHora: String; var pMensagemRetorno: String): Boolean;
var
  xHora : String;
  xMinuto  : String;
begin
  Result := False;

  xHora   := Copy(pHora, 1, 2);
  xMinuto := Copy(pHora, 4, 2);

  if Length(Trim(xHora)) < 2 then
     Exit;

  if Length(Trim(xMinuto)) < 2 then
     Exit;

  try
     StrToDateTime(pHora);
  except
     On EConvertError do
     begin
        pMensagemRetorno := 'Hora inválida';
        Exit;
     end;
  end;

  Result := True;
end;

class function TFuncoes.RetornaIdProcesso: Integer;
var
   h: hwnd;
   hpr, hth: longint;
begin
   h:= getforegroundwindow;
   GetWindowThreadProcessID(h, @hpr);

   hth:= OpenProcess(STANDARD_RIGHTS_REQUIRED OR PROCESS_TERMINATE, false, hpr);

   Result := hpr;
end;

class function TFuncoes.ProcessoExiste(pExeName: String;
   pIDProcesso: Integer): Boolean;
var
   xContinueLoop: BOOL;
   xSnapshotHandle: THandle;
   xProcessEntry32: TProcessEntry32;
begin
   Result := False;

   xSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
   xProcessEntry32.dwSize := SizeOf(xProcessEntry32);
   xContinueLoop := Process32First(xSnapshotHandle, xProcessEntry32);
   Result := False;

   while Integer(xContinueLoop) <> 0 do
   begin
      if xProcessEntry32.th32ProcessID = pIDProcesso then
      begin
         if (Pos(UpperCase(pExeName), UpperCase(ExtractFileName(xProcessEntry32.szExeFile))) <> 0 ) then
         begin
            Result := True;
            break;
         end;
      end;

      xContinueLoop := Process32Next(xSnapshotHandle, xProcessEntry32);
   end;

   CloseHandle(xSnapshotHandle);
end;

class function TFuncoes.GetHWNDFromPID(const pId: Cardinal): HWND;
var
  MHandle: HWND;
  MProcPID: Cardinal;
begin
   result := 0;
   MHandle := GetTopWindow( 0 );

   while Boolean( MHandle ) do
   begin
         { ** O retorno do método não é necessário. Apenas o seu Handle ** }
     GetWindowThreadProcessId( MHandle, MProcPid );
     if MProcPid = pid then
      begin

         result := MHandle;
         Break;

      end;

     { ** Recuperando a próxima janela ** }
      MHandle := GetNextWindow( MHandle, GW_HWNDNEXT );
   end;
end;

class procedure TFuncoes.SetaFocoProcessoExterno(pHandle: HWND);
begin
   SendMessage (pHandle, WM_SYSCOMMAND, SC_RESTORE, 0);
   SetForegroundWindow(pHandle);
end;

class function TFuncoes.ValidaPrefixoGS1(pCodigo: string): Boolean;
var
   x: Integer;
   xPrefixo: String;
   xCodprefx: Integer;
type
   TRangePrefixGTIN = record
      fxPrefixIni: Integer;
      fxPrefixFim: Integer;
      indEsp: Integer;
      fxPaisNome: String;
  end;
const
  ARRAY_PREFIX_GTIN: array[0..126] of TRangePrefixGTIN = (
    (fxPrefixIni: 000;	fxPrefixFim: 019; indEsp: 0; fxPaisNome: 'GS1 US'),
    (fxPrefixIni: 020;	fxPrefixFim: 029; indEsp: 1; fxPaisNome: 'Números de circulação restrita dentro da região'),
    (fxPrefixIni: 030;	fxPrefixFim: 039; indEsp: 0; fxPaisNome: 'GS1 US'),
    (fxPrefixIni: 040;	fxPrefixFim: 049; indEsp: 1; fxPaisNome: 'GS1 Números de circulação restrita dentro da empresa'),
    (fxPrefixIni: 050;	fxPrefixFim: 059; indEsp: 1; fxPaisNome: 'GS1 US reserved for future use'),
    (fxPrefixIni: 060;	fxPrefixFim: 139; indEsp: 0; fxPaisNome: 'GS1 US'),
    (fxPrefixIni: 200;	fxPrefixFim: 299; indEsp: 1; fxPaisNome: 'GS1 Números de circulação restrita dentro da região'),
    (fxPrefixIni: 300;	fxPrefixFim: 379; indEsp: 0; fxPaisNome: 'GS1 France'),
    (fxPrefixIni: 380;	fxPrefixFim: 380; indEsp: 0; fxPaisNome: 'GS1 Bulgaria'),
    (fxPrefixIni: 383;	fxPrefixFim: 383; indEsp: 0; fxPaisNome: 'GS1 Slovenija'),
    (fxPrefixIni: 385;	fxPrefixFim: 385; indEsp: 0; fxPaisNome: 'GS1 Croatia'),
    (fxPrefixIni: 387;	fxPrefixFim: 387; indEsp: 0; fxPaisNome: 'GS1 BIH (Bosnia-Herzegovina)'),
    (fxPrefixIni: 389;	fxPrefixFim: 389; indEsp: 0; fxPaisNome: 'GS1 Montenegro'),
    (fxPrefixIni: 400;	fxPrefixFim: 440; indEsp: 0; fxPaisNome: 'GS1 Germany'),
    (fxPrefixIni: 450;	fxPrefixFim: 459; indEsp: 0; fxPaisNome: 'GS1 Japan'),
    (fxPrefixIni: 490;	fxPrefixFim: 499; indEsp: 0; fxPaisNome: 'GS1 Japan'),
    (fxPrefixIni: 460;	fxPrefixFim: 469; indEsp: 0; fxPaisNome: 'GS1 Russia'),
    (fxPrefixIni: 470;	fxPrefixFim: 470; indEsp: 0; fxPaisNome: 'GS1 Kyrgyzstan'),
    (fxPrefixIni: 471;	fxPrefixFim: 471; indEsp: 0; fxPaisNome: 'GS1 Taiwan'),
    (fxPrefixIni: 474;	fxPrefixFim: 474; indEsp: 0; fxPaisNome: 'GS1 Estonia'),
    (fxPrefixIni: 475;	fxPrefixFim: 475; indEsp: 0; fxPaisNome: 'GS1 Latvia'),
    (fxPrefixIni: 476;	fxPrefixFim: 476; indEsp: 0; fxPaisNome: 'GS1 Azerbaijan'),
    (fxPrefixIni: 477;	fxPrefixFim: 477; indEsp: 0; fxPaisNome: 'GS1 Lithuania'),
    (fxPrefixIni: 478;	fxPrefixFim: 478; indEsp: 0; fxPaisNome: 'GS1 Uzbekistan'),
    (fxPrefixIni: 479;	fxPrefixFim: 479; indEsp: 0; fxPaisNome: 'GS1 Sri Lanka'),
    (fxPrefixIni: 480;	fxPrefixFim: 480; indEsp: 0; fxPaisNome: 'GS1 Philippines'),
    (fxPrefixIni: 481;	fxPrefixFim: 481; indEsp: 0; fxPaisNome: 'GS1 Belarus'),
    (fxPrefixIni: 482;	fxPrefixFim: 482; indEsp: 0; fxPaisNome: 'GS1 Ukraine'),
    (fxPrefixIni: 483;	fxPrefixFim: 483; indEsp: 0; fxPaisNome: 'GS1 Turkmenistan'),
    (fxPrefixIni: 484;	fxPrefixFim: 484; indEsp: 0; fxPaisNome: 'GS1 Moldova'),
    (fxPrefixIni: 485;	fxPrefixFim: 485; indEsp: 0; fxPaisNome: 'GS1 Armenia'),
    (fxPrefixIni: 486;	fxPrefixFim: 486; indEsp: 0; fxPaisNome: 'GS1 Georgia'),
    (fxPrefixIni: 487;	fxPrefixFim: 487; indEsp: 0; fxPaisNome: 'GS1 Kazakstan'),
    (fxPrefixIni: 488;	fxPrefixFim: 488; indEsp: 0; fxPaisNome: 'GS1 Tajikistan'),
    (fxPrefixIni: 489;	fxPrefixFim: 489; indEsp: 0; fxPaisNome: 'GS1 Hong Kong'),
    (fxPrefixIni: 500;	fxPrefixFim: 509; indEsp: 0; fxPaisNome: 'GS1 UK'),
    (fxPrefixIni: 520;	fxPrefixFim: 521; indEsp: 0; fxPaisNome: 'GS1 Association Greece'),
    (fxPrefixIni: 528;	fxPrefixFim: 528; indEsp: 0; fxPaisNome: 'GS1 Lebanon'),
    (fxPrefixIni: 529;	fxPrefixFim: 529; indEsp: 0; fxPaisNome: 'GS1 Cyprus'),
    (fxPrefixIni: 530;	fxPrefixFim: 530; indEsp: 0; fxPaisNome: 'GS1 Albania'),
    (fxPrefixIni: 531;	fxPrefixFim: 531; indEsp: 0; fxPaisNome: 'GS1 Macedonia'),
    (fxPrefixIni: 535;	fxPrefixFim: 535; indEsp: 0; fxPaisNome: 'GS1 Malta'),
    (fxPrefixIni: 539;	fxPrefixFim: 539; indEsp: 0; fxPaisNome: 'GS1 Ireland'),
    (fxPrefixIni: 540;	fxPrefixFim: 549; indEsp: 0; fxPaisNome: 'GS1 Belgium & Luxembourg'),
    (fxPrefixIni: 560;	fxPrefixFim: 560; indEsp: 0; fxPaisNome: 'GS1 Portugal'),
    (fxPrefixIni: 569;	fxPrefixFim: 569; indEsp: 0; fxPaisNome: 'GS1 Iceland'),
    (fxPrefixIni: 570;	fxPrefixFim: 579; indEsp: 0; fxPaisNome: 'GS1 Denmark'),
    (fxPrefixIni: 590;	fxPrefixFim: 590; indEsp: 0; fxPaisNome: 'GS1 Poland'),
    (fxPrefixIni: 594;	fxPrefixFim: 594; indEsp: 0; fxPaisNome: 'GS1 Romania'),
    (fxPrefixIni: 599;	fxPrefixFim: 599; indEsp: 0; fxPaisNome: 'GS1 Hungary'),
    (fxPrefixIni: 600;	fxPrefixFim: 601; indEsp: 0; fxPaisNome: 'GS1 South Africa'),
    (fxPrefixIni: 603;	fxPrefixFim: 603; indEsp: 0; fxPaisNome: 'GS1 Ghana'),
    (fxPrefixIni: 604;	fxPrefixFim: 604; indEsp: 0; fxPaisNome: 'GS1 Senegal'),
    (fxPrefixIni: 608;	fxPrefixFim: 608; indEsp: 0; fxPaisNome: 'GS1 Bahrain'),
    (fxPrefixIni: 609;	fxPrefixFim: 609; indEsp: 0; fxPaisNome: 'GS1 Mauritius'),
    (fxPrefixIni: 611;	fxPrefixFim: 611; indEsp: 0; fxPaisNome: 'GS1 Morocco'),
    (fxPrefixIni: 613;	fxPrefixFim: 613; indEsp: 0; fxPaisNome: 'GS1 Algeria'),
    (fxPrefixIni: 615;	fxPrefixFim: 615; indEsp: 0; fxPaisNome: 'GS1 Nigeria'),
    (fxPrefixIni: 616;	fxPrefixFim: 616; indEsp: 0; fxPaisNome: 'GS1 Kenya'),
    (fxPrefixIni: 618;	fxPrefixFim: 618; indEsp: 0; fxPaisNome: 'GS1 Ivory Coast'),
    (fxPrefixIni: 619;	fxPrefixFim: 619; indEsp: 0; fxPaisNome: 'GS1 Tunisia'),
    (fxPrefixIni: 620;	fxPrefixFim: 620; indEsp: 0; fxPaisNome: 'GS1 Tanzania'),
    (fxPrefixIni: 621;	fxPrefixFim: 621; indEsp: 0; fxPaisNome: 'GS1 Syria'),
    (fxPrefixIni: 622;	fxPrefixFim: 622; indEsp: 0; fxPaisNome: 'GS1 Egypt'),
    (fxPrefixIni: 623;	fxPrefixFim: 623; indEsp: 0; fxPaisNome: 'GS1 Brunei'),
    (fxPrefixIni: 624;	fxPrefixFim: 624; indEsp: 0; fxPaisNome: 'GS1 Libya'),
    (fxPrefixIni: 625;	fxPrefixFim: 625; indEsp: 0; fxPaisNome: 'GS1 Jordan'),
    (fxPrefixIni: 626;	fxPrefixFim: 626; indEsp: 0; fxPaisNome: 'GS1 Iran'),
    (fxPrefixIni: 627;	fxPrefixFim: 627; indEsp: 0; fxPaisNome: 'GS1 Kuwait'),
    (fxPrefixIni: 628;	fxPrefixFim: 628; indEsp: 0; fxPaisNome: 'GS1 Saudi Arabia'),
    (fxPrefixIni: 629;	fxPrefixFim: 629; indEsp: 0; fxPaisNome: 'GS1 Emirates'),
    (fxPrefixIni: 640;	fxPrefixFim: 649; indEsp: 0; fxPaisNome: 'GS1 Finland'),
    (fxPrefixIni: 690;	fxPrefixFim: 699; indEsp: 0; fxPaisNome: 'GS1 China'),
    (fxPrefixIni: 700;	fxPrefixFim: 709; indEsp: 0; fxPaisNome: 'GS1 Norway'),
    (fxPrefixIni: 729;	fxPrefixFim: 729; indEsp: 0; fxPaisNome: 'GS1 Israel'),
    (fxPrefixIni: 730;	fxPrefixFim: 739; indEsp: 0; fxPaisNome: 'GS1 Sweden'),
    (fxPrefixIni: 740;	fxPrefixFim: 740; indEsp: 0; fxPaisNome: 'GS1 Guatemala'),
    (fxPrefixIni: 741;	fxPrefixFim: 741; indEsp: 0; fxPaisNome: 'GS1 El Salvador'),
    (fxPrefixIni: 742;	fxPrefixFim: 742; indEsp: 0; fxPaisNome: 'GS1 Honduras'),
    (fxPrefixIni: 743;	fxPrefixFim: 743; indEsp: 0; fxPaisNome: 'GS1 Nicaragua'),
    (fxPrefixIni: 744;	fxPrefixFim: 744; indEsp: 0; fxPaisNome: 'GS1 Costa Rica'),
    (fxPrefixIni: 745;	fxPrefixFim: 745; indEsp: 0; fxPaisNome: 'GS1 Panama'),
    (fxPrefixIni: 746;	fxPrefixFim: 746; indEsp: 0; fxPaisNome: 'GS1 Republica Dominicana'),
    (fxPrefixIni: 750;	fxPrefixFim: 750; indEsp: 0; fxPaisNome: 'GS1 Mexico'),
    (fxPrefixIni: 754;	fxPrefixFim: 755; indEsp: 0; fxPaisNome: 'GS1 Canada'),
    (fxPrefixIni: 759;	fxPrefixFim: 759; indEsp: 0; fxPaisNome: 'GS1 Venezuela'),
    (fxPrefixIni: 760;	fxPrefixFim: 769; indEsp: 0; fxPaisNome: 'GS1 Schweiz; Suisse; Svizzera'),
    (fxPrefixIni: 770;	fxPrefixFim: 771; indEsp: 0; fxPaisNome: 'GS1 Colombia'),
    (fxPrefixIni: 773;	fxPrefixFim: 773; indEsp: 0; fxPaisNome: 'GS1 Uruguay'),
    (fxPrefixIni: 775;	fxPrefixFim: 775; indEsp: 0; fxPaisNome: 'GS1 Peru'),
    (fxPrefixIni: 777;	fxPrefixFim: 777; indEsp: 0; fxPaisNome: 'GS1 Bolivia'),
    (fxPrefixIni: 778;	fxPrefixFim: 779; indEsp: 0; fxPaisNome: 'GS1 Argentina'),
    (fxPrefixIni: 780;	fxPrefixFim: 780; indEsp: 0; fxPaisNome: 'GS1 Chile'),
    (fxPrefixIni: 784;	fxPrefixFim: 784; indEsp: 0; fxPaisNome: 'GS1 Paraguay'),
    (fxPrefixIni: 786;	fxPrefixFim: 786; indEsp: 0; fxPaisNome: 'GS1 Ecuador'),
    (fxPrefixIni: 789;	fxPrefixFim: 790; indEsp: 0; fxPaisNome: 'GS1 Brasil'),
    (fxPrefixIni: 800;	fxPrefixFim: 839; indEsp: 0; fxPaisNome: 'GS1 Italy'),
    (fxPrefixIni: 840;	fxPrefixFim: 849; indEsp: 0; fxPaisNome: 'GS1 Spain'),
    (fxPrefixIni: 850;	fxPrefixFim: 850; indEsp: 0; fxPaisNome: 'GS1 Cuba'),
    (fxPrefixIni: 858;	fxPrefixFim: 858; indEsp: 0; fxPaisNome: 'GS1 Slovakia'),
    (fxPrefixIni: 859;	fxPrefixFim: 859; indEsp: 0; fxPaisNome: 'GS1 Czech'),
    (fxPrefixIni: 860;	fxPrefixFim: 860; indEsp: 0; fxPaisNome: 'GS1 Serbia'),
    (fxPrefixIni: 865;	fxPrefixFim: 865; indEsp: 0; fxPaisNome: 'GS1 Mongolia'),
    (fxPrefixIni: 867;	fxPrefixFim: 867; indEsp: 0; fxPaisNome: 'GS1 North Korea'),
    (fxPrefixIni: 868;	fxPrefixFim: 869; indEsp: 0; fxPaisNome: 'GS1 Turkey'),
    (fxPrefixIni: 870;	fxPrefixFim: 879; indEsp: 0; fxPaisNome: 'GS1 Netherlands'),
    (fxPrefixIni: 880;	fxPrefixFim: 880; indEsp: 0; fxPaisNome: 'GS1 South Korea'),
    (fxPrefixIni: 884;	fxPrefixFim: 884; indEsp: 0; fxPaisNome: 'GS1 Cambodia'),
    (fxPrefixIni: 885;	fxPrefixFim: 885; indEsp: 0; fxPaisNome: 'GS1 Thailand'),
    (fxPrefixIni: 888;	fxPrefixFim: 888; indEsp: 0; fxPaisNome: 'GS1 Singapore'),
    (fxPrefixIni: 890;	fxPrefixFim: 890; indEsp: 0; fxPaisNome: 'GS1 India'),
    (fxPrefixIni: 893;	fxPrefixFim: 893; indEsp: 0; fxPaisNome: 'GS1 Vietnam'),
    (fxPrefixIni: 896;	fxPrefixFim: 896; indEsp: 0; fxPaisNome: 'GS1 Pakistan'),
    (fxPrefixIni: 899;	fxPrefixFim: 899; indEsp: 0; fxPaisNome: 'GS1 Indonesia'),
    (fxPrefixIni: 900;	fxPrefixFim: 919; indEsp: 0; fxPaisNome: 'GS1 Austria'),
    (fxPrefixIni: 930;	fxPrefixFim: 939; indEsp: 0; fxPaisNome: 'GS1 Australia'),
    (fxPrefixIni: 940;	fxPrefixFim: 949; indEsp: 0; fxPaisNome: 'GS1 New Zealand'),
    (fxPrefixIni: 950;	fxPrefixFim: 950; indEsp: 1; fxPaisNome: 'GS1 Global Office'),
    (fxPrefixIni: 951;	fxPrefixFim: 951; indEsp: 1; fxPaisNome: 'Numeracao para EPC Tag Data Standard'),
    (fxPrefixIni: 955;	fxPrefixFim: 955; indEsp: 0; fxPaisNome: 'GS1 Malaysia'),
    (fxPrefixIni: 958;	fxPrefixFim: 958; indEsp: 0; fxPaisNome: 'GS1 Macau'),
    (fxPrefixIni: 960;	fxPrefixFim: 969; indEsp: 1; fxPaisNome: 'Global Office (GTIN-8s)'),
    (fxPrefixIni: 977;	fxPrefixFim: 977; indEsp: 1; fxPaisNome: 'Serial publications (ISSN)'),
    (fxPrefixIni: 978;	fxPrefixFim: 979; indEsp: 1; fxPaisNome: 'Bookland (ISBN)'),
    (fxPrefixIni: 980;	fxPrefixFim: 980; indEsp: 1; fxPaisNome: 'Refund receipts'),
    (fxPrefixIni: 981;	fxPrefixFim: 984; indEsp: 1; fxPaisNome: 'GS1 Coupon identification for common currency areas'),
    (fxPrefixIni: 990;	fxPrefixFim: 999; indEsp: 1; fxPaisNome: 'GS1 Coupon identification'));
begin
   result := false;
   xPrefixo := Trim(pCodigo);
   if (xPrefixo = '') Or
      (not Length(xPrefixo) in [8,12,13,14])then
      exit;

   for x:= 1 to Length(xPrefixo) do
      if not (xPrefixo[x] in ['0'..'9']) then
         Exit;

   if Copy(xPrefixo,1,5) = '00000' then
      exit;

   if (Copy(xPrefixo,1,5) = '00001') or
      (Copy(xPrefixo,1,4) = '0001')  or
      (Copy(xPrefixo,1,4) = '0009')  or
      (Copy(xPrefixo,1,5) = '00009') or
      (Copy(xPrefixo,1,2) = '99') then
   begin
      result := true;
      exit;
   end;

   xCodprefx := StrToInt(Copy(xPrefixo,1,3));
   for x := Low(ARRAY_PREFIX_GTIN) to High(ARRAY_PREFIX_GTIN) do
   begin
     if (xCodprefx >= ARRAY_PREFIX_GTIN[x].fxPrefixIni) and
        (xCodprefx <= ARRAY_PREFIX_GTIN[x].fxPrefixFim) then
     begin
        result := true;
        break;
     end
   end
end;

class function TFuncoes.MontaHora(pHora: String): string;
var
   xHoraCompleta  : string;
   xMinuto,
   xHora        : Word;
begin
   xHora   := StrToIntDef(Trim(Copy(pHora, 1, 2)), 0);
   xMinuto := StrToIntDef(Trim(Copy(pHora, 4, 2)), 0);

   if xHora < 10 then
      xHoraCompleta := '0' + IntToStr(xHora)
   else
      xHoraCompleta := IntToStr(xHora);

   if (Length(xHoraCompleta) = 2) then
      xHoraCompleta := xHoraCompleta + ':';

   if xMinuto < 10 then
      xHoraCompleta := xHoraCompleta + IntToStr(xMinuto) + '0'
   else
      xHoraCompleta := xHoraCompleta + IntToStr(xMinuto);
      
   Result := xHoraCompleta;
end;

class procedure TFuncoes.FinalizaProcesso(pNomeExe: String);
begin
   KillTask(pNomeEXE);
end;

class function TFuncoes.KillTask(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(
                        OpenProcess(PROCESS_TERMINATE,
                                    BOOL(0),
                                    FProcessEntry32.th32ProcessID),
                                    0));
     ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

class function TFuncoes.VerificaSerieContingencia(pSerie: String): Boolean;
begin
  Result := False;
  try
     Result := StrToInt(pSerie) >= 910;
  except
     Result := (Pos('A', pSerie)> 0) or (Pos('B', pSerie)> 0) or (Pos('C', pSerie)> 0) or
               (Pos('D', pSerie)> 0) or (Pos('E', pSerie)> 0) or (Pos('F', pSerie)> 0) or
               (Pos('G', pSerie)> 0);
  end;
end;

class function TFuncoes.RetornaSerieConvertida(pSerie: string; pRetornarCodigo: Boolean = False; pNormalizada: Boolean = False): String;
begin
   Result := '';

   if Length(Trim(pSerie)) > 3 then
   begin
      Result := pSerie;
      exit;
   end;

   try
      pSerie := Trim(pSerie);
      pSerie := IntToStr(StrToInt(pSerie));
   except
   end;

   if (Length(pSerie) = 1) then
   begin
      try
         StrToInt(pSerie);
         pSerie := TFuncoes.StrZero(pSerie, 2);
      except
      end;

      Result := pSerie;
      Exit;
   end;

   if(Length(pSerie) = 2) or
     (StrToIntDef(pSerie,0) <= 79) then
   begin
     try
        StrToInt(pSerie);
        Result := pSerie;
        exit;
     except
        //Só pra não sair caso seja uma série codificada
     end;
   end;

   if not pRetornarCodigo then
   begin
      try
         Result := StrZero(IntToStr(StrToInt(pSerie)), 3);
         Exit;
      except
         pSerie := StringReplace(pSerie, 'A', '91', [rfReplaceAll, rfIgnoreCase]);
         pSerie := StringReplace(pSerie, 'B', '92', [rfReplaceAll, rfIgnoreCase]);
         pSerie := StringReplace(pSerie, 'C', '93', [rfReplaceAll, rfIgnoreCase]);
         pSerie := StringReplace(pSerie, 'D', '94', [rfReplaceAll, rfIgnoreCase]);
         pSerie := StringReplace(pSerie, 'E', '95', [rfReplaceAll, rfIgnoreCase]);
         pSerie := StringReplace(pSerie, 'F', '96', [rfReplaceAll, rfIgnoreCase]);
         pSerie := StringReplace(pSerie, 'G', '97', [rfReplaceAll, rfIgnoreCase]);

         try
            pSerie := Trim(pSerie);
            Result := StrZero(IntToStr(StrToIntDef(pSerie, 0)), 3);

            if pNormalizada and (StrToIntDef(pSerie, 0) >= 910) then
               Result := StrZero(IntToStr(StrToIntDef(pSerie, 0) - 900), 2);
         except
            Result := '00';
         end
      end;
   end
   else
   begin
      pSerie := StringReplace(pSerie, '91', 'A', [rfReplaceAll, rfIgnoreCase]);
      pSerie := StringReplace(pSerie, '92', 'B', [rfReplaceAll, rfIgnoreCase]);
      pSerie := StringReplace(pSerie, '93', 'C', [rfReplaceAll, rfIgnoreCase]);
      pSerie := StringReplace(pSerie, '94', 'D', [rfReplaceAll, rfIgnoreCase]);
      pSerie := StringReplace(pSerie, '95', 'E', [rfReplaceAll, rfIgnoreCase]);
      pSerie := StringReplace(pSerie, '96', 'F', [rfReplaceAll, rfIgnoreCase]);
      pSerie := StringReplace(pSerie, '97', 'G', [rfReplaceAll, rfIgnoreCase]);

      Result := pSerie;
   end;
end;

class function TFuncoes.IsNumero2(pTexto: String): Boolean;
var
   I: Integer;
begin
   for I := 1 to Length(pTexto) do
   begin

      if pos(pTexto[I], '0123456789') = 0 then
      begin
         Result := False;
         Exit;
      end;
   end;

   Result := True;
end;

class function TFuncoes.validaEstadoCidadeSUFRAMA(pEstado, pMunicipio: String; pSoEstado: boolean): Boolean;
begin
   Result  := False;
   pEstado := upperCase(pEstado);
   case ansiIndexStr(pEstado, ['ACRE', 'AMAZONAS', 'RORAIMA', 'AMAPA', 'AMAPÁ', 'RONDONIA', 'RONDÔNIA']) of
      0: pEstado := 'AC';
      1: pEstado := 'AM';
      2: pEstado := 'RR';
      3,4: pEstado := 'AP';
      5,6: pEstado := 'RO';
   end;

   if ansiIndexStr(pEstado, ['AC', 'AM', 'RO', 'AP', 'RR']) = -1 then
      exit;

   if pSoEstado then
   begin
      Result := True;
      exit;
   end;

   if pEstado = 'AP' then
   begin
      Result := (pMunicipio = '1600303') or //Macapá
                (pMunicipio = '1600600') or //Santana
                (UpperCase(pMunicipio) = 'MACAPA') or
                (UpperCase(pMunicipio) = 'MACAPÁ') or
                (UpperCasE(pMunicipio) = 'SANTANA');
      exit;
   end;

   Result := True;

end;


class function TFuncoes.possuiCaraterEspecial(pTexto: string): Boolean;
var
   xCaracter,
   xCarateresEspeciais : String;
   I : Integer;
begin
   Result              := False;
   xCarateresEspeciais := CARACTERES_ESPECIAIS+CARACTERES_ALFA;
   for I := 0 to Length(pTexto) do
   begin
      xCaracter := Copy(pTexto,I,1);
      if Pos(xCaracter,xCarateresEspeciais) > 1 then
      begin
         Result := True;
         Exit;
      end;
   end;
end;

class function TFuncoes.DataExtensa(pData: TDateTime): String;
begin
   Result := FormatDateTime('DD', pData) + ' de ' +
             NomeMes(StrToInt(FormatDateTime('M', pData))) + ' de ' +
             FormatDateTime('YYYY', pData);
end;

class function TFuncoes.NomeMes(pMes: Integer): String;
begin
  Result := '';
  Case pMes Of
     1 : Result := 'Janeiro';
     2 : Result := 'Fevereiro';
     3 : Result := 'Março';
     4 : Result := 'Abril';
     5 : Result := 'Maio';
     6 : Result := 'Junho';
     7 : Result := 'Julho';
     8 : Result := 'Agosto';
     9 : Result := 'Setembro';
     10: Result := 'Outubro';
     11: Result := 'Novembro';
     12: Result := 'Dezembro';
  End;
end;

class function TFuncoes.ValidaCNPJCPF(pCNPJCPF: String;
   pTipoPessoa: String): Boolean;
var
   Digito : String;
   Digito1: String;
   Digito2: String;

   // Variáveis p/ CPF
   I,
   Contador : Integer;
   D101, D102, D103, D104, D105, D106, D107, D108, D109,
   D201, D202, D203, D204, D205, D206, D207, D208, D209,
   Df4,
   Df5,
   Df6,
   Resto1,
   PriDig,
   SegDig: Real;

   function Right(pString: String; pQuantidade: Integer): String;
   begin
      Result := Copy(pString,Length(pString)-pQuantidade+1,pQuantidade);
   end;

   function Mod11(pCodigo: String): String;
   var
      K,
      xSoma,
      xTemp : Integer;
   begin
      pCodigo := Trim(pCodigo);
      xSoma   := 0;

      for K := Length(pCodigo) DownTo 1 do
      begin
         if (Length(pCodigo) - K + 2) <= 9 then
            xTemp := (Length(pCodigo) - K + 2)
         else
            xTemp := (Length(pCodigo) - K + 2) - 8;

         xSoma := xSoma + StrToInt(Copy(pCodigo,K,1)) * xTemp;
      end; // End For

      if (11 - (xSoma mod 11)) > 9 then
         Result := '0'
      else
         Result := Trim(IntToStr(11 - (xSoma mod 11)));
   end;
begin
   Result := True;

   D101   := 0;
   D102   := 0;
   D103   := 0;
   D104   := 0;
   D105   := 0;
   D106   := 0;
   D107   := 0;
   D108   := 0;
   D109   := 0;
   D201   := 0;
   D202   := 0;
   D203   := 0;
   D204   := 0;
   D205   := 0;
   D206   := 0;
   D207   := 0;
   D208   := 0;
   D209   := 0;

   I := 1;

   while (Copy(pCNPJCPF,I,1) = Copy(pCNPJCPF,I+1,1)) and (I <= Length(pCNPJCPF)) do
      Inc(i);

   if (I = Length(pCNPJCPF)) or (pCNPJCPF = '') then
   begin
      Result := False;
      Exit;
   end;

   try
      if pTipoPessoa = 'J' then
      begin
         if (Length(SoNumero(pCNPJCPF)) <> 14) then // Marcos C. Costa - A validação não levava em conta o número de digitos do DOCUMENTO
         begin
            Result := False;
            Exit;
         end;

         pCNPJCPF := Trim(pCNPJCPF);
         Digito  := Right(pCNPJCPF,2);
         Digito1 := Mod11(Copy(pCNPJCPF,1,12));
         Digito2 := Mod11(Copy(pCNPJCPF,1,13));

         if Digito = Digito1+Digito2 then
            Result := True
         else
            Result := False;
      end
      else
      begin
         //********** Calculo do Primeiro Digito CPF pessoa Fisica ***********
         if (Length(SoNumero(pCNPJCPF)) <> 11) then // Marcos C. Costa - A validação não levava em conta o número de digitos do DOCUMENTO
         begin
            Result := False;
            Exit;
         end;

         Contador := 1;

         while Contador <= 9 do
         begin
            if Contador = 1 then
               D101 := StrToInt(Copy(pCNPJCPF,Contador,1));

            if Contador = 2 then
               D102 := StrToInt(Copy(pCNPJCPF,Contador,1));

            if Contador = 3 then
               D103 := StrToInt(Copy(pCNPJCPF,Contador,1));

            if Contador = 4 then
               D104 := StrToInt(Copy(pCNPJCPF,Contador,1));

            if Contador = 5 then
               D105 := StrToInt(Copy(pCNPJCPF,Contador,1));

            if Contador = 6 then
               D106 := StrToInt(Copy(pCNPJCPF,Contador,1));

            if Contador = 7 then
               D107 := StrToInt(Copy(pCNPJCPF,Contador,1));

            if Contador = 8 then
               D108 := StrToInt(Copy(pCNPJCPF,Contador,1));

            if Contador = 9 then
               D109 := StrToInt(Copy(pCNPJCPF,Contador,1));

            Contador := Contador + 1;
         end;

         Df4    := (10*D101 + 9*D102 + 8*D103 + 7*D104 + 6*D105 + 5*D106 + 4*D107 + 3*D108 + 2*D109);
         Df5    := (Df4 / 11);
         Df6    := (Int(Df5) * 11);
         Resto1 := (Df4 - Df6);

         if (Resto1 = 0) or (Resto1 = 1) then
            PriDig := 0
         else
            PriDig := (11 - Resto1);

         //********** Calculo do Segundo Digito CPF pessoa Fisica ***************

         Contador := 1;
         while Contador <= 9 do
         begin
            if Contador = 1 then
               D201 := StrToInt(Copy(pCNPJCPF,Contador,1));

            if Contador = 2 then
               D202 := StrToInt(Copy(pCNPJCPF,Contador,1));

            if Contador = 3 then
               D203 := StrToInt(Copy(pCNPJCPF,Contador,1));

            if Contador = 4 then
               D204 := StrToInt(Copy(pCNPJCPF,Contador,1));

            if Contador = 5 then
               D205 := StrToInt(Copy(pCNPJCPF,Contador,1));

            if Contador = 6 then
               D206 := StrToInt(Copy(pCNPJCPF,Contador,1));

            if Contador = 7 then
               D207 := StrToInt(Copy(pCNPJCPF,Contador,1));

            if Contador = 8 then
               D208 := StrToInt(Copy(pCNPJCPF,Contador,1));

            if Contador = 9 then
               D209 := StrToInt(Copy(pCNPJCPF,Contador,1));

            Contador := Contador + 1;
         end;

         Df4    := (11*D201 + 10*D202 + 9*D203 + 8*D204 + 7*D205 + 6*D206 + 5*D207 + 4*D208 + 3*D209 + 2*PriDig);
         Df5    := (Df4 / 11);
         Df6    := (Int(Df5) * 11);
         Resto1 := (Df4 - Df6);

         if (Resto1 = 0) Or (Resto1 = 1) then
            SegDig := 0
         else
            SegDig := 11 - Resto1;

         if (PriDig <> StrToInt(Copy(pCNPJCPF,10,1))) or
            (SegDig <> StrToInt(Copy(pCNPJCPF,11,1))) then
            Result := False;
      end;
   except
      Result := False;
   end;
end;

{Esse método consome a API do Windows para descompactar um ZIP
 É possível indicar uma máscara, como '*.html' para que só arquivos
 correspondentes sejam extraídos, caso nada seja indicado, tudo é extraído}
class function TFuncoes.ShellUnzip(pArquivoZip, pPastaDestino: string;
   pFiltro: string = ''): Boolean;
var
   xShell,
   xPastaRaiz,
   xPastaDestino,
   xColecaoArquivos,
   xPastaDestinoVariant,
   xArquivoZipVariant: variant;
begin
   xArquivoZipVariant := pArquivoZip;
   xPastaDestinoVariant := pPastaDestino;

   xShell := CreateOleObject('Shell.Application');

   xPastaRaiz := xShell.NameSpace((xArquivoZipVariant));
   xPastaDestino := xShell.NameSpace((xPastaDestinoVariant));

   xColecaoArquivos := xPastaRaiz.Items;

   if (pFiltro <> '') then
     xColecaoArquivos.Filter(SHCONTF_INCLUDEHIDDEN or SHCONTF_NONFOLDERS or SHCONTF_FOLDERS,(pFiltro));

   xPastaDestino.CopyHere((xColecaoArquivos), SHCONTCH_NOPROGRESSBOX or SHCONTCH_RESPONDYESTOALL);
end;

class function TFuncoes.ValidaNumeroNaoPermitido(
   pCodGerado   : String;
   pCodComparado: String;
   pQtdeCaracter: Integer): Boolean;
var
   xCodigosNaoPermitidos : String;
begin
   Result := False;
   xCodigosNaoPermitidos :=
      '00000000, 11111111, 22222222, 33333333, 44444444, 55555555, 66666666, '+
      '77777777, 88888888, 99999999, 12345678, 23456789, 34567890, 45678901, '+
      '56789012, 67890123, 78901234, 89012345, 90123456, 01234567';

   pCodGerado := StrZero(pCodGerado, pQtdeCaracter);
   if (Pos(pCodGerado, xCodigosNaoPermitidos) = 0) and
      (pCodGerado <> pCodComparado) then
      Result := True;
end;

class procedure TFuncoes.ordenaTStrings(pLista: TStrings);
var
   tmp: TStringList;
begin
   if pLista is TStringList then
   begin
      TStringList(pLista).Sort;
   end
   else
   begin
      tmp := TStringList.Create;
      try
         // make a copy
         tmp.Assign(pLista);
         // sort the copy
         tmp.Sort;
         //
         pLista.Assign(tmp);
      finally
         tmp.Free;
      end;
   end;
end;

class function TFuncoes.Base36(pNumero, pQuantidadeCasas: Integer): String;
var
   I, xQuociente, xResto: Integer;

   function DigitoBase36(pNum: Integer): string;
   begin
      if pNum < 10 then
         Result := Chr(Ord('0') + pNum)
      else
         Result := Chr(Ord('A') + pNum - 10);
   end;

begin
   if pNumero >= Power(36, pQuantidadeCasas) then
      raise Exception.Create('Limite excedido.');

   xQuociente := pNumero;
   Result := '';

   for I := 1 to pQuantidadeCasas do
   begin
      xResto := xQuociente mod 36;
      Result := DigitoBase36(xResto) + Result;

      xQuociente := xQuociente div 36;
   end;
end;

class function TFuncoes.ValidaData(var pData: TMaskEdit; pLabelData: String;
   pPermiteVazio: Boolean = false; pAnoBase: Integer = 0): Boolean;
begin
   Result := False;

   if pData.Enabled Then
   begin
      try
         pData.Text := MontaAno(pData.Text, pAnoBase);
         pData.Text := FormatDateTime('DD/MM/YYYY', StrToDate(pData.Text));
      except
         on EConvertError do
         if (not pPermiteVazio) and (pData.Text = '  /  /    ') then
         begin
            Application.MessageBox(Pchar(pLabelData + ' não pode ficar em branco. '),'Alerta',MB_ICONWARNING+MB_OK);
            If pData.Parent.ClassName = 'TTabSheet' Then
               pData.Parent.Show;
            If pData.CanFocus Then
               pData.SetFocus;
            Exit;
         end
         else
         if (pData.Text <> '  /  /    ')  then
         begin
            Application.MessageBox(Pchar(pLabelData + ' inválida. '),'Alerta',MB_ICONWARNING+MB_OK);
            If pData.Parent.ClassName = 'TTabSheet' then
               pData.Parent.Show;
            pData.Clear;
            if pData.CanFocus then
               pData.SetFocus;
            Exit;
         end;
      end;
   end;
   
   Result := True;
end;

class procedure TFuncoes.CentralizaForm(pForm: TForm);
var
   xRect: TRect;
   xMainClientWidth,
   xMainClientHeight: Integer;
begin
   // Obtem o retângulo da área cliente MDI
   Windows.GetWindowRect(Application.MainForm.ClientHandle, xRect);
                                    
   // Calcula a origem da área cliente MDI no form pai
   xMainClientWidth  := xRect.Right - xRect.Left;
   xMainClientHeight := xRect.Bottom - xRect.Top;
   
   // Calcula nossa nova posição
   pForm.Left := (xMainClientWidth div 2) - (pForm.Width div 2);
   pForm.Top  := (xMainClientHeight div 2) - (pForm.Height div 2);
end;

end.
