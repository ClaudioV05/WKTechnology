unit Controller.Produtos;
// Unidade gerada pelo GeraClasseMVC para Delphi XE10 + FireDAC
// Desenvolvido com base no modelo de Manoel Zanchetta.
// Autor: Paulo F. Rocha Filho. Colaboração: Claudiomildo Ventura.
interface

uses
  Model.Produtos;

type
  TControllerProdutos = class(TObject)
  private
    FModelProdutos: TModelProdutos;
  public
    constructor Create;
    destructor Destroy; override;
    property ModelProdutos: TModelProdutos read FModelProdutos write FModelProdutos;
end;


implementation

uses
  System.SysUtils;

{ TControllerProdutos }

constructor TControllerProdutos.Create;
begin
  inherited Create;
  FModelProdutos := TModelProdutos.Create;
end;

destructor TControllerProdutos.Destroy;
begin
  FreeAndNil(FModelProdutos);
  inherited;
end;

end.
