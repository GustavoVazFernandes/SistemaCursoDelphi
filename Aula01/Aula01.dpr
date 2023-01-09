program Aula01;

uses
  Forms,
  UPrincipalView in 'View\UPrincipalView.pas' {frmNovoSistema},
  UConexao in 'Model\BD\UConexao.pas',
  UGenericDAO in 'Model\BD\UGenericDAO.pas',
  UCriptografiaUtil in 'Model\Util\UCriptografiaUtil.pas',
  UClassFuncoes in 'Model\Util\UClassFuncoes.pas',
  UClientesView in 'View\UClientesView.pas' {frmClientes},
  uMessageUtil in 'Model\Util\uMessageUtil.pas',
  Consts in 'Model\Util\Consts.pas',
  UEnumerationUtil in 'Model\Util\UEnumerationUtil.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmNovoSistema, frmNovoSistema);
  Application.Run;
end.
