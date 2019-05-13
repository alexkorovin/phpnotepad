unit AddWatch;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls;

type
  TAddWatchForm = class(TForm)
    WatchEdit: TEdit;
    CancelBtn: TSpeedButton;
    OkBtn: TSpeedButton;
    procedure OkBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddWatchForm: TAddWatchForm;

implementation

{$R *.dfm}

procedure TAddWatchForm.CancelBtnClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TAddWatchForm.OkBtnClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
