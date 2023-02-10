unit UPrincipalView; // Nome da Unit

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, frxpngimage , ComCtrls, Buttons, UEnumerationUtil,
  uMessageUtil;

type
  TfrmNovoSistema = class(TForm)    //Nome da Classes
  { Lista de componentes visual que são adicionados a tela do prototipo
   Lembre-se de renomear TODOS os componentes que forem adicionados
   }
    menMenu: TMainMenu;
    menCadastros: TMenuItem;
    menClientes: TMenuItem;
    menProdutos: TMenuItem;
    menRelatorios: TMenuItem;
    menRelVendas: TMenuItem;
    menMovimentos: TMenuItem;
    menVendas: TMenuItem;
    menSair: TMenuItem;
    stbBarraStatus: TStatusBar;
    imgLogo: TImage;
    menUnidadeProduto: TMenuItem;

    // Metodos ja criados
    
    procedure menSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure menClientesClick(Sender: TObject);
    procedure menUnidadeProdutoClick(Sender: TObject);
    procedure menProdutosClick(Sender: TObject);
    procedure menVendasClick(Sender: TObject);



  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  frmNovoSistema: TfrmNovoSistema;

implementation

uses
    UConexao, UClientesView, UUnidadeProdutosView, UProdutosView,
  UVendasView;

{$R *.dfm}


procedure TfrmNovoSistema.menSairClick(Sender: TObject);
begin
   Close; // Fecha o Sistema
end;

procedure TfrmNovoSistema.FormShow(Sender: TObject);
begin
   stbBarraStatus.Panels [0].Text :=
   'Caminho do BD:' + TConexao.get.getCaminhoBanco;
end;

procedure TfrmNovoSistema.menClientesClick(Sender: TObject);
begin
   try
      Screen.Cursor := crHourGlass;

      if frmClientes = nil then
         frmClientes := TfrmClientes.Create(Application);


      frmClientes.Show;
   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TfrmNovoSistema.menUnidadeProdutoClick(Sender: TObject);
begin
   try
      Screen.Cursor := crHourGlass;

      if frmUnidadeProdutos = nil then
         frmUnidadeProdutos := TfrmUnidadeProdutos.Create(Application);


      frmUnidadeProdutos.Show;
   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TfrmNovoSistema.menProdutosClick(Sender: TObject);
begin
   try
      Screen.Cursor := crHourGlass;

      if frmProdutos = nil then
         frmProdutos := TfrmProdutos.Create(Application);


      frmProdutos.Show;
   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TfrmNovoSistema.menVendasClick(Sender: TObject);
begin
   try
      Screen.Cursor := crHourGlass;

      if frmVendas = nil then
         frmVendas := TfrmVendas.Create(Application);


      frmVendas.Show;
   finally
      Screen.Cursor := crDefault;
   end;
end;

end.










