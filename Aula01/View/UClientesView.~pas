unit UClientesView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Mask, Buttons, UEnumerationUtil,
  UCliente, UPessoaController, UEndereco, frxClass, DB, DBClient, frxDBSet,
  frxExportXLS, frxExportPDF,UClassFuncoes;

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
    frxListagemCliente: TfrxReport;
    cdsCliente: TClientDataSet;
    cdsClienteNome: TStringField;
    cdsClienteID: TStringField;
    cdsClienteEndereco: TStringField;
    cdsClienteCPFCNPJ: TStringField;
    cdsClienteAtivo: TStringField;
    cdsClienteNumero: TStringField;
    cdsClienteBairro: TStringField;
    cdsClienteComplemento: TStringField;
    cdsClienteCidadeUF: TStringField;
    frxDBCliente: TfrxDBDataset;
    frxPDF: TfrxPDFExport;
    frxXLS: TfrxXLSExport;
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
    procedure rdgTipoPessoaClick(Sender: TObject);



  private
    { Private declarations }
    vKey : Word;

    // Variaveis de Classe
    vEstadoTela     :TEstadoTela;
    vObjCliente     :TCliente;
    vObjColEndereco :TColEndereco;
    vFuncao         :TFuncoes;

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
    function ProcessaListagem    :Boolean;

    function ProcessaPessoa   : Boolean;
    function ProcessaEndereco : Boolean;

    function NumerosCPFCNPJ(const Texto:String) : String;
    function ValidaCliente                     : Boolean;
    function ValidaEndereco                    : Boolean;
    function ValidaCPF(num:string)             : Boolean;
    function ValidaCNPJ(num:string)            : Boolean;
  public
    { Public declarations }
  end;

var
  frmClientes: TfrmClientes;

implementation

uses
   uMessageUtil, UClientesPesqView, StrUtils;

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
        // (Components[i] as TComboBox).Clear;
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
   btnSair.Enabled      := (vEstadoTela in [etPadrao]);

   btnConfirmar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar, etPesquisar,
      etListar];

   btnCancelar.Enabled :=
      vEstadoTela in [etIncluir, etAlterar, etExcluir, etConsultar, etPesquisar,
      etListar];



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
         stbBarraStatus.Panels[0].Text :='Alteração';

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
         stbBarraStatus.Panels[0].Text  := 'Exclusão';

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

      etPesquisar:
      begin
         stbBarraStatus.Panels[0].Text := 'Pesquisa';

         if frmClientesPesq = nil then
           frmClientesPesq := TfrmClientesPesq.Create(Application);

         frmClientesPesq.ShowModal;

         if  frmClientesPesq.mClienteID <> 0 then
         begin
            edtCodigo.Text := IntToStr(frmClientesPesq.mClienteID);
            vEstadoTela := etConsultar;
            ProcessaConsulta;
         end
         else
         begin
            vEstadoTela := etPadrao;
            DefineEstadoTela;
         end;

         frmClientesPesq.mClienteID := 0;
         frmClientesPesq.mClienteNome := EmptyStr;

         if edtNome.CanFocus then
            edtNome.SetFocus;
      end;

      etListar:
      begin
         stbBarraStatus.Panels[0].Text := 'Lista';

         if edtCodigo.Text <> EmptyStr then
            ProcessaListagem
         else
         begin
            lblCodigo.Enabled := True;
            edtCodigo.Enabled := True;

            if edtCodigo.CanFocus then
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
   if (vEstadoTela <> etPadrao) then
   begin
      if  TMessageUtil.Pergunta('Deseja sair da operação?') then
      begin
         vEstadoTela := etPadrao;
         DefineEstadoTela;
      end
   end;

end;

procedure TfrmClientes.btnSairClick(Sender: TObject);
begin
   if  TMessageUtil.Pergunta('Deseja sair da rotina?') then
   begin
      vEstadoTela := etPadrao;
      DefineEstadoTela;
      Close;
   end;
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
var
   xCPFCNPJ: string;

begin
   try
      Result := False;

      if not ValidaCliente then
         Exit;

      if rdgTipoPessoa.ItemIndex = 0 then
      begin
         xCPFCNPJ := NumerosCPFCNPJ(Trim(edtCPFCNPJ.Text));
         if not ValidaCPF(xCPFCNPJ) then
         begin
         if edtCPFCNPJ.CanFocus then
            edtCPFCNPJ.SetFocus;
            edtCPFCNPJ.Clear;
            Exit;
         end;
      end;

      if rdgTipoPessoa.ItemIndex = 1 then
      begin
         xCPFCNPJ := NumerosCPFCNPJ(Trim(edtCPFCNPJ.Text));
         if not ValidaCNPJ(xCPFCNPJ) then
         begin
            
         if edtCPFCNPJ.CanFocus then
            edtCPFCNPJ.SetFocus;
            edtCPFCNPJ.Clear;
            Exit;
         end;
      end;


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
            'Nenhum cliente encontrado para o código informado.');

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
   xAux: Integer;
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
         xAux := cmbUF.Items.IndexOf(vObjColEndereco.Retorna(i).UF);
         cmbUF.ItemIndex := xAux;
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
      end
      else
      begin
         vEstadoTela := etConsultar;
         DefineEstadoTela;
      end;

      try
         if TMessageUtil.Pergunta(
         'Quer realmente excluir os dados do cliente?')then

         begin
            Screen.Cursor := crHourGlass;
            TPessoaController.getInstancia.ExcluiPessoa(vObjCliente);
            TMessageUtil.Informacao('Cliente excluido com sucesso!');

            LimparTela;
            vEstadoTela:= etPadrao;
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


procedure TfrmClientes.rdgTipoPessoaClick(Sender: TObject);
begin
   if rdgTipoPessoa.ItemIndex = 1 then
      begin
         edtCPFCNPJ.Clear;
         edtCPFCNPJ.EditMask := '##\.###\.###\/####\-##;1;_'
      end
   else
      begin
         edtCPFCNPJ.Clear;
         edtCPFCNPJ.EditMask := '###\.###\.###\-##;1;_';
      end;

end;

function TfrmClientes.ProcessaListagem: Boolean;
begin
   try
      if not cdsCliente.Active then
         Exit;

      cdsCliente.Append;
      cdsClienteID.Value          := edtCodigo.Text;
      cdsClienteNome.Value        := edtNome.Text;
      cdsClienteCPFCNPJ.Value     := edtCPFCNPJ.Text;
      cdsClienteAtivo.Value       := IfThen(chkAtivo.Checked, 'Sim', 'Não');
      cdsClienteEndereco.Value    := edtEndereco.Text;
      cdsClienteBairro.Value      := edtBairro.Text;
      cdsClienteNumero.Value      := edtNumero.Text;
      cdsClienteComplemento.Value := edtComplemento.Text;
      cdsClienteCidadeUF.Value    := edtCidade.Text + '/' + cmbUF.Text;
      cdsCliente.Post;

      frxListagemCliente.Variables['DATAHORA']    :=
         QuotedStr(FormatDateTime('DD/MM/YYYY hh:mm', Date + Time));
      frxListagemCliente.Variables['NOMEEMPRESA'] :=
         QuotedStr('Nome da Empresa');

      frxXLS.Wysiwyg := False;

      frxListagemCliente.ShowReport();

   finally
      vEstadoTela := etPadrao;
      DefineEstadoTela;
      cdsCliente.EmptyDataSet;
   end;
end;

function TfrmClientes.ValidaCPF(num:string) : Boolean;
var
   xN1,xN2,xN3,xN4,xN5,xN6,xN7,xN8,xN9 : Integer;
   xDigito1,xDigito2 : Integer;
   xDigitosInformados : string;
   xDigitosCalculados : string;
   xCPFCNPJ : string;
begin
   Result := False;
   xCPFCNPJ := NumerosCPFCNPJ(edtCPFCNPJ.Text);

   if (xCPFCNPJ = '11111111111') or (xCPFCNPJ = '22222222222') or
      (xCPFCNPJ = '33333333333') or (xCPFCNPJ = '44444444444') or
      (xCPFCNPJ = '55555555555') or (xCPFCNPJ = '66666666666') or
      (xCPFCNPJ = '77777777777') or (xCPFCNPJ = '88888888888') or
      (xCPFCNPJ = '99999999999') or (xCPFCNPJ = '00000000000') then
      begin
         TMessageUtil.Alerta('O CPF informado é invalido.');
         Exit
      end
   else
      if (Length(Trim(num))<>11)then
      begin
         TMessageUtil.Alerta('O CPF informado é invalido.');
      end
      else
      begin
         xN1 := StrToInt(num[1]);
         xN2 := StrToInt(num[2]);
         xN3 := StrToInt(num[3]);
         xN4 := StrToInt(num[4]);
         xN5 := StrToInt(num[5]);
         xN6 := StrToInt(num[6]);
         xN7 := StrToInt(num[7]);
         xN8 := StrToInt(num[8]);
         xN9 := StrToInt(num[9]);
         xDigito1 := ((xN1*10) + (xN2*9) + (xN3*8) + (xN4*7) + (xN5*6) +
            (xN6*5) + (xN7*4) + (xN8*3) + (xN9*2));
         xDigito1 := 11 - (xDigito1 mod 11);
         if xDigito1 > 9 then
            xDigito1 := 0;

         xDigito2 :=  ((xN1*11) + (xN2*10) + (xN3*9) + (xN4*8) + (xN5*7) +
            (xN6*6) + (xN7*5) + (xN8*4) + (xN9*3) + (xDigito1*2));
         xDigito2 := 11 - (xDigito2 mod 11);
         if xDigito2 > 9 then
            xDigito2 := 0;
         xDigitosCalculados := IntToStr(xDigito1)+IntToStr(xDigito2);
         xDigitosInformados := num[10] + num[11];
         if xDigitosInformados = xDigitosCalculados then
            Result:= True
         else
            TMessageUtil.Alerta('O CPF informado é invalido.');
      end;


end;

function TfrmClientes.NumerosCPFCNPJ(Const Texto:string):string;
var
   xNumero: Integer;
   xString: string;
begin
   xString := '';
   for xNumero := 1 to Length(Texto) do
   begin
      if Texto [xNumero] in ['0'..'9'] then
      begin
         xString := xString + Copy(Texto, xNumero,1);
      end;
      Result := xString;
   end;
end;

function TfrmClientes.ValidaCNPJ(num:string): Boolean;
var
   xN1,xN2,xN3,xN4,xN5,xN6,xN7,xN8,xN9,xN10,xN11,xN12 : Integer;
   xDigito1,xDigito2 : Integer;
   xDigitosInformados : string;
   xDigitosCalculados : string;
   xCPFCNPJ: string;
begin
   Result := False;
   xCPFCNPJ := NumerosCPFCNPJ(edtCPFCNPJ.Text);

   if (xCPFCNPJ = '11111111111111') or (xCPFCNPJ = '22222222222222') or
      (xCPFCNPJ = '33333333333333') or (xCPFCNPJ = '44444444444444') or
      (xCPFCNPJ = '55555555555555') or (xCPFCNPJ = '66666666666666') or
      (xCPFCNPJ = '77777777777777') or (xCPFCNPJ = '88888888888888') or
      (xCPFCNPJ = '99999999999999') or (xCPFCNPJ = '00000000000000') then
      begin
         TMessageUtil.Alerta('O CPF informado é invalido.');
         Exit
      end
   else
   if (Length(Trim(num))<>14)then
   begin
      Result:= False;
   end
   else
   begin
      xN1 := StrToInt(num[1]);
      xN2 := StrToInt(num[2]);
      xN3 := StrToInt(num[3]);
      xN4 := StrToInt(num[4]);
      xN5 := StrToInt(num[5]);
      xN6 := StrToInt(num[6]);
      xN7 := StrToInt(num[7]);
      xN8 := StrToInt(num[8]);
      xN9 := StrToInt(num[9]);
      xN10 := StrToInt(num[10]);
      xN11 := StrToInt(num[11]);
      xN12 := StrToInt(num[12]);
      xDigito1 := ((xN1*5) + (xN2*4) + (xN3*3) + (xN4*2) + (xN5*9) +
         (xN6*8) + (xN7*7) + (xN8*6) + (xN9*5)+(xN10*4)+(xN11*3)+(xN12*2));
      xDigito1 := xDigito1 mod 11;
      if xDigito1 < 2  then
         xDigito1 := 0
      else
         xDigito1 := 11 - xDigito1;

      xDigito2 :=  ((xN1*6) + (xN2*5) + (xN3*4) + (xN4*3) + (xN5*2) + (xN6*9) +
         (xN7*8) + (xN8*7) + (xN9*6) +(xN10*5)+(xN11*4)+(xN12*3)+(xDigito1*2));
      xDigito2 :=  (xDigito2 mod 11);
      if xDigito2 < 2 then
         xDigito2 := 0
      else
         xDigito2 := 11 - xDigito2;

      xDigitosCalculados := IntToStr(xDigito1)+IntToStr(xDigito2);
      xDigitosInformados := num[13] + num[14];
      if xDigitosInformados = xDigitosCalculados then
         Result:= True
      else
         TMessageUtil.Alerta('O CNPJ informado é invalido');


   end;
end;



end.
