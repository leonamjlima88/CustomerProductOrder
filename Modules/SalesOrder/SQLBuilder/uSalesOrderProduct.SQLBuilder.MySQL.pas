unit uSalesOrderProduct.SQLBuilder.MySQL;

interface

uses
  uSalesOrderProduct.SQLBuilder.Interfaces,
  uSalesOrderProduct.Entity.Interfaces;

type
  TSalesOrderProductSQLBuilderMySQL = class(TInterfacedObject, ISalesOrderProductSQLBuilder)
  public
    class function Make: ISalesOrderProductSQLBuilder;

    // SalesOrderProduct
    function ScriptCreateTable: String;
    function DeleteBySalesOrderId(ASalesOrderId: Int64): String;
    function SelectBySalesOrderId(ASalesOrderId: Int64): String;
    function InsertInto(AEntity: ISalesOrderProductEntity): String;
  end;

implementation

uses
  System.SysUtils;

{ TSalesOrderProductSQLBuilder }

function TSalesOrderProductSQLBuilderMySQL.ScriptCreateTable: String;
begin
  Result :=
    ' CREATE TABLE `sales_order_product` ( '+
    '   `id` bigint(20) NOT NULL AUTO_INCREMENT, '+
    '   `sales_order_id` bigint(20) NOT NULL, '+
    '   `product_id` bigint(20) NOT NULL, '+
    '   `quantity` decimal(18,4) NOT NULL, '+
    '   `unit_price` decimal(18,4) NOT NULL, '+
    '   `amount` decimal(18,4) NOT NULL, '+
    '   PRIMARY KEY (`id`), '+
    '   KEY `sales_order_product_fk_sales_order_id` (`sales_order_id`), '+
    '   KEY `sales_order_product_fk_product_id` (`product_id`), '+
    '   CONSTRAINT `sales_order_product_fk_product_id` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION, '+
    '   CONSTRAINT `sales_order_product_fk_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `sales_order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE '+
    ' ) ';
end;

function TSalesOrderProductSQLBuilderMySQL.DeleteBySalesOrderId(ASalesOrderId: Int64): String;
begin
  Result := 'delete from sales_order_product where sales_order_product.sales_order_id = ' + QuotedStr(ASalesOrderId.ToString);
end;

function TSalesOrderProductSQLBuilderMySQL.InsertInto(AEntity: ISalesOrderProductEntity): String;
const
  LSQL = ' INSERT INTO sales_order_product                              '+
         '   (sales_order_id, product_id, quantity, unit_price, amount) '+
         ' VALUES                                                       '+
         '   ( %s, %s, %s, %s, %s)                                      ';
begin
  Result := Format(LSQL, [
    QuotedStr(AEntity.sales_order_id.ToString),
    QuotedStr(AEntity.product_id.ToString),
    QuotedStr(StringReplace(FormatFloat('0.0000', AEntity.quantity),   FormatSettings.DecimalSeparator, '.', [rfReplaceAll,rfIgnoreCase])),
    QuotedStr(StringReplace(FormatFloat('0.0000', AEntity.unit_price), FormatSettings.DecimalSeparator, '.', [rfReplaceAll,rfIgnoreCase])),
    QuotedStr(StringReplace(FormatFloat('0.0000', AEntity.amount),     FormatSettings.DecimalSeparator, '.', [rfReplaceAll,rfIgnoreCase]))
  ]);
end;

class function TSalesOrderProductSQLBuilderMySQL.Make: ISalesOrderProductSQLBuilder;
begin
  Result := Self.Create;
end;

function TSalesOrderProductSQLBuilderMySQL.SelectBySalesOrderId(ASalesOrderId: Int64): String;
begin
  Result :=
    ' SELECT                                                                       '+
    '   sales_order_product.*,                                                     '+
    '   product.name as product_name,                                              '+
    '   product.price as product_price                                             '+
    ' FROM                                                                         '+
    '   sales_order_product                                                        '+
    ' INNER JOIN product                                                           '+
    '         ON product.id = sales_order_product.product_id                       '+
    ' WHERE                                                                        '+
    '   sales_order_product.sales_order_id = ' + QuotedStr(ASalesOrderId.ToString)  +
    ' ORDER BY                                                                     '+
    '   sales_order_product.id                                                     ';
end;

end.

