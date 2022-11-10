unit uCustomer.SQLBuilder.Interfaces;

interface

uses
  uCustomer.Entity.Interfaces,
  uPageFilter,
  uSelectWithFilter;

type
  ICustomerSQLBuilder = interface
    ['{288C203F-7E86-4DE7-A3E8-3208A54EEEA6}']

    // Customer
    function ScriptCreateTable: String;
    function ScriptSeedTable: String;
    function DeleteById(AId: Int64): String;
    function SelectAll: String;
    function SelectById(AId: Int64): String;
    function InsertInto(AEntity: ICustomerEntity): String;
    function LastInsertId: String;
    function Update(AEntity: ICustomerEntity; AId: Int64): String;
    function SelectAllWithFilter(APageFilter: IPageFilter): TOutPutSelectAllFilter;
  end;

implementation

end.
