unit AddEval;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TAddEvalForm = class(TForm)
    EvalEdit: TEdit;
    CancelBtn: TSpeedButton;
    OkBtn: TSpeedButton;
    procedure CancelBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddEvalForm: TAddEvalForm;

implementation

{$R *.dfm}

procedure TAddEvalForm.CancelBtnClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TAddEvalForm.OkBtnClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
