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
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSair: TBitBtn;
    edtValor: TEdit;
    btnPesquisaCliente: TBitBtn;
    btnLimpar: TBitBtn;
    btnPesquisar: TBitBtn;
    pnlProdutos: TPanel;
    grbGrid: TGroupBox;
    lblValorTotal: TLabel;
    dbgVenda: TDBGrid;
    stbBarraStatus: TStatusBar;
    cdsVendaCodigo: TIntegerField;
    cdsVendaDescricao: TStringField;
    cdsVendaUnidade: TStringField;
    cdsVendaQuantidade: TFloatField;
    cdsVendaPrecoUnitario: TFloatField;
    cdsVendaPrecoTotal: TFloatField;
    btnConsultar: TBitBtn;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtCodigoClienteExit(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnPesquisaClienteClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure dbgVendaExit(Sender: TObject);
    procedure edtCodigoVendaExit(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);



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
    function ProcessaAlteracao          : Boolean;
    function ProcessaExclusao           : Boolean;
    function ProcessaConsultaProduto    : Boolean;
    function ProcessaPesquisaProduto    : Boolean;
    function ProcessaTotalValor         : Boolean;
    function ProcessaConsulta           : Boolean;

    function ProcessaVendaItem  : Boolean;
    function ProcessaVendaDados : Boolean;
    function ProcessaVenda      : Boolean;

  public
    { Public declarations }
  end;

var
  frmVendas: TfrmVendas;

implementation

uses uMessageUtil, UClientesPesqView, UProdutosPesqView;

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
            if (TMessageUtil.Pergunta('Deseja encerrar a opera��o?')) then
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
   btnIncluir.Enabled           := (vEstadoTela in [etPadrao]);
   btnAlterar.Enabled           := (vEstadoTela in [etPadrao]);
   btnExcluir.Enabled           := (vEstadoTela in [etPadrao]);

   btnPesquisaCliente.Enabled  :=
      vEstadoTela in [etIncluir, etAlterar,etPesquisarCliente,etPesquisarProduto,
      etIncluirDados];

   btnConfirmar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar, etPesquisar,
      etPesquisarCliente, etPesquisarProduto, etConsultarVenda];

   btnCancelar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar, etPesquisar,
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
           btnAlterar.Enabled   := True;
           btnExcluir.Enabled   := True;
           btnConfirmar.Enabled := False;

           if (btnAlterar.CanFocus)then
               btnAlterar.SetFocus;

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

         if edtCodigoCliente.CanFocus then
            edtCodigoCliente.SetFocus;

      end;

       etIncluirDados:
      begin
        stbBarraStatus.Panels[0].Text := 'Incluir';
        CamposEnabled(True);
        edtData.Enabled := False;
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

         if edtNome.CanFocus then
            edtNome.SetFocus;


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
         end;


         frmProdutosPesq.mProdutoID := 0;
         frmProdutosPesq.mProdutoNome := EmptyStr;


      end;

      etAlterar:
      begin
         stbBarraStatus.Panels[0].Text :='Alterando';

         if (edtCodigoVenda.Text <> EmptyStr)then
         begin
            CamposEnabled(True);

            edtCodigoVenda.Enabled    := False;
            btnAlterar.Enabled   := False;
            btnConfirmar.Enabled := True;
         end
         else
         begin
            lblVenda.Enabled := True;
            edtCodigoVenda.Enabled := True;

            if edtCodigoVenda.CanFocus then
               edtCodigoVenda.SetFocus;
         end;
      end;

       etExcluir:
      begin
         stbBarraStatus.Panels[0].Text  := 'Excluindo';

         if edtCodigoVenda.Text <> EmptyStr then
            ProcessaExclusao;
            begin
               lblVenda.Enabled := True;
               edtCodigoVenda.Enabled := True;

               if edtCodigoVenda.CanFocus then
                  edtCodigoVenda.SetFocus;
            end;
      end;

      etConsultarVenda:
      begin
        stbBarraStatus.Panels[0].Text := 'Consulta';

        CamposEnabled(False);

        if (edtCodigoVenda.Text <> EmptyStr) then
        begin
           edtCodigoVenda.Enabled    := False;
           btnAlterar.Enabled   := True;
           btnExcluir.Enabled   := True;
           btnConfirmar.Enabled := False;

           if (btnAlterar.CanFocus)then
               btnAlterar.SetFocus;

        end
        else
        begin
          lblVenda.Enabled := True;
          edtCodigoVenda.Enabled := True;

           if (edtCodigoVenda.CanFocus) then
               edtCodigoVenda.SetFocus;

        end;
      end;
   end;
end;


procedure TfrmVendas.CamposEnabled(pOpcao: Boolean);
var
   i : Integer; // Variavel auxiliar do comando de repeti��o
   begin
      for i := 0 to pred(ComponentCount) do
      begin
         if (Components[i] is TEdit) then
            (Components[i] as TEdit).Enabled := pOpcao;

         if (Components[i] is TMaskEdit) then
            (Components[i] as TMaskEdit).Enabled := pOpcao;

         if Components[i] is TDBGrid then
            (Components[i] as TDBGrid).Enabled := pOpcao;

      end;

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
   end;
   edtData.Text:=DateToStr(Date());
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
end;

procedure TfrmVendas.edtCodigoClienteExit(Sender: TObject);
begin
   if vKey = VK_RETURN then
      if vEstadoTela = etAlterar then
      begin
         if edtCodigoCliente.Text <> EmptyStr then
            vObjCliente :=
               TCliente(TPessoaController.getInstancia.BuscaPessoa(
                  StrToIntDef(edtCodigoCliente.Text, 0)));

            if (vObjCliente <> nil) then
            begin
               edtCodigoCliente.Text   := IntToStr (vObjCliente.Id);
               edtNome.Text            := vObjCliente.Nome;
            end;

               cdsVenda.Append;
               cdsVenda.Post;
      end
      else
         if edtCodigoCliente.Text = EmptyStr then
         begin
            vEstadoTela := etPesquisarCliente;
            DefineEstadoTela;
         end
         else
            ProcessaConsultaCliente;

   if dbgVenda.CanFocus then
      dbgVenda.SetFocus;

   vKey := VK_CLEAR;
end;

function TfrmVendas.ProcessaConsultaCliente: Boolean;
begin
   try
      Result := False;

      if (edtCodigoCliente.Text = EmptyStr) then
      begin
         TMessageUtil.Alerta('Codigo do cliente n�o preenchido.');

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
            'Nenhum cliente encotrado para o c�digo informado.');

         LimparTela;

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
   if (vEstadoTela <> etPadrao) then
   begin
      if  TMessageUtil.Pergunta('Deseja sair da opera��o?') then
      begin
         vEstadoTela := etPadrao;
         DefineEstadoTela;
      end
   end
   else
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
   vEstadoTela := etPadrao;
   DefineEstadoTela;
end;

procedure TfrmVendas.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmVendas.btnExcluirClick(Sender: TObject);
begin
   vEstadoTela := etExcluir;
   DefineEstadoTela;
end;

procedure TfrmVendas.btnAlterarClick(Sender: TObject);
begin
   vEstadoTela := etAlterar;
   DefineEstadoTela;
end;

procedure TfrmVendas.btnPesquisaClienteClick(Sender: TObject);
begin
   vEstadoTela := etPesquisarCliente;
   DefineEstadoTela;
end;

function TfrmVendas.ProcessaConfirmacao: Boolean;
begin
   begin
      Result := False;

   try
      case vEstadoTela of
         etIncluir: Result         := ProcessaInclusao;
         etConsultar: Result       := ProcessaConsultaCliente;
         etAlterar: Result         := ProcessaAlteracao;
         etExcluir: Result         := ProcessaExclusao;
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
end;

function TfrmVendas.ProcessaInclusao: Boolean;
begin
   try
      Result := False;

      if ProcessaVenda then
      begin
         TMessageUtil.Informacao('Cliente cadastrado com sucesso.'#13+
         'C�digo cadastrado: '+ IntToStr(vObjVenda.Id));

         vEstadoTela:= etPadrao;
         DefineEstadoTela;

         Result := True;
      end;


   except
      on E: Exception do
      begin
         raise Exception.Create(
         'Falha ao incluir os dados do cliente [View]: '#13+
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
         //Grava��o do BD
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
      end
      else
      if vEstadoTela =etAlterar then
      begin
         if vObjVenda = nil then
            Exit;
      end;

         if (vObjVenda) = nil then
            Exit;

      vObjVenda.Id_Cliente   := StrToInt(edtCodigoCliente.Text);
      vObjVenda.DataVenda    := StrToDate(edtData.Text);
      vObjVenda.TotalVenda   := StrToFloat(edtValor.Text);

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

         vObjColVendaItem := TColVendaItem.Create;

         if vEstadoTela = etAlterar then
           xID_Venda  := StrToIntDef(cdsVendaCodigo.Text, 0);

         for i := 0 to dbgVenda.DataSource.DataSet.RecordCount - 1 do
         begin
             dbgVenda.DataSource.DataSet.RecNo := i + 1;

            xVendaItem              := TVendaItem.Create;
            xVendaItem.Id           := xID_Venda;
            xVendaItem.Id_Venda     := vObjVenda.Id;
            if cdsVendaCodigo.Value <> 0 then
               xVendaItem.Id_Produto   := cdsVendaCodigo.Value
            else
               Break;
            xVendaItem.Quantidade   := cdsVendaQuantidade.Value;
            xVendaItem.UnidadeSaida := cdsVendaUnidade.Text;
            xVendaItem.TotalItem    := cdsVendaPrecoTotal.Value;
            vObjColVendaItem.Add(xVendaItem);

         end;


         Result := True;
      except
         on E: Exception do
         begin
            raise Exception.Create(
            'Falha ao preeencher os dados de ender�o do cliente [View]:'#13+
            e.Message);
         end;

      end;
   end;

function TfrmVendas.ProcessaAlteracao: Boolean;
begin
   try
      Result := False;

      if ProcessaVenda then
      begin
         TMessageUtil.Informacao('Dados foram alterados com sucesso!');

         vEstadoTela := etPadrao;
         DefineEstadoTela;
         Result := True;
      end;

   except
       on E: Exception do
       begin
          raise Exception.Create (
            'Falha ao alterar os dados do cliente [View]'#13+
            e.Message);
       end;

   end;
end;

function TfrmVendas.ProcessaExclusao: Boolean;
begin
   try
      Result:= False;

      if (vObjVenda = nil) or
         (vObjColVendaItem = nil) then
      begin
         TMessageUtil.Alerta (
         'N�o foi possivel carregar os dados cadastrados da venda informada.');

         LimparTela;
         vEstadoTela := etPadrao;
         DefineEstadoTela;
         Exit;
      end;

      try
         if TMessageUtil.Pergunta(
         'Quer realmente excluir os dados da venda?')then

            begin
               Screen.Cursor := crHourGlass;
               TVendaController.getInstancia.ExcluiVenda(vObjVenda);
               TMessageUtil.Informacao('Venda excluida com sucesso!');
            end
         else
            begin
               LimparTela;
               vEstadoTela := etPadrao;
               DefineEstadoTela;
               Exit;
            end;

      finally
         Screen.Cursor := crDefault;
         Application.ProcessMessages;
      end;
      Result:= True;

      LimparTela;
      vEstadoTela:= etPadrao;
      DefineEstadoTela;
   except
       on E: Exception do
       begin
          raise Exception.Create(
          'Falha na exclus�o dos dados da venda [View].'#13+
          e.Message);
       end;
   end;
end;


procedure TfrmVendas.btnLimparClick(Sender: TObject);
begin
   LimparTela;
end;

function TfrmVendas.ProcessaConsultaProduto: Boolean;
begin
   try
      Result := False;

      if (IntToStr(frmProdutosPesq.mProdutoID) = EmptyStr) then
      begin
         TMessageUtil.Alerta('Codigo do produto n�o preenchido.');

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
            cdsVendaDescricao.Value            := vObjProduto.Nome;
            cdsVendaCodigo.Value               := vObjProduto.Id;
            cdsVendaPrecoUnitario.Value        := vObjProduto.PrecoVenda;
            cdsVendaUnidade.Value              := vObjProduto.UnidadeSaida;
            cdsVenda.Post;
         end
         else
         begin
            cdsVenda.Edit;
            cdsVendaDescricao.Value            := vObjProduto.Nome;
            cdsVendaCodigo.Value               := vObjProduto.Id;
            cdsVendaPrecoUnitario.Value        := vObjProduto.PrecoVenda;
            cdsVendaUnidade.Value              := vObjProduto.UnidadeSaida;
            cdsVenda.Post;
         end
      else
      begin
         TMessageUtil.Alerta(
            'Nenhum produto encotrado para o c�digo informado.');

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
   cdsVendaDescricao.Value            := vObjProduto.Nome;
   cdsVendaCodigo.Value               := vObjProduto.Id;
   cdsVendaPrecoUnitario.Value        := vObjProduto.PrecoVenda;
   cdsVendaUnidade.Value              := vObjProduto.UnidadeSaida;
   cdsVenda.Post;

end;

procedure TfrmVendas.dbgVendaExit(Sender: TObject);
begin
   if (vKey = VK_RETURN) and(dbgVenda.SelectedIndex = 0) or
      (dbgVenda.SelectedIndex = 1) or (dbgVenda.SelectedIndex = 2) or
      (dbgVenda.SelectedIndex = 4)then
   begin
      if cdsVendaCodigo.Value = 0 then
      begin
         vEstadoTela := etPesquisarProduto;
         DefineEstadoTela;
      end
      else
         ProcessaPesquisaProduto;

   end
   else if (vKey = VK_RETURN) and (dbgVenda.SelectedIndex = 3) then
   begin
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
         TMessageUtil.Alerta(
            'Nenhum produto encotrado para o c�digo informado.');

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

   Result := True;
end;

procedure TfrmVendas.edtCodigoVendaExit(Sender: TObject);
begin
   if vKey = VK_RETURN then
      ProcessaConsulta;

   vKey := VK_CLEAR;
end;

function TfrmVendas.ProcessaConsulta: Boolean;
begin
   try
      Result := False;

      if (edtCodigoVenda.Text = EmptyStr) then
      begin
         TMessageUtil.Alerta('Codigo do produto n�o preenchido.');

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
            'Nenhum produto encotrado para o c�digo informado.');

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

   vObjCliente :=
         TCliente(TPessoaController.getInstancia.BuscaPessoa(
            StrToIntDef(edtCodigoCliente.Text, 0)));
   edtNome.text := vObjCliente.Nome;


   if vObjColVendaItem <> nil then
   begin
      for i := 0 to (vObjColVendaItem.Count - 1) do
      begin
         cdsVenda.Append;
         cdsVendaCodigo.Text          := IntToStr(vObjColVendaItem.Retorna(i).Id_Produto);
         cdsVendaQuantidade.Text      := FloatToStr(vObjColVendaItem.Retorna(i).Quantidade);
         cdsVendaUnidade.Text         := vObjColVendaItem.Retorna(i).UnidadeSaida;
         cdsVendaPrecoUnitario.Text   := FloatToStr(vObjColVendaItem.Retorna(i).ValorUnitario);
         cdsVendaPrecoTotal.Text      := FloatToStr(vObjColVendaItem.Retorna(i).TotalItem);



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
end;


procedure TfrmVendas.btnConsultarClick(Sender: TObject);
begin
   vEstadoTela := etConsultarVenda;
   DefineEstadoTela;
end;

end.