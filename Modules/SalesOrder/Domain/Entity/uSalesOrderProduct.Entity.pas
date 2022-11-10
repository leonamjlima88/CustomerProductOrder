unit uSalesOrderProduct.Entity;

interface

uses
  uSalesOrderProduct.Entity.Interfaces,
  uProduct.Entity.Interfaces;

type
  TSalesOrderProductEntity = class(TInterfacedObject, ISalesOrderProductEntity)
  private
    Fid: Int64;
    Fsales_order_id: Int64;
    Fproduct_id: Int64;
    Fquantity: Double;
    Funit_price: Double;

    // OneToOne
    Fproduct: IProductEntity;

    function Getid: Int64;
    function Getproduct_id: Int64;
    function Getquantity: Double;
    function Getsales_order_id: Int64;
    function Getunit_price: Double;
    procedure Setid(const Value: Int64);
    procedure Setproduct_id(const Value: Int64);
    procedure Setquantity(const Value: Double);
    procedure Setsales_order_id(const Value: Int64);
    procedure Setunit_price(const Value: Double);
  public
    constructor Create;
    destructor Destroy; override;

    property id: Int64 read Getid write Setid;
    property sales_order_id: Int64 read Getsales_order_id write Setsales_order_id;
    property product_id: Int64 read Getproduct_id write Setproduct_id;
    property quantity: Double read Getquantity write Setquantity;
    property unit_price: Double read Getunit_price write Setunit_price;

    function amount: Double;

    // OneToOne
    function product: IProductEntity; overload;
    function product(AValue: IProductEntity; AUpdateValues: Boolean = False): ISalesOrderProductEntity; overload;
  end;

implementation

uses
  System.SysUtils,
  uProduct.Entity;

{ TSalesOrderProductEntity }

function TSalesOrderProductEntity.amount: Double;
begin
  Result := FQuantity * Funit_price;
end;

constructor TSalesOrderProductEntity.Create;
begin
  Fproduct := TProductEntity.Create;
end;

destructor TSalesOrderProductEntity.Destroy;
begin
  inherited;
end;

function TSalesOrderProductEntity.Getid: Int64;
begin
  Result := Fid;
end;

function TSalesOrderProductEntity.Getproduct_id: Int64;
begin
  Result := Fproduct_id;
end;

function TSalesOrderProductEntity.Getquantity: Double;
begin
  Result := Fquantity;
end;

function TSalesOrderProductEntity.Getsales_order_id: Int64;
begin
  Result := Fsales_order_id;
end;

function TSalesOrderProductEntity.Getunit_price: Double;
begin
  Result := Funit_price;
end;

function TSalesOrderProductEntity.product(AValue: IProductEntity; AUpdateValues: Boolean): ISalesOrderProductEntity;
begin
  Result := Self;
  Fproduct := AValue;
  if AUpdateValues then
  begin
    Fproduct_id := AValue.id;
    Funit_price := AValue.price;
    Fquantity   := 1;
  end;
end;

function TSalesOrderProductEntity.product: IProductEntity;
begin
  Result := Fproduct;
end;

procedure TSalesOrderProductEntity.Setid(const Value: Int64);
begin
  Fid := Value;
end;

procedure TSalesOrderProductEntity.Setproduct_id(const Value: Int64);
begin
  Fproduct_id := Value;
end;

procedure TSalesOrderProductEntity.Setquantity(const Value: Double);
begin
  Fquantity := Value;
end;

procedure TSalesOrderProductEntity.Setsales_order_id(const Value: Int64);
begin
  Fsales_order_id := Value;
end;

procedure TSalesOrderProductEntity.Setunit_price(const Value: Double);
begin
  Funit_price := Value;
end;

end.
