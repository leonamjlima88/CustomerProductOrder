unit uCustomer.Entity;

interface

uses
  uCustomer.Entity.Interfaces;

type
  TCustomerEntity = class(TInterfacedObject, ICustomerEntity)
  private
    Fid: Int64;
    Fname: String;
    Fcity: String;
    Fstate: String;
    Fcreated_at: TDateTime;
    Fupdated_at: TDateTime;
    function Getcity: String;
    function Getcreated_at: TDateTime;
    function Getid: Int64;
    function Getname: String;
    function Getstate: String;
    function Getupdated_at: TDateTime;
    procedure Setcity(const Value: String);
    procedure Setcreated_at(const Value: TDateTime);
    procedure Setid(const Value: Int64);
    procedure Setname(const Value: String);
    procedure Setstate(const Value: String);
    procedure Setupdated_at(const Value: TDateTime);
   public
    constructor Create;
    destructor Destroy; override;

    property id: Int64 read Getid write Setid;
    property name: String read Getname write Setname;
    property city: String read Getcity write Setcity;
    property state: String read Getstate write Setstate;
    property created_at: TDateTime read Getcreated_at write Setcreated_at;
    property updated_at: TDateTime read Getupdated_at write Setupdated_at;
  end;

implementation

{ TCustomerEntity }

constructor TCustomerEntity.Create;
begin
end;

destructor TCustomerEntity.Destroy;
begin
  inherited;
end;

function TCustomerEntity.Getcity: String;
begin
  Result := Fcity;
end;

function TCustomerEntity.Getcreated_at: TDateTime;
begin
  Result := Fcreated_at;
end;

function TCustomerEntity.Getid: Int64;
begin
  Result := Fid;
end;

function TCustomerEntity.Getname: String;
begin
  Result := Fname;
end;

function TCustomerEntity.Getstate: String;
begin
  Result := Fstate;
end;

function TCustomerEntity.Getupdated_at: TDateTime;
begin
  Result := Fupdated_at;
end;

procedure TCustomerEntity.Setcity(const Value: String);
begin
  Fcity := Value;
end;

procedure TCustomerEntity.Setcreated_at(const Value: TDateTime);
begin
  Fcreated_at := Value;
end;

procedure TCustomerEntity.Setid(const Value: Int64);
begin
  Fid := Value;
end;

procedure TCustomerEntity.Setname(const Value: String);
begin
  Fname := Value;
end;

procedure TCustomerEntity.Setstate(const Value: String);
begin
  Fstate := Value;
end;

procedure TCustomerEntity.Setupdated_at(const Value: TDateTime);
begin
  Fupdated_at := Value;
end;

end.
