unit UProdutosPesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UProdutos, UProdutosController, DB, DBClient, Grids, DBGrids,
  ExtCtrls, ComCtrls, StdCtrls, Buttons, uMessageUtil;

type
  TfrmProdutosPesq = class(TForm)
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
    dbgProduto: TDBGrid;
    dtsProduto: TDataSource;
    cdsProduto: TClientDataSet;
    cdsProdutoID: TIntegerField;
    cdsProdutoUnidade: TStringField;
    cdsProdutoNome: TStringField;
    cdsProdutoPreco: TFloatField;
    procedure btnFiltrarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure cdsProdutoBeforeDelete(DataSet: TDataSet);
    procedure dbgProdutoDblClick(Sender: TObject);
    procedure dbgProdutoKeyDown(Sender: TObject; var Key: Word;
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
    mProdutoID : Integer;
    mProdutoNome: String;
  end;

var
   frmProdutosPesq: TfrmProdutosPesq;

implementation

{$R *.dfm}

{ TfrmProdutosPesq }

procedure TfrmProdutosPesq.btnConfirmarClick(Sender: TObject);
begin
   mProdutoID := 0;
   mProdutoNome := EmptyStr;
   ProcessaConfirmacao;
   LimparTela;
end;

procedure TfrmProdutosPesq.btnFiltrarClick(Sender: TObject);
begin
   mProdutoID := 0;
   mProdutoNome := EmptyStr;
   ProcessaPesquisa;
end;

procedure TfrmProdutosPesq.btnLimparClick(Sender: TObject);
begin
   LimparTela;
end;

procedure TfrmProdutosPesq.btnSairClick(Sender: TObject);
begin
   mProdutoID := 0;
   mProdutoNome := EmptyStr;
   LimparTela;
   Close;
end;

procedure TfrmProdutosPesq.LimparTela;
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if Components[i] is TEdit then
         (Components[i] as TEdit).Text := EmptyStr;
   end;

   if not cdsProduto.IsEmpty then
      cdsProduto.EmptyDataSet;


   if edtNome.CanFocus then
      edtNome.SetFocus;

end;

procedure TfrmProdutosPesq.ProcessaConfirmacao;
begin
   if not cdsProduto.IsEmpty then
   begin
      mProdutoID := cdsProdutoID.Value;
      mProdutoNome := cdsProdutoNome.Value;
      Self.ModalResult  := mrOk;
      Close;
   end
   else
   begin
      TMessageUtil.Alerta('Nenhum produto selecionado.');

      if edtNome.CanFocus then
         edtNome.SetFocus;
   end;
end;

procedure TfrmProdutosPesq.ProcessaPesquisa;
var
   xListaProduto : TColProduto;
   xAux : Integer;
begin
   try
      try
         xListaProduto := TColProduto.Create;

         xListaProduto :=
          TProdutoController.getInstancia.PesquisaProduto(
             Trim(edtNome.Text));

           cdsProduto.EmptyDataSet;

         if xListaProduto <> nil then
            for xAux := 0 to pred(xListaProduto.Count) do
            begin
               cdsProduto.Append;
               cdsProdutoID.Value := xListaProduto.Retorna(xAux).Id;
               cdsProdutoUnidade.Value := xListaProduto.Retorna(xAux).UnidadeSaida;
               cdsProdutoNome.Value := xListaProduto.Retorna(xAux).Nome;
               cdsProdutoPreco.Value := xListaProduto.Retorna(xAux).PrecoVenda;
               cdsProduto.Post;
            end;

            if cdsProduto.RecordCount = 0 then
            begin
               if edtNome.CanFocus then
                  edtNome.SetFocus;

               TMessageUtil.Alerta(
                  'Nenhum produto encontrada na pesquisa.');
            end
            else
            begin
               cdsProduto.First;
               if dbgProduto.CanFocus then
                  dbgProduto.SetFocus;
            end;

      finally
         if xListaProduto <> nil  then
            FreeAndNil(xListaProduto);
      end;
   except
      on E: Exception do
      begin
         raise Exception.Create(
         'Falha ao pesquisar os dados do produto [View]:'#13+
         e.Message);
      end;
   end;
end;

procedure TfrmProdutosPesq.cdsProdutoBeforeDelete(DataSet: TDataSet);
begin
   Abort;
end;

procedure TfrmProdutosPesq.dbgProdutoDblClick(
  Sender: TObject);
begin
   mProdutoID := 0;
   mProdutoNome := EmptyStr;
   ProcessaConfirmacao;
   LimparTela;
end;

procedure TfrmProdutosPesq.dbgProdutoKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if (Key = VK_RETURN) and
      (btnConfirmar.CanFocus) then
       btnConfirmar.SetFocus;

end;

procedure TfrmProdutosPesq.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
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

         if ActiveControl = dbgProduto then
            Exit;

         Perform(WM_NEXTDLGCTL,1,0);
      end;

   end;

end;

procedure TfrmProdutosPesq.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   cdsProduto.EmptyDataSet;
end;

end.
