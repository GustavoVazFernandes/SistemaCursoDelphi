unit uMessageUtil;

interface

uses
  Windows, Dialogs, Controls;

type
  TMessageUtil = class

  private
    class function MostraPergunta(pPergunta: String; mbDefault: TMsgDlgBtn = mbYes): Boolean; 
  public
    class function Alerta(pAlerta: String; pComponenteFoco: TWinControl = nil): Boolean;
    class function Erro(pErro: String; pComponenteFoco: TWinControl = nil): Boolean;
    class function Informacao(pInformacao: String; pComponenteFoco: TWinControl = nil): Boolean;
    class function Pergunta(pPergunta: String; pComponenteFoco: TWinControl = nil): Boolean; overload;
    {$IFNDEF VER150}
    class function Pergunta(pPergunta: String; mbDefault: TMsgDlgBtn; pComponenteFoco: TWinControl = nil): Boolean; overload;
    {$ENDIF}
  end;

implementation

{ TMessageUtil }

//IsConsole verifica se a aplicação é executava em modo de linha de comando, normalmente os casos de teste são.
//Validando desta forma evita exibição de msg na tela ao executar casos de teste.


class function TMessageUtil.Alerta(pAlerta: String; pComponenteFoco: TWinControl = nil): Boolean;
begin
   if Not IsConsole then
      MessageDlg(pAlerta, mtWarning, [mbOk], 0);

   Result := True;

   if ((pComponenteFoco <> nil) And (pComponenteFoco.CanFocus)) then
      pComponenteFoco.SetFocus;
end;

class function TMessageUtil.Erro(pErro: String; pComponenteFoco: TWinControl = nil): Boolean;
begin
   if Not IsConsole then
      MessageDlg(pErro, mtError, [mbOk], 0);

   Result := True;

   if ((pComponenteFoco <> nil) And (pComponenteFoco.CanFocus)) then
      pComponenteFoco.SetFocus;
end;

class function TMessageUtil.Informacao(pInformacao: String; pComponenteFoco: TWinControl = nil): Boolean;
begin
   if Not IsConsole then
      MessageDlg(pInformacao, mtInformation, [mbOk], 0);

   Result := True;
   if ((pComponenteFoco <> nil) And (pComponenteFoco.CanFocus)) then
      pComponenteFoco.SetFocus;
end;

class function TMessageUtil.MostraPergunta(pPergunta: String;
   mbDefault: TMsgDlgBtn): Boolean;
begin
   if Not IsConsole then
      Result :=
         {$IFDEF VER150}                                                   
         MessageDlg(
            pPergunta, mtConfirmation, [mbYes, mbNo], 0) = idYes
         {$ELSE}
         MessageDlg(
            pPergunta, mtConfirmation, [mbYes, mbNo], 0, mbDefault) = idYes
         {$ENDIF}
   else
      Result := True;
end;
    
{$IFNDEF VER150}
class function TMessageUtil.Pergunta(pPergunta: String; mbDefault: TMsgDlgBtn;
   pComponenteFoco: TWinControl): Boolean;
begin
   Result := MostraPergunta(pPergunta, mbDefault);

   if ((pComponenteFoco <> nil) And (pComponenteFoco.CanFocus)) then
      pComponenteFoco.SetFocus;
end;
{$ENDIF}

class function TMessageUtil.Pergunta(pPergunta: String; pComponenteFoco: TWinControl = nil): Boolean;
begin
   Result := MostraPergunta(pPergunta);

   if ((pComponenteFoco <> nil) And (pComponenteFoco.CanFocus)) then
      pComponenteFoco.SetFocus;
end;

end.
