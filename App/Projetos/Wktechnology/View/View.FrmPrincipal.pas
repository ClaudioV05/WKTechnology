unit View.FrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Menus, Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.Controls, Vcl.Forms,
  Vcl.StdCtrls, System.UITypes, Vcl.Buttons, Vcl.Imaging.pngimage;

type
  TFrmPrincipal = class(TForm)
    BtnFechaTodas: TButton;
    BtnNovaVenda: TButton;
    Image1: TImage;
    MainMenu1: TMainMenu;
    ViewNovaVenda: TMenuItem;
    FechaTodasJanelas1: TMenuItem;
    PanGeral: TPanel;
    PanFundo: TPanel;
    procedure BtnNovaVendaClick(Sender: TObject);
    procedure BtnFechaTodasClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure ConectaBanco;
    function CarregaVendorBd: String;
  public
    { Public declarations }
    procedure MostraEscondePanFundo(EFormFilho: Boolean);
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

uses Vcl.Dialogs, Controller.Conexao, Controller.DeclTiposConsts, FuncStrings,
  View.FrmPedidosdet, View.FrmClientes;

procedure TFrmPrincipal.BtnNovaVendaClick(Sender: TObject);
var
  I: Integer;
begin
  for I := MDIChildCount - 1 downto 0 do
  begin
    if (MDIChildren[I] = FrmClientes) then
    begin
      MDIChildren[I].BringToFront;
      MDIChildren[I].WindowState := wsMaximized;
      Exit;
    end;
  end;

  try
    Screen.Cursor := crHourglass;
    Application.CreateForm(TFrmClientes, FrmClientes);
    PanGeral.Visible := False;
    FrmClientes.Show;
    MostraEscondePanFundo(False);

  finally
    Screen.Cursor := crDefault;
  end;

end;

procedure TFrmPrincipal.MostraEscondePanFundo(EFormFilho: Boolean);
begin
  if EFormFilho then
  begin
    if MDIChildCount = 1 then
    begin
      PanFundo.Visible := True;
      PanGeral.Visible := True;
    end
    else
      PanFundo.Visible := False;
  end
  else
    PanFundo.Visible := MDIChildCount = 0;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  KeyPreview := True;
  PanFundo.Align := alClient;
  PanFundo.SendToBack;
  ConectaBanco;
end;

procedure TFrmPrincipal.ConectaBanco;
var
  Conectado: Boolean;
  AInfoConexaoSQL: TInfoConexaoSQL;
begin

  with AInfoConexaoSQL do
  begin
    Database  := 'wktechnology';
    DriverID  := 'MySQL';
    Password  := '';
    Protocol  := '';
    Server    := '127.0.0.1';
    Port      := '3306';
    UserName  := 'root';
    VendorLib := CarregaVendorBd;
  end;

  Conectado :=  TControllerConexao.GetInstance.DaoConexao.EstabeleceConexaoSQL(AInfoConexaoSQL);
  if (Conectado) then
  begin
    BtnNovaVenda.Enabled := True;
    ViewNovaVenda.Enabled := True;
  end
  else
    MessageDlgPos('N?o foi poss?vel conectar o bando de dados.', mtError, [mbOk], 0, GetXMsg(Self), GetYMsg(Self));

end;

procedure TFrmPrincipal.BtnFechaTodasClick(Sender: TObject);
var
  I: Integer;
begin
  with Application do
  begin
    for I := 0 to ComponentCount - 1 do
    begin
      if (Components[I] is TForm) and (Components[I].Name <> 'FrmPrincipal') then
        (Components[I] as TForm).Close;
    end;
  end;
end;

function TFrmPrincipal.CarregaVendorBd: String;
var
  Aux: String;
begin
  Aux := '';
  Aux := LowerCase(ExtractFilePath(Application.ExeName));
  Aux := Aux + 'libmysql.dll';
  Result := Aux;
end;

end.
