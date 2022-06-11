unit Model.Clientes;

interface

uses
  System.Classes, System.SysUtils, Controller.DeclTiposConsts;

type
  TModelClientes = class
  private
    FAcaoDePersistencia: TAcaoDePersistencia;
  protected
    FCODIGO: Integer;
    FNOME: String;
    FCIDADE: String;
    FUF: String;
    FATIVO: String;

    // Métodos Set para os campos obrigatórios:
    procedure SetCODIGO(const Value: Integer);
    procedure SetNOME(const Value: String);
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
    property NOME: String read FNOME write SetNOME;
    property CIDADE: String read FCIDADE write FCIDADE;
    property UF: String read FUF write FUF;
    property ATIVO: String read FATIVO write FATIVO;

  end;

implementation

{ TModelClientes }

uses JSonUtils, FuncStrings, System.UITypes, Dao.Clientes, Controller.Conexao,
  Vcl.Dialogs, Vcl.Forms;

constructor TModelClientes.Create;
begin
  inherited Create;
  InicializaValores;

end;

// destructor TModelClientes.Destroy;
// begin
// // Aqui ficam linhas para classes descendentes quando há necessidades diferentes do Destroy.
// inherited;

// end;

procedure TModelClientes.InicializaValores;
begin
  FCODIGO := 0;
  FNOME := '';
  FCIDADE := '';
  FUF := '';
  FATIVO := '';

end;

function TModelClientes.Ler(ValorPK: Integer): Boolean;
var
  DaoClientes: TDaoClientes;
begin
  DaoClientes := TDaoClientes.Create;
  try
    Result := DaoClientes.Ler(ValorPK, Self);
  finally
    FreeAndNil(DaoClientes);
  end;

end;

function TModelClientes.ListaJSon(Valor,
                                  CampoPesquisa,
                                  CamposOrdem: String;
                                  CamposVisiveis: String; // Campos separados por ","
                                  ModoPesquisa: TModoPesquisa;
                                  Descendente: Boolean;
                                  PaginaAtual: Integer;
                                  TamPagina: Word;
                                  ValorPK: Integer): String;

var
  DaoClientes: TDaoClientes;
begin
  DaoClientes := TDaoClientes.Create;
  try
    Result := DaoClientes.ListaJSon(Valor,
                                    CampoPesquisa,
                                    CamposOrdem,
                                    CamposVisiveis,
                                    ModoPesquisa,
                                    Descendente,
                                    PaginaAtual,
                                    TamPagina,
                                    ValorPK);
  finally
    FreeAndNil(DaoClientes);
  end;

end;

function TModelClientes.Persistir(out Erro: String): Boolean;
var
  DaoClientes: TDaoClientes;
begin
  Result := False;
  DaoClientes := TDaoClientes.Create;
  try
    case FAcaoDePersistencia of
      adpInclusao:
        Result := DaoClientes.Incluir(Self, Erro);
      adpAlteracao:
        Result := DaoClientes.Alterar(Self, Erro);
      adpExclusao:
        Result := DaoClientes.Excluir(Self, Erro);
    end;

  finally
    FreeAndNil(DaoClientes);
  end;

end;

function TModelClientes.ProximoCodigo: Integer;
var
  DaoClientes: TDaoClientes;
begin
  DaoClientes := TDaoClientes.Create;
  try
    Result := DaoClientes.ProximoCodigo;
  finally
    FreeAndNil(DaoClientes);
  end;

end;

function TModelClientes.RegistroJSon(CamposVisiveis: String; ValorPK: Integer): String;
var
  DaoClientes: TDaoClientes;
begin
  DaoClientes := TDaoClientes.Create;
  try
    Result := DaoClientes.RegistroJSon(CamposVisiveis, ValorPK);
  finally
    FreeAndNil(DaoClientes);
  end;

end;

procedure TModelClientes.SetCODIGO(const Value: Integer);
begin
  if (Value < 0) then
    raise Exception.Create('Campo ''Codigo'' precisa ser informado.')
  else
    FCODIGO := Value;

end;

procedure TModelClientes.SetNOME(const Value: String);
begin
  if (Value = EmptyStr) then
    raise Exception.Create('Campo ''Nome'' precisa ser informado.')
  else
    FNOME := Value;

end;

end.
