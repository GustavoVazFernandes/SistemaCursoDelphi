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
  UEnumerationUtil in 'Model\Util\UEnumerationUtil.pas',
  Upessoa in 'Model\UPessoa.pas',
  UPessoaDAO in 'Model\UPessoaDAO.pas',
  UCliente in 'Model\UCliente.pas',
  UPessoaController in 'Controller\UPessoaController.pas',
  UEndereco in 'Model\UEndereco.pas',
  UEnderecoDAO in 'Model\UEnderecoDAO.pas',
  UClientesPesqView in 'View\UClientesPesqView.pas' {frmClientesPesq},
  UUnidadeProdutosView in 'View\UUnidadeProdutosView.pas' {frmUnidadeProdutos},
  UUnidadeProdutos in 'Model\UUnidadeProdutos.pas',
  UUnidadeProdutosDAO in 'Model\UUnidadeProdutosDAO.pas',
  UUnidadeProdutosController in 'Controller\UUnidadeProdutosController.pas',
  UUnidadeProdutosPesqView in 'View\UUnidadeProdutosPesqView.pas' {frmUnidadeProdutosPesq},
  UProdutosView in 'View\UProdutosView.pas' {frmProdutos},
  UProdutos in 'Model\UProdutos.pas',
  UProdutosDAO in 'Model\UProdutosDAO.pas',
  UProdutosController in 'Controller\UProdutosController.pas',
  UProdutosPesqView in 'View\UProdutosPesqView.pas' {frmProdutosPesq},
  UVendasView in 'View\UVendasView.pas' {frmVendas},
  UVenda in 'Model\UVenda.pas',
  UVendaDAO in 'Model\UVendaDAO.pas',
  UVendaItem in 'Model\UVendaItem.pas',
  UVendaItemDAO in 'Model\UVendaItemDAO.pas',
  UVendaController in 'Controller\UVendaController.pas',
  UVendasPesqView in 'View\UVendasPesqView.pas' {frmVendaPesq};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmNovoSistema, frmNovoSistema);
  Application.Run;
end.
