unit Dao.Clientes;

interface

uses
  System.Classes, System.Sysutils,
  FireDAC.Stan.Param, FireDAC.Comp.Client,
  Controller.DeclTiposConsts, Model.Clientes;

type
  TDaoClientes = class(TObject)
  private
    function ExecutaListarJSon(ValorPesquisa,
                               CampoPesquisa,
                               CamposOrdem: String;
                               CamposVisiveis: String; // Campos separados por ","
                               ModoPesquisa: TModoPesquisa;
                               Descendente: Boolean;
                               PaginaAtual: Integer;
                               TamPagina: Word;
                               ValorPK: Integer): String;

  protected
    procedure InformaParams(var AModelClientes: TModelClientes; AFDQuery: TFDQuery);
  public
    // Constructor Create;   // Veja comentário abaixo.
    // Destructor Destroy; override;  // Veja comentário abaixo.
    function Ler(ValorPK: Integer; AModelClientes: TModelClientes): Boolean;
    function ListaJSon(ValorPesquisa,
                       CampoPesquisa,
                       CamposOrdem: String;
                       CamposVisiveis: String; // Campos separados por ","
                       ModoPesquisa: TModoPesquisa;
                       Descendente: Boolean;
                       PaginaAtual: Integer;
                       TamPagina: Word;
                       ValorPK: Integer): String;

    function RegistroJSon(CamposVisiveis: String; ValorPK: Integer): String;

    function PodeExcluir: Boolean;
    function ProximoCodigo: Integer;

    function Incluir(AModelClientes: TModelClientes; out Erro: String): Boolean;
    function Alterar(AModelClientes: TModelClientes; out Erro: String): Boolean;
    function Excluir(AModelClientes: TModelClientes; out Erro: String): Boolean;
    procedure MontaSQLIncluir(AModelClientes: TModelClientes; AFDQuery: TFDQuery);
    procedure MontaSQLAlterar(AModelClientes: TModelClientes; AFDQuery: TFDQuery);
    procedure MontaSQLExcluir(AModelClientes: TModelClientes; AFDQuery: TFDQuery);
  end;

implementation

{ TDaoClientes }

uses JSonUtils, FuncStrings, Controller.Conexao;

//  constructor TDaoClientes.Create;
//  begin
//    inherited Create;
//    // Aqui ficam linhas para classes descendentes quando há necessidades diferentes do Create.
//  end;

//  destructor TDaoClientes.Destroy;
//  begin
//    // Aqui ficam linhas para classes descendentes quando há necessidades diferentes do Destroy.
//    inherited;
//  end;

// Obtenção da próxima chave primária quando aplicável.
function TDaoClientes.ProximoCodigo: Integer;
var
  AFDQuery: TFDQuery;
begin
  AFDQuery := TControllerConexao.GetInstance.DaoConexao.CriarQuery;
  try
    AFDQuery.SQL.Add('SELECT MAX(CODIGO) FROM CLIENTES');
    try
      AFDQuery.Open;
      Result := AFDQuery.Fields[0].AsInteger + 1;
    except
      Result := 0;
    end;

  finally
    FreeAndNil(AFDQuery);
  end;

end;

function TDaoClientes.Incluir(AModelClientes: TModelClientes; out Erro: String): Boolean;
var
  AFDQuery: TFDQuery;
  AFDTransaction: TFDTransaction;
begin
  Result := False;
  AFDQuery := TControllerConexao.GetInstance.DaoConexao.CriarQuery;
  AFDTransaction := TControllerConexao.GetInstance.DaoConexao.CriarTransaction;
  try
    // Informa chave primaria
    AModelClientes.CODIGO := ProximoCodigo;
    TControllerConexao.GetInstance.DaoConexao.ConfigQueryTransac(AFDQuery, AFDTransaction);

    MontaSQLIncluir(AModelClientes, AFDQuery);

    try
      AFDTransaction.StartTransaction;
      AFDQuery.ExecSQL;
      AFDTransaction.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        AFDTransaction.Rollback;
        Erro := 'Ocorreu um erro ao incluir: ' + #13 + E.Message;
      end;
    end;

  finally
    FreeAndNil(AFDQuery);
    FreeAndNil(AFDTransaction);
  end;

end;

procedure TDaoClientes.MontaSQLIncluir(AModelClientes: TModelClientes; AFDQuery: TFDQuery);
begin
  AFDQuery.SQL.Clear;
  AFDQuery.SQL.Text := 'INSERT INTO CLIENTES'
                     + '('
                     + '  CODIGO'
                     + ', NOME'
                     + ', CIDADE'
                     + ', UF'
                     + ', ATIVO'
                     + ')'
                     + 'VALUES'
                     + '('
                     + '  :CODIGO'
                     + ', :NOME'
                     + ', :CIDADE'
                     + ', :UF'
                     + ', :ATIVO'
                     + ')';

  InformaParams(AModelClientes, AFDQuery);

end;

function TDaoClientes.Alterar(AModelClientes: TModelClientes; out Erro: String): Boolean;
var
  AFDQuery: TFDQuery;
  AFDTransaction: TFDTransaction;
begin
  Result := False;
  AFDQuery := TControllerConexao.GetInstance.DaoConexao.CriarQuery;
  AFDTransaction := TControllerConexao.GetInstance.DaoConexao.CriarTransaction;
  try
    TControllerConexao.GetInstance.DaoConexao.ConfigQueryTransac(AFDQuery, AFDTransaction);

    MontaSQLAlterar(AModelClientes, AFDQuery);

    try
      AFDTransaction.StartTransaction;
      AFDQuery.ExecSQL;
      AFDTransaction.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        AFDTransaction.Rollback;
        Erro := 'Ocorreu um erro ao salvar: ' + #13 + E.Message;
      end;
    end;

  finally
    FreeAndNil(AFDQuery);
    FreeAndNil(AFDTransaction);
  end;

end;

procedure TDaoClientes.MontaSQLAlterar(AModelClientes: TModelClientes; AFDQuery: TFDQuery);
begin
  AFDQuery.SQL.Clear;
  AFDQuery.SQL.Text := 'UPDATE CLIENTES SET'
                     + '  CODIGO = :CODIGO'
                     + ', NOME = :NOME'
                     + ', CIDADE = :CIDADE'
                     + ', UF = :UF'
                     + ', ATIVO = :ATIVO'
                     // Cláusula WHERE para individualizar o registro a ser gravado (atualizado).
                     + ' WHERE CODIGO = ' + IntToStr(AModelClientes.CODIGO);

  InformaParams(AModelClientes, AFDQuery);

end;

function TDaoClientes.Ler(ValorPK: Integer; AModelClientes: TModelClientes): Boolean;
var
  AFDQuery: TFDQuery;
begin
  Result := False;
  AFDQuery := TControllerConexao.GetInstance.DaoConexao.CriarQuery;
  try
    AModelClientes.InicializaValores;
    AFDQuery.SQL.Add('SELECT * FROM CLIENTES');
    // Cláusula WHERE para individualizar o registro a ser gravado (atualizado).
    AFDQuery.SQL.Add(' WHERE CODIGO = ' + IntToStr(ValorPK));
    AFDQuery.Open;

    if AFDQuery.RecordCount > 0 then
    begin
      Result := True;
      AModelClientes.CODIGO := AFDQuery.Fields.FieldByName('CODIGO').AsInteger;
      AModelClientes.NOME := AFDQuery.Fields.FieldByName('NOME').AsString;
      AModelClientes.CIDADE := AFDQuery.Fields.FieldByName('CIDADE').AsString;
      AModelClientes.UF := AFDQuery.Fields.FieldByName('UF').AsString;
      AModelClientes.ATIVO := AFDQuery.Fields.FieldByName('ATIVO').AsString;
    end;
  finally
    FreeAndNil(AFDQuery);
  end;

end;

function TDaoClientes.ListaJSon(ValorPesquisa,
                                CampoPesquisa,
                                CamposOrdem: String;
                                CamposVisiveis: String; // Campos separados por ","
                                ModoPesquisa: TModoPesquisa;
                                Descendente: Boolean;
                                PaginaAtual: Integer;
                                TamPagina: Word;
                                ValorPK: Integer): String;
begin
  Result := ExecutaListarJSon(ValorPesquisa,
                              CampoPesquisa,
                              CamposOrdem,
                              CamposVisiveis,
                              ModoPesquisa,
                              Descendente,
                              PaginaAtual,
                              TamPagina,
                              0);
end;

function TDaoClientes.RegistroJSon(CamposVisiveis: String; ValorPK: Integer): String;
begin
  Result := ExecutaListarJSon('',
                              '',
                              '',
                              CamposVisiveis,
                              mpComecaCom,
                              False,
                              1,
                              20,
                              ValorPK);
end;

function TDaoClientes.PodeExcluir: Boolean;
begin
  Result := True; // A ser implementado.
end;

function TDaoClientes.Excluir(AModelClientes: TModelClientes; out Erro: String): Boolean;
var
  AFDQuery: TFDQuery;
  AFDTransaction: TFDTransaction;
begin
  Result := False;
  if not PodeExcluir then
  begin
    Erro := 'Exclusão não permitida.';
    Exit;
  end;
  AFDQuery := TControllerConexao.GetInstance.DaoConexao.CriarQuery;
  AFDTransaction := TControllerConexao.GetInstance.DaoConexao.CriarTransaction;
  try
    TControllerConexao.GetInstance.DaoConexao.ConfigQueryTransac(AFDQuery, AFDTransaction);

    MontaSQLExcluir(AModelClientes, AFDQuery);

    try
      AFDTransaction.StartTransaction;
      AFDQuery.ExecSQL;
      AFDTransaction.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        AFDTransaction.Rollback;
        Erro := 'Ocorreu um erro ao excluir: ' + #13 + E.Message;
      end;
    end;

  finally
    FreeAndNil(AFDQuery);
    FreeAndNil(AFDTransaction);
  end;

end;

procedure TDaoClientes.MontaSQLExcluir(AModelClientes: TModelClientes; AFDQuery: TFDQuery);
begin
  AFDQuery.SQL.Clear;
  AFDQuery.SQL.Add('DELETE FROM CLIENTES');
  // Cláusula WHERE para individualizar o registro a ser deletado.
  AFDQuery.SQL.Add(' WHERE CODIGO = ' + IntToStr(AModelClientes.CODIGO));

end;

procedure TDaoClientes.InformaParams(var AModelClientes: TModelClientes; AFDQuery: TFDQuery);
var
  I: Integer;
begin

  for I := 0 to AFDQuery.Params.Count - 1 do
    AFDQuery.Params[I].Clear;

  AFDQuery.ParamByName('CODIGO').AsInteger := AModelClientes.CODIGO;
  AFDQuery.ParamByName('NOME').AsString := AModelClientes.NOME;
  AFDQuery.ParamByName('CIDADE').AsString := AModelClientes.CIDADE;
  AFDQuery.ParamByName('UF').AsString := AModelClientes.UF;
  AFDQuery.ParamByName('ATIVO').AsString := AModelClientes.ATIVO;

end;

function TDaoClientes.ExecutaListarJSon(ValorPesquisa,
                                        CampoPesquisa,
                                        CamposOrdem: String;
                                        CamposVisiveis: String; // Campos separados por ","
                                        ModoPesquisa: TModoPesquisa;
                                        Descendente: Boolean;
                                        PaginaAtual: Integer;
                                        TamPagina: Word;
                                        ValorPK: Integer): String;
var
  AFDQuery: TFDQuery;
  AJson: String;
  StrTamPagina, StrSkip: String;
  Skip: Integer;
begin
  AFDQuery := TControllerConexao.GetInstance.DaoConexao.CriarQuery;
  try
    StrTamPagina := IntToStr(TamPagina);
    if PaginaAtual <= 0 then
      PaginaAtual := 1;
    Skip := (PaginaAtual - 1) * TamPagina;
    StrSkip := IntToStr(Skip);

    CamposVisiveis := UpperCase(CamposVisiveis);

    AFDQuery.SQL.Add('SELECT');
    if ExisteCampo('CODIGO', CamposVisiveis) then
      AFDQuery.SQL.Add(' CLIENTES.CODIGO AS " CÓDIGO ",');
    if ExisteCampo('NOME', CamposVisiveis) then
      AFDQuery.SQL.Add(' CLIENTES.NOME AS " NOME DO CLIENTE ",');
    if ExisteCampo('CIDADE', CamposVisiveis) then
      AFDQuery.SQL.Add(' CLIENTES.CIDADE,');
    if ExisteCampo('UF', CamposVisiveis) then
      AFDQuery.SQL.Add(' CLIENTES.UF,');
    if ExisteCampo('ATIVO', CamposVisiveis) then
      AFDQuery.SQL.Add(' CLIENTES.ATIVO,');

    // Elimina última vírgula
    AFDQuery.SQL[AFDQuery.SQL.Count - 1] := Copy(AFDQuery.SQL[AFDQuery.SQL.Count - 1], 1, Length(AFDQuery.SQL[AFDQuery.SQL.Count - 1]) - 1);

    AFDQuery.SQL.Add('FROM CLIENTES');

    if (ValorPK = 0) then // retorna lista pesquisada
    begin
      AFDQuery.SQL.Add('WHERE CLIENTES.CODIGO <> 0');

      if ValorPesquisa <> EmptyStr then
      begin
        // Descomentar só para campos tipo VARCHAR ou CHAR
        //if CampoPesquisa = 'NOME' then
        //  CampoPesquisa := CampoPesquisa + ' collate WIN_PTBR ';

        case ModoPesquisa of
          mpComecaCom:
            AFDQuery.SQL.Add('AND CLIENTES.' + CampoPesquisa + ' starting with ''' + ValorPesquisa + '''');
          mpContem:
            AFDQuery.SQL.Add('AND CLIENTES.' + CampoPesquisa + ' containing ''' + ValorPesquisa + '''');
          mpIgual:
            AFDQuery.SQL.Add('AND CLIENTES.' + CampoPesquisa + ' = ''' + ValorPesquisa + '''');
        end;
      end;

      if (CamposOrdem <> EmptyStr) then
      begin
        if Descendente then
          CamposOrdem := CamposOrdem + ' DESC';

        AFDQuery.SQL.Add('ORDER BY ' + CamposOrdem);
      end;

    end
    else // retorna apenas um registro
    begin
      AFDQuery.SQL.Add('WHERE CLIENTES.CODIGO = ' + IntToStr(ValorPK));
    end;

    AFDQuery.SQL.Add('LIMIT ' + StrTamPagina + ' OFFSET ' + StrSkip + '');

    AFDQuery.Open;

    AJson := '';
    if AFDQuery.RecordCount <> 0 then
      DataSetToJson(AFDQuery, AJson)
    else
      AJson := '';

    Result := AJson;

  finally
    FreeAndNil(AFDQuery);
  end;

end;

end.
