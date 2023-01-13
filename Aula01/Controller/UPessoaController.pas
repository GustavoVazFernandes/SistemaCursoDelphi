unit UPessoaController;

interface

uses SysUtils, Math, StrUtils, UConexao, UPessoa;

type
  TPessoaController = class
     public
        constructor Create;
        function GravaPessoa(
                    pPessoa: TPessoa) : Boolean;

        function ExcluiPessoa(pPessoa : TPessoa): Boolean;

        function BuscaPessoa(pID: integer): TPessoa;
        function RetornaCondicaoPessoa (pID_Pessoa : Integer) : String;
     published
        class function getInstancia: TPessoaController;
  end;



implementation

uses UPessoaDAO;

var
   _instance : TPessoaController;

{ TPessoaController }

function TPessoaController.BuscaPessoa(pID: integer): TPessoa;
  var
     xPessoaDAO : TPessoaDAO;
begin
   try
      try
         Result:= nil;

         xPessoaDAO := TPessoaDAO.Create(TConexao.getInstance.getConn);
         Result := xPessoaDAO.Retorna(RetornaCondicaoPessoa(pID));

      finally
         if (xPessoaDAO <> nil) then
            FreeAndNil(xPessoaDAO);

      end;

   except
      on E: Exception do
      begin
          raise Exception.Create(
          'Falha ao buscar os dados da pessoa. [Controller]'#13+
          e.Message);
      end;
   end;

end;

constructor TPessoaController.Create;
begin
   inherited Create;
end;

function TPessoaController.ExcluiPessoa(pPessoa: TPessoa): Boolean;
var
   xPessoaDAO : TPessoaDAO;
begin
   try
      try
         Result:= False;

         TConexao.get.iniciaTransacao;

         xPessoaDAO:= TPessoaDAO.Create(TConexao.get.getConn);

         if pPessoa.Id = 0 then
            Exit
         else
         begin
            xPessoaDAO.Deleta(RetornaCondicaoPessoa(pPessoa.Id));
         end;

         TConexao.get.confirmaTransacao;

         Result:= True;
      finally
         if xPessoaDAO <> nil then
            FreeAndNil(xPessoaDAO);

      end;


   except
       on E: Exception do
       begin
          TConexao.get.cancelaTransacao;
          raise Exception.Create(
             'Falha ao excluir os dados da pessoa [Controller]'#13+
             e.Message);
       end;
   end;
end;

class function TPessoaController.getInstancia: TPessoaController;
begin
   if _instance = nil then
      _instance  := TPessoaController.Create;


   Result  := _instance;

end;

function TPessoaController.GravaPessoa(pPessoa: TPessoa): Boolean;
var
   xPessoaDAO: TPessoaDAO;
   xAux: Integer;

begin
   try
      try
         TConexao.get.iniciaTransacao;

         Result := False;

         xPessoaDAO :=
            TPessoaDAO.Create (TConexao.get.getConn);


         if pPessoa.Id = 0 then
         begin
            xPessoaDAO.Insere(pPessoa);

         end
         else
         begin
            xPessoaDAO.Atualiza(pPessoa, RetornaCondicaoPessoa(pPessoa.Id));

         end;

         TConexao.get.confirmaTransacao;

      finally
         if xPessoaDAO <> nil then
            FreeAndNil(xPessoaDAO);


      end;

   except
       on E: Exception do
       begin
          TConexao.get.cancelaTransacao;
          Raise Exception.Create(
          'Falha ao gravar os dados do cliente [Controller].'#13 +
          e.Message);
       end;

   end;
end;

function TPessoaController.RetornaCondicaoPessoa(
  pID_Pessoa: Integer): String;
var
   xChave : string;
begin
   xChave := 'ID';

   Result :=
   'WHERE'#13+
   '     '+xChave + ' = '+ QuotedStr(IntToStr(pID_Pessoa))+' '#13;


end;

end.
