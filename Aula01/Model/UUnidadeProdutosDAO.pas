unit UUnidadeProdutosDAO;

interface
uses
   SqlExpr, DBXpress, SimpleDS, Db, Classes, SysUtils, DateUtils, StdCtrls,
   UGenericDAO, UUnidadeProdutos;

type

   TUnidadeProdutosDAO = class (TGenericDAO)
      public
         constructor Create(pConexao : TSQLConnection);
         function Insere(pUnidadeProdutos: TUnidadeProdutos) : Boolean;
         function Atualiza(pUnidadeProdutos : TUnidadeProdutos; pCondicao : String): Boolean ;
         function Retorna (pCondicao: string): TUnidadeProdutos;
         function RetornaLista (pCondicao : string = ''): TColUnidadeProdutos;

end;

implementation

{ TUnidadeProdutosDAO }

function TUnidadeProdutosDAO.Atualiza(pUnidadeProdutos: TUnidadeProdutos;
  pCondicao: String): Boolean;
begin
   Result := inherited Atualiza(pUnidadeProdutos, pCondicao);
end;

constructor TUnidadeProdutosDAO.Create(pConexao: TSQLConnection);
begin
   inherited Create;
   vEntidade := 'UNIDADEPRODUTO';
   vConexao := pConexao;
   vClass := TUnidadeProdutos;
end;

function TUnidadeProdutosDAO.Insere(
  pUnidadeProdutos: TUnidadeProdutos): Boolean;
begin
   Result := inherited Insere(pUnidadeProdutos, 'ID');
end;

function TUnidadeProdutosDAO.Retorna(pCondicao: string): TUnidadeProdutos;
begin
   Result := TUnidadeProdutos (inherited Retorna(pCondicao));
end;

function TUnidadeProdutosDAO.RetornaLista(
  pCondicao: string): TColUnidadeProdutos;
begin
   Result:= TColUnidadeProdutos (inherited RetornaLista(pCondicao));
end;

end.
 