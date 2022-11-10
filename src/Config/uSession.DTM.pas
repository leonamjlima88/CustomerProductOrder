unit uSession.DTM;

interface

uses
  System.SysUtils,
  System.Classes,
  uConnection.Types,
  uConnection.Interfaces,
  uHandle.Exception,
  System.ImageList,
  Vcl.ImgList,
  Vcl.Controls;

type
  TSessionDTM = class(TDataModule)
    imgListGrid: TImageList;
    procedure DataModuleCreate(Sender: TObject);
  private
    FConnection: IConnection;
    function TestConnection: Boolean;
  public
    function DefaultConnectionType: TConnectionType;
    function DefaultRepositoryType: TRepositoryType;
    function GetConnection(APoolConn: Boolean = False): IConnection;
  end;

var
  SessionDTM: TSessionDTM;

implementation

uses
  uConnection.Factory,
  Vcl.Dialogs,
  uMigration.Manager;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TSessionDTM.DataModuleCreate(Sender: TObject);
begin
  // Testar Conexão com o BD
  if not Self.TestConnection then
  begin
    System.Halt;
    Exit;
  End;

  // Rodar Migrations
  TMigrationManager.Make(GetConnection).Execute;
end;

function TSessionDTM.DefaultConnectionType: TConnectionType;
begin
  Result := ctFireDAC;
end;

function TSessionDTM.DefaultRepositoryType: TRepositoryType;
begin
  Result := rtSQL;
end;

function TSessionDTM.GetConnection(APoolConn: Boolean): IConnection;
begin
  case APoolConn of
    True:  Result := TConnectionFactory.Make.Connect;
    False: Begin
      if not Assigned(FConnection) then
        FConnection := TConnectionFactory.Make.Connect;

      Result := FConnection;
    end;
  end;
end;

function TSessionDTM.TestConnection: Boolean;
var
  lStrList: TStringList;
begin
  Try
    lStrList := TStringList.Create;
    try
      Self.GetConnection.Connect;
    except on E: Exception do
      Begin
        // Exibir mensagem para o usuário
        lStrList.Add('Oops... Ocorreu um erro!');
        lStrList.Add('A conexão de rede falhou. Verifique as configurações de rede e internet.');
        lStrList.Add(EmptyStr);
        lStrList.Add('Mensagem Técnica: ' + E.Message + ' - ' + E.ClassName);
        lStrList.Add(EmptyStr);
        lStrList.Add('Se não souber como proceder, entre em contato com o administrador do sistema.');

        MessageDlg(lStrList.Text, mtWarning, [mbOK], 0);
        Exit;
      End;
    end;
  Finally
    if Assigned(lStrList) then FreeAndNil(lStrList);
  End;

  Result := True;
end;

end.
