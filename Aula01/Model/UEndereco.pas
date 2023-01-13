unit UEndereco;

interface

uses SysUtils,Classes;

type
   TEndereco = class (TPersistent)

      private
         vID              : Integer;
         vID_Pessoa       : Integer;
         vTipo_Endereco   : Integer;
         vEndereco        : String;
         vNumero          : String;
         vComplemento     : string;
         vBairro          : String;
         vUF              : String;
         vCidade          : String;

      public
         Constructor Create;
      published
         property ID             : Integer  read vId            write vId;
         property ID_Pessoa      : Integer  read vID_Pessoa     write vID_Pessoa;
         property Tipo_Endereco  : Integer  read vTipo_Endereco write vTipo_Endereco;
         property Endereco       : String   read vEndereco      write vEndereco;
         property Numero         : String   read vNumero        write vNumero;
         property Complemento    : string   read vComplemento   write vComplemento;
         property Bairro         : String   read vBairro        write vBairro;
         property UF             : String   read vUF            write vUF;
         property Cidade         : String   read vCidade        write vCidade;
   end;

   TColEndereco = class (TList)
      public
         function Retorna (pIndex : Integer) : TEndereco;
         procedure Adiciona (pEndereco : TEndereco);

   end;


                                          
implementation

{ TColEndereco }

procedure TColEndereco.Adiciona(pEndereco: TEndereco);
begin
   Self.Add(TEndereco(pEndereco));
end;

function TColEndereco.Retorna(pIndex: Integer): TEndereco;
begin
   Result:= TEndereco(Self[pIndex]);
end;

{ TEndereco }

constructor TEndereco.Create;
begin
   Self.vId            := 0;
   Self.vID_Pessoa     := 0;
   Self.vTipo_Endereco := 0;
   Self.vEndereco      := EmptyStr;
   Self.vNumero        := EmptyStr;
   Self.vComplemento   := EmptyStr;
   Self.vBairro        := EmptyStr;
   Self.vUF            := EmptyStr;
   Self.vCidade        := EmptyStr;
end;

end.

