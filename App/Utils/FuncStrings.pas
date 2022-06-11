unit FuncStrings;

// Esta unidade contem diversas funÁıes simples envolvendo strings.

interface

uses System.Classes, Vcl.Forms, System.ConvUtils, System.SysUtils, Controller.DeclTiposConsts;

procedure SeparaLinha(Resultado: TStrings; Linha: String; Separador: Char);

// FunÁıes que envolvem vari·veis booleanas
function BooleanToStrChar(B: Boolean): String;
function BooleanToStr(B: Boolean): String;
function StrToBoolean(S: String): Boolean;
function StrToBooleanDef(S: String; B: Boolean): Boolean;
function GetXMsg(Form: TForm): Integer;
function GetYMsg(Form: TForm): Integer;

function CustomFormatDateTime(const Format: String; DateTime: TDateTime): String;

function EliminaAcentos(Texto: String): string;

function CapitalizaNomeProprio(_Texto: String): String;
function FormataCNPJ(CnpjSemMascara: string): string;

function ModoPesquisaToString(ModoPesquisa: TModoPesquisa): String;
function StringToModoPesquisa(StrModoPesquisa: String): TModoPesquisa;

function EliminaCaracteres(AString, AEliminar: string; FormaEliminacao: TFormaEliminacao): string;
function ExisteCampo(Campo, CamposVisiveis: String): Boolean;

implementation

procedure SeparaLinha(Resultado: TStrings; Linha: String; Separador: Char);
var
  I, Cont: Integer;
  PosSeparador: Array of Integer; // posiÁ„o do separador #173
begin
  Linha := Separador + Linha + Separador;
  // Para achar o tamanho do array  PosSeparador:
  Cont := 0;
  for I := 1 to Length(Linha) do
  begin
    if Linha[I] = Separador then // ≠=alt-0173
      inc(Cont);
  end;
  // Estabelece o tamanho de PosSeparador:
  PosSeparador := [];
  SetLength(PosSeparador, Cont + 2);

  // faz o "parsing"
  Cont := 0;
  for I := 1 to Length(Linha) do
  begin
    if Linha[I] = Separador then // ≠=alt-0173
    begin
      inc(Cont);
      PosSeparador[Cont] := I;
    end;
  end;
  Resultado.Clear;
  for I := 1 to Cont - 1 do // valores
    Resultado.Add(Copy(Linha, PosSeparador[I] + 1, PosSeparador[I + 1] - PosSeparador[I] - 1));

end;

function BooleanToStrChar(B: Boolean): String;
begin
  if B then
    Result := 'T'
  else
    Result := 'F';
end;

function BooleanToStr(B: Boolean): String;
begin
  if B then
    Result := 'True'
  else
    Result := 'False';
end;

function StrToBoolean(S: String): Boolean;
begin
  Result := False;
  if (UpperCase(S) = 'T') or (UpperCase(S) = 'TRUE') then
    Result := true
  else if (UpperCase(S) = 'F') or (UpperCase(S) = 'FALSE') then
    Result := False
  else
    RaiseConversionError('N„o È possÌvel converter "' + S + '" para boolean.');
end;

function StrToBooleanDef(S: String; B: Boolean): Boolean;
begin
  if (UpperCase(S) = 'T') or (UpperCase(S) = 'TRUE') then
    Result := true
  else if (UpperCase(S) = 'F') or (UpperCase(S) = 'FALSE') then
    Result := False
  else
    Result := B;
end;

function CustomFormatDateTime(const Format: String; DateTime: TDateTime): String;
begin
  if DateTime = 0 then
    Result := ''
  else
    Result := FormatDateTime(Format, DateTime);
end;

function GetXMsg(Form: TForm): Integer;
begin
  // Largura da janela do dialogo: 344
  Result := Form.Left + (Form.ClientWidth - 344) div 2;
end;

function GetYMsg(Form: TForm): Integer;
begin
  // Altura da janela do dialogo: 87
  Result := Form.Top + (Form.ClientHeight - 87) div 2;
end;

function EliminaAcentos(Texto: String): string;
var
  I, X : integer;
const
  ComAcento = '·‡‚„‰ÈËÍÎÌÏÓÔÛÚÙıˆ˙˘˚¸ÁÒ¡¿¬√ƒ…» ÀÕÃŒœ”“‘’÷⁄Ÿ€‹«—';
  SemAcento = 'aaaaaeeeeiiiiooooouuuucnAAAAAEEEEIIIIOOOOOUUUUCN';
begin
  Result := Texto;
  for I := 1 to length(Texto) do
  begin
    X := Pos(Texto[I], ComAcento);
    if X <> 0 then
      Result := Copy(Result, 1, I-1) + SemAcento[X] + Copy(Result, I+1, Length(Result));
  end;
end;

function CapitalizaNomeProprio(_Texto: String): String;
var
  I, J, TamTexto: Integer;
  Palavra: TStrings;
begin
  // FunÁ„o que capitaliza nomes prÛprios compostos, independentemente se estiverem em mai˙sculo ou em min˙sculo.
  // Capitaliza para min˙sculo os caracteres 'E', 'DA', 'DE', 'DO', 'DAS', 'DOS'.
  // O caracter romano 'III' fica em mai˙sculo.
  // Exemplo de como a funÁ„o pode receber o texto: EXECOM INFORM¡TICA
  // Exemplo de retorno: Execom Inform·tica

  Result := AnsiLowerCase(_Texto);
  TamTexto := Length(Result);

  Palavra := TStringList.Create;

  with (Palavra) do
  begin
    Add(' e ');
    Add(' da ');
    Add(' de ');
    Add(' do ');
    Add(' das ');
    Add(' dos ');
    Add('III');
  end;

  try
    for J := 1 to TamTexto do
    begin
      if (J = 1) or ((J > 1) and (Result[J - 1] = ' ')) then
        Result[J] := AnsiUpperCase(Result[J])[1];
    end;

    for I := 0 to Palavra.Count - 1 do
      Result := StringReplace(Result, Palavra[I], Palavra[I], [rfReplaceAll, rfIgnoreCase]);

  finally
    Palavra.Free;
  end;
end;

function FormataCNPJ(CnpjSemMascara: string): string;
begin
  Result := Copy(CnpjSemMascara,1,2) + '.' +
            Copy(CnpjSemMascara,3,3) + '.' +
            Copy(CnpjSemMascara,6,3) + '/' +
            Copy(CnpjSemMascara,9,4) + '-' +
            Copy(CnpjSemMascara,13,2);

end;

function ModoPesquisaToString(ModoPesquisa: TModoPesquisa): String;
begin
  case ModoPesquisa of
    mpComecaCom: Result := 'mpComecaCom' ;
    mpContem: Result := 'mpContem' ;
    mpIgual: Result := 'mpIgual' ;
  end;
end;

function StringToModoPesquisa(StrModoPesquisa: String): TModoPesquisa;
begin
  if StrModoPesquisa =  'mpComecaCom' then
    Result := mpComecaCom
  else if StrModoPesquisa =  'mpContem' then
    Result := mpContem
  else if StrModoPesquisa =  'mpIgual' then
    Result := mpIgual
  else
    Result := mpComecaCom;
end;

function EliminaCaracteres(AString, AEliminar: string; FormaEliminacao: TFormaEliminacao): string;
var i, X: integer;
begin
  if FormaEliminacao = feString then //elimina ocorrencias de AEliminar dentro de AString
  begin
    while Pos(AEliminar, AString) > 0 do
    begin
      X := Pos(AEliminar, AString);
      AString := Copy(AString,1,X-1) + Copy(AString,X+Length(AEliminar),Length(AString));
    end;
    Result := AString;
  end
  else if FormaEliminacao = feQualquer then //elimina qualquer caractere de AString que pertenÁa a AEliminar
  begin
    for i := 1 to Length(AEliminar) do
    begin
      while Pos(AEliminar[i], AString) > 0 do
      begin
        X := Pos(AEliminar[i], AString);
        AString := Copy(AString,1,X-1) + Copy(AString,X+1,Length(AString));
      end;
    end;
    Result := AString;
  end;
end;

function ExisteCampo(Campo, CamposVisiveis: String): Boolean;
begin
  // CamposVisiveis => campos da query separados por vÌrgula
  CamposVisiveis := EliminaCaracteres(CamposVisiveis, ' ', feQualquer);
  CamposVisiveis := ',' + CamposVisiveis + ',';
  Campo := ',' + Campo + ',';
  Result := Pos(Campo, CamposVisiveis) <> 0;
end;

end.
