unit Controller.Clientes;

interface

uses
  Model.Clientes;

type
  TControllerClientes = class(TObject)
  private
    FModelClientes: TModelClientes;
  public
    constructor Create;
    destructor Destroy; override;
    property ModelClientes: TModelClientes read FModelClientes write FModelClientes;
end;


implementation

uses
  System.SysUtils;

{ TControllerClientes }

constructor TControllerClientes.Create;
begin
  inherited Create;
  FModelClientes := TModelClientes.Create;
end;

destructor TControllerClientes.Destroy;
begin
  FreeAndNil(FModelClientes);
  inherited;
end;

end.
