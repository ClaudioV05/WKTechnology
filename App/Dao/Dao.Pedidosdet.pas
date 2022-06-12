unit Dao.Pedidosdet;

interface

uses
  System.Classes, System.Sysutils,
  FireDAC.Stan.Param, FireDAC.Comp.Client,
  Controller.DeclTiposConsts, Model.Pedidosdet;

type
  TDaoPedidosdet = class(TObject)
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
    procedure InformaParams(var AModelPedidosdet: TModelPedidosdet; AFDQuery: TFDQuery);
  public
    // Constructor Create;   // Veja comentário abaixo.
    // Destructor Destroy; override;  // Veja comentário abaixo.
    function Ler(ValorPK, Sequencial: Integer; AModelPedidosdet: TModelPedidosdet): Boolean;
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
    function ProximoSequencial(CodPedido: Integer): Integer;

    function Incluir(AModelPedidosdet: TModelPedidosdet; out Erro: String): Boolean;
    function Alterar(AModelPedidosdet: TModelPedidosdet; out Erro: String): Boolean;
    function Excluir(AModelPedidosdet: TModelPedidosdet; out Erro: String): Boolean;
    procedure MontaSQLIncluir(AModelPedidosdet: TModelPedidosdet; AFDQuery: TFDQuery);
    procedure MontaSQLAlterar(AModelPedidosdet: TModelPedidosdet; AFDQuery: TFDQuery);
    procedure MontaSQLExcluir(AModelPedidosdet: TModelPedidosdet; AFDQuery: TFDQuery);
  end;

implementation

{ TDaoPedidosdet }

uses JSonUtils, FuncStrings, Controller.Conexao;

//  constructor TDaoPedidosdet.Create;
//  begin
//    inherited Create;
//    // Aqui ficam linhas para classes descendentes quando há necessidades diferentes do Create.
//  end;

//  destructor TDaoPedidosdet.Destroy;
//  begin
//    // Aqui ficam linhas para classes descendentes quando há necessidades diferentes do Destroy.
//    inherited;
//  end;

// Obtenção da próxima chave primária quando aplicável.
function TDaoPedidosdet.ProximoCodigo: Integer;
var
  AFDQuery: TFDQuery;
begin
  AFDQuery := TControllerConexao.GetInstance.DaoConexao.CriarQuery;
  try
    AFDQuery.SQL.Add('SELECT MAX(CODIGO) FROM PEDIDOSDET');
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

function TDaoPedidosdet.ProximoSequencial(CodPedido: Integer): Integer;
var
  AFDQuery: TFDQuery;
begin
  AFDQuery := TControllerConexao.GetInstance.DaoConexao.CriarQuery;
  try
    AFDQuery.SQL.Add('SELECT MAX(SEQUENCIAL) AS SEQ FROM PEDIDOSDET');
    AFDQuery.SQL.Add('WHERE (CODIGO = :parCodigo)');
    AFDQuery.Params[0].AsInteger := CodPedido;

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

function TDaoPedidosdet.Incluir(AModelPedidosdet: TModelPedidosdet; out Erro: String): Boolean;
var
  AFDQuery: TFDQuery;
  AFDTransaction: TFDTransaction;
begin
  Result := False;
  AFDQuery := TControllerConexao.GetInstance.DaoConexao.CriarQuery;
  AFDTransaction := TControllerConexao.GetInstance.DaoConexao.CriarTransaction;
  try
    // Informa chave primaria
    //AModelPedidosdet.CODIGO := ProximoCodigo;
    TControllerConexao.GetInstance.DaoConexao.ConfigQueryTransac(AFDQuery, AFDTransaction);

    MontaSQLIncluir(AModelPedidosdet, AFDQuery);

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

procedure TDaoPedidosdet.MontaSQLIncluir(AModelPedidosdet: TModelPedidosdet; AFDQuery: TFDQuery);
begin
  AFDQuery.SQL.Clear;
  AFDQuery.SQL.Text := 'INSERT INTO PEDIDOSDET'
                     + '('
                     + '  CODIGO'
                     + ', SEQUENCIAL'
                     + ', CODPRODUTO'
                     + ', QUANTIDADE'
                     + ', PRECOUNITARIO'
                     + ', VALORTOTAL'
                     + ')'
                     + 'VALUES'
                     + '('
                     + '  :CODIGO'
                     + ', :SEQUENCIAL'
                     + ', :CODPRODUTO'
                     + ', :QUANTIDADE'
                     + ', :PRECOUNITARIO'
                     + ', :VALORTOTAL'
                     + ')';

  InformaParams(AModelPedidosdet, AFDQuery);

end;

function TDaoPedidosdet.Alterar(AModelPedidosdet: TModelPedidosdet; out Erro: String): Boolean;
var
  AFDQuery: TFDQuery;
  AFDTransaction: TFDTransaction;
begin
  Result := False;
  AFDQuery := TControllerConexao.GetInstance.DaoConexao.CriarQuery;
  AFDTransaction := TControllerConexao.GetInstance.DaoConexao.CriarTransaction;
  try
    TControllerConexao.GetInstance.DaoConexao.ConfigQueryTransac(AFDQuery, AFDTransaction);

    MontaSQLAlterar(AModelPedidosdet, AFDQuery);

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

procedure TDaoPedidosdet.MontaSQLAlterar(AModelPedidosdet: TModelPedidosdet; AFDQuery: TFDQuery);
begin
  AFDQuery.SQL.Clear;
  AFDQuery.SQL.Text := 'UPDATE PEDIDOSDET SET'
                     + '  CODIGO = :CODIGO'
                     + ', SEQUENCIAL = :SEQUENCIAL'
                     + ', CODPRODUTO = :CODPRODUTO'
                     + ', QUANTIDADE = :QUANTIDADE'
                     + ', PRECOUNITARIO = :PRECOUNITARIO'
                     + ', VALORTOTAL = :VALORTOTAL'
                     // Cláusula WHERE para individualizar o registro a ser gravado (atualizado).
                     + ' WHERE CODIGO = ' + IntToStr(AModelPedidosdet.CODIGO);

  InformaParams(AModelPedidosdet, AFDQuery);

end;

function TDaoPedidosdet.Ler(ValorPK, Sequencial: Integer; AModelPedidosdet: TModelPedidosdet): Boolean;
var
  AFDQuery: TFDQuery;
begin
  Result := False;
  AFDQuery := TControllerConexao.GetInstance.DaoConexao.CriarQuery;
  try
    AModelPedidosdet.InicializaValores;
    AFDQuery.SQL.Add('SELECT * FROM PEDIDOSDET');
    // Cláusula WHERE para individualizar o registro a ser gravado (atualizado).
    AFDQuery.SQL.Add(' WHERE CODIGO = ' + IntToStr(ValorPK));
    AFDQuery.SQL.Add(' AND SEQUENCIAL = ' + IntToStr(Sequencial));
    AFDQuery.Open;

    if AFDQuery.RecordCount > 0 then
    begin
      Result := True;
      AModelPedidosdet.CODIGO := AFDQuery.Fields.FieldByName('CODIGO').AsInteger;
      AModelPedidosdet.SEQUENCIAL := AFDQuery.Fields.FieldByName('SEQUENCIAL').AsInteger;
      AModelPedidosdet.CODPRODUTO := AFDQuery.Fields.FieldByName('CODPRODUTO').AsInteger;
      AModelPedidosdet.QUANTIDADE := AFDQuery.Fields.FieldByName('QUANTIDADE').AsFloat;
      AModelPedidosdet.PRECOUNITARIO := AFDQuery.Fields.FieldByName('PRECOUNITARIO').AsFloat;
      AModelPedidosdet.VALORTOTAL := AFDQuery.Fields.FieldByName('VALORTOTAL').AsFloat;
    end;
  finally
    FreeAndNil(AFDQuery);
  end;

end;

function TDaoPedidosdet.ListaJSon(ValorPesquisa,
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

function TDaoPedidosdet.RegistroJSon(CamposVisiveis: String; ValorPK: Integer): String;
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

function TDaoPedidosdet.PodeExcluir: Boolean;
begin
  Result := True; // A ser implementado.
end;

function TDaoPedidosdet.Excluir(AModelPedidosdet: TModelPedidosdet; out Erro: String): Boolean;
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

    MontaSQLExcluir(AModelPedidosdet, AFDQuery);

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

procedure TDaoPedidosdet.MontaSQLExcluir(AModelPedidosdet: TModelPedidosdet; AFDQuery: TFDQuery);
begin
  AFDQuery.SQL.Clear;
  AFDQuery.SQL.Add('DELETE FROM PEDIDOSDET');
  // Cláusula WHERE para individualizar o registro a ser deletado.
  AFDQuery.SQL.Add(' WHERE CODIGO = ' + IntToStr(AModelPedidosdet.CODIGO));
  AFDQuery.SQL.Add(' AND SEQUENCIAL = ' + IntToStr(AModelPedidosdet.SEQUENCIAL));

end;

procedure TDaoPedidosdet.InformaParams(var AModelPedidosdet: TModelPedidosdet; AFDQuery: TFDQuery);
var
  I: Integer;
begin

  for I := 0 to AFDQuery.Params.Count - 1 do
    AFDQuery.Params[I].Clear;

  AFDQuery.ParamByName('CODIGO').AsInteger := AModelPedidosdet.CODIGO;
  AFDQuery.ParamByName('SEQUENCIAL').AsInteger := AModelPedidosdet.SEQUENCIAL;
  AFDQuery.ParamByName('CODPRODUTO').AsInteger := AModelPedidosdet.CODPRODUTO;
  AFDQuery.ParamByName('QUANTIDADE').AsFloat := AModelPedidosdet.QUANTIDADE;
  AFDQuery.ParamByName('PRECOUNITARIO').AsFloat := AModelPedidosdet.PRECOUNITARIO;
  AFDQuery.ParamByName('VALORTOTAL').AsFloat := AModelPedidosdet.VALORTOTAL;

end;

function TDaoPedidosdet.ExecutaListarJSon(ValorPesquisa,
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

    AFDQuery.SQL.Add('SELECT FIRST ' + StrTamPagina + ' SKIP ' + StrSkip + '');
    if ExisteCampo('CODIGO', CamposVisiveis) then
      AFDQuery.SQL.Add(' PEDIDOSDET.CODIGO,');
    if ExisteCampo('SEQUENCIAL', CamposVisiveis) then
      AFDQuery.SQL.Add(' PEDIDOSDET.SEQUENCIAL AS " SEQUENCIAL ",');
    if ExisteCampo('CODPRODUTO', CamposVisiveis) then
      AFDQuery.SQL.Add(' PEDIDOSDET.CODPRODUTO AS " CÓDIGO ",');
    if ExisteCampo('DESCRICAO', CamposVisiveis) then
      AFDQuery.SQL.Add(' PRODUTOS.DESCRICAO AS " DESCRIÇÃO ",');
    if ExisteCampo('QUANTIDADE', CamposVisiveis) then
      AFDQuery.SQL.Add(' PEDIDOSDET.QUANTIDADE AS " QUANTIDADE ",');
    if ExisteCampo('PRECOUNITARIO', CamposVisiveis) then
      AFDQuery.SQL.Add(' PEDIDOSDET.PRECOUNITARIO AS " PR. UNIT ",');
    if ExisteCampo('VALORTOTAL', CamposVisiveis) then
      AFDQuery.SQL.Add(' PEDIDOSDET.VALORTOTAL AS " VALOR TOTAL ",');

    // Elimina última vírgula
    AFDQuery.SQL[AFDQuery.SQL.Count - 1] := Copy(AFDQuery.SQL[AFDQuery.SQL.Count - 1], 1, Length(AFDQuery.SQL[AFDQuery.SQL.Count - 1]) - 1);

    AFDQuery.SQL.Add('FROM PEDIDOSDET');
    AFDQuery.SQL.Add('INNER JOIN PRODUTOS ON (PRODUTOS.CODIGO = PEDIDOSDET.CODPRODUTO)');
    AFDQuery.SQL.Add('WHERE PEDIDOSDET.CODIGO = ' + IntToStr(ValorPK));

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
