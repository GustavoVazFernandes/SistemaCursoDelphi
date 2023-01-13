unit UEnderecoDAO;

interface

uses
   SqlExpr, DBXpress, SimpleDS, Db, Classes, SysUtils, DateUtils, StdCtrls,
   UGenericDAO, UEndereco;

type

   TEnderecoDAO = class (TGenericDAO)
      public
         constructor Create(pConexao : TSQLConnection);
         function Insere(pEndereco: TEndereco) : Boolean;
         function InsereLista(pColEndereco : TColEndereco): Boolean;
         function Atuliza(pEndereco : TEndereco; pCondicao : String): Boolean ;
         function Retorna (pCondicao: string): TEndereco;
         function RetornaLista (pCondicao : string = ''): TColEndereco;

   end;
implementation

{ TEnderecoDAO }

function TEnderecoDAO.Atuliza(pEndereco: TEndereco;
  pCondicao: String): Boolean;
begin
   Result := inherited Atualiza(pEndereco, pCondicao);
end;

constructor TEnderecoDAO.Create(pConexao: TSQLConnection);
begin
   inherited Create;
   vEntidade := 'ENDERECO';
   vConexao := pConexao;
   vClass := TEndereco;
end;

function TEnderecoDAO.Insere(pEndereco: TEndereco): Boolean;
begin
   Result := inherited Insere(pEndereco, 'ID');
end;

function TEnderecoDAO.InsereLista(pColEndereco: TColEndereco): Boolean;
begin
   Result := inherited InsereLista(pColEndereco);
end;

function TEnderecoDAO.Retorna(pCondicao: string): TEndereco;
begin
   Result := TEndereco (inherited Retorna(pCondicao));
end;

function TEnderecoDAO.RetornaLista(pCondicao: string): TColEndereco;
begin
   Result:= TColEndereco (inherited RetornaLista(pCondicao));
end;

end.
