program Aula01;

uses
  Forms,
  UPrincipalView in 'View\UPrincipalView.pas' {Form1},
  UConexao in 'Model\BD\UConexao.pas',
  UGenericDAO in 'Model\BD\UGenericDAO.pas',
  UCriptografiaUtil in 'Model\Util\UCriptografiaUtil.pas',
  UClassFuncoes in 'Model\Util\UClassFuncoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
