unit Dao.Produtos;

interface

uses
  System.Classes, System.Sysutils,
  FireDAC.Stan.Param, FireDAC.Comp.Client,
  Controller.DeclTiposConsts, Model.Produtos;

type
  TDaoProdutos = class(TObject)
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
    procedure InformaParams(var AModelProdutos: TModelProdutos; AFDQuery: TFDQuery);
  public
    // Constructor Create;   // Veja comentário abaixo.
    // Destructor Destroy; override;  // Veja comentário abaixo.
    function Ler(ValorPK: Integer; AModelProdutos: TModelProdutos): Boolean;
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

    function Incluir(AModelProdutos: TModelProdutos; out Erro: String): Boolean;
    function Alterar(AModelProdutos: TModelProdutos; out Erro: String): Boolean;
    function Excluir(AModelProdutos: TModelProdutos; out Erro: String): Boolean;
    procedure MontaSQLIncluir(AModelProdutos: TModelProdutos; AFDQuery: TFDQuery);
    procedure MontaSQLAlterar(AModelProdutos: TModelProdutos; AFDQuery: TFDQuery);
    procedure MontaSQLExcluir(AModelProdutos: TModelProdutos; AFDQuery: TFDQuery);
  end;

implementation

{ TDaoProdutos }

uses JSonUtils, FuncStrings, Controller.Conexao;

//  constructor TDaoProdutos.Create;
//  begin
//    inherited Create;
//    // Aqui ficam linhas para classes descendentes quando há necessidades diferentes do Create.
//  end;

//  destructor TDaoProdutos.Destroy;
//  begin
//    // Aqui ficam linhas para classes descendentes quando há necessidades diferentes do Destroy.
//    inherited;
//  end;

// Obtenção da próxima chave primária quando aplicável.
function TDaoProdutos.ProximoCodigo: Integer;
var
  AFDQuery: TFDQuery;
begin
  AFDQuery := TControllerConexao.GetInstance.DaoConexao.CriarQuery;
  try
    AFDQuery.SQL.Add('SELECT MAX(CODIGO) FROM PRODUTOS');
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

function TDaoProdutos.Incluir(AModelProdutos: TModelProdutos; out Erro: String): Boolean;
var
  AFDQuery: TFDQuery;
  AFDTransaction: TFDTransaction;
begin
  Result := False;
  AFDQuery := TControllerConexao.GetInstance.DaoConexao.CriarQuery;
  AFDTransaction := TControllerConexao.GetInstance.DaoConexao.CriarTransaction;
  try
    // Informa chave primaria
    AModelProdutos.CODIGO := ProximoCodigo;
    TControllerConexao.GetInstance.DaoConexao.ConfigQueryTransac(AFDQuery, AFDTransaction);

    MontaSQLIncluir(AModelProdutos, AFDQuery);

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

procedure TDaoProdutos.MontaSQLIncluir(AModelProdutos: TModelProdutos; AFDQuery: TFDQuery);
begin
  AFDQuery.SQL.Clear;
  AFDQuery.SQL.Text := 'INSERT INTO PRODUTOS'
                     + '('
                     + '  CODIGO'
                     + ', DESCRICAO'
                     + ', PRECOVENDA'
                     + ', ATIVO'
                     + ')'
                     + 'VALUES'
                     + '('
                     + '  :CODIGO'
                     + ', :DESCRICAO'
                     + ', :PRECOVENDA'
                     + ', :ATIVO'
                     + ')';

  InformaParams(AModelProdutos, AFDQuery);

end;

function TDaoProdutos.Alterar(AModelProdutos: TModelProdutos; out Erro: String): Boolean;
var
  AFDQuery: TFDQuery;
  AFDTransaction: TFDTransaction;
begin
  Result := False;
  AFDQuery := TControllerConexao.GetInstance.DaoConexao.CriarQuery;
  AFDTransaction := TControllerConexao.GetInstance.DaoConexao.CriarTransaction;
  try
    TControllerConexao.GetInstance.DaoConexao.ConfigQueryTransac(AFDQuery, AFDTransaction);

    MontaSQLAlterar(AModelProdutos, AFDQuery);

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

procedure TDaoProdutos.MontaSQLAlterar(AModelProdutos: TModelProdutos; AFDQuery: TFDQuery);
begin
  AFDQuery.SQL.Clear;
  AFDQuery.SQL.Text := 'UPDATE PRODUTOS SET'
                     + '  CODIGO = :CODIGO'
                     + ', DESCRICAO = :DESCRICAO'
                     + ', PRECOVENDA = :PRECOVENDA'
                     + ', ATIVO = :ATIVO'
                     // Cláusula WHERE para individualizar o registro a ser gravado (atualizado).
                     + ' WHERE CODIGO = ' + IntToStr(AModelProdutos.CODIGO);

  InformaParams(AModelProdutos, AFDQuery);

end;

function TDaoProdutos.Ler(ValorPK: Integer; AModelProdutos: TModelProdutos): Boolean;
var
  AFDQuery: TFDQuery;
begin
  Result := False;
  AFDQuery := TControllerConexao.GetInstance.DaoConexao.CriarQuery;
  try
    AModelProdutos.InicializaValores;
    AFDQuery.SQL.Add('SELECT * FROM PRODUTOS');
    // Cláusula WHERE para individualizar o registro a ser gravado (atualizado).
    AFDQuery.SQL.Add(' WHERE CODIGO = ' + IntToStr(ValorPK));
    AFDQuery.Open;

    if AFDQuery.RecordCount > 0 then
    begin
      Result := True;
      AModelProdutos.CODIGO := AFDQuery.Fields.FieldByName('CODIGO').AsInteger;
      AModelProdutos.DESCRICAO := AFDQuery.Fields.FieldByName('DESCRICAO').AsString;
      AModelProdutos.PRECOVENDA := AFDQuery.Fields.FieldByName('PRECOVENDA').AsFloat;
      AModelProdutos.ATIVO := AFDQuery.Fields.FieldByName('ATIVO').AsString;
    end;
  finally
    FreeAndNil(AFDQuery);
  end;

end;

function TDaoProdutos.ListaJSon(ValorPesquisa,
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

function TDaoProdutos.RegistroJSon(CamposVisiveis: String; ValorPK: Integer): String;
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

function TDaoProdutos.PodeExcluir: Boolean;
begin
  Result := True; // A ser implementado.
end;

function TDaoProdutos.Excluir(AModelProdutos: TModelProdutos; out Erro: String): Boolean;
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

    MontaSQLExcluir(AModelProdutos, AFDQuery);

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

procedure TDaoProdutos.MontaSQLExcluir(AModelProdutos: TModelProdutos; AFDQuery: TFDQuery);
begin
  AFDQuery.SQL.Clear;
  AFDQuery.SQL.Add('DELETE FROM PRODUTOS');
  // Cláusula WHERE para individualizar o registro a ser deletado.
  AFDQuery.SQL.Add(' WHERE CODIGO = ' + IntToStr(AModelProdutos.CODIGO));

end;

procedure TDaoProdutos.InformaParams(var AModelProdutos: TModelProdutos; AFDQuery: TFDQuery);
var
  I: Integer;
begin

  for I := 0 to AFDQuery.Params.Count - 1 do
    AFDQuery.Params[I].Clear;

  AFDQuery.ParamByName('CODIGO').AsInteger := AModelProdutos.CODIGO;
  AFDQuery.ParamByName('DESCRICAO').AsString := AModelProdutos.DESCRICAO;
  AFDQuery.ParamByName('PRECOVENDA').AsFloat := AModelProdutos.PRECOVENDA;
  AFDQuery.ParamByName('ATIVO').AsString := AModelProdutos.ATIVO;

end;

function TDaoProdutos.ExecutaListarJSon(ValorPesquisa,
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
      AFDQuery.SQL.Add(' PRODUTOS.CODIGO AS " CÓDIGO ",');
    if ExisteCampo('DESCRICAO', CamposVisiveis) then
      AFDQuery.SQL.Add(' PRODUTOS.DESCRICAO AS " DESCRIÇÃO ",');
    if ExisteCampo('PRECOVENDA', CamposVisiveis) then
      AFDQuery.SQL.Add(' PRODUTOS.PRECOVENDA AS " PREÇO DE VENDA ",');
    if ExisteCampo('ATIVO', CamposVisiveis) then
      AFDQuery.SQL.Add(' PRODUTOS.ATIVO,');

    // Elimina última vírgula
    AFDQuery.SQL[AFDQuery.SQL.Count - 1] := Copy(AFDQuery.SQL[AFDQuery.SQL.Count - 1], 1, Length(AFDQuery.SQL[AFDQuery.SQL.Count - 1]) - 1);

    AFDQuery.SQL.Add('FROM PRODUTOS');

    if (ValorPK = 0) then // retorna lista pesquisada
    begin
      AFDQuery.SQL.Add('WHERE PRODUTOS.CODIGO <> 0');

      if ValorPesquisa <> EmptyStr then
      begin
        case ModoPesquisa of
          mpComecaCom:
            AFDQuery.SQL.Add('AND PRODUTOS.' + CampoPesquisa + ' LIKE ''' + ValorPesquisa + '%''');
          mpContem:
            AFDQuery.SQL.Add('AND PRODUTOS.' + CampoPesquisa + ' LIKE ''%' + ValorPesquisa + '''');
          mpIgual:
            AFDQuery.SQL.Add('AND PRODUTOS.' + CampoPesquisa + ' = ''' + ValorPesquisa + '''');
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
      AFDQuery.SQL.Add('WHERE PRODUTOS.CODIGO = ' + IntToStr(ValorPK));
    end;

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
