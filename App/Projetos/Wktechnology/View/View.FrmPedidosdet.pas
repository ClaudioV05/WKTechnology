unit View.FrmPedidosdet;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
   System.StrUtils, System.UITypes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
   Vcl.Grids, Vcl.StdCtrls, Vcl.Mask, Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus,
   Controller.DeclTiposConsts, AlignedTStringGrid, NumEdit, Vcl.Imaging.pngimage;

type
  TFrmPedidosdet = class(TForm)
    Panel1: TPanel;
    EdtDescProduto: TEdit;
    EdtQtdProduto: TEdit;
    EdtVUnitProduto: TEdit;
    BtnConfirmar: TButton;
    Panel2: TPanel;
    PanBotoes: TPanel;
    BtnAlterar: TBitBtn;
    BtnExcluir: TBitBtn;
    PanFiltro: TPanel;
    StgLista: TStringGrid;
    BtnEscolherProduto: TButton;
    lblCodProduto: TLabel;
    Panel3: TPanel;
    panTotal: TPanel;
    Label1: TLabel;
    lblQtdProduto: TLabel;
    LblVUnitProduto: TLabel;
    BtnFinalizarVenda: TButton;
    EdtCodProduto: TEdit;
    procedure BtnExcluirClick(Sender: TObject);
    procedure CboCampoPesquisaChange(Sender: TObject);
    procedure CboOrdemChange(Sender: TObject);
    procedure ChkDescendenteClick(Sender: TObject);
    procedure EdtPesquisaChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mniCopiarClick(Sender: TObject);
    procedure mniOrdenarClick(Sender: TObject);
    procedure StgListaSelectCell(Sender: TObject; aCol, aRow: Integer; var CanSelect: Boolean);
    procedure BtnEscolherProdutoClick(Sender: TObject);
    procedure BtnConfirmarClick(Sender: TObject);
    procedure EdtDescProdutoChange(Sender: TObject);
    procedure StgListaKeyPress(Sender: TObject; var Key: Char);
    procedure BtnAlterarClick(Sender: TObject);
    procedure BtnFinalizarVendaClick(Sender: TObject);
    procedure EdtCodProdutoExit(Sender: TObject);
  private
    { Private declarations }
    procedure Pesquisa(RetornoPesquisa: TRetornoPesquisa; PaginaAtual: Integer; TamPagina: Word; _Codigo: Integer);
    procedure LimparCampos;
    procedure CarregaPanTotais;
    procedure AlterarDadosProduto;
  public
    { Public declarations }
    UCodCliente, UCodPedido, UCodProduto:Integer;
    procedure CarregaRegistroDosProdutos(CodProduto, Descricao, PrecoVenda: String);
    procedure GeraRegistroPedidos(CodCliente: Integer);
  end;

var
  FrmPedidosdet: TFrmPedidosdet;

implementation

uses View.FrmPrincipal, View.FrmPedidosdetEd, Controller.Pedidosdet, StringGridUtils, FuncStrings,
  Controller.Pedidos, View.FrmProdutos, Controller.Produtos;

{$R *.DFM}

var
  UPaginaAtual, UCol, URow: Integer;
  UTamPagina: Word;
  UEdtPesquisaAlterado: Boolean;

{ TFrmPedidosdet }

procedure TFrmPedidosdet.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FrmPrincipal.MostraEscondePanFundo(True);
  Action := caFree;

end;

procedure TFrmPedidosdet.BtnEscolherProdutoClick(Sender: TObject);
begin
  Application.CreateForm(TFrmProdutos, FrmProdutos);
  FrmPedidosdet.SendToBack;

  FrmProdutos.BringToFront;
  FrmProdutos.WindowState := wsMaximized;
  FrmProdutos.Show
end;

procedure TFrmPedidosdet.CboCampoPesquisaChange(Sender: TObject);
begin
  UPaginaAtual := 1;

end;

procedure TFrmPedidosdet.CboOrdemChange(Sender: TObject);
begin
  UPaginaAtual := 1;
  Pesquisa(rpListagem, UPaginaAtual, UTamPagina, 0);

end;

procedure TFrmPedidosdet.ChkDescendenteClick(Sender: TObject);
begin
  UPaginaAtual := 1;
  Pesquisa(rpListagem, UPaginaAtual, UTamPagina, 0);

end;

procedure TFrmPedidosdet.EdtCodProdutoExit(Sender: TObject);
var
  CtrlProdutos: TControllerProdutos;
begin
  if (EdtCodProduto.Text = EmptyStr) then
  begin
    EdtDescProduto.Clear;
    Exit;
  end;

  CtrlProdutos := TControllerProdutos.Create;
  try
    if (CtrlProdutos.ModelProdutos.Ler(StrToIntDef(EdtCodProduto.Text, 0))) then
    begin
      CarregaRegistroDosProdutos(IntToStr(CtrlProdutos.ModelProdutos.CODIGO),
                                 CtrlProdutos.ModelProdutos.DESCRICAO,
                                 FloatToStr(CtrlProdutos.ModelProdutos.PRECOVENDA));
    end;
    
  finally
    FreeAndNil(CtrlProdutos);
  end;

end;

procedure TFrmPedidosdet.EdtDescProdutoChange(Sender: TObject);
begin
  if (EdtDescProduto.Text = EmptyStr) then
    BtnConfirmar.Enabled := False
  else
    BtnConfirmar.Enabled := True;
    
end;

procedure TFrmPedidosdet.EdtPesquisaChange(Sender: TObject);
begin
  UEdtPesquisaAlterado := True;
  BtnAlterar.Enabled := False;
  BtnExcluir.Enabled := False;

end;

procedure TFrmPedidosdet.BtnAlterarClick(Sender: TObject);
begin
  AlterarDadosProduto;

end;

procedure TFrmPedidosdet.BtnConfirmarClick(Sender: TObject);
var
  Erro: String;
  CtrlPedidosdet: TControllerPedidosdet;
begin
  CtrlPedidosdet := TControllerPedidosdet.Create;
  try
    // Preenche os valores pertinentes
    CtrlPedidosdet.ModelPedidosdet.InicializaValores;

    CtrlPedidosdet.ModelPedidosdet.CODIGO := UCodPedido;
    CtrlPedidosdet.ModelPedidosdet.AcaoDePersistencia := adpInclusao;
    CtrlPedidosdet.ModelPedidosdet.SEQUENCIAL := CtrlPedidosdet.ModelPedidosdet.ProximoSequencial(UCodPedido);
    CtrlPedidosdet.ModelPedidosdet.CODPRODUTO := UCodProduto;
    CtrlPedidosdet.ModelPedidosdet.QUANTIDADE := StrToFloatDef(EdtQtdProduto.Text, 0);
    CtrlPedidosdet.ModelPedidosdet.PRECOUNITARIO := StrToFloatDef(EdtVUnitProduto.Text, 0);
    CtrlPedidosdet.ModelPedidosdet.VALORTOTAL := StrToFloatDef(EdtQtdProduto.Text, 0) * StrToFloatDef(EdtVUnitProduto.Text, 0);

    if (CtrlPedidosdet.ModelPedidosdet.Persistir(Erro)) then
    begin
      LimparCampos;
      Pesquisa(rpRegistro, UPaginaAtual, UTamPagina, UCodPedido);
      CarregaPanTotais;
      EdtDescProduto.SetFocus;
    end
    else
      MessageDlgPos(Erro, mtError, [mbOk], 0, GetXMsg(Self), GetYMsg(Self));

  finally
    FreeAndNil(CtrlPedidosdet);
  end;

end;

procedure TFrmPedidosdet.BtnExcluirClick(Sender: TObject);
var
  Sequencial: Integer;
  MsgErro: String;
  CtrlPedidosdet: TControllerPedidosdet;
begin
  if (URow = 0) then
    URow := 1;

  if (StgLista.Cells[0, URow] = EmptyStr) then
    Exit
  else if (MessageDlgPos('Remover o produto ' + QuotedStr(UpperCase(StgLista.Cells[2, URow])) + ' da venda.', mtConfirmation, [mbYes, mbNo], 0, GetXMsg(Self), GetYMsg(Self), mbNo) = mrYes) then
  begin
    Sequencial := StrToInt(StgLista.Cells[0, URow]);
    CtrlPedidosdet := TControllerPedidosdet.Create;
    try
      CtrlPedidosdet.ModelPedidosdet.AcaoDePersistencia := adpExclusao;
      CtrlPedidosdet.ModelPedidosdet.CODIGO := UCodPedido;
      CtrlPedidosdet.ModelPedidosdet.SEQUENCIAL := Sequencial;

      if (CtrlPedidosdet.ModelPedidosdet.Persistir(MsgErro)) then
      begin
        Pesquisa(rpRegistro, UPaginaAtual, UTamPagina, UCodPedido);
        CarregaPanTotais;
      end
      else
        MessageDlgPos(MsgErro, mtError, [mbOk], 0, GetXMsg(Self), GetYMsg(Self));

    finally
      FreeAndNil(CtrlPedidosdet);
    end;

  end;

end;

procedure TFrmPedidosdet.BtnFinalizarVendaClick(Sender: TObject);
var
  Erro: String;
  CtrlPedidos: TControllerPedidos;
begin
  if (URow = 0) then
    URow := 1;

  if (StgLista.Cells[0, URow] = EmptyStr) then
    Exit;

  if (MessageDlgPos('Finalizar Venda?', mtConfirmation, [mbYes, mbNo], 0, GetXMsg(Self), GetYMsg(Self), mbNo) = mrYes) then
  begin

    CtrlPedidos := TControllerPedidos.Create;
    try
      // Preenche os valores pertinentes
      CtrlPedidos.ModelPedidos.InicializaValores;

      CtrlPedidos.ModelPedidos.CODIGO := UCodPedido;
      CtrlPedidos.ModelPedidos.Ler(UCodPedido);
      CtrlPedidos.ModelPedidos.AcaoDePersistencia := adpAlteracao;
      CtrlPedidos.ModelPedidos.VALORTOTAL := StrToFloat(panTotal.Caption);

      if (CtrlPedidos.ModelPedidos.Persistir(Erro)) then
      begin
        LimparCampos;
        LimpaDadosGrid(StgLista);

        FrmPedidosdet.Close;

        FrmPrincipal.PanGeral.Visible := True;
        FrmPrincipal.Show;

      end
      else
        MessageDlgPos(Erro, mtError, [mbOk], 0, GetXMsg(Self), GetYMsg(Self));

    finally
      FreeAndNil(CtrlPedidos);
    end;
  end;

end;

procedure TFrmPedidosdet.FormCreate(Sender: TObject);
begin
  KeyPreview := True;

  UTamPagina := 20;
  UPaginaAtual := 1;
  UEdtPesquisaAlterado := False;
  UCodPedido := 0;
  UCodProduto := 0;

end;

procedure TFrmPedidosdet.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if not (ActiveControl is TStringGrid) then
  begin
    if (Key = VK_UP) and (Shift = []) then
      SelectNext(ActiveControl, False, True)
    else if ((Key = VK_DOWN) or (Key = VK_RETURN)) and (Shift = []) and not (ActiveControl is TButtonControl) then
      SelectNext(ActiveControl, True, True);
  end;

  if (Key = VK_F5) then
    BtnEscolherProdutoClick(Sender)
  else if (Key = VK_F6) then
    BtnConfirmarClick(Sender);

end;

procedure TFrmPedidosdet.mniCopiarClick(Sender: TObject);
begin
  CopyGridSelectionToClipBoard(StgLista, StgLista.Selection);

end;

procedure TFrmPedidosdet.mniOrdenarClick(Sender: TObject);
begin
  if UCol = 0 then // ID
    SortGrid(StgLista, UCol, True)
  else
    SortGrid(StgLista, UCol, False);
end;

procedure TFrmPedidosdet.StgListaKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
    AlterarDadosProduto;

end;

procedure TFrmPedidosdet.StgListaSelectCell(Sender: TObject; aCol, aRow: Integer; var CanSelect: Boolean);
begin
  UCol := ACol;
  URow := ARow;

end;

procedure TFrmPedidosdet.Pesquisa(RetornoPesquisa: TRetornoPesquisa; PaginaAtual: Integer; TamPagina: Word; _Codigo: Integer);
var
  AJsonStr, CamposVisiveis: String;
  ModoPesquisa: TModoPesquisa;
  CtrlPedidosdet: TControllerPedidosdet;
begin
  LimpaDadosGrid(StgLista);

  ModoPesquisa := mpComecaCom; // Default

  CtrlPedidosdet := TControllerPedidosdet.Create;
  try
    CamposVisiveis := 'SEQUENCIAL, CODPRODUTO, DESCRICAO, QUANTIDADE, PRECOUNITARIO, VALORTOTAL';
    case (RetornoPesquisa) of
      rpListagem:
      begin
        AJsonStr := CtrlPedidosdet.ModelPedidosdet.ListaJSon('',
                                                             '',
                                                             'SEQUENCIAL',
                                                             CamposVisiveis,
                                                             ModoPesquisa,
                                                             False,
                                                             PaginaAtual,
                                                             UTamPagina,
                                                             _Codigo);
      end;
      rpRegistro:
      begin
        AJsonStr := CtrlPedidosdet.ModelPedidosdet.RegistroJSon(CamposVisiveis, _Codigo);
      end;
    end;    

  finally
    FreeAndNil(CtrlPedidosdet);
  end;
    
  if (AJsonStr <> EmptyStr) then
  begin
    LimpaDadosGrid(StgLista);

    JsonToStringGrid(AJsonStr, StgLista);
    StgLista.VerticalAlignment := vaCenter;
    EstabeleceLarguras(StgLista, 0);

    StgLista.ColsDefaultAlignment[0] := taCenter;       // Centraliza a coluna 0
    StgLista.ColsDefaultAlignment[1] := taCenter;       // Centraliza a coluna 1
    StgLista.ColsDefaultAlignment[2] := taLeftJustify;  // Justifica a esquerda a coluna 2
    StgLista.ColsDefaultAlignment[3] := taRightJustify; // Justifica a direita a coluna 3
    StgLista.ColsDefaultAlignment[4] := taRightJustify; // Justifica a direita a coluna 4
    StgLista.ColsDefaultAlignment[5] := taRightJustify; // Justifica a direita a coluna 5

    // Habililita botões
    BtnAlterar.Enabled := True;
    BtnExcluir.Enabled := True;
  end
  else begin
    if (UEdtPesquisaAlterado) then
      LimpaDadosGrid(StgLista);

    UPaginaAtual := UPaginaAtual - 1;
    if (UPaginaAtual <= 0) then
      UPaginaAtual := 1;

    // Desabililita botões
    BtnAlterar.Enabled := False;
    BtnExcluir.Enabled := False;
  end;

  UEdtPesquisaAlterado := False;

end;

procedure TFrmPedidosdet.GeraRegistroPedidos(CodCliente: Integer);
var
  Erro: String;
  CtrlPedidos: TControllerPedidos;
begin
  Erro := '';
  CtrlPedidos := TControllerPedidos.Create;

  try
    // Preenche os valores pertinentes para a tabela de PEDIDOS.
    CtrlPedidos.ModelPedidos.AcaoDePersistencia := adpInclusao;
    CtrlPedidos.ModelPedidos.InicializaValores;

    UCodPedido := CtrlPedidos.ModelPedidos.ProximoCodigo;
    CtrlPedidos.ModelPedidos.CODIGO := UCodPedido;
    CtrlPedidos.ModelPedidos.CODCLIENTE := CodCliente;
    CtrlPedidos.ModelPedidos.DATAEMISSAO := Now;
    CtrlPedidos.ModelPedidos.VALORTOTAL := 0;

    if not (CtrlPedidos.ModelPedidos.Persistir(Erro)) then
      MessageDlgPos(Erro, mtError, [mbOk], 0, GetXMsg(Self), GetYMsg(Self));

  finally
    FreeAndNil(CtrlPedidos);
  end;

end;

procedure TFrmPedidosdet.CarregaRegistroDosProdutos(CodProduto, Descricao, PrecoVenda: String);
begin
  LimparCampos;

  UCodProduto := 0;
  UCodProduto := StrToIntDef(CodProduto, 0);
  
  EdtCodProduto.Text := CodProduto;
  EdtDescProduto.Text := Descricao;
  EdtQtdProduto.Text := '1';
  EdtVUnitProduto.Text := FormatFloat('###,##0.00', StrToFloatDef(PrecoVenda, 0));

end;

procedure TFrmPedidosdet.LimparCampos;
var
  I: Integer;
begin
  for I := ComponentCount - 1 downto 0 do
  begin
    if (Components[I] is TEdit) then
      (Components[I] as TEdit).Clear;
  end;

end;

procedure TFrmPedidosdet.CarregaPanTotais;
var
  I: Integer;
  ValorTotal: Double;
begin
  ValorTotal := 0;

  for I := 1 to StgLista.RowCount - 1 do
  begin
    if (StgLista.Cells[3, I] <> EmptyStr) then
      ValorTotal := ValorTotal + StrToFloat(StgLista.Cells[5, I]);
  end;
  panTotal.Caption := '';
  panTotal.Caption := FormatFloat('###,##0.00', ValorTotal);

end;

procedure TFrmPedidosdet.AlterarDadosProduto;
var
  Sequencial: Integer;
  CtrlPedidosdet: TControllerPedidosdet;
begin
  if (URow = 0) then
    URow := 1;

  if (StgLista.Cells[0, URow] = EmptyStr) then
    Exit;

  Sequencial := StrToInt(StgLista.Cells[0, URow]);
  CtrlPedidosdet := TControllerPedidosdet.Create;
  Application.CreateForm(TFrmPedidosdetEd, FrmPedidosdetEd);

  try
    FrmPedidosdetEd.FAcaoDePersistencia := adpAlteracao;
    Position:= poOwnerFormCenter;

    CtrlPedidosdet.ModelPedidosdet.Ler(UCodPedido, Sequencial);

    FrmPedidosdetEd.FCodPedidos := CtrlPedidosdet.ModelPedidosdet.CODIGO;
    FrmPedidosdetEd.FSequencial := CtrlPedidosdet.ModelPedidosdet.SEQUENCIAL;
    FrmPedidosdetEd.FCodProduto := CtrlPedidosdet.ModelPedidosdet.CODPRODUTO;
    FrmPedidosdetEd.EdtPrecounitario.Text := FloatToStr(CtrlPedidosdet.ModelPedidosdet.PRECOUNITARIO);
    FrmPedidosdetEd.EdtQuantidade.text := FloatToStr(CtrlPedidosdet.ModelPedidosdet.QUANTIDADE);
    FrmPedidosdetEd.EdtDescProduto.Text := StgLista.Cells[2, URow];

    FrmPedidosdetEd.ShowModal;

    if (FrmPedidosdetEd.ModalResult = mrOK) then
    begin
      UPaginaAtual := 1;
      Pesquisa(rpRegistro, UPaginaAtual, UTamPagina, UCodPedido);
      CarregaPanTotais;
    end;

  finally
    FreeAndNil(FrmPedidosdetEd);
    FreeAndNil(CtrlPedidosdet);
  end;

end;

end.

