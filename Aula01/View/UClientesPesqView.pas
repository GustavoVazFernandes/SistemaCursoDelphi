unit UClientesPesqView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, DB, DBClient, Grids,
  DBGrids, uMessageUtil, UPessoa, UPessoaController, UClassFuncoes,
  OleServer, ExcelXP;

type
  TfrmClientesPesq = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    btnConfirmar: TBitBtn;
    btnSair: TBitBtn;
    btnLimpar: TBitBtn;
    pnFiltro: TPanel;
    pnResultado: TPanel;
    grbFiltrar: TGroupBox;
    lblNome: TLabel;
    edtNome: TEdit;
    lblInfo: TLabel;
    btnFiltrar: TBitBtn;
    grbGrid: TGroupBox;
    dbgCliente: TDBGrid;
    dtsCliente: TDataSource;
    cdsCliente: TClientDataSet;
    cdsClienteID: TIntegerField;
    cdsClienteNome: TStringField;
    cdsClienteAtivo: TIntegerField;
    cdsClienteDescricaoAtivo: TStringField;
    BitBtn1: TBitBtn;
    svdDiretorio: TSaveDialog;
    Excel: TExcelApplication;
    procedure btnSairClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFiltrarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure cdsClienteBeforeDelete(DataSet: TDataSet);
    procedure dbgClienteDblClick(Sender: TObject);
    procedure dbgClienteKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    
  private
    { Private declarations }
    vKey : Word;

    procedure LimparTela;
    procedure ProcessaPesquisa;
    procedure ProcessaConfirmacao;
    procedure PreenchePlanilha;
  public
    { Public declarations }
    mClienteID : Integer;
    mClienteNome: String;
  end;

var
  frmClientesPesq: TfrmClientesPesq;

implementation

uses Math, StrUtils, ComObj;

{$R *.dfm}

procedure TfrmClientesPesq.btnSairClick(Sender: TObject);
begin
   mClienteID := 0;
   mClienteNome := EmptyStr;
   LimparTela;
   Close;
end;

procedure TfrmClientesPesq.FormKeyDown(Sender: TObject; var Key: Word;
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

         if ActiveControl = dbgCliente then
            Exit;

         Perform(WM_NEXTDLGCTL,1,0);
      end;

   end;

end;

procedure TfrmClientesPesq.LimparTela;
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if Components[i] is TEdit then
         (Components[i] as TEdit).Text := EmptyStr;
   end;

   if not cdsCliente.IsEmpty then
      cdsCliente.EmptyDataSet;


   if edtNome.CanFocus then
      edtNome.SetFocus;

end;

procedure TfrmClientesPesq.ProcessaConfirmacao;
begin
   if not cdsCliente.IsEmpty then
   begin
      mClienteID := cdsClienteID.Value;
      mClienteNome := cdsClienteNome.Value;
      Self.ModalResult  := mrOk;
      Close;
   end
   else
   begin
      TMessageUtil.Alerta('Nenhum cliente selecionado.');

      if edtNome.CanFocus then
         edtNome.SetFocus;
   end;
end;

procedure TfrmClientesPesq.ProcessaPesquisa;
var
   xListaCliente : TColPessoa;
   xAux : Integer;
begin
   try
      try
         xListaCliente := TColPessoa.Create;

         xListaCliente :=
          TPessoaController.getInstancia.PesquisaPessoa(Trim(edtNome.Text));

          cdsCliente.EmptyDataSet;

          if xListaCliente <> nil then
             for xAux := 0 to pred(xListaCliente.Count) do
             begin
                cdsCliente.Append;
                cdsClienteID.Value := xListaCliente.Retorna(xAux).Id;
                cdsClienteNome.Value := xListaCliente.Retorna(xAux).Nome;
                cdsClienteAtivo.Value :=
                   IfThen(xListaCliente.Retorna(xAux).Ativo,1,0);
                cdsClienteDescricaoAtivo.Value :=
                   IfThen(xListaCliente.Retorna(xAux).Ativo, 'Sim', 'Não');
                   cdsCliente.Post;
             end;

             if cdsCliente.RecordCount = 0 then
             begin
                if edtNome.CanFocus then
                   edtNome.SetFocus;

                TMessageUtil.Alerta('Nenhum cliente encontrado na pesquisa.');
             end
             else
             begin
                cdsCliente.First;
                if dbgCliente.CanFocus then
                   dbgCliente.SetFocus;
             end;

      finally
         if xListaCliente <> nil  then
            FreeAndNil(xListaCliente);
      end;
   except
      on E: Exception do
      begin
         raise Exception.Create(
         'Falha ao pesquisar os dados da Pessoa [View]:'#13+
         e.Message);
      end;
   end;
end;

procedure TfrmClientesPesq.btnFiltrarClick(Sender: TObject);
begin
   mClienteID := 0;
   mClienteNome := EmptyStr;
   ProcessaPesquisa;
end;

procedure TfrmClientesPesq.btnConfirmarClick(Sender: TObject);
begin
   mClienteID := 0;
   mClienteNome := EmptyStr;
   ProcessaConfirmacao;
   LimparTela;
end;

procedure TfrmClientesPesq.btnLimparClick(Sender: TObject);
begin
   LimparTela;
end;

procedure TfrmClientesPesq.cdsClienteBeforeDelete(DataSet: TDataSet);
begin
   Abort;
end;

procedure TfrmClientesPesq.dbgClienteDblClick(Sender: TObject);
begin
   mClienteID := 0;
   mClienteNome := EmptyStr;
   ProcessaConfirmacao;
   LimparTela
end;

procedure TfrmClientesPesq.dbgClienteKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if (Key = VK_RETURN) and
      (btnConfirmar.CanFocus) then
      btnConfirmar.SetFocus;

end;

procedure TfrmClientesPesq.BitBtn1Click(Sender: TObject);
begin
   PreenchePlanilha;
end;

procedure TfrmClientesPesq.PreenchePlanilha;
var
   xExcel     : Variant;
   xIndiceCab : Integer;
   xCaminho   : String;
begin
   xIndiceCab := 1;
   xCaminho   := 'ListagemCliente_'+ DateTimeToStr(Now)+ '.xls';

   xCaminho   := TFuncoes.Troca(xCaminho, '/','');
   xCaminho   := TFuncoes.Troca(xCaminho, ':','');
   svdDiretorio.FileName := xCaminho;
   if not svdDiretorio.Execute then
      Exit;

   xCaminho := svdDiretorio.FileName;
   try
      xExcel := CreateOleObject('Excel.Application');
      xExcel.Application.Visible := False;

      xExcel.WorkBooks.Add(null);

      xExcel.ActiveSheet.Rows[2].Select;
      xExcel.ActiveSheet.FreezePanes := True;

      xExcel.Range['A1','A1'].ColumnWidth := 10.00;
      xExcel.Range['B1','B1'].ColumnWidth := 100.00;
      xExcel.Range['C1','C1'].ColumnWidth := 10.00;

      xExcel.Range['D1','E1'].MergeCells := True;  //Mesclar celulas

      xExcel.Range['A1','C1'].Interior.ColorIndex := 16;       //Cinza Escuro
      xExcel.Range['A1','C1'].Font.Bold := True;               //Negrito
      xExcel.Range['A1','C1'].Font.Name := 'Arial';            //Fonte
      xExcel.Range['A1','C1'].Font.Size := 12;                 //Tamanho Fonte
      xExcel.Range['A1','C1'].HorizontalAlignment := xlCenter; // Alinhamento

      xExcel.Range['A1','A1'].Value := 'Código';
      xExcel.Range['B1','B1'].Value := 'Nome';
      xExcel.Range['C1','C1'].Value := 'Ativo';

      cdsCliente.First;
      while not cdsCliente.Eof do
      begin
         Inc(xIndiceCab);
         xExcel.Range['A'+IntToStr(xIndiceCab),'A'+IntToStr(xIndiceCab)].Value
           := cdsClienteID.AsString;
         xExcel.Range['B'+IntToStr(xIndiceCab),'B'+IntToStr(xIndiceCab)].Value
           := cdsClienteNome.Value;
         xExcel.Range['C'+IntToStr(xIndiceCab),'C'+IntToStr(xIndiceCab)].Value
           := cdsClienteDescricaoAtivo.Value;

         cdsCliente.Next;

      end;



      if FileExists(xCaminho) then
         DeleteFile(xCaminho);

      xExcel.WorkBooks[1].Worksheets[1].Activate;
      xExcel.ActiveWorkBook.SaveAs(xCaminho);

      xExcel.Application.Visible := True;
   finally
      xExcel := Unassigned;

   end;
end;


procedure TfrmClientesPesq.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   cdsCliente.EmptyDataSet;
end;

end.
