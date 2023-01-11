unit UCliente;

interface

uses SysUtils, Classes, UPessoa;

type
   TCliente = class (TPessoa)

      private
         vBloqueado: Boolean;

      public
         constructor Create;
      published
         property Bloqueado : Boolean read vBloqueado write vBloqueado;


      end;

implementation

{ TCliente }

constructor TCliente.Create;
begin
   vBloqueado := False;
end;

end.
