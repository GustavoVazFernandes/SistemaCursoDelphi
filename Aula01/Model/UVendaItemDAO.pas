unit UVendaItemDAO;

interface

uses
   SqlExpr, DBXpress, SimpleDS, Db, Classes, SysUtils, DateUtils, StdCtrls,
   UGenericDAO, UVendaItem;

type

   TVendaItemDAO = class (TGenericDAO)
      public
         constructor Create(pConexao : TSQLConnection);
         function Insere(pVendaItem: TVendaItem) : Boolean;
         function InsereLista(pColVendaItem : TcolVendaItem): Boolean;
         function Atualiza(pVendaItem : TVendaItem; pCondicao : String): Boolean ;
         function Retorna (pCondicao: string): TVendaItem;
         function RetornaLista (pCondicao : string = ''): TcolVendaItem;

   end;

implementation

{TVendaItemDAO}

function TVendaItemDAO.Atualiza(pVendaItem: TVendaItem; pCondicao: String): Boolean;
begin
   Result := inherited Atualiza(pVendaItem, pCondicao);
end;

constructor TVendaItemDAO.Create(pConexao: TSQLConnection);
begin
   inherited Create;
   vEntidade := 'VENDA_ITEM';
   vConexao := pConexao;
   vClass := TVendaItem;
end;

function TVendaItemDAO.Insere(pVendaItem: TVendaItem): Boolean;
begin
   Result := inherited Insere(pVendaItem, 'ID');
end;

function TVendaItemDAO.InsereLista(pColVendaItem: TcolVendaItem): Boolean;
begin
   Result := inherited InsereLista(pColVendaItem);
end;

function TVendaItemDAO.Retorna(pCondicao: string): TVendaItem;
begin
   Result := TVendaItem (inherited Retorna(pCondicao));
end;

function TVendaItemDAO.RetornaLista(pCondicao: string): TcolVendaItem;
begin
   Result:= TcolVendaItem (inherited RetornaLista(pCondicao));
end;

end.
 