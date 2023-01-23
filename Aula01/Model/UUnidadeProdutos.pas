unit UUnidadeProdutos;

interface

uses SysUtils, Classes;

type
   TUnidadeProdutos = class (TPersistent)

   private
         vId                      : Integer;
         vAtivo                   : Boolean;
         vUnidade                 : String;
         vDescricao               : string;

   public
        constructor Create;
       published
         property Id                      : Integer read vId                  write vId;
         property Ativo                   : Boolean read vAtivo               write vAtivo;
         property Unidade                 : string read vUnidade             write vUnidade;
         property Descricao               : String read vDescricao           write vDescricao;

   end;

   TColUnidadeProdutos = class (TList)
      public
         function Retorna(pIndex : Integer) : TUnidadeProdutos;
         procedure Adiciona(pUnidadeProdutos : TUnidadeProdutos);

   end;
implementation

{ TUnidadeProdutos }

constructor TUnidadeProdutos.Create;
begin
   Self.vId                  :=0;
   Self.vDescricao           := EmptyStr;
   Self.vUnidade             := EmptyStr;
   Self.vAtivo               := False;
end;

{ TColUnidadeProdutos }

procedure TColUnidadeProdutos.Adiciona(pUnidadeProdutos: TUnidadeProdutos);
begin
   Self.Add(TUnidadeProdutos(pUnidadeProdutos));
end;

function TColUnidadeProdutos.Retorna(pIndex: Integer): TUnidadeProdutos;
begin
   Result := TUnidadeProdutos(Self[pIndex]);
end;

end.                         
