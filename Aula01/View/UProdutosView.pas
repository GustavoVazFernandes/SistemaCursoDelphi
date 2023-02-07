unit UProdutosView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, Mask, UProdutos, UProdutosDAO,
  UProdutosController, UEnumerationUtil, UUnidadeProdutos, UUnidadeProdutosDAO,
  UUnidadeProdutosController, DBCtrls;

type
  TfrmProdutos = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlArea: TPanel;
    lblCodigo: TLabel;
    lblNome: TLabel;
    edtCodigo: TEdit;
    edtNome: TEdit;
    pnlBotoes: TPanel;
    btnIncluir: TBitBtn;
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    btnConsultar: TBitBtn;
    btnPesquisar: TBitBtn;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSair: TBitBtn;
    lblPreco: TLabel;
    lblCodigoUnidade: TLabel;
    edtPreco: TMaskEdit;
    edtCodigoUnidade: TEdit;
    lblTipoUnidade: TLabel;
    edtTipoUnidade: TEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure edtCodigoExit(Sender: TObject);
    procedure edtCodigoUnidadeExit(Sender: TObject);
  private
    { Private declarations }
    vKey : Word;

    vEstadoTela         :TEstadoTela;
    vObjProduto         :TProduto;
    vObjUnidadeProdutos :TUnidadeProdutos;

    procedure CamposEnabled(pOpcao : Boolean);
    procedure LimparTela;
    procedure DefineEstadoTela;
    procedure CarregaDadosTela;
    procedure CarregaDadosUnidade;


    function ProcessaConfirmacao     :Boolean;
    function ProcessaInclusao        :Boolean;
    function ProcessaConsulta        :Boolean;
    function ProcessaProdutos        :Boolean;
    function ProcessaAlteracao       :Boolean;
    function ProcessaExclusao        :Boolean;
    function ProcessaConsultaUnidade :Boolean;

    function ProcessaDadosProdutos   : Boolean;
    function ValidaProdutos          : Boolean;

  public
    { Public declarations }
  end;

var
  frmProdutos: TfrmProdutos;

implementation

uses
   uMessageUtil, UProdutosPesqView;

{$R *.dfm}


procedure TfrmProdutos.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmProdutos.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
   frmProdutos := nil;
end;

procedure TfrmProdutos.FormCreate(Sender: TObject);
begin
   vEstadoTela := etPadrao;
end;

procedure TfrmProdutos.FormShow(Sender: TObject);
begin
   DefineEstadoTela;
end;

procedure TfrmProdutos.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := VK_CLEAR;
end;

procedure TfrmProdutos.CamposEnabled(pOpcao: Boolean);
var
   i : Integer; // Variavel auxiliar do comando de repeti��o
   begin
      for i := 0 to pred(ComponentCount) do
      begin
         if (Components[i] is TEdit) then
            (Components[i] as TEdit).Enabled := pOpcao;

         if (Components[i] is TMaskEdit) then
            (Components[i] as TMaskEdit).Enabled := pOpcao;

      end;

   end;


procedure TfrmProdutos.CarregaDadosTela;
begin
   if (vObjProduto = nil) then
      Exit;

   edtCodigo.Text          := IntToStr (vObjProduto.Id);
   edtNome.Text            := vObjProduto.Nome;
   edtPreco.Text           := FloatToStr(vObjProduto.PrecoVenda);
   edtTipoUnidade.Text     := vObjProduto.UnidadeSaida;

   edtPreco.Text := FormatFloat('##0.00',vObjProduto.PrecoVenda);
   

end;


procedure TfrmProdutos.DefineEstadoTela;
begin
   btnIncluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnAlterar.Enabled   := (vEstadoTela in [etPadrao]);
   btnExcluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnConsultar.Enabled := (vEstadoTela in [etPadrao]);
   btnPesquisar.Enabled := (vEstadoTela in [etPadrao]);

   btnConfirmar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar, etPesquisar];

   btnCancelar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar, etPesquisar];

   case vEstadoTela of
      etPadrao:
      begin
         CamposEnabled(False);
         LimparTela;

         stbBarraStatus.Panels[0].Text := EmptyStr;
         stbBarraStatus.Panels[1].Text := EmptyStr;

           if (frmProdutos <>nil)   and
              (frmProdutos.Active)  and
              (btnIncluir.CanFocus) then
               btnIncluir.SetFocus;

           Application.ProcessMessages;
      end;

      etIncluir:
      begin
         stbBarraStatus.Panels[0].Text :='Inclus�o';
         CamposEnabled(True);

         edtCodigo.Enabled := False;

         if edtNome.CanFocus then
            edtNome.SetFocus;

      end;

      etAlterar:
      begin
         stbBarraStatus.Panels[0].Text :='Alterando';

         if (edtCodigo.Text <> EmptyStr)then
         begin
            CamposEnabled(True);

            edtCodigo.Enabled    := False;
            btnAlterar.Enabled   := False;
            btnConfirmar.Enabled := True;
         end
         else
         begin
            lblCodigo.Enabled := True;
            edtCodigo.Enabled := True;

            if edtCodigo.CanFocus then
               edtCodigo.SetFocus;
         end;
      end;

      etExcluir:
      begin
         stbBarraStatus.Panels[0].Text  := 'Excluindo';

         if edtCodigo.Text <> EmptyStr then
            ProcessaExclusao;
            begin
               lblCodigo.Enabled := True;
               edtCodigo.Enabled := True;

               if edtCodigo.CanFocus then
                  edtCodigo.SetFocus;
            end;
      end;

      etConsultar:
      begin
        stbBarraStatus.Panels[0].Text := 'Consulta';

        CamposEnabled(False);

        if (edtCodigo.Text <> EmptyStr) then
        begin
           edtCodigo.Enabled    := False;
           btnAlterar.Enabled   := True;
           btnExcluir.Enabled   := True;
           btnConfirmar.Enabled := False;

           if (btnAlterar.CanFocus)then
               btnAlterar.SetFocus;

        end
        else
        begin
          lblCodigo.Enabled := True;
          edtCodigo.Enabled := True;

           if (edtCodigo.CanFocus) then
               edtCodigo.SetFocus;

        end;
      end;

      
      etPesquisar:
      begin
         stbBarraStatus.Panels[0].Text := 'Pesquisar';

         if frmProdutosPesq = nil then
           frmProdutosPesq := TfrmProdutosPesq.Create(Application);

         frmProdutosPesq.ShowModal;

         if  frmProdutosPesq.mProdutoID <> 0 then
         begin
            edtCodigo.Text := IntToStr(frmProdutosPesq.mProdutoID);
            vEstadoTela := etConsultar;
            ProcessaConsulta;
         end
         else
         begin
            vEstadoTela := etPadrao;
            DefineEstadoTela;
         end;

         frmProdutosPesq.mProdutoID := 0;
         frmProdutosPesq.mProdutoNome := EmptyStr;

         if edtNome.CanFocus then
            edtNome.SetFocus;
      end;
   end;
end;
procedure TfrmProdutos.LimparTela;
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

   if vObjProduto <> nil then
      FreeAndNil(vObjProduto);
end;

function TfrmProdutos.ProcessaAlteracao: Boolean;
begin
   try
      Result := False;

      if ProcessaProdutos then
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
            'Falha ao alterar os dados do produto [View]'#13+
            e.Message);
       end;

   end;
end;

function TfrmProdutos.ProcessaConfirmacao: Boolean;
begin
   Result := False;

   try
      case vEstadoTela of
         etIncluir: Result := ProcessaInclusao;
         etConsultar: Result := ProcessaConsulta;
         etAlterar: Result := ProcessaAlteracao;
         etExcluir: Result := ProcessaExclusao;
      end;

      if not Result then
         Exit;
   except
      on E: Exception do
         TMessageUtil.Alerta(E.Message);
   end;


   Result := True;
end;

function TfrmProdutos.ProcessaConsulta: Boolean;
begin
   try
      Result := False;

      if (edtCodigo.Text = EmptyStr) then
      begin
         TMessageUtil.Alerta('Codigo do produto n�o preenchido.');

         if edtCodigo.CanFocus then
            edtCodigo.SetFocus;

         Exit;
      end;

      vObjProduto :=
         TProduto(TProdutoController.getInstancia.BuscaProduto(
            StrToIntDef(edtCodigo.Text, 0)));



      if (vObjProduto <> nil) then
         begin
            CarregaDadosTela;
            CarregaDadosUnidade;
         end
      else
      begin
         TMessageUtil.Alerta(
            'Nenhum produto encotrado para o c�digo informado.');

         LimparTela;

         if (edtCodigo.CanFocus) then
            edtCodigo.SetFocus;

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

function TfrmProdutos.ProcessaDadosProdutos: Boolean;
begin
   try
      Result := False;

      if not ValidaProdutos then
         Exit;


      if vEstadoTela =etIncluir then
      begin
         if vObjProduto = nil then
            vObjProduto := TProduto.Create;
      end
      else
      if vEstadoTela =etAlterar then
      begin
         if vObjProduto = nil then
            Exit;
      end;

         if (vObjProduto) = nil then
            Exit;

      vObjProduto.Nome                := edtNome.Text;
      vObjProduto.PrecoVenda          := StrToFloat(edtPreco.Text);
      vObjProduto.UnidadeSaida        := edtTipoUnidade.Text;


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

function TfrmProdutos.ProcessaExclusao: Boolean;
begin
   try
      Result:= False;

      if (vObjProduto = nil) then
      begin
         TMessageUtil.Alerta (
         'N�o foi possivel carregar os dados cadastrados do produto informado.');

         LimparTela;
         vEstadoTela := etPadrao;
         DefineEstadoTela;
         Exit;
      end;

      try
         if TMessageUtil.Pergunta(
         'Quer realmente excluir os dados do produto?')then

            begin
               Screen.Cursor := crHourGlass;
               TProdutoController.getInstancia.ExcluiProduto(vObjProduto);
               TMessageUtil.Informacao('Cliente excluido com sucesso!');
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
          'Falha na exclus�o dos dados do cliente [View].'#13+
          e.Message);
       end;

   end;

end;

function TfrmProdutos.ProcessaInclusao: Boolean;
begin
   try
      Result := False;

      if ProcessaProdutos then
      begin
         TMessageUtil.Informacao('Produto cadastrado com sucesso.'#13+
         'C�digo cadastrado: '+ IntToStr(vObjProduto.Id));

         vEstadoTela:= etPadrao;
         DefineEstadoTela;

         Result := True;
      end;


   except
      on E: Exception do
      begin
         raise Exception.Create(
         'Falha ao incluir os dados do produto [View]: '#13+
         e.Message);
      end;

   end;
end;

function TfrmProdutos.ProcessaProdutos: Boolean;
begin
   try
      Result:= False;
      if (ProcessaDadosProdutos) then
      begin
         //Grava��o do BD
         TProdutoController.getInstancia.GravaProduto(vObjProduto);


         Result := True;


      end;


   except
      on E: Exception do
      begin
      Raise Exception.Create(
            'Falha ao gravar os dados do produto [View]'#13+
            e.Message);

      end;
    end;
end;

procedure TfrmProdutos.btnIncluirClick(Sender: TObject);
begin
   vEstadoTela := etIncluir;
   DefineEstadoTela;
end;

procedure TfrmProdutos.btnAlterarClick(Sender: TObject);
begin
   vEstadoTela := etAlterar;
   DefineEstadoTela;
end;

procedure TfrmProdutos.btnExcluirClick(Sender: TObject);
begin
   vEstadoTela := etExcluir;
   DefineEstadoTela;
end;

procedure TfrmProdutos.btnConsultarClick(Sender: TObject);
begin
   vEstadoTela := etConsultar;
   DefineEstadoTela;
end;

procedure TfrmProdutos.btnPesquisarClick(Sender: TObject);
begin
   vEstadoTela := etPesquisar;
   DefineEstadoTela;
end;

procedure TfrmProdutos.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmProdutos.btnCancelarClick(Sender: TObject);
begin
   vEstadoTela := etPadrao;
   DefineEstadoTela;
end;

procedure TfrmProdutos.btnSairClick(Sender: TObject);
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

procedure TfrmProdutos.edtCodigoExit(Sender: TObject);
begin
   if vKey = VK_RETURN then
      ProcessaConsulta;

   vKey := VK_CLEAR;
end;

function TfrmProdutos.ValidaProdutos: Boolean;
begin
   Result := False;

    if (edtNome.Text = EmptyStr) then
    begin
       TMessageUtil.Alerta('Nome do produto em branco.');

       if edtNome.CanFocus then
          edtNome.SetFocus;

        Exit;
    end;

    Result := True;
end;

procedure TfrmProdutos.edtCodigoUnidadeExit(Sender: TObject);
begin
   if vKey = VK_RETURN then
      ProcessaConsultaUnidade;

   vKey := VK_CLEAR;
end;

function TfrmProdutos.ProcessaConsultaUnidade: Boolean;
begin
   try
      Result := False;

      if (edtCodigoUnidade.Text = EmptyStr) then
      begin
         TMessageUtil.Alerta('Codigo da unidade de  produto n�o preenchido.');

         if edtCodigoUnidade.CanFocus then
            edtCodigoUnidade.SetFocus;

         Exit;
      end;

      vObjUnidadeProdutos :=
         TUnidadeProdutos(TUnidadeProdutosController.getInstancia.
         BuscaUnidadeProdutos(StrToIntDef(edtCodigoUnidade.Text,0)));



      if (edtCodigoUnidade <> nil) then
         CarregaDadosUnidade
      else
      begin
         TMessageUtil.Alerta(
            'Nenhuma unidade de produto encotrado para o c�digo informado.');

         LimparTela;

         if (edtCodigoUnidade.CanFocus) then
             edtCodigoUnidade.SetFocus;

         Exit;
      end;

      DefineEstadoTela;

      Result:= True;

   except
      on E: Exception do
      begin
         Raise Exception.Create(
         'Falha ao consultar os dados da unidade de  produto [View]:'#13+
         e.Message);
      end;
   end;
end;

procedure TfrmProdutos.CarregaDadosUnidade;
begin
   if (vObjUnidadeProdutos = nil) then
      Exit;

   edtTipoUnidade.Text          := vObjUnidadeProdutos.Unidade;
end;

end.
