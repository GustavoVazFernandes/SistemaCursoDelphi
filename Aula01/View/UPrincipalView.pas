unit UPrincipalView; // Nome da Unit

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, frxpngimage , ComCtrls;

type
  TForm1 = class(TForm)    //Nome da Classes
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
    UConexao;

{$R *.dfm}


procedure TForm1.menSairClick(Sender: TObject);
begin
   Close; // Fecha o Sistema
end;

procedure TForm1.FormShow(Sender: TObject);
begin
   stbBarraStatus.Panels [0].Text :=
   'Caminho do BD:' + TConexao.get.getCaminhoBanco;
end;

end.
