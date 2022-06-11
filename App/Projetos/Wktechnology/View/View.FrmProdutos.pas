unit View.FrmProdutos;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
   System.StrUtils, System.UITypes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
   Vcl.Grids, Vcl.StdCtrls, Vcl.Mask, Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus,
   Controller.DeclTiposConsts, AlignedTStringGrid, NumEdit, Vcl.Imaging.pngimage, EnterEdit;

type
  TFrmProdutos = class(TForm)
    mnuGrid: TPopupMenu;
    mniCopiar: TMenuItem;
    mniOrdenar: TMenuItem;
    PanFiltro: TPanel;
    StgLista: TStringGrid;
    BtnConfirmar: TBitBtn;
    procedure CboOrdemChange(Sender: TObject);
    procedure ChkDescendenteClick(Sender: TObject);
    procedure EdtDescProdutoChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mniCopiarClick(Sender: TObject);
    procedure mniOrdenarClick(Sender: TObject);
    procedure StgListaSelectCell(Sender: TObject; aCol, aRow: Integer; var CanSelect: Boolean);
    procedure BtnConfirmarClick(Sender: TObject);
  private
    { Private declarations }
    procedure Pesquisa(RetornoPesquisa: TRetornoPesquisa; PaginaAtual: Integer; TamPagina: Word; _Codigo: Integer);
  public
    { Public declarations }
  end;

var
  FrmProdutos: TFrmProdutos;

implementation

uses View.FrmPrincipal, Controller.Produtos, StringGridUtils, FuncStrings, View.FrmPedidosdet;

{$R *.DFM}

var
  UPaginaAtual, UCol, URow: Integer;
  UTamPagina: Word;
  UEdtPesquisaAlterado: Boolean;

{ TFrmProdutos }

procedure TFrmProdutos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FrmPrincipal.MostraEscondePanFundo(True);
  Action := caFree;

end;

procedure TFrmProdutos.BtnConfirmarClick(Sender: TObject);
begin
  if (URow = 0) then
    URow := 1;

  FrmPedidosdet.CarregaRegistroDosProdutos(StgLista.Cells[0, URow], // Código
                                           StgLista.Cells[1, URow], // Descrição
                                           StgLista.Cells[2, URow]); // Preço venda

  FrmProdutos.SendToBack;
  FrmProdutos.Close;

end;

procedure TFrmProdutos.CboOrdemChange(Sender: TObject);
begin
  UPaginaAtual := 1;
  Pesquisa(rpListagem, UPaginaAtual, UTamPagina, 0);

end;

procedure TFrmProdutos.ChkDescendenteClick(Sender: TObject);
begin
  UPaginaAtual := 1;
  Pesquisa(rpListagem, UPaginaAtual, UTamPagina, 0);

end;

procedure TFrmProdutos.EdtDescProdutoChange(Sender: TObject);
begin
  UEdtPesquisaAlterado := True;

end;

procedure TFrmProdutos.FormCreate(Sender: TObject);
begin
  KeyPreview := True;

  UTamPagina := 20;
  UPaginaAtual := 1;
  UEdtPesquisaAlterado := False;

  Pesquisa(rpListagem, UPaginaAtual, UTamPagina, 0);

end;

procedure TFrmProdutos.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if not (ActiveControl is TStringGrid) then
  begin
    if (Key = VK_UP) and (Shift = []) then
      SelectNext(ActiveControl, False, True)
    else if ((Key = VK_DOWN) or (Key = VK_RETURN)) and (Shift = []) and not (ActiveControl is TButtonControl) then
      SelectNext(ActiveControl, True, True);
  end;

  if (Key = VK_F6) then
    BtnConfirmarClick(Sender);

end;

procedure TFrmProdutos.mniCopiarClick(Sender: TObject);
begin
  CopyGridSelectionToClipBoard(StgLista, StgLista.Selection);

end;

procedure TFrmProdutos.mniOrdenarClick(Sender: TObject);
begin
  if UCol = 0 then // ID
    SortGrid(StgLista, UCol, True)
  else
    SortGrid(StgLista, UCol, False);
end;

procedure TFrmProdutos.StgListaSelectCell(Sender: TObject; aCol, aRow: Integer; var CanSelect: Boolean);
begin
  UCol := ACol;
  URow := ARow;

end;

procedure TFrmProdutos.Pesquisa(RetornoPesquisa: TRetornoPesquisa; PaginaAtual: Integer; TamPagina: Word; _Codigo: Integer);
var
  AJsonStr, CamposVisiveis: String;
  ModoPesquisa: TModoPesquisa;
  CtrlProdutos: TControllerProdutos;
begin
  LimpaDadosGrid(StgLista);

  ModoPesquisa := mpComecaCom; // Default

  CtrlProdutos := TControllerProdutos.Create;
  try
    CamposVisiveis := 'CODIGO, DESCRICAO, PRECOVENDA, ATIVO;';
    case (RetornoPesquisa) of
      rpListagem:
      begin
        AJsonStr := CtrlProdutos.ModelProdutos.ListaJSon('',
                                                         'DESCRICAO',
                                                         'CODIGO',
                                                         CamposVisiveis,
                                                         ModoPesquisa,
                                                         False,
                                                         PaginaAtual,
                                                         UTamPagina,
                                                         _Codigo);
      end;
      rpRegistro:
      begin
        AJsonStr := CtrlProdutos.ModelProdutos.RegistroJSon(CamposVisiveis, _Codigo);
      end;
    end;    

  finally
    FreeAndNil(CtrlProdutos);
  end;
    
  if (AJsonStr <> EmptyStr) then
  begin
    LimpaDadosGrid(StgLista);

    JsonToStringGrid(AJsonStr, StgLista);
    StgLista.VerticalAlignment := vaCenter;
    EstabeleceLarguras(StgLista, 0);

    StgLista.ColsDefaultAlignment[0] := taCenter;  // Centraliza a coluna 0

  end
  else begin
    if (UEdtPesquisaAlterado) then
      LimpaDadosGrid(StgLista);

    UPaginaAtual := UPaginaAtual - 1;
    if (UPaginaAtual <= 0) then
      UPaginaAtual := 1;

  end;

  UEdtPesquisaAlterado := False;

end;

end.

