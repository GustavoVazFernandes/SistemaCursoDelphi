unit UUnidadeProdutosController;

interface

uses SysUtils, Math, StrUtils, UConexao, UUnidadeProdutos;

type
  TUnidadeProdutosController = class
     public
        constructor Create;
        function GravaUnidadeProdutos(
        pUnidadeProdutos: TUnidadeProdutos) : Boolean;

        function ExcluiUnidadeProdutos(
        pUnidadeProdutos : TUnidadeProdutos): Boolean;

        function PesquisaUnidadeProdutos (pNome : String ) : TColUnidadeProdutos;
        function BuscaUnidadeProdutos(pID: integer): TUnidadeProdutos;
        function RetornaCondicaoUnidadeProdutos (
        pID_UnidadeProdutos : Integer;
        pRelacionada:Boolean = False ) : String;
     published
        class function getInstancia: TUnidadeProdutosController;
  end;

implementation

uses UUnidadeProdutosDAO;

var
   _instance : TUnidadeProdutosController;

{ TUnidadeProdutosController }

function TUnidadeProdutosController.BuscaUnidadeProdutos(pID: integer):
    TUnidadeProdutos;

   var
     xUnidadeProdutosDAO : TUnidadeProdutosDAO;
begin
   try
      try
         Result:= nil;

         xUnidadeProdutosDAO :=
            TUnidadeProdutosDAO.Create(TConexao.getInstance.getConn);
         Result := xUnidadeProdutosDAO.Retorna(
            RetornaCondicaoUnidadeProdutos(pID));

      finally
         if (xUnidadeProdutosDAO <> nil) then
            FreeAndNil(xUnidadeProdutosDAO);

      end;

   except
      on E: Exception do
      begin
          raise Exception.Create(
          'Falha ao buscar os dados da unidade dos produtos. [Controller]'#13+
          e.Message);
      end;
   end;
end;


constructor TUnidadeProdutosController.Create;
begin
   inherited Create;
end;

function TUnidadeProdutosController.ExcluiUnidadeProdutos(
  pUnidadeProdutos: TUnidadeProdutos): Boolean;

   var
   xUnidadeProdutosDAO : TUnidadeProdutosDAO ;
begin
   try
      try
         Result:= False;

         TConexao.get.iniciaTransacao;

         xUnidadeProdutosDAO:= TUnidadeProdutosDAO.Create(TConexao.get.getConn);


         if pUnidadeProdutos.Id = 0 then
            Exit
         else
            xUnidadeProdutosDAO.Deleta(RetornaCondicaoUnidadeProdutos(
               pUnidadeProdutos.Id));

         TConexao.get.confirmaTransacao;

         Result:= True;
      finally
         if xUnidadeProdutosDAO <> nil then
            FreeAndNil(xUnidadeProdutosDAO);
      end;


   except
       on E: Exception do
       begin
          TConexao.get.cancelaTransacao;
          raise Exception.Create(
             'Falha ao excluir os dados da unidade de produto [Controller]'#13+
             e.Message);
       end;
   end;
end;


class function TUnidadeProdutosController.getInstancia: TUnidadeProdutosController;
begin
   if _instance = nil then
      _instance  := TUnidadeProdutosController.Create;

   Result  := _instance;

end;

function TUnidadeProdutosController.GravaUnidadeProdutos(
  pUnidadeProdutos: TUnidadeProdutos): Boolean;
var
   xUnidadeProdutosDAO   : TUnidadeProdutosDAO;
begin
   try
      try
         TConexao.get.iniciaTransacao;

         Result := False;

         xUnidadeProdutosDAO :=
            TUnidadeProdutosDAO.Create (TConexao.get.getConn);

         if pUnidadeProdutos.Id = 0 then
            xUnidadeProdutosDAO.Insere(pUnidadeProdutos)

         else
         begin
            xUnidadeProdutosDAO.Atualiza(
            pUnidadeProdutos, RetornaCondicaoUnidadeProdutos(
               pUnidadeProdutos.Id));
         end;

         TConexao.get.confirmaTransacao;

      finally
         if xUnidadeProdutosDAO <> nil then
            FreeAndNil(xUnidadeProdutosDAO);
      end;

   except
       on E: Exception do
       begin
          TConexao.get.cancelaTransacao;
          Raise Exception.Create(
          'Falha ao gravar os dados da unidade de produto [Controller].'#13 +
          e.Message);
       end;

   end;
end;

function TUnidadeProdutosController.PesquisaUnidadeProdutos(
  pNome: String): TColUnidadeProdutos;

   var
   xUnidadeProdutosDAO : TUnidadeProdutosDAO;
   xCondicao : string;
begin
   try
      try
         Result := nil;

         xUnidadeProdutosDAO := TUnidadeProdutosDAO.Create(TConexao.get.getConn);

         xCondicao :=
            IfThen(pNome <> EmptyStr,
               'WHERE                                         '#13+
               '        (DESCRICAO LIKE UPPER (''%'+ pNome +'%'')) '#13+
               'ORDER BY DESCRICAO, ID', EmptyStr);

         Result := xUnidadeProdutosDAO.RetornaLista(xCondicao);
      finally
         if xUnidadeProdutosDAO <> nil then
            FreeAndNil(xUnidadeProdutosDAO);
      end;
   except
      on E:Exception do
      begin
         Raise Exception.Create(
         'Falha ao buscar ao dados da unidade de produto'#13+
         e.Message);
      end;
   end;
end;

function TUnidadeProdutosController.RetornaCondicaoUnidadeProdutos(
  pID_UnidadeProdutos: Integer; pRelacionada: Boolean): String;
var
   xChave : string;
begin
   if(pRelacionada = True) then
      xChave := 'ID_UNIDADEPRODUTO'
   else
      xChave := 'ID';

   Result :=
   'WHERE'#13+
   '     '+xChave + ' = '+ QuotedStr(IntToStr(pID_UnidadeProdutos))+' '#13;


end;


end.
 