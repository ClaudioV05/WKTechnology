unit Controller.Pedidos;

interface

uses
  Model.Pedidos;

type
  TControllerPedidos = class(TObject)
  private
    FModelPedidos: TModelPedidos;
  public
    constructor Create;
    destructor Destroy; override;
    property ModelPedidos: TModelPedidos read FModelPedidos write FModelPedidos;
end;


implementation

uses
  System.SysUtils;

{ TControllerPedidos }

constructor TControllerPedidos.Create;
begin
  inherited Create;
  FModelPedidos := TModelPedidos.Create;
end;

destructor TControllerPedidos.Destroy;
begin
  FreeAndNil(FModelPedidos);
  inherited;
end;

end.
