unit uHlp;

interface

uses
  Data.DB,
  Vcl.Forms;

type
  THlp = class
  public
    class function  FormatDateTimeWithLastHour(AValue: TDateTime): String;
    class function  FormatDateTimeWithFirstHour(AValue: TDateTime): String;
    class function  SetDateTimeWithLastHour(AValue: TDateTime): TDateTime;
    class function  SetDateTimeWithFirstHour(AValue: TDateTime): TDateTime;
    class function  StrZero(Conteudo: String; Tamanho: Integer): String;
    class function  CreateTransparentBackground(AOwner: TForm; AlphaBlendValue: Integer = 200): TForm;
    class function  StrInt(AValue: String; ADefaultValue: Integer = 0): Integer;
    class function  StrFloat(AValue: String; ADefaultValue: Double = 0): Double;
    class procedure FormatDataSet(ADataSet: TDataSet; ADecimalPlaces: Integer = 2); // Formata Campos do DataSet
    class procedure FillDataSetWithZero(ADataSet: TDataSet; AValueInteger: Boolean = true; AValueDouble: Boolean = true);
    class function  Iif(aCondition: Boolean; aResultTrue, aResultFalse: variant): variant; // Simula operador tern·rio
    class function  RemoveAccentedChars(AValue: String): String; // Remover caracteres acentuados
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Winapi.Windows,
  System.Dateutils;

{ THlp }

class function THlp.CreateTransparentBackground(AOwner: TForm; AlphaBlendValue: Integer): TForm;
begin
  // Configurar Fundo Transparente
  Result := TForm.Create(AOwner);
  Result.AlphaBlend      := True;
  Result.AlphaBlendValue := AlphaBlendValue;
  Result.Color           := clBlack;
  Result.BorderStyle     := bsNone;
  Result.Enabled         := False;
  Result.Top             := 0;
  Result.Left            := 0;
  Result.Width           := GetSystemMetrics(SM_CXSCREEN) - (GetSystemMetrics(SM_CXSCREEN) - GetSystemMetrics(SM_CXFULLSCREEN)) + 1;
  Result.Height          := GetSystemMetrics(SM_CYSCREEN) - (GetSystemMetrics(SM_CYSCREEN) - GetSystemMetrics(SM_CYFULLSCREEN)) + GetSystemMetrics(SM_CYCAPTION) + 1;
  Result.Show;

  // Trazer form para frente - Evitar Erro
  Result.BringToFront;
  AOwner.BringToFront;
  Application.ProcessMessages;
end;

class procedure THlp.FillDataSetWithZero(ADataSet: TDataSet; AValueInteger, AValueDouble: Boolean);
var
  lI: Integer;
begin
  for lI := 0 to Pred(ADataSet.Fields.Count) do
  begin
    if (AValueInteger and (ADataSet.Fields[lI].DataType in [ftSmallint, ftInteger])) then
      ADataSet.Fields[lI].AsInteger := 0;

    if (AValueDouble and (ADataSet.Fields[lI].DataType in [ftFloat, ftCurrency, ftBCD])) then
      ADataSet.Fields[lI].AsFloat := 0;
  end;
end;

class procedure THlp.FormatDataSet(ADataSet: TDataSet; ADecimalPlaces: Integer);
Var
  lI: Integer;
  lDecimalPlacesMask: String;
begin
  lDecimalPlacesMask := '';
  case ADecimalPlaces of
    1: lDecimalPlacesMask := '#,###,##0.0';
    2: lDecimalPlacesMask := '#,###,##0.00';
    3: lDecimalPlacesMask := '#,###,##0.000';
    4: lDecimalPlacesMask := '#,###,##0.0000';
  end;

  // Evitar erro
  if (lDecimalPlacesMask = '') then
    lDecimalPlacesMask := '#,###,##0.00';

  // Formatar campos
  for lI := 0 to ADataSet.Fields.Count-1 do
  Begin
    ADataSet.Fields[lI].Alignment := taLeftJustify;
    if ADataSet.Fields[lI].DataType in [ftFloat, ftCurrency, ftBCD] Then
    Begin
      TBCDField(ADataSet.Fields[lI]).DisplayFormat := '#,###,##0.00';
      ADataSet.Fields[lI].Alignment := taRightJustify;
    End;
  End;
end;

class function THlp.FormatDateTimeWithFirstHour(AValue: TDateTime): String;
begin
  Result := FormatDateTime('YYYY/MM/DD hh:mm:ss', SetDateTimeWithFirstHour(AValue));
end;

class function THlp.FormatDateTimeWithLastHour(AValue: TDateTime): String;
begin
  Result := FormatDateTime('YYYY/MM/DD hh:mm:ss', SetDateTimeWithLastHour(AValue));
end;

class function THlp.Iif(aCondition: Boolean; aResultTrue, aResultFalse: variant): variant;
begin
  if (aCondition) then
    result := aResultTrue
  else
    result := aResultFalse
end;

class function THlp.RemoveAccentedChars(AValue: String): String;
const
  lWithAccentedChars = '·‡‚‰„ÈËÍÎÌÏÓÔÛÚÙˆı˙˘˚¸Á¡¿¬ƒ√…» ÀÕÃŒœ”“‘÷’⁄Ÿ€‹«∫™áîâöÉì';
  lWithoutAccentedChars = 'aaaaaeeeeiiiiooooouuuucAAAAAEEEEIIIIOOOOOUUUUC        ';
var
   x: Integer;
begin;
  for x := 1 to Length(AValue) do
  if Pos(AValue[x],lWithAccentedChars) <> 0 then
    AValue[x] := lWithoutAccentedChars[Pos(AValue[x], lWithAccentedChars)];
  Result := AValue;
end;

class function THlp.SetDateTimeWithFirstHour(AValue: TDateTime): TDateTime;
begin
  Result := RecodeTime(AValue, 0, 0, 0, 0);
end;

class function THlp.SetDateTimeWithLastHour(AValue: TDateTime): TDateTime;
begin
  Result := RecodeTime(AValue, 23, 59, 59, 0);
end;

class function THlp.StrFloat(AValue: String; ADefaultValue: Double): Double;
begin
  // Tratar campo Price
  AValue := StringReplace(AValue, '.', '', [rfReplaceAll]);
  Result := StrToFloatDef(AValue, ADefaultValue);
end;

class function THlp.StrInt(AValue: String; ADefaultValue: Integer): Integer;
begin
  Result := StrToIntDef(AValue, ADefaultValue);
end;



class function THlp.StrZero(Conteudo: String; Tamanho: Integer): String;
begin
  while Length(Conteudo) < Tamanho do
    Insert('0', COnteudo,1);
  Result := Conteudo;
end;

end.
