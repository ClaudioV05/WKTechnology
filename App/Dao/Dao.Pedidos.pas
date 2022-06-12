unit Dao.Pedidos;

interface

uses
  System.Classes, System.Sysutils,
  FireDAC.Stan.Param, FireDAC.Comp.Client,
  Controller.DeclTiposConsts, Model.Pedidos;

type
  TDaoPedidos = class(TObject)
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
    procedure InformaParams(var AModelPedidos: TModelPedidos; AFDQuery: TFDQuery);
  public
    // Constructor Create;   // Veja comentário abaixo.
    // Destructor Destroy; override;  // Veja comentário abaixo.
    function Ler(ValorPK: Integer; AModelPedidos: TModelPedidos): Boolean;
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

    function Incluir(AModelPedidos: TModelPedidos; out Erro: String): Boolean;
    function Alterar(AModelPedidos: TModelPedidos; out Erro: String): Boolean;
    function Excluir(AModelPedidos: TModelPedidos; out Erro: String): Boolean;
    procedure MontaSQLIncluir(AModelPedidos: TModelPedidos; AFDQuery: TFDQuery);
    procedure MontaSQLAlterar(AModelPedidos: TModelPedidos; AFDQuery: TFDQuery);
    procedure MontaSQLExcluir(AModelPedidos: TModelPedidos; AFDQuery: TFDQuery);
  end;

implementation

{ TDaoPedidos }

uses JSonUtils, FuncStrings, Controller.Conexao;

//  constructor TDaoPedidos.Create;
//  begin
//    inherited Create;
//    // Aqui ficam linhas para classes descendentes quando há necessidades diferentes do Create.
//  end;

//  destructor TDaoPedidos.Destroy;
//  begin
//    // Aqui ficam linhas para classes descendentes quando há necessidades diferentes do Destroy.
//    inherited;
//  end;

// Obtenção da próxima chave primária quando aplicável.
function TDaoPedidos.ProximoCodigo: Integer;
var
  AFDQuery: TFDQuery;
begin
  AFDQuery := TControllerConexao.GetInstance.DaoConexao.CriarQuery;
  try
    AFDQuery.SQL.Add('SELECT MAX(CODIGO) FROM PEDIDOS');
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

function TDaoPedidos.Incluir(AModelPedidos: TModelPedidos; out Erro: String): Boolean;
var
  AFDQuery: TFDQuery;
  AFDTransaction: TFDTransaction;
begin
  Result := False;
  AFDQuery := TControllerConexao.GetInstance.DaoConexao.CriarQuery;
  AFDTransaction := TControllerConexao.GetInstance.DaoConexao.CriarTransaction;
  try
    // Informa chave primaria
    AModelPedidos.CODIGO := ProximoCodigo;
    TControllerConexao.GetInstance.DaoConexao.ConfigQueryTransac(AFDQuery, AFDTransaction);

    MontaSQLIncluir(AModelPedidos, AFDQuery);

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

procedure TDaoPedidos.MontaSQLIncluir(AModelPedidos: TModelPedidos; AFDQuery: TFDQuery);
begin
  AFDQuery.SQL.Clear;
  AFDQuery.SQL.Text := 'INSERT INTO PEDIDOS'
                     + '('
                     + '  CODIGO'
                     + ', CODCLIENTE'
                     + ', DATAEMISSAO'
                     + ', VALORTOTAL'
                     + ')'
                     + 'VALUES'
                     + '('
                     + '  :CODIGO'
                     + ', :CODCLIENTE'
                     + ', :DATAEMISSAO'
                     + ', :VALORTOTAL'
                     + ')';

  InformaParams(AModelPedidos, AFDQuery);

end;

function TDaoPedidos.Alterar(AModelPedidos: TModelPedidos; out Erro: String): Boolean;
var
  AFDQuery: TFDQuery;
  AFDTransaction: TFDTransaction;
begin
  Result := False;
  AFDQuery := TControllerConexao.GetInstance.DaoConexao.CriarQuery;
  AFDTransaction := TControllerConexao.GetInstance.DaoConexao.CriarTransaction;
  try
    TControllerConexao.GetInstance.DaoConexao.ConfigQueryTransac(AFDQuery, AFDTransaction);

    MontaSQLAlterar(AModelPedidos, AFDQuery);

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

procedure TDaoPedidos.MontaSQLAlterar(AModelPedidos: TModelPedidos; AFDQuery: TFDQuery);
begin
  AFDQuery.SQL.Clear;
  AFDQuery.SQL.Text := 'UPDATE PEDIDOS SET'
                     + '  CODIGO = :CODIGO'
                     + ', CODCLIENTE = :CODCLIENTE'
                     + ', DATAEMISSAO = :DATAEMISSAO'
                     + ', VALORTOTAL = :VALORTOTAL'
                     // Cláusula WHERE para individualizar o registro a ser gravado (atualizado).
                     + ' WHERE CODIGO = ' + IntToStr(AModelPedidos.CODIGO);

  InformaParams(AModelPedidos, AFDQuery);

end;

function TDaoPedidos.Ler(ValorPK: Integer; AModelPedidos: TModelPedidos): Boolean;
var
  AFDQuery: TFDQuery;
begin
  Result := False;
  AFDQuery := TControllerConexao.GetInstance.DaoConexao.CriarQuery;
  try
    AModelPedidos.InicializaValores;
    AFDQuery.SQL.Add('SELECT * FROM PEDIDOS');
    // Cláusula WHERE para individualizar o registro a ser gravado (atualizado).
    AFDQuery.SQL.Add(' WHERE CODIGO = ' + IntToStr(ValorPK));
    AFDQuery.Open;

    if AFDQuery.RecordCount > 0 then
    begin
      Result := True;
      AModelPedidos.CODIGO := AFDQuery.Fields.FieldByName('CODIGO').AsInteger;
      AModelPedidos.CODCLIENTE := AFDQuery.Fields.FieldByName('CODCLIENTE').AsInteger;
      AModelPedidos.DATAEMISSAO := AFDQuery.Fields.FieldByName('DATAEMISSAO').AsDateTime;
      AModelPedidos.VALORTOTAL := AFDQuery.Fields.FieldByName('VALORTOTAL').AsFloat;
    end;
  finally
    FreeAndNil(AFDQuery);
  end;

end;

function TDaoPedidos.ListaJSon(ValorPesquisa,
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

function TDaoPedidos.RegistroJSon(CamposVisiveis: String; ValorPK: Integer): String;
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

function TDaoPedidos.PodeExcluir: Boolean;
begin
  Result := True; // A ser implementado.
end;

function TDaoPedidos.Excluir(AModelPedidos: TModelPedidos; out Erro: String): Boolean;
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

    MontaSQLExcluir(AModelPedidos, AFDQuery);

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

procedure TDaoPedidos.MontaSQLExcluir(AModelPedidos: TModelPedidos; AFDQuery: TFDQuery);
begin
  AFDQuery.SQL.Clear;
  AFDQuery.SQL.Add('DELETE FROM PEDIDOS');
  // Cláusula WHERE para individualizar o registro a ser deletado.
  AFDQuery.SQL.Add(' WHERE CODIGO = ' + IntToStr(AModelPedidos.CODIGO));

end;

procedure TDaoPedidos.InformaParams(var AModelPedidos: TModelPedidos; AFDQuery: TFDQuery);
var
  I: Integer;
begin

  for I := 0 to AFDQuery.Params.Count - 1 do
    AFDQuery.Params[I].Clear;

  AFDQuery.ParamByName('CODIGO').AsInteger := AModelPedidos.CODIGO;
  AFDQuery.ParamByName('CODCLIENTE').AsInteger := AModelPedidos.CODCLIENTE;
  AFDQuery.ParamByName('DATAEMISSAO').AsDateTime := AModelPedidos.DATAEMISSAO;
  AFDQuery.ParamByName('VALORTOTAL').AsFloat := AModelPedidos.VALORTOTAL;

end;

function TDaoPedidos.ExecutaListarJSon(ValorPesquisa,
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
      AFDQuery.SQL.Add(' PEDIDOS.CODIGO,');
    if ExisteCampo('CODCLIENTE', CamposVisiveis) then
      AFDQuery.SQL.Add(' PEDIDOS.CODCLIENTE,');
    if ExisteCampo('DATAEMISSAO', CamposVisiveis) then
      AFDQuery.SQL.Add(' PEDIDOS.DATAEMISSAO,');
    if ExisteCampo('VALORTOTAL', CamposVisiveis) then
      AFDQuery.SQL.Add(' PEDIDOS.VALORTOTAL,');

    // Elimina última vírgula
    AFDQuery.SQL[AFDQuery.SQL.Count - 1] := Copy(AFDQuery.SQL[AFDQuery.SQL.Count - 1], 1, Length(AFDQuery.SQL[AFDQuery.SQL.Count - 1]) - 1);

    AFDQuery.SQL.Add('FROM PEDIDOS');

    if (ValorPK = 0) then // retorna lista pesquisada
    begin
      AFDQuery.SQL.Add('WHERE PEDIDOS.CODIGO <> 0');

      if ValorPesquisa <> EmptyStr then
      begin
        // Descomentar só para campos tipo VARCHAR ou CHAR
        //if CampoPesquisa = 'NomeCampoString' then
        //  CampoPesquisa := CampoPesquisa + ' collate WIN_PTBR ';

        case ModoPesquisa of
          mpComecaCom:
            AFDQuery.SQL.Add('AND PEDIDOS.' + CampoPesquisa + ' starting with ''' + ValorPesquisa + '''');
          mpContem:
            AFDQuery.SQL.Add('AND PEDIDOS.' + CampoPesquisa + ' containing ''' + ValorPesquisa + '''');
          mpIgual:
            AFDQuery.SQL.Add('AND PEDIDOS.' + CampoPesquisa + ' = ''' + ValorPesquisa + '''');
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
      AFDQuery.SQL.Add('WHERE PEDIDOS.CODIGO = ' + IntToStr(ValorPK));
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
