unit UVendaItem;

interface

uses SysUtils, Classes;

type
   TVendaItem = Class(TPersistent)


      private
         vId           : Integer;
         vId_Venda     : Integer;
         vId_Produto   : Integer;
         vQuantidade   : Double;
         vUnidadeSaida : String;
         vTotalItem    : Double;
         vValorUnitario: Double;

      public
         constructor Create;
      published
         property Id            : Integer   read vId            write vId;
         property Id_Venda      : Integer   read vId_Venda      write vId_Venda;
         property Id_Produto    : Integer   read vId_Produto    write vId_Produto;
         property Quantidade    : Double    read vQuantidade    write vQuantidade;
         property UnidadeSaida  : String    read vUnidadeSaida  write vUnidadeSaida;
         property TotalItem     : Double    read vTotalItem     write vTotalItem;
         property ValorUnitario : Double    read vValorUnitario write vValorUnitario;
      end;

      TColVendaItem = class (TList)
      public
         function Retorna(pIndex : Integer) : TVendaItem;
         procedure Adiciona(pVendaItem : TVendaItem);

      end;

implementation

{ TColVenda }

procedure TColVendaItem.Adiciona(pVendaItem: TVendaItem);
begin
   Self.Add(TVendaItem(pVendaItem));
end;

function TColVendaItem.Retorna(pIndex: Integer): TVendaItem;
begin
   Result := TVendaItem(Self[pIndex]);
end;

{ TVenda }

constructor TVendaItem.Create;
begin
   Self.vId            := 0;
   Self.vId_Venda      := 0;
   Self.vId_Produto    := 0;
   Self.vQuantidade    := 0;
   Self.vUnidadeSaida  := EmptyStr;
   Self.vTotalItem     := 0;
   Self.vValorUnitario := 0;
end;


end.
