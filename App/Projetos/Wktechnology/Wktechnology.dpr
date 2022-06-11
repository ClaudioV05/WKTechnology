program Wktechnology;

uses
  Vcl.Forms,
  View.FrmPrincipal in 'View\View.FrmPrincipal.pas' {FrmPrincipal},
  Dao.Pedidos in '..\..\Dao\Dao.Pedidos.pas',
  Dao.Pedidosdet in '..\..\Dao\Dao.Pedidosdet.pas',
  Dao.Clientes in '..\..\Dao\Dao.Clientes.pas',
  Dao.Produtos in '..\..\Dao\Dao.Produtos.pas',
  Model.Pedidos in '..\..\Model\Model.Pedidos.pas',
  Model.Pedidosdet in '..\..\Model\Model.Pedidosdet.pas',
  Model.Clientes in '..\..\Model\Model.Clientes.pas',
  Model.Produtos in '..\..\Model\Model.Produtos.pas',
  Controller.Pedidos in '..\..\Controller\Controller.Pedidos.pas',
  Controller.Pedidosdet in '..\..\Controller\Controller.Pedidosdet.pas',
  Controller.Clientes in '..\..\Controller\Controller.Clientes.pas',
  Controller.Produtos in '..\..\Controller\Controller.Produtos.pas',
  JSonUtils in '..\..\Utils\JSonUtils.pas',
  Dao.Conexao in '..\..\Dao\Dao.Conexao.pas',
  FuncStrings in '..\..\Utils\FuncStrings.pas',
  StringGridUtils in '..\..\Utils\StringGridUtils.pas',
  AlignedTStringGrid in '..\..\Utils\AlignedTStringGrid.pas',
  Controller.Conexao in '..\..\Controller\Controller.Conexao.pas',
  Controller.DeclTiposConsts in '..\..\Controller\Controller.DeclTiposConsts.pas',
  View.FrmPedidosdet in 'View\View.FrmPedidosdet.pas' {FrmPedidosdet},
  View.FrmPedidosdetEd in 'View\View.FrmPedidosdetEd.pas' {FrmPedidosdetEd},
  View.FrmClientes in 'View\View.FrmClientes.pas' {FrmClientes},
  View.FrmProdutos in 'View\View.FrmProdutos.pas' {FrmProdutos};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
