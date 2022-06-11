unit View.FrmClientes;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
   System.StrUtils, System.UITypes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
   Vcl.Grids, Vcl.StdCtrls, Vcl.Mask, Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus,
   Controller.DeclTiposConsts, AlignedTStringGrid, Vcl.Imaging.pngimage;

type
  TFrmClientes = class(TForm)
    CboCampoPesquisa: TComboBox;
    CboModoPesquisa: TComboBox;
    CboOrdem: TComboBox;
    ChkDescendente: TCheckBox;
    EdtPesquisa: TEdit;
    LblCampoPesquisa: TLabel;
    LblOrdem: TLabel;
    PanFiltro: TPanel;
    StgLista: TStringGrid;
    BtnRetornar: TBitBtn;
    BtnAvancar: TBitBtn;
    Label1: TLabel;
    Bevel1: TBevel;
    BtnConfirmaCliente: TBitBtn;
    Label2: TLabel;
    procedure BtnAvancarClick(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
    procedure BtnRetornarClick(Sender: TObject);
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
    procedure BtnConfirmaClienteClick(Sender: TObject);
  private
    { Private declarations }
    procedure Pesquisa(RetornoPesquisa: TRetornoPesquisa; PaginaAtual: Integer; TamPagina: Word; _Codigo: Integer);
  public
    { Public declarations }
  end;

var
  FrmClientes: TFrmClientes;

implementation

uses View.FrmPrincipal, Controller.Clientes, StringGridUtils, FuncStrings, View.FrmPedidosDet;

{$R *.DFM}

var
  UPaginaAtual, UCol, URow: Integer;
  UTamPagina: Word;
  UEdtPesquisaAlterado: Boolean;

{ TFrmClientes }

procedure TFrmClientes.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FrmPrincipal.MostraEscondePanFundo(True);
  Action := caFree;

end;

procedure TFrmClientes.BtnRetornarClick(Sender: TObject);
begin
  Dec(UPaginaAtual);
  if UPaginaAtual <= 0 then
    UPaginaAtual := 1;
  Pesquisa(rpListagem, UPaginaAtual, UTamPagina, 0);

end;

procedure TFrmClientes.CboCampoPesquisaChange(Sender: TObject);
begin
  UPaginaAtual := 1;

end;

procedure TFrmClientes.CboOrdemChange(Sender: TObject);
begin
  UPaginaAtual := 1;
  Pesquisa(rpListagem, UPaginaAtual, UTamPagina, 0);

end;

procedure TFrmClientes.ChkDescendenteClick(Sender: TObject);
begin
  UPaginaAtual := 1;
  Pesquisa(rpListagem, UPaginaAtual, UTamPagina, 0);

end;

procedure TFrmClientes.EdtPesquisaChange(Sender: TObject);
begin
  UEdtPesquisaAlterado := True;
  BtnAvancar.Enabled := False;
  BtnRetornar.Enabled := False;

end;

procedure TFrmClientes.BtnAvancarClick(Sender: TObject);
begin
  Inc(UPaginaAtual);
  Pesquisa(rpListagem, UPaginaAtual, UTamPagina, 0);

end;

procedure TFrmClientes.BtnConfirmaClienteClick(Sender: TObject);
var
  I, Codigo: Integer;
begin
  if (URow = 0) then
    URow := 1;

  if (StgLista.Cells[0, URow] = EmptyStr) then
    Exit
  else begin

    try
      Screen.Cursor := crHourglass;

      FrmPrincipal.PanGeral.Visible := False;

      Application.CreateForm(TFrmPedidosDet, FrmPedidosDet);
      FrmPedidosDet.BringToFront;
      FrmPedidosDet.WindowState := wsMaximized;
      FrmPedidosDet.GeraRegistroPedidos(StrToInt(StgLista.Cells[0, URow]));
      FrmPedidosDet.Show;

    finally
      FrmClientes.Close;
      Screen.Cursor := crDefault;
    end;
  end;

end;

procedure TFrmClientes.BtnExcluirClick(Sender: TObject);
var
  _Codigo: Integer;
  MsgErro: String;
  CtrlClientes: TControllerClientes;
begin
  if (URow = 0) then
    URow := 1;

  if (StgLista.Cells[0, URow] = EmptyStr) then
    Exit
  else if (MessageDlgPos('Confirma a exclusão', mtConfirmation, [mbYes, mbNo], 0, GetXMsg(Self), GetYMsg(Self), mbNo) = mrYes) then
  begin
    _Codigo := StrToInt(StgLista.Cells[0, URow]);
    CtrlClientes := TControllerClientes.Create;
    try
      with CtrlClientes.ModelClientes do
      begin
        AcaoDePersistencia := adpExclusao;
        Codigo := _Codigo;

        if (CtrlClientes.ModelClientes.Persistir(MsgErro)) then
        begin
          EdtPesquisa.Text := '';
          Pesquisa(rpListagem, UPaginaAtual, UTamPagina, 0);
        end
        else
          MessageDlgPos(MsgErro, mtError, [mbOk], 0, GetXMsg(Self), GetYMsg(Self));
      end;

    finally
      FreeAndNil(CtrlClientes);
    end;

  end;

end;

procedure TFrmClientes.FormCreate(Sender: TObject);
begin
  KeyPreview := True;
  CboModoPesquisa.ItemIndex := 0;
  CboOrdem.ItemIndex := 1;

  UTamPagina := 20;
  UPaginaAtual := 1;
  UEdtPesquisaAlterado := False;

  Pesquisa(rpListagem, UPaginaAtual, UTamPagina, 0);

end;

procedure TFrmClientes.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if not (ActiveControl is TStringGrid) then
  begin
    if (Key = VK_UP) and (Shift = []) then
      SelectNext(ActiveControl, False, True)
    else if ((Key = VK_DOWN) or (Key = VK_RETURN)) and (Shift = []) and not (ActiveControl is TButtonControl) then
      SelectNext(ActiveControl, True, True);
  end;

  if (Key = VK_F5) then
    BtnConfirmaClienteClick(Sender);

end;

procedure TFrmClientes.mniCopiarClick(Sender: TObject);
begin
  CopyGridSelectionToClipBoard(StgLista, StgLista.Selection);

end;

procedure TFrmClientes.mniOrdenarClick(Sender: TObject);
begin
  if UCol = 0 then // ID
    SortGrid(StgLista, UCol, True)
  else
    SortGrid(StgLista, UCol, False);
end;

procedure TFrmClientes.StgListaSelectCell(Sender: TObject; aCol, aRow: Integer; var CanSelect: Boolean);
begin
  UCol := ACol;
  URow := ARow;

end;

procedure TFrmClientes.Pesquisa(RetornoPesquisa: TRetornoPesquisa; PaginaAtual: Integer; TamPagina: Word; _Codigo: Integer);
var
  AJsonStr, CamposVisiveis: String;
  ModoPesquisa: TModoPesquisa;
  CtrlClientes: TControllerClientes;
begin
  LimpaDadosGrid(StgLista);

  ModoPesquisa := mpComecaCom; // Default
  case (CboModoPesquisa.ItemIndex) of
    1: ModoPesquisa := mpContem;
    2: ModoPesquisa := mpIgual;
  end;

  CtrlClientes := TControllerClientes.Create;
  try
    CamposVisiveis := 'CODIGO, NOME';
    case (RetornoPesquisa) of
      rpListagem:
      begin
        AJsonStr := CtrlClientes.ModelClientes.ListaJSon(EdtPesquisa.Text,
                                                         CboCampoPesquisa.Text,
                                                         CboOrdem.Text,
                                                         CamposVisiveis,
                                                         ModoPesquisa,
                                                         ChkDescendente.Checked,
                                                         PaginaAtual,
                                                         UTamPagina,
                                                         _Codigo);
      end;
      rpRegistro:
      begin
        AJsonStr := CtrlClientes.ModelClientes.RegistroJSon(CamposVisiveis, _Codigo);
      end;
    end;    

  finally
    FreeAndNil(CtrlClientes);
  end;
    
  if (AJsonStr <> EmptyStr) then
  begin
    LimpaDadosGrid(StgLista);

    JsonToStringGrid(AJsonStr, StgLista);
    StgLista.VerticalAlignment := vaCenter;
    EstabeleceLarguras(StgLista, 0);

    StgLista.ColsDefaultAlignment[0] := taCenter;  // Centraliza a coluna 0

    // Habililita botões
    BtnAvancar.Enabled := True;
    BtnRetornar.Enabled := True;
  end
  else begin
    if (UEdtPesquisaAlterado) then
      LimpaDadosGrid(StgLista);

    UPaginaAtual := UPaginaAtual - 1;
    if (UPaginaAtual <= 0) then
      UPaginaAtual := 1;

    // Desabililita botões
    BtnAvancar.Enabled := False;
  end;

  UEdtPesquisaAlterado := False;

end;

end.
