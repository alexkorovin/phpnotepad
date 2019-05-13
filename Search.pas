unit Search;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, Buttons, StdCtrls, PHPEdit, ClipBrd;

type
  TSearchForm = class(TForm)
    MainPanel: TPanel;
    PageControl: TPageControl;
    FindSheet: TTabSheet;
    ReplaceSheet: TTabSheet;
    FindEdit: TEdit;
    FindFromCursorBox: TCheckBox;
    CaseSensitiveFindBox: TCheckBox;
    FindForwardRadio: TRadioButton;
    FindBackwardRadio: TRadioButton;
    FindBtn: TSpeedButton;
    CalcBtn: TSpeedButton;
    CloseFindBtn: TSpeedButton;
    FindStatusBar: TStatusBar;
    FindReplEdit: TEdit;
    ReplaceEdit: TEdit;
    FindReplLabel: TLabel;
    ReplaceLabel: TLabel;
    FindLabel: TLabel;
    ReplaceFromCursorBox: TCheckBox;
    CaseSensitiveReplaceBox: TCheckBox;
    ReplaceForwardRadio: TRadioButton;
    ReplaceBackwardRadio: TRadioButton;
    ReplaceStatusBar: TStatusBar;
    ReplaceBtn: TSpeedButton;
    ReplaceAllBtn: TSpeedButton;
    CloseReplaceBtn: TSpeedButton;
    FInsBtn: TSpeedButton;
    FRInsBtn: TSpeedButton;
    RInsBtn: TSpeedButton;
    procedure PageControlChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    procedure CalcBtnClick(Sender: TObject);
    procedure ReplaceBtnClick(Sender: TObject);
    procedure ReplaceAllBtnClick(Sender: TObject);
    procedure FindEditChange(Sender: TObject);
    procedure FindReplEditChange(Sender: TObject);
    procedure FindFromCursorBoxClick(Sender: TObject);
    procedure ReplaceFromCursorBoxClick(Sender: TObject);
    procedure CaseSensitiveFindBoxClick(Sender: TObject);
    procedure CaseSensitiveReplaceBoxClick(Sender: TObject);
    procedure ReplaceForwardRadioClick(Sender: TObject);
    procedure FindForwardRadioClick(Sender: TObject);
    procedure FindBackwardRadioClick(Sender: TObject);
    procedure ReplaceBackwardRadioClick(Sender: TObject);
    procedure CloseFindBtnClick(Sender: TObject);
    procedure CloseReplaceBtnClick(Sender: TObject);
    procedure FInsBtnClick(Sender: TObject);
    procedure FRInsBtnClick(Sender: TObject);
    procedure RInsBtnClick(Sender: TObject);
    procedure FindEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    PHPEditor: TPHPEdit;
  end;

var
  SearchForm: TSearchForm;

implementation

uses Main;

{$R *.dfm}

procedure TSearchForm.FormShow(Sender: TObject);
begin
  FindStatusBar.Panels[0].Text := '';
  ReplaceStatusBar.Panels[0].Text := '';

  if Caption = 'Find' then
    PageControl.Pages[0].Show
  else if Caption = 'Replace' then
    PageControl.Pages[1].Show
end;

procedure TSearchForm.FRInsBtnClick(Sender: TObject);
begin
  FindReplEdit.Text := Clipboard.AsText;
end;

procedure TSearchForm.PageControlChange(Sender: TObject);
begin
  Caption := PageControl.ActivePage.Caption;
end;

procedure TSearchForm.FindBtnClick(Sender: TObject);
begin
  FindStatusBar.Panels[0].Text := '';
  if not PHPEditor.Find(TState(255), FindEdit.Text,
                        FindFromCursorBox.Checked,
                        CaseSensitiveFindBox.Checked,
                        FindForwardRadio.Checked) then begin
    if FindEdit.Text <> '' then
      FindStatusBar.Panels[0].Text := 'Can not find the text"'+FindEdit.Text+'"';
  end;
end;

procedure TSearchForm.CalcBtnClick(Sender: TObject);
var
  MatcCount: Integer;
begin
  FindStatusBar.Panels[0].Text := '';
  MatcCount := PHPEditor.CalcFind(FindEdit.Text,
                                  FindFromCursorBox.Checked,
                                  CaseSensitiveFindBox.Checked,
                                  FindForwardRadio.Checked);
  if FindEdit.Text <> '' then
    FindStatusBar.Panels[0].Text := IntToStr(MatcCount) + ' matches';
end;

procedure TSearchForm.ReplaceBtnClick(Sender: TObject);
var
  RepCount: Integer;
begin
  ReplaceStatusBar.Panels[0].Text := '';
  RepCount := PHPEditor.Replace(FindReplEdit.Text,
                                ReplaceEdit.Text,
                                ReplaceForwardRadio.Checked,
                                ReplaceFromCursorBox.Checked,
                                CaseSensitiveReplaceBox.Checked);

  ReplaceStatusBar.Panels[0].Text := '';
end;

procedure TSearchForm.ReplaceAllBtnClick(Sender: TObject);
var
  RepCount: Integer;
begin
  ReplaceStatusBar.Panels[0].Text := '';
  RepCount := PHPEditor.ReplaceAll(FindReplEdit.Text,
                                   ReplaceEdit.Text,
                                   ReplaceForwardRadio.Checked,
                                   ReplaceFromCursorBox.Checked,
                                   CaseSensitiveReplaceBox.Checked);

  ReplaceStatusBar.Panels[0].Text := IntToStr(RepCount) + ' occurrences were replaced';
end;

procedure TSearchForm.FindEditChange(Sender: TObject);
begin
  FindReplEdit.Text := FindEdit.Text;
end;

procedure TSearchForm.FindEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then FindBtn.Click;
end;

procedure TSearchForm.FindReplEditChange(Sender: TObject);
begin
  FindEdit.Text := FindReplEdit.Text;
end;

procedure TSearchForm.FInsBtnClick(Sender: TObject);
begin
  FindEdit.Text := Clipboard.AsText;
end;

procedure TSearchForm.FindFromCursorBoxClick(Sender: TObject);
begin
  ReplaceFromCursorBox.Checked := FindFromCursorBox.Checked;
end;

procedure TSearchForm.ReplaceFromCursorBoxClick(Sender: TObject);
begin
  FindFromCursorBox.Checked := ReplaceFromCursorBox.Checked;
end;

procedure TSearchForm.RInsBtnClick(Sender: TObject);
begin
  ReplaceEdit.Text := Clipboard.AsText;
end;

procedure TSearchForm.CaseSensitiveFindBoxClick(Sender: TObject);
begin
  CaseSensitiveReplaceBox.Checked := CaseSensitiveFindBox.Checked;
end;

procedure TSearchForm.CaseSensitiveReplaceBoxClick(Sender: TObject);
begin
  CaseSensitiveFindBox.Checked := CaseSensitiveReplaceBox.Checked;
end;

procedure TSearchForm.FindForwardRadioClick(Sender: TObject);
begin
  ReplaceForwardRadio.Checked := FindForwardRadio.Checked;
end;

procedure TSearchForm.ReplaceForwardRadioClick(Sender: TObject);
begin
  FindForwardRadio.Checked := ReplaceForwardRadio.Checked;
end;

procedure TSearchForm.FindBackwardRadioClick(Sender: TObject);
begin
  ReplaceBackwardRadio.Checked := FindBackwardRadio.Checked;
end;

procedure TSearchForm.ReplaceBackwardRadioClick(Sender: TObject);
begin
  FindBackwardRadio.Checked := ReplaceBackwardRadio.Checked;
end;

procedure TSearchForm.CloseFindBtnClick(Sender: TObject);
begin
  Visible := False;
end;

procedure TSearchForm.CloseReplaceBtnClick(Sender: TObject);
begin
  Visible := False;
end;

end.
