unit UUnidadeProdutosPesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, Grids, DBGrids, ComCtrls, StdCtrls, Buttons,
  ExtCtrls, UUnidadeProdutos, UUnidadeProdutosController, uMessageUtil;

type
  TfrmUnidadeProdutosPesq = class(TForm)
    pnFiltro: TPanel;
    grbFiltrar: TGroupBox;
    lblNome: TLabel;
    lblInfo: TLabel;
    edtNome: TEdit;
    btnFiltrar: TBitBtn;
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    btnConfirmar: TBitBtn;
    btnSair: TBitBtn;
    btnLimpar: TBitBtn;
    grbGrid: TGroupBox;
    dbgUnidadeProdutos: TDBGrid;
    dtsUnidadeProdutos: TDataSource;
    cdsUnidadeProdutos: TClientDataSet;
    cdsUnidadeProdutosID: TIntegerField;
    cdsUnidadeProdutosAtivo: TIntegerField;
    cdsUnidadeProdutosDescricaoAtivo: TStringField;
    cdsUnidadeProdutosUnidade: TStringField;
    cdsUnidadeProdutosDescricao: TStringField;
    procedure btnSairClick(Sender: TObject);
    procedure btnFiltrarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure cdsUnidadeProdutosBeforeDelete(DataSet: TDataSet);
    procedure dbgUnidadeProdutosDblClick(Sender: TObject);
    procedure dbgUnidadeProdutosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);


  private
    { Private declarations }
    vKey : Word;

    procedure LimparTela;
    procedure ProcessaPesquisa;
    procedure ProcessaConfirmacao;


  public
    { Public declarations }
    mUnidadeProdutosID : Integer;
    mUnidadeProdutosDescricao: String;
end;

var
   frmUnidadeProdutosPesq: TfrmUnidadeProdutosPesq;

implementation

uses Math, StrUtils, ComObj;

{$R *.dfm}

procedure TfrmUnidadeProdutosPesq.btnSairClick(Sender: TObject);
begin
   mUnidadeProdutosID := 0;
   mUnidadeProdutosDescricao := EmptyStr;
   LimparTela;
   Close;
end;


procedure TfrmUnidadeProdutosPesq.LimparTela;
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if Components[i] is TEdit then
         (Components[i] as TEdit).Text := EmptyStr;
   end;

   if not cdsUnidadeProdutos.IsEmpty then
      cdsUnidadeProdutos.EmptyDataSet;


   if edtNome.CanFocus then
      edtNome.SetFocus;

end;

procedure TfrmUnidadeProdutosPesq.ProcessaConfirmacao;
begin
   if not cdsUnidadeProdutos.IsEmpty then
   begin
      mUnidadeProdutosID := cdsUnidadeProdutosID.Value;
      mUnidadeProdutosDescricao := cdsUnidadeProdutosDescricao.Value;
      Self.ModalResult  := mrOk;
      Close;
   end
   else
   begin
      TMessageUtil.Alerta('Nenhuma unidade de produto selecionado.');

      if edtNome.CanFocus then
         edtNome.SetFocus;
   end;
end;

procedure TfrmUnidadeProdutosPesq.ProcessaPesquisa;
var
   xListaUnidadeProdutos : TColUnidadeProdutos;
   xAux : Integer;
begin
   try
      try
         xListaUnidadeProdutos := TColUnidadeProdutos.Create;

         xListaUnidadeProdutos :=
          TUnidadeProdutosController.getInstancia.PesquisaUnidadeProdutos(
             Trim(edtNome.Text));

           cdsUnidadeProdutos.EmptyDataSet;

         if xListaUnidadeProdutos <> nil then
            for xAux := 0 to pred(xListaUnidadeProdutos.Count) do
            begin
               cdsUnidadeProdutos.Append;
               cdsUnidadeProdutosID.Value := xListaUnidadeProdutos.Retorna(
                  xAux).Id;
               cdsUnidadeProdutosUnidade.Value := xListaUnidadeProdutos.Retorna(
                  xAux).Unidade;
               cdsUnidadeProdutosDescricao.Value := xListaUnidadeProdutos.Retorna(
                  xAux).Descricao;
               cdsUnidadeProdutosAtivo.Value :=
                  IfThen(xListaUnidadeProdutos.Retorna(xAux).Ativo,1,0);
               cdsUnidadeProdutosDescricaoAtivo.Value :=
                  IfThen(xListaUnidadeProdutos.Retorna(xAux).Ativo, 'Sim', 'Não');
                  cdsUnidadeProdutos.Post;
            end;

            if cdsUnidadeProdutos.RecordCount = 0 then
            begin
               if edtNome.CanFocus then
                  edtNome.SetFocus;

               TMessageUtil.Alerta(
                  'Nenhuma unidade de produto encontrada na pesquisa.');
            end
            else
            begin
               cdsUnidadeProdutos.First;
               if dbgUnidadeProdutos.CanFocus then
                  dbgUnidadeProdutos.SetFocus;
            end;

      finally
         if xListaUnidadeProdutos <> nil  then
            FreeAndNil(xListaUnidadeProdutos);
      end;
   except
      on E: Exception do
      begin
         raise Exception.Create(
         'Falha ao pesquisar os dados da unidade de produto [View]:'#13+
         e.Message);
      end;
   end;
end;

procedure TfrmUnidadeProdutosPesq.btnFiltrarClick(Sender: TObject);
begin
   mUnidadeProdutosID := 0;
   mUnidadeProdutosDescricao := EmptyStr;
   ProcessaPesquisa;
end;

procedure TfrmUnidadeProdutosPesq.btnConfirmarClick(Sender: TObject);
begin
   mUnidadeProdutosID := 0;
   mUnidadeProdutosDescricao := EmptyStr;
   ProcessaConfirmacao;
   LimparTela;
end;

procedure TfrmUnidadeProdutosPesq.btnLimparClick(Sender: TObject);
begin
   LimparTela;
end;

procedure TfrmUnidadeProdutosPesq.cdsUnidadeProdutosBeforeDelete(
  DataSet: TDataSet);
begin
   Abort;
end;

procedure TfrmUnidadeProdutosPesq.dbgUnidadeProdutosDblClick(
  Sender: TObject);
begin
   mUnidadeProdutosID := 0;
   mUnidadeProdutosDescricao := EmptyStr;
   ProcessaConfirmacao;
   LimparTela;
end;

procedure TfrmUnidadeProdutosPesq.dbgUnidadeProdutosKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if (Key = VK_RETURN) and
      (btnConfirmar.CanFocus) then
      btnConfirmar.SetFocus;

end;


procedure TfrmUnidadeProdutosPesq.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
 vKey := Key;

   case vKey of
      VK_RETURN:
      begin
         Perform(WM_NEXTDLGCTL,0,0);
      end;
      VK_ESCAPE:
      begin
         if TMessageUtil.Pergunta('Deseja sair da rotina?') then
            LimparTela;
            Close;
      end;
      VK_UP:
      begin
         vKey := VK_CLEAR;

         if ActiveControl = dbgUnidadeProdutos then
            Exit;

         Perform(WM_NEXTDLGCTL,1,0);
      end;

   end;

end;


procedure TfrmUnidadeProdutosPesq.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   cdsUnidadeProdutos.EmptyDataSet;
end;

end.
