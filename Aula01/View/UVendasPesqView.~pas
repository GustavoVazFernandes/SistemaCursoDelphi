unit UVendasPesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Forms,
  Dialogs, DB, DBClient, Grids, DBGrids, ComCtrls, StdCtrls, Buttons,
  ExtCtrls, UVenda, UVendaController, uMessageUtil, UClassFuncoes, Controls,
  UCliente, UPessoaController;

type
  TfrmVendaPesq = class(TForm)
    pnFiltro: TPanel;
    grbFiltrar: TGroupBox;
    lblCodigo: TLabel;
    lblInfo: TLabel;
    edtCodigo: TEdit;
    btnFiltrar: TBitBtn;
    pnlBotoes: TPanel;
    btnConfirmar: TBitBtn;
    btnSair: TBitBtn;
    btnLimpar: TBitBtn;
    stbBarraStatus: TStatusBar;
    grbGrid: TGroupBox;
    dbgVendaPesq: TDBGrid;
    dtsVendaPesq: TDataSource;
    cdsVendaPesq: TClientDataSet;
    cdsVendaPesqID: TIntegerField;
    cdsVendaPesqCliente: TStringField;
    cdsVendaPesqData: TDateTimeField;
    cdsVendaPesqTotal: TFloatField;
    cdsVendaPesqFaturada: TIntegerField;
    cdsVendaPesqDescricaoFaturada: TStringField;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnFiltrarClick(Sender: TObject);
    procedure cdsVendaPesqBeforeDelete(DataSet: TDataSet);
    procedure btnSairClick(Sender: TObject);
    procedure dbgVendaPesqDblClick(Sender: TObject);
    procedure dbgVendaPesqKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    { Private declarations }
    vObjCliente : TCliente;

    vKey : Word;

    procedure LimparTela;
    procedure ProcessaPesquisa;
    procedure ProcessaConfirmacao;

  public
    { Public declarations }
    mClienteID : Integer;
    mClienteNome: String;

  end;

var
   frmVendaPesq: TfrmVendaPesq;

implementation

uses Math, StrUtils, ComObj;



{$R *.dfm}



{ TfrmVendaPesq }

procedure TfrmVendaPesq.LimparTela;
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if Components[i] is TEdit then
         (Components[i] as TEdit).Text := EmptyStr;
   end;

   if not cdsVendaPesq.IsEmpty then
      cdsVendaPesq.EmptyDataSet;


   if edtCodigo.CanFocus then
      edtCodigo.SetFocus;

end;

procedure TfrmVendaPesq.ProcessaConfirmacao;
begin
   if not cdsVendaPesq.IsEmpty then
   begin
      mClienteID := cdsVendaPesqID.Value;
      mClienteNome := cdsVendaPesqCliente.Value;
      Self.ModalResult  := mrOk;
      Close;
   end
   else
   begin
      TMessageUtil.Alerta('Nenhuma venda selecionada.');

      if edtCodigo.CanFocus then
         edtCodigo.SetFocus;


   end;
end;

procedure TfrmVendaPesq.ProcessaPesquisa;
var
   xListaVenda : TColVenda;
   xAux : Integer;
   i : Integer;
begin
   try
      try
         xListaVenda := TColVenda.Create;

         xListaVenda :=
          TVendaController.getInstancia.PesquisaVenda(Trim(edtCodigo.Text));

         cdsVendaPesq.EmptyDataSet;

         if xListaVenda <> nil then
            for xAux := 0 to pred(xListaVenda.Count) do
            begin
               cdsVendaPesq.Append;
               cdsVendaPesqID.Value          := xListaVenda.Retorna(xAux).Id;
               i := xListaVenda.Retorna(xAux).Id_Cliente;
               vObjCliente :=
                  TCliente(TPessoaController.getInstancia.BuscaPessoa(
                     i));
               cdsVendaPesqCliente.Value     := vObjCliente.Nome;
               cdsVendaPesqData.Value        := xListaVenda.Retorna(xAux).DataVenda;
               cdsVendaPesqTotal.Value       := xListaVenda.Retorna(xAux).TotalVenda;
               cdsVendaPesqFaturada.Value    :=
                  IfThen(xListaVenda.Retorna(xAux).Faturada,1,0);
               cdsVendaPesqDescricaoFaturada.Value :=
                  IfThen(xListaVenda.Retorna(xAux).Faturada, 'Sim', 'Não');
               cdsVendaPesq.Post;
            end;

            if cdsVendaPesq.RecordCount = 0 then
            begin
               if edtCodigo.CanFocus then
                  edtCodigo.SetFocus;

               TMessageUtil.Alerta('Nenhuma venda encontrado na pesquisa.');
            end
            else
            begin
               cdsVendaPesq.First;
               if dbgVendaPesq.CanFocus then
                  dbgVendaPesq.SetFocus;
            end;

      finally
         if xListaVenda <> nil  then
            FreeAndNil(xListaVenda);
      end;
   except
      on E: Exception do
      begin
         raise Exception.Create(
         'Falha ao pesquisar os dados do Cliente [View]:'#13+
         e.Message);
      end;
   end;
end;

procedure TfrmVendaPesq.FormKeyDown(Sender: TObject; var Key: Word;
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

         if ActiveControl = dbgVendaPesq then
            Exit;

         Perform(WM_NEXTDLGCTL,1,0);
      end;

   end;
end;

procedure TfrmVendaPesq.btnFiltrarClick(Sender: TObject);
begin
   mClienteID := 0;
   mClienteNome := EmptyStr;
   ProcessaPesquisa;
end;

procedure TfrmVendaPesq.btnConfirmarClick(Sender: TObject);
begin
   mClienteID := 0;
   mClienteNome := EmptyStr;
   ProcessaConfirmacao;
   LimparTela;
end;

procedure TfrmVendaPesq.btnLimparClick(Sender: TObject);
begin
   LimparTela;
end;

procedure TfrmVendaPesq.cdsVendaPesqBeforeDelete(DataSet: TDataSet);
begin
   Abort;
end;

procedure TfrmVendaPesq.dbgVendaPesqDblClick(Sender: TObject);
begin
   mClienteID := 0;
   mClienteNome := EmptyStr;
   ProcessaConfirmacao;
   LimparTela
end;

procedure TfrmVendaPesq.btnSairClick(Sender: TObject);
begin
   mClienteID := 0;
   mClienteNome := EmptyStr;
   LimparTela;
   Close;
end;


procedure TfrmVendaPesq.dbgVendaPesqKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (Key = VK_RETURN) and
      (btnConfirmar.CanFocus) then
      btnConfirmar.SetFocus;
end;
end.
