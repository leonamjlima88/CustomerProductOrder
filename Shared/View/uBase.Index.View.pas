unit uBase.Index.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Data.DB, Vcl.WinXCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids,
  Vcl.Forms, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Controls;

type
  TBaseIndexView = class(TForm)
    dtsIndex: TDataSource;
    pnlBackground: TPanel;
    pnlContent: TPanel;
    pnlTitle: TPanel;
    lblTitle: TLabel;
    imgTitle: TImage;
    pnlTitleBottomBar: TPanel;
    scbContent: TScrollBox;
    pnlGrid: TPanel;
    pnlGrid2: TPanel;
    pnlButtonsTop: TPanel;
    pnlOptions: TPanel;
    pnlOptions2: TPanel;
    pnlOptions3: TPanel;
    imgOptions: TImage;
    pnlAppend: TPanel;
    pnlAppend2: TPanel;
    btnAppend: TSpeedButton;
    pnlAppend3: TPanel;
    imgAppend: TImage;
    pnlNavigator: TPanel;
    lblNavShowingRecords: TLabel;
    pnlNavFirst3: TPanel;
    pnlNavFirst2: TPanel;
    pnlNavLast3: TPanel;
    pnlNavLast2: TPanel;
    pnlNavPrior4: TPanel;
    pnlNavPrior2: TPanel;
    pnlNavPrior: TPanel;
    btnNavPrior: TSpeedButton;
    pnlNavNext4: TPanel;
    pnlNavNext2: TPanel;
    pnlNavNext: TPanel;
    btnNavNext: TSpeedButton;
    pnlNavCurrentPage2: TPanel;
    pnlNavCurrentPage: TPanel;
    edtNavCurrentPage: TEdit;
    btnNavFirst: TSpeedButton;
    btnNavLast: TSpeedButton;
    pnlNavLimitPerPage: TPanel;
    pnlNavLimitPerPage2: TPanel;
    lblNavLimitPerPage: TLabel;
    edtNavLimitPerPage: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    edtNavLastPageNumber: TEdit;
    pnlSearch: TPanel;
    pnlSearch4: TPanel;
    pnlSearch2: TPanel;
    lblSearch: TLabel;
    pnlDbgrid: TPanel;
    DBGrid1: TDBGrid;
    lblNoSearch: TLabel;
    lblNoSearch2: TLabel;
    imgNoSearch: TImage;
    Image1: TImage;
    pnlSearch3: TPanel;
    Panel4: TPanel;
    imgDoSearch: TImage;
    imgSearchClear: TImage;
    pnlSearch5: TPanel;
    lblSearchTitle: TLabel;
    edtSearchValue: TEdit;
    IndicatorLoadDoSearch: TActivityIndicator;
    pnlFilter: TPanel;
    pnlFilter2: TPanel;
    imgFilter: TImage;
    btnFilter: TSpeedButton;
    SplitView1: TSplitView;
    pnlSplitView: TPanel;
    pnlSplitView3: TPanel;
    imgSplitView: TImage;
    lblSplitView: TLabel;
    lblSplitView2: TLabel;
    pnlSplitViewApply: TPanel;
    pnlSplitViewApply2: TPanel;
    imgSplitViewApply: TImage;
    pnlSplitViewApply3: TPanel;
    btnSplitViewApply: TSpeedButton;
    pnlSplitViewHide: TPanel;
    pnlSplitViewHide2: TPanel;
    imgSplitViewHide: TImage;
    pnlFilterClean2: TPanel;
    pnlFilterClean: TPanel;
    imgFilterClean: TImage;
    Panel3: TPanel;
    pnlSplitView2: TPanel;
    scbSplitView: TScrollBox;
    procedure FormShow(Sender: TObject); virtual;
    procedure FormCreate(Sender: TObject); virtual;
    procedure btnFilterClick(Sender: TObject); virtual;
    procedure imgSplitViewHideClick(Sender: TObject); virtual;
    procedure btnSplitViewApplyClick(Sender: TObject); virtual;
    procedure imgSplitViewApplyClick(Sender: TObject); virtual;
  private
    { Private declarations }
    FTransparentBackground: TForm;
  public
    { Public declarations }
  end;

var
  BaseIndexView: TBaseIndexView;

implementation

{$R *.dfm}

uses
  uHlp;

procedure TBaseIndexView.btnFilterClick(Sender: TObject);
begin
  SplitView1.Opened := not SplitView1.Opened;
end;

procedure TBaseIndexView.btnSplitViewApplyClick(Sender: TObject);
begin
  SplitView1.Opened := False;
end;

procedure TBaseIndexView.FormCreate(Sender: TObject);
begin
  SplitView1.Width  := 320;
  SplitView1.Opened := False;
  DBGrid1.Visible   := False;
  IndicatorLoadDoSearch.Visible := False;
end;

procedure TBaseIndexView.FormShow(Sender: TObject);
begin
  imgNoSearch.Top  := Trunc((pnlDbgrid.Height/2) - (imgNoSearch.Height/2));
  imgNoSearch.Left := Trunc((pnlGrid2.Width/2) - (imgNoSearch.Width/2));
end;

procedure TBaseIndexView.imgSplitViewApplyClick(Sender: TObject);
begin
  imgSplitViewHideClick(Sender);
end;

procedure TBaseIndexView.imgSplitViewHideClick(Sender: TObject);
begin
  SplitView1.Opened := False;
end;

end.
