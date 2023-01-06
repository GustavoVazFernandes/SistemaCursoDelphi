(*
   PARA UTILIZAR ESSA CLASSE:

      * VERIFIQUE SE SEU OBJETO E AS PROPRIEDADES DO
        MESMO ESTÃO HERDANDO DA CLASSE "TPersistent", OU ESTÃO ENTRE AS
        DIRETIVAS {$M+}...{$M-} OU {$TYPEINFO+}...{$TYPEINFO-};

      * AS PROPRIEDADES DEVEM ESTAR DECLARADAS COMO "Published".

      * CASO SEU OBJETO POSSUA PROPRIEDADES QUE NÃO EXISTEM NO BANCO DE DADOS
        OU QUE NÃO ESTEJA COM O NOME IDENTICO AO CAMPO NO BANCO, DECLARE-AS EM
        "Public" PARA ELAS NÃO SEREM IDENTIFICADAS NOS MÉTODOS DESTA CLASSE. O
        TRATAMENTO DELAS DEVERÁ SER REALIZADA NOS DAOs ESPECÍFICOS DAS MESMAS SE
        NECESSÁRIO.

      * CASO SEU OBJETO POSSUA PROPRIEDADES DO TIPO BOOLEAN, ESTA CLASSE ENTENDE
        QUE O VALOR NO BANCO DE DADOS ASSOCIADO A ELA É DO TIPO INTEIRO
        ("False = 0" e "True = 1"), CASO A SUA PROPRIEDADE FUJA DESTE PADRÃO, O
        TRATAMENTO PARA O PREENCHIMENTO E LEITURA DESTA PROPRIEADE DEVE SER
        CORRIGIDO NO SEU DAO RESPECTIVO.

      * CASO SEU OBJETO POSSUA PROPRIEDADES DO TIPO ENUMERATION, ESTA CLASSE
        ENTENDE QUE O VALOR NO BANCO DE DADOS ASSOCIADO A ELA É DO TIPO INTEIRO
        (0, 1, 2, 3...), CASO A SUA PROPRIEDADE FUJA DESTE PADRÃO, O TRATAMENTO
        PARA PREENCIMENTO E LEITURA DESTA PROPRIEDADE DEVE SER CORRIGIDO NO SEU
        DAO RESPECTIVO.
*)
unit UGenericDAO;

interface

uses
   DB, SqlExpr, Classes;

type
   TGenericDAO = class
   protected
      vClass: TClass;
      vEntidade: String;
      vConexao: TSQLConnection;

      vSQLUpdate: String;
      vCamposParametros: String;
   private
      function RetornaQryInsert: String;
      function RetornaQryUpdate: String;
      function RetornaQryUpdateInsert(pMatching: String): String;
      function RetornaCamposParametros: String;

      constructor Create;
   public
      function PreencheObjeto(pDataSet: TDataSet): TObject; virtual;
      function PreencheParametros(pQry: TSQLQuery; pObjeto: TObject): Boolean; virtual;

      function Insere(pObjeto: TObject; pReturn: String = ''): Boolean;
      function Deleta(pCondicao: String): Boolean;
      function Atualiza(pObjeto: TObject; pCondicao: String): Boolean;
      function AtualizaOuInsere(pObjeto: TObject; pMatching: String; pReturn: String = ''): Boolean;
      function InsereLista(pLista: TList): Boolean;
      function Retorna(pCondicao: String): TObject;
      function RetornaLista(pCondicao: String): TList;
      function RetornaCampoDefault(pCondicao, pCampo: String; pDefault: Variant): Variant;
      function Existe(pCondicao: String): Boolean;
   end;

implementation

uses
   {$IFDEF CTE}
      Util.Funcoes
   {$ELSE}
      UClassFuncoes
   {$ENDIF},
   SysUtils, Variants;

{ TGenericDAO }

function TGenericDAO.Atualiza(pObjeto: TObject;
   pCondicao: String): Boolean;
var
   xQry : TSQLQuery;
begin
   Result := False;

   if vEntidade = '' then
      raise Exception.Create('Entidade não definida.');

   try
      try
         xQry := TSQLQuery.Create(Nil);
         xQry.SQLConnection := vConexao;

         xQry.SQL.Text := RetornaQryUpdate;

         if pCondicao <> '' then
            if Pos('WHERE', UpperCase(pCondicao)) > 0 then
               xQry.SQL.Add(pCondicao)
            else
               xQry.SQL.Add(' WHERE ' + pCondicao);

         xQry.Prepared := True;
         
         PreencheParametros(xQry, pObjeto);

         xQry.ExecSQL;

         Result := True;
      finally
         if xQry <> nil then
         begin
            xQry.Close;
            FreeAndNil(xQry);
         end;
      end;
   except
      on E: Exception do
         raise Exception.Create(
            'Não foi possível atualizar o registro na tabela '+ vEntidade +'. '+
            E.Message);
   end;
end;

function TGenericDAO.AtualizaOuInsere(pObjeto: TObject;
   pMatching, pReturn: String): Boolean;
var
   xQry: TSQLQuery;
begin
   Result := False;

   if vEntidade = '' then
      raise Exception.Create('Entidade não definida.');
   
   try
      try
         xQry := TSQLQuery.Create(Nil);
         xQry.SQLConnection := vConexao;
         xQry.SQL.Text := RetornaQryUpdateInsert(pMatching);

         if pReturn <> '' then
            xQry.SQL.Add('RETURNING '+ pReturn);

         PreencheParametros(xQry, pObjeto);

         if pReturn <> '' then
         begin
            xQry.Open;
            {$IFDEF CTE}
               TFuncoes.get.PreenchePropriedade(
                  pObjeto, pReturn, xQry.FieldByName(pReturn).Value);
            {$ELSE}
               TFuncoes.PreenchePropriedade(
                  pObjeto, pReturn, xQry.FieldByName(pReturn).Value);
            {$ENDIF}
         end
         else
            xQry.ExecSQL;

         Result := True;
      finally
         if xQry <> nil then
         begin
            xQry.Close;
            FreeAndNil(xQry);
         end;
      end;
   except
      on E: Exception do
         raise Exception.Create(
            'Não foi possível inserir o registro da tabela '+ vEntidade +'. '+
            E.Message);
   end;
end;

constructor TGenericDAO.Create;
begin
   vSQLUpdate        := '';
   vCamposParametros := '';
end;

function TGenericDAO.Deleta(pCondicao: String): Boolean;
var
   xQry : TSQLQuery;
begin    
   Result := False;

   if vEntidade = '' then
      raise Exception.Create('Entidade não definida.');

   try
      try
         xQry := TSQLQuery.Create(Nil);
         xQry.SQLConnection := vConexao;

         xQry.SQL.Text := 'DELETE FROM '+ vEntidade;

         if pCondicao <> '' then
            if Pos('WHERE', UpperCase(pCondicao)) > 0 then
               xQry.SQL.Add(pCondicao)
            else
               xQry.SQL.Add(' WHERE '+ pCondicao);

         xQry.ExecSQL;

         Result := True;
      finally
         if xQry <> nil then
         begin
            xQry.Close;
            FreeAndNil(xQry);
         end;
      end;
   except
      on E: Exception do
         raise Exception.Create(
            'Não foi possível excluir o registro da tabela '+ vEntidade +'. '+
            E.Message);
   end;
end;

function TGenericDAO.Existe(pCondicao: String): Boolean;
begin
   Result := RetornaCampoDefault(pCondicao, '*', False);
end;

function TGenericDAO.Insere(pObjeto: TObject; pReturn: String): Boolean;
var
   xQry: TSQLQuery;
begin
   Result := False;

   if vEntidade = '' then
      raise Exception.Create('Entidade não definida.');

   try
      try
         xQry := TSQLQuery.Create(Nil);
         xQry.SQLConnection := vConexao;
         xQry.SQL.Text := RetornaQryInsert;

         if pReturn <> '' then
            xQry.SQL.Add('RETURNING '+ pReturn);

         PreencheParametros(xQry, pObjeto);

         if pReturn <> '' then
         begin
            xQry.Open;
            {$IFDEF CTE}
               TFuncoes.get.PreenchePropriedade(
                  pObjeto, pReturn, xQry.FieldByName(pReturn).Value);
            {$ELSE}
               TFuncoes.PreenchePropriedade(
                  pObjeto, pReturn, xQry.FieldByName(pReturn).Value);
            {$ENDIF}
         end
         else
            xQry.ExecSQL;

         Result := True;
      finally
         if xQry <> nil then
         begin
            xQry.Close;
            FreeAndNil(xQry);
         end;
      end;
   except
      on E: Exception do
         raise Exception.Create(
            'Não foi possível inserir o registro da tabela '+ vEntidade +'. '+
            E.Message);
   end;
end;

function TGenericDAO.InsereLista(pLista: TList): Boolean;
var
   I: Integer;
begin
   Result := False;

   for I := 0 to Pred(pLista.Count) do
      Insere(pLista[I]);

   Result := True;
end;

function TGenericDAO.PreencheObjeto(pDataSet: TDataSet): TObject;
var
   I: Integer;
begin
   Result := vClass.NewInstance;

   for I := 0 to Pred(pDataSet.FieldCount) do
      if pDataSet.Fields[I].Value <> Null then
         {$IFDEF CTE}
            TFuncoes.get.PreenchePropriedade(
               Result, pDataSet.Fields[I].FieldName, pDataSet.Fields[I].Value);
         {$ELSE}
            TFuncoes.PreenchePropriedade(
               Result, pDataSet.Fields[I].FieldName, pDataSet.Fields[I].Value);
         {$ENDIF}
end;

function TGenericDAO.PreencheParametros(pQry: TSQLQuery;
   pObjeto: TObject): Boolean;
var
   I: Integer;
   xValor: Variant;
begin
   for I := 0 to Pred(pQry.Params.Count) do
   begin
      {$IFDEF CTE}
         xValor := TFuncoes.get.ValorPropriedade(pObjeto, pQry.Params[I].Name);
      {$ELSE}
         xValor := TFuncoes.ValorPropriedade(pObjeto, pQry.Params[I].Name);
      {$ENDIF}

      if VarType(xValor) = varDate then
      begin
         pQry.Params[I].DataType := ftDate;

         if xValor = 0 then
            pQry.Params[I].Clear
         else
            pQry.Params[I].AsString :=
               FormatDateTime('dd.mm.yyyy hh:mm:ss', xValor);

         Continue;
      end
      else
      if VarType(xValor) = varInt64 then
      begin
         pQry.Params[I].AsInteger := xValor;
         Continue;
      end
      else
      if VarType(xValor) = varBoolean then
      begin
         if xValor then
            pQry.Params[I].AsInteger := 1
         else
            pQry.Params[I].AsInteger := 0;

         Continue;
      end;

      pQry.Params[I].Value := xValor;
   end;
end;

function TGenericDAO.Retorna(pCondicao: String): TObject;
var
   xQry: TSQLQuery;
begin
   Result := Nil;

   if vEntidade = '' then
      raise Exception.Create('Entidade não definida.');

   try
      try
         xQry := TSQLQuery.Create(Nil);
         xQry.SQLConnection := vConexao;

         xQry.SQL.Text :=
            'SELECT *       '#13+
            '  FROM '+ vEntidade;

         if pCondicao <> '' then
            if Pos('WHERE', UpperCase(pCondicao)) > 0 then
               xQry.SQL.Add(pCondicao)
            else
               xQry.SQL.Add(' WHERE ' + pCondicao);

         xQry.Open;

         if xQry.IsEmpty then
            Exit;

         Result := PreencheObjeto(xQry);
      finally
         if xQry <> nil then
         begin
            xQry.Close;
            FreeAndNil(xQry);
         end;
      end;
   except
      on E: Exception do
         raise Exception.Create(
            'Não foi possível retornar o registro da tabela '+ vEntidade +'. '+
            E.Message);
   end;
end;

function TGenericDAO.RetornaCampoDefault(pCondicao, pCampo: String;
   pDefault: Variant): Variant;
var
   xQry: TSQLQuery;
begin
   Result := pDefault;

   if vEntidade = '' then
      raise Exception.Create('Entidade não definida.');
      
   try
      try
         xQry := TSQLQuery.Create(Nil);
         xQry.SQLConnection := vConexao;

         xQry.SQL.Text :=
            'SELECT FIRST 1 '+ pCampo   +#13+
            '  FROM '+ vEntidade;

         if pCondicao <> '' then
            if Pos('WHERE', UpperCase(pCondicao)) > 0 then
               xQry.SQL.Add(pCondicao)
            else
               xQry.SQL.Add(' WHERE ' + pCondicao);

         xQry.Open;

         if xQry.IsEmpty then
            Exit;

         if pCampo = '*' then
            Result := True
         else
         if not xQry.FieldByName(pCampo).IsNull then
            Result := xQry.FieldByName(pCampo).Value;
      finally
         if xQry <> nil then
         begin
            xQry.Close;
            FreeAndNil(xQry);
         end;
      end;
   except
      on E: Exception do
         raise Exception.Create(
            'Não foi possível retornar o registro da tabela '+ vEntidade +'. '+
            E.Message);
   end;
end;

function TGenericDAO.RetornaCamposParametros: String;
var
   I: Integer;
   xList: TStrings;
   xObject: TObject;
begin
   if vCamposParametros <> '' then
   begin
      Result := vCamposParametros;
      Exit;
   end;

   try                                                   
      xObject := vClass.NewInstance;
      {$IFDEF CTE}
         xList := TFuncoes.get.RetornaListaPropriedades(xObject);
      {$ELSE}
         xList := TFuncoes.RetornaListaPropriedades(xObject);
      {$ENDIF}

      Result  := '(';
      
      for I := 0 to Pred(xList.Count) do
      begin
         if I = Pred(xList.Count) then
            Result := Result +#13'       '+ xList[I]
         else
            Result := Result +#13'       '+ xList[I] +',';
      end;

      Result := Result +#13')'#13'VALUES(';

      for I := 0 to Pred(xList.Count) do
      begin
         if I = Pred(xList.Count) then
            Result := Result +#13'       :'+ xList[I]
         else
            Result := Result +#13'       :'+ xList[I] +',';
      end;

      Result := Result +#13')';
   finally
      if xList <> Nil then
         FreeAndNil(xList);
         
      if xObject <> Nil then
         FreeAndNil(xObject);
   end;

   vCamposParametros := Result;
end;

function TGenericDAO.RetornaLista(pCondicao: String): TList;
var
   xQry: TSQLQuery;
begin    
   Result := nil;

   if vEntidade = '' then
      raise Exception.Create('Entidade não definida.');
      
   try
      try
         xQry := TSQLQuery.Create(Nil);
         xQry.SQLConnection := vConexao;

         xQry.SQL.Text :=
            'SELECT *       '#13+
            '  FROM '+ vEntidade;

         if pCondicao <> '' then
            if Pos('WHERE', UpperCase(pCondicao)) > 0 then
               xQry.SQL.Add(pCondicao)
            else
               xQry.SQL.Add(' WHERE '+ pCondicao);

         xQry.Open;

         if xQry.IsEmpty then
            Exit;

         Result := TList.Create;

         while not xQry.Eof do
         begin
            Result.Add(PreencheObjeto(xQry));

            xQry.Next;
         end;
      finally
         if xQry <> nil then
         begin
            xQry.Close;
            FreeAndNil(xQry);
         end;
      end;
   except
      on E: Exception do
         raise Exception.Create(
            'Não foi possível retornar os registros da tabela '+ vEntidade +
            '. '+ E.Message);
   end;
end;

function TGenericDAO.RetornaQryInsert: String;
begin
   Result := 'INSERT INTO '+ vEntidade + RetornaCamposParametros;
end;

function TGenericDAO.RetornaQryUpdate: String;
var
   I: Integer;
   xObject: TObject;
   xList: TStrings;
begin
   if vSQLUpdate <> '' then
   begin
      Result := vSQLUpdate;
      Exit;
   end;

   try
      xObject := vClass.NewInstance;
      {$IFDEF CTE}
         xList := TFuncoes.get.RetornaListaPropriedades(xObject);
      {$ELSE}
         xList := TFuncoes.RetornaListaPropriedades(xObject);
      {$ENDIF}
      Result  := 'UPDATE '+ vEntidade +' SET';

      for I := 0 to Pred(xList.Count) do
      begin
         if I = Pred(xList.Count) then
            Result := Result +#13'       '+ xList[I] +' = :'+ xList[I]
         else
            Result := Result +#13'       '+ xList[I] +' = :'+ xList[I] +',';
      end;
   finally
      if xList <> Nil then
         FreeAndNil(xList);

      if xObject <> Nil then
         FreeAndNil(xObject);
   end;

   vSQLUpdate := Result;
end;

function TGenericDAO.RetornaQryUpdateInsert(pMatching: String): String;
begin
   Result :=
      'UPDATE OR INSERT INTO '+ vEntidade + RetornaCamposParametros +
      #13'MATCHING('+ pMatching +')';
end;

end.

