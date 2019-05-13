unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PHPEdit, ExtCtrls, ComCtrls, Menus, StdCtrls, Buttons, TabControl,
  ToolWin, ImgList, ClipBrd, CommDlg, WordBoxInit, CheckLst, Registry,
  StringListUnicodeSupport, XMLDoc, XMLIntf, System.ImageList, UxTheme,
  DocumentMap, Vcl.Shell.ShellConsts, Vcl.Shell.ShellCtrls, StrUtils,
  DBGp, Base64, OverbyteIcsWndControl, OverbyteIcsWSocket;

const
  MAX_HISTORY_REC = 100;
  MAX_REOPEN = 20;
  FONTCOUNT = 2;

type
  THistoryRec = record
    Path: String;
    X: Integer;
    Y: Integer;
    ScrPos: Integer;
  end;

  TFontAttr = record
    FontSize: Integer;
    CharWidth: Integer;
    LineHeight: Integer;
  end;

  THelpHint = class(THintWindow)
  private
    Hint: String;
  protected
     procedure Paint; override;
  public
    procedure Show(text: string);
    constructor Create(AOwner: TWinControl);
    destructor Destroy; override;
  end;

  TMainFormPND = class(TForm)
    StatusBar: TStatusBar;
    MainMenu: TMainMenu;
    ItOpen: TMenuItem;
    OpenDialog: TOpenDialog;
    LeftPanel: TPanel;
    PopupMenu: TPopupMenu;
    ItNew: TMenuItem;
    ToolPanel: TPanel;
    pmSelectAll: TMenuItem;
    pmCut: TMenuItem;
    ImageList: TImageList;
    ToolBar: TToolBar;
    PrintBtn: TToolButton;
    ReplaceBtn: TToolButton;
    FindBtn: TToolButton;
    RedoBtn: TToolButton;
    UndoBtn: TToolButton;
    PasteBtn: TToolButton;
    CopyBtn: TToolButton;
    CutBtn: TToolButton;
    CloseAllBtn: TToolButton;
    CloseBtn: TToolButton;
    SaveAllBtn: TToolButton;
    SaveBtn: TToolButton;
    NewBtn: TToolButton;
    ExitBtn: TToolButton;
    OpenBtn: TToolButton;
    Sep_1: TToolButton;
    Sep_2: TToolButton;
    Sep_3: TToolButton;
    ItSave: TMenuItem;
    ItReopen: TMenuItem;
    ItSaveAs: TMenuItem;
    ItSaveAll: TMenuItem;
    ItClose: TMenuItem;
    ItCloseAll: TMenuItem;
    ItExit: TMenuItem;
    MEdit: TMenuItem;
    Search: TMenuItem;
    View: TMenuItem;
    Help: TMenuItem;
    PHPNotepad: TMenuItem;
    About: TMenuItem;
    ItUndoItem: TMenuItem;
    ItRedoItem: TMenuItem;
    ItSep_1: TMenuItem;
    ItCut: TMenuItem;
    ItCopy: TMenuItem;
    ItPaste: TMenuItem;
    ItDelete: TMenuItem;
    ItSelectAll: TMenuItem;
    CloseQueryTimer: TTimer;
    ItFind: TMenuItem;
    ItReplace: TMenuItem;
    ItPrint: TMenuItem;
    MainPanel: TPanel;
    TabPanel: TPanel;
    MFile: TMenuItem;
    SaveDialog: TSaveDialog;
    ModePanel: TPanel;
    ModeBar: TToolBar;
    HTMLBTN: TToolButton;
    PHPBTN: TToolButton;
    JSBTN: TToolButton;
    CSSBTN: TToolButton;
    TXTBTN: TToolButton;
    pmCopy: TMenuItem;
    pmPaste: TMenuItem;
    pmDelete: TMenuItem;
    XMLBTN: TToolButton;
    Encoding: TMenuItem;
    ItANSI: TMenuItem;
    ItUTF8: TMenuItem;
    ItUCSBigEndian: TMenuItem;
    ItUCS2LittleEndian: TMenuItem;
    N1: TMenuItem;
    IttoANSI: TMenuItem;
    IttoUTF8: TMenuItem;
    IttoUCS2BigEndian: TMenuItem;
    IttoUCS2LittleEndian: TMenuItem;
    PrintDialog: TPrintDialog;
    LicensePanel: TPanel;
    LicenseAgreeBox: TCheckBox;
    ItPageSeparator: TMenuItem;
    LeftSplitter: TSplitter;
    ItDocumentMap: TMenuItem;
    ItStyleConfigurator: TMenuItem;
    ItUTF8WithOutBOM: TMenuItem;
    IttoUTF8WithOutBOM: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    ItZoomIn: TMenuItem;
    ItZoomOut: TMenuItem;
    ZoomInBtn: TToolButton;
    ZoomOutBtn: TToolButton;
    Sep_4: TToolButton;
    itFonts: TMenuItem;
    itCourierNew: TMenuItem;
    itConsolas: TMenuItem;
    ItUbuntuMono: TMenuItem;
    ClassTreeView: TTreeView;
    ItClassView: TMenuItem;
    TreeImageList: TImageList;
    PageControl: TPageControl;
    ClassViewSheet: TTabSheet;
    FileExplorerSheet: TTabSheet;
    ItFileExplorer: TMenuItem;
    ItBlockEdging: TMenuItem;
    ItHelpLanguage: TMenuItem;
    ItLangEn: TMenuItem;
    ItLangRu: TMenuItem;
    DebugPanel: TPanel;
    BottomSplitter: TSplitter;
    DebugPageControl: TPageControl;
    GlobalSheet: TTabSheet;
    LocalSheet: TTabSheet;
    WatchesSheet: TTabSheet;
    StackSheet: TTabSheet;
    BreakpointsSheet: TTabSheet;
    DebugMenuPanel: TPanel;
    GlobalTreeView: TTreeView;
    LocalTreeView: TTreeView;
    ItDebugger: TMenuItem;
    DebugToolBar: TToolBar;
    DebSep: TToolButton;
    ListenBtn: TToolButton;
    DebugImageList: TImageList;
    RunNextBtn: TToolButton;
    RunToCursorBtn: TToolButton;
    TraceIntoBtn: TToolButton;
    StepOverBtn: TToolButton;
    StepOutBtn: TToolButton;
    ToolButton7: TToolButton;
    AddWatchBtn: TToolButton;
    EvalBtn: TToolButton;
    ToolButton6: TToolButton;
    BreakPointsView: TListView;
    StackView: TListView;
    WatchesView: TListView;
    WatchPopupMenu: TPopupMenu;
    Addwatch: TMenuItem;
    Deletewatch: TMenuItem;
    DebugInfoPanel: TPanel;
    ToolButton1: TToolButton;
    DebOptionBtn: TToolButton;
    DebBtn: TToolButton;
    ToolButton2: TToolButton;
    Run1: TMenuItem;
    ItListen: TMenuItem;
    ItRun: TMenuItem;
    ItRunToCursor: TMenuItem;
    ItTraceInto: TMenuItem;
    ItStepOver: TMenuItem;
    ItStepOut: TMenuItem;
    ItAddWatch: TMenuItem;
    ItEval: TMenuItem;
    ItDebOptions: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    procedure ItOpenClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ItNewClick(Sender: TObject);
    procedure pmCopyClick(Sender: TObject);
    procedure pmPasteClick(Sender: TObject);
    procedure pmDeleteClick(Sender: TObject);
    procedure pmSelectAllClick(Sender: TObject);
    procedure pmCutClick(Sender: TObject);
    procedure UndoBtnClick(Sender: TObject);
    procedure NewBtnClick(Sender: TObject);
    procedure RedoBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseQueryTimerTimer(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure ItCopyClick(Sender: TObject);
    procedure ItDeleteClick(Sender: TObject);
    procedure ItPasteClick(Sender: TObject);
    procedure ItCutClick(Sender: TObject);
    procedure ItSelectAllClick(Sender: TObject);
    procedure ItUndoItemClick(Sender: TObject);
    procedure ItRedoItemClick(Sender: TObject);
    procedure ItSaveClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure ItSaveAsClick(Sender: TObject);
    procedure ItCloseClick(Sender: TObject);
    procedure ItSaveAllClick(Sender: TObject);
    procedure ItCloseAllClick(Sender: TObject);
    procedure SaveAllBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure CloseAllBtnClick(Sender: TObject);
    procedure SaveDialogTypeChange(Sender: TObject);
    procedure HTMLBTNClick(Sender: TObject);
    procedure PHPBTNClick(Sender: TObject);
    procedure JSBTNClick(Sender: TObject);
    procedure CSSBTNClick(Sender: TObject);
    procedure TXTBTNClick(Sender: TObject);
    procedure ItExitClick(Sender: TObject);
    procedure CutBtnClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure PasteBtnClick(Sender: TObject);
    procedure XMLBTNClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure ItFindClick(Sender: TObject);
    procedure ItReplaceClick(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    procedure ReplaceBtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure ItPrintClick(Sender: TObject);
    procedure LicenseAgreeBoxClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure PHPNotepadClick(Sender: TObject);
    procedure AboutClick(Sender: TObject);
    procedure ItPageSeparatorClick(Sender: TObject);
    procedure IttoANSIClick(Sender: TObject);
    procedure IttoUTF8Click(Sender: TObject);
    procedure IttoUCS2BigEndianClick(Sender: TObject);
    procedure IttoUCS2LittleEndianClick(Sender: TObject);
    procedure ItDocumentMapClick(Sender: TObject);
    procedure ItStyleConfiguratorClick(Sender: TObject);
    procedure IttoUTF8WithOutBOMClick(Sender: TObject);
    procedure ItZoomInClick(Sender: TObject);
    procedure ItZoomOutClick(Sender: TObject);
    procedure ZoomInBtnClick(Sender: TObject);
    procedure ZoomOutBtnClick(Sender: TObject);
    procedure itCourierNewClick(Sender: TObject);
    procedure itConsolasClick(Sender: TObject);
    procedure itInconsolataClick(Sender: TObject);
    procedure ItUbuntuMonoClick(Sender: TObject);
    procedure ItClassViewClick(Sender: TObject);
    procedure ShellTreeDblClick(Sender: TObject);
    procedure ItFileExplorerClick(Sender: TObject);
    procedure LeftPanelResize(Sender: TObject);
    procedure ClassTreeViewDblClick(Sender: TObject);
    procedure ItBlockEdgingClick(Sender: TObject);
    procedure ItLangEnClick(Sender: TObject);
    procedure ItLangRuClick(Sender: TObject);
    procedure MainPanelResize(Sender: TObject);
    procedure DebugPanelResize(Sender: TObject);
    procedure ItDebuggerClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure AddwatchClick(Sender: TObject);
    procedure AddWatchBtnClick(Sender: TObject);
    procedure DeletewatchClick(Sender: TObject);
    procedure EvalBtnClick(Sender: TObject);
    procedure DebOptionBtnClick(Sender: TObject);
    procedure DebBtnClick(Sender: TObject);
    procedure ItRunClick(Sender: TObject);
    procedure ItListenClick(Sender: TObject);
    procedure ItRunToCursorClick(Sender: TObject);
    procedure ItTraceIntoClick(Sender: TObject);
    procedure ItStepOverClick(Sender: TObject);
    procedure ItStepOutClick(Sender: TObject);
    procedure ItAddWatchClick(Sender: TObject);
    procedure ItEvalClick(Sender: TObject);
    procedure ItDebOptionsClick(Sender: TObject);
    procedure FormAfterMonitorDpiChanged(Sender: TObject; OldDPI,
      NewDPI: Integer);
  private
    mdOpen: Boolean;
    procedure ReceiveMessage(var Msg: TMessage); message WM_COPYDATA;
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
  public
    DBGpServer: TDBGpServer;
    ReopenPath: String;
    DocCloseTimer: array of TTimer;
    DocCounter: Integer;
    ActivDocID: Integer;
    TabControl: TTabControl;
    ReadLicense: Integer;
    ShowSepLine: Boolean;
    ShowDocMap: Boolean;
    ShowClassView: Boolean;
    ShowFileExplorer: Boolean;
    ShowDebugger: Boolean;
    ShowBlockEdging: Boolean;
    BeginUserEdit: Boolean;
    HistoryList: array[0..MAX_HISTORY_REC - 1] of THistoryRec;
    FontAttr: array[0..FONTCOUNT-1,-2..3] of TFontAttr;
    ZoomVal: Integer;
    AppFontNo: Integer;
    AppFonts: array[0..FONTCOUNT-1] of String;
    BoxW: Integer;
    BoxH: Integer;
    BreakAtFirst: Boolean;
    HHint: THelpHint;
    HELP_PREF: String;
    RefIdentName: String;
    RefX: Integer;
    RefY: Integer;
    RefIndex: Integer;
    RefDocID: Integer;
    RefObject: TObject;
    RefActivDocID: Integer;
    procedure LoadDocFromFile(Path: String);
    procedure ChoiceTab(Sender: TObject; var TabID: Integer);
    procedure CloseTab(Sender: TObject; var TabID: Integer);
    procedure AssignActivDocWithMenu(ActivObj: TPHPEdit);
    procedure CloseTimerTab(Sender: TObject);
    procedure ChangeScanMode(SelectScanMode: TScanMode);
    procedure ReopenClick(Sender: TObject);
    function ExtentionFilter(Ext: String): Integer;
    procedure ReopenItemInsert(PHPEdit: TPHPEdit);
    procedure FollowLink;
  end;

var
  MainFormPND: TMainFormPND;
  Docs: array of TPHPEdit;
  SCREENSCALE: Double;

implementation

uses Math, WordBox, Search, ShortHelp, ABox, Types, StyleConfigurator,
  Encoding, AddWatch, AddEval, DBGpConfig;

{$R *.dfm}

constructor THelpHint.Create(AOwner: TWinControl);
begin
  inherited Create(AOwner);
end;

destructor THelpHint.Destroy;
begin
  inherited Destroy;
end;

procedure THelpHint.Show(text: string);
var
  HintPosition: TRect;
  LF, L, T: Integer;
  shf: Integer;
begin
  shf := Docs[MainFormPND.ActivDocID].HorsStartPos * Docs[MainFormPND.ActivDocID].CharWidth;
  LF :=  Docs[MainFormPND.ActivDocID].CreateScreenAnchorBox;
  L := Docs[MainFormPND.ActivDocID].ScreenAnchorBox.ClientToScreen(Point(0,0)).X + LF - shf;
  T := Docs[MainFormPND.ActivDocID].ScreenAnchorBox.ClientToScreen(Point(0,0)).Y;
  Docs[MainFormPND.ActivDocID].FreeScreenAnchorBox;

  HintPosition.Left := L;
  HintPosition.Top := T;
  HintPosition.Right := L + 700;
  HintPosition.Bottom := T;
  Hint := text;
  ActivateHint(HintPosition, '');
end;

procedure THelpHint.Paint;
var
  i, j, strno, lineh: Integer;
  spacePos: Integer;
  CharWidth: Integer;
  Line: String;
  carry: Boolean;
begin
  Canvas.Font.Name := 'Consolas';
  Canvas.Font.Size := 10; //char width = 7px
  CharWidth := 7;
  Line := '';
  strno := 0;
  lineh := 17;

  Canvas.Rectangle(0,0,Width,Height);
  for i := 1 to Length(Hint) do begin
    if (Hint[i] <> #13) and ((Hint[i] <> #10)) then begin
      Line := Line + Hint[i];
    end;  
    if (Hint[i] = #13) or (i = Length(Hint)) then begin   
      if (i = Length(Hint)) and ((Length(Line) * CharWidth) > Width) then begin
        carry := False;
        for j := Length(Line) - 1 downto 0  do begin
          if (Line[j] = #32) then begin
            Canvas.TextOut(3, strno * lineh + 3, Copy(Line, 1, j));
            Line := Copy(Line, j+1, Length(Line));
            Inc(strno); 
            Canvas.TextOut(3, strno * lineh + 3, Line);
            Inc(strno);                            
            carry := True;
            Break;
          end;
        end;
        if not carry then begin   
          Width := Length(Line) * CharWidth + CharWidth;
        end;       
      end
      else begin       
        Canvas.TextOut(3, strno * lineh + 3, Line);
        Line := '';
        Inc(strno);
      end;
    end;
    if (Hint[i] = #32) then begin
      spacePos := Length(Line);
      if (spacePos * CharWidth) > Width then begin
        carry := False;
        for j := Length(Line) - 1 downto 0  do begin
          if (Line[j] = #32) then begin
            Canvas.TextOut(3, strno * lineh + 3, Copy(Line, 1, j));
            Line := Copy(Line, j+1, Length(Line));
            Inc(strno);
            carry := True;
            Break;
          end;
        end;
        if not carry then begin
          Width := spacePos * CharWidth + CharWidth;
        end;
      end;
    end;
  end;

  Height := strno * lineh + 5;
end;

procedure TMainFormPND.ReopenItemInsert(PHPEdit: TPHPEdit);
var
  i,j,n: Integer;
  HisItem: TMenuItem;
begin
  //удалили если есть в списке
  for i := 0 to MAX_HISTORY_REC - 1 do begin
    if HistoryList[i].Path = PHPEdit.GetDocPath then begin
      for j := i to MAX_HISTORY_REC - 2 do begin
        HistoryList[j].Path := HistoryList[j+1].Path;
        HistoryList[j].X := HistoryList[j+1].X;
        HistoryList[j].Y := HistoryList[j+1].Y;
        HistoryList[j].ScrPos := HistoryList[j+1].ScrPos;
      end;
      HistoryList[Length(HistoryList)-1].Path := '';
      HistoryList[Length(HistoryList)-1].X := 0;
      HistoryList[Length(HistoryList)-1].Y := 0;
      HistoryList[Length(HistoryList)-1].ScrPos := 0;
      Break
    end;
  end;

  for i := MAX_HISTORY_REC - 1 downto 1 do begin
    HistoryList[i].Path := HistoryList[i-1].Path;
    HistoryList[i].X := HistoryList[i-1].X;
    HistoryList[i].Y := HistoryList[i-1].Y;
    HistoryList[i].ScrPos := HistoryList[i-1].ScrPos;
  end;
  HistoryList[0].Path := PHPEdit.GetDocPath;
  HistoryList[0].X := PHPEdit.CaretPos.X;
  HistoryList[0].Y := PHPEdit.CaretPos.Y;
  HistoryList[0].ScrPos := PHPEdit.GetVertScrollPos;

  ItReopen.Clear;
  n := 0;
  while HistoryList[n].Path <> '' do begin
    HisItem := TMenuItem.Create(Self);
    HisItem.Caption := HistoryList[n].Path;
    HisItem.Hint := HistoryList[n].Path;
    HisItem.OnClick := ReopenClick;
    ItReopen.Insert(n, HisItem);
    Inc(n);
    if n = MAX_REOPEN then Break;
  end;

  for i := 0 to ItReopen.Count - 1 do begin
    ItReopen.Items[i].Tag := i;
  end;
end;

procedure TMainFormPND.ReceiveMessage(var Msg: TMessage);
var
  pcd : PCopyDataStruct;
  i: Integer;
  flag: Boolean;

begin
  pcd := PCopyDataStruct(Msg.LParam);

  if (String(PChar(pcd.lpData)) <> '') then begin
    flag := False;
    for i := 0 to Length(Docs) - 1 do begin
      if Docs[i] <> nil then begin
        if Docs[i].GetDocPath = String(PChar(pcd.lpData)) then begin
          flag := True;
          TabControl.SelectTab(Docs[i].ID);
        end;
      end;
    end;
    if not flag then LoadDocFromFile(String(PChar(pcd.lpData)));
    TabControl.Refresh;
  end;

  if IsIconic(Application.Handle) then
    Application.Restore
  else
    Application.BringToFront;
end;

procedure TMainFormPND.AddWatchBtnClick(Sender: TObject);
begin
  Addwatch.Click;
end;

procedure TMainFormPND.AddwatchClick(Sender: TObject);
begin
  AddWatchForm.WatchEdit.Text := '';

  if AddWatchForm.ShowModal = mrOk then begin
    if Length(Docs) > 0 then begin
      if Docs[ActivDocID] <> nil then begin
        DBGpServer.AddWatch(Docs[ActivDocID].GetDocPath, AddWatchForm.WatchEdit.Text);
      end;
    end;
  end
  else begin

  end;
end;

procedure TMainFormPND.DeletewatchClick(Sender: TObject);
begin
  if WatchesView.SelCount > 0 then begin
    DBGpServer.DeleteWatch(WatchesView.Selected.Index);
    WatchesView.DeleteSelected;
  end;
end;

procedure TMainFormPND.AppMessage(var Msg: TMsg; var Handled: Boolean);
var
  i, LPos, FPos: Integer;
  flag: Boolean;
  hnt: String;
  HintList: TStringList;
begin
  if Msg.message = WM_KEYDOWN then begin

    if Length(Docs) > 0 then begin
      if Docs[ActivDocID] <> nil then begin
       Docs[ActivDocID].TreeScanWaitTick := 0;
       Docs[ActivDocID].ClassFuncWaitTick := 0;
      end;
    end;

    if HHint <> nil then FreeAndNil(HHint);
    BeginUserEdit := True;
    if Length(Docs) > 0 then begin
      if Docs[ActivDocID] <> nil then begin
        if (Docs[ActivDocID].CaretPos.Y <= Docs[ActivDocID].CurrentScanLineNo) and (ReadLicense = 1) then begin

          if (Msg.wParam = 112)then begin
             hnt := Docs[ActivDocID].GetHelpFuncStr;
             if hnt <> '' then begin
               HintList := TStringList.Create;
               try
                 HintList.LoadFromFile(ExtractFilePath(Application.ExeName)+'\AppData\ShortHelp_'+HELP_PREF+'.xml');
                 LPos := PosEx('<FName>'+hnt+'</FName>',HintList.Text,1);
                 if LPos > 0 then begin
                   LPos := LPos + Length('<FName>'+hnt+'</FName>');
                   LPos := PosEx('<Desc>',HintList.Text,LPos);
                   if LPos > 0 then begin
                     LPos := LPos + Length('<Desc>');
                     FPos := PosEx('</Desc>',HintList.Text,LPos);
                     if FPos > 0 then begin
                       HHint := THelpHint.Create(Self);
                       HHint.Show(UTF8ToString(Trim(Copy(HintList.Text,LPos,FPos-LPos))));
                     end;
                   end;
                 end;
               except
               end;

               HintList.Free;
             end;
             Handled := True;
          end

          else

          if (Msg.wParam = 46) and mdOpen then begin
            if SearchForm.FindEdit.Focused then begin
              SendMessage(SearchForm.FindEdit.Handle, WM_KEYDOWN, VK_DELETE, 0);
              Handled := True;
            end else
            if SearchForm.FindReplEdit.Focused then begin
              SendMessage(SearchForm.FindReplEdit.Handle, WM_KEYDOWN, VK_DELETE, 0);
              Handled := True;
            end else
            if SearchForm.ReplaceEdit.Focused then begin
              SendMessage(SearchForm.ReplaceEdit.Handle, WM_KEYDOWN, VK_DELETE, 0);
              Handled := True;
            end else begin
             if not Docs[ActivDocID].TextSelected then begin
                Docs[ActivDocID].DeleteChar;
              end;
            end;
          end

          else

          if ((GetKeyState(VK_CONTROL) and 128) = 128) and (Msg.wParam = 32) then begin
            if Length(Docs) > 0 then begin
              if Docs[ActivDocID] <> nil then begin
                if WordBoxForm.Visible = False then begin
                  Docs[ActivDocID].AlignWindowIfCursorHide;
                  Docs[ActivDocID].ValignWindowIfCursorHide;
                  WordBoxForm.SetParams;
                end;
              end;
            end;
            Handled := True;
          end

          else

          if ((GetKeyState(VK_SHIFT) and 128) = 128) and ((GetKeyState(VK_CONTROL) and 128) = 128) and (Msg.wParam = 85) then begin
            if Length(Docs) > 0 then begin
              if Docs[ActivDocID] <> nil then begin
                Docs[ActivDocID].ShiftBlockLeft;
              end;
            end;
            Handled := True
          end

          else

          if ((GetKeyState(VK_SHIFT) and 128) = 128) and ((GetKeyState(VK_CONTROL) and 128) = 128) and (Msg.wParam = 73) then begin
            if Length(Docs) > 0 then begin
              if Docs[ActivDocID] <> nil then begin
                Docs[ActivDocID].ShiftBlockRight;
              end;
            end;
            Handled := True
          end

          else

          if ((GetKeyState(VK_CONTROL) and 128) = 128) and (Msg.wParam = 38) then begin
            if Length(Docs) > 0 then begin
              if Docs[ActivDocID] <> nil then begin
                Docs[ActivDocID].ScrollLineUp;
              end;
            end;
            Handled := True
          end

          else

          if ((GetKeyState(VK_CONTROL) and 128) = 128) and (Msg.wParam = 40) then begin
            if Length(Docs) > 0 then begin
              if Docs[ActivDocID] <> nil then begin
                Docs[ActivDocID].ScrollLineDown;
              end;
            end;
            Handled := True
          end

          else

          if ((GetKeyState(VK_CONTROL) and 128) = 128) and (Msg.wParam = 107) then begin
            ItZoomIn.Click;
            Handled := True
          end

          else

          if ((GetKeyState(VK_CONTROL) and 128) = 128) and (Msg.wParam = 109) then begin
            ItZoomOut.Click;
            Handled := True
          end

          else
          //Ctrl+X
          if ((GetKeyState(VK_CONTROL) and 128) = 128) and (Msg.wParam = 88) then begin
            if SearchForm.FindEdit.Focused then begin
              SendMessage(SearchForm.FindEdit.Handle, WM_CUT, 0, 0);
              Handled := True;
            end else
            if SearchForm.FindReplEdit.Focused then begin
              SendMessage(SearchForm.FindReplEdit.Handle, WM_CUT, 0, 0);
              Handled := True;
            end else
            if SearchForm.ReplaceEdit.Focused then begin
              SendMessage(SearchForm.ReplaceEdit.Handle, WM_CUT, 0, 0);
              Handled := True;
            end else begin
              Handled := False;
            end;
          end

          else
          //Ctrl+C
          if ((GetKeyState(VK_CONTROL) and 128) = 128) and (Msg.wParam = 67) then begin
            if SearchForm.FindEdit.Focused then begin
              SendMessage(SearchForm.FindEdit.Handle, WM_COPY, 0, 0);
              Handled := True;
            end else
            if SearchForm.FindReplEdit.Focused then begin
              SendMessage(SearchForm.FindReplEdit.Handle, WM_COPY, 0, 0);
              Handled := True;
            end else
            if SearchForm.ReplaceEdit.Focused then begin
              SendMessage(SearchForm.ReplaceEdit.Handle, WM_COPY, 0, 0);
              Handled := True;
            end else begin
              Handled := False;
            end;
          end

          else
          //Ctrl+V
          if ((GetKeyState(VK_CONTROL) and 128) = 128) and (Msg.wParam = 86) then begin
            if SearchForm.FindEdit.Focused then begin
              SendMessage(SearchForm.FindEdit.Handle, WM_PASTE, 0, 0);
              Handled := True;
            end else
            if SearchForm.FindReplEdit.Focused then begin
              SendMessage(SearchForm.FindReplEdit.Handle, WM_PASTE, 0, 0);
              Handled := True;
            end else
            if SearchForm.ReplaceEdit.Focused then begin
              SendMessage(SearchForm.ReplaceEdit.Handle, WM_PASTE, 0, 0);
              Handled := True;
            end else begin
              Handled := False;
            end;
          end

          else
          //Ctrl+Z
          if ((GetKeyState(VK_CONTROL) and 128) = 128) and (Msg.wParam = 90) then begin
            if SearchForm.FindEdit.Focused then begin
              SendMessage(SearchForm.FindEdit.Handle, WM_UNDO, 0, 0);
              Handled := True;
            end else
            if SearchForm.FindReplEdit.Focused then begin
              SendMessage(SearchForm.FindReplEdit.Handle, WM_UNDO, 0, 0);
              Handled := True;
            end else
            if SearchForm.ReplaceEdit.Focused then begin
              SendMessage(SearchForm.ReplaceEdit.Handle, WM_UNDO, 0, 0);
              Handled := True;
            end else begin
              Handled := False;
            end;
          end

          else if Msg.hwnd = ClassTreeView.Handle then begin
            if (Msg.wParam = 37) then begin
              StatusBar.Panels[3].Text := '';

              Docs[ActivDocID].FindAndSelectAll(ClassTreeView.Selected.Text,
                                                TState(Integer(ClassTreeView.Selected.Data)));

              Docs[ActivDocID].Find(TState(Integer(ClassTreeView.Selected.Data)),
                                    ClassTreeView.Selected.Text, True, True, False);
              Handled := True;
            end;
            if (Msg.wParam = 39) then begin
              StatusBar.Panels[3].Text := '';

              Docs[ActivDocID].FindAndSelectAll(ClassTreeView.Selected.Text,
                                                TState(Integer(ClassTreeView.Selected.Data)));

              Docs[ActivDocID].Find(TState(Integer(ClassTreeView.Selected.Data)),
                                    ClassTreeView.Selected.Text, True, True, True);
              Handled := True;
            end;
          end;
        end else Handled := True;
      end;
    end;
  end
  else if (Msg.message = WM_MOUSEWHEEL) then begin
    if HHint <> nil then FreeAndNil(HHint);
  end
  else if (Msg.hwnd = ClassTreeView.Handle) and (Msg.message = WM_MOUSEWHEEL) then begin
    if Length(Docs) > 0 then begin
      if Docs[ActivDocID] <> nil then begin
        Docs[ActivDocID].SetFocus;
      end;
    end;

    Handled := True;
  end
  else if (Msg.message = WM_LBUTTONDOWN) or (Msg.message = WM_RBUTTONDOWN) then begin
    if HHint <> nil then FreeAndNil(HHint);
    BeginUserEdit := True;
  end
  else if Msg.message = WM_USER+1 then begin
    LoadDocFromFile(ReopenPath);
  end
  else if Msg.message = WM_USER+2 then begin

  end
  else if Msg.message = WM_USER+3 then begin
    flag := False;

    for i := 0 to Length(Docs) - 1 do begin
      if Docs[i] <> nil then begin
        if Docs[i].GetDocPath = ParamStr(1) then begin
          flag := True;
          TabControl.SelectTab(Docs[i].ID);
        end;
      end;
    end;
    if not flag then LoadDocFromFile(ParamStr(1));

    TabControl.Refresh;
  end
  else if Msg.message = WM_USER+4 then begin
    FollowLink;
  end
  else if Msg.message = WM_USER+5 then begin
    flag := False;

    for i := 0 to Length(Docs) - 1 do begin
      if Docs[i] <> nil then begin
        if Docs[i].ID = Docs[RefDocID].ID then begin
          flag := True;
          Break;
        end;
      end;
    end;

    if flag then begin
      if (ActivDocID <> (Docs[RefDocID].ID)) then begin
        TabControl.SelectTab(Docs[RefDocID].ID);
        TabControl.Update;
      end;
      Docs[RefDocID].RefJumpTo(1, Integer(RefObject), RefActivDocID, RefY);
      Docs[RefDocID].SetCursor(1, Integer(RefObject));
      Docs[RefDocID].Repaint;
    end;
  end
  else if Msg.message = WM_USER+6 then begin
    BottomSplitter.Top := DebugPanel.Top - 1;
  end
  else if Msg.message = WM_USER+7 then begin
    TDBGpWSocket(msg.LParam).Destroy;
  end;


  if ((GetKeyState(VK_CONTROL) and 128) = 128) and (Msg.message = WM_MOUSEMOVE) then begin
    if Length(Docs) > 0 then begin
      if Docs[ActivDocID] <> nil then begin
        PostMessage(Handle, WM_USER+4, 0, 0);
      end;
    end;
  end

  else

  if ((GetKeyState(VK_CONTROL) and 128) = 128) and (Msg.message = WM_LBUTTONDOWN) then begin
    if Length(Docs) > 0 then begin
      if Docs[ActivDocID] <> nil then begin
        if Docs[ActivDocID].FollowRef then begin
          PostMessage(Handle, WM_USER+5, 0, 0);
          Handled := True;
        end;
      end;
    end;
  end

  else

  if (Msg.message = WM_KEYUP) and (Msg.wParam = VK_CONTROL) then begin
    if Length(Docs) > 0 then begin
      for i := 0 to Length(Docs) - 1 do begin
        if (Docs[i] <> nil) then begin
          Docs[i].SetFollowRef(0, 0, 0, RefIdentName, False);
        end;
      end;
    end;
  end;
end;

procedure TMainFormPND.FollowLink;
var
  i,j: Integer;
  X,Y: Integer;
  wfrom, wto: Integer;
  Ch: Char;
begin
  wfrom := 0;
  wto := 0;
  X := Docs[ActivDocID].MouseX div Docs[ActivDocID].CharWidth + Docs[ActivDocID].HorsStartPos;
  Y := Docs[ActivDocID].GetVertScrollPos + Docs[ActivDocID].MouseY div Docs[ActivDocID].LineHeight;
  if Y < 0 then Y := 0;
  
  RefActivDocID := ActivDocID;

  if (Y < Docs[ActivDocID].StringList.Count) and (Length(Docs[ActivDocID].StringList[Y]) > 0) then begin
    if X <= Length(Docs[ActivDocID].StringList[Y]) then begin
      for i := X downto 1 do begin
        Ch := Docs[ActivDocID].StringList[Y][i];
        if not (IsCharAlpha(Ch) or (Ch in ['0'..'9','_'])) then begin
          wfrom := i+1;
          Break;
        end;
        if (i = 1) then wfrom := 1;
      end;
      for i := X to Length(Docs[ActivDocID].StringList[Y])  do begin
        Ch := Docs[ActivDocID].StringList[Y][i];
        if not (IsCharAlpha(Ch) or (Ch in ['0'..'9','_'])) then begin
          wto := i;
          Break;
        end;
         if (i = Length(Docs[ActivDocID].StringList[Y])) then
           wto := i + 1;
      end;
      if ((wto - wfrom) > 0) then begin
        if (RefIdentName <> Copy(Docs[ActivDocID].StringList[Y], wfrom, wto-wfrom)) or
           (RefY <> Y) or (X < wfrom) or (X > wto)
        then begin
          RefIdentName := Copy(Docs[ActivDocID].StringList[Y], wfrom, wto-wfrom);

          if Docs[ActivDocID].GetStatePos(X,Y) = ScanPHP then begin
            RefX := X;
            RefY := Y;
            RefIndex := -1;

            if Docs[ActivDocID].PHPUserClassList.Find(RefIdentName, RefIndex) then begin
              Docs[ActivDocID].SetFollowRef(Y, wfrom ,wto, RefIdentName, True);
              RefDocID := Docs[ActivDocID].ID;
              RefObject := Docs[ActivDocID].PHPUserClassList.Objects[RefIndex];
            end
            else if Docs[ActivDocID].PHPUserFuncList.Find(RefIdentName, RefIndex) then begin
              Docs[ActivDocID].SetFollowRef(Y, wfrom, wto, RefIdentName, True);
              RefDocID := Docs[ActivDocID].ID;
              RefObject := Docs[ActivDocID].PHPUserFuncList.Objects[RefIndex];
            end
            else begin
              for i := 0 to Length(Docs) - 1 do begin
                if (Docs[i] <> nil) then begin
                  if Docs[i].PHPUserClassList.Find(RefIdentName, RefIndex) then begin
                    Docs[ActivDocID].SetFollowRef(Y, wfrom ,wto, RefIdentName, True);
                    RefDocID := Docs[i].ID;
                    RefObject := Docs[i].PHPUserClassList.Objects[RefIndex];
                    Break;
                  end
                  else if Docs[i].PHPUserFuncList.Find(RefIdentName, RefIndex) then begin
                    Docs[ActivDocID].SetFollowRef(Y, wfrom, wto, RefIdentName, True);
                    RefDocID := Docs[i].ID;
                    RefObject := Docs[i].PHPUserFuncList.Objects[RefIndex];
                    Break;
                  end
                end;
              end;
            end;
            if RefIndex = -1 then begin
              Docs[ActivDocID].SetFollowRef(0, 0, 0, '', False);
              RefIdentName := '';
              RefX := -1;
              RefY := -1;
            end;
          end else begin
            Docs[ActivDocID].SetFollowRef(0, 0, 0, '', False);
            RefIdentName := '';
            RefX := -1;
            RefY := -1;
          end;
        end;
      end else begin
        Docs[ActivDocID].SetFollowRef(0, 0, 0, '', False);
        RefIdentName := '';
        RefX := -1;
        RefY := -1;
      end;
    end else begin
      Docs[ActivDocID].SetFollowRef(0, 0, 0, '', False);
      RefIdentName := '';
      RefX := -1;
      RefY := -1;
    end;
  end else begin
    Docs[ActivDocID].SetFollowRef(0, 0, 0, '', False);
    RefIdentName := '';
    RefX := -1;
    RefY := -1;
  end;
end;

function TMainFormPND.ExtentionFilter(Ext: String): Integer;
begin
  Result := -1;
  if (LowerCase(Ext) = '.php') or (LowerCase(Ext) = '.php3') or (LowerCase(Ext) = '.php4') or (LowerCase(Ext) = '.php5') or
     (LowerCase(Ext) = '.phps') or (LowerCase(Ext) = '.phpt') or (LowerCase(Ext) = '.phtml') then begin
    Result := 1;
  end else
  if (LowerCase(Ext) = '.js') or (LowerCase(Ext) = '.jsx') or (LowerCase(Ext) = '.jsm') or (LowerCase(Ext) = '.ts') or
     (LowerCase(Ext) = '.tsx')  then begin
    Result := 2;
  end else
  if (LowerCase(Ext) = '.json') then begin
    Result := 3;
  end else
  if (LowerCase(Ext) = '.html') or (LowerCase(Ext) = '.htm') or (LowerCase(Ext) = '.shtml') or (LowerCase(Ext) = '.shtm') or
     (LowerCase(Ext) = '.xhtml') or (LowerCase(Ext) = '.xht') or (LowerCase(Ext) = '.hta') then begin
    Result := 4;
  end else
  if (LowerCase(Ext) = '.css') then begin
    Result := 5;
  end else
  if (LowerCase(Ext) = '.xml') then begin
    Result := 6;
  end else begin
    Result := 7;
  end;
end;

procedure TMainFormPND.LoadDocFromFile(Path: String);
var
  i,j,n: Integer;
  Ext: String;
  DMap: TDocMap;
  HisItem: TMenuItem;
begin
  BeginUserEdit := False;
  if not FileExists(Path) then begin
    //---------------------------------------------------
    //удалили если есть в списке (Reopen)
    for i := 0 to MAX_HISTORY_REC - 1 do begin
      if HistoryList[i].Path = Path then begin
        for j := i to MAX_HISTORY_REC - 2 do begin
          HistoryList[j].Path := HistoryList[j+1].Path;
          HistoryList[j].X := HistoryList[j+1].X;
          HistoryList[j].Y := HistoryList[j+1].Y;
          HistoryList[j].ScrPos := HistoryList[j+1].ScrPos;
        end;
        HistoryList[Length(HistoryList)-1].Path := '';
        HistoryList[Length(HistoryList)-1].X := 0;
        HistoryList[Length(HistoryList)-1].Y := 0;
        HistoryList[Length(HistoryList)-1].ScrPos := 0;
        Break
      end;
    end;

    ItReopen.Clear;
    n := 0;
    while HistoryList[n].Path <> '' do begin
      HisItem := TMenuItem.Create(Self);
      HisItem.Caption := HistoryList[n].Path;
      HisItem.Hint := HistoryList[n].Path;
      HisItem.OnClick := ReopenClick;
      ItReopen.Insert(n, HisItem);
      Inc(n);
      if n = MAX_REOPEN then Break;
    end;

    for i := 0 to ItReopen.Count - 1 do begin
      ItReopen.Items[i].Tag := i;
    end;
    //---------------------------------------------------

    raise Exception.CreateFmt('Cannot open file "'+Path+'" file not found.' , [name]);
    Exit;
  end;

  OpenDialog.FileName := '';

  SetLength(DocCloseTimer, Length(DocCloseTimer) + 1);
  DocCloseTimer[Length(DocCloseTimer)-1] := TTimer.Create(Self);
  DocCloseTimer[Length(DocCloseTimer)-1].Enabled := False;
  DocCloseTimer[Length(DocCloseTimer)-1].Interval := 10;
  DocCloseTimer[Length(DocCloseTimer)-1].OnTimer := CloseTimerTab;
  DocCloseTimer[Length(DocCloseTimer)-1].Tag := Length(DocCloseTimer)-1;

  SetLength(Docs, Length(Docs) + 1);
  MainPanel.Perform(WM_SETREDRAW,0,0);
  Docs[Length(Docs)-1] := TPHPEdit.Create(MainPanel);
  Docs[Length(Docs)-1].SetDocState(dsOpen);
  Docs[Length(Docs)-1].SetDocPath(Path);

  Docs[Length(Docs)-1].AssignMainMenu(ItUndoItem, ItRedoItem, ItSave, ItSaveAll,
                                      ItCut, ItCopy, ItDelete,
                                      UndoBtn, RedoBtn, SaveBtn, SaveAllBtn,
                                      CutBtn, CopyBtn,
                                      pmCut, pmCopy, pmDelete,
                                      StatusBar, PrintDialog, ShowSepLine, ShowBlockEdging,  Encoding);

  Docs[Length(Docs)-1].AssignScanList(PHPReservList, PHPFuncList, HtmlTagList,
                                      HtmlAttrList, HtmlMethodsList, JSObjectList, JSMethodsList,
                                      JSPropList, JSReservList, CSSAttrList,
                                      CSSValList);

  Docs[Length(Docs)-1].SetScanStartLine(0);
  TabControl.AddTab(ExtractFileName(Path), Length(Docs)-1);
  Docs[Length(Docs)-1].ID := Length(Docs)-1;

  if ShowDocMap then begin
    DMap := TDocMap.Create(Docs[Length(Docs)-1]);
    DMap.Align := alRight;
    Docs[Length(Docs)-1].DocMap := DMap;
  end;

  if ShowClassView then begin
    Docs[Length(Docs)-1].ClassView := ClassTreeView;
  end
  else begin
    Docs[Length(Docs)-1].ClassView := nil;
  end;

  for i := 0 to Length(Docs) - 1 do begin
    if Docs[i] <> nil then begin
      if i <> Length(Docs) - 1 then
        Docs[i].Visible := False
      else
        Docs[i].Visible := True;
    end;
  end;
  MainPanel.Perform(WM_SETREDRAW,1,0);
  Docs[Length(Docs)-1].ScrollRepaint;
  Docs[Length(Docs)-1].SetCursor(1,0);
  Docs[Length(Docs)-1].SetFocus;

  ChangeScanMode(smYes);

  ItSaveAs.Enabled := True;
  ItClose.Enabled := True;
  ItCloseAll.Enabled := True;
  ItPrint.Enabled := True;
  ItSelectAll.Enabled := True;
  CloseBtn.Enabled := True;
  CloseAllBtn.Enabled := True;
  PrintBtn.Enabled := True;
  ItFind.Enabled := True;
  ItReplace.Enabled := True;
  FindBtn.Enabled := True;
  ReplaceBtn.Enabled := True;
  pmPaste.Enabled := True;
  pmSelectAll.Enabled := True;
  mdOpen := True;

  Ext := ExtractFileExt(Path);
  OpenDialog.FilterIndex := ExtentionFilter(Ext);

  ChangeScanMode(smTXT);

  case OpenDialog.FilterIndex of
    4:ChangeScanMode(smHTML);
    1:ChangeScanMode(smPHP);
    2:ChangeScanMode(smJS);
    3:ChangeScanMode(smJS);
    5:ChangeScanMode(smCSS);
    6:ChangeScanMode(smXML);
    7:ChangeScanMode(smTXT);
  end;

  Docs[Length(Docs)-1].PaintBox.Font.Name := AppFonts[AppFontNo];
  Docs[Length(Docs)-1].PaintBox.Font.Size := FontAttr[AppFontNo,ZoomVal].FontSize;
  Docs[Length(Docs)-1].NumBox.Font.Name := AppFonts[AppFontNo];
  Docs[Length(Docs)-1].NumBox.Font.Size := FontAttr[AppFontNo,ZoomVal].FontSize;
  Docs[Length(Docs)-1].CharWidth := FontAttr[AppFontNo,ZoomVal].CharWidth;
  Docs[Length(Docs)-1].LineHeight := FontAttr[AppFontNo,ZoomVal].LineHeight;
  Docs[Length(Docs)-1].DebugBox.Width := FontAttr[AppFontNo,ZoomVal].LineHeight;
  Docs[Length(Docs)-1].ReCalcScrollRange;
  Docs[Length(Docs)-1].Update;
  Docs[Length(Docs)-1].LoadFromFile(Path);
  TabControl.Update;

  for i := 0 to MAX_HISTORY_REC - 1 do begin
    if HistoryList[i].Path = Path then begin
      if not BeginUserEdit then begin
        Docs[Length(Docs)-1].ScrollTo(HistoryList[i].ScrPos);
        Docs[Length(Docs)-1].SetCursor(HistoryList[i].X, HistoryList[i].Y);
      end;
      Break;
    end;
  end;

  //---------------------------------------------------
  for i := 0 to MAX_HISTORY_REC - 1 do begin
    if HistoryList[i].Path = Path then begin
      for j := i to MAX_HISTORY_REC - 2 do begin
        HistoryList[j].Path := HistoryList[j+1].Path;
        HistoryList[j].X := HistoryList[j+1].X;
        HistoryList[j].Y := HistoryList[j+1].Y;
        HistoryList[j].ScrPos := HistoryList[j+1].ScrPos;
      end;
      HistoryList[Length(HistoryList)-1].Path := '';
      HistoryList[Length(HistoryList)-1].X := 0;
      HistoryList[Length(HistoryList)-1].Y := 0;
      HistoryList[Length(HistoryList)-1].ScrPos := 0;
      Break
    end;
  end;

  ItReopen.Clear;
  n := 0;
  while HistoryList[n].Path <> '' do begin
    HisItem := TMenuItem.Create(Self);
    HisItem.Caption := HistoryList[n].Path;
    HisItem.Hint := HistoryList[n].Path;
    HisItem.OnClick := ReopenClick;
    ItReopen.Insert(n, HisItem);
    Inc(n);
    if n = MAX_REOPEN then Break;
  end;

  for i := 0 to ItReopen.Count - 1 do begin
    ItReopen.Items[i].Tag := i;
  end;
  //---------------------------------------------------
end;

procedure TMainFormPND.MainPanelResize(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Length(Docs) - 1 do begin
    if Docs[i] <> nil then begin
      Docs[i].ScrollRepaint;
    end;
  end;
end;

procedure TMainFormPND.FormCreate(Sender: TObject);
var
  Reg: TRegistry;
  i,j,n: Integer;
  XMLDocument: TXMLDocument;
  Root, Child: IXMLNode;
  AFile: String;
  TopIndex: Integer;
  HisItem: TMenuItem;
  flag: Boolean;
  ShellTreeView: TShellTreeView;
begin
  Application.OnMessage := AppMessage;
  TabControl := TTabControl.Create(TabPanel);
  TabControl.Align := alTop;
  TabControl.OnChoiceTab := ChoiceTab;
  TabControl.OnCloseTab := CloseTab;
  DocCounter := 0;
  HHint := nil;

  DoubleBuffered := True;
  MainPanel.DoubleBuffered := True;
  ItZoomIn.Caption := 'Zoom In'+#9#9#9+'Ctrl+';
  ItZoomOut.Caption := 'Zoom Out'+#9#9+'Ctrl-';

  InitScaner;

  //ReadLicense := -1;
  ReadLicense := 1;
  ShowSepLine := True;
  ShowDocMap := True;
  ShowClassView := True;
  ShowFileExplorer := True;
  ShowDebugger := False;
  ShowBlockEdging := True;
  AppFontNo := 1; //Consolas
  ZoomVal := 0;

  LeftPanel.Width := 200;
  HELP_PREF := 'en';

  Reg := TRegistry.Create;

  try
    try
      Reg.RootKey :=  HKEY_CURRENT_USER;
      Reg.OpenKey('Software\PHPNotepad',true);
      Left := Reg.ReadInteger('Left');
      Top := Reg.ReadInteger('Top');
      Width := Reg.ReadInteger('Width');
      Height := Reg.ReadInteger('Height');
      ShowSepLine := Reg.ReadBool('SepLine');
      ShowDocMap := Reg.ReadBool('DocMap');
      ShowClassView := Reg.ReadBool('ClassView');
      ShowFileExplorer := Reg.ReadBool('FileExplorer');
      ShowDebugger := Reg.ReadBool('Debugger');
      ShowBlockEdging := Reg.ReadBool('BlockEdging');
      ZoomVal := Reg.ReadInteger('ZoomVal');
      AppFontNo := Reg.ReadInteger('AppFontNo');
      BoxW := Reg.ReadInteger('BoxW');
      BoxH := Reg.ReadInteger('BoxH');
      LeftPanel.Width := Reg.ReadInteger('LPanel');
      HELP_PREF := Reg.ReadString('HELP_PREF');
      DebugPanel.Height := Reg.ReadInteger('BebHeight');
      BreakAtFirst := Reg.ReadBool('BreakAtFirst');

      if LeftPanel.Width > 500 then LeftPanel.Width := 500;
      if LeftPanel.Width < 150 then LeftPanel.Width := 200;

      if DebugPanel.Height < 150 then DebugPanel.Height := 150;
      if DebugPanel.Height > Self.Height div 2 then DebugPanel.Height := Self.Height div 2;
      DebugPanel.Top := Self.ClientHeight - StatusBar.Height - DebugPanel.Height;
      StatusBar.Top := DebugPanel.Top + DebugPanel.Height;

      if HELP_PREF = 'en' then begin
        ItLangEn.Checked := True;
        ItLangRu.Checked := False;
      end;

      if HELP_PREF = 'ru' then begin
        ItLangEn.Checked := False;
        ItLangRu.Checked := True;
      end;

      if ShowSepLine then ItPageSeparator.Checked := True
        else ItPageSeparator.Checked := False;

      if ShowDocMap then ItDocumentMap.Checked := True
        else ItDocumentMap.Checked := False;

      if ShowClassView then begin
        ItClassView.Checked := True;
        ClassViewSheet.TabVisible := True;
      end
      else begin
        ItClassView.Checked := False;
        ClassViewSheet.TabVisible := False;
      end;

      if ShowFileExplorer then begin
        ItFileExplorer.Checked := True;
        FileExplorerSheet.TabVisible := True;
      end
      else begin
        ItFileExplorer.Checked := False;
        FileExplorerSheet.TabVisible := False;
      end;

      if ShowBlockEdging then begin
        ItBlockEdging.Checked := True;
      end
      else begin
        ItBlockEdging.Checked := False;
      end;

      if ShowDebugger then begin
        ItDebugger.Checked := True;
        DebugPanel.Visible := True;
        BottomSplitter.Visible := True;
        DebBtn.ImageIndex := 18;
      end
      else begin
        ItDebugger.Checked := False;
        DebugPanel.Visible := False;
        BottomSplitter.Visible := False;
        DebBtn.ImageIndex := 17;
      end;

      if Reg.ReadInteger('Maximized') <> 0 then WindowState := wsMaximized
        else WindowState := wsNormal;

    except
    end;

  finally
    Reg.free;
  end;

  case Screen.PixelsPerInch of
    96 : SCREENSCALE := 1.00;
    120: SCREENSCALE := 1.25;
    144: SCREENSCALE := 1.50;
  end;

  AppFonts[0] := 'Courier New';
  AppFonts[1] := 'Consolas';

  if (SCREENSCALE = 1.25) then begin
    FontAttr[0,-2].FontSize := 6;             FontAttr[1,-2].FontSize := 6;
    FontAttr[0,-2].CharWidth := 6;            FontAttr[1,-2].CharWidth := 5;
    FontAttr[0,-2].LineHeight := 10;          FontAttr[1,-2].LineHeight := 10;
    FontAttr[0,-1].FontSize := 8;             FontAttr[1,-1].FontSize := 8;
    FontAttr[0,-1].CharWidth := 8;            FontAttr[1,-1].CharWidth := 7;
    FontAttr[0,-1].LineHeight := 13;          FontAttr[1,-1].LineHeight := 13;
    FontAttr[0,0].FontSize := 10;             FontAttr[1,0].FontSize := 10;
    FontAttr[0,0].CharWidth := 10;            FontAttr[1,0].CharWidth := 9;
    FontAttr[0,0].LineHeight := 17;           FontAttr[1,0].LineHeight := 17;
    FontAttr[0,1].FontSize := 12;             FontAttr[1,1].FontSize := 12;
    FontAttr[0,1].CharWidth := 12;            FontAttr[1,1].CharWidth := 11;
    FontAttr[0,1].LineHeight := 20;           FontAttr[1,1].LineHeight := 20;
    FontAttr[0,2].FontSize := 15;             FontAttr[1,2].FontSize := 15;
    FontAttr[0,2].CharWidth := 15;            FontAttr[1,2].CharWidth := 14;
    FontAttr[0,2].LineHeight := 25;           FontAttr[1,2].LineHeight := 25;
    FontAttr[0,3].FontSize := 18;             FontAttr[1,3].FontSize := 18;
    FontAttr[0,3].CharWidth := 18;            FontAttr[1,3].CharWidth := 16;
    FontAttr[0,3].LineHeight := 30;           FontAttr[1,3].LineHeight := 30;
  end
  else if (SCREENSCALE = 1.50) then begin
    FontAttr[0,-2].FontSize := 6;             FontAttr[1,-2].FontSize := 6;
    FontAttr[0,-2].CharWidth := 7;            FontAttr[1,-2].CharWidth := 7;
    FontAttr[0,-2].LineHeight := 15;          FontAttr[1,-2].LineHeight := 15;
    FontAttr[0,-1].FontSize := 8;             FontAttr[1,-1].FontSize := 8;
    FontAttr[0,-1].CharWidth := 10;            FontAttr[1,-1].CharWidth := 9;
    FontAttr[0,-1].LineHeight := 18;          FontAttr[1,-1].LineHeight := 18;
    FontAttr[0,0].FontSize := 10;             FontAttr[1,0].FontSize := 10;
    FontAttr[0,0].CharWidth := 12;            FontAttr[1,0].CharWidth := 11;
    FontAttr[0,0].LineHeight := 20;           FontAttr[1,0].LineHeight := 20;
    FontAttr[0,1].FontSize := 12;             FontAttr[1,1].FontSize := 12;
    FontAttr[0,1].CharWidth := 14;            FontAttr[1,1].CharWidth := 13;
    FontAttr[0,1].LineHeight := 24;           FontAttr[1,1].LineHeight := 24;
    FontAttr[0,2].FontSize := 15;             FontAttr[1,2].FontSize := 15;
    FontAttr[0,2].CharWidth := 18;            FontAttr[1,2].CharWidth := 16;
    FontAttr[0,2].LineHeight := 30;           FontAttr[1,2].LineHeight := 30;
    FontAttr[0,3].FontSize := 18;             FontAttr[1,3].FontSize := 18;
    FontAttr[0,3].CharWidth := 22;            FontAttr[1,3].CharWidth := 20;
    FontAttr[0,3].LineHeight := 35;           FontAttr[1,3].LineHeight := 35;
  end else begin
    FontAttr[0,-2].FontSize := 6;             FontAttr[1,-2].FontSize := 6;
    FontAttr[0,-2].CharWidth := 5;            FontAttr[1,-2].CharWidth := 4;
    FontAttr[0,-2].LineHeight := 10;          FontAttr[1,-2].LineHeight := 10;
    FontAttr[0,-1].FontSize := 8;             FontAttr[1,-1].FontSize := 8;
    FontAttr[0,-1].CharWidth := 7;            FontAttr[1,-1].CharWidth := 6;
    FontAttr[0,-1].LineHeight := 13;          FontAttr[1,-1].LineHeight := 13;
    FontAttr[0,0].FontSize := 10;             FontAttr[1,0].FontSize := 10;
    FontAttr[0,0].CharWidth := 8;             FontAttr[1,0].CharWidth := 7;
    FontAttr[0,0].LineHeight := 17;           FontAttr[1,0].LineHeight := 17;
    FontAttr[0,1].FontSize := 12;             FontAttr[1,1].FontSize := 12;
    FontAttr[0,1].CharWidth := 10;            FontAttr[1,1].CharWidth := 9;
    FontAttr[0,1].LineHeight := 20;           FontAttr[1,1].LineHeight := 20;
    FontAttr[0,2].FontSize := 15;             FontAttr[1,2].FontSize := 15;
    FontAttr[0,2].CharWidth := 12;            FontAttr[1,2].CharWidth := 11;
    FontAttr[0,2].LineHeight := 25;           FontAttr[1,2].LineHeight := 25;
    FontAttr[0,3].FontSize := 18;             FontAttr[1,3].FontSize := 18;
    FontAttr[0,3].CharWidth := 14;            FontAttr[1,3].CharWidth := 13;
    FontAttr[0,3].LineHeight := 30;           FontAttr[1,3].LineHeight := 30;

    ToolPanel.Height := 32;
    ToolBar.Height := 32;
    ToolBar.ButtonHeight := 28;
    ToolBar.ButtonWidth := 28;
  end;

  if AppFontNo > FONTCOUNT - 1 then AppFontNo := 0;

  for i := 0 to FONTCOUNT - 1 do begin
    flag := False;
    for j := 0 to Screen.Fonts.Count - 1 do begin
      if AppFonts[i] = Screen.Fonts[j] then begin
        flag := True;
      end;
    end;
    if not flag then begin
      itFonts.Items[i].Enabled := False;
      itFonts.Items[i].Caption := itFonts.Items[i].Caption + ' (not setup)';
    end;
  end;

  if itFonts.Items[AppFontNo].Enabled = False then begin
    itFonts.Items[0].Checked := True;
    AppFontNo := 0;
  end else begin
    itFonts.Items[AppFontNo].Checked := True;
  end;

  try
    AFile := ExtractFilePath(Application.ExeName)+'\AppData\history.xml';
    XMLDocument := TXMLDocument.Create(Application);
    XMLDocument.LoadFromFile(AFile);
    XMLDocument.Active := True;

    Root := XMLDocument.DocumentElement;
    TopIndex := 0;
    for i := 0 to Root.ChildNodes.Count - 1 do begin
      if Root.ChildNodes[i].NodeName = 'File' then begin
        Child := Root.ChildNodes[i];
        for j := 0 to Child.ChildNodes.Count - 1 do begin
          if Child.ChildNodes[j].NodeName = 'Path' then begin
            HistoryList[TopIndex].Path := Child.ChildNodes[j].Text;
          end;
          if Child.ChildNodes[j].NodeName = 'X' then begin
            HistoryList[TopIndex].X := StrToInt(Child.ChildNodes[j].Text);
          end;
          if Child.ChildNodes[j].NodeName = 'Y' then begin
            HistoryList[TopIndex].Y := StrToInt(Child.ChildNodes[j].Text);
          end;
          if Child.ChildNodes[j].NodeName = 'Pos' then begin
            HistoryList[TopIndex].ScrPos := StrToInt(Child.ChildNodes[j].Text);
          end;
        end;
        if TopIndex < MAX_HISTORY_REC - 2 then Inc(TopIndex);
      end;
    end;

    n := 0;
    while HistoryList[n].Path <> '' do begin
      HisItem := TMenuItem.Create(Self);
      HisItem.Caption := HistoryList[n].Path;
      HisItem.Hint := HistoryList[n].Path;
      HisItem.OnClick := ReopenClick;
      ItReopen.Insert(n, HisItem);
      Inc(n);
      if n = MAX_REOPEN then Break;
    end;

    for i := 0 to ItReopen.Count - 1 do begin
      ItReopen.Items[i].Tag := i;
    end;

  except
    Exit;
  end;

  if ReadLicense <> 1 then begin
    for i := 0 to MainMenu.Items.Count - 1 do begin
      MainMenu.Items[i].Enabled := False;
    end;

    ToolPanel.Enabled := False;
    ModeBar.Enabled := False;
    TabPanel.Enabled := False;
    LicensePanel.Visible := True;
    PostMessage(Handle, WM_USER+2, 0, 0);
  end else begin
    for i := 0 to MainMenu.Items.Count - 1 do begin
      MainMenu.Items[i].Enabled := True;
    end;

    ToolPanel.Enabled := True;
    ModeBar.Enabled := True;
    TabPanel.Enabled := True;
    LicensePanel.Visible := False;
  end;

  if ParamCount > 0 then begin
    PostMessage(Handle, WM_USER+3, 0, 0);
  end;

  ClassTreeView.DoubleBuffered := True;
  ClassViewSheet.DoubleBuffered := True;

  ShellTreeView := TShellTreeView.Create(FileExplorerSheet);
  ShellTreeView.Parent := FileExplorerSheet;
  ShellTreeView.Align := alClient;
  ShellTreeView.Root := 'rfMyComputer';
  ShellTreeView.ObjectTypes := [otFolders, otNonFolders];
  ShellTreeView.OnDblClick := ShellTreeDblClick;

  if (ShowClassView or ShowFileExplorer) then begin
    LeftPanel.Visible := True;
    LeftSplitter.Enabled := True;
  end
  else begin
    LeftPanel.Visible := False;
    LeftSplitter.Enabled := False;
  end;

  ClassTreeView.FullExpand;

  {debug}
  DBGpServer := TDBGpServer.Create(nil);
  DBGpServer.InitInterface(nil, GlobalTreeView, LocalTreeView,
                           nil);
  DBGpServer.SetButtons(ListenBtn, RunNextBtn, RunToCursorBtn, TraceIntoBtn, StepOverBtn, StepOutBtn);
  {end debug}

  TabControl.ReScale;
end;

procedure TMainFormPND.FormResize(Sender: TObject);
begin
  PostMessage(Handle, WM_USER+6, 0, 0);
end;

procedure TMainFormPND.ShellTreeDblClick(Sender: TObject);
var
  i: Integer;
  flag: Boolean;
begin
  if TShellTreeView(Sender).Selected.Index = 0 then Exit;

  if not DirectoryExists(TShellTreeView(Sender).Path) then begin
    flag := False;

    for i := 0 to Length(Docs) - 1 do begin
      if Docs[i] <> nil then begin
        if Docs[i].GetDocPath = TShellTreeView(Sender).Path then begin
          flag := True;
          TabControl.SelectTab(Docs[i].ID);
        end;
      end;
    end;
    if not flag then LoadDocFromFile(TShellTreeView(Sender).Path);

    TabControl.Refresh;
  end;
end;

procedure TMainFormPND.FormActivate(Sender: TObject);
begin
  WordBoxForm.Visible := False;
  WordBoxForm.Width := BoxW;
  WordBoxForm.Height := BoxH;

  DBGpConfigForm.CheckBoxBreakAtFirst.Checked := BreakAtFirst;
  DBGpServer.DebFirstLine := BreakAtFirst;

  if BoxW < 200 then WordBoxForm.Width := 200;
  if BoxW > 500 then WordBoxForm.Width := 500;
  if BoxH < 100 then WordBoxForm.Height := 100;
  if BoxH > 300 then WordBoxForm.Height := 300;

  //MainFormPND := Self;
end;

procedure TMainFormPND.FormAfterMonitorDpiChanged(Sender: TObject; OldDPI,
  NewDPI: Integer);
var
  i: Integer;
begin
  case Screen.PixelsPerInch of
    96 : SCREENSCALE := 1.00;
    120: SCREENSCALE := 1.25;
    146: SCREENSCALE := 1.50;
  end;

  for i := 0 to Length(Docs) - 1 do begin
    if Docs[i] <> nil then begin
      Docs[i].ReScale;
      TabControl.ReScale;
    end;
  end;

  if (SCREENSCALE = 1.00) then begin
    ToolPanel.Height := 32;
    ToolBar.Height := 32;
    ToolBar.ButtonHeight := 28;
    ToolBar.ButtonWidth := 28;
  end
  else begin
    ToolPanel.Height := 19;
    ToolBar.Height := 19;
    ToolBar.ButtonHeight := 16;
    ToolBar.ButtonWidth := 16;
  end;
end;

procedure TMainFormPND.ItOpenClick(Sender: TObject);
var
  i: Integer;
  flag: Boolean;
begin
  flag := False;
  if OpenDialog.Execute then begin
    for i := 0 to Length(Docs) - 1 do begin
      if Docs[i] <> nil then begin
        if Docs[i].GetDocPath = OpenDialog.FileName then begin
          flag := True;
          TabControl.SelectTab(Docs[i].ID);
        end;
      end;
    end;
    if not flag then LoadDocFromFile(OpenDialog.FileName);
  end;
  TabControl.Refresh;
end;

procedure TMainFormPND.ItLangEnClick(Sender: TObject);
begin
  HELP_PREF := 'en';
  ItLangEn.Checked := True;
  ItLangRu.Checked := False;
end;

procedure TMainFormPND.ItLangRuClick(Sender: TObject);
begin
  HELP_PREF := 'ru';
  ItLangRu.Checked := True;
  ItLangEn.Checked := False;
end;

procedure TMainFormPND.ItListenClick(Sender: TObject);
begin
  TMenuItem(Sender).Checked := True;

  ShowDebugger := True;
  DebugPanel.Visible := True;
  BottomSplitter.Visible := True;
  DebBtn.ImageIndex := 18;
  ItDebugger.Checked := True;

  ListenBtn.Click;
end;

procedure TMainFormPND.ItNewClick(Sender: TObject);
var
  i,j, NewInd: Integer;
  NewName, No, S: String;
  dgflag: Boolean;
  ExistNoArray: array of Integer;
  DMap: TDocMap;
begin
  SetLength(DocCloseTimer, Length(DocCloseTimer) + 1);
  DocCloseTimer[Length(DocCloseTimer)-1] := TTimer.Create(Self);
  DocCloseTimer[Length(DocCloseTimer)-1].Enabled := False;
  DocCloseTimer[Length(DocCloseTimer)-1].Interval := 10;
  DocCloseTimer[Length(DocCloseTimer)-1].OnTimer := CloseTimerTab;
  DocCloseTimer[Length(DocCloseTimer)-1].Tag := Length(DocCloseTimer)-1;

  MainPanel.Perform(WM_SETREDRAW,0,0);
  SetLength(Docs, Length(Docs) + 1);
  Docs[Length(Docs)-1] := TPHPEdit.Create(MainPanel);
  Docs[Length(Docs)-1].PaintBox.Font.Name := AppFonts[AppFontNo];
  Docs[Length(Docs)-1].PaintBox.Font.Size := FontAttr[AppFontNo,ZoomVal].FontSize;
  Docs[Length(Docs)-1].NumBox.Font.Name := AppFonts[AppFontNo];
  Docs[Length(Docs)-1].NumBox.Font.Size := FontAttr[AppFontNo,ZoomVal].FontSize;
  Docs[Length(Docs)-1].CharWidth := FontAttr[AppFontNo,ZoomVal].CharWidth;
  Docs[Length(Docs)-1].LineHeight := FontAttr[AppFontNo,ZoomVal].LineHeight;
  Docs[Length(Docs)-1].DebugBox.Width := FontAttr[AppFontNo,ZoomVal].LineHeight;
  Docs[Length(Docs)-1].ReCalcScrollRange;
  Docs[Length(Docs)-1].Update;

  Docs[Length(Docs)-1].AssignMainMenu(ItUndoItem, ItRedoItem, ItSave, ItSaveAll,
                                      ItCut, ItCopy, ItDelete,
                                      UndoBtn, RedoBtn, SaveBtn, SaveAllBtn,
                                      CutBtn, CopyBtn,
                                      pmCut, pmCopy, pmDelete,
                                      StatusBar, PrintDialog, ShowSepLine, ShowBlockEdging, Encoding);

  Docs[Length(Docs)-1].AssignScanList(PHPReservList, PHPFuncList, HtmlTagList,
                                      HtmlAttrList, HtmlMethodsList, JSObjectList, JSMethodsList,
                                      JSPropList, JSReservList, CSSAttrList,
                                      CSSValList);

  Docs[Length(Docs)-1].SetScanStartLine(0);
  Docs[Length(Docs)-1].GoScan;

  if ShowDocMap then begin
    DMap := TDocMap.Create(Docs[Length(Docs)-1]);
    DMap.Align := alRight;
    Docs[Length(Docs)-1].DocMap := DMap;
  end;

  if ShowClassView then begin
    Docs[Length(Docs)-1].ClassView := ClassTreeView;
  end
  else begin
    Docs[Length(Docs)-1].ClassView := nil;
  end;

  //New Tab Index
  SetLength(ExistNoArray, 0);
  for i := 0 to TabControl.GetTabCount - 1 do begin
    S := TabControl.Title(i);
    if (Copy(S,1,9) = 'untitled ') then begin
      No := Copy(S,10,Length(S));
      dgflag := False;
      if (Length(No) > 0) then begin
        dgflag := True;
        if not(No[1] in ['1'..'9']) then begin
          dgflag := False;
        end else begin
          for j := 2 to Length(No) do begin
            if not(No[j] in ['0'..'9']) then begin
              dgflag := False;
            end;
          end;
        end;
        if dgflag then begin
          SetLength(ExistNoArray, Length(ExistNoArray) + 1);
          try
            ExistNoArray[Length(ExistNoArray)-1] := StrToInt(No);
          except
            ExistNoArray[Length(ExistNoArray)-1] := -1;
          end;
        end;
      end;
    end;
  end;

  NewInd := 1;
  while True do begin
    dgflag := True;
    for i := 0 to Length(ExistNoArray) - 1 do begin
      if NewInd = ExistNoArray[i] then begin
        dgflag := False;
        Inc(NewInd);
      end;
    end;  
    if dgflag then Break;
  end;

  Docs[Length(Docs)-1].SetDocPath('untitled '+ IntToStr(NewInd));
  Docs[Length(Docs)-1].SetDocState(dsNew);
  TabControl.AddTab('untitled '+ IntToStr(NewInd), Length(Docs)-1);
  Docs[Length(Docs)-1].ID := Length(Docs)-1;
  //End New Tab Index

  for i := 0 to Length(Docs) - 1 do begin
    if Docs[i] <> nil then begin
      if i <> (Length(Docs)-1) then
        Docs[i].Visible := False
      else
        Docs[i].Visible := True;
    end;
  end;
  MainPanel.Perform(WM_SETREDRAW,1,0);
  TabControl.Update;

  ItSaveAs.Enabled := True;
  ItClose.Enabled := True;
  ItCloseAll.Enabled := True;
  ItPrint.Enabled := True;
  ItSelectAll.Enabled := True;
  CloseBtn.Enabled := True;
  CloseAllBtn.Enabled := True;
  PrintBtn.Enabled := True;
  ItFind.Enabled := True;
  ItReplace.Enabled := True;
  FindBtn.Enabled := True;
  ReplaceBtn.Enabled := True;
  pmPaste.Enabled := True;
  pmSelectAll.Enabled := True;
  mdOpen := True;

  ChangeScanMode(smYes);
  ChangeScanMode(smPHP);

  Docs[Length(Docs)-1].SetFocus;
end;

procedure TMainFormPND.ChoiceTab(Sender: TObject; var TabID: Integer);
var
  i: Integer;
  DebID: Integer;
begin
  Caption := 'PHPNotepad - ' + Docs[TabID].GetDocPath;

  MainPanel.Perform(WM_SETREDRAW,0,0);
  for i := 0 to Length(Docs) - 1 do begin
    if Docs[i] <> nil then begin
      if i <> TabID then begin
        Docs[i].Visible := False;
        Docs[i].SuspendTree := True;
      end
      else begin
        Docs[i].Visible := True;
        Docs[i].SuspendTree := False;
      end;
    end;
  end;
  MainPanel.Perform(WM_SETREDRAW,1,0);

  Docs[TabID].Repaint;
  Docs[TabID].ScrollRepaint;
  Docs[TabID].SetFocus;
  MainPanel.Repaint;

  AssignActivDocWithMenu(Docs[TabID]);
  ActivDocID := TabID;

  SearchForm.PHPEditor := Docs[ActivDocID];

  if Docs[TabID].CurrentScanLineNo < Docs[TabID].GetLineCount then begin
    Docs[TabID].GoScan;
  end
  else begin
    if Docs[TabID].ClassView <> nil then begin
      Docs[TabID].TreeTimer.Enabled := True;
      {Docs[TabID].ResetTreeScaner;
      Docs[TabID].ScanTree;}
    end;
  end;

  DebID := Docs[TabID].DebugConnectionID;

  if (DebID <> -1) then begin
    DBGpServer.ActivDoc := DebID;
    DBGpServer.UpdateTabs;
    DebugInfoPanel.Caption :=  Docs[TabID].DebugStatus;
  end
  else begin
    GlobalTreeView.Items.Clear;
    LocalTreeView.Items.Clear;
    DebugInfoPanel.Caption := '';
  end;

  DBGpServer.UpdateWatches;
  TabControl.Repaint;
end;

procedure TMainFormPND.CloseTimerTab(Sender: TObject);
begin
  if not Docs[TTimer(Sender).Tag].InScan then begin
    FreeAndNil(Docs[TTimer(Sender).Tag]);
    FreeAndNil(DocCloseTimer[TTimer(Sender).Tag]);
  end;

  if TabControl.GetTabCount = 0 then
    ChangeScanMode(smNo);
end;

procedure TMainFormPND.CloseTab(Sender: TObject; var TabID: Integer);
var
  i, BtnSelID: Integer;
  flag: Boolean;
  NewFileName, Path: String;
  CloseItem: TMenuItem;
begin
  if Docs[TabID].Modified then begin
    ShortHelpForm.Close;
    SearchForm.Close;
    AboutBox.Close;
    StyleConfiguratorForm.Close;

    BtnSelID := MessageBox(Handle, PChar('Save file "'+Docs[TabID].GetDocPath+'" ?'), PChar('Save'), MB_YESNOCANCEL+MB_ICONQUESTION);

    if BtnSelID = mrCancel then begin
      TabId := -1;
      Exit;
    end;

    if BtnSelID = mrYes then begin
      if Docs[TabID].GetDocState = dsOpen then begin
        Docs[TabID].SaveToFile(Docs[TabID].GetDocPath);
      end;
      if Docs[TabID].GetDocState = dsNew then begin
        SaveDialog.FilterIndex := Docs[ActivDocID].FilterIndex;
        NewFileName := Docs[ActivDocID].GetDocPath;

        case SaveDialog.FilterIndex of
          1: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.php';
          2: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.js';
          3: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.json';
          4: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.html';
          5: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.css';
          6: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.xml';
          7: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.txt';
          8: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '';
        end;
        SaveDialog.FileName := Path + NewFileName;

        if SaveDialog.Execute then begin
          ItSave.Enabled := False;
          SaveBtn.Enabled := False;

          Docs[ActivDocID].SaveToFile(SaveDialog.FileName);
          Docs[ActivDocID].SetDocPath(SaveDialog.FileName);
          Docs[ActivDocID].SetDocState(dsOpen);
          Docs[ActivDocID].CommitModify;
          TabControl.RenameTab(ActivDocID, ExtractFileName(NewFileName));
          TabControl.Update;
          Caption := 'PHPNotepad - ' + SaveDialog.FileName;
        end else begin
          TabId := -1;
          Exit;
        end;
      end;
    end;
  end;

  if TabControl.GetTabCount = 1 then begin
    ItUndoItem.Enabled := False;
    UndoBtn.Enabled := False;
    ItRedoItem.Enabled := False;
    RedoBtn.Enabled := False;
    ItSave.Enabled := False;
    SaveBtn.Enabled := False;
    ItSaveAll.Enabled := False;
    SaveAllBtn.Enabled := False;
    ItSaveAs.Enabled := False;
    ItClose.Enabled := False;
    ItCloseAll.Enabled := False;
    ItPrint.Enabled := False;
    CloseBtn.Enabled := False;
    CloseAllBtn.Enabled := False;
    PrintBtn.Enabled := False;
    ItCut.Enabled := False;
    ItCopy.Enabled := False;
    CutBtn.Enabled := False;
    CopyBtn.Enabled := False;
    ItPaste.Enabled := False;
    PasteBtn.Enabled := False;
    ItDelete.Enabled := False;
    ItFind.Enabled := False;
    ItReplace.Enabled := False;
    FindBtn.Enabled := False;
    ReplaceBtn.Enabled := False;
    ItSelectAll.Enabled := False;
    pmPaste.Enabled := False;
    pmSelectAll.Enabled := False;
    pmCut.Enabled := False;
    pmCopy.Enabled := False;
    pmDelete.Enabled := False;
    mdOpen := False;

    Caption := 'PHPNotepad';

    ClassTreeView.Items.BeginUpdate;

    for i := ClassTreeView.Items.Count - 1 downto 0 do begin
      if (ClassTreeView.Items[i].Level = 1) then begin
        ClassTreeView.Items[i].DeleteChildren;
      end;
    end;

    ClassTreeView.Items.EndUpdate;

    StatusBar.Panels[0].Text := '';
    StatusBar.Panels[1].Text := '';
    StatusBar.Panels[2].Text := '';

    SearchForm.Visible := False;
    GlobalTreeView.Items.Clear;
    LocalTreeView.Items.Clear;
    StackView.Items.Clear;
    BreakPointsView.Items.Clear;
    WatchesView.Items.Clear;
    DebugInfoPanel.Caption := '';
  end;

  flag := False;
  for i := 0 to Length(Docs) - 1 do begin
    if (Docs[i] <> nil) and (Docs[i].Modified) and (i <> TabID) then flag := True;
  end;

  if not flag then begin
    ItSaveAll.Enabled := False;
    SaveAllBtn.Enabled := False;
  end;

  if Docs[TabID].GetDocState <> dsNew then ReopenItemInsert(Docs[TabID]);

  if (Docs[TabID].DebugConnectionID <> -1) and (Docs[TabID].IsMainDebugStack) then begin
    DBGpServer.ActivDoc := -1;
    DBGpServer.CloseConnection(Docs[TabID].DebugConnectionID);
  end;

  Docs[TabID].Terminate;
  DocCloseTimer[TabID].Enabled := True;
end;

procedure TMainFormPND.ReopenClick(Sender: Tobject);
var
  i,n: Integer;
  HisItem: TMenuItem;
begin
  ReopenPath := TMenuItem(Sender).Hint;
  PostMessage(Handle, WM_USER+1, 0, 0);
end;

procedure TMainFormPND.AssignActivDocWithMenu(ActivObj: TPHPEdit);
var
  EncStr: String;
begin
  if ActivObj.GetUndoCount = 0 then begin
    ItUndoItem.Enabled := False;
    UndoBtn.Enabled := False;
  end else begin
    ItUndoItem.Enabled := True;
    UndoBtn.Enabled := True;
  end;

  if ActivObj.GetRedoCount = 0 then begin
    ItRedoItem.Enabled := False;
    RedoBtn.Enabled := False;
  end else begin
    ItRedoItem.Enabled := True;
    RedoBtn.Enabled := True;
  end;

  if ActivObj.Modified then begin
    ItSave.Enabled := True;
    ItSaveAll.Enabled := True;
    SaveBtn.Enabled := True;
    SaveAllBtn.Enabled := True;
  end else begin
    ItSave.Enabled := False;
    SaveBtn.Enabled := False;
  end;

  if ActivObj.TextSelected then begin
    ItCut.Enabled := True;
    ItCopy.Enabled := True;
    CutBtn.Enabled := True;
    CopyBtn.Enabled := True;
    ItDelete.Enabled := True;
  end else begin
    ItCut.Enabled := False;
    ItCopy.Enabled := False;
    CutBtn.Enabled := False;
    CopyBtn.Enabled := False;
    ItDelete.Enabled := False;
  end;

  ItPaste.Enabled := True;
  PasteBtn.Enabled := True;

  case ActivObj.ScanMode of
    smPHP: PHPBTN.Down := True;
    smHTML: HTMLBTN.Down := True;
    smJS: JSBTN.Down := True;
    smCSS: CSSBTN.Down := True;
    smXML: XMLBTN.Down := True;
    smTXT: TXTBTN.Down := True;
  end;

  StatusBar.Panels[0].Text := ' Ln:' + IntToStr(ActivObj.CaretPos.Y + 1);
  StatusBar.Panels[1].Text := ' Col:' + IntToStr(ActivObj.CaretPos.X);
  EncStr := ActivObj.StringList.EncodingStr;
  StatusBar.Panels[2].Text := EncStr;

  if EncStr = 'ANSI' then ItANSI.Checked := True;
  if EncStr = 'UTF-8' then ItUTF8WithOutBOM.Checked := True;
  if EncStr = 'UTF-8 BOM' then ItUTF8.Checked := True;
  if EncStr = 'UCS-2 LE' then ItUCS2LittleEndian.Checked := True;
  if EncStr = 'UCS-2 BE' then ItUCSBigEndian.Checked := True;
end;

procedure TMainFormPND.pmCopyClick(Sender: TObject);
begin
  ItCopy.Click;
end;

procedure TMainFormPND.pmPasteClick(Sender: TObject);
begin
  ItPaste.Click;
end;

procedure TMainFormPND.pmDeleteClick(Sender: TObject);
begin
  ItDelete.Click;
end;

procedure TMainFormPND.pmSelectAllClick(Sender: TObject);
begin
  ItSelectAll.Click;
end;

procedure TMainFormPND.pmCutClick(Sender: TObject);
begin
  ItCut.Click;
end;

procedure TMainFormPND.UndoBtnClick(Sender: TObject);
begin
  ItUndoItem.Click;
end;

procedure TMainFormPND.NewBtnClick(Sender: TObject);
begin
  ItNew.Click;
end;

procedure TMainFormPND.SaveBtnClick(Sender: TObject);
begin
  ItSave.Click;
end;

procedure TMainFormPND.RedoBtnClick(Sender: TObject);
begin
  ItRedoItem.Click;
end;

procedure TMainFormPND.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i: Integer;
  Reg: TRegistry;
  HistList: TStringList;
  Encoding: TEncoding;
begin
  if HHint <> nil then FreeAndNil(HHint);
  AboutBox.Close;
  SearchForm.Close;
  ShortHelpForm.Close;

  CanClose := False;
  ItCloseAll.Click;

  Reg := TRegistry.Create;
  try
    try
      Reg.RootKey :=  HKEY_CURRENT_USER;
      Reg.OpenKey('Software\PHPNotepad',true);
      Reg.WriteInteger('Left', Left);
      Reg.WriteInteger('Top', Top);
      Reg.WriteInteger('Width', Width);
      Reg.WriteInteger('Height', Height);
      Reg.WriteInteger('ZoomVal', ZoomVal);
      Reg.WriteInteger('AppFontNo', AppFontNo);
      Reg.WriteBool('SepLine', ShowSepLine);
      Reg.WriteBool('DocMap', ShowDocMap);
      Reg.WriteBool('ClassView', ShowClassView);
      Reg.WriteBool('FileExplorer', ShowFileExplorer);
      Reg.WriteBool('Debugger', ShowDebugger);
      Reg.WriteBool('BlockEdging', ShowBlockEdging);
      Reg.WriteInteger('BoxW', BoxW);
      Reg.WriteInteger('BoxH', BoxH);
      Reg.WriteInteger('LPanel', LeftPanel.Width);
      Reg.WriteString('HELP_PREF', HELP_PREF);
      Reg.WriteInteger('BebHeight', DebugPanel.Height);
      Reg.WriteBool('BreakAtFirst', BreakAtFirst);

      if WindowState = wsMaximized then Reg.WriteInteger('Maximized', 1);
      if WindowState = wsNormal then Reg.WriteInteger('Maximized', 0);
    except
    end;
  finally
    Reg.free;
  end;

  try
    Encoding := TUTF8Encoding.Create;
    HistList := TStringList.Create;
    HistList.Add('<?xml version="1.0" encoding="UTF-8" ?>');
    HistList.Add('<PHPNotepad>');
    for i := 0 to MAX_HISTORY_REC - 1 do begin
      HistList.Add('  <File>');
      HistList.Add('    <Path>'+HistoryList[i].Path+'</Path>');
      HistList.Add('    <X>'+IntToStr(HistoryList[i].X)+'</X>');
      HistList.Add('    <Y>'+IntToStr(HistoryList[i].Y)+'</Y>');
      HistList.Add('    <Pos>'+IntToStr(HistoryList[i].ScrPos)+'</Pos>');
      HistList.Add('  </File>');
    end;
    HistList.Add('</PHPNotepad>');
    HistList.WriteBOM := False;
    HistList.SaveToFile(ExtractFilePath(Application.ExeName)+'\AppData\history.xml', Encoding);
  except
  end;

  if TabControl.GetTabCount = 0 then begin
    for i := 0 to Length(Docs) - 1 do begin
      if Docs[i] <> nil then begin
        Docs[i].Terminate;
        DocCloseTimer[i].Enabled := True;
      end;
    end;

    CloseQueryTimer.Enabled := True;
  end;
end;

procedure TMainFormPND.CloseQueryTimerTimer(Sender: TObject);
var
  i: Integer;
  flag: Boolean;
begin
  flag := False;
  for i := 0 to Length(Docs) - 1 do begin
    if Docs[i] <> nil then flag := true;
  end;      

  if not flag then begin
    Application.Terminate;
  end;
end;


procedure TMainFormPND.OpenBtnClick(Sender: TObject);
begin
  ItOpen.Click;
end;

procedure TMainFormPND.ItDebOptionsClick(Sender: TObject);
begin
  DebOptionBtn.Click;
end;

procedure TMainFormPND.ItCopyClick(Sender: TObject);
begin
  Docs[ActivDocID].CopyToClipBoard;
end;

procedure TMainFormPND.itCourierNewClick(Sender: TObject);
var
  i: Integer;
begin
  TMenuItem(Sender).Checked := True;
  AppFontNo := 0;

  for i := 0 to Length(Docs) - 1 do begin
    if Docs[i] <> nil then begin
      Docs[i].PaintBox.Font.Name := AppFonts[AppFontNo];
      Docs[i].PaintBox.Font.Size := FontAttr[AppFontNo,ZoomVal].FontSize;
      Docs[i].NumBox.Font.Name := AppFonts[AppFontNo];
      Docs[i].NumBox.Font.Size := FontAttr[AppFontNo,ZoomVal].FontSize;
      Docs[i].CharWidth := FontAttr[AppFontNo,ZoomVal].CharWidth;
      Docs[i].LineHeight := FontAttr[AppFontNo,ZoomVal].LineHeight;
      Docs[i].DebugBox.Width := FontAttr[AppFontNo,ZoomVal].LineHeight;
      Docs[i].ReCalcScrollRange;
      Docs[i].Update;
    end;
  end;
end;

procedure TMainFormPND.itConsolasClick(Sender: TObject);
var
  i: Integer;
begin
  TMenuItem(Sender).Checked := True;
  AppFontNo := 1;

  for i := 0 to Length(Docs) - 1 do begin
    if Docs[i] <> nil then begin
      Docs[i].PaintBox.Font.Name := AppFonts[AppFontNo];
      Docs[i].PaintBox.Font.Size := FontAttr[AppFontNo,ZoomVal].FontSize;
      Docs[i].NumBox.Font.Name := AppFonts[AppFontNo];
      Docs[i].NumBox.Font.Size := FontAttr[AppFontNo,ZoomVal].FontSize;
      Docs[i].CharWidth := FontAttr[AppFontNo,ZoomVal].CharWidth;
      Docs[i].LineHeight := FontAttr[AppFontNo,ZoomVal].LineHeight;
      Docs[i].DebugBox.Width := FontAttr[AppFontNo,ZoomVal].LineHeight;
      Docs[i].ReCalcScrollRange;
      Docs[i].Update;
    end;
  end;
end;

procedure TMainFormPND.ItDebuggerClick(Sender: TObject);
begin
  if TMenuItem(Sender).Checked then begin
    ShowDebugger := False;
    TMenuItem(Sender).Checked := False;
    DebugPanel.Visible := False;
    BottomSplitter.Visible := False;
    DebBtn.ImageIndex := 17;
    ItListen.Checked := False;
  end
  else begin
    ShowDebugger := True;
    TMenuItem(Sender).Checked := True;
    DebugPanel.Visible := True;
    BottomSplitter.Visible := True;
    DebBtn.ImageIndex := 18;
  end;

  DBGpServer.Stop;
end;

procedure TMainFormPND.ItDeleteClick(Sender: TObject);
begin
  Docs[ActivDocID].DeleteTx;
end;

procedure TMainFormPND.ItPasteClick(Sender: TObject);
begin
  Docs[ActivDocID].Paste;
end;

procedure TMainFormPND.ItCutClick(Sender: TObject);
begin
  Docs[ActivDocID].Cut;
end;

procedure TMainFormPND.ItSelectAllClick(Sender: TObject);
begin
  Docs[ActivDocID].SelectAll;
end;

procedure TMainFormPND.ItUbuntuMonoClick(Sender: TObject);
var
  i: Integer;
begin
  TMenuItem(Sender).Checked := True;
  AppFontNo := 2;

  for i := 0 to Length(Docs) - 1 do begin
    if Docs[i] <> nil then begin
      Docs[i].PaintBox.Font.Name := AppFonts[AppFontNo];
      Docs[i].PaintBox.Font.Size := FontAttr[AppFontNo,ZoomVal].FontSize;
      Docs[i].NumBox.Font.Name := AppFonts[AppFontNo];
      Docs[i].NumBox.Font.Size := FontAttr[AppFontNo,ZoomVal].FontSize;
      Docs[i].CharWidth := FontAttr[AppFontNo,ZoomVal].CharWidth;
      Docs[i].LineHeight := FontAttr[AppFontNo,ZoomVal].LineHeight;
      Docs[i].DebugBox.Width := FontAttr[AppFontNo,ZoomVal].LineHeight;
      Docs[i].ReCalcScrollRange;
      Docs[i].Update;
    end;
  end;
end;

procedure TMainFormPND.ItStepOutClick(Sender: TObject);
begin
  StepOutBtn.Click;
end;

procedure TMainFormPND.ItStepOverClick(Sender: TObject);
begin
  StepOverBtn.Click;
end;

procedure TMainFormPND.ItStyleConfiguratorClick(Sender: TObject);
begin
  AboutBox.Close;
  ShortHelpForm.Close;
  SearchForm.Close;
  StyleConfiguratorForm.Visible := True;
end;

procedure TMainFormPND.ItUndoItemClick(Sender: TObject);
begin
  Docs[ActivDocID].HideSelection;

  if Docs[ActivDocID].GetUndoCount = 1 then begin
    ItUndoItem.Enabled := False;
    UndoBtn.Enabled := False;
  end;
  if Docs[ActivDocID].GetRedoCount > -1 then begin
    ItRedoItem.Enabled := True;
    RedoBtn.Enabled := True;
  end;

  ItSave.Enabled := True;
  ItSaveAll.Enabled := True;
  SaveBtn.Enabled := True;
  SaveAllBtn.Enabled := True;

  Docs[ActivDocID].Undo;
end;

procedure TMainFormPND.ItRedoItemClick(Sender: TObject);
begin
  Docs[ActivDocID].HideSelection;

  if Docs[ActivDocID].GetRedoCount = 1 then begin
    ItRedoItem.Enabled := False;
    RedoBtn.Enabled := False;
  end;
  if Docs[ActivDocID].GetUndoCount > -1 then begin
    ItUndoItem.Enabled := True;
    UndoBtn.Enabled := True;
  end;

  ItSave.Enabled := True;
  ItSaveAll.Enabled := True;
  SaveBtn.Enabled := True;
  SaveAllBtn.Enabled := True;

  Docs[ActivDocID].Redo;
end;

procedure TMainFormPND.ItSaveClick(Sender: TObject);
var
  i: Integer;
  flag: Boolean;
begin
  if Docs[ActivDocID].GetDocState = dsNew then begin
    ItSaveAs.Click;
  end;
  if Docs[ActivDocID].GetDocState = dsOpen then begin
    ItSave.Enabled := False;
    SaveBtn.Enabled := False;
    Docs[ActivDocID].SaveToFile(Docs[ActivDocID].GetDocPath);
    Docs[ActivDocID].CommitModify;
  end;

  flag := False;
  for i := 0 to Length(Docs) - 1 do begin
    if (Docs[i] <> nil) and (Docs[i].Modified) then flag := True;
  end;

  if not flag then begin
    ItSaveAll.Enabled := False;
    SaveAllBtn.Enabled := False;
  end;
end;

procedure TMainFormPND.ItSaveAsClick(Sender: TObject);
var
  i: Integer;
  flag: Boolean;
begin
  SaveDialog.FileName := Docs[ActivDocID].GetDocPath;
  SaveDialog.FilterIndex := Docs[ActivDocID].FilterIndex;

  if SaveDialog.Execute then begin
    ItSave.Enabled := False;
    SaveBtn.Enabled := False;

    if Length(ExtractFileExt(SaveDialog.FileName)) = 0 then begin
      case SaveDialog.FilterIndex of
        1: SaveDialog.FileName := SaveDialog.FileName + '.php';
        2: SaveDialog.FileName := SaveDialog.FileName + '.js';
        3: SaveDialog.FileName := SaveDialog.FileName + '.json';
        4: SaveDialog.FileName := SaveDialog.FileName + '.html';
        5: SaveDialog.FileName := SaveDialog.FileName + '.css';
        6: SaveDialog.FileName := SaveDialog.FileName + '.xml';
        7: SaveDialog.FileName := SaveDialog.FileName + '.txt';
        8: SaveDialog.FileName := SaveDialog.FileName + '';
      end;
    end;

    Docs[ActivDocID].SaveToFile(SaveDialog.FileName);
    Docs[ActivDocID].SetDocPath(SaveDialog.FileName);
    Docs[ActivDocID].SetDocState(dsOpen);
    Docs[ActivDocID].CommitModify;
    TabControl.RenameTab(ActivDocID, ExtractFileName(SaveDialog.FileName));
    TabControl.Update;
    Caption := 'PHPNotepad - ' + SaveDialog.FileName;
  end;

  flag := False;
  for i := 0 to Length(Docs) - 1 do begin
    if (Docs[i] <> nil) and (Docs[i].Modified) then flag := True;
  end;

  if not flag then begin
    ItSaveAll.Enabled := False;
    SaveAllBtn.Enabled := False;
  end;
end;

procedure TMainFormPND.ItCloseClick(Sender: TObject);
var
  ID: Integer;
begin
  ID := ActivDocID;
  TabControl.CloseTab(ID);
  TabControl.Update;
end;


procedure TMainFormPND.ItSaveAllClick(Sender: TObject);
var
  i: Integer;
  flag: Boolean;
  NewFileName, Path: String;
begin
  flag := False;
  for i := 0 to Length(Docs) - 1 do begin
    if (Docs[i] <> nil) and (Docs[i].Modified) then begin
      if Docs[i].GetDocState = dsNew then begin

        SaveDialog.FilterIndex := Docs[i].FilterIndex;
        NewFileName := Docs[i].GetDocPath;
        Path := ExtractFilePath(NewFileName);

        case SaveDialog.FilterIndex of
          1: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.php';
          2: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.js';
          3: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.json';
          4: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.html';
          5: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.css';
          6: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.xml';
          7: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.txt';
          8: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '';
        end;

        SaveDialog.FileName := Path + NewFileName;

        if SaveDialog.Execute then begin
          ItSave.Enabled := False;
          SaveBtn.Enabled := False;
          Docs[i].SaveToFile(SaveDialog.FileName);
          Docs[i].SetDocPath(SaveDialog.FileName);
          Docs[i].SetDocState(dsOpen);
          Docs[i].CommitModify;
          TabControl.RenameTab(Docs[i].ID, ExtractFileName(SaveDialog.FileName));
          TabControl.Update;
          Caption := 'PHPNotepad - ' + SaveDialog.FileName;
        end else begin
          ItSave.Enabled := True;
          SaveBtn.Enabled := True;
          flag := True;
        end;
      end;

      if Docs[i].GetDocState = dsOpen then begin
        ItSave.Enabled := False;
        SaveBtn.Enabled := False;
        Docs[i].SaveToFile(Docs[i].GetDocPath);
        Docs[i].CommitModify;
      end;
    end;
  end;

  if not flag then begin
    ItSaveAll.Enabled := False;
    SaveAllBtn.Enabled := False;
  end;
end;

procedure TMainFormPND.itInconsolataClick(Sender: TObject);
var
  i: Integer;
begin
  TMenuItem(Sender).Checked := True;
  AppFontNo := 2;

  for i := 0 to Length(Docs) - 1 do begin
    if Docs[i] <> nil then begin
      Docs[i].PaintBox.Font.Name := AppFonts[AppFontNo];
      Docs[i].PaintBox.Font.Size := FontAttr[AppFontNo,ZoomVal].FontSize;
      Docs[i].NumBox.Font.Name := AppFonts[AppFontNo];
      Docs[i].NumBox.Font.Size := FontAttr[AppFontNo,ZoomVal].FontSize;
      Docs[i].CharWidth := FontAttr[AppFontNo,ZoomVal].CharWidth;
      Docs[i].LineHeight := FontAttr[AppFontNo,ZoomVal].LineHeight;
      Docs[i].DebugBox.Width := FontAttr[AppFontNo,ZoomVal].LineHeight;
      Docs[i].ReCalcScrollRange;
      Docs[i].Update;
    end;
  end;
end;

procedure TMainFormPND.ItCloseAllClick(Sender: TObject);
var
  i, BtnSelID: Integer;
  SvFlags: array of Boolean;
  NewFileName, Path: String;
begin
  SetLength(SvFlags, Length(Docs));
  for i := 0 to Length(SvFlags) - 1 do begin
    SvFlags[i] := False;
  end;

  for i := 0 to Length(Docs) - 1 do begin
    if Docs[i] <> nil then begin
      if Docs[i].Modified then begin
        ShortHelpForm.Close;
        SearchForm.Close;
        AboutBox.Close;
        StyleConfiguratorForm.Close;

        BtnSelID := MessageBox(Handle, PChar('Save file "'+Docs[i].GetDocPath+'" ?'), PChar('Save'), MB_YESNOCANCEL+MB_ICONQUESTION);

        if BtnSelID = mrCancel then begin
          Exit;
        end;

        if BtnSelID = mrYes then begin
          if Docs[i].GetDocState = dsOpen then begin
            Docs[i].SaveToFile(Docs[i].GetDocPath);
          end;
          if Docs[i].GetDocState = dsNew then begin
            SaveDialog.FilterIndex := Docs[i].FilterIndex;
            NewFileName := Docs[i].GetDocPath;
            Path := ExtractFilePath(NewFileName);

            case SaveDialog.FilterIndex of
              1: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.php';
              2: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.js';
              3: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.json';
              4: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.html';
              5: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.css';
              6: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.xml';
              7: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '.txt';
              8: NewFileName := StringReplace(ExtractFileName(NewFileName),ExtractFileExt(NewFileName),'',[]) + '';
            end;
            SaveDialog.FileName := Path + NewFileName;

            if SaveDialog.Execute then begin
              Docs[i].SaveToFile(SaveDialog.FileName);
              Docs[i].SetDocPath(SaveDialog.FileName);
              Docs[i].SetDocState(dsOpen);
              Docs[i].CommitModify;
              TabControl.RenameTab(Docs[i].ID, ExtractFileName(NewFileName));
              TabControl.Update;
              Caption := 'PHPNotepad - ' + SaveDialog.FileName;
            end else Exit;
          end;
        end;
        SvFlags[i] := True;
      end;
    end;
  end;

  for i := 0 to Length(SvFlags) - 1 do begin
    if SvFlags[i] then Docs[i].CommitModify;
  end;

  for i := 0 to Length(Docs) - 1 do begin
    if Docs[i] <> nil then begin
      TabControl.CloseTab(i);
    end;
  end;
  TabControl.ScrollPos := 0;
  TabControl.Update;
end;

procedure TMainFormPND.SaveAllBtnClick(Sender: TObject);
begin
  ItSaveAll.Click;
end;

procedure TMainFormPND.CloseBtnClick(Sender: TObject);
begin
  ItClose.Click;
end;

procedure TMainFormPND.ClassTreeViewDblClick(Sender: TObject);
begin
  if ClassTreeView.Selected.Level > 1 then begin
    if Length(Docs) > 0 then begin
      if Docs[ActivDocID] <> nil then begin
        Docs[ActivDocID].FindAndSelectAll(ClassTreeView.Selected.Text, TState(Integer(ClassTreeView.Selected.Data)));

        Docs[ActivDocID].FindFirst(TState(ClassTreeView.Selected.Data), ClassTreeView.Selected.Text);

        StatusBar.Panels[3].Text := IntToStr(Docs[ActivDocID].CalcAll(TState(ClassTreeView.Selected.Data), ClassTreeView.Selected.Text)) +
        ' matches found';
      end;
    end;
  end;
end;

procedure TMainFormPND.CloseAllBtnClick(Sender: TObject);
begin
  ItCloseAll.Click;
end;

procedure TMainFormPND.SaveDialogTypeChange(Sender: TObject);
var
  NewFileName: String;
begin
  case SaveDialog.FilterIndex of
    1: NewFileName := StringReplace(ExtractFileName(SaveDialog.FileName),ExtractFileExt(SaveDialog.FileName),'',[]) + '.php';
    2: NewFileName := StringReplace(ExtractFileName(SaveDialog.FileName),ExtractFileExt(SaveDialog.FileName),'',[]) + '.js';
    3: NewFileName := StringReplace(ExtractFileName(SaveDialog.FileName),ExtractFileExt(SaveDialog.FileName),'',[]) + '.json';
    4: NewFileName := StringReplace(ExtractFileName(SaveDialog.FileName),ExtractFileExt(SaveDialog.FileName),'',[]) + '.html';
    5: NewFileName := StringReplace(ExtractFileName(SaveDialog.FileName),ExtractFileExt(SaveDialog.FileName),'',[]) + '.css';
    6: NewFileName := StringReplace(ExtractFileName(SaveDialog.FileName),ExtractFileExt(SaveDialog.FileName),'',[]) + '.xml';
    7: NewFileName := StringReplace(ExtractFileName(SaveDialog.FileName),ExtractFileExt(SaveDialog.FileName),'',[]) + '.txt';
    8: NewFileName := StringReplace(ExtractFileName(SaveDialog.FileName),ExtractFileExt(SaveDialog.FileName),'',[]) + '';
  end;

  SendMessage(Windows.Getparent(Savedialog.Handle), CDM_SETCONTROLTEXT, 1152,
              Longint(PChar(NewFileName)));
end;

procedure TMainFormPND.HTMLBTNClick(Sender: TObject);
begin
  ChangeScanMode(smHTML);
  Docs[ActivDocID].SetScanStartLine(0);
  Docs[ActivDocID].GoScan;
end;

procedure TMainFormPND.PHPBTNClick(Sender: TObject);
begin
  ChangeScanMode(smPHP);
  Docs[ActivDocID].SetScanStartLine(0);
  Docs[ActivDocID].GoScan;  
end;

procedure TMainFormPND.JSBTNClick(Sender: TObject);
begin
  ChangeScanMode(smJS);
  Docs[ActivDocID].SetScanStartLine(0);
  Docs[ActivDocID].GoScan;
end;

procedure TMainFormPND.CSSBTNClick(Sender: TObject);
begin
  ChangeScanMode(smCSS);
  Docs[ActivDocID].SetScanStartLine(0);
  Docs[ActivDocID].GoScan;
end;

procedure TMainFormPND.TXTBTNClick(Sender: TObject);
begin
  ChangeScanMode(smTXT);
  Docs[ActivDocID].SetScanStartLine(0);
  Docs[ActivDocID].GoScan;
end;

procedure TMainFormPND.XMLBTNClick(Sender: TObject);
begin
  ChangeScanMode(smXML);
  Docs[ActivDocID].SetScanStartLine(0);
  Docs[ActivDocID].GoScan;
end;

procedure TMainFormPND.ZoomInBtnClick(Sender: TObject);
begin
  ItZoomIn.Click;
end;

procedure TMainFormPND.ZoomOutBtnClick(Sender: TObject);
begin
  ItZoomOut.Click;
end;

procedure TMainFormPND.ChangeScanMode(SelectScanMode: TScanMode);
begin
  case SelectScanMode of
    smNo: begin
      HTMLBTN.Down := False;
      PHPBTN.Down := False;
      JSBTN.Down := False;
      CSSBTN.Down := False;
      XMLBTN.Down := False;
      TXTBTN.Down := False;    
      HTMLBTN.Enabled := False;
      PHPBTN.Enabled := False;
      JSBTN.Enabled := False;
      CSSBTN.Enabled := False;
      XMLBTN.Enabled := False;
      TXTBTN.Enabled := False;
    end;
    smYes: begin
      HTMLBTN.Enabled := True;
      PHPBTN.Enabled := True;
      JSBTN.Enabled := True;
      CSSBTN.Enabled := True;
      XMLBTN.Enabled := True;
      TXTBTN.Enabled := True;
    end;
    smHTML: begin
      HTMLBTN.Down := True;
      Docs[ActivDocID].ScanMode := smHTML;
      Docs[ActivDocID].FilterIndex := 4;
    end;
    smPHP: begin
      PHPBTN.Down := True;
      Docs[ActivDocID].ScanMode := smPHP;
      Docs[ActivDocID].FilterIndex := 1;
    end;
    smJS: begin
      JSBTN.Down := True;
      Docs[ActivDocID].ScanMode := smJS;
      Docs[ActivDocID].FilterIndex := 2;
    end;
    smCSS: begin
      CSSBTN.Down := True;
      Docs[ActivDocID].ScanMode := smCSS;
      Docs[ActivDocID].FilterIndex := 5;
    end;
    smXML: begin
      XMLBTN.Down := True;
      Docs[ActivDocID].ScanMode := smXML;
      Docs[ActivDocID].FilterIndex := 6;
    end;    
    smTXT: begin
      TXTBTN.Down := True;
      Docs[ActivDocID].ScanMode := smTXT;
      Docs[ActivDocID].FilterIndex := 7;
    end;
  end;
end;

procedure TMainFormPND.ItEvalClick(Sender: TObject);
begin
  EvalBtn.Click;
end;

procedure TMainFormPND.ItExitClick(Sender: TObject);
var
  i: Integer;
begin
  ItCloseAll.Click;

  if TabControl.GetTabCount = 0 then begin
    for i := 0 to Length(Docs) - 1 do begin
      if Docs[i] <> nil then begin
        Docs[i].Terminate;
        DocCloseTimer[i].Enabled := True;
      end;
    end;

    CloseQueryTimer.Enabled := True;
  end;
end;

procedure TMainFormPND.CutBtnClick(Sender: TObject);
begin
  ItCut.Click;
end;

procedure TMainFormPND.DebBtnClick(Sender: TObject);
begin
  ItDebugger.Click;
end;

procedure TMainFormPND.DebOptionBtnClick(Sender: TObject);
var
  DBGpConfList: TStringList;
  Encoding: TEncoding;
begin
  if (DBGpConfigForm.ShowModal = mrOk) then begin
    try
      if DBGpConfigForm.CheckBoxBreakAtFirst.Checked then
        BreakAtFirst := True
      else
        BreakAtFirst :=  False;

      DBGpServer.DebFirstLine := BreakAtFirst;


      DBGpServer.SendMisc;
      Encoding := TUTF8Encoding.Create;
      DBGpConfList := TStringList.Create;
      DBGpConfList.Add('<?xml version="1.0" encoding="UTF-8" ?>');
      DBGpConfList.Add('<PHPNotepad>');
      DBGpConfList.Add('  <Misc>');
      DBGpConfList.Add('    <Depth>'+DBGpConfigForm.SpinDepth.Text+'</Depth>');
      DBGpConfList.Add('    <Child>'+DBGpConfigForm.SpinChild.Text+'</Child>');
      DBGpConfList.Add('    <Data>'+DBGpConfigForm.SpinData.Text+'</Data>');
      DBGpConfList.Add('  </Misc>');
      DBGpConfList.Add('</PHPNotepad>');
      DBGpConfList.SaveToFile(ExtractFilePath(Application.ExeName)+'\AppData\DBGp.xml', Encoding);
      DBGpConfList.Free;
    except
    end;
  end;
end;

procedure TMainFormPND.DebugPanelResize(Sender: TObject);
begin
  if DebugPanel.Height < 150 then DebugPanel.Height := 150;
  if DebugPanel.Height > Self.Height div 2 then DebugPanel.Height := Self.Height div 2;

  DebugPanel.Top := Self.ClientHeight - StatusBar.Height - DebugPanel.Height;
  StatusBar.Top := DebugPanel.Top + DebugPanel.Height;
end;

procedure TMainFormPND.ItDocumentMapClick(Sender: TObject);
var
  i: Integer;
  DMap: TDocMap;
begin
  if TMenuItem(Sender).Checked then begin
    ShowDocMap := False;
    TMenuItem(Sender).Checked := False;
    for i := 0 to Length(Docs) - 1 do begin
      if Docs[i] <> nil then begin
        if Docs[i].DocMap <> nil then begin
          Docs[i].DocMap.Free;
          Docs[i].DocMap := nil;
        end;
      end;
    end;
  end
  else begin
    ShowDocMap := True;
    TMenuItem(Sender).Checked := True;
    for i := 0 to Length(Docs) - 1 do begin
      if Docs[i] <> nil then begin
        if Docs[i].DocMap = nil then begin
          DMap := TDocMap.Create(Docs[i]);
          DMap.Align := alRight;
          Docs[i].DocMap := DMap;
        end;
      end;
    end;
  end;
end;

procedure TMainFormPND.ItAddWatchClick(Sender: TObject);
begin
  AddWatchBtn.Click;
end;

procedure TMainFormPND.ItBlockEdgingClick(Sender: TObject);
var
  i: Integer;
begin
  if TMenuItem(Sender).Checked then begin
    ShowBlockEdging := False;
    TMenuItem(Sender).Checked := False;
    for i := 0 to Length(Docs) - 1 do begin
      if Docs[i] <> nil then begin
        Docs[i].BlockEdgingPaint := False;
        Docs[i].Refresh;
      end;
    end;
  end
  else begin
    ShowBlockEdging := True;
    TMenuItem(Sender).Checked := True;
    for i := 0 to Length(Docs) - 1 do begin
      if Docs[i] <> nil then begin
        Docs[i].BlockEdgingPaint := True;
        Docs[i].Refresh;
      end;
    end;
  end;
end;

procedure TMainFormPND.ItClassViewClick(Sender: TObject);
var
  i: Integer;
begin
  if TMenuItem(Sender).Checked then begin
    ShowClassView := False;
    TMenuItem(Sender).Checked := False;
    ClassViewSheet.TabVisible := False;
    for i := 0 to Length(Docs) - 1 do begin
      if Docs[i] <> nil then begin
        if Docs[i].ClassView <> nil then begin
          if not Docs[i].InScanTree then begin
            Docs[i].ClassView := nil;
          end;
        end;
      end;
    end;
  end
  else begin
    ShowClassView := True;
    TMenuItem(Sender).Checked := True;
    ClassViewSheet.TabVisible := True;
    ClassViewSheet.Show;
    for i := 0 to Length(Docs) - 1 do begin
      if Docs[i] <> nil then begin
        if Docs[i].ClassView = nil then begin
          Docs[i].ClassView := ClassTreeView;
        end;
      end;
    end;
  end;

  if (ShowClassView or ShowFileExplorer) then begin
    LeftPanel.Visible := True;
    LeftSplitter.Enabled := True;
  end
  else begin
    LeftPanel.Visible := False;
    LeftSplitter.Enabled := False;
  end;

  if ShowClassView then begin
    if Length(Docs) > 0 then begin
      if Docs[ActivDocID] <> nil then begin
        Docs[ActivDocID].TreeTimer.Enabled := True;
      end;
    end;
  end;
end;

procedure TMainFormPND.ItZoomInClick(Sender: TObject);
var
  i: Integer;
begin
  if ZoomVal < 3 then Inc(ZoomVal);
  for i := 0 to Length(Docs) - 1 do begin
    if Docs[i] <> nil then begin
      Docs[i].PaintBox.Font.Name := AppFonts[AppFontNo];
      Docs[i].PaintBox.Font.Size := FontAttr[AppFontNo,ZoomVal].FontSize;
      Docs[i].NumBox.Font.Name := AppFonts[AppFontNo];
      Docs[i].NumBox.Font.Size := FontAttr[AppFontNo,ZoomVal].FontSize;
      Docs[i].CharWidth := FontAttr[AppFontNo,ZoomVal].CharWidth;
      Docs[i].LineHeight := FontAttr[AppFontNo,ZoomVal].LineHeight;
      Docs[i].DebugBox.Width := Docs[i].LineHeight;
      Docs[i].ReCalcScrollRange;
      Docs[i].Update;
    end;
  end;
end;

procedure TMainFormPND.ItZoomOutClick(Sender: TObject);
var
  i: Integer;
begin
  if ZoomVal > -2 then Dec(ZoomVal);
  for i := 0 to Length(Docs) - 1 do begin
    if Docs[i] <> nil then begin
      Docs[i].PaintBox.Font.Name := AppFonts[AppFontNo];
      Docs[i].PaintBox.Font.Size := FontAttr[AppFontNo,ZoomVal].FontSize;
      Docs[i].NumBox.Font.Name := AppFonts[AppFontNo];
      Docs[i].NumBox.Font.Size := FontAttr[AppFontNo,ZoomVal].FontSize;
      Docs[i].CharWidth := FontAttr[AppFontNo,ZoomVal].CharWidth;
      Docs[i].LineHeight := FontAttr[AppFontNo,ZoomVal].LineHeight;
      Docs[i].DebugBox.Width := Docs[i].LineHeight;
      Docs[i].ReCalcScrollRange;
      Docs[i].Update;
    end;
  end;
end;

procedure TMainFormPND.CopyBtnClick(Sender: TObject);
begin
  ItCopy.Click;
end;

procedure TMainFormPND.PasteBtnClick(Sender: TObject);
begin
  ItPaste.Click;
end;

procedure TMainFormPND.SpeedButton8Click(Sender: TObject);
begin
  if Docs[ActivDocID].TextSelected then ShowMessage('True')
  else ShowMessage('False');
end;


procedure TMainFormPND.SpeedButton9Click(Sender: TObject);
begin
  ItReopen.Delete(0);
end;

procedure TMainFormPND.ItFileExplorerClick(Sender: TObject);
begin
  if TMenuItem(Sender).Checked then begin
    ShowFileExplorer := False;
    TMenuItem(Sender).Checked := False;
    FileExplorerSheet.TabVisible := False;
  end
  else begin
    ShowFileExplorer := True;
    TMenuItem(Sender).Checked := True;
    FileExplorerSheet.TabVisible := True;
    FileExplorerSheet.Show;
  end;

  if (ShowClassView or ShowFileExplorer) then begin
    LeftPanel.Visible := True;
    LeftSplitter.Enabled := True;
  end
  else begin
    LeftPanel.Visible := False;
    LeftSplitter.Enabled := False;
  end;
end;

procedure TMainFormPND.ItFindClick(Sender: TObject);
begin
  AboutBox.Close;
  ShortHelpForm.Close;
  StyleConfiguratorForm.Close;

  Docs[ActivDocID].StopCursor;
  SearchForm.PHPEditor := Docs[ActivDocID];
  SearchForm.Caption := 'Find';
  SearchForm.FindEdit.Clear;
  SearchForm.FindReplEdit.Clear;
  SearchForm.ReplaceEdit.Clear;
  SearchForm.FindEdit.Text := Docs[ActivDocID].TextSelectedForFind;
  SearchForm.PageControl.Pages[0].Show;
  SearchForm.Visible := True;
  Docs[ActivDocID].RunCursor;
end;

procedure TMainFormPND.ItReplaceClick(Sender: TObject);
begin
  AboutBox.Close;
  ShortHelpForm.Close;
  StyleConfiguratorForm.Close;

  Docs[ActivDocID].StopCursor;
  SearchForm.PHPEditor := Docs[ActivDocID];
  SearchForm.Caption := 'Replace';
  SearchForm.FindEdit.Clear;
  SearchForm.FindReplEdit.Clear;
  SearchForm.ReplaceEdit.Clear;
  SearchForm.FindReplEdit.Text := Docs[ActivDocID].TextSelectedForFind;
  SearchForm.PageControl.Pages[1].Show;
  SearchForm.Visible := True;
  Docs[ActivDocID].RunCursor;
end;

procedure TMainFormPND.FindBtnClick(Sender: TObject);
begin
  ItFind.Click;
end;

procedure TMainFormPND.ReplaceBtnClick(Sender: TObject);
begin
  ItReplace.Click;
end;

procedure TMainFormPND.ItRunClick(Sender: TObject);
begin
  RunNextBtn.Click;
end;

procedure TMainFormPND.ItRunToCursorClick(Sender: TObject);
begin
  RunToCursorBtn.Click;
end;

procedure TMainFormPND.EvalBtnClick(Sender: TObject);
begin
  AddEvalForm.EvalEdit.Text := '';

  if AddEvalForm.ShowModal = mrOk then begin
    if Length(Docs) > 0 then begin
      if Docs[ActivDocID] <> nil then begin
        DBGpServer.AddEval(Docs[ActivDocID].GetDocPath, AddEvalForm.EvalEdit.Text);
      end;
    end;
  end
  else begin

  end;
end;

procedure TMainFormPND.ExitBtnClick(Sender: TObject);
begin
  ItExit.Click;
end;

procedure TMainFormPND.ItPrintClick(Sender: TObject);
begin
  Docs[ActivDocID].Print;
end;

procedure TMainFormPND.LeftPanelResize(Sender: TObject);
begin
  if LeftPanel.Width < 150 then LeftPanel.Width := 150;
  if LeftPanel.Width > 500 then LeftPanel.Width := 500;
end;

procedure TMainFormPND.LicenseAgreeBoxClick(Sender: TObject);
var
  Reg: TRegistry;
  i: Integer;
begin
  Reg := TRegistry.Create;
  try
    try
      Reg.RootKey :=  HKEY_CURRENT_USER;
      Reg.OpenKey('Software\PHPNotepad',true);
      Reg.WriteInteger('ReadLicense', 1);
    except
    end;
  finally
    for i := 0 to MainMenu.Items.Count - 1 do begin
      MainMenu.Items[i].Enabled := True;
    end;

    ToolPanel.Enabled := True;
    ModeBar.Enabled := True;
    TabPanel.Enabled := True;
    LicensePanel.Visible := False;
    ReadLicense := 1;

    for i := 0 to Length(Docs) - 1 do begin
      if Docs[i] <> nil then begin
        TabControl.CloseTab(0);
      end;
    end;

    TabControl.Update;
    Reg.free;
  end;

  Refresh;
end;

procedure TMainFormPND.PrintBtnClick(Sender: TObject);
begin
  ItPrint.Click;
end;

procedure TMainFormPND.PHPNotepadClick(Sender: TObject);
begin
  AboutBox.Close;
  SearchForm.Close;
  StyleConfiguratorForm.Close;
  ShortHelpForm.Visible := True;
end;

procedure TMainFormPND.AboutClick(Sender: TObject);
begin
  ShortHelpForm.Close;
  SearchForm.Close;
  StyleConfiguratorForm.Close;
  AboutBox.FormStyle := fsStayOnTop;
  AboutBox.Visible := True;
end;

procedure TMainFormPND.ItPageSeparatorClick(Sender: TObject);
var
  i: Integer;
begin
  if TMenuItem(Sender).Checked then begin
    ShowSepLine := False;
    TMenuItem(Sender).Checked := False;
    for i := 0 to Length(Docs) - 1 do begin
      if Docs[i] <> nil then begin
        Docs[i].SepLinePaint := False;
        Docs[i].Refresh;
      end;
    end;
  end
  else begin
    ShowSepLine := True;
    TMenuItem(Sender).Checked := True;
    for i := 0 to Length(Docs) - 1 do begin
      if Docs[i] <> nil then begin
        Docs[i].SepLinePaint := True;
        Docs[i].Refresh;
      end;
    end;
  end;
end;

procedure TMainFormPND.IttoANSIClick(Sender: TObject);
var
  Enb: Boolean;
begin
  Enb := ItUndoItem.Enabled;

  if Length(Docs) > 0 then begin
    if Docs[ActivDocID] <> nil then begin
      Docs[ActivDocID].TransCode('ANSI');
      ItANSI.Checked := True;
    end;
  end;

  if not Enb then begin
    ItUndoItem.Enabled := False;
    UndoBtn.Enabled  := False;
  end;
end;

procedure TMainFormPND.IttoUTF8Click(Sender: TObject);
var
  Enb: Boolean;
begin
  Enb := ItUndoItem.Enabled;

  if Length(Docs) > 0 then begin
    if Docs[ActivDocID] <> nil then begin
      Docs[ActivDocID].TransCode('UTF-8 BOM');
      ItUTF8.Checked := True;
    end;
  end;

  if not Enb then begin
    ItUndoItem.Enabled := False;
    UndoBtn.Enabled  := False;
  end;
end;

procedure TMainFormPND.IttoUTF8WithOutBOMClick(Sender: TObject);
var
  Enb: Boolean;
begin
  Enb := ItUndoItem.Enabled;

  if Length(Docs) > 0 then begin
    if Docs[ActivDocID] <> nil then begin
      Docs[ActivDocID].TransCode('UTF-8');
      ItUTF8WithOutBOM.Checked := True;
    end;
  end;

  if not Enb then begin
    ItUndoItem.Enabled := False;
    UndoBtn.Enabled  := False;
  end;
end;

procedure TMainFormPND.ItTraceIntoClick(Sender: TObject);
begin
  TraceIntoBtn.Click;
end;

procedure TMainFormPND.IttoUCS2BigEndianClick(Sender: TObject);
var
  Enb: Boolean;
begin
  Enb := ItUndoItem.Enabled;

  if Length(Docs) > 0 then begin
    if Docs[ActivDocID] <> nil then begin
      Docs[ActivDocID].TransCode('UCS-2 BE');
      ItUCSBigEndian.Checked := True;
    end;  
  end;

  if not Enb then begin
    ItUndoItem.Enabled := False;
    UndoBtn.Enabled  := False;
  end;  
end;

procedure TMainFormPND.IttoUCS2LittleEndianClick(Sender: TObject);
var
  Enb: Boolean;
begin
  Enb := ItUndoItem.Enabled;
  
  if Length(Docs) > 0 then begin
    if Docs[ActivDocID] <> nil then begin
      Docs[ActivDocID].TransCode('UCS-2 LE');
      ItUCS2LittleEndian.Checked := True;
    end;  
  end;

  if not Enb then begin
    ItUndoItem.Enabled := False;
    UndoBtn.Enabled  := False;
  end;  
end;

end.



