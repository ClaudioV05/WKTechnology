unit Controller.Conexao;

interface

uses Dao.Conexao;

type
  // Singleton
  TControllerConexao = class
    private
      FDaoConexao: TDaoConexao;
      constructor Create; // Na seção "private"  por que é um singleton
      destructor Destroy; override;
    public
      property DaoConexao: TDaoConexao read FDaoConexao write FDaoConexao;
      class function GetInstance: TControllerConexao; // uma "class function" permite ser chamada sem instanciar a classe
  end;

implementation

uses
  System.SysUtils;

var
  InstanciaConexao: TControllerConexao;

{ TControllerConexao }

constructor TControllerConexao.Create;
begin
  inherited Create;
  FDaoConexao := TDaoConexao.Create;
end;

destructor TControllerConexao.Destroy;
begin
  FreeAndNil(FDaoConexao);
  inherited;
end;

class function TControllerConexao.GetInstance: TControllerConexao;
begin
  if (InstanciaConexao = nil) then
    InstanciaConexao := TControllerConexao.Create;

  Result := InstanciaConexao;
end;

initialization
  InstanciaConexao := nil;

finalization
  if (InstanciaConexao <> nil) then
    FreeAndNil(InstanciaConexao);

end.
