unit Controller.Produtos;

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
