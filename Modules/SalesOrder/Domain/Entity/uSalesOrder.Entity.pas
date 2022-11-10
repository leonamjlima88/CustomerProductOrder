unit uSalesOrder.Entity;

interface

uses
  uSalesOrder.Entity.Interfaces,
  uCustomer.Entity.Interfaces,
  System.Generics.Collections,
  uSalesOrderProduct.Entity.Interfaces;

type
  TSalesOrderEntity = class(TInterfacedObject, ISalesOrderEntity)
  private
    Fid: Int64;
    Fcustomer_id: Int64;
    Fcreated_at: TDateTime;
    Fupdated_at: TDateTime;

    // OneToOne
    Fcustomer: ICustomerEntity;

    // OneToMany
    Fsales_order_product_list: TList<ISalesOrderProductEntity>;

    function Getcreated_at: TDateTime;
    function Getid: Int64;
    function Getcustomer_id: Int64;
    function Getupdated_at: TDateTime;
    procedure Setcreated_at(const Value: TDateTime);
    procedure Setid(const Value: Int64);
    procedure Setcustomer_id(const Value: Int64);
    procedure Setupdated_at(const Value: TDateTime);
   public
    constructor Create;
    destructor Destroy; override;

    property id: Int64 read Getid write Setid;
    property customer_id: Int64 read Getcustomer_id write Setcustomer_id;
    property created_at: TDateTime read Getcreated_at write Setcreated_at;
    property updated_at: TDateTime read Getupdated_at write Setupdated_at;

    function sum_sales_order_product_amount: Double;

    // OneToOne
    function customer: ICustomerEntity; overload;
    function customer(AValue: ICustomerEntity; AUpdateId: Boolean = False): ISalesOrderEntity; overload;

    // OneToMany
    function sales_order_product_list: TList<ISalesOrderProductEntity>;
  end;

implementation

uses
  uCustomer.Entity,
  System.SysUtils;

{ TSalesOrderEntity }

constructor TSalesOrderEntity.Create;
begin
  Fcustomer := TCustomerEntity.Create;
  Fsales_order_product_list := TList<ISalesOrderProductEntity>.Create;
end;

function TSalesOrderEntity.customer(AValue: ICustomerEntity; AUpdateId: Boolean): ISalesOrderEntity;
begin
  Result := Self;
  Fcustomer := AValue;
  if AUpdateId then
    Fcustomer_id := AValue.id;
end;

function TSalesOrderEntity.customer: ICustomerEntity;
begin
  Result := Fcustomer;
end;

destructor TSalesOrderEntity.Destroy;
begin
  if Assigned(Fsales_order_product_list) then FreeAndNil(Fsales_order_product_list);
  inherited;
end;

function TSalesOrderEntity.Getcreated_at: TDateTime;
begin
  Result := Fcreated_at;
end;

function TSalesOrderEntity.Getid: Int64;
begin
  Result := Fid;
end;

function TSalesOrderEntity.Getcustomer_id: Int64;
begin
  Result := Fcustomer_id;
end;

function TSalesOrderEntity.Getupdated_at: TDateTime;
begin
  Result := Fupdated_at;
end;

function TSalesOrderEntity.sales_order_product_list: TList<ISalesOrderProductEntity>;
begin
  Result := Fsales_order_product_list;
end;

procedure TSalesOrderEntity.Setcreated_at(const Value: TDateTime);
begin
  Fcreated_at := Value;
end;

procedure TSalesOrderEntity.Setid(const Value: Int64);
begin
  Fid := Value;
end;

procedure TSalesOrderEntity.Setcustomer_id(const Value: Int64);
begin
  Fcustomer_id := Value;
end;

procedure TSalesOrderEntity.Setupdated_at(const Value: TDateTime);
begin
  Fupdated_at := Value;
end;

function TSalesOrderEntity.sum_sales_order_product_amount: Double;
var
  lItem: ISalesOrderProductEntity;
begin
  Result := 0;
  for lItem in sales_order_product_list do
    Result := Result + lItem.amount;
end;

end.
