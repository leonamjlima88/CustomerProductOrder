unit uSalesOrder.Service.Interfaces;

interface

uses
  uSalesOrder.Entity.Interfaces,
  System.Generics.Collections,
  uIndexResult,
  uPageFilter;

type
  ISalesOrderService = interface
    ['{D785E76E-3B92-442D-A836-869387606EE4}']

    function Delete(AId: Int64): Boolean;
    function Index: TList<ISalesOrderEntity>; overload;
    function Index(APageFilter: IPageFilter): IIndexResult; overload;
    function Show(AId: Int64): ISalesOrderEntity;
    function Store(AEntity: ISalesOrderEntity): Int64;
    function Update(AEntity: ISalesOrderEntity; AId: Int64): Boolean;
  end;

implementation

end.
