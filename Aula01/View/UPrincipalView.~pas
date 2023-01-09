unit UPrincipalView; // Nome da Unit

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, frxpngimage , ComCtrls, Buttons, UEnumerationUtil;

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

    // Metodos ja criados
    
    procedure menSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure menClientesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNovoSistema: TfrmNovoSistema;

implementation

uses
    UConexao,UClientesView;

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

      if   frmClientes = nil then
           frmClientes := TfrmClientes.Create(Application);


      frmClientes.Show;
   finally
      Screen.Cursor := crDefault;
   end;
end  ;



end.









