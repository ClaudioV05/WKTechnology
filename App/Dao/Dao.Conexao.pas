unit Dao.Conexao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.IB, FireDAC.Phys.IBDef, FireDAC.Dapt, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.MySQL, Controller.DeclTiposConsts;

type
  TDaoConexao = class
    FConexao: TFDConnection;
    FMySQLDriver: TFDPhysMySQLDriverLink;
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    property Conexao: TFDConnection read FConexao write FConexao;
    property MySQLDriver: TFDPhysMySQLDriverLink read FMySQLDriver write FMySQLDriver;
    function EstabeleceConexaoSQL(AInfoConexaoSQL : TInfoConexaoSQL): Boolean;
    function CriarQuery: TFDQuery;
    function CriarTransaction: TFDTransaction;
    procedure ConfigQueryTransac(var AQuery: TFDQuery; var ATransaction: TFDTransaction);
  end;

implementation

uses
  Vcl.Dialogs;

{ TDaoConexao }

procedure TDaoConexao.ConfigQueryTransac(var AQuery: TFDQuery;
var
  ATransaction: TFDTransaction);
begin
  // setup transaction for updating commands: read_committed, rec_version, nowait
  ATransaction.Connection.UpdateOptions.LockWait := False;
  ATransaction.Options.ReadOnly := False;
  ATransaction.Options.Isolation := xiReadCommitted;

  AQuery.Transaction := ATransaction;

end;

constructor TDaoConexao.Create;
begin
  inherited Create;
  FConexao := TFDConnection.Create(nil);
  FMySQLDriver := TFDPhysMySQLDriverLink.Create(nil);
  FConexao.LoginPrompt := False;
end;

function TDaoConexao.CriarQuery: TFDQuery;
var
  AQuery: TFDQuery;
begin
  AQuery := TFDQuery.Create(nil);
  AQuery.Connection := FConexao;
  Result := AQuery;
end;

function TDaoConexao.CriarTransaction: TFDTransaction;
var
  ATransaction: TFDTransaction;
begin
  ATransaction := TFDTransaction.Create(nil);
  ATransaction.Connection := FConexao;
  Result := ATransaction;
end;

destructor TDaoConexao.Destroy;
begin
  FreeAndNil(FConexao);
  FreeAndNil(FMySQLDriver);
  inherited;
end;

function TDaoConexao.EstabeleceConexaoSQL(AInfoConexaoSQL: TInfoConexaoSQL): Boolean;
begin
  Result := False;
  try
    FConexao.Connected := False;

    with FConexao do
    begin
      Params.Clear;
      Params.Add('DATABASE='  + AInfoConexaoSQL.Database);
      Params.Add('DriverID='  + AInfoConexaoSQL.DriverID); // "DriverID=IB" ou "DriverID=MySQL"
      Params.Add('PASSWORD='  + AInfoConexaoSQL.Password);
      Params.Add('Protocol='  + AInfoConexaoSQL.Protocol); // "LOCAL" ou "TCPIP"
      Params.Add('Server='    + AInfoConexaoSQL.Server);
      Params.Add('Port='      + AInfoConexaoSQL.Port);
      Params.Add('USER_NAME=' + AInfoConexaoSQL.UserName);
    end;

    with FMySQLDriver do
    begin
      VendorLib := AInfoConexaoSQL.VendorLib;
    end;

    FConexao.Connected := True;

    Result := True;
  except
     on E: Exception do
      begin
        ShowMessage('Ocorreu um erro ao conectar o banco de dados: ' + #13 + E.Message);
      end;
  end;
end;

end.
