unit uCustomer.ViewModel.Interfaces;

interface

uses
  uMemTable.Interfaces;

type
  ICustomerViewModel = interface
    ['{A1DC654E-1658-405E-86B8-EAC0A7CFB98D}']

    function Customer: IMemTable;
    function CustomerClear: ICustomerViewModel;
  end;

implementation

end.
