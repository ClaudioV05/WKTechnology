unit JSonUtils;

interface

uses
  FireDAC.Comp.Client, System.JSON, REST.Response.Adapter, System.Classes;

procedure JsonToListaRegistros(Registros: TStrings; JSonStr: String);
procedure DataSetToJson(ADataset: TFDQuery; var AJson: String);

implementation

uses
  System.SysUtils, Data.DB, System.StrUtils, FuncStrings;

procedure JsonToListaRegistros(Registros: TStrings; JSonStr: String);
var
  I, J, X: Integer;
  Bloco: TStrings;
  Registro: TStrings;
  Aux, ValorCampo: String;
begin
  Registros.Clear;

  Aux := ReplaceStr(JSonStr, '},', #173);
  Aux := ReplaceStr(Aux, ',"', #172);
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

    // cria as linhas de dados
    for J := 0 to Bloco.Count - 1 do
    begin
      SeparaLinha(Registro, Bloco[J], #172);
      Aux := '';
      for I := 0 to Registro.Count - 1 do
      begin
        X := Pos(':', Registro[I]);
        ValorCampo := Copy(Registro[I], X+1, Length(Registro[I]));
        Aux := Aux + ValorCampo + #173;
      end;
      // elimina último #173 delimitador
     Aux := LeftStr(Aux, Length(Aux)-1);
     Registros.Add(Aux);
    end;

  finally
    FreeAndNil(Bloco);
    FreeAndNil(Registro);
  end;

end;

procedure DataSetToJson(ADataset: TFDQuery; var AJson: String);

  function Aspas(Texto: String): String;
  begin
    Result := '"' + Texto + '"';
  end;

  function Chaves(Texto: String): String;
  begin
    Result := '{' + Texto + '}';
  end;

  function Colchetes(Texto: String): String;
  begin
    Result := '[' + Texto + ']';
  end;

var
  I: Integer;
  S, NomeCampo, Valor, Reg, Aux: String;
begin
  S := '';
  with ADataset do
  begin
    First;
    while not Eof do
    begin
      Reg := '';
      for I := 0 to Fields.Count - 1 do
      begin
        NomeCampo := Aspas(Fields[I].DisplayLabel);
        Valor := '';
        if Fields[I].AsString = '' then
        begin
          Valor := 'null';
        end
        else
        begin
          case Fields[I].DataType of
            ftSmallint, ftInteger, ftWord:
              Valor := IntToStr(Fields[I].Value);
            ftFloat, ftCurrency:
              Valor := FloatToStr(Fields[I].Value);
          else
            Valor := Aspas(Fields[I].AsString);
          end;

        end;
        Aux := NomeCampo + ':' + Valor;
        if I < Fields.Count - 1 then
          Aux := Aux + ',';
        Reg := Reg + Aux;
      end;
      Reg := Chaves(Reg);
      Reg := Reg + ',';
      S := S + Reg;
      Next;
    end;
  end;
  // elimina última vírgula delimitadora
  S := Copy(S, 1, Length(S) - 1);
  S := Colchetes(S);

  AJson := S;

end;

end.
