unit StringGridUtils;

interface

uses
  Vcl.Grids, AlignedTStringGrid;

procedure JsonToStringGrid(JSonStr: String; AGrid: TStringGrid);
procedure EstabeleceLarguras(AGrid: TStringGrid; LarguraMax: Integer);
procedure DeleteColumn(Grid: TStringGrid; AColumn: Integer);
procedure LimpaDadosGrid(Grid: TStringGrid);
procedure FormataCpfGrid(Grid: TStringGrid; ColunaCPF: Integer);
procedure CopyGridSelectionToClipBoard(Grid: TStringGrid; Selection: TGridRect);
procedure SortGrid(Grid: TStringGrid; SortCol: Integer; ENumero: Boolean);
procedure InsertRows(Grid: TStringGrid; RowIndex, RCount: Integer);
procedure RemoveRows(Grid: TStringGrid; RowIndex, RCount: Integer);

implementation

uses
  System.Classes, System.StrUtils, System.SysUtils, Vcl.ClipBrd, FuncStrings;

procedure JsonToStringGrid(JSonStr: String; AGrid: TStringGrid);
var
  I, J, X: integer;
  Bloco: TStrings;
  Registro: TStrings;
  Aux: String;
begin
  // Formata o Grid
  LimpaDadosGrid(AGrid);

  AGrid.DefaultRowHeight := 18;
  AGrid.DefaultColWidth := 50;
  AGrid.Options := AGrid.Options + [goColSizing, goRowSizing, goDrawFocusSelected, goAlwaysShowEditor];
  AGrid.DrawingStyle := gdsGradient;
  AGrid.FixedCols := 0;
  AGrid.FixedRows := 1;

  // Caso o grid não seja multilinhas então separa-se as linhas de um memo com Pi (#182)
  if not Agrid.MultLine then
    JSonStr := ReplaceStr(JSonStr, #$D#$A, #182);

  // Inicia transferência dos dados para o grid
  Aux := ReplaceStr(JSonStr, '},', #173);
  Aux := ReplaceStr(Aux, ',"',#172);
  Aux := ReplaceStr(Aux, '[{', '');
  Aux := ReplaceStr(Aux, '}]', '');
  Aux := ReplaceStr(Aux, '{', '');
  Aux := ReplaceStr(Aux, '"', '');
  Aux := ReplaceStr(Aux, 'null', '');

  Bloco := TStringList.Create;
  Registro := TStringList.Create;
  try
    SeparaLinha(Bloco, Aux, #173);

    SeparaLinha(Registro, Bloco[0], #172);

    AGrid.RowCount := Bloco.Count + 1;// + 1 para a linha de cabeçalho (linha 0);
    AGrid.ColCount := Registro.Count;

    // Cria a linha de cabeçalho
    for I:= 0 to Registro.Count - 1 do
    begin
      X := Pos(':', Registro[I]);
      AGrid.Cells[I, 0] := Copy(Registro[I], 1, X - 1);
    end;

    // Cria as linhas de dados
    for J := 1 to AGrid.RowCount - 1 do
    begin
      SeparaLinha(Registro, Bloco[J-1], #172);
      for I := 0 to Registro.Count - 1 do
      begin
        X := Pos(':', Registro[I]);
          AGrid.Cells[I, J] := Copy(Registro[I], X + 1, Length(Registro[I]));
      end;
    end;

    // Estabelece as larguras
    EstabeleceLarguras(AGrid, 0);

  finally
    FreeAndNil(Bloco);
    FreeAndNil(Registro);
  end;

end;

procedure EstabeleceLarguras(AGrid: TStringGrid; LarguraMax: Integer);
var
  I, J, L, LarguraMin: Integer;
  FatorLargura: Double;
begin
  FatorLargura := 7; // Fator multiplicador para achar a largura da coluna
  LarguraMin := 30;
  for I := 0 to AGrid.ColCount - 1 do
  begin
    AGrid.ColWidths[I] := LarguraMin;
    L := LarguraMin;
    for J := 0 to AGrid.RowCount - 1 do
    begin
      if (Length(AGrid.Cells[I, J]) * FatorLargura > L) then
        L := Round(Length(AGrid.Cells[I, J]) * FatorLargura);
    end;
    if (LarguraMax > 0) then
    begin
      if (L <= LarguraMax) then
        AGrid.ColWidths[I] := L
      else
        AGrid.ColWidths[I] := LarguraMax;
    end
    else if (L >= LarguraMin) then
      AGrid.ColWidths[I] := L
    else
      AGrid.ColWidths[I] := LarguraMin;

  end;

end;

procedure DeleteColumn(Grid: TStringGrid; AColumn: Integer);
var
  I: Integer;
begin
  for I := AColumn to Grid.ColCount - 1 do
    Grid.Cols[I].Assign(Grid.Cols[I + 1]);
  Grid.ColCount := Grid.ColCount - 1;

end;

procedure LimpaDadosGrid(Grid: TStringGrid);
var
  I, J: Integer;
begin
  with Grid do
  begin
    for I := 0 to ColCount - 1 do
      for J := 1 to RowCount - 1 do
        Cells[I, J] := '';
    RowCount := 2;
  end;

end;

procedure FormataCpfGrid(Grid: TStringGrid; ColunaCPF: Integer);
var
  I, J: Integer;
  S: String;
begin
  with Grid do
  begin
    I := ColunaCPF;
    for J := 1 to RowCount - 1 do
    begin
      S := Cells[I, J];
      if (S <> EmptyStr) then
      begin
        S := Copy(S, 1, 3) + '.' + Copy(S, 4, 3) + '.' + Copy(S, 7, 3) + '-' + Copy(S, 10, 2);
        Cells[I, J] := S;
      end;
    end;
  end;

end;

procedure CopyGridSelectionToClipBoard(Grid: TStringGrid; Selection: TGridRect);
const
  TAB = #9;
  CR = #13;
var
  R, C: Integer;
  S: String;
begin
  S := '';
  for R := Selection.Top to Selection.Bottom do
  begin
    for C := Selection.Left to Selection.Right do
    begin
      S := S + Grid.Cells[C, R];
      if (C < Selection.Right) then
        S := S + TAB;
    end;
    if (R < Selection.Bottom) then
      S := S + CR;
  end;
  ClipBoard.SetTextBuf(PChar(S));
end;

procedure SortGrid(Grid: TStringGrid; SortCol: Integer; ENumero: Boolean);
//A simple exchange sort of grid rows
var
  I, J: Integer;
  Temp: TStringList;
  Comp: Boolean;
begin
  Temp := TStringList.Create;
  with Grid do
    for I := FixedRows to RowCount - 2 do // Because last row has no next row
      for J := I + 1 to RowCount - 1 do   // From next row to end
      begin
        if not (ENumero) then
           Comp := AnsiCompareText(Cells[SortCol, I], Cells[SortCol, J]) > 0
        else
           Comp := StrToFloatDef(Cells[SortCol, I], 0) > StrToFloatDef(Cells[SortCol, J], 0);
        if (Comp) then
        begin
          Temp.Assign(Rows[J]);
          Rows[J].Assign(Rows[I]);
          Rows[I].Assign(Temp);
        end;
      end;
  Temp.Free;

end;

procedure InsertRows(Grid: TStringGrid; RowIndex, RCount: Integer);
var
  I: Integer;
begin
  with Grid do
  begin
    RowCount := RowCount + RCount;

    for I := RowCount - 1 downto RowIndex do
      Rows[I] := Rows[I - RCount];
  end;

end;

procedure RemoveRows(Grid: TStringGrid; RowIndex, RCount: Integer);
var
  I: Integer;
begin
  with Grid do
  begin
    for I := RowIndex to RowCount - 1 do
      Rows[I] := Rows[I + RCount];

    RowCount := RowCount - RCount;
  end;

end;

end.
