unit View.FrmPedidosdetEd;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Menus, Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.Controls, Vcl.Forms,
  Vcl.StdCtrls, System.UITypes, Vcl.Buttons, Vcl.Dialogs, Controller.DeclTiposConsts;

type
  TFrmPedidosdetEd = class(TForm)
    BtnCancelar: TBitBtn;
    BtnSalvar: TBitBtn;
    PanSalvar: TPanel;
    ScrollBox1: TScrollBox;
    LblCodigo: TLabel;
    EdtDescProduto: TEdit;
    EdtPrecounitario: TEdit;
    EdtQuantidade: TEdit;
    LblPrecounitario: TLabel;
    Label1: TLabel;
    procedure BtnSalvarClick(Sender: TObject);
    procedure EditsChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FAcaoDePersistencia: TAcaoDePersistencia;
    FCodPedidos, FSequencial, FCodProduto: Integer;
  end;

var
  FrmPedidosdetEd: TFrmPedidosdetEd;

implementation

uses Controller.Pedidosdet, FuncStrings;

var UHouveModificacoes: boolean;

{$R *.DFM}

{ TFrmPedidosdetEd }

procedure TFrmPedidosdetEd.FormShow(Sender: TObject);
var I: Integer;
begin
  case FAcaoDePersistencia of
    adpInclusao:
    begin
      for I := 0 to ComponentCount - 1 do
      begin
        if Components[I] is TEdit then
          (Components[I] as TEdit).Clear;
      end;
    end;
    adpAlteracao:
    begin

    end;
  end;
  BtnSalvar.Enabled := False;
  UHouveModificacoes := False;
end;

procedure TFrmPedidosdetEd.FormCreate(Sender: TObject);
begin
  KeyPreview := True;

end;

procedure TFrmPedidosdetEd.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_F12) then
    BtnSalvarClick(Sender);

end;

procedure TFrmPedidosdetEd.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if UHouveModificacoes then
  begin
    if (MessageDlgPos('Valores foram alterados. Descartar alterações?' , mtConfirmation, [mbYes, mbNo], 0, GetXMsg(Self), GetYMsg(Self), mbNo) = mrYes) then
      Close
    else
    begin
      CanClose := False;
    end;
  end

end;

procedure TFrmPedidosdetEd.EditsChange(Sender: TObject);
begin
  UHouveModificacoes := True;
  BtnSalvar.Enabled := True;
end;

procedure TFrmPedidosdetEd.BtnSalvarClick(Sender: TObject);
var
  Erro: String;
  CtrlPedidosdet: TControllerPedidosdet;
begin
  CtrlPedidosdet := TControllerPedidosdet.Create;
  try
    // Preenche os valores pertinentes
    CtrlPedidosdet.ModelPedidosdet.AcaoDePersistencia := FAcaoDePersistencia;
    CtrlPedidosdet.ModelPedidosdet.InicializaValores;

    CtrlPedidosdet.ModelPedidosdet.CODIGO := FCodPedidos;
    CtrlPedidosdet.ModelPedidosdet.SEQUENCIAL := FSequencial;
    CtrlPedidosdet.ModelPedidosdet.CODPRODUTO := FCodProduto;
    CtrlPedidosdet.ModelPedidosdet.PRECOUNITARIO := StrToFloatDef(EdtPrecounitario.Text, 0);
    CtrlPedidosdet.ModelPedidosdet.QUANTIDADE := StrToFloatDef(EdtQuantidade.Text, 0);
    CtrlPedidosdet.ModelPedidosdet.VALORTOTAL := StrToFloatDef(EdtQuantidade.Text, 0) * StrToFloatDef(EdtPrecounitario.Text, 0);

    if not (CtrlPedidosdet.ModelPedidosdet.Persistir(Erro)) then
      MessageDlgPos(Erro, mtError, [mbOk], 0, GetXMsg(Self), GetYMsg(Self))
    else begin
      UHouveModificacoes := False;
      ModalResult := mrOk;
    end;

  finally
    FreeAndNil(CtrlPedidosdet);
  end;

end;

end.
