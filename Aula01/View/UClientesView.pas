unit UClientesView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Mask, Buttons, UEnumerationUtil,
  UCliente, UPessoaController, UEndereco;

type
  TfrmClientes = class(TForm)
    stbBarraStatus: TStatusBar;
    pnlBotoes: TPanel;
    pnlArea: TPanel;
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    chkAtivo: TCheckBox;
    rdgTipoPessoa: TRadioGroup;
    lblCpfCNPJ: TLabel;
    edtCPFCNPJ: TMaskEdit;
    lblNome: TLabel;
    edtNome: TEdit;
    grbEndereco: TGroupBox;
    lblEndereco: TLabel;
    edtEndereco: TEdit;
    lblNumero: TLabel;
    edtNumero: TEdit;
    lblComplemento: TLabel;
    edtComplemento: TEdit;
    lblBairro: TLabel;
    edtBairro: TEdit;
    lblUF: TLabel;
    cmbUF: TComboBox;
    lblCidade: TLabel;
    edtCidade: TEdit;
    btnIncluir: TBitBtn;
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    btnConsultar: TBitBtn;
    btnListar: TBitBtn;
    btnPesquisar: TBitBtn;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    btnSair: TBitBtn;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnListarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtCodigoExit(Sender: TObject);


  private
    { Private declarations }
    vKey : Word;

    // Variaveis de Classe
    vEstadoTela     :TEstadoTela;
    vObjCliente     :TCliente;
    vObjColEndereco :TColEndereco;

    procedure CamposEnabled(pOpcao : Boolean);
    procedure LimparTela;
    procedure DefineEstadoTela;
    procedure CarregaDadosTela;


    function ProcessaConfirmacao :Boolean;
    function ProcessaInclusao    :Boolean;
    function ProcessaConsulta    :Boolean;
    function ProcessaCliente     :Boolean;
    function ProcessaAlteracao   :Boolean;
    function ProcessaExclusao    :Boolean;

    function ProcessaPessoa: Boolean;
    function ProcessaEndereco: Boolean;

    function ValidaCliente: Boolean;
    function ValidaEndereco: Boolean;
  public
    { Public declarations }
  end;

var
  frmClientes: TfrmClientes;

implementation

uses
   uMessageUtil;

{$R *.dfm}

procedure TfrmClientes.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmClientes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
   frmClientes := nil;
end;

procedure TfrmClientes.CamposEnabled(pOpcao: Boolean);
var
   i : Integer; // Variavel auxiliar do comando de repetição
begin
   for i := 0 to pred(ComponentCount) do
   begin
      if (Components[i] is TEdit) then
         (Components[i] as TEdit).Enabled := pOpcao;

      if (Components[i] is TMaskEdit) then
         (Components[i] as TMaskEdit).Enabled := pOpcao;

      if (Components[i] is TRadioGroup) then
         (Components[i] as TRadioGroup).Enabled := pOpcao;

      if (Components[i] is TComboBox) then
         (Components[i] as TComboBox).Enabled := pOpcao;

      if (Components[i] is TCheckBox) then
         (Components[i] as TCheckBox).Enabled := pOpcao;
   end;

   grbEndereco.Enabled := pOpcao;
end;

procedure TfrmClientes.LimparTela;
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

      // Se o campo for do tipo RADIOGROUP
      if (Components[i] is TRadioGroup) then // Define o valor igual a 0
         (Components[i] as TRadioGroup).ItemIndex := 0;

      // Se o campo for do tipo COMBOBOX
      if (Components[i] is TComboBox) then  // Define o valor igual a -1
      begin
         (Components[i] as TComboBox).Clear;
         (Components[i] as TComboBox).ItemIndex := -1;
      end;

      // Se o campo for do tipo CheckBox
      if (Components[i] is TCheckBox) then // Define o campo como FALSO
         (Components[i] as TCheckBox).Checked := False;

   end;

   if vObjCliente <> nil then
         FreeAndNil(vObjCliente);

   if vObjColEndereco <> nil then
         FreeAndNil(vObjColEndereco);

end;

procedure TfrmClientes.DefineEstadoTela;
begin
   btnIncluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnAlterar.Enabled   := (vEstadoTela in [etPadrao]);
   btnExcluir.Enabled   := (vEstadoTela in [etPadrao]);
   btnConsultar.Enabled := (vEstadoTela in [etPadrao]);
   btnListar.Enabled    := (vEstadoTela in [etPadrao]);
   btnPesquisar.Enabled := (vEstadoTela in [etPadrao]);

   btnConfirmar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar];

   btnCancelar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar];

   case vEstadoTela of
   etPadrao:
      begin
         CamposEnabled(False);
         LimparTela;

         stbBarraStatus.Panels[0].Text := EmptyStr;
         stbBarraStatus.Panels[1].Text := EmptyStr;

           if (frmClientes <>nil)   and
              (frmClientes.Active)  and
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
           btnListar.Enabled    := True;
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




   end;

end;


procedure TfrmClientes.btnIncluirClick(Sender: TObject);
begin
   vEstadoTela := etIncluir;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnAlterarClick(Sender: TObject);
begin
   vEstadoTela := etAlterar;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnExcluirClick(Sender: TObject);
begin
   vEstadoTela := etExcluir;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnConsultarClick(Sender: TObject);
begin
   vEstadoTela := etConsultar;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnListarClick(Sender: TObject);
begin
   vEstadoTela := etListar;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnPesquisarClick(Sender: TObject);
begin
   vEstadoTela := etPesquisar;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnConfirmarClick(Sender: TObject);
begin
   ProcessaConfirmacao;
end;

procedure TfrmClientes.btnCancelarClick(Sender: TObject);
begin
   vEstadoTela := etPadrao;
   DefineEstadoTela;
end;

procedure TfrmClientes.btnSairClick(Sender: TObject);
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
     Close;
end;

procedure TfrmClientes.FormCreate(Sender: TObject);
begin
   vEstadoTela := etPadrao;
end;

procedure TfrmClientes.FormShow(Sender: TObject);
begin
   DefineEstadoTela;
end;

procedure TfrmClientes.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   vKey := VK_CLEAR;
end;

function TfrmClientes.ProcessaConfirmacao: Boolean;
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

function TfrmClientes.ProcessaInclusao: Boolean;
begin
   try
      Result := False;

      if ProcessaCliente then
      begin
         TMessageUtil.Informacao('Cliente cadastrado com sucesso.'#13+
         'Código cadastrado: '+ IntToStr(vObjCliente.Id));

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


function TfrmClientes.ProcessaCliente: Boolean;
begin
   try
      Result:= False;
      if (ProcessaPessoa) and
         (ProcessaEndereco) then
      begin
         //Gravação do BD
         TPessoaController.getInstancia.GravaPessoa(
         vObjCliente,vObjColEndereco);


         Result := True;


      end;


   except
      on E: Exception do
      begin
      Raise Exception.Create(
            'Falha ao gravar os dados do cliente [View]'#13+
            e.Message);

      end;
    end;
end;

function TfrmClientes.ProcessaPessoa: Boolean;
begin
   try
      Result := False;

      if not ValidaCliente then
         Exit;


      if vEstadoTela =etIncluir then
      begin
         if vObjCliente = nil then
            vObjCliente := Tcliente.Create;
      end
      else
      if vEstadoTela =etAlterar then
      begin
         if vObjCliente = nil then
            Exit;
      end;

         if (vObjCliente) = nil then
            Exit;

      vObjCliente.Tipo_Pessoa         := 0;
      vObjCliente.Nome                := edtNome.Text;
      vObjCliente.Fisica_Juridica     := rdgTipoPessoa.ItemIndex;
      vObjCliente.Ativo               := chkAtivo.Checked;
      vObjCliente.IdentificadorPessoa := edtCPFCNPJ.Text;


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

function TfrmClientes.ProcessaEndereco: Boolean;
var
   xEndereco : TEndereco;
   xID_Pessoa : Integer;
begin
   try
      Result :=False;

      xEndereco := nil;
      xID_Pessoa := 0;

      if (not ValidaEndereco) then
             Exit;

      if vObjColEndereco <> nil then
         FreeAndNil(vObjColEndereco);

      vObjColEndereco := TColEndereco.Create;

      if vEstadoTela = etAlterar then
         xID_Pessoa  := StrToIntDef(edtCodigo.Text, 0);

      xEndereco                := TEndereco.Create;
      xEndereco.ID_Pessoa      := xID_Pessoa;
      xEndereco.Tipo_Endereco  := 0;
      xEndereco.Endereco       := edtEndereco.Text;
      xEndereco.Numero         := edtNumero.Text;
      xEndereco.Complemento    := edtComplemento.Text;
      xEndereco.Bairro         := edtBairro.Text;
      xEndereco.UF             := cmbUF.Text;
      xEndereco.Cidade         := edtCidade.Text;

      vObjColEndereco.Add(xEndereco);

      Result := True;
   except
      on E: Exception do
      begin
         raise Exception.Create(
         'Falha ao preeencher os dados de enderço do cliente [View]:'#13+
         e.Message);
      end;

   end;
end;

function TfrmClientes.ValidaCliente: Boolean;
begin
    Result := False;

    if (edtNome.Text = EmptyStr) then
    begin
       TMessageUtil.Alerta('Nome do cliente em branco.');

       if edtNome.CanFocus then
          edtNome.SetFocus;

        Exit;
    end;

    Result := True;
end;

function TfrmClientes.ProcessaConsulta: Boolean;
begin
   try
      Result := False;

      if (edtCodigo.Text = EmptyStr) then
      begin
         TMessageUtil.Alerta('Codigo do cliente não preenchido.');

         if edtCodigo.CanFocus then
            edtCodigo.SetFocus;

         Exit;
      end;

      vObjCliente :=
         TCliente(TPessoaController.getInstancia.BuscaPessoa(
            StrToIntDef(edtCodigo.Text, 0)));

      vObjColEndereco :=
         TPessoaController.getInstancia.BuscaEnderecoPessoa(
         StrToIntDef(edtCodigo.Text, 0));

      if (vObjCliente <> nil) then
         CarregaDadosTela
      else
      begin
         TMessageUtil.Alerta(
            'Nenhum cliente encotrado para o código informado.');

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
         'Falha ao consultar os dados do cliente [View]:'#13+
         e.Message);
      end;
    end;
end;

procedure TfrmClientes.CarregaDadosTela;
var
   i : Integer;
begin
   if (vObjCliente = nil) then
      Exit;

   edtCodigo.Text          := IntToStr (vObjCliente.Id);
   rdgTipoPessoa.ItemIndex := vObjCliente.Fisica_Juridica;
   edtNome.Text            := vObjCliente.Nome;
   chkAtivo.Checked        := vObjCliente.Ativo;
   edtCPFCNPJ.Text         := vObjCliente.IdentificadorPessoa;

   if vObjColEndereco <> nil then
   begin
      for i := 0 to (vObjColEndereco.Count - 1) do
      begin
         edtEndereco.Text    := vObjColEndereco.Retorna(i).Endereco;
         edtNumero.Text      := vObjColEndereco.Retorna(i).Numero;
         edtComplemento.Text := vObjColEndereco.Retorna(i).Complemento;
         edtBairro.Text      := vObjColEndereco.Retorna(i).Bairro;
         cmbUF.Text          := vObjColEndereco.Retorna(i).UF;
         edtCidade.Text      := vObjColEndereco.Retorna(i).Cidade;
      end;
   end;


end;

function TfrmClientes.ProcessaAlteracao: Boolean;
begin
   try
      Result := False;

      if ProcessaCliente then
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

procedure TfrmClientes.edtCodigoExit(Sender: TObject);
begin
   if vKey = VK_RETURN then
      ProcessaConsulta;

   vKey := VK_CLEAR;
end;

function TfrmClientes.ProcessaExclusao: Boolean;
begin
   try
      Result:= False;

      if (vObjCliente = nil) or
         (vObjColEndereco = nil) then
      begin
         TMessageUtil.Alerta (
         'Não foi possivel carregar os dados cadastrados do cliente informado.');

         LimparTela;
         vEstadoTela := etPadrao;
         DefineEstadoTela;
         Exit;
      end;

      try
         if TMessageUtil.Pergunta(
         'Quer realmente excluir os dados do cliente?')then

            begin
               Screen.Cursor := crHourGlass;
               TPessoaController.getInstancia.ExcluiPessoa(vObjCliente);

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

      vEstadoTela:= etPadrao;
      DefineEstadoTela;

      Result:= True;

      TMessageUtil.Informacao('Cliente excluido com sucesso!');
   except
       on E: Exception do
       begin
          raise Exception.Create(
          'Falha na exclusão dos dados do cliente [View].'#13+
          e.Message);
       end;

   end;


end;

function TfrmClientes.ValidaEndereco: Boolean;
begin
   Result:= False;

   if(Trim(edtEndereco.Text) = EmptyStr) then
   begin
      TMessageUtil.Alerta('Endereço do cliente não pode ficar em branco.');

      if edtEndereco.CanFocus then
         edtEndereco.SetFocus;
      Exit;
   end;

   if(Trim(edtNumero.Text) = EmptyStr) then
   begin
      TMessageUtil.Alerta(
      'O numero do endereço do cliente não pode ficar em branco.');

      if edtNumero.CanFocus then
         edtNumero.SetFocus;
      Exit;
   end;


   if(Trim(edtBairro.Text) = EmptyStr) then
   begin
      TMessageUtil.Alerta(
      'O bairro do cliente não pode ficar em branco.');

      if edtBairro.CanFocus then
         edtBairro.SetFocus;
      Exit;
   end;

   if(Trim(cmbUF.Text) = EmptyStr) then
   begin
      TMessageUtil.Alerta(
      'O Estado do cliente não pode ficar em branco.');

      if cmbUF.CanFocus then
         cmbUF.SetFocus;
      Exit;
   end;

   if(Trim(edtCidade.Text) = EmptyStr) then
   begin
      TMessageUtil.Alerta(
      'A cidade do cliente não pode ficar em branco.');

      if edtCidade.CanFocus then
         edtCidade.SetFocus;
      Exit;
   end;

   Result:= True;
end;


end.
