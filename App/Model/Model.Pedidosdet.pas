unit Model.Pedidosdet;

interface

uses
  System.Classes, System.SysUtils, Controller.DeclTiposConsts;

type
  TModelPedidosdet = class
  private
    FAcaoDePersistencia: TAcaoDePersistencia;
  protected
    FCODIGO: Integer;
    FSEQUENCIAL: Integer;
    FCODPRODUTO: Integer;
    FQUANTIDADE: Double;
    FPRECOUNITARIO: Double;
    FVALORTOTAL: Double;

    // Métodos Set para os campos obrigatórios:
    procedure SetCODIGO(const Value: Integer);
  public
    constructor Create;
    // destructor Destroy; override;  // Veja comentário abaixo.
    function Persistir(out Erro: String): Boolean;
    function Ler(ValorPK, Sequencial: Integer): Boolean;
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
    function ProximoSequencial(CodPedido: Integer): Integer;
    procedure InicializaValores;

    property AcaoDePersistencia: TAcaoDePersistencia read FAcaoDePersistencia write FAcaoDePersistencia;

    property CODIGO: Integer read FCODIGO write SetCODIGO;
    property SEQUENCIAL: Integer read FSEQUENCIAL write FSEQUENCIAL;
    property CODPRODUTO: Integer read FCODPRODUTO write FCODPRODUTO;
    property QUANTIDADE: Double read FQUANTIDADE write FQUANTIDADE;
    property PRECOUNITARIO: Double read FPRECOUNITARIO write FPRECOUNITARIO;
    property VALORTOTAL: Double read FVALORTOTAL write FVALORTOTAL;

  end;

implementation

{ TModelPedidosdet }

uses JSonUtils, FuncStrings, System.UITypes, Dao.Pedidosdet, Controller.Conexao,
  Vcl.Dialogs, Vcl.Forms;

constructor TModelPedidosdet.Create;
begin
  inherited Create;
  InicializaValores;

end;

// destructor TModelPedidosdet.Destroy;
// begin
// // Aqui ficam linhas para classes descendentes quando há necessidades diferentes do Destroy.
// inherited;

// end;

procedure TModelPedidosdet.InicializaValores;
begin
  FCODIGO := 0;
  FSEQUENCIAL := 0;
  FCODPRODUTO := 0;
  FPRECOUNITARIO := 0;
  FVALORTOTAL := 0;

end;

function TModelPedidosdet.Ler(ValorPK, Sequencial: Integer): Boolean;
var
  DaoPedidosdet: TDaoPedidosdet;
begin
  DaoPedidosdet := TDaoPedidosdet.Create;
  try
    Result := DaoPedidosdet.Ler(ValorPK, Sequencial, Self);
  finally
    FreeAndNil(DaoPedidosdet);
  end;

end;

function TModelPedidosdet.ListaJSon(Valor,
                                    CampoPesquisa,
                                    CamposOrdem: String;
                                    CamposVisiveis: String; // Campos separados por ","
                                    ModoPesquisa: TModoPesquisa;
                                    Descendente: Boolean;
                                    PaginaAtual: Integer;
                                    TamPagina: Word;
                                    ValorPK: Integer): String;

var
  DaoPedidosdet: TDaoPedidosdet;
begin
  DaoPedidosdet := TDaoPedidosdet.Create;
  try
    Result := DaoPedidosdet.ListaJSon(Valor,
                                      CampoPesquisa,
                                      CamposOrdem,
                                      CamposVisiveis,
                                      ModoPesquisa,
                                      Descendente,
                                      PaginaAtual,
                                      TamPagina,
                                      ValorPK);
  finally
    FreeAndNil(DaoPedidosdet);
  end;

end;

function TModelPedidosdet.Persistir(out Erro: String): Boolean;
var
  DaoPedidosdet: TDaoPedidosdet;
begin
  Result := False;
  DaoPedidosdet := TDaoPedidosdet.Create;
  try
    case FAcaoDePersistencia of
      adpInclusao:
        Result := DaoPedidosdet.Incluir(Self, Erro);
      adpAlteracao:
        Result := DaoPedidosdet.Alterar(Self, Erro);
      adpExclusao:
        Result := DaoPedidosdet.Excluir(Self, Erro);
    end;

  finally
    FreeAndNil(DaoPedidosdet);
  end;

end;

function TModelPedidosdet.ProximoCodigo: Integer;
var
  DaoPedidosdet: TDaoPedidosdet;
begin
  DaoPedidosdet := TDaoPedidosdet.Create;
  try
    Result := DaoPedidosdet.ProximoCodigo;
  finally
    FreeAndNil(DaoPedidosdet);
  end;

end;

function TModelPedidosdet.ProximoSequencial(CodPedido: Integer): Integer;
var
  DaoPedidosdet: TDaoPedidosdet;
begin
  DaoPedidosdet := TDaoPedidosdet.Create;
  try
    Result := DaoPedidosdet.ProximoSequencial(CodPedido);
  finally
    FreeAndNil(DaoPedidosdet);
  end;

end;

function TModelPedidosdet.RegistroJSon(CamposVisiveis: String; ValorPK: Integer): String;
var
  DaoPedidosdet: TDaoPedidosdet;
begin
  DaoPedidosdet := TDaoPedidosdet.Create;
  try
    Result := DaoPedidosdet.RegistroJSon(CamposVisiveis, ValorPK);
  finally
    FreeAndNil(DaoPedidosdet);
  end;

end;

procedure TModelPedidosdet.SetCODIGO(const Value: Integer);
begin
  if (Value < 0) then
    raise Exception.Create('Campo ''Codigo'' precisa ser informado.')
  else
    FCODIGO := Value;

end;

end.
