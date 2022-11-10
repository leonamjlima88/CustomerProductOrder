unit uMemTable.Interfaces;

interface

uses
  Data.DB;

type
  IMemTable = interface
    ['{A33A8267-08DE-482A-B9B4-984E3F6A81A4}']

    function FromDataSet(ADataSet: TDataSet): IMemTable;
    function DataSet: TDataSet;
    function FieldDefs: TFieldDefs;
    function CreateDataSet: IMemTable;
    function Active: Boolean; overload;
    function Active(AValue: Boolean): IMemTable; overload;
  end;


implementation

end.
