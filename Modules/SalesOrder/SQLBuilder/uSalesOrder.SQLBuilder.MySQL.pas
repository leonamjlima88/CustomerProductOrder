unit uSalesOrder.SQLBuilder.MySQL;

interface

uses
  uSalesOrder.SQLBuilder.Interfaces,
  uSalesOrder.Entity.Interfaces,
  uPageFilter,
  uSelectWithFilter,
  uSalesOrderProduct.SQLBuilder.Interfaces;

type
  TSalesOrderSQLBuilderMySQL = class(TInterfacedObject, ISalesOrderSQLBuilder)
  private
    FSalesOrderProduct: ISalesOrderProductSQLBuilder;
    constructor Create;
  public
    class function Make: ISalesOrderSQLBuilder;
    destructor Destroy; override;

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

uses
  System.Classes,
  System.SysUtils,
  uConnection.Types,
  uSalesOrderProduct.SQLBuilder.MySQL;

{ TSalesOrderSQLBuilder }

function TSalesOrderSQLBuilderMySQL.SalesOrderProduct: ISalesOrderProductSQLBuilder;
begin
  Result := FSalesOrderProduct;
end;

function TSalesOrderSQLBuilderMySQL.ScriptCreateTable: String;
begin
  Result :=
    ' CREATE TABLE `sales_order` (                                                                       '+
    '   `id` bigint(20) NOT NULL AUTO_INCREMENT,                                                         '+
    '   `customer_id` bigint(20) NOT NULL,                                                               '+
    '   `sum_sales_order_product_amount` decimal(18,4),                                                  '+
    '   `created_at` datetime NOT NULL,                                                                  '+
    '   `updated_at` datetime,                                                                           '+
    '   PRIMARY KEY (`id`),                                                                              '+
    '   KEY `sales_order_idx_created_at` (`created_at`),                                                 '+
    '   KEY `sales_order_fk_customer_id` (`customer_id`),                                                '+
    '   CONSTRAINT `sales_order_fk_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) '+
    ' )                                                                                                   ';
end;

function TSalesOrderSQLBuilderMySQL.ScriptSeedTable: String;
begin
  Result := '';
end;

constructor TSalesOrderSQLBuilderMySQL.Create;
begin
  FSalesOrderProduct := TSalesOrderProductSQLBuilderMySQL.Make;
end;

function TSalesOrderSQLBuilderMySQL.DeleteById(AId: Int64): String;
const
  LSQL = 'DELETE FROM sales_order WHERE sales_order.id = %s';
begin
  Result := Format(LSQL, [QuotedStr(AId.ToString)]);
end;

destructor TSalesOrderSQLBuilderMySQL.Destroy;
begin
  inherited;
end;

function TSalesOrderSQLBuilderMySQL.InsertInto(AEntity: ISalesOrderEntity): String;
const
  LSQL = ' INSERT INTO sales_order                                     '+
         '   (customer_id, sum_sales_order_product_amount, created_at) '+
         ' VALUES                                                      '+
         '   ( %s, %s, %s)                                             ';
begin
  Result := Format(LSQL, [
    QuotedStr(AEntity.customer_id.ToString),
    QuotedStr(StringReplace(FormatFloat('0.0000', AEntity.sum_sales_order_product_amount), FormatSettings.DecimalSeparator, '.', [rfReplaceAll,rfIgnoreCase])),
    QuotedStr(FormatDateTime('YYYY-MM-DD HH:MM:SS', AEntity.created_at))
  ]);
end;

function TSalesOrderSQLBuilderMySQL.LastInsertId: String;
begin
  Result := 'SELECT last_insert_id()';
end;

class function TSalesOrderSQLBuilderMySQL.Make: ISalesOrderSQLBuilder;
begin
  Result := Self.Create;
end;

function TSalesOrderSQLBuilderMySQL.SelectAll: String;
begin
  Result :=
    ' SELECT                                           '+
    '   sales_order.*,                                 '+
    '   customer.name  as customer_name,               '+
    '   customer.city  as customer_city,               '+
    '   customer.state as customer_state               '+
    ' FROM                                             '+
    '   sales_order                                    '+
    ' INNER JOIN customer                              '+
    '         ON customer.id = sales_order.customer_id '+
    ' WHERE                                            '+
    '   sales_order.id is not null                     ';
end;

function TSalesOrderSQLBuilderMySQL.SelectAllWithFilter(APageFilter: IPageFilter): TOutPutSelectAllFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(APageFilter, SelectAll, 'sales_order.id', ddMySql);
end;

function TSalesOrderSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' AND sales_order.id = ' + QuotedStr(AId.ToString);
end;

function TSalesOrderSQLBuilderMySQL.Update(AEntity: ISalesOrderEntity; AId: Int64): String;
const
  LSQL = ' UPDATE sales_order                       '+
         '   SET                                    '+
         '     customer_id = %s,                    '+
         '     sum_sales_order_product_amount = %s, '+
         '     updated_at = %s                      '+
         '   WHERE                                  '+
         '     (id = %s)                            ';
begin
  Result := Format(LSQL, [
    QuotedStr(AEntity.customer_id.ToString),
    QuotedStr(StringReplace(FormatFloat('0.0000', AEntity.sum_sales_order_product_amount), FormatSettings.DecimalSeparator, '.', [rfReplaceAll,rfIgnoreCase])),
    QuotedStr(FormatDateTime('YYYY-MM-DD HH:MM:SS', AEntity.updated_at)),
    QuotedStr(AId.ToString)
  ]);
end;

end.

