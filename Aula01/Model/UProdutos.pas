unit UProdutos;

interface

uses SysUtils, Classes;

type
   TProduto = Class(TPersistent)


      private
         vId                      : Integer;
         vNome                    : String;
         vPrecoVenda              : Double;
         vUnidadeSaida            : string;



      public
         constructor Create;
      published
         property Id            : Integer read vId            write vId;
         property Nome          : String  read vNome          write vNome;
         property PrecoVenda    : Double  read vPrecoVenda    write vPrecoVenda;
         property UnidadeSaida  : String read vUnidadeSaida  write vUnidadeSaida;

      end;

   TColProduto = class (TList)
      public
         function Retorna(pIndex : Integer) : TProduto;
         procedure Adiciona(pProduto : TProduto);

   end;

implementation

{ TColProduto }

procedure TColProduto.Adiciona(pProduto: TProduto);
begin
   Self.Add(TProduto(pProduto));
end;

function TColProduto.Retorna(pIndex: Integer): TProduto;
begin
   Result := TProduto(Self[pIndex]);
end;

{ TPessoa }

constructor TProduto.Create;
begin
   Self.vId                  :=0;
   Self.vNome                := EmptyStr;
   Self.vPrecoVenda          := 0;
   Self.vUnidadeSaida        := EmptyStr;
end;

end.
 