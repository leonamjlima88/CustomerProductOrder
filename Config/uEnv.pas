unit uEnv;

interface

uses
  SysUtils,
  IniFiles,
  Forms;

type
  TEnv = class(TIniFile)
  private
    procedure SetDatabase(const Value: String);
    procedure SetPassword(const Value: String);
    procedure SetPort(const Value: String);
    procedure SetServer(const Value: String);
    procedure SetUserName(const Value: String);
    procedure SetVendorLib(const Value: String);
    function GetDatabase: String;
    function GetPassword: String;
    function GetPort: String;
    function GetServer: String;
    function GetUserName: String;
    function GetVendorLib: String;
    procedure SetDriver(const Value: String);
    function GetDriver: String;
  public
    property Database: String read GetDatabase write SetDatabase;
    property UserName: String read GetUserName write SetUserName;
    property Password: String read GetPassword write SetPassword;
    property Server: String read GetServer write SetServer;
    property Port: String read GetPort write SetPort;
    property VendorLib: String read GetVendorLib write SetVendorLib;
    property Driver: String read GetDriver write SetDriver;
  end;

var
  ENV: TEnv;

implementation

{ TEnv }

function TEnv.GetDatabase: String;
begin
  Result := ReadString('CONNECTION','DATABASE','');
end;

function TEnv.GetDriver: String;
begin
  Result := ReadString('CONNECTION','DRIVER','');
end;

function TEnv.GetPassword: String;
begin
  Result := ReadString('CONNECTION','PASSWORD','');
end;

function TEnv.GetPort: String;
begin
  Result := ReadString('CONNECTION','PORT','');
end;

function TEnv.GetServer: String;
begin
  Result := ReadString('CONNECTION','SERVER','');
end;

function TEnv.GetUserName: String;
begin
  Result := ReadString('CONNECTION','USERNAME','');
end;

function TEnv.GetVendorLib: String;
begin
  Result := ReadString('CONNECTION','VENDORLIB','');
end;

procedure TEnv.SetDatabase(const Value: String);
begin
  WriteString('CONNECTION','DATABASE',Value);
end;

procedure TEnv.SetDriver(const Value: String);
begin
  WriteString('CONNECTION','DRIVER',Value);
end;

procedure TEnv.SetPassword(const Value: String);
begin
  WriteString('CONNECTION','PASSWORD',Value);
end;

procedure TEnv.SetPort(const Value: String);
begin
  WriteString('CONNECTION','PORT',Value);
end;

procedure TEnv.SetServer(const Value: String);
begin
  WriteString('CONNECTION','SERVER',Value);
end;

procedure TEnv.SetUserName(const Value: String);
begin
  WriteString('CONNECTION','USERNAME',Value);
end;

procedure TEnv.SetVendorLib(const Value: String);
begin
  WriteString('CONNECTION','VENDORLIB',Value);
end;

initialization
  ENV := TEnv.Create(ExtractFilePath(Application.ExeName) + 'env.ini');
finalization
  FreeAndNil(ENV);

end.

