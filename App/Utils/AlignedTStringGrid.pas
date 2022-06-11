unit AlignedTStringGrid;

// ORIGINAL de https://stackoverflow.com/questions/3540570/delphi-how-to-make-cells-texts-in-tstringgrid-center-aligned
// Modificada por PFRF em 30/06/2021
// Implementada a propriedade Multline e VerticalAlignment que possibilitam apresentar a célula em várias linhas

interface

uses Windows, SysUtils, Classes, Grids;

type
  TVerticalAlignment = (vaTop, vaCenter, vaBottom);

  TStringGrid = class(Grids.TStringGrid)
  private
    FCellsAlignment: TStringList;
    FColsDefaultAlignment: TStringList;
    FMultLine: Boolean;
    FVerticalAlignment: TVerticalAlignment;
    function GetCellsAlignment(ACol, ARow: Integer): TAlignment;
    procedure SetCellsAlignment(ACol, ARow: Integer; const Alignment: TAlignment);
    function GetColsDefaultAlignment(ACol: Integer): TAlignment;
    procedure SetColsDefaultAlignment(ACol: Integer; const Alignment: TAlignment);
    procedure SetMultLine(Valor: Boolean);
    procedure SetVerticalAlignment(Valor: TVerticalAlignment);
  protected
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CellsAlignment[ACol, ARow: Integer]: TAlignment read GetCellsAlignment write SetCellsAlignment;
    property ColsDefaultAlignment[ACol: Integer]: TAlignment read GetColsDefaultAlignment write SetColsDefaultAlignment;
    property MultLine: Boolean read FMultLine write SetMultLine default True;
    property VerticalAlignment: TVerticalAlignment read FVerticalAlignment write SetVerticalAlignment default vaTop;

  end;

implementation

constructor TStringGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVerticalAlignment := vaTop;
  FCellsAlignment := TStringList.Create;
  FCellsAlignment.CaseSensitive := True;
  FCellsAlignment.Sorted := True;
  FCellsAlignment.Duplicates := dupIgnore;
  FColsDefaultAlignment := TStringList.Create;
  FColsDefaultAlignment.CaseSensitive := True;
  FColsDefaultAlignment.Sorted := True;
  FColsDefaultAlignment.Duplicates := dupIgnore;
end;

destructor TStringGrid.Destroy;
begin
  FCellsAlignment.Free;
  FColsDefaultAlignment.Free;
  inherited;
end;

procedure TStringGrid.SetCellsAlignment(ACol, ARow: Integer; const Alignment: TAlignment);
var
  Index: Integer;
begin
  if (-1 < Index) then
  begin
    FCellsAlignment.Objects[Index] := TObject(Alignment);
  end
  else
  begin
    FCellsAlignment.AddObject(IntToStr(ACol) + '-' + IntToStr(ARow), TObject(Alignment));
  end;
end;

function TStringGrid.GetCellsAlignment(ACol, ARow: Integer): TAlignment;
var
  Index: Integer;
begin
  Index := FCellsAlignment.IndexOf(IntToStr(ACol) + '-' + IntToStr(ARow));
  if (-1 < Index) then
  begin
    GetCellsAlignment := TAlignment(FCellsAlignment.Objects[Index]);
  end
  else
  begin
    GetCellsAlignment := ColsDefaultAlignment[ACol];
  end;
end;

procedure TStringGrid.SetColsDefaultAlignment(ACol: Integer; const Alignment: TAlignment);
var
  Index: Integer;
begin
  Index := FColsDefaultAlignment.IndexOf(IntToStr(ACol));
  if (-1 < Index) then
  begin
    FColsDefaultAlignment.Objects[Index] := TObject(Alignment);
  end
  else
  begin
    FColsDefaultAlignment.AddObject(IntToStr(ACol), TObject(Alignment));
  end;
end;

procedure TStringGrid.SetMultLine(Valor: Boolean);
begin
  if (Valor <> FMultLine) then
  begin
    FMultLine := Valor;
    Invalidate;
  end;
end;

procedure TStringGrid.SetVerticalAlignment(Valor: TVerticalAlignment);
begin
  if (Valor <> FVerticalAlignment) then
  begin
    FVerticalAlignment := Valor;
    Invalidate;
  end;
end;

function TStringGrid.GetColsDefaultAlignment(ACol: Integer): TAlignment;
var
  Index: Integer;
begin
  Index := FColsDefaultAlignment.IndexOf(IntToStr(ACol));
  if (-1 < Index) then
  begin
    GetColsDefaultAlignment := TAlignment(FColsDefaultAlignment.Objects[Index]);
  end
  else
  begin
    GetColsDefaultAlignment := taLeftJustify;
  end;
end;

// ORIGINAL de https://stackoverflow.com/questions/3540570/delphi-how-to-make-cells-texts-in-tstringgrid-center-aligned
// procedure TStringGrid.DrawCell(ACol,ARow:Longint;ARect:TRect;AState:TGridDrawState);
// var
//   Old_DefaultDrawing:Boolean;
// begin
//   if DefaultDrawing then
//   begin
//     case CellsAlignment[ACol,ARow] of
//       taLeftJustify: begin
//         Canvas.TextRect(ARect,ARect.Left+2,ARect.Top+2,Cells[ACol,ARow]); end;
//       taRightJustify: begin
//         Canvas.TextRect(ARect,ARect.Right -2 -Canvas.TextWidth(Cells[ACol,ARow]), ARect.Top+2,Cells[ACol,ARow]); end;
//       taCenter: begin
//         Canvas.TextRect(ARect,(ARect.Left+ARect.Right-Canvas.TextWidth(Cells[ACol,ARow]))div 2,ARect.Top+2,Cells[ACol,ARow]);  end;
//     end;
//   end;
//   Old_DefaultDrawing:= DefaultDrawing;
//   DefaultDrawing:=False;
//   inherited DrawCell(ACol,ARow,ARect,AState);
//   DefaultDrawing:= Old_DefaultDrawing;
// end;
procedure TStringGrid.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
Const
  TextAlignments: Array [TAlignment] of Word = (dt_Left, dt_Right, dt_Center);
var
  Old_DefaultDrawing: Boolean;
  Altura: Integer;
  Texto: string;
  CRect: TRect;
  HorAlignment: TAlignment;
  VerAlignment: TVerticalAlignment;
  Options: Integer;
begin

  if DefaultDrawing then
  begin
    Texto := Cells[ACol, ARow];

    case CellsAlignment[ACol, ARow] of
      taLeftJustify:
        HorAlignment := taLeftJustify;
      taRightJustify:
        HorAlignment := taRightJustify;
      taCenter:
        HorAlignment := taCenter;
    end;

    if MultLine then
    begin
      VerAlignment := FVerticalAlignment;

      Canvas.FillRect(ARect);
      Inc(ARect.Left, 2);
      Dec(ARect.Right, 2);
      CRect := ARect;
      Options := TextAlignments[HorAlignment] or dt_VCenter;
      if MultLine then
        Options := Options or dt_WordBreak;

      with ARect, Canvas do
      begin
        Altura := DrawText(Handle, PChar(Texto), -1, CRect, Options or dt_CalcRect);

        if (RowHeights[ARow] < Altura) then
          RowHeights[ARow] := Altura;
        if FVerticalAlignment = vaCenter then
        begin
          if Altura < Bottom - Top + 1 then
          begin
            Top := (Bottom + Top - Altura) shr 1;
            Bottom := Top + Altura;
          end;
        end
        else if FVerticalAlignment = vaBottom then
          if Altura < Bottom - Top + 1 then
            Top := Bottom - Altura;
        DrawText(Handle, PChar(Texto), -1, ARect, Options)
      end;
    end
    else
    begin
      case CellsAlignment[ACol, ARow] of
        taLeftJustify:
          Canvas.TextRect(ARect, ARect.Left + 2, ARect.Top + 2, Cells[ACol, ARow]);
        taRightJustify:
          Canvas.TextRect(ARect, ARect.Right - 2 - Canvas.TextWidth(Cells[ACol, ARow]), ARect.Top + 2, Cells[ACol, ARow]);
        taCenter:
          Canvas.TextRect(ARect, (ARect.Left + ARect.Right - Canvas.TextWidth(Cells[ACol, ARow])) div 2, ARect.Top + 2,
            Cells[ACol, ARow]);
      end;

    end;

  end;

  Old_DefaultDrawing := DefaultDrawing;
  DefaultDrawing := False;
  inherited DrawCell(ACol, ARow, ARect, AState);
  DefaultDrawing := Old_DefaultDrawing;
end;

end.
