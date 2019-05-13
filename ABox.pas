unit ABox;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, SHELLAPI;

type
  TAboutBox = class(TForm)
    Panel: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    WebLabel: TLabel;
    SiteLabel: TLabel;
    SubLabel: TLabel;
    EmailLabel: TLabel;
    TailLabel: TLabel;
    WMZEdit: TEdit;
    WMEEdit: TEdit;
    WMZLabel: TLabel;
    WMELabel: TLabel;
    InfoLabel: TLabel;
    procedure OKButtonClick(Sender: TObject);
    procedure SiteLabelClick(Sender: TObject);
    procedure EmailLabelClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.dfm}

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TAboutBox.FormActivate(Sender: TObject);
begin
  OKButton.SetFocus;
end;

procedure TAboutBox.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    ShellExecute(handle, 'open', 'http://phpnotepad.org/donate/pay.html', nil, nil, SW_SHOW);
end;

procedure TAboutBox.SiteLabelClick(Sender: TObject);
begin
  ShellExecute(handle, 'open', 'http://phpnotepad.org', nil, nil, SW_SHOW);
end;

procedure TAboutBox.EmailLabelClick(Sender: TObject);
begin
  ShellExecute(handle, 'open', 'mailto:supportphpnotepad@gmail.com', nil, nil, SW_SHOW);
end;

end.

