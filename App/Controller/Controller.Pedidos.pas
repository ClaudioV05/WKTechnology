unit Controller.Pedidos;
// Unidade gerada pelo GeraClasseMVC para Delphi XE10 + FireDAC
// Desenvolvido com base no modelo de Manoel Zanchetta.
// Autor: Paulo F. Rocha Filho. Colaboração: Claudiomildo Ventura.
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
