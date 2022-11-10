unit uPageFilter;

interface

uses
  System.Generics.Collections;

type
  TcondOperator = (
    coEqual, coGreater, coLess, coGreaterOrEqual, coLessOrEqual, coDifferent,
    coLikeInitial, coLikeFinal, coLikeAnywhere, coLikeEqual
  );
  TFilterWhere = class;

  IPageFilter = interface
    ['{A224A36B-FEEC-4665-9BEF-C05A57267751}']

    function CurrentPage: integer; overload;
    function CurrentPage(AValue: integer): IPageFilter overload;

    function LimitPerPage: integer; overload;
    function LimitPerPage(AValue: integer): IPageFilter overload;

    function Columns: string; overload;
    function Columns(AValue: string): IPageFilter overload;

    function OrderBy: string; overload;
    function OrderBy(AValue: string): IPageFilter; overload;

    function Where: TObjectList<TFilterWhere>;
    function AddWhere(AValue: TFilterWhere): IPageFilter; overload;
    function AddWhere(AFieldName: String; ACondOperator: TcondOperator; AFieldValue: String; AIfDiffEmpty: Boolean = false): IPageFilter; overload;

    function OrWhere: TObjectList<TFilterWhere>;
    function AddOrWhere(AValue: TFilterWhere): IPageFilter; overload;
    function AddOrWhere(AFieldName: String; ACondOperator: TcondOperator; AFieldValue: String; AIfDiffEmpty: Boolean = false): IPageFilter; overload;

    function ClearConditions: IPageFilter;
  end;

  TFilterWhere = class
  private
    FCondOperator: TCondOperator;
    FFieldName: string;
    FFieldValue: string;
    FIfDiffEmpty: Boolean;
  public
    class function Make: TFilterWhere;

    function FieldName: string; overload;
    function FieldName(AValue: string): TFilterWhere; overload;

    function CondOperator: TCondOperator; overload;
    function CondOperator(AValue: TCondOperator): TFilterWhere; overload;

    function FieldValue: string; overload;
    function FieldValue(AValue: string): TFilterWhere; overload;

    function IfDiffEmpty: boolean; overload;
    function IfDiffEmpty(Avalue: boolean): TFilterWhere; overload;
  end;

  TPageFilter = class(TInterfacedObject, IPageFilter)
  private
    FCurrentPage: integer;
    FLimitPerPage: integer;
    FColumns: string;
    FOrderBy: string;
    FWhere: TObjectList<TFilterWhere>;
    FOrWhere: TObjectList<TFilterWhere>;
  public
    constructor Create;
    destructor Destroy; override;
    class function Make: IPageFilter;

    function CurrentPage: integer; overload;
    function CurrentPage(AValue: integer): IPageFilter overload;

    function LimitPerPage: integer; overload;
    function LimitPerPage(AValue: integer): IPageFilter overload;

    function Columns: string; overload;
    function Columns(AValue: string): IPageFilter overload;

    function OrderBy: string; overload;
    function OrderBy(AValue: string): IPageFilter; overload;

    function Where: TObjectList<TFilterWhere>;
    function AddWhere(AValue: TFilterWhere): IPageFilter; overload;
    function AddWhere(AFieldName: String; ACondOperator: TcondOperator; AFieldValue: String; AIfDiffEmpty: Boolean = false): IPageFilter; overload;

    function OrWhere: TObjectList<TFilterWhere>;
    function AddOrWhere(AValue: TFilterWhere): IPageFilter; overload;
    function AddOrWhere(AFieldName: String; ACondOperator: TcondOperator; AFieldValue: String; AIfDiffEmpty: Boolean = false): IPageFilter; overload;

    function ClearConditions: IPageFilter;
  end;

implementation

uses
  uHlp;

{ TPageFilter }

function TPageFilter.Columns: string;
begin
  Result := FColumns;
end;

function TPageFilter.AddOrWhere(AValue: TFilterWhere): IPageFilter;
begin
  Result := Self;
  FOrWhere.Add(Avalue);
end;

function TPageFilter.AddWhere(AValue: TFilterWhere): IPageFilter;
begin
  Result := self;
  FWhere.Add(Avalue);
end;

function TPageFilter.AddOrWhere(AFieldName: String; ACondOperator: TcondOperator; AFieldValue: String; AIfDiffEmpty: Boolean): IPageFilter;
begin
  Result := Self;
  AddOrWhere(
    TFilterWhere.Make
      .fieldName(AFieldName)
      .condOperator(ACondOperator)
      .FieldValue(AFieldValue)
      .IfDiffEmpty(AIfDiffEmpty)
  );
end;

function TPageFilter.AddWhere(AFieldName: String; ACondOperator: TcondOperator; AFieldValue: String; AIfDiffEmpty: Boolean): IPageFilter;
begin
  Result := Self;
  AddWhere(
    TFilterWhere.Make
      .fieldName(AFieldName)
      .condOperator(ACondOperator)
      .FieldValue(AFieldValue)
      .IfDiffEmpty(AIfDiffEmpty)
  );
end;

function TPageFilter.ClearConditions: IPageFilter;
begin
  Result := self;
  FWhere.Clear;
  FOrWhere.Clear;
end;

function TPageFilter.Columns(AValue: string): IPageFilter;
begin
  Result := Self;
  FColumns := AValue;
end;

constructor TPageFilter.Create;
begin
  FWhere   := TObjectList<TFilterWhere>.Create;
  FOrWhere := TObjectList<TFilterWhere>.Create;

  // Valor Default
  FCurrentPage  := 1;
  FLimitPerPage := 50;
end;

function TPageFilter.CurrentPage: integer;
begin
  Result := FCurrentPage;
end;

function TPageFilter.CurrentPage(AValue: integer): IPageFilter;
begin
  Result := Self;
  FCurrentPage := AValue;
end;

destructor TPageFilter.Destroy;
begin
  FWhere.Free;
  FOrWhere.Free;

  inherited;
end;

function TPageFilter.LimitPerPage(AValue: integer): IPageFilter;
begin
  Result := Self;
  FLimitPerPage := AValue;
end;

class function TPageFilter.Make: IPageFilter;
begin
  Result := Self.Create;
end;

function TPageFilter.OrderBy(AValue: string): IPageFilter;
begin
  Result := Self;
  FOrderBy := AValue;
end;

function TPageFilter.OrWhere: TObjectList<TFilterWhere>;
begin
  Result := FOrWhere;
end;

function TPageFilter.Where: TObjectList<TFilterWhere>;
begin
  Result := FWhere;
end;

function TPageFilter.OrderBy: string;
begin
  Result := FOrderBy;
end;

function TPageFilter.LimitPerPage: integer;
begin
  Result := FLimitPerPage;
end;

{ TFilterWhere }

function TFilterWhere.CondOperator: TCondOperator;
begin
  Result := FCondOperator;
end;

function TFilterWhere.CondOperator(AValue: TCondOperator): TFilterWhere;
begin
  Result := self;
  FCondOperator := Avalue;
end;

function TFilterWhere.FieldName(AValue: string): TFilterWhere;
begin
  Result := self;
  FFieldName := Avalue;
end;

function TFilterWhere.FieldName: string;
begin
  Result := FFieldName;
end;

function TFilterWhere.FieldValue(AValue: string): TFilterWhere;
begin
  Result := self;
  FFieldValue := THlp.RemoveAccentedChars(AValue);

  // Evitar erro com data e hora
  if (FFieldValue = '12/30/1899') or (FFieldValue = '  :  :  ') then
    FFieldValue := '';
end;

function TFilterWhere.IfDiffEmpty(Avalue: boolean): TFilterWhere;
begin
  Result := Self;
  FIfDiffEmpty := Avalue;
end;

function TFilterWhere.IfDiffEmpty: boolean;
begin
  Result := FIfDiffEmpty;
end;

function TFilterWhere.FieldValue: string;
begin
  Result := FFieldValue;
end;

class function TFilterWhere.Make: TFilterWhere;
begin
  Result := Self.Create;
end;

end.
