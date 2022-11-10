unit uMainView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Forms, System.Actions, Vcl.ActnList, Vcl.StdCtrls, Vcl.Imaging.jpeg,
  Vcl.ComCtrls, Vcl.Buttons, Vcl.WinXCtrls, Vcl.Imaging.pngimage, Vcl.Controls,
  Vcl.ExtCtrls, Vcl.Menus;

type
  TMainView = class(TForm)
    pnlBackground: TPanel;
    pnlTopBar: TPanel;
    imgShowOrHideSideBar: TImage;
    Image1: TImage;
    Image4: TImage;
    lblDate: TLabel;
    lblNameOfTheWeek: TLabel;
    lblCompanyAliasName: TLabel;
    imgDadosEmpLogo: TImage;
    lblCompanyEin: TLabel;
    SplitView1: TSplitView;
    Panel7: TPanel;
    Image8: TImage;
    lblUserLoggedLogin: TLabel;
    Image9: TImage;
    lblStationNumber: TLabel;
    Image10: TImage;
    lblPcName: TLabel;
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    btnFocus: TButton;
    pnlBody: TPanel;
    Panel5: TPanel;
    Image2: TImage;
    btnCustomer: TSpeedButton;
    Panel6: TPanel;
    Image3: TImage;
    btnProduct: TSpeedButton;
    Panel8: TPanel;
    Image5: TImage;
    btnOrder: TSpeedButton;
    Panel9: TPanel;
    Image6: TImage;
    btnLogoff: TSpeedButton;
    Panel10: TPanel;
    Image7: TImage;
    btnLogin: TSpeedButton;
    Panel11: TPanel;
    Image11: TImage;
    btnProfileView: TSpeedButton;
    Panel2: TPanel;
    Image12: TImage;
    btnClose: TSpeedButton;
    ActionList1: TActionList;
    actCustomer: TAction;
    PopupMenu1: TPopupMenu;
    Abas1: TMenuItem;
    mniCloseCurrentTab: TMenuItem;
    mniCloseOthersTab: TMenuItem;
    mniCloseAllTabs: TMenuItem;
    pgcActiveForms: TPageControl;
    TabSheet1: TTabSheet;
    pnlDashboard: TPanel;
    imgPrincAlbsys: TImage;
    actProduct: TAction;
    actSalesOrder: TAction;
    actClose: TAction;
    btnCloseTabSheet: TButton;
    Panel3: TPanel;
    SpeedButton1: TSpeedButton;
    Image13: TImage;
    Panel4: TPanel;
    Image14: TImage;
    Panel12: TPanel;
    procedure imgShowOrHideSideBarClick(Sender: TObject);
    procedure actCustomerExecute(Sender: TObject);
    procedure imgCloseTabSheetClick(Sender: TObject);
    procedure pgcActiveFormsMouseEnter(Sender: TObject);
    procedure pgcActiveFormsMouseLeave(Sender: TObject);
    procedure pgcActiveFormsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure mniCloseCurrentTabClick(Sender: TObject);
    procedure mniCloseOthersTabClick(Sender: TObject);
    procedure mniCloseAllTabsClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actProductExecute(Sender: TObject);
    procedure actSalesOrderExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    FTabSheetTag: Integer;
    function  LoadAndShowForm(const AFrmClass: TComponentClass; ACaption: String): TForm;
    procedure ShowTabCloseButtonOnHotTab;
  public
  end;

var
  MainView: TMainView;

implementation

uses
  uCustomer.Index.View,
  Vcl.Dialogs,
  uNotificationView,
  uProduct.Index.View,
  uSalesOrder.Index.View,
  uWithoutViewModel.View;

{$R *.dfm}

procedure TMainView.actCloseExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainView.actCustomerExecute(Sender: TObject);
var
  lForm: TCustomerIndexView;
begin
  // Abrir Formulário
  lForm := TCustomerIndexView(LoadAndShowForm(
      TCustomerIndexView,
      'Clientes'
  ));
  if Assigned(lForm) then
  begin
    lForm.BringToFront;
    if lForm.edtSearchValue.CanFocus then
      lForm.edtSearchValue.SetFocus;
  end;
end;

procedure TMainView.actSalesOrderExecute(Sender: TObject);
var
  lForm: TSalesOrderIndexView;
begin
  // Abrir Formulário
  lForm := TSalesOrderIndexView(LoadAndShowForm(
      TSalesOrderIndexView,
      'Pedidos de Venda'
  ));
  if Assigned(lForm) then
  begin
    lForm.BringToFront;
    if lForm.edtSearchValue.CanFocus then
      lForm.edtSearchValue.SetFocus;
  end;
end;

procedure TMainView.actProductExecute(Sender: TObject);
var
  lForm: TProductIndexView;
begin
  // Abrir Formulário
  lForm := TProductIndexView(LoadAndShowForm(
      TProductIndexView,
      'Produtos'
  ));
  if Assigned(lForm) then
  begin
    lForm.BringToFront;
    if lForm.edtSearchValue.CanFocus then
      lForm.edtSearchValue.SetFocus;
  end;
end;

procedure TMainView.FormCreate(Sender: TObject);
begin
  pgcActiveForms.Align := alClient;
end;

procedure TMainView.FormShow(Sender: TObject);
begin
  btnFocus.SetFocus;
end;

procedure TMainView.imgCloseTabSheetClick(Sender: TObject);
begin
  // Não permitir operação com Home
  if String(pgcActiveForms.Pages[btnCloseTabSheet.Tag].Caption).Trim.ToLower = 'home' then Exit;

  pgcActiveForms.Pages[btnCloseTabSheet.Tag].Free;
  pgcActiveForms.ActivePageIndex := Pred(btnCloseTabSheet.Tag);
  ShowTabCloseButtonOnHotTab;
end;

procedure TMainView.imgShowOrHideSideBarClick(Sender: TObject);
begin
  SplitView1.Opened := not SplitView1.Opened;
end;

function TMainView.LoadAndShowForm(const AFrmClass: TComponentClass; ACaption: String): TForm;
var
  lTabSheetShow: TTabSheet;
  lFormShow: TComponent;
  lI: Integer;
  lSourceStr, lTargetStr: String;
  lWindowWidth, lWindowHeight: Integer;
  lCloseMenu: Boolean;
  lJ: Integer;
begin
  Result := nil;

  lWindowWidth  := GetSystemMetrics(SM_CXSCREEN) - (GetSystemMetrics(SM_CXSCREEN) - GetSystemMetrics(SM_CXFULLSCREEN));
  lWindowHeight := GetSystemMetrics(SM_CYSCREEN) - (GetSystemMetrics(SM_CYSCREEN) - GetSystemMetrics(SM_CYFULLSCREEN)) + GetSystemMetrics(SM_CYCAPTION);
  lCloseMenu    := (lWindowWidth <= 1200) or (lWindowHeight <= 750);
  if lCloseMenu then
    SplitView1.Opened := False;

  // Se formulário já existir, apenas abre
  for lI := 0 to Pred(pgcActiveForms.PageCount) do
  Begin
    lSourceStr := String(pgcActiveForms.Pages[lI].Caption).Trim.ToLower;
    lTargetStr := ACaption.Trim.ToLower;

    if (lSourceStr = lTargetStr) then
    begin
      for lJ := 0 to Pred(pgcActiveForms.Pages[lI].ControlCount) do
      begin
        if (pgcActiveForms.Pages[lI].Controls[lJ] is TForm) then
        begin
          Result := TForm(pgcActiveForms.Pages[lI].Controls[lJ]);
          Break;
        end;
      end;
      pgcActiveForms.ActivePageIndex := lI;
      Exit;
    end;
  End;

  // Limite de abas abertas (10)
  if (pgcActiveForms.PageCount > 10) then
  begin
    NotificationView.Execute('Limite(10) de páginas foi atingido. Encerre alguma página e tente novamente.', tneError);
    Abort;
  end;

  // Se formulário não existir, cria aba para abrir
  lTabSheetShow             := TTabSheet.Create(pgcActiveForms);
  lTabSheetShow.Parent      := pgcActiveForms;
  lTabSheetShow.PageControl := pgcActiveForms;
  lTabSheetShow.Caption     := '     ' + ACaption + '     ';

  // Se formulário não existir, cria formulário e coloca na aba criada
  lFormShow := AFrmClass.Create(lTabSheetShow);
  TForm(lFormShow).Parent      := lTabSheetShow;
  TForm(lFormShow).Align       := alClient;
  TForm(lFormShow).BorderStyle := bsNone;
  TForm(lFormShow).Show;
  Result := TForm(lFormShow);
  pgcActiveForms.ActivePageIndex := Pred(pgcActiveForms.PageCount);
end;

procedure TMainView.mniCloseAllTabsClick(Sender: TObject);
var
  lI: Integer;
begin
  Try
    // Evita bug de layoyt
    pgcActiveForms.Align  := alNone;
    pgcActiveForms.Height := 0;

    pgcActiveForms.Align  := alNone;
    for lI := Pred(pgcActiveForms.PageCount) downto 0 do
    begin
      // Não permitir operação com Home
      if String(pgcActiveForms.Pages[lI].Caption).Trim.ToLower <> 'home' then
        pgcActiveForms.Pages[lI].Free;
    end;
  Finally
    pgcActiveForms.Align  := alClient;
  End;
end;

procedure TMainView.mniCloseCurrentTabClick(Sender: TObject);
begin
  Try
    // Evita bug de layoyt
    pgcActiveForms.Align  := alNone;
    pgcActiveForms.Height := 0;

    // Não permitir operação com Home
    if String(pgcActiveForms.Pages[FTabSheetTag].Caption).Trim.ToLower = 'home' then Exit;

    pgcActiveForms.Pages[FTabSheetTag].Free;
    pgcActiveForms.ActivePageIndex := Pred(FTabSheetTag);
  Finally
    pgcActiveForms.Align  := alClient;
  End;
end;

procedure TMainView.mniCloseOthersTabClick(Sender: TObject);
var
  lI: Integer;
begin
  Try
    // Evita bug de layoyt
    pgcActiveForms.Align  := alNone;
    pgcActiveForms.Height := 0;

    for lI := Pred(pgcActiveForms.PageCount) downto 0 do
    begin
      if (FTabSheetTag <> lI) then
      Begin
        // Não permitir operação com Home
        if String(pgcActiveForms.Pages[lI].Caption).Trim.ToLower <> 'home' then
          pgcActiveForms.Pages[lI].Free;
      End;
    end;

    if (pgcActiveForms.PageCount > 0)        then pgcActiveForms.ActivePageIndex := 1;
    if (pgcActiveForms.ActivePageIndex = -1) then pgcActiveForms.ActivePageIndex := 0;
  Finally
    pgcActiveForms.Align  := alClient;
  End;
end;

procedure TMainView.pgcActiveFormsMouseEnter(Sender: TObject);
begin
  ShowTabCloseButtonOnHotTab;
end;

procedure TMainView.pgcActiveFormsMouseLeave(Sender: TObject);
begin
  if btnCloseTabSheet <> FindVCLWindow(Mouse.CursorPos) then
  begin
    btnCloseTabSheet.Hide;
    btnCloseTabSheet.Tag := -1;
  end;
end;

procedure TMainView.pgcActiveFormsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
{$WRITEABLECONST ON}
const oldPos : integer = -2;
{$WRITEABLECONST OFF}
var
  iot : integer;
  ctrl : TWinControl;
begin
  inherited;

  iot := TPageControl(Sender).IndexOfTabAt(x,y);

  if (iot > -1) then
  begin
    if iot <> oldPos then
      ShowTabCloseButtonOnHotTab;
  end;

  oldPos := iot;
end;

procedure TMainView.PopupMenu1Popup(Sender: TObject);
begin
  if (btnCloseTabSheet.Tag < 0) then Abort;
  FTabSheetTag := btnCloseTabSheet.Tag;
end;

procedure TMainView.ShowTabCloseButtonOnHotTab;
var
  iot : integer;
  cp : TPoint;
  rectOver: TRect;
begin
  cp := pgcActiveForms.ScreenToClient(Mouse.CursorPos);
  iot := pgcActiveForms.IndexOfTabAt(cp.X, cp.Y);

  if iot > -1 then
  begin
    rectOver := pgcActiveForms.TabRect(iot);

    btnCloseTabSheet.Left := rectOver.Right - btnCloseTabSheet.Width;
    btnCloseTabSheet.Top  := rectOver.Top + ((rectOver.Height div 2) - (btnCloseTabSheet.Height div 2));

    btnCloseTabSheet.Tag := iot;
    btnCloseTabSheet.Show;
  end
  else
  begin
    btnCloseTabSheet.Tag := -1;
    btnCloseTabSheet.Hide;
  end;
end;

procedure TMainView.SpeedButton1Click(Sender: TObject);
var
  lView: TWithoutViewModelView;
begin
  lView := TWithoutViewModelView.Create(nil);
  Try
    lView.ShowModal;
  Finally
    lView.Free;
  end;
end;

end.
