unit uSalesOrder.SQLBuilder.Interfaces;

interface

uses
  uSalesOrder.Entity.Interfaces,
  uPageFilter,
  uSelectWithFilter,
  uSalesOrderProduct.SQLBuilder.Interfaces;

type
  ISalesOrderSQLBuilder = interface
    ['{4B9C5728-C86F-41B6-9AE7-F4FB82D832CD}']

    // SalesOrder
    function ScriptCreateTable: String;
    function ScriptSeedTable: String;
    function DeleteById(AId: Int64): String;
    function SelectAll: String;
    function SelectById(AId: Int64): String;
    function InsertInto(AEntity: ISalesOrderEntity): String;
    function LastInsertId: String;
    function Update(AEntity: ISalesOrderEntity; AId: Int64): String;
    function SelectAllWithFilter(APageFilter: IPageFilter): TOutPutSelectAllFilter;

    // SalesOrderProduct
    function SalesOrderProduct: ISalesOrderProductSQLBuilder;
  end;

implementation

end.
