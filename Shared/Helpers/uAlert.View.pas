unit uAlert.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.Buttons;

type
  TAlertView = class(TForm)
    pnlFundoBorda: TPanel;
    pnl02Conteudo: TPanel;
    memInfo: TMemo;
    pnl01Topo: TPanel;
    Image1: TImage;
    lblTitulo: TLabel;
    btnExportText: TSpeedButton;
    Panel1: TPanel;
    pnl03Botoes: TPanel;
    Panel2: TPanel;
    btnOk: TSpeedButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnExportTextClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function AShowModal(AMessage: String; ATitle: String = ''): Integer;
  end;

var
  AlertView: TAlertView;

implementation

uses
  uHlp,
  Winapi.ShellAPI;

{$R *.dfm}

class function TAlertView.AShowModal(AMessage, ATitle: String): Integer;
Var
  lView: TAlertView;
begin
  lView := TAlertView.Create(nil);
  Try
    if not ATitle.Trim.IsEmpty then lView.lblTitulo.Caption := ATitle;
    lView.memInfo.Lines.Text := AMessage;

    Result := lView.ShowModal;
  Finally
    lView.Hide;
    FreeAndNil(lView);
  End;
end;

procedure TAlertView.btnExportTextClick(Sender: TObject);
Var
  sArquivo: String;
begin
  sArquivo := ExtractFileDir(application.ExeName)+'\alert.txt';
  memInfo.Lines.SaveToFile(sArquivo);
  ShellExecute(0,Nil,PChar(sArquivo),'', Nil, SW_SHOWNORMAL);
end;

procedure TAlertView.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TAlertView.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_Return) and (Shift = [ssShift]) then
    btnOkClick(Sender);
end;

procedure TAlertView.FormShow(Sender: TObject);
begin
  THlp.createTransparentBackground(Self);

  memInfo.Lines.Add('');
  memInfo.Lines.Add('Pressione a tecla [SHIFT] + [ENTER] para fechar a mensagem.');
end;

end.
