unit uProduct.Entity;

interface

uses
  uProduct.Entity.Interfaces;

type
  TProductEntity = class(TInterfacedObject, IProductEntity)
  private
    Fid: Int64;
    Fname: String;
    Fprice: Double;
    Fcreated_at: TDateTime;
    Fupdated_at: TDateTime;
    function Getprice: Double;
    function Getcreated_at: TDateTime;
    function Getid: Int64;
    function Getname: String;
    function Getupdated_at: TDateTime;
    procedure Setprice(const Value: Double);
    procedure Setcreated_at(const Value: TDateTime);
    procedure Setid(const Value: Int64);
    procedure Setname(const Value: String);
    procedure Setupdated_at(const Value: TDateTime);
   public
    constructor Create;
    destructor Destroy; override;

    property id: Int64 read Getid write Setid;
    property name: String read Getname write Setname;
    property price: Double read Getprice write Setprice;
    property created_at: TDateTime read Getcreated_at write Setcreated_at;
    property updated_at: TDateTime read Getupdated_at write Setupdated_at;
  end;

implementation

{ TProductEntity }

constructor TProductEntity.Create;
begin
end;

destructor TProductEntity.Destroy;
begin
  inherited;
end;

function TProductEntity.Getprice: Double;
begin
  Result := Fprice;
end;

function TProductEntity.Getcreated_at: TDateTime;
begin
  Result := Fcreated_at;
end;

function TProductEntity.Getid: Int64;
begin
  Result := Fid;
end;

function TProductEntity.Getname: String;
begin
  Result := Fname;
end;

function TProductEntity.Getupdated_at: TDateTime;
begin
  Result := Fupdated_at;
end;

procedure TProductEntity.Setprice(const Value: Double);
begin
  Fprice := Value;
end;

procedure TProductEntity.Setcreated_at(const Value: TDateTime);
begin
  Fcreated_at := Value;
end;

procedure TProductEntity.Setid(const Value: Int64);
begin
  Fid := Value;
end;

procedure TProductEntity.Setname(const Value: String);
begin
  Fname := Value;
end;

procedure TProductEntity.Setupdated_at(const Value: TDateTime);
begin
  Fupdated_at := Value;
end;

end.
