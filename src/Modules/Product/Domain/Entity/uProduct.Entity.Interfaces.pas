unit uProduct.Entity.Interfaces;

interface

type
  IProductEntity = interface
    ['{5FF7B753-63BD-4C11-BDA1-E26DB35FA3BD}']

    // GETS
    function Getprice: Double;
    function Getcreated_at: TDateTime;
    function Getid: Int64;
    function Getname: String;
    function Getupdated_at: TDateTime;

    // SETS
    procedure Setprice(const Value: Double);
    procedure Setcreated_at(const Value: TDateTime);
    procedure Setid(const Value: Int64);
    procedure Setname(const Value: String);
    procedure Setupdated_at(const Value: TDateTime);

    // PROPERTIES
    property id: Int64 read Getid write Setid;
    property name: String read Getname write Setname;
    property price: Double read Getprice write Setprice;
    property created_at: TDateTime read Getcreated_at write Setcreated_at;
    property updated_at: TDateTime read Getupdated_at write Setupdated_at;
  end;

implementation

end.
