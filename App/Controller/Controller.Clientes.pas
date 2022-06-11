unit Controller.Clientes;
// Unidade gerada pelo GeraClasseMVC para Delphi XE10 + FireDAC
// Desenvolvido com base no modelo de Manoel Zanchetta.
// Autor: Paulo F. Rocha Filho. Colaboração: Claudiomildo Ventura.
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
