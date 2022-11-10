unit uSalesOrderProduct.Entity.Interfaces;

interface

uses
  uProduct.Entity.Interfaces;

type
  ISalesOrderProductEntity = interface
    ['{2DD9D674-038B-4FA6-B7FD-0BE2D7CD3A6F}']

    // GETS
    function Getid: Int64;
    function Getproduct_id: Int64;
    function Getquantity: Double;
    function Getsales_order_id: Int64;
    function Getunit_price: Double;

    // SETS
    procedure Setid(const Value: Int64);
    procedure Setproduct_id(const Value: Int64);
    procedure Setquantity(const Value: Double);
    procedure Setsales_order_id(const Value: Int64);
    procedure Setunit_price(const Value: Double);

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

end.
