unit UVendaController;

interface

uses SysUtils, Math, StrUtils, UConexao, UVenda, UVendaItem;

type
  TVendaController = class
     public
        constructor Create;
        function GravaVenda(
                    pVenda: TVenda;
                    pColVendaItem : TColVendaItem) : Boolean;

        function ExcluiVenda(pVenda : TVenda): Boolean;

        function BuscaVendaItem(pID_Venda: Integer) : TColVendaItem;

        function PesquisaVenda (pID : String ) : TColVenda;
        function BuscaVenda(pID: integer): TVenda;
        function RetornaCondicaoVenda (
        pID_Venda : Integer;
        pRelacionada:Boolean = False ) : String;
     published
        class function getInstancia: TVendaController;
  end;

implementation

uses UVendaDAO, UVendaItemDAO;

var
   _instance : TVendaController;

{TVendaController}

function TVendaController.BuscaVendaItem(
  pID_Venda: Integer): TColVendaItem;
var
   xVendaItemDAO: TVendaItemDAO;
begin
   try
       try
         Result := nil;

         xVendaItemDAO:=
            TVendaItemDAO.Create(TConexao.getInstance.getConn);

         Result:=
            xVendaItemDAO.RetornaLista(RetornaCondicaoVenda(pID_Venda, True));

      finally
          if xVendaItemDAO <> nil then
          FreeAndNil(xVendaItemDAO)
      end;
   except
      on E: Exception do
      begin
         raise Exception.Create(
         'Falha ao retornar dados dos itens da venda [Controller]:'#13+
         e.Message);
      end;
   end;
end;

function TVendaController.BuscaVenda(pID: integer): TVenda;
  var
     xVendaDAO : TVendaDAO;
begin
   try
      try
         Result:= nil;

         xVendaDAO := TVendaDAO.Create(TConexao.getInstance.getConn);
         Result := xVendaDAO.Retorna(RetornaCondicaoVenda(pID));

      finally
         if (xVendaDAO <> nil) then
            FreeAndNil(xVendaDAO);

      end;

   except
      on E: Exception do
      begin
          raise Exception.Create(
          'Falha ao buscar os dados da venda. [Controller]'#13+
          e.Message);
      end;
   end;

end;

constructor TVendaController.Create;
begin
   inherited Create;
end;

function TVendaController.ExcluiVenda(pVenda: TVenda): Boolean;
var
   xVendaDAO : TVendaDAO;
   xVendaItemDAO: TVendaItemDAO;
begin
   try
      try
         Result:= False;

         TConexao.get.iniciaTransacao;

         xVendaDAO:= TVendaDAO.Create(TConexao.get.getConn);
         xVendaItemDAO:= TVendaItemDAO.Create(TConexao.get.getConn);

         if pVenda.Id = 0 then
            Exit
         else
         begin
            xVendaDAO.Deleta(RetornaCondicaoVenda(pVenda.Id));

            xVendaItemDAO.Deleta(RetornaCondicaoVenda(pVenda.Id, True));
         end;

         TConexao.get.confirmaTransacao;

         Result:= True;
      finally
         if xVendaDAO <> nil then
            FreeAndNil(xVendaDAO);
         if xVendaItemDAO <> nil then
            FreeAndNil(xVendaItemDAO);

      end;


   except
       on E: Exception do
       begin
          TConexao.get.cancelaTransacao;
          raise Exception.Create(
             'Falha ao excluir os dados da venda [Controller]'#13+
             e.Message);
       end;
   end;
end;

class function TVendaController.getInstancia: TVendaController;
begin
   if _instance = nil then
      _instance  := TVendaController.Create;


   Result  := _instance;

end;

function TVendaController.GravaVenda(
         pVenda: TVenda;
         pColVendaItem : TColVendaItem ): Boolean;
var
   xVendaDAO   : TVendaDAO;
   xVendaItemDAO : TVendaItemDAO;
   xAux: Integer;
   i : Integer;

begin
   try
      try
         TConexao.get.iniciaTransacao;

         Result := False;

         xVendaDAO :=
            TVendaDAO.Create (TConexao.get.getConn);

         xVendaItemDAO :=
            TVendaItemDAO.Create (TConexao.get.getConn);


            if pVenda.Id = 0 then
            begin
               xVendaDAO.Insere(pVenda);

               for xAux := 0 to pred(pColVendaItem.Count) do
                  pColVendaItem.Retorna(xAux).ID_Venda := pVenda.Id;

               xVendaItemDAO.InsereLista(pColVendaItem);
            end
            else
            begin
               xVendaDAO.Atualiza(pVenda, RetornaCondicaoVenda(pVenda.Id));
            end;

         TConexao.get.confirmaTransacao;

      finally
         if xVendaDAO <> nil then
            FreeAndNil(xVendaDAO);
         if xVendaItemDAO <> nil then
            FreeAndNil(xVendaItemDAO);
      end;

   except
      on E: Exception do
      begin
         TConexao.get.cancelaTransacao;
         Raise Exception.Create(
         'Falha ao gravar os dados da venda [Controller].'#13 +
         e.Message);
      end;

   end;
end;


function TVendaController.PesquisaVenda(pID: String): TColVenda;
var
   xVendaDAO : TVendaDAO;
   xCondicao : string;
begin
   try
      try
         Result := nil;

         xVendaDAO := TVendaDAO.Create(TConexao.get.getConn);

         xCondicao :=
            IfThen(pID <> EmptyStr,
               'WHERE                                         '#13+
               '        (ID LIKE UPPER (''%'+ pID +'%'')) '#13+
               'ORDER BY ID, DATAVENDA', EmptyStr);

         Result := xVendaDAO.RetornaLista(xCondicao);
      finally
         if xVendaDAO <> nil then
            FreeAndNil(xVendaDAO);
      end;
   except
      on E:Exception do
      begin
         Raise Exception.Create(
         'Falha ao buscar ao dados da venda'#13+
         e.Message);
      end;
   end;
end;

function TVendaController.RetornaCondicaoVenda(
  pID_Venda: Integer; pRelacionada : Boolean): String;
var
   xChave : string;
begin
   if(pRelacionada = True) then
      xChave := 'ID_VENDA'
   else
      xChave := 'ID';

   Result :=
   'WHERE'#13+
   '     '+xChave + ' = '+ QuotedStr(IntToStr(pID_Venda))+' '#13;


end;

end.




