unit UVendasView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DB, DBClient, Grids, DBGrids, ExtCtrls, Buttons,
  UEnumerationUtil, UPessoaController, UCliente, UVendaItem, UVenda,
  UVendaItemDAO, UVendaDAO, UVendaController, ComCtrls, UProdutos,
  UProdutosController;

type
  TfrmVendas = class(TForm)
    pnlGeral: TPanel;
    pnlValores: TPanel;
    pnlBotoes: TPanel;
    cdsVenda: TClientDataSet;
    dtsVendas: TDataSource;
    lblData: TLabel;
    edtData: TMaskEdit;
    edtCodigoVenda: TEdit;
    lblVenda: TLabel;
    lblCodigo: TLabel;
    edtNome: TEdit;
    edtCodigoCliente: TEdit;
    pnlBotoesVenda: TPanel;
    btnIncluir: TBitBtn;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSair: TBitBtn;
    btnPesquisaCliente: TBitBtn;
    btnLimpar: TBitBtn;
    btnPesquisar: TBitBtn;
    lblValorTotal: TLabel;
    cdsVendaCodigo: TIntegerField;
    cdsVendaDescricao: TStringField;
    cdsVendaUnidade: TStringField;
    cdsVendaQuantidade: TFloatField;
    cdsVendaPrecoUnitario: TFloatField;
    cdsVendaPrecoTotal: TFloatField;
    btnConsultar: TBitBtn;
    edtValor: TEdit;
    stbBarraStatus: TStatusBar;
    pnlProdutos: TPanel;
    grbGrid: TGroupBox;
    dbgVenda: TDBGrid;
    chkFaturada: TCheckBox;
    btnCancelarVenda: TBitBtn;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnPesquisaClienteClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure dbgVendaKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodigoClienteKeyPress(Sender: TObject; var Key: Char);
    procedure dbgVendaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtCodigoVendaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtCodigoVendaKeyPress(Sender: TObject; var Key: Char);
    procedure dbgVendaExit(Sender: TObject);
    procedure btnCancelarVendaClick(Sender: TObject);

  private
    { Private declarations }
    vKey : Word;

    vEstadoTela      :TEstadoTela;
    vObjCliente      :TCliente;
    vObjVenda        :TVenda;
    vObjColVendaItem :TColVendaItem;
    vObjProduto      :TProduto;

    procedure CamposEnabled(pOpcao : Boolean);
    procedure DefineEstadoTela;
    procedure LimparTela;
    procedure CarregaDadosTela;
    procedure CarregaDadosProduto;
    procedure CarregaDadosConsulta;

    function ProcessaConsultaCliente    : Boolean;
    function ProcessaConfirmacao        : Boolean;
    function ProcessaInclusao           : Boolean;
    function ProcessaConsultaProduto    : Boolean;
    function ProcessaPesquisaProduto    : Boolean;
    function ProcessaTotalValor         : Boolean;
    function ProcessaConsulta           : Boolean;
    function ProcessaAlteracao          : Boolean;

    function ProcessaVendaItem  : Boolean;
    function ProcessaVendaDados : Boolean;
    function ProcessaVenda      : Boolean;

  public
    { Public declarations }
  end;

var
  frmVendas: TfrmVendas;

implementation

uses uMessageUtil, UClientesPesqView, UProdutosPesqView, UVendasPesqView;

{$R *.dfm}


procedure TfrmVendas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

begin
   vKey := Key;

   case vKey of
      VK_RETURN: // Corresponde ao Enter
      begin
         // Comando responsavel para passar para o proximo campo
         Perform(WM_NEXTDLGCTL, 0,0);
      end;

      VK_ESCAPE: // Corresponde ao ESC
      begin
         if (vEstadoTela <> etPadrao) then
         begin
            if (TMessageUtil.Pergunta('Deseja encerrar a opera??o?')) then
            begin
               vEstadoTela := etPadrao;
               DefineEstadoTela;
            end;
         end
         else
         begin
           if (TMessageUtil.Pergunta('Deseja sair da rotina?')) then
               Close; // Fechar formulario
         end;
      end;

   end;
end;

procedure TfrmVendas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caFree;
   frmVendas := nil;
end;

procedure TfrmVendas.FormCreate(Sender: TObject);
begin
  vEstadoTela := etPadrao;
end;

procedure TfrmVendas.FormShow(Sender: TObject);
begin
   DefineEstadoTela;
end;

procedure TfrmVendas.DefineEstadoTela;
begin
   btnIncluir.Enabled        := (vEstadoTela in [etPadrao]);
   btnConsultar.Enabled      := (vEstadoTela in [etPadrao]);
   btnPesquisar.Enabled      := (vEstadoTela in [etPadrao]);
   btnLimpar.Enabled         := False;
   btnSair.Enabled           := (vEstadoTela in [etPadrao]);
   btnCancelarVenda.Enabled  := False;

   btnPesquisaCliente.Enabled  :=
      vEstadoTela in [etIncluir, etPesquisarCliente, etPesquisarProduto];

   btnConfirmar.Enabled :=
      vEstadoTela in [etIncluir, etConsultar, etPesquisar,
      etPesquisarCliente, etPesquisarProduto, etConsultarVenda];

   btnCancelar.Enabled :=
      vEstadoTela in [etIncluir, etConsultar, etPesquisar,
      etPesquisarCliente, etPesquisarProduto, etConsultarVenda];


   case vEstadoTela of
      etPadrao:
      begin
         stbBarraStatus.Panels[0].Text := ' ';
         CamposEnabled(False);
         LimparTela;


         if (frmVendas <>nil)   and
            (frmVendas.Active)  and
            (btnIncluir.CanFocus) then
             btnIncluir.SetFocus;

         Application.ProcessMessages;
      end;

      etConsultar:
      begin
         stbBarraStatus.Panels[0].Text := 'Consultar';
         CamposEnabled(False);

         if (edtCodigoCliente.Text <> EmptyStr) then
         begin
            edtCodigoCliente.Enabled    := False;
            btnConfirmar.Enabled := False;

         end
         else
         begin
            lblCodigo.Enabled := True;
            edtCodigoCliente.Enabled := True;

            if (edtCodigoCliente.CanFocus) then
                edtCodigoCliente.SetFocus;

         end;
      end;

       etIncluir:
      begin
         stbBarraStatus.Panels[0].Text := 'Incluir';
         CamposEnabled(True);

         btnPesquisar.Enabled   := False;
         btnConsultar.Enabled   := False;
         btnLimpar.Enabled      := True;
         edtCodigoVenda.Enabled := False;
         chkFaturada.Checked    := True;

         if edtCodigoCliente.CanFocus then
            edtCodigoCliente.SetFocus;

      end;


      etPesquisarCliente:
      begin
         stbBarraStatus.Panels[0].Text := 'Pesquisar';
         if frmClientesPesq = nil then
            frmClientesPesq := TfrmClientesPesq.Create(Application);

         frmClientesPesq.ShowModal;

         if  frmClientesPesq.mClienteID <> 0 then
         begin
            edtCodigoCliente.Text := IntToStr(frmClientesPesq.mClienteID);
            vEstadoTela := etIncluir;
            ProcessaConsultaCliente;
         end;


         frmClientesPesq.mClienteID := 0;
         frmClientesPesq.mClienteNome := EmptyStr;

         if dbgVenda.CanFocus then
            dbgVenda.SetFocus;

         vEstadoTela := etIncluir;

      end;

      etPesquisarProduto:
      begin
         stbBarraStatus.Panels[0].Text := 'Pesquisar';

         if frmProdutosPesq = nil then
            frmProdutosPesq := TfrmProdutosPesq.Create(Application);

         frmProdutosPesq.ShowModal;

         if  frmProdutosPesq.mProdutoID <> 0 then
         begin
            vEstadoTela := etIncluir;
            ProcessaConsultaProduto;
         end
         else
         vEstadoTela := etIncluir;
         DefineEstadoTela;

         frmProdutosPesq.mProdutoID := 0;
         frmProdutosPesq.mProdutoNome := EmptyStr;


      end;

      etConsultarVenda:
      begin
         stbBarraStatus.Panels[0].Text := 'Consultar';
         CamposEnabled(False);

         if (edtCodigoVenda.Text <> EmptyStr) then
         begin
            edtCodigoVenda.Enabled    := False;
            btnConfirmar.Enabled := False;

            if chkFaturada.Checked = True then
               btnCancelarVenda.Enabled := True
            else
               btnCancelarVenda.Enabled := False;
         end
         else
         begin
           lblVenda.Enabled := True;
           edtCodigoVenda.Enabled := True;

            if (edtCodigoVenda.CanFocus) then
                edtCodigoVenda.SetFocus;

         end;
      end;

      etPesquisar:
      begin
         stbBarraStatus.Panels[0].Text := 'Pesquisar';

         if frmVendaPesq = nil then
           frmVendaPesq := TfrmVendaPesq.Create(nil);

         frmVendaPesq.ShowModal;

         if  frmVendaPesq.mClienteID <> 0 then
         begin
            edtCodigoVenda.Text := IntToStr(frmVendaPesq.mClienteID);
            vEstadoTela := etConsultarVenda;
            ProcessaConsulta;
         end
         else
         begin
            vEstadoTela := etPadrao;
            DefineEstadoTela;
         end;

         frmVendaPesq.mClienteID := 0;
         frmVendaPesq.mClienteNome := EmptyStr;

         if edtNome.CanFocus then
            edtNome.SetFocus;
      end;

      etAlterar:
      begin
         stbBarraStatus.Panels[0].Text :='Cancelar Venda';

         if (edtCodigoVenda.Text <> EmptyStr)  then
         begin
            ProcessaAlteracao;
         end
         else
         begin
            vEstadoTela := etConsultarVenda;
            DefineEstadoTela;
         end;

      end;
   end;
end;


procedure TfrmVendas.CamposEnabled(pOpcao: Boolean);
var
   i : Integer; // Variavel auxiliar do comando de repeti??o
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Enabled := pOpcao;

      if (Components[i] is TMaskEdit) then
         (Components[i] as TMaskEdit).Enabled := pOpcao;

      if Components[i] is TDBGrid then
         (Components[i] as TDBGrid).Enabled := pOpcao;

      if (Components[i] is TCheckBox) then
         (Components[i] as TCheckBox).Enabled := pOpcao;
   end;
   cdsVendaCodigo.ReadOnly := False;
   cdsVendaQuantidade.ReadOnly := False;
   edtData.Enabled  := False;
   edtNome.Enabled  := False;
   edtValor.Enabled := False;

end;

procedure TfrmVendas.LimparTela;
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
     //Se o campo for do tipo EDIT
      if (Components[i] is TEdit) then // Limpa o valor que esta no campo
         (Components[i] as TEdit).Text := EmptyStr;

     // Se o campo for do tipo MASKEDIT
      if (Components[i] is TMaskEdit) then // Limpa o valor que esta no campo
         (Components[i] as TMaskEdit).Text := EmptyStr;

      if (Components[i] is TCheckBox) then // Define o campo como FALSO
         (Components[i] as TCheckBox).Checked := False;
   end;
   edtData.Text    := DateToStr(Date());
   edtData.Enabled := False;

   if vObjCliente <> nil then
      FreeAndNil(vObjCliente);

   if vObjVenda <> nil then
         FreeAndNil(vObjVenda);

   if vObjProduto <> nil then
      FreeAndNil(vObjProduto);

   if vObjColVendaItem <> nil then
      FreeAndNil(vObjColVendaItem);

   cdsVenda.EmptyDataSet;

   dbgVenda.SelectedIndex := 0;

   if edtCodigoCliente.CanFocus then
      edtCodigoCliente.SetFocus;

end;


function TfrmVendas.ProcessaConsultaCliente: Boolean;
begin
   try
      Result := False;

      if (edtCodigoCliente.Text = EmptyStr) then
      begin
         TMessageUtil.Alerta('Codigo do cliente n?o preenchido.');

         if edtCodigoCliente.CanFocus then
            edtCodigoCliente.SetFocus;

         Exit;
      end;

      vObjCliente :=
         TCliente(TPessoaController.getInstancia.BuscaPessoa(
            StrToIntDef(edtCodigoCliente.Text, 0)));


      if (vObjCliente <> nil) then
         CarregaDadosTela
      else
      begin
         TMessageUtil.Alerta(
            'Nenhum cliente encontrado para o c?digo informado.');

         edtCodigoCliente.Text := EmptyStr;
         edtNome.Text := EmptyStr;

         if (edtCodigoCliente.CanFocus) then
             edtCodigoCliente.SetFocus;

         Exit;
      end;

      DefineEstadoTela;
      Result:= True;

   except
      on E: Exception do
      begin
         Raise Exception.Create(
         'Falha ao consultar os dados do cliente [View]:'#13+
         e.Message);
      end;
   end;
end;

procedure TfrmVendas.CarregaDadosTela;
var
   i : Integer;
begin
  if (vObjCliente = nil) then
     Exit;

   edtCodigoCliente.Text   := IntToStr (vObjCliente.Id);
   edtNome.Text            := vObjCliente.Nome;

   if (vObjVenda = nil) then
      Exit;

   edtCodigoVenda.Text     := IntToStr (vObjVenda.Id);
   edtCodigoCliente.Text   := IntToStr (vObjVenda.Id_Cliente);
   edtValor.Text           := FloatToStr(vObjVenda.TotalVenda);
   edtData.Text            := DateToStr(vObjVenda.DataVenda);
   chkFaturada.Checked     := vObjVenda.Faturada;


  if vObjColVendaItem <> nil then
  begin
     for i := 0 to (vObjColVendaItem.Count - 1) do
     begin
        edtCodigoVenda.Text          := IntToStr(vObjColVendaItem.Retorna(i).Id_Venda);
        cdsVenda.Append;
        cdsVendaCodigo.Text          := IntToStr(vObjColVendaItem.Retorna(i).Id_Produto);
        cdsVendaQuantidade.Text      := FloatToStr(vObjColVendaItem.Retorna(i).Quantidade);
        cdsVendaUnidade.Text         := vObjColVendaItem.Retorna(i).UnidadeSaida;
        cdsVendaPrecoUnitario.Text   := FloatToStr(vObjColVendaItem.Retorna(i).ValorUnitario);
        cdsVendaPrecoTotal.Text      := FloatToStr(vObjColVendaItem.Retorna(i).TotalItem);
        cdsVenda.Post;
     end;
  end;
end;


procedure TfrmVendas.btnSairClick(Sender: TObject);
begin
   if  TMessageUtil.Pergunta('Deseja sair da rotina?') then
   begin
      vEstadoTela := etPadrao;
      DefineEstadoTela;
      Close;
   end;
end;

procedure TfrmVendas.btnIncluirClick(Sender: TObject);
begin
   vEstadoTela := etIncluir;
   DefineEstadoTela;
   edtData.Text:=DateToStr(Date());
   edtData.Enabled := False;
end;

procedure TfrmVendas.btnCancelarClick(Sender: TObject);
begin
   if (vEstadoTela <> etPadrao) then
   begin
      if  TMessageUtil.Pergunta('Deseja sair da opera??o?') then
      begin
         vEstadoTela := etPadrao;
         DefineEstadoTela;
      end;
   end;

   if edtCodigoCliente.CanFocus then
      edtCodigoCliente.SetFocus;
      
end;

procedure TfrmVendas.btnConfirmarClick(Sender: TObject);
var
   i : Integer;
begin
   if ProcessaConsultaCliente = False then
      Exit;
   for i := 0 to dbgVenda.DataSource.DataSet.RecordCount - 1 do
   begin
      dbgVenda.DataSource.DataSet.RecNo := i + 1;
      if ProcessaPesquisaProduto = False then
      begin
         dbgVenda.SelectedIndex := 0;

         Exit;
      end;
   end;

   ProcessaConfirmacao;
end;

procedure TfrmVendas.btnPesquisaClienteClick(Sender: TObject);
begin
   vEstadoTela := etPesquisarCliente;
   DefineEstadoTela;
end;

function TfrmVendas.ProcessaConfirmacao: Boolean;
begin
   Result := False;

   try
      case vEstadoTela of
         etIncluir: Result         := ProcessaInclusao;
         etConsultar: Result       := ProcessaConsultaCliente;
         etConsultarVenda: Result  := ProcessaConsulta;
      end;

      if not Result then
         Exit;
   except
      on E: Exception do
         TMessageUtil.Alerta(E.Message);
   end;


   Result := True;

end;

function TfrmVendas.ProcessaInclusao: Boolean;
begin
   try
      Result := False;

      if ProcessaVenda then
      begin
         TMessageUtil.Informacao('Venda cadastrada com sucesso.'#13+
         'C?digo da venda cadastrada: '+ IntToStr(vObjVenda.Id));

         vEstadoTela:= etPadrao;
         DefineEstadoTela;

         Result := True;
      end;


   except
      on E: Exception do
      begin
         raise Exception.Create(
         'Falha ao incluir os dados da venda [View]: '#13+
         e.Message);
      end;

   end;
end;

function TfrmVendas.ProcessaVenda: Boolean;
var
   i : Integer;
begin
   try
      Result:= False;

      if (ProcessaVendaDados) and
         (ProcessaVendaItem) then
      begin
         //Grava??o do BD
         for i := 0 to dbgVenda.DataSource.DataSet.RecordCount - 1 do
         begin
            dbgVenda.DataSource.DataSet.RecNo := i + 1;
            TVendaController.getInstancia.GravaVenda(
            vObjVenda,vObjColVendaItem);
         end;

         Result := True;

      end;


   except
      on E: Exception do
      begin
      Raise Exception.Create(
            'Falha ao gravar os dados da Venda [View]'#13+
            e.Message);

      end;
   end;
end;

function TfrmVendas.ProcessaVendaDados: Boolean;
begin
   try
      Result := False;

      if vEstadoTela = etIncluir then
      begin
         if vObjVenda = nil then
            vObjVenda := TVenda.Create;
      end;

      if (vObjVenda) = nil then
         Exit;

      ProcessaTotalValor;

      vObjVenda.Id_Cliente   := StrToInt(edtCodigoCliente.Text);
      vObjVenda.DataVenda    := StrToDate(edtData.Text);
      vObjVenda.TotalVenda   := StrToFloat(edtValor.Text);
      vObjVenda.Faturada     := chkFaturada.Checked;

      Result := True;
   except
      on E: Exception do
      begin
         raise Exception.Create(
         'Falha ao processar os dados do cliente [View]:'#13+
         e.Message);
      end;
   end;
end;

function TfrmVendas.ProcessaVendaItem: Boolean;
   var
   xVendaItem : TVendaItem;
   xID_Venda : Integer;
   i : Integer;
begin
   try

      xVendaItem := nil;
      xID_Venda := 0;


      if vObjColVendaItem <> nil then
         FreeAndNil(vObjColVendaItem);

      cdsVenda.First;
      if cdsVendaCodigo.Value = 0 then
      begin
         TMessageUtil.Alerta('Informe ao menos um produto para a venda.');
         if dbgVenda.CanFocus then
            dbgVenda.SetFocus;

         Exit;
      end;

      vObjColVendaItem := TColVendaItem.Create;

      cdsVenda.Last;
      
      if (cdsVendaCodigo.Value = 0) and (cdsVendaDescricao.Text = EmptyStr) then
          cdsVenda.Delete;

      for i := 0 to dbgVenda.DataSource.DataSet.RecordCount - 1 do
      begin
         dbgVenda.DataSource.DataSet.RecNo := i + 1;

         xVendaItem              := TVendaItem.Create;
         xVendaItem.Id           := xID_Venda;
         xVendaItem.Id_Venda     := vObjVenda.Id;
         if cdsVendaQuantidade.Value <> 0 then
            xVendaItem.Quantidade   := cdsVendaQuantidade.Value
         else
         begin
            cdsVenda.Edit;
            cdsVendaQuantidade.Value := 1;
            cdsVendaPrecoTotal.Value := cdsVendaQuantidade.Value * cdsVendaPrecoUnitario.Value;
            cdsVenda.Post;
            xVendaItem.Quantidade    := cdsVendaQuantidade.Value;
            xVendaItem.TotalItem     := cdsVendaPrecoTotal.Value;

            ProcessaTotalValor;
         end;
         xVendaItem.UnidadeSaida := cdsVendaUnidade.Text;
         xVendaItem.ValorUnitario:= cdsVendaPrecoUnitario.Value;
         xVendaItem.TotalItem    := cdsVendaPrecoTotal.Value;
         if cdsVendaCodigo.value <> 0  then
         begin
            xVendaItem.Id_Produto   := cdsVendaCodigo.Value;
            vObjColVendaItem.Add(xVendaItem);
         end
         else
         begin
            TMessageUtil.Alerta('ID do produto n?o informado');
            Exit;
         end;
      end;

      Result := True;
   except
      on E: Exception do
      begin
         raise Exception.Create(
         'Falha ao preeencher os itens da venda [View]:'#13+
         e.Message);
      end;

   end;
end;

procedure TfrmVendas.btnLimparClick(Sender: TObject);
begin
   if (vEstadoTela <> etPadrao) then
   begin
      if  TMessageUtil.Pergunta('Deseja limpar a tela?') then
      begin
         LimparTela;
      end;
   end;
end;

function TfrmVendas.ProcessaConsultaProduto: Boolean;
begin
   try
      Result := False;

      if (IntToStr(frmProdutosPesq.mProdutoID) = EmptyStr) then
      begin
         TMessageUtil.Alerta('Codigo do produto n?o preenchido.');

         if frmProdutosPesq.edtNome.CanFocus then
            frmProdutosPesq.edtNome.SetFocus;

         Exit;
      end;


      vObjProduto :=
         TProduto(TProdutoController.getInstancia.BuscaProduto(
            frmProdutosPesq.mProdutoID));

      if (frmProdutosPesq.mProdutoID <> 0 ) then
         if cdsVenda.RecordCount = 0 then
         begin
            cdsVenda.Append;
            if cdsVendaUnidade.Text = EmptyStr then
               cdsVendaQuantidade.Value := 1;
            cdsVendaDescricao.Value            := vObjProduto.Nome;
            cdsVendaCodigo.Value               := vObjProduto.Id;
            cdsVendaPrecoUnitario.Value        := vObjProduto.PrecoVenda;
            cdsVendaUnidade.Value              := vObjProduto.UnidadeSaida;
            cdsVendaPrecoTotal.Value           := cdsVendaQuantidade.value *
               cdsVendaPrecoUnitario.Value;
            cdsVenda.Post;
         end
         else
         begin
            cdsVenda.Edit;
            if cdsVendaUnidade.Text = EmptyStr then
               cdsVendaQuantidade.Value := 1;
            cdsVendaDescricao.Value            := vObjProduto.Nome;
            cdsVendaCodigo.Value               := vObjProduto.Id;
            cdsVendaPrecoUnitario.Value        := vObjProduto.PrecoVenda;
            cdsVendaUnidade.Value              := vObjProduto.UnidadeSaida;
            cdsVendaPrecoTotal.Value           := cdsVendaQuantidade.value *
               cdsVendaPrecoUnitario.Value;
            cdsVenda.Post;
         end
      else
      begin
         TMessageUtil.Alerta(
            'Nenhum produto encontrado para o c?digo informado.');

         LimparTela;

         if frmProdutosPesq.edtNome.CanFocus then
            frmProdutosPesq.SetFocus;

         Exit;
      end;

      DefineEstadoTela;
      Result:= True;

      dbgVenda.SelectedIndex := 3;
      if dbgVenda.CanFocus then
         dbgVenda.SetFocus;

   except
      on E: Exception do
      begin
         Raise Exception.Create(
         'Falha ao consultar os dados do produto [View]:'#13+
         e.Message);
      end;
   end;
end;

procedure TfrmVendas.CarregaDadosProduto;
begin
   if vObjProduto = nil then
      Exit;

   cdsVenda.Edit;
   if cdsVendaUnidade.Text = EmptyStr then
      cdsVendaQuantidade.Value           := 1;
   cdsVendaDescricao.Value            := vObjProduto.Nome;
   cdsVendaCodigo.Value               := vObjProduto.Id;
   cdsVendaPrecoUnitario.Value        := vObjProduto.PrecoVenda;
   cdsVendaUnidade.Value              := vObjProduto.UnidadeSaida;
   cdsVendaPrecoTotal.Value           := cdsVendaQuantidade.value * cdsVendaPrecoUnitario.Value;
   cdsVenda.Post;

end;

function TfrmVendas.ProcessaPesquisaProduto: Boolean;
begin
   try
      Result := False;

      vObjProduto :=
         TProduto(TProdutoController.getInstancia.BuscaProduto(
            StrToIntDef(cdsVendaCodigo.text,0)));

      if (vObjProduto <> nil) then
      begin
         CarregaDadosProduto;

         dbgVenda.SelectedIndex := 3;
         if dbgVenda.CanFocus then
            dbgVenda.SetFocus;

      end
      else
      begin
         if (cdsVendaUnidade.Text = EmptyStr) and (cdsVendaDescricao.Text = EmptyStr) then
         begin
            cdsVenda.Delete;
            Result:= True;
            Exit;
         end;

         TMessageUtil.Alerta(
            'Produto n?o encontrado para o codigo informado.');


         Exit;
      end;

      Result:= True;

   except
      on E: Exception do
      begin
         Raise Exception.Create(
         'Falha ao consultar os dados do produto [View]:'#13+
         e.Message);
      end;
   end;
end;


function TfrmVendas.ProcessaTotalValor: Boolean;
var
   xTotal: Double;
   xAux: Integer;
begin
   xTotal := 0;
   for xAux := 0 to dbgVenda.DataSource.DataSet.RecordCount - 1 do
   begin
      dbgVenda.DataSource.DataSet.RecNo := xAux + 1;
      xTotal := xTotal + dbgVenda.DataSource.DataSet.FieldByName('PrecoTotal').AsFloat;
   end;
   edtValor.Text := FloatToStr(xTotal);
   edtValor.Text := FormatFloat('##0.00',xTotal);

   Result := True;
end;


function TfrmVendas.ProcessaConsulta: Boolean;
begin
   try
      Result := False;

      if (edtCodigoVenda.Text = EmptyStr) then
      begin
         TMessageUtil.Alerta('Codigo do produto n?o preenchido.');

         if edtCodigoVenda.CanFocus then
            edtCodigoVenda.SetFocus;

         Exit;
      end;

      vObjVenda :=
         TVenda(TVendaController.getInstancia.BuscaVenda(
            StrToIntDef(edtCodigoVenda.Text, 0)));

      vObjColVendaItem :=
         TVendaController.getInstancia.BuscaVendaItem(
            StrToIntDef(edtCodigoVenda.Text, 0));


      if (vObjVenda <> nil) and (vObjColVendaItem <> nil) then
      begin
         CarregaDadosConsulta;
      end
      else
      begin
         TMessageUtil.Alerta(
            'Nenhum produto encontrado para o c?digo informado.');

         LimparTela;

         if edtCodigoVenda.CanFocus then
            edtCodigoVenda.SetFocus;

         Exit;
      end;

      DefineEstadoTela;

      Result:= True;

   except
      on E: Exception do
      begin
         Raise Exception.Create(
         'Falha ao consultar os dados do produto [View]:'#13+
         e.Message);
      end;
   end;
end;

procedure TfrmVendas.CarregaDadosConsulta;
   var
   i : Integer;
begin

   if (vObjVenda = nil) then
      Exit;

   edtCodigoCliente.Text   := IntToStr (vObjVenda.Id_Cliente);
   edtCodigoVenda.Text     := IntToStr (vObjVenda.Id);
   edtValor.Text           := FloatToStr(vObjVenda.TotalVenda);
   edtData.Text            := DateToStr(vObjVenda.DataVenda);
   chkFaturada.Checked     := vObjVenda.Faturada;

   vObjCliente :=
         TCliente(TPessoaController.getInstancia.BuscaPessoa(
            StrToIntDef(edtCodigoCliente.Text, 0)));
   edtNome.Text := vObjCliente.Nome;

   if vObjColVendaItem <> nil then
   begin
      for i := 0 to (vObjColVendaItem.Count - 1) do
      begin
         cdsVenda.Append;
         cdsVendaCodigo.Text          := IntToStr(vObjColVendaItem.Retorna(i).Id_Produto);
         cdsVendaQuantidade.Text      := FloatToStr(vObjColVendaItem.Retorna(i).Quantidade);
         cdsVendaUnidade.Text         := vObjColVendaItem.Retorna(i).UnidadeSaida;
         cdsVendaPrecoTotal.Text      := FloatToStr(vObjColVendaItem.Retorna(i).TotalItem);
         cdsVendaPrecoUnitario.Value  := vObjColVendaItem.Retorna(i).ValorUnitario;

         vObjProduto :=
            TProduto(TProdutoController.getInstancia.BuscaProduto(
              StrToIntDef(cdsVendaCodigo.text,0)));

         if (vObjProduto <> nil) then
         begin
            cdsVenda.Edit;
            cdsVendaDescricao.Text := vObjProduto.Nome;
            cdsVenda.Post;
         end;
      end;
   end;

   edtValor.Text := FormatFloat('##0.00',vObjVenda.TotalVenda);
end;


procedure TfrmVendas.btnConsultarClick(Sender: TObject);
begin
   vEstadoTela := etConsultarVenda;
   DefineEstadoTela;
end;

procedure TfrmVendas.btnPesquisarClick(Sender: TObject);
begin
   vEstadoTela := etPesquisar;
   DefineEstadoTela;
end;

procedure TfrmVendas.dbgVendaKeyPress(Sender: TObject; var Key: Char);
begin
   if (vKey = VK_RETURN) and (dbgVenda.SelectedIndex = 0) then
   begin
      if cdsVendaCodigo.Value = 0 then
      begin
         vEstadoTela := etPesquisarProduto;
         DefineEstadoTela;
         if dbgVenda.CanFocus then
            dbgVenda.SetFocus;
      end
      else
         if IntToStr(cdsVendaCodigo.Value) = EmptyStr then
         begin
            TMessageUtil.Alerta('O Codigo n?o esta preenchido');

            if dbgVenda.CanFocus then
               dbgVenda.SetFocus;

            Exit;
         end
         else
         begin
            ProcessaPesquisaProduto;
            if dbgVenda.CanFocus then
               dbgVenda.SetFocus;
         end;
   end
   else if (vKey = VK_RETURN) and (dbgVenda.SelectedIndex = 3) then
   begin
      if cdsVendaQuantidade.Value = 0 then
      begin
         TMessageUtil.Alerta('Informe um valor para a quantidade.');
         if dbgVenda.CanFocus then
            dbgVenda.SetFocus;
         Exit;
      end;
      cdsVenda.Edit;
      cdsVendaPrecoTotal.Value := cdsVendaQuantidade.Value * cdsVendaPrecoUnitario.Value;
      cdsVenda.Post;

      ProcessaTotalValor;

      cdsVenda.Last;

      if cdsVendaCodigo.Value <> 0 then
      begin
         cdsVenda.Append;
         cdsVenda.Post;
      end;

      dbgVenda.SelectedIndex := 0;
      if dbgVenda.CanFocus then
         dbgVenda.SetFocus;
   end;


   vKey := VK_CLEAR;
end;

procedure TfrmVendas.edtCodigoClienteKeyPress(Sender: TObject;
  var Key: Char);
begin
   if vKey = VK_RETURN then
      if edtCodigoCliente.Text = EmptyStr then
      begin
         vEstadoTela := etPesquisarCliente;
         DefineEstadoTela;
      end
      else
      begin
         ProcessaConsultaCliente;
         if edtNome.Text <> EmptyStr then
         begin
            dbgVenda.SelectedIndex := 0;
            if dbgVenda.CanFocus then
               dbgVenda.SetFocus;
         end;
      end;


   if ((Key in ['0'..'9'] = False) and (Word(Key) <> VK_BACK)) then
   Key := #0;

   vKey := VK_CLEAR;
end;


procedure TfrmVendas.dbgVendaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
   xAux : Integer;
begin
   xAux := dbgVenda.DataSource.DataSet.RecNo + 1;
   if (vKey = VK_DOWN) and
      (xAux = dbgVenda.DataSource.DataSet.RecordCount) or (vKey = VK_DOWN) and
        (dbgVenda.DataSource.DataSet.RecNo = dbgVenda.DataSource.DataSet.RecordCount) then
   begin
      if (cdsVendaDescricao.Value = EmptyStr) then
      begin
         vKey := VK_CLEAR;
         cdsVenda.Edit;
         cdsVenda.Delete;
      end;

   end;

   if vKey = VK_DELETE then
   begin
      if cdsVenda.RecordCount > 0 then
      begin
         cdsVenda.Delete;
      end;
      ProcessaTotalValor;
   end;


end;

procedure TfrmVendas.edtCodigoVendaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if vKey = VK_RETURN then
      ProcessaConsulta;

   vKey := VK_CLEAR;
end;


procedure TfrmVendas.edtCodigoVendaKeyPress(Sender: TObject;
  var Key: Char);
begin
   if ((Key in ['0'..'9'] = False) and (Word(Key) <> VK_BACK)) then
   Key := #0;
end;

procedure TfrmVendas.dbgVendaExit(Sender: TObject);
begin
   cdsVenda.Edit;
   cdsVendaPrecoTotal.Value := cdsVendaQuantidade.Value * cdsVendaPrecoUnitario.Value;
   cdsVenda.Post;
end;

function TfrmVendas.ProcessaAlteracao: Boolean;
begin
   try
      Result := False;

      if TMessageUtil.Pergunta('Quer realmente cancelar esta venda?')then
      begin
         chkFaturada.Checked := False;
         if ProcessaVenda then
         begin
            TMessageUtil.Informacao('Dados foram alterados com sucesso!');

            vEstadoTela := etPadrao;
            DefineEstadoTela;
            Result := True;
         end;
      end
      else
      begin
         vEstadoTela := etConsultarVenda;
         DefineEstadoTela;
      end;


   except
       on E: Exception do
       begin
          raise Exception.Create (
            'Falha ao cancelar venda: [View]'#13+
            e.Message);
       end;

   end;
end;

procedure TfrmVendas.btnCancelarVendaClick(Sender: TObject);
begin
   vEstadoTela := etAlterar;
   DefineEstadoTela;
end;

end.
