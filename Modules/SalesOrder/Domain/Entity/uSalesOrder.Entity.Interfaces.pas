unit uSalesOrder.Entity.Interfaces;

interface

uses
  uCustomer.Entity.Interfaces,
  uSalesOrderProduct.Entity.Interfaces,
  System.Generics.Collections;

type
  ISalesOrderEntity = interface
    ['{0A36090D-1AF8-47BA-840D-5BEA2C2246F9}']

    // GETS
    function Getcreated_at: TDateTime;
    function Getid: Int64;
    function Getcustomer_id: Int64;
    function Getupdated_at: TDateTime;

    // SETS
    procedure Setcreated_at(const Value: TDateTime);
    procedure Setid(const Value: Int64);
    procedure Setcustomer_id(const Value: Int64);
    procedure Setupdated_at(const Value: TDateTime);

    // PROPERTIES
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

end.
