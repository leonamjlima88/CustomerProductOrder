unit uCustomer.Entity.Interfaces;

interface

type
  ICustomerEntity = interface
    ['{F7823285-6305-455B-873C-8F9DC5EFD6E1}']

    // GETS
    function Getcity: String;
    function Getcreated_at: TDateTime;
    function Getid: Int64;
    function Getname: String;
    function Getstate: String;
    function Getupdated_at: TDateTime;

    // SETS
    procedure Setcity(const Value: String);
    procedure Setcreated_at(const Value: TDateTime);
    procedure Setid(const Value: Int64);
    procedure Setname(const Value: String);
    procedure Setstate(const Value: String);
    procedure Setupdated_at(const Value: TDateTime);

    // PROPERTIES
    property id: Int64 read Getid write Setid;
    property name: String read Getname write Setname;
    property city: String read Getcity write Setcity;
    property state: String read Getstate write Setstate;
    property created_at: TDateTime read Getcreated_at write Setcreated_at;
    property updated_at: TDateTime read Getupdated_at write Setupdated_at;
  end;

implementation

end.
