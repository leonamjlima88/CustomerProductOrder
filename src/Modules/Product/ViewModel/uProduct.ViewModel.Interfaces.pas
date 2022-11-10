unit uProduct.ViewModel.Interfaces;

interface

uses
  uMemTable.Interfaces;

type
  IProductViewModel = interface
    ['{33CB81A7-CF6D-478D-8B2E-19EA0914B3FA}']

    function Product: IMemTable;
    function ProductClear: IProductViewModel;
  end;

implementation

end.
