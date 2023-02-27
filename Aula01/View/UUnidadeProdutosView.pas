unit UUnidadeProdutosView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls,UEnumerationUtil,
  UUnidadeProdutos, UUnidadeProdutosDAO, UUnidadeProdutosController;

type
  TfrmUnidadeProdutos = class(TForm)
    pnlDados: TPanel;
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    edtUnidade: TEdit;
    lblUnidade: TLabel;
    chkAtivo: TCheckBox;
    lblDescricao: TLabel;
    edtDescricao: TEdit;
    btnIncluir: TBitBtn;
    btnConsultar: TBitBtn;
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    btnPesquisar: TBitBtn;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSair: TBitBtn;
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtCodigoExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    vKey : Word;

    vEstadoTela : TEstadoTela;
    vObjUnidadeProdutos : TUnidadeProdutos;



    procedure CamposEnabled(pOpcao : Boolean);
    procedure LimparTela;
    procedure DefineEstadoTela;
    procedure CarregaDadosTela;

    function ProcessaConfirmacao         :Boolean;
    function ProcessaInclusao            :Boolean;
    function ProcessaConsulta            :Boolean;
    function ProcessaAlteracao           :Boolean;
    function ProcessaExclusao            :Boolean;
    function ProcessaUnidadeProdutos     :Boolean;
    function ProcessaUnidade             :Boolean;

    function ValidaUnidadeProdutos       :Boolean;
  public
    { Public declarations }
  end;

var
  frmUnidadeProdutos: TfrmUnidadeProdutos;

implementation

uses uMessageUtil, UUnidadeProdutosPesqView;

{$R *.dfm}

{ TfrmProdutos }

procedure TfrmUnidadeProdutos.btnIncluirClick(Sender: TObject);
begin
   vEstadoTela := etIncluir;
   DefineEstadoTela;
end;

procedure TfrmUnidadeProdutos.btnAlterarClick(Sender: TObject);
begin
   vEstadoTela := etAlterar;
   DefineEstadoTela;
end;

procedure TfrmUnidadeProdutos.btnExcluirClick(Sender: TObject);
begin
   vEstadoTela := etExcluir;
   DefineEstadoTela;
end;

procedure TfrmUnidadeProdutos.btnConsultarClick(Sender: TObject);
begin
   vEstadoTela := etConsultar;
   DefineEstadoTela;
end;

procedure TfrmUnidadeProdutos.btnPesquisarClick(Sender: TObject);
begin
   vEstadoTela := etPesquisar;
   DefineEstadoTela;
end;

procedure TfrmUnidadeProdutos.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmUnidadeProdutos.btnCancelarClick(Sender: TObject);
begin
   if (vEstadoTela <> etPadrao) then
   begin
      if  TMessageUtil.Pergunta('Deseja sair da operação?') then
      begin
         vEstadoTela := etPadrao;
         DefineEstadoTela;
      end;
   end;
end;

procedure TfrmUnidadeProdutos.btnSairClick(Sender: TObject);
begin
   if  TMessageUtil.Pergunta('Deseja sair da rotina?') then
   begin
      vEstadoTela := etPadrao;
      DefineEstadoTela;
      Close;
   end;
end;

procedure TfrmUnidadeProdutos.FormCreate(Sender: TObject);
begin
   vEstadoTela := etPadrao;
end;

procedure TfrmUnidadeProdutos.FormShow(Sender: TObject);
begin
   DefineEstadoTela;
end;

procedure TfrmUnidadeProdutos.CamposEnabled(pOpcao: Boolean);
var
   i: Integer;// Variavel auxiliar do comando de repetição
begin
   begin
      for i := 0 to pred(ComponentCount) do
      begin
         if (Components[i] is TEdit) then
            (Components[i] as TEdit).Enabled := pOpcao;

         if (Components[i] is TCheckBox) then
            (Components[i] as TCheckBox).Enabled := pOpcao;
      end;
   end;
end;

procedure TfrmUnidadeProdutos.DefineEstadoTela;
begin
   btnIncluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnAlterar.Enabled   := (vEstadoTela in [etPadrao]);
   btnExcluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnConsultar.Enabled := (vEstadoTela in [etPadrao]);
   btnPesquisar.Enabled := (vEstadoTela in [etPadrao]);
   btnSair.Enabled      := (vEstadoTela in [etPadrao]);

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

           if (frmUnidadeProdutos <>nil)   and
              (frmUnidadeProdutos.Active)  and
              (btnIncluir.CanFocus) then
               btnIncluir.SetFocus;

           Application.ProcessMessages;
      end;

      etIncluir:
      begin
         stbBarraStatus.Panels[0].Text :='Inclusão';
         CamposEnabled(True);

         edtCodigo.Enabled := False;

         chkAtivo.Checked := True;

         if edtUnidade.CanFocus then
            edtUnidade.SetFocus;

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

            if chkAtivo.CanFocus then
               chkAtivo.SetFocus;

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

        if (edtCodigo.Text <> EmptyStr)  then
        begin
           ProcessaExclusao;
        end
        else
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

         if frmUnidadeProdutosPesq = nil then
           frmUnidadeProdutosPesq := TfrmUnidadeProdutosPesq.Create(Application);

         frmUnidadeProdutosPesq.ShowModal;

         if  frmUnidadeProdutosPesq.mUnidadeProdutosID <> 0 then
         begin
            edtCodigo.Text := IntToStr(frmUnidadeProdutosPesq.mUnidadeProdutosID);
            vEstadoTela := etConsultar;
            ProcessaConsulta;
         end
         else
         begin
            vEstadoTela := etPadrao;
            DefineEstadoTela;
         end;

         frmUnidadeProdutosPesq.mUnidadeProdutosID := 0;
         frmUnidadeProdutosPesq.mUnidadeProdutosDescricao := EmptyStr;

         if edtDescricao.CanFocus then
            edtDescricao.SetFocus;
      end;
   end;
end;

procedure TfrmUnidadeProdutos.LimparTela;
var
   i : Integer;
begin
   for i := 0 to pred(ComponentCount) do
   begin
     //Se o campo for do tipo EDIT
      if (Components[i] is TEdit) then // Limpa o valor que esta no campo
         (Components[i] as TEdit).Text := EmptyStr;

      // Se o campo for do tipo CheckBox
      if (Components[i] is TCheckBox) then // Define o campo como FALSO
         (Components[i] as TCheckBox).Checked := False;

   end;

    if vObjUnidadeProdutos <> nil then
         FreeAndNil(vObjUnidadeProdutos);

end;

function TfrmUnidadeProdutos.ProcessaAlteracao: Boolean;
begin
   try
      Result := False;

      if ProcessaUnidadeProdutos then
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
            'Falha ao alterar os dados da unidade do produto [View]'#13+
            e.Message);
       end;

   end;
end;

function TfrmUnidadeProdutos.ProcessaConfirmacao: Boolean;
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

function TfrmUnidadeProdutos.ProcessaConsulta: Boolean;
begin
    try
      Result := False;

      if (edtCodigo.Text = EmptyStr) then
      begin
         TMessageUtil.Alerta('Codigo da unidade de produto não preenchido.');

         if edtCodigo.CanFocus then
            edtCodigo.SetFocus;

         Exit;
      end;

      vObjUnidadeProdutos :=
         TUnidadeProdutos(TUnidadeProdutosController.getInstancia.
         BuscaUnidadeProdutos(StrToIntDef(edtCodigo.Text, 0)));

      if (vObjUnidadeProdutos <> nil) then
         CarregaDadosTela
      else
      begin
         TMessageUtil.Alerta(
            'Nenhuma unidade de produto encontrado para o código informado.');

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
         'Falha ao consultar os dados da unidade de produto [View]:'#13+
         e.Message);
      end;
    end;
end;

function TfrmUnidadeProdutos.ProcessaExclusao: Boolean;
begin
   try
      Result:= False;

      if (vObjUnidadeProdutos = nil) then
      begin
         TMessageUtil.Alerta (
         'Não foi possivel carregar os dados cadastrados da unidade de'+
         'produto informado.');

         LimparTela;
         vEstadoTela := etPadrao;
         DefineEstadoTela;
         Exit;
      end;


      try
         if TMessageUtil.Pergunta(
         'Quer realmente excluir os dados da unidade de produto?')then
         begin
            Screen.Cursor := crHourGlass;
            TUnidadeProdutosController.getInstancia.
               ExcluiUnidadeProdutos(vObjUnidadeProdutos);
            TMessageUtil.Informacao('Unidade de produto excluido com sucesso!');

            LimparTela;
            vEstadoTela:= etPadrao;
            DefineEstadoTela;
         end
         else
         begin
            vEstadoTela := etConsultar;
            DefineEstadoTela;
         end;
      finally
         Screen.Cursor := crDefault;
         Application.ProcessMessages;
      end;
      Result:= True;

   except
       on E: Exception do
       begin
          raise Exception.Create(
          'Falha na exclusão dos dados do cliente [View].'#13+
          e.Message);
       end;

   end;

end;

function TfrmUnidadeProdutos.ProcessaInclusao: Boolean;
begin
   try
      Result := False;

      if ProcessaUnidadeProdutos then
      begin
         TMessageUtil.Informacao('Unidade do produto cadastrado com sucesso.'#13+
         'Produto cadastrado: '+ IntToStr(vObjUnidadeProdutos.Id));

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

function TfrmUnidadeProdutos.ProcessaUnidadeProdutos: Boolean;
begin
   try
      Result:= False;
      if (ProcessaUnidade) then
      begin
         //Gravação do BD
         TUnidadeProdutosController.getInstancia.GravaUnidadeProdutos(
         vObjUnidadeProdutos);


         Result := True;


      end;


   except
      on E: Exception do
      begin
      Raise Exception.Create(
            'Falha ao gravar os dados da unidade do produto [View]'#13+
            e.Message);

      end;
    end;
end;



procedure TfrmUnidadeProdutos.FormKeyDown(Sender: TObject; var Key: Word;
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
            if (TMessageUtil.Pergunta('Deseja encerrar a operação?')) then
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

function TfrmUnidadeProdutos.ProcessaUnidade: Boolean;
begin
   try
      Result := False;

      if not ValidaUnidadeProdutos then
         Exit;


      if vEstadoTela =etIncluir then
      begin
         if vObjUnidadeProdutos = nil then
            vObjUnidadeProdutos := TUnidadeProdutos.Create;
      end
      else
      if vEstadoTela =etAlterar then
      begin
         if vObjUnidadeProdutos = nil then
            Exit;
      end;

         if (vObjUnidadeProdutos) = nil then
            Exit;


      vObjUnidadeProdutos.Ativo                  := chkAtivo.Checked;
      vObjUnidadeProdutos.Unidade                := edtUnidade.Text;
      vObjUnidadeProdutos.Descricao              := edtDescricao.Text;


      Result := True;
   except
      on E: Exception do
      begin
         raise Exception.Create(
         'Falha ao processar os dados da unidade do produto [View]:'#13+
         e.Message);
      end;
   end;
end;

function TfrmUnidadeProdutos.ValidaUnidadeProdutos: Boolean;
begin
   Result := False;

    if (edtUnidade.Text = EmptyStr) then
    begin
       TMessageUtil.Alerta('Unidade em branco.');

       if edtUnidade.CanFocus then
          edtUnidade.SetFocus;

        Exit;
    end;

    if (edtDescricao.Text = EmptyStr) then
    begin
       TMessageUtil.Alerta('Descrição da unidade do produto em branco.');

       if edtDescricao.CanFocus then
          edtDescricao.SetFocus;

        Exit;
    end;

    Result := True;
end;

procedure TfrmUnidadeProdutos.CarregaDadosTela;
   begin
      if (vObjUnidadeProdutos = nil) then
         Exit;

      edtCodigo.Text          := IntToStr (vObjUnidadeProdutos.Id);
      edtUnidade.Text         := vObjUnidadeProdutos.Unidade;
      edtDescricao.Text       := vObjUnidadeProdutos.Descricao;
      chkAtivo.Checked        := vObjUnidadeProdutos.Ativo;

   end;
procedure TfrmUnidadeProdutos.edtCodigoExit(Sender: TObject);
begin
   if vKey = VK_RETURN then
      ProcessaConsulta;

   vKey := VK_CLEAR;
end;

procedure TfrmUnidadeProdutos.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
   frmUnidadeProdutos := nil;
end;

end.
