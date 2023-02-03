unit UVenda;

interface

uses SysUtils, Classes;

type
   TVenda = Class(TPersistent)


      private
         vId           : Integer;
         vId_Cliente   : Integer;
         vDataVenda    : TDateTime;
         vFaturada     : Integer;
         vTotalVenda   : Double;


      public
         constructor Create;
      published
         property Id          : Integer    read vId            write vId;
         property Id_Cliente  : Integer    read vId_Cliente    write vId_Cliente;
         property DataVenda   : TDateTime  read vDataVenda     write vDataVenda;
         property Faturada    : Integer    read vFaturada      write vFaturada;
         property TotalVenda  : Double     read vTotalVenda    write vTotalVenda;

      end;

      TColVenda = class (TList)
      public
         function Retorna(pIndex : Integer) : TVenda;
         procedure Adiciona(pVenda : TVenda);

      end;

implementation

{ TColVenda }

procedure TColVenda.Adiciona(pVenda: TVenda);
begin
   Self.Add(TVenda(pVenda));
end;

function TColVenda.Retorna(pIndex: Integer): TVenda;
begin
   Result := TVenda(Self[pIndex]);
end;

{ TVenda }

constructor TVenda.Create;
begin
   Self.vId                  :=0;
   Self.vId_Cliente          :=0;
   Self.vDataVenda           := Date;
   Self.vFaturada            :=0;
   Self.vTotalVenda          :=0;
end;

end.
