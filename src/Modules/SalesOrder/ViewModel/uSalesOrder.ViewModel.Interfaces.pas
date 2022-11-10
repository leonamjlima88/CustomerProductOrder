unit uSalesOrder.ViewModel.Interfaces;

interface

uses
  uMemTable.Interfaces;

type
  ISalesOrderViewModel = interface
    ['{8A4F91E8-0084-41D9-807F-EA688AF77A89}']

    function SalesOrder: IMemTable;
    function SalesOrderClear: ISalesOrderViewModel;

    function SalesOrderProduct: IMemTable;
    function SalesOrderProductClear: ISalesOrderViewModel;
  end;

implementation

end.
