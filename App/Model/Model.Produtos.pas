unit Model.Produtos;

interface

uses
  System.Classes, System.SysUtils, Controller.DeclTiposConsts;

type
  TModelProdutos = class
  private
    FAcaoDePersistencia: TAcaoDePersistencia;
  protected
    FCODIGO: Integer;
    FDESCRICAO: String;
    FPRECOVENDA: Double;
    FATIVO: String;

    // Métodos Set para os campos obrigatórios:
    procedure SetCODIGO(const Value: Integer);
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
    property DESCRICAO: String read FDESCRICAO write FDESCRICAO;
    property PRECOVENDA: Double read FPRECOVENDA write FPRECOVENDA;
    property ATIVO: String read FATIVO write FATIVO;

  end;

implementation

{ TModelProdutos }

uses JSonUtils, FuncStrings, System.UITypes, Dao.Produtos, Controller.Conexao,
  Vcl.Dialogs, Vcl.Forms;

constructor TModelProdutos.Create;
begin
  inherited Create;
  InicializaValores;

end;

// destructor TModelProdutos.Destroy;
// begin
// // Aqui ficam linhas para classes descendentes quando há necessidades diferentes do Destroy.
// inherited;

// end;

procedure TModelProdutos.InicializaValores;
begin
  FCODIGO := 0;
  FDESCRICAO := '';
  FPRECOVENDA := 0;
  FATIVO := '';

end;

function TModelProdutos.Ler(ValorPK: Integer): Boolean;
var
  DaoProdutos: TDaoProdutos;
begin
  DaoProdutos := TDaoProdutos.Create;
  try
    Result := DaoProdutos.Ler(ValorPK, Self);
  finally
    FreeAndNil(DaoProdutos);
  end;

end;

function TModelProdutos.ListaJSon(Valor,
                                  CampoPesquisa,
                                  CamposOrdem: String;
                                  CamposVisiveis: String; // Campos separados por ","
                                  ModoPesquisa: TModoPesquisa;
                                  Descendente: Boolean;
                                  PaginaAtual: Integer;
                                  TamPagina: Word;
                                  ValorPK: Integer): String;

var
  DaoProdutos: TDaoProdutos;
begin
  DaoProdutos := TDaoProdutos.Create;
  try
    Result := DaoProdutos.ListaJSon(Valor,
                                    CampoPesquisa,
                                    CamposOrdem,
                                    CamposVisiveis,
                                    ModoPesquisa,
                                    Descendente,
                                    PaginaAtual,
                                    TamPagina,
                                    ValorPK);
  finally
    FreeAndNil(DaoProdutos);
  end;

end;

function TModelProdutos.Persistir(out Erro: String): Boolean;
var
  DaoProdutos: TDaoProdutos;
begin
  Result := False;
  DaoProdutos := TDaoProdutos.Create;
  try
    case FAcaoDePersistencia of
      adpInclusao:
        Result := DaoProdutos.Incluir(Self, Erro);
      adpAlteracao:
        Result := DaoProdutos.Alterar(Self, Erro);
      adpExclusao:
        Result := DaoProdutos.Excluir(Self, Erro);
    end;

  finally
    FreeAndNil(DaoProdutos);
  end;

end;

function TModelProdutos.ProximoCodigo: Integer;
var
  DaoProdutos: TDaoProdutos;
begin
  DaoProdutos := TDaoProdutos.Create;
  try
    Result := DaoProdutos.ProximoCodigo;
  finally
    FreeAndNil(DaoProdutos);
  end;

end;

function TModelProdutos.RegistroJSon(CamposVisiveis: String; ValorPK: Integer): String;
var
  DaoProdutos: TDaoProdutos;
begin
  DaoProdutos := TDaoProdutos.Create;
  try
    Result := DaoProdutos.RegistroJSon(CamposVisiveis, ValorPK);
  finally
    FreeAndNil(DaoProdutos);
  end;

end;

procedure TModelProdutos.SetCODIGO(const Value: Integer);
begin
  if (Value < 0) then
    raise Exception.Create('Campo ''Codigo'' precisa ser informado.')
  else
    FCODIGO := Value;

end;

end.
