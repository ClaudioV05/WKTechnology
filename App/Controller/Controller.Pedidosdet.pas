unit Controller.Pedidosdet;

interface

uses
  Model.Pedidosdet;

type
  TControllerPedidosdet = class(TObject)
  private
    FModelPedidosdet: TModelPedidosdet;
  public
    constructor Create;
    destructor Destroy; override;
    property ModelPedidosdet: TModelPedidosdet read FModelPedidosdet write FModelPedidosdet;
end;


implementation

uses
  System.SysUtils;

{ TControllerPedidosdet }

constructor TControllerPedidosdet.Create;
begin
  inherited Create;
  FModelPedidosdet := TModelPedidosdet.Create;
end;

destructor TControllerPedidosdet.Destroy;
begin
  FreeAndNil(FModelPedidosdet);
  inherited;
end;

end.
