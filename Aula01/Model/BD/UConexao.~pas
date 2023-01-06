unit UConexao;

interface

uses SysUtils,SqlExpr,IniFiles,Forms,Classes,DBTables,DBXpress,
     UCriptografiaUtil,Windows;

type
   TConexao = class
      private
         vConexao: TSQLConnection;
         vTransaction : TTransactionDesc;
         vCaminhoBd,
         vUsuario,
         vSenha : String;
         procedure carregaParametros;
         constructor CreatePrivate;

      public
         constructor Create;
         class function getInstance : TConexao;
         class function get: TConexao;
         function getConn : TSQLConnection;
         function cancelaTransacao(pId: Integer = 1; pConexao: TSQLConnection = Nil): Boolean;
         function confirmaTransacao(pId: Integer = 1; pConexao: TSQLConnection = Nil): Boolean;
         function iniciaTransacao(pId: Integer = 1; pConexao: TSQLConnection = Nil): Boolean;
         function createConnection: TSQLConnection;
         function getCaminhoBanco : String;
         procedure DefineConexao(pConexao: TSQLConnection);
         procedure FechaConexao;
   end;

implementation

var
   _Conexao : TConexao = nil;

{ TConexao }

constructor TConexao.Create;
begin
   raise Exception.Create('Para obter uma conexão. Utilize o método getInstance.');
end;

constructor TConexao.CreatePrivate;
begin
   inherited Create;
end;

function TConexao.getConn:TSQLConnection;
begin
   if Not Assigned(vConexao) then
      vConexao := createConnection;

   if not vConexao.Connected then
      vConexao.Open;

   Result := vConexao;
end;

function TConexao.createConnection: TSQLConnection;
begin
   result := TSQLConnection.Create(Nil);

   carregaParametros;
   result.DriverName := 'Interbase';
   result.ConnectionName := 'FBConnection';
   result.GetDriverFunc := 'getSQLDriverINTERBASE';
   result.LibraryName := 'dbexpint.dll';
   result.VendorLib := 'gds32.dll';
   result.LoginPrompt := False;
   Result.KeepConnection := True;
   result.Params.Values['Database'     ] := vCaminhoBd;
   result.Params.Values['User_Name'    ] := vUsuario;
   result.Params.Values['Password'     ] := vSenha;
   result.Params.Values['ServerCharSet'] := 'WIN1252';
   result.Params.Values['WaitOnLocks'  ] := 'True';
   try
      result.Open;
   except
      on E: Exception do
      begin
         raise Exception.Create('Ocorreu um erro ao ao tentar comunicar com o banco de dados.' + #13 +
                                'Motivo: ' + E.Message);
      end;
   end;
end;

class function TConexao.getInstance: TConexao;
begin
   if not Assigned(_Conexao) then
       _Conexao := TConexao.CreatePrivate;
    Result:= _Conexao;
end;

procedure TConexao.carregaParametros;
Var
   vCaminho,
   vTextoArq   : String;
   vArq        : TextFile;
   vArqIni     : TMemIniFile;
   vAlias      : TStringList;
   vCripto     : TCriptografia;
begin
   try
      try
         vCripto := TCriptografia.Create;
         vAlias  := TStringList.Create;

         vCaminhoBd := '';
         vUsuario   := '';
         vSenha     := '';

         if((Trim(GetEnvironmentVariable(PChar('CAMINHOBANCORESULTH'))) <> '') and
            (Trim(GetEnvironmentVariable(PChar('USUARIOBANCORESULTH'))) <> '') and
            (Trim(GetEnvironmentVariable(PChar('SENHABANCORESULTH'  ))) <> '')) then
         begin
            vCaminhoBd := Trim(GetEnvironmentVariable(PChar('CAMINHOBANCORESULTH')));
            vUsuario   := Trim(GetEnvironmentVariable(PChar('USUARIOBANCORESULTH')));
            vSenha     := Trim(GetEnvironmentVariable(PChar('SENHABANCORESULTH'  )));
         end;

         vCaminho := UpperCase(Trim(ExtractFilePath(Application.ExeName)));

         if (vCaminho <> '') and
            (Copy(vCaminho,Length(vCaminho),1) <> '\') then
            vCaminho := vCaminho + '\';

         if FileExists(vCaminho + 'Caminho.ini') then
         begin
            vArqIni := TMemIniFile.Create(vCaminho + 'Caminho.ini');

            vCaminhoBd := vArqIni.ReadString('DATABASENF', 'Caminho', '');
            vUsuario   := vArqIni.ReadString('DATABASENF', 'Usuario', '');
            vSenha     := vArqIni.ReadString('DATABASENF', 'Senha',   '');

            if (vCaminhoBd = '') and
               (vUsuario   = '') and
               (vSenha     = '') then
            begin
               vCaminhoBd := vArqIni.ReadString('DATABASEESTOQUE', 'Caminho', '');
               vUsuario   := vArqIni.ReadString('DATABASEESTOQUE', 'Usuario', '');
               vSenha     := vArqIni.ReadString('DATABASEESTOQUE', 'Senha',   '');
            end;

            if Trim(vUsuario) <> '' then
               vUsuario := vCripto.decriptaString(vUsuario);

            if Trim(vSenha) <> '' then
               vSenha   := vCripto.decriptaString(vSenha);
         end
         else
         if FileExists(vCaminho + 'Caminho.Dir') then
         begin
            AssignFile(vArq,vCaminho + 'Caminho.Dir');
            {$I-}
            Reset(vArq);                 // Abre um  arquivo já existente.
            {$I+}
            Read(vArq,vTextoArq);

            vCaminhoBd := vTextoArq;
            vUsuario   := 'SYSDBA';
            vSenha     := 'masterkey';
         end
         else
         if (vCaminhoBd = '') and (vUsuario = '') and (vSenha = '') then
         begin
            Session.GetAliasParams('RESULTH',vAlias);
            vCaminhoBd := vAlias[0];
            vCaminhoBd := Copy(vCaminhoBd,POS('=',vCaminhoBd)+1,255);
            vCaminhoBd := Copy(vCaminhoBd,1,(Length(vCaminhoBd)));
            vUsuario := 'SYSDBA';
            vSenha   := 'masterkey';
         end;

         if FileExists(vCaminho + 'Resulth.ini') then
         begin
            vArqIni := TMemIniFile.Create(vCaminho + 'Resulth.ini');

            vUsuario := vArqIni.ReadString('Conexao', 'Usuario', '');
            vSenha   := vArqIni.ReadString('Conexao', 'Senha',   '');

            if Trim(vUsuario) <> '' then
               vUsuario := vCripto.decriptaString(vUsuario)
            else
               vUsuario := 'SYSDBA';

            if Trim(vSenha) <> '' then
               vSenha   := vCripto.decriptaString(vSenha)
            else
               vSenha   := 'masterkey';
               
         end;

         //Conexão ResulthCheckout
         if FileExists(vCaminho + 'ResulthCheckout.ini') then
         begin
            vArqIni := TMemIniFile.Create(vCaminho + 'ResulthCheckout.ini');

            vCaminhoBd := vArqIni.ReadString('CONEXAO', 'Caminho', '');
            vUsuario := vArqIni.ReadString('CONEXAO', 'Usuario', '');
            vSenha   := vArqIni.ReadString('CONEXAO', 'Senha',   '');

            if Trim(vUsuario) = '' then
               vUsuario := 'SYSDBA';

            if Trim(vSenha) <> '' then
               vSenha   := vCripto.DecriptaASCII(vSenha,Length(vSenha)Div 3)
            else
               vSenha   := 'masterkey';

         end;
      finally
         FreeAndNil(vCripto);
         FreeAndNil(vAlias);
      end;
   except
      on E: Exception do
      begin
         raise Exception.Create('Não foi possível conectar ao banco de dados. '+#13+
                                E.Message);
      end;
   end;
end;

function TConexao.iniciaTransacao(pId: Integer = 1; pConexao: TSQLConnection = Nil): Boolean;
var
   xSQLConnection: TSQLConnection;
begin
   xSQLConnection := pConexao;

   if xSQLConnection = Nil then
      xSQLConnection := getConn;

   if pId = vTransaction.TransactionID then
      if xSQLConnection.InTransaction then
         Exit;   

   try
      vTransaction.TransactionID  := 1;
      vTransaction.IsolationLevel := xilREADCOMMITTED;

      xSQLConnection.StartTransaction(vTransaction);
   except
      on E : Exception do
         raise Exception.Create('Não foi possível iniciar a transação. '+#13+
                                E.Message);
   end;
end;

function TConexao.confirmaTransacao(pId: Integer = 1; pConexao: TSQLConnection = Nil): Boolean;
var
   xSQLConnection: TSQLConnection;
begin
   xSQLConnection := pConexao;

   if xSQLConnection = Nil then
      xSQLConnection := vConexao;

   if Not xSQLConnection.InTransaction then
      Exit;

   try
      vTransaction.TransactionID  := 1;
      vTransaction.IsolationLevel := xilREADCOMMITTED;

      xSQLConnection.Commit(vTransaction);
   except
      on E : Exception do
         raise Exception.Create('Não foi possível confirmar a transação. '+#13+
                                E.Message);
   end;
end;

function TConexao.cancelaTransacao(pId: Integer = 1; pConexao: TSQLConnection = Nil): Boolean;
var
   xSQLConnection: TSQLConnection;
begin
   xSQLConnection := pConexao;

   if xSQLConnection = Nil then
      xSQLConnection := vConexao;

   if Not xSQLConnection.InTransaction then
      Exit;

   try
      vTransaction.TransactionID  := 1;
      vTransaction.IsolationLevel := xilREADCOMMITTED;

      xSQLConnection.Rollback(vTransaction);
   except
      on E : Exception do
         raise Exception.Create('Não foi possível cancelar a transação. '+#13+
                                E.Message);
   end;
end;

function TConexao.getCaminhoBanco: String;
begin
   carregaParametros;
   Result := vCaminhoBd;
end;

class function TConexao.get: TConexao;
begin
   result := self.getInstance;
end;

procedure TConexao.DefineConexao(pConexao: TSQLConnection);
begin
   if vConexao <> nil then
   begin
      vConexao.Close;
      vConexao := Nil;
   end;
   
   vConexao := pConexao;
end;

procedure TConexao.FechaConexao;
begin
   if vConexao <> nil then
      vConexao.Close;
end;

end.
