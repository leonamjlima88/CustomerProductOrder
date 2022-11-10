unit uSalesOrderProduct.SQLBuilder.Interfaces;

interface

uses
  uSalesOrderProduct.Entity.Interfaces,
  uPageFilter,
  uSelectWithFilter;

type
  ISalesOrderProductSQLBuilder = interface
    ['{C30F6C8E-CC09-426D-8191-ECA52FE67B21}']

    // SalesOrderProduct
    function ScriptCreateTable: String;
    function DeleteBySalesOrderId(ASaleOrderId: Int64): String;
    function SelectBySalesOrderId(ASaleOrderId: Int64): String;
    function InsertInto(AEntity: ISalesOrderProductEntity): String;
  end;

implementation

end.
