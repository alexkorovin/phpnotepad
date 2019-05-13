program PHPNotepad;

uses
  Forms,
  Windows,
  Dialogs,
  Messages,
  Main in 'Main.pas' {MainFormPND},
  ShortHelp in 'ShortHelp.pas' {ShortHelpForm},
  ABox in 'ABox.pas' {AboutBox},
  Vcl.Themes,
  Vcl.Styles,
  StyleConfigurator in 'StyleConfigurator.pas' {StyleConfiguratorForm},
  Encoding in 'Encoding.pas',
  StringListUnicodeSupport in 'StringListUnicodeSupport.pas',
  PHPEdit in 'PHPEdit.pas',
  DocumentMap in 'DocumentMap.pas',
  TabControl in 'TabControl.pas',
  WordBoxInit in 'WordBoxInit.pas',
  WordBox in 'WordBox.pas' {WordBoxForm},
  Search in 'Search.pas' {SearchForm},
  DBGp in 'DBGp.pas',
  AddWatch in 'AddWatch.pas' {AddWatchForm},
  AddEval in 'AddEval.pas' {AddEvalForm},
  EvalView in 'EvalView.pas' {EvalViewForm},
  DBGpConfig in 'DBGpConfig.pas' {DBGpConfigForm};

{$R *.res}

var
  H: THandle;
  HW: HWND;
  s: String;
  cd : TCopyDataStruct;

begin
  H := CreateMutex(nil, True, 'PHPNotepad_APL');
  if GetLastError = ERROR_ALREADY_EXISTS then begin
    HW := FindWindow('TMainFormPND', nil);
    if HW <> 0 then begin
      s := PChar(ParamStr(1));
      cd.cbData := (Length(ParamStr(1))+1)*2;
      cd.lpData := PChar(s);
      SendMessage(HW, WM_COPYDATA, 0, LParam(@cd));
      Exit;
    end else begin

    end;
  end;
  Application.Initialize;
  TStyleManager.TrySetStyle('Slate Classico');
  Application.CreateForm(TMainFormPND, MainFormPND);
  Application.CreateForm(TWordBoxForm, WordBoxForm);
  Application.CreateForm(TSearchForm, SearchForm);
  Application.CreateForm(TShortHelpForm, ShortHelpForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TWordBoxForm, WordBoxForm);
  Application.CreateForm(TWordBoxForm, WordBoxForm);
  Application.CreateForm(TStyleConfiguratorForm, StyleConfiguratorForm);
  Application.CreateForm(TStyleConfiguratorForm, StyleConfiguratorForm);
  Application.CreateForm(TWordBoxForm, WordBoxForm);
  Application.CreateForm(TSearchForm, SearchForm);
  Application.CreateForm(TAddWatchForm, AddWatchForm);
  Application.CreateForm(TAddEvalForm, AddEvalForm);
  Application.CreateForm(TEvalViewForm, EvalViewForm);
  Application.CreateForm(TDBGpConfigForm, DBGpConfigForm);
  Application.Run;
end.
