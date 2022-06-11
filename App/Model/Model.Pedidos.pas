unit Model.Pedidos;

interface

uses
  System.Classes, System.SysUtils, Controller.DeclTiposConsts;

type
  TModelPedidos = class
  private
    FAcaoDePersistencia: TAcaoDePersistencia;
  protected
    FCODIGO: Integer;
    FCODCLIENTE: Integer;
    FDATAEMISSAO: TDateTime;
    FVALORTOTAL: Double;

    // Métodos Set para os campos obrigatórios:
    procedure SetCODIGO(const Value: Integer);
    procedure SetCODCLIENTE(const Value: Integer);
  public
    constructor Create;
    // destructor Destroy; override;  // Veja comentário abaixo.
    function Persistir(out Erro: String): Boolean;
    function Ler(ValorPK: Integer): Boolean;
    function ListaJSon(Valor,
                       CampoPesquisa,
                       CamposOrdem: String;
                       CamposVisiveis: String; // Campos separados por ","
                       ModoPesquisa: TModoPesquisa;
                       Descendente: Boolean;
                       PaginaAtual: Integer;
                       TamPagina: Word;
                       ValorPK: Integer): String;

    function RegistroJSon(CamposVisiveis: String; ValorPK: Integer): String;
    function ProximoCodigo: Integer;
    procedure InicializaValores;

    property AcaoDePersistencia: TAcaoDePersistencia read FAcaoDePersistencia write FAcaoDePersistencia;

    property CODIGO: Integer read FCODIGO write SetCODIGO;
    property CODCLIENTE: Integer read FCODCLIENTE write SetCODCLIENTE;
    property DATAEMISSAO: TDateTime read FDATAEMISSAO write FDATAEMISSAO;
    property VALORTOTAL: Double read FVALORTOTAL write FVALORTOTAL;

  end;

implementation

{ TModelPedidos }

uses JSonUtils, FuncStrings, System.UITypes, Dao.Pedidos, Controller.Conexao,
  Vcl.Dialogs, Vcl.Forms;

constructor TModelPedidos.Create;
begin
  inherited Create;
  InicializaValores;

end;

// destructor TModelPedidos.Destroy;
// begin
// // Aqui ficam linhas para classes descendentes quando há necessidades diferentes do Destroy.
// inherited;

// end;

procedure TModelPedidos.InicializaValores;
begin
  FCODIGO := 0;
  FCODCLIENTE := 0;
  FDATAEMISSAO := 0;
  FVALORTOTAL := 0;

end;

function TModelPedidos.Ler(ValorPK: Integer): Boolean;
var
  DaoPedidos: TDaoPedidos;
begin
  DaoPedidos := TDaoPedidos.Create;
  try
    Result := DaoPedidos.Ler(ValorPK, Self);
  finally
    FreeAndNil(DaoPedidos);
  end;

end;

function TModelPedidos.ListaJSon(Valor,
                                 CampoPesquisa,
                                 CamposOrdem: String;
                                 CamposVisiveis: String; // Campos separados por ","
                                 ModoPesquisa: TModoPesquisa;
                                 Descendente: Boolean;
                                 PaginaAtual: Integer;
                                 TamPagina: Word;
                                 ValorPK: Integer): String;

var
  DaoPedidos: TDaoPedidos;
begin
  DaoPedidos := TDaoPedidos.Create;
  try
    Result := DaoPedidos.ListaJSon(Valor,
                                   CampoPesquisa,
                                   CamposOrdem,
                                   CamposVisiveis,
                                   ModoPesquisa,
                                   Descendente,
                                   PaginaAtual,
                                   TamPagina,
                                   ValorPK);
  finally
    FreeAndNil(DaoPedidos);
  end;

end;

function TModelPedidos.Persistir(out Erro: String): Boolean;
var
  DaoPedidos: TDaoPedidos;
begin
  Result := False;
  DaoPedidos := TDaoPedidos.Create;
  try
    case FAcaoDePersistencia of
      adpInclusao:
        Result := DaoPedidos.Incluir(Self, Erro);
      adpAlteracao:
        Result := DaoPedidos.Alterar(Self, Erro);
      adpExclusao:
        Result := DaoPedidos.Excluir(Self, Erro);
    end;

  finally
    FreeAndNil(DaoPedidos);
  end;

end;

function TModelPedidos.ProximoCodigo: Integer;
var
  DaoPedidos: TDaoPedidos;
begin
  DaoPedidos := TDaoPedidos.Create;
  try
    Result := DaoPedidos.ProximoCodigo;
  finally
    FreeAndNil(DaoPedidos);
  end;

end;

function TModelPedidos.RegistroJSon(CamposVisiveis: String; ValorPK: Integer): String;
var
  DaoPedidos: TDaoPedidos;
begin
  DaoPedidos := TDaoPedidos.Create;
  try
    Result := DaoPedidos.RegistroJSon(CamposVisiveis, ValorPK);
  finally
    FreeAndNil(DaoPedidos);
  end;

end;

procedure TModelPedidos.SetCODIGO(const Value: Integer);
begin
  if (Value < 0) then
    raise Exception.Create('Campo ''Codigo'' precisa ser informado.')
  else
    FCODIGO := Value;

end;

procedure TModelPedidos.SetCODCLIENTE(const Value: Integer);
begin
  if (Value < 0) then
    raise Exception.Create('Campo ''Codcliente'' precisa ser informado.')
  else
    FCODCLIENTE := Value;

end;

end.
