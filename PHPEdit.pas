unit PHPEdit;

interface

uses
  Windows, Controls, Classes, Forms, ExtCtrls, Graphics, StdCtrls, Dialogs,
  Types, Messages, ClipBrd, Buttons, ComCtrls, Menus, Printers, Encoding,
  StringListUnicodeSupport, System.WideStrUtils;

const
  Delim = [#9,#10,#13,#32,'!','<','>','[',']','{','}','(',')',',','.','/','?','"','''']+
          [';',':','-','+','=','*','&','#','`','@','$','%','^','\','|','~'];
type
  TDocState = (dsNew, dsOpen);

  TScanMode = (smPHP, smHTML, smJS, smCSS, smXML, smTXT, smNo, smYes);
  
  TState = (ScanNull, ScanNormal, ScanPHP, ScanSingleQuoted, ScanDoubleQuoted, ScanComment,
            ScanLineComment, ScanVar, ScanFunc, ScanReserv, ScanDigit,
            ScanPHPTag, ScanHTMLTag, ScanOpenHTML, ScanHTMLAttr, ScanCloseHTML,
            ScanDblQHTML, ScanSingQHTML, ScanHTMLComment, ScanHTMLHeader,
            ScanCSSTag, ScanOpenCSS, ScanDblQCSS, ScanSingQCSS, ScanCloseCSS,
            ScanCSSBody, ScanCSSAttr, ScanCSSVal, ScanCSSComment,
            ScanJSTag, ScanOpenJS, ScanDblQJS, ScanSingQJS, ScanCloseJS,
            ScanJSBody, ScanJSMetods, ScanJSObj, ScanJSProp, ScanJSReserv,
            ScanJSComment, ScanDblStringJS, ScanSingStringJS, ScanLineJSComment,
            ScanOpenCurlPHP, ScanCloseCurlPHP, ScanOpenRoundPHP, ScanCloseRoundPHP,
            ScanOpenCurlJS, ScanCloseCurlJS, ScanOpenRoundJS, ScanCloseRoundJS,
            ScanOpenCurlCSS, ScanCloseCurlCSS);//53

  TStateRec = record
    Pos: array of TState;
    Max: Integer;
    J: array of Integer;
    LevelPHP: Integer;
    LevelJS: Integer;
  end;

  TStateArray = array of TStateRec;

  PReplaceRec = ^TReplaceRec;
  TReplaceRec = record
    X: Integer;
    Y: Integer;
    Mask: array of Char;
    Next: PReplaceRec;
  end;

  TURType = (urUndo, urRedo);
  TActionType = (actInsert, actDelete, actReplace);
  TActionRec = record
    ActType: TActionType;
    BeginPos: TPoint;
    EndPos: TPoint;
    Text: String;
    ReplText: String;
    RpBlock: Boolean;
    Ref: PReplaceRec;
  end;

  TDocPlaceInfo = record
    PlaceState: TState;
    DocSmType: TScanMode;
  end;

  TCurlBlockRec = record
    BBegin: TPoint;
    BEnd: TPoint;
    Level: Integer;
    Visit: Boolean;
  end;

  TBreakPointArray = array of Integer;

  TEditScrollBar = class(TScrollBar)
  protected
    procedure WMCtlColor(var Message: TWMCtlColorScrollbar); message CN_CTLCOLORSCROLLBAR;
  end;

  TPHPEdit = class(TCustomPanel)
  private
    LineNo: Integer;
    LineNoTr: Integer;
    FID: Integer;
    FCharWidth: Integer;
    FLineHeight: Integer;
    FEndLine: Integer;
    FInDBlClick: Boolean;
    FTerminate: Boolean;
    FHorzScrollBar: TScrollBar;
    FHorzScrollPanel: TPanel;
    FScrollSeparator: TControl;
    FHorsStartPos: Integer;
    predstate: TState;
    predj: Integer;
    DCount: Integer;
    FFonColor: TColor;
    FBigStringPartLen: Integer;
    FSelectedRange: array[0..1] of TPoint;
    FRepaintWaitTimer: TTimer;
    FOpenTimer: TTimer;
    FDblClickTimer: TTimer;
    FCaretMerguTimer: TTimer;
    MergCounter: Integer;
    FMoveX: Integer;
    FUndoMenu: TMenuItem;
    FRedoMenu: TMenuItem;
    FSaveMenu: TMenuItem;
    FSaveAllMenu: TMenuItem;
    FCutMenu: TMenuItem;
    FCopyMenu: TMenuItem;
    FDeleteMenu: TMenuItem;
    FUndoBtn: TToolButton;
    FRedoBtn: TToolButton;
    FSaveBtn: TToolButton;
    FSaveAllBtn: TToolButton;
    FCutBtn: TToolButton;
    FCopyBtn: TToolButton;
    FEncodingMenu: TMenuItem;
    FpmCut: TMenuItem;
    FpmCopy: TMenuItem;
    FpmDelete: TMenuItem;
    FStatusBar: TStatusBar;
    FPrintDialog: TPrintDialog;
    FModified: Boolean;
    FDocPath: String;
    FDocState: TDocState;
    FScanMode: TScanMode;
    FFilterIndex: Integer;
    FPHPReservList: TStringList;
    FPHPFuncList: TStringList;
    FHtmlTagList: TStringList;
    FHtmlAttrList: TStringList;
    FHtmlMethodsList: TStringList;
    FJSObjectList: TStringList;
    FJSMethodsList: TStringList;
    FJSPropList: TStringList;
    FJSReservList: TStringList;
    FCSSAttrList: TStringList;
    FCSSValList: TStringList;
    FPerProcessMessages: Integer;
    FScreenAnchorBox: TControl;
    FSepLinePaint: Boolean;
    FBlockEdgingPaint: Boolean;
    FDocMap: TObject;
    FClassView: TTreeView;
    FFindTreeItem: Boolean;
    FFindTreeState: TState;
    FFindTreeStr: String;
    FLevelPHP: Integer;
    FCurlBlockArrayPHP: array of TCurlBlockRec;
    FNewCurlPosPHP: Integer;
    FLevelJS: Integer;
    FCurlBlockArrayJS: array of TCurlBlockRec;
    FNewCurlPosJS: Integer;
    FTreeScanWaitTick: Integer;
    FClassFuncWaitTick: Integer;
    FSuspendTree: Boolean;
    FPHPUserClassList: TStringList;
    FPHPUserFuncList: TStringList;
    FFollowRef: Boolean;
    FFollowRefLine: Integer;
    FFollowRefPosFrom: Integer;
    FFollowRefPosTo: Integer;
    FFollowStr: String;
    FMouseX: Integer;
    FMouseY: Integer;
    FBackDocID: Integer;
    FBackY: Integer;
    FBackRefY: Integer;
    FRefArrowBackActiv: Boolean;
    FInScanTree: Boolean;
    FDebugConnectionID: Integer;
    FIsMainDebugStack: Boolean;
    FDebugCurLine: Integer;
    FDebugStatus: string;
    FDebugBreakPointArray: TBreakPointArray;
    FDebugBox: TPaintBox;
    FRepaintTimer: TTimer;
    FTreeTimer: TTimer;
    FClassFuncTimer: TTimer;
    FStartLine: Integer;
    FCaretPos: TPoint;
    FSRMove: Boolean;
    FVertScrollBar: TScrollBar;
    FStringList: TStringList; FLineStateAr: TStateArray; FPaintBox: TPaintBox;
    FNumBox: TPaintBox;
    FUndoStack: array of TActionRec;
    FRedoStack: array of TActionRec;
    FStartSelected: Boolean;
    FScanFromLine: Integer;
    FMaxLineLength: Integer;
    FIndex: Integer;
    FKeyChanged: Boolean;
    FBkChanged: Boolean;
    FDelChanged: Boolean;
    FKeyChgBeginPos: TPoint;
    FKeyChgEndPos: TPoint;
    FBkText: String;
    FUdText: String;
    FInScan: Boolean;

    CurWord: String;
    LinePos: Integer;
    Next: Boolean;
    State: TState;
    ReturnState: TState;
    LastState: TState;
    gi: Integer;
    gS: String;
    procedure ClassFuncListScan;
    function GetCountOfDigit(Number: Integer): Integer;
    procedure CaretPaint;
    procedure SelectedRangePaint;
  protected
    procedure WMGetDlgCode(var Msg: TMessage); message WM_GETDLGCODE;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
  public
    procedure BeginKeyChanged(Ch: Char; CharPos: TPoint; Sp: String);
    procedure BeginBkSpaceChanged(Ch: Char; CharPos: TPoint);
    procedure BeginDelChanged(Ch: Char; CharPos: TPoint; Return: Boolean);
    procedure LoadFromFile(const FileName: String);
    procedure SaveToFile(const FileName: String);
    procedure VertScroll(Sender: TObject);
    procedure HorzScroll(Sender: TObject);
    procedure DrawTransparentBmp(Cnv: TCanvas; x,y: Integer; Bmp: TBitmap; clTransparent: TColor);
    procedure DebugPaint(Sender: TObject);
    procedure DebugClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure NumPaint(Sender: TObject);
    procedure Paint(Sender: TObject);
    procedure SetFon(Color: TColor);
    function GetSelectedText: String;
    procedure CopyToClipBoard;
    procedure CopyFromClipBoard;
    procedure ReCalcScrollRange;
    procedure HideSelection;
    procedure GoScan;
    procedure SetScanStartLine(LineN: Integer);
    procedure ValignWindowIfCursorHide;
    procedure AlignWindowIfCursorHide;
    function  TextSelected: Boolean;
    function TextSelectedForFind: String;
    procedure CheckMaxLineLen(str: String);
    procedure ScanMaxLineLen;
    procedure InsertText;
    procedure DeleteText;
    procedure SetCursor(X,Y: Integer);
    function  GetVertScrollPos: Integer;
    procedure ScrollTo(Y: Integer);
    procedure RefJumpTo(X,Y: Integer; BackDocID, BackY: Integer);
    procedure SelectAll;
    procedure ActionAdd(AType: TActionType; BeginPos, EndPos: TPoint; Text, ReplText: String; RBlock: Boolean; Ref: PReplaceRec);
    procedure SwapUR(URType: TURType);
    procedure Undo;
    procedure Redo;
    procedure InsertTextBlock(Text: String; BeginY, BeginX: Integer);
    function DeleteTextBlock(BeginPos, EndPos: TPoint): String;
    procedure DeleteTx;
    procedure DeleteSelection;
    procedure DeleteChar;
    procedure Paste;
    procedure Cut;
    procedure SetSelection(SelFrom, SelTo: TPoint);
    function FindFirst(FindState: TState; str: String): Boolean;
    function Find(FindState: TState; str: String; FromCursor, CaseSens, FindForward: Boolean): Boolean;
    function CalcAll(FindState: TState; str: String): Integer;
    function CalcFind(str: String; FromCursor, CaseSens, FindForward: Boolean): Integer;
    procedure FindAndSelectAll(const str: String; FindState: TState);
    function Replace(str, ReplaceText: String; FindForward, FromCursor, CaseSens: Boolean): Integer;
    function ReplaceAll(str, ReplaceText: String; FindForward, FromCursor, CaseSens: Boolean): Integer;
    procedure InsertWord(Word: String; PrefLen: Integer; Replace, Suffix: Boolean);
    procedure ScanAfterInsertWord;
    procedure AddCurlPHP(X,Y: Integer; Level: Integer; Tp: Byte);
    procedure AddCurlJS(X,Y: Integer; Level: Integer; Tp: Byte);
    procedure RescanCurlBlocksPHP(StartLine: Integer);
    procedure RescanCurlBlocksJS(StartLine: Integer);
    procedure AddState(var StateAr: TStateArray; LineN:Integer; State: TState; var NewPos: Integer; j: Integer);
    procedure ScanText(var StateAr: TStateArray);
    procedure ScanTree;
    procedure ResetScaner(StartLine: Integer);
    procedure ResetTreeScaner;
    procedure AssignMainMenu(UndoMenu, RedoMenu, SaveMenu, SaveAllMenu,
                             CutMenu, CopyMenu, DelMenu: TMenuItem;
                             UndoBtn, RedoBtn, SaveBtn, SaveAllBtn,
                             CutBtn, CopyBtn: TToolButton;
                             pmCutMenu, pmCopyMenu, pmDeleteMenu: TMenuItem;
                             sbStatusBar: TStatusBar; PrintDlg: TPrintDialog; SepLn: Boolean;
                             BLEdg: Boolean; EncodeHead: TMenuItem);

    procedure AssignScanList(lsPHPReservList, lsPHPFuncList, lsHtmlTagList,
                             lsHtmlAttrList, lsHtmlMethodsList, lsJSObjectList, lsJSMethodsList,
                             lsJSPropList, lsJSReservList, lsCSSAttrList,
                             lsCSSValList: TStringList);
    procedure StopTimers;
    function Modified: Boolean;
    procedure CommitModify;
    procedure Modify;
    procedure SetDocPath(Path: String);
    function GetDocPath: String;
    function GetDocState: TDocState;
    procedure SetDocState(DocState: TDocState);
    function GetLineCount: Integer;
    function GetUndoCount: Integer;
    function GetRedoCount: Integer;
    procedure Terminate;
    procedure CanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure NumMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure NumClick(Sender: TObject);
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    function IsCharPrint(Key: Char): Boolean;
    function IsCorrectIdent(const Ident: String): Boolean;
    procedure DblClick(Sender: TObject);
    procedure ProcRepaintTimer(Sender: TObject);
    procedure ProcRepaintWaitTimer(Sender: TObject);
    procedure ProcOpenTimer(Sender: TObject);
    procedure ProcDblClickTimer(Sender: TObject);
    procedure ProcCaretMerguTimer(Sender: TObject);
    procedure ProcTreeTimer(Sender: TObject);
    procedure ProcClassFunc(Sender: TObject);
    function CreateScreenAnchorBox: Integer;
    procedure FreeScreenAnchorBox;
    function GetPref: String;
    function GetPlaceState: TDocPlaceInfo;
    function GetCaretChar: Char;
    procedure DecCaretX;
    function CurrentScanLineNo: Integer;
    procedure RunCursor;
    procedure StopCursor;
    procedure Print;
    procedure ShiftBlockLeft;
    procedure ShiftBlockRight;
    procedure ScrollLineUp;
    procedure ScrollLineDown;
    procedure Update;
    procedure ReScale;
    procedure TransCode(const Encoding: String);
    function GetPaintWndHeight: Integer;
    procedure SendKeyDown(Key: Word);
    procedure SendKeyPress(Ch: Char);
    function GetHelpFuncStr: String;
    procedure ScrollRepaint;
    function GetStatePos(X,Y: Integer): TState;
    procedure SetFollowRef(Line, PosFrom, PosTo: Integer; Ident: String; Move: Boolean);
    procedure AddBreakPointToList(LineNo: Integer);
    procedure ClearBreakPoints;
    property ID: Integer read FID write FID;
    property CaretPos: TPoint read FCaretPos;
    property ScanMode: TScanMode read FScanMode write FScanMode;
    property FilterIndex: Integer read FFilterIndex write FFilterIndex;
    property ScreenAnchorBox: TControl read FScreenAnchorBox write FScreenAnchorBox;
    property SepLinePaint: Boolean read FSepLinePaint write FSepLinePaint;
    property BlockEdgingPaint: Boolean read FBlockEdgingPaint write FBlockEdgingPaint;
    property StartLine: Integer read FStartLine;
    property PHPUserClassList: TStringList read FPHPUserClassList;
    property PHPUserFuncList: TStringList read FPHPUserFuncList;
    property LineStateAr: TStateArray read FLineStateAr;
    property HorsStartPos: Integer read FHorsStartPos;
    property DocMap: TObject read FDocMap write FDocMap;
    property ClassView: TTreeView read FClassView write FClassView;
    property CharWidth: Integer read FCharWidth write FCharWidth;
    property LineHeight: Integer read FLineHeight write FLineHeight;
    property SuspendTree: Boolean read FSuspendTree write FSuspendTree;
    property MouseX: Integer read FMouseX;
    property MouseY: Integer read FMouseY;
    property FollowRef: Boolean read FFollowRef;
    property InScanTree: Boolean read FInScanTree;
    property TreeScanWaitTick: Integer read FTreeScanWaitTick write FTreeScanWaitTick;
    property ClassFuncWaitTick: Integer read FClassFuncWaitTick write FClassFuncWaitTick;
    property DebugBox: TPaintBox read FDebugBox write FDebugBox;
    property DebugConnectionID: Integer read FDebugConnectionID write FDebugConnectionID;
    property IsMainDebugStack: Boolean read FIsMainDebugStack write FIsMainDebugStack;
    property DebugCurLine: Integer read FDebugCurLine write FDebugCurLine;
    property DebugStatus: String read FDebugStatus write FDebugStatus;
    property PaintBox: TPaintBox read FPaintBox write FPaintBox;
    property NumBox: TPaintBox read FNumBox write FNumBox;
    property TreeTimer: TTimer read FTreeTimer write FTreeTimer;
    property InScan: Boolean read FInScan write FInScan;
    property StringList: TStringList read FStringList write FStringList;
    property DebugBreakPointArray: TBreakPointArray read FDebugBreakPointArray write FDebugBreakPointArray;
    constructor Create(AOwner: TWinControl);
    destructor Destroy; override;
  end;

implementation

{$R PHPEdit.res}

uses SysUtils, Main, DateUtils, StrUtils, TypInfo, WordBoxInit, DocumentMap,
     StyleConfigurator;

procedure TEditScrollBar.WMCtlColor(var Message: TWMCtlColor);
begin
  Message.Result := CreateSolidBrush(RGB(255, 255, 255));
end;

procedure TPHPEdit.ScrollRepaint;
begin
  FVertScrollBar.StyleElements := [];
  FHorzScrollBar.StyleElements := [];
end;

function TPHPEdit.GetStatePos(X,Y: Integer): TState;
var
  i: Integer;
begin
  Result := ScanNull;
  if (FLineStateAr[Y].Max = 0) and (Length(FLineStateAr[Y].J) = 0) then begin
    Exit;
  end;
  for i := 0 to FLineStateAr[Y].Max do begin
    if FLineStateAr[Y].J[i] > X then begin
      if (i > 0) then begin
        Result := FLineStateAr[Y].Pos[i-1];
      end;
      Break;
    end;
  end;
end;

procedure TPHPEdit.SetFollowRef(Line, PosFrom, PosTo: Integer; Ident: String; Move: Boolean);
begin
  FFollowRef := Move;
  FFollowRefLine := Line;
  FFollowRefPosFrom := PosFrom;
  FFollowRefPosTo := PosTo;
  FFollowStr := Ident;
  FPaintBox.Repaint;
end;

procedure TPHPEdit.AddBreakPointToList(LineNo: Integer);
begin
  SetLength(FDebugBreakPointArray, Length(FDebugBreakPointArray) + 1);
  FDebugBreakPointArray[Length(FDebugBreakPointArray) - 1] := LineNo;
end;

procedure TPHPEdit.ClearBreakPoints;
begin
  SetLength(FDebugBreakPointArray, 0);
end;


constructor TPHPEdit.Create(AOwner: TWinControl);
begin
  inherited Create(AOwner);
  Parent := AOwner;

  FDebugConnectionID := -1;

  FFonColor := clWhite;
  FLineHeight := 17;
  FCharWidth := 8;
  FCaretPos.X := 1;
  FCaretPos.Y := 0;

  FStringList := TStringList.Create;
  FStringList.Add('');

  SetLength(FLineStateAr, 2);
  SetLength(FLineStateAr[0].Pos, 10);
  SetLength(FLineStateAr[0].J, 10);

  BevelOuter := bvLowered;
  Align := alClient;
  Color := FFonColor;
  DoubleBuffered := True;
  ControlStyle := ControlStyle + [csOpaque];

  FVertScrollBar := TEditScrollBar.Create(Self);
  FVertScrollBar.Parent := Self;
  FVertScrollBar.Kind := sbVertical;
  FVertScrollBar.Align := alRight;
  FVertScrollBar.OnChange := VertScroll;
  FVertScrollBar.TabStop := False;
  FVertScrollBar.Max := 1;
  FVertScrollBar.PageSize := 1;

  FHorzScrollPanel := TPanel.Create(Self);
  FHorzScrollPanel.Parent := Self;
  FHorzScrollPanel.Align := alBottom;
  FHorzScrollPanel.BevelOuter := bvNone;
  FHorzScrollPanel.Height := 17;

  FScrollSeparator := TControl.Create(FHorzScrollPanel);
  FScrollSeparator.Parent := FHorzScrollPanel;
  FScrollSeparator.Align := alRight;
  FScrollSeparator.Width := FVertScrollBar.Width;
  FScrollSeparator.Height := FVertScrollBar.Width;

  FHorzScrollBar := TEditScrollBar.Create(FHorzScrollPanel);
  FHorzScrollBar.Parent := FHorzScrollPanel;
  FHorzScrollBar.Kind := sbHorizontal;
  FHorzScrollBar.Align := alClient;
  FHorzScrollBar.OnChange := HorzScroll;
  FHorzScrollBar.TabStop := False;
  FHorzScrollBar.Max := 100;
  FHorzScrollBar.PageSize := 10;
  FHorzScrollPanel.Height := FVertScrollBar.Width;

  FNumBox := TPaintBox.Create(Self);
  FNumBox.Parent := Self;
  FNumBox.Align := alLeft;
  FNumBox.Width := 50;
  FNumBox.OnPaint := NumPaint;
  FNumBox.OnMouseMove := NumMouseMove;
  FNumBox.OnClick := NumClick;

  FDebugBox := TPaintBox.Create(Self);
  FDebugBox.Parent := Self;
  FDebugBox.Align := alLeft;
  FDebugBox.Width := FLineHeight;
  FDebugBox.OnPaint := DebugPaint;
  FDebugBox.OnMouseDown := DebugClick;
  FDebugCurLine := -1;

  FPaintBox := TPaintBox.Create(Self);
  FPaintBox.Parent := Self;
  FPaintBox.ParentColor := false;
  FPaintBox.Align := alClient;
  FPaintBox.Cursor := crIBeam;
  FPaintBox.OnPaint := Paint;
  FPaintBox.OnMouseDown := MouseDown;
  FPaintBox.OnMouseMove := MouseMove;
  FPaintBox.OnMouseUp := MouseUp;
  FPaintBox.OnDblClick := DblClick;
  FPaintBox.Canvas.Pen.Mode := pmNotXor;
  FPaintBox.PopupMenu := MainFormPND.PopupMenu;

  OnCanResize := CanResize;
  Realign;
  predstate := ScanNormal;
  predj := 1;

  FRepaintTimer := TTimer.Create(nil);
  FRepaintTimer.Enabled := False;
  FRepaintTimer.Interval := 10;
  FRepaintTimer.OnTimer := ProcRepaintTimer;

  FRepaintWaitTimer := TTimer.Create(nil);
  FRepaintWaitTimer.Enabled := False;
  FRepaintWaitTimer.Interval := 500;
  FRepaintWaitTimer.OnTimer := ProcRepaintWaitTimer;

  FOpenTimer := TTimer.Create(nil);
  FOpenTimer.Enabled := False;
  FOpenTimer.Interval := 300;
  FOpenTimer.OnTimer := ProcOpenTimer;

  FDblClickTimer := TTimer.Create(nil);
  FDblClickTimer.Enabled := False;
  FDblClickTimer.Interval := 300;
  FDblClickTimer.OnTimer := ProcDblClickTimer;

  FCaretMerguTimer := TTimer.Create(nil);
  FCaretMerguTimer.Enabled := True;
  FCaretMerguTimer.Interval := 300;
  FCaretMerguTimer.OnTimer := ProcCaretMerguTimer;
  MergCounter := 0;

  FTreeTimer := TTimer.Create(nil);
  FTreeTimer.Enabled := False;
  FTreeTimer.Interval := 150;
  FTreeTimer.OnTimer := ProcTreeTimer;

  FClassFuncTimer := TTimer.Create(nil);
  FClassFuncTimer.Enabled := False;
  FClassFuncTimer.Interval := 150;
  FClassFuncTimer.OnTimer := ProcClassFunc;

  Realign;
  FPaintBox.Repaint;
  FNumBox.Repaint;

  FKeyChanged := False;
  FBkChanged := False;
  FDelChanged := False;
  SetLength(FUndoStack,0);
  SetLength(FRedoStack,0);

  FModified := False;
  ReturnState := ScanNull;
  FBigStringPartLen := 512;
  FPerProcessMessages := 100;

  FPHPUserClassList := TStringList.Create;
  FPHPUserFuncList := TStringList.Create;

  FBackDocID := -1;
  FBackY := -1;
  FBackRefY := -1;

  InScan := False;
  FInScanTree := False;
end;

destructor TPHPEdit.Destroy;
var
  i, PtrCounter: Integer;
  NextPtr, DelPtr: PReplaceRec;
  PtrArray: array of Pointer;
begin
  FRepaintTimer.Free;
  FRepaintWaitTimer.Free;
  FOpenTimer.Free;
  FDblClickTimer.Free;
  FCaretMerguTimer.Free;

  FStringList.Free;
  SetLength(FLineStateAr,0);

  FPHPReservList := nil;
  FPHPFuncList := nil;
  FHtmlTagList := nil;
  FHtmlAttrList := nil;
  FJSObjectList := nil;
  FJSMethodsList := nil;
  FJSPropList := nil;
  FJSReservList := nil;
  FCSSAttrList := nil;
  FCSSValList := nil;

  {----------------------------------------------------------------------------}
  PtrCounter := 0;
  for i := 0 to Length(FUndoStack) - 1 do begin
    NextPtr := FUndoStack[i].Ref;
    while NextPtr <> nil do begin
      NextPtr := NextPtr^.Next;
      Inc(PtrCounter);
    end;
  end;

  SetLength(PtrArray, PtrCounter);
  PtrCounter := 0;
  for i := 0 to Length(FUndoStack) - 1 do begin
    NextPtr := FUndoStack[i].Ref;
    while NextPtr <> nil do begin
      PtrArray[PtrCounter] := NextPtr;
      NextPtr := NextPtr^.Next;
      Inc(PtrCounter);
    end;
  end;

  for i := 0 to Length(PtrArray) - 1 do begin
    SetLength(PReplaceRec(PtrArray[i])^.Mask, 0);
    Dispose(PtrArray[i]);
  end;

  SetLength(PtrArray, 0);
  SetLength(FUndoStack, 0);
  {----------------------------------------------------------------------------}
  PtrCounter := 0;
  for i := 0 to Length(FRedoStack) - 1 do begin
    NextPtr := FRedoStack[i].Ref;
    while NextPtr <> nil do begin
      NextPtr := NextPtr^.Next;
      Inc(PtrCounter);
    end;
  end;

  SetLength(PtrArray, PtrCounter);
  PtrCounter := 0;
  for i := 0 to Length(FRedoStack) - 1 do begin
    NextPtr := FRedoStack[i].Ref;
    while NextPtr <> nil do begin
      PtrArray[PtrCounter] := NextPtr;
      NextPtr := NextPtr^.Next;
      Inc(PtrCounter);
    end;
  end;

  for i := 0 to Length(PtrArray) - 1 do begin
    SetLength(PReplaceRec(PtrArray[i])^.Mask, 0);
    Dispose(PtrArray[i]);
  end;

  SetLength(PtrArray, 0);
  SetLength(FRedoStack, 0);
  {----------------------------------------------------------------------------}
  FPHPUserClassList.Free;
  FPHPUserFuncList.Free;
  inherited Destroy;
end;

procedure TPHPEdit.SendKeyDown(Key: Word);
begin
  KeyDown(Key,[]);
end;

procedure TPHPEdit.SendKeyPress(Ch: Char);
begin
  KeyPress(Ch);
end;

function TPHPEdit.GetHelpFuncStr: String;
var
  i: Integer;
begin
  Result := '';
  if (FLineStateAr[FCaretPos.Y].Max = 0) and (Length(FLineStateAr[FCaretPos.Y].J) = 0) then Exit;
  if FCaretPos.Y < Length(FLineStateAr) then begin
    for i := 0 to FLineStateAr[FCaretPos.Y].Max do begin
      if FCaretPos.X-1 < FLineStateAr[FCaretPos.Y].J[i] then begin
        if i > 0 then begin
          if FLineStateAr[FCaretPos.Y].Pos[i-1] = ScanFunc then begin
            Result := Copy(FStringList[FCaretPos.Y],
                           FLineStateAr[FCaretPos.Y].J[i-1],
                           FLineStateAr[FCaretPos.Y].J[i] - FLineStateAr[FCaretPos.Y].J[i-1]);
          end;
        end;
        Break;
      end;
    end;
  end;
end;

procedure TPHPEdit.WMGetDlgCode(var Msg: TMessage);
begin
  inherited;
  Msg.Result := Msg.Result or DLGC_WANTARROWS or DLGC_WANTTAB;
end;

procedure TPHPEdit.AssignScanList(lsPHPReservList, lsPHPFuncList, lsHtmlTagList,
                                  lsHtmlAttrList, lsHtmlMethodsList, lsJSObjectList, lsJSMethodsList,
                                  lsJSPropList, lsJSReservList, lsCSSAttrList,
                                  lsCSSValList: TStringList);
begin
  FPHPReservList := lsPHPReservList;
  FPHPFuncList := lsPHPFuncList;
  FHtmlTagList := lsHtmlTagList;
  FHtmlAttrList := lsHtmlAttrList;
  FHtmlMethodsList := lsHtmlMethodsList;
  FJSObjectList := lsJSObjectList;
  FJSMethodsList := lsJSMethodsList;
  FJSPropList := lsJSPropList;
  FJSReservList := lsJSReservList;
  FCSSAttrList := lsCSSAttrList;
  FCSSValList := lsCSSValList;

  FPHPReservList.CaseSensitive := True;
  FPHPFuncList.CaseSensitive := True;
  FHtmlTagList.CaseSensitive := False;
  FHtmlAttrList.CaseSensitive := False;
  FHtmlMethodsList.CaseSensitive := False;
  FJSObjectList.CaseSensitive := True;
  FJSMethodsList.CaseSensitive := True;
  FJSPropList.CaseSensitive := True;
  FJSReservList.CaseSensitive := True;
  FCSSAttrList.CaseSensitive := False;
  FCSSValList.CaseSensitive := False;
end;


function TPHPEdit.GetDocPath: String;
begin
  Result := FDocPath;
end;

procedure TPHPEdit.SetDocPath(Path: String);
begin
  FDocPath := Path;
end;


function TPHPEdit.GetDocState: TDocState;
begin
  Result := FDocState;
end;

procedure TPHPEdit.SetDocState(DocState: TDocState);
begin
  FDocState := DocState;
end;

function  TPHPEdit.GetLineCount: Integer;
begin
  Result := FStringList.Count;
end;

procedure TPHPEdit.AssignMainMenu(UndoMenu, RedoMenu, SaveMenu, SaveAllMenu,
                                  CutMenu, CopyMenu, DelMenu: TMenuItem;
                                  UndoBtn, RedoBtn, SaveBtn, SaveAllBtn,
                                  CutBtn, CopyBtn: TToolButton;
                                  pmCutMenu, pmCopyMenu, pmDeleteMenu: TMenuItem;
                                  sbStatusBar: TStatusBar; PrintDlg: TPrintDialog; SepLn: Boolean;
                                  BLEdg: Boolean; EncodeHead: TMenuItem);
begin
  FUndoMenu := UndoMenu;
  FRedoMenu := RedoMenu;
  FUndoBtn := UndoBtn;
  FRedoBtn := RedoBtn;
  FSaveMenu := SaveMenu;
  FSaveAllMenu := SaveAllMenu;
  FSaveBtn := SaveBtn;
  FSaveAllBtn := SaveAllBtn;
  FCutBtn := CutBtn;
  FCopyBtn := CopyBtn;
  FCutMenu := CutMenu;
  FCopyMenu := CopyMenu;
  FDeleteMenu := DelMenu;
  FSepLinePaint := SepLn;
  FBlockEdgingPaint := BLEdg;
  FEncodingMenu := EncodeHead;
  {---------------------}
  FpmCut := pmCutMenu;
  FpmCopy := pmCopyMenu;
  FpmDelete := pmDeleteMenu;
  {---------------------}
  FStatusBar := sbStatusBar;
  FPrintDialog := PrintDlg;

  FStringList.EncodingStr := 'ANSI';
  FStatusBar.Panels[0].Text := ' Ln:' + IntToStr(FCaretPos.Y + 1);
  FStatusBar.Panels[1].Text := ' Col:' + IntToStr(FCaretPos.X);
  FStatusBar.Refresh;
end;

procedure TPHPEdit.StopTimers;
begin
  FRepaintTimer.Enabled := False;
  FRepaintWaitTimer.Enabled := False;
  FOpenTimer.Enabled := False;
  FDblClickTimer.Enabled := False;
  FCaretMerguTimer.Enabled := False;
end;

function TPHPEdit.Modified: Boolean;
begin
  Result := FModified;
end;

procedure TPHPEdit.CommitModify;
begin
  FModified := False;
end;

procedure TPHPEdit.Modify;
begin
  FModified := True;
  FUndoMenu.Enabled := True;
  FUndoBtn.Enabled := True;
  FSaveMenu.Enabled := True;
  FSaveBtn.Enabled := True;
  FSaveAllMenu.Enabled := True;
  FSaveAllBtn.Enabled := True;

  SetLength(FRedoStack,0);
  FRedoMenu.Enabled := False;
  FRedoBtn.Enabled := False;
end;

function TPHPEdit.GetUndoCount: Integer;
begin
  Result := Length(FUndoStack);
end;

function TPHPEdit.GetRedoCount: Integer;
begin
  Result := Length(FRedoStack);
end;

function TPHPEdit.CreateScreenAnchorBox: Integer;
begin
  FScreenAnchorBox := TControl.Create(Self);
  FScreenAnchorBox.Parent := Self;
  FScreenAnchorBox.Left := FCaretPos.X * FCharWidth;
  FScreenAnchorBox.Top := (FCaretPos.Y - FStartLine + 1) * FLineHeight;
  FScreenAnchorBox.Width := 0;
  FScreenAnchorBox.Height := 0;
  Result := FNumBox.Width;
end;

procedure TPHPEdit.FreeScreenAnchorBox;
begin
  FScreenAnchorBox.Free;
end;

function TPHPEdit.GetPref: String;
var
  i: Integer;
  str: String;
  Ch: Char;
begin
  for i := FCaretPos.X - 1 downto 1 do begin
    if i <= Length(FStringList[FCaretPos.Y]) then begin
      Ch := FStringList[FCaretPos.Y][i];
    end;
    if Ch in ['a'..'z','A'..'Z', '_', '-', ':'] then
      str := str + Ch
    else
      Break;
  end;

  Result := ReverseString(str);
end;

function TPHPEdit.GetPlaceState: TDocPlaceInfo;
var
  i,j: Integer;
  Br: Boolean;
  Ch: Char;
begin
  Result.PlaceState := ScanNull;
  Result.DocSmType := ScanMode;

  if (ScanMode <> smXML) and (ScanMode <> smTXT) then begin
    Br := False;
    for i := 1 to FLineStateAr[FCaretPos.Y].Max do begin
      for j := FLineStateAr[FCaretPos.Y].J[i-1] to FLineStateAr[FCaretPos.Y].J[i] - 1 do begin
        if j = FCaretPos.X - 1 then begin
          Result.PlaceState := FLineStateAr[FCaretPos.Y].Pos[i-1];
          if (Result.PlaceState = ScanDoubleQuoted) and (FCaretPos.X = FLineStateAr[FCaretPos.Y].J[i]) then  Result.PlaceState := ScanPHP;
          if (Result.PlaceState = ScanSingleQuoted) and (FCaretPos.X = FLineStateAr[FCaretPos.Y].J[i]) then  Result.PlaceState := ScanPHP;
          if (Result.PlaceState = ScanComment) and (FCaretPos.X = FLineStateAr[FCaretPos.Y].J[i]) then  Result.PlaceState := ScanPHP;

          if (Result.PlaceState = ScanSingQHTML) and (FCaretPos.X = FLineStateAr[FCaretPos.Y].J[i]) then  Result.PlaceState := ScanOpenHTML;
          if (Result.PlaceState = ScanDblQHTML) and (FCaretPos.X = FLineStateAr[FCaretPos.Y].J[i]) then  Result.PlaceState := ScanOpenHTML;

          if FLineStateAr[FCaretPos.Y].Pos[i] = ScanNormal then Result.PlaceState := ScanNormal;
          if FLineStateAr[FCaretPos.Y].Pos[i] = ScanCSSBody then Result.PlaceState := ScanCSSBody;
          if FLineStateAr[FCaretPos.Y].Pos[i] = ScanJSBody then Result.PlaceState := ScanJSBody;
          Br := True;
          Break;
        end;
      end;
      if Br then Break;
    end;
    if (FCaretPos.X = 1) and  (FLineStateAr[FCaretPos.Y].Pos[0] = ScanPHP) then  Result.PlaceState := ScanPHP;
    if (FCaretPos.X = 1) and  (FLineStateAr[FCaretPos.Y].Pos[0] = ScanNormal) then  Result.PlaceState := ScanNormal;
    if (FCaretPos.X = 1) and  (FLineStateAr[FCaretPos.Y].Pos[0] = ScanCSSBody) then  Result.PlaceState := ScanCSSBody;
    if (FCaretPos.X = 1) and  (FLineStateAr[FCaretPos.Y].Pos[0] = ScanJSBody) then  Result.PlaceState := ScanJSBody;
    //ScanCSSVal
    if Result.PlaceState = ScanCSSBody then begin
      for i := FCaretPos.X - 1 downto 1 do begin
        Ch := FStringList[FCaretPos.Y][i];
        if Ch in ['a'..'z','A'..'Z', '_', '-'] then
          //str := str + Ch
        else begin
          if Ch = ':' then Result.PlaceState := ScanCSSVal;
          Break;
        end;
      end;
    end;

  end;
end;

function TPHPEdit.GetCaretChar: Char;
begin
  if FCaretPos.X > 1 then
    Result := FStringList[FCaretPos.Y][FCaretPos.X-1];
end;

procedure TPHPEdit.DecCaretX;
begin
  Dec(FCaretPos.X);
  FPaintBox.Repaint;
end;

function TPHPEdit.CurrentScanLineNo: Integer;
begin
  Result := LineNo;
end;

procedure TPHPEdit.RunCursor;
begin
  FCaretMerguTimer.Enabled := True;
end;

procedure TPHPEdit.StopCursor;
begin
  FCaretMerguTimer.Enabled := False;
  if (MergCounter mod 2) <> 0  then Dec(MergCounter);
  FPaintBox.Repaint;
end;

procedure TPHPEdit.Print;
var
  Line: TextFile;
  i: integer;
begin
  if FPrintDialog.Execute then begin
    AssignPrn(Line);
    ReWrite(Line);
    Printer.Canvas.Font := Font;

    for i := 0 to FStringList.Count -1 do begin
      Writeln(Line, FStringList[i]);
    end;

    System.CloseFile(Line);
  end;
end;

procedure TPHPEdit.ShiftBlockLeft;
var
  BeginLine, EndLine, i: Integer;
  TLen, BLen: Integer;
  S: String;
  flag, modflag: Boolean;
  ReplTail, NextReplRtr: PReplaceRec;
begin
  if TextSelected then begin
    flag := False;
    if FSelectedRange[0].Y < FSelectedRange[1].Y then begin
      BeginLine := FSelectedRange[0].Y;
      EndLine := FSelectedRange[1].Y
    end else begin
      BeginLine := FSelectedRange[1].Y;
      EndLine := FSelectedRange[0].Y
    end;

    TLen := Length(FStringList[BeginLine]);
    BLen := Length(FStringList[EndLine]);

    for i := BeginLine to EndLine do begin
      S := FStringList[i];

      if Length(S) > 1 then begin
        if (S[1] = ' ') and (S[2] = ' ') then begin

          if not flag then begin
            New(ReplTail);
            ReplTail^.X := 1;
            ReplTail^.Y := i;
            ReplTail^.Next := nil;
            ActionAdd(actReplace, Point(0,0), Point(0,0), '  ', '', True, ReplTail);
            flag := True;
          end else begin
            New(NextReplRtr);
            NextReplRtr^.X := 1;
            NextReplRtr^.Y := i;
            NextReplRtr^.Next := nil;
            ReplTail^.Next := NextReplRtr;
            ReplTail := NextReplRtr;
          end;

          Delete(S, 1, 2);
          modflag := True;
        end
        else if(S[1] = ' ') and (S[2] <> ' ') then begin

          if not flag then begin
            New(ReplTail);
            ReplTail^.X := 1;
            ReplTail^.Y := i;
            ReplTail^.Next := nil;
            ActionAdd(actReplace, Point(0,0), Point(0,0), ' ', '', True, ReplTail);
            flag := True;
          end else begin
            New(NextReplRtr);
            NextReplRtr^.X := 1;
            NextReplRtr^.Y := i;
            NextReplRtr^.Next := nil;
            ReplTail^.Next := NextReplRtr;
            ReplTail := NextReplRtr;
          end;

          Delete(S, 1, 1);
          modflag := True;
        end;
      end;
      FStringList[i] := S;
    end;

    if FSelectedRange[0].Y = FSelectedRange[1].Y then begin
      Dec(FSelectedRange[0].X, TLen - Length(FStringList[BeginLine]));
      Dec(FSelectedRange[1].X, TLen - Length(FStringList[BeginLine]));
      Dec(FCaretPos.X, TLen - Length(FStringList[BeginLine]));
    end
    else if FSelectedRange[1].Y > FSelectedRange[0].Y then begin
      Dec(FSelectedRange[0].X, TLen - Length(FStringList[BeginLine]));
      Dec(FSelectedRange[1].X, BLen - Length(FStringList[EndLine]));
      if FCaretPos.Y = BeginLine then begin
        Dec(FCaretPos.X, TLen - Length(FStringList[BeginLine]));
      end;
      if FCaretPos.Y = EndLine then begin
        Dec(FCaretPos.X, BLen - Length(FStringList[EndLine]));
      end;
    end
    else if FSelectedRange[1].Y < FSelectedRange[0].Y then begin
      Dec(FSelectedRange[0].X, BLen - Length(FStringList[EndLine]));
      Dec(FSelectedRange[1].X, TLen - Length(FStringList[BeginLine]));
      if FCaretPos.Y = BeginLine then begin
        Dec(FCaretPos.X, TLen - Length(FStringList[BeginLine]));
      end;
      if FCaretPos.Y = EndLine then begin
        Dec(FCaretPos.X, BLen - Length(FStringList[EndLine]));
      end;      
    end;

    if FSelectedRange[0].X < 1 then FSelectedRange[0].X := 1;
    if FSelectedRange[1].X < 1 then FSelectedRange[1].X := 1;
    if FCaretPos.X < 1 then FCaretPos.X := 1;

    if modflag then Modify;

    FPaintBox.Repaint;
    ScanMaxLineLen;
    SetScanStartLine(BeginLine);
    ValignWindowIfCursorHide;
    AlignWindowIfCursorHide;
    GoScan;
  end;
end;

procedure TPHPEdit.ShiftBlockRight;
var
  BeginLine, EndLine, i: Integer;
  TLen, BLen: Integer;
  S: String;
  flag, modflag: Boolean;
  ReplTail, NextReplRtr: PReplaceRec;
begin
  if TextSelected then begin
    flag := False;
    if FSelectedRange[0].Y < FSelectedRange[1].Y then begin
      BeginLine := FSelectedRange[0].Y;
      EndLine := FSelectedRange[1].Y
    end else begin
      BeginLine := FSelectedRange[1].Y;
      EndLine := FSelectedRange[0].Y
    end;

    TLen := Length(FStringList[BeginLine]);
    BLen := Length(FStringList[EndLine]);

    for i := BeginLine to EndLine do begin
      S := FStringList[i];

      if Length(S) > 0 then begin
        if not flag then begin
          New(ReplTail);
          ReplTail^.X := 1;
          ReplTail^.Y := i;
          ReplTail^.Next := nil;
          ActionAdd(actReplace, Point(0,0), Point(0,0), '', '  ', True, ReplTail);
          flag := True;
        end else begin
          New(NextReplRtr);
          NextReplRtr^.X := 1;
          NextReplRtr^.Y := i;
          NextReplRtr^.Next := nil;
          ReplTail^.Next := NextReplRtr;
          ReplTail := NextReplRtr;
        end;

        Insert('  ', S, 1);
        modflag := True;
      end;
      FStringList[i] := S;
    end;

   if FSelectedRange[0].Y = FSelectedRange[1].Y then begin
      Inc(FSelectedRange[0].X, Length(FStringList[BeginLine]) - TLen);
      Inc(FSelectedRange[1].X, Length(FStringList[BeginLine]) - TLen);
      Inc(FCaretPos.X, Length(FStringList[BeginLine]) - TLen);
    end
    else if FSelectedRange[1].Y > FSelectedRange[0].Y then begin
      Inc(FSelectedRange[0].X, Length(FStringList[BeginLine]) - TLen);
      Inc(FSelectedRange[1].X, Length(FStringList[EndLine]) - BLen);
      if FCaretPos.Y = BeginLine then begin
        Inc(FCaretPos.X, Length(FStringList[BeginLine]) - TLen);
      end;
      if FCaretPos.Y = EndLine then begin
        Inc(FCaretPos.X, Length(FStringList[EndLine]) - BLen);
      end;
    end
    else if FSelectedRange[1].Y < FSelectedRange[0].Y then begin
      Inc(FSelectedRange[0].X, Length(FStringList[EndLine]) - BLen);
      Inc(FSelectedRange[1].X, Length(FStringList[BeginLine]) - TLen);
      if FCaretPos.Y = BeginLine then begin
        Inc(FCaretPos.X, Length(FStringList[BeginLine]) - TLen);
      end;
      if FCaretPos.Y = EndLine then begin
        Inc(FCaretPos.X, Length(FStringList[EndLine]) - BLen);
      end;
    end;

    if modflag then Modify;

    FPaintBox.Repaint;
    ScanMaxLineLen;
    SetScanStartLine(BeginLine);
    ValignWindowIfCursorHide;
    AlignWindowIfCursorHide;
    GoScan;
  end;
end;

procedure TPHPEdit.ScrollLineUp;
begin
  StopCursor;
  FVertScrollBar.Position := FVertScrollBar.Position - 1;
  if FVertScrollBar.Position + (FPaintBox.Height div FLineHeight) < FCaretPos.Y + 1 then begin
    FCaretPos.Y := FVertScrollBar.Position + (FPaintBox.Height div FLineHeight) - 1;
  end;
  FPaintBox.Repaint;
end;

procedure TPHPEdit.ScrollLineDown;
begin
  StopCursor;
  if FVertScrollBar.Position < FStringList.Count - 1 then begin
    FVertScrollBar.Position := FVertScrollBar.Position + 1;
  end;
  if FVertScrollBar.Position > FCaretPos.Y then begin
    FCaretPos.Y := FVertScrollBar.Position;
  end;
  FPaintBox.Repaint;  
end;

procedure TPHPEdit.TransCode(const Encoding: String);
var
  i: Integer;
begin
  FStringList.EncodingStr := Encoding;
  FStatusBar.Panels[2].Text := Encoding;

  Modify;  
  ReCalcScrollRange;
  ScanMaxLineLen;
  SetScanStartLine(0);
  GoScan;
end;

function TPHPEdit.GetPaintWndHeight: Integer;
begin
  Result := FPaintBox.Height;
end;

procedure TPHPEdit.DeleteTx;
var
  S: String;
begin
  if FSelectedRange[0].Y < FSelectedRange[1].Y then begin
    if not(FSelectedRange[0].Y <= LineNo) then Exit;
  end else begin
    if not(FSelectedRange[1].Y <= LineNo) then Exit;
  end;

  FCaretMerguTimer.Enabled := False;
  if (MergCounter mod 2) <> 0  then Dec(MergCounter);

  Modify;
  DeleteText;

  FCutMenu.Enabled := False;
  FCopyMenu.Enabled := False;
  FCutBtn.Enabled := False;
  FCopyBtn.Enabled := False;
  FDeleteMenu.Enabled := False;
  FpmCut.Enabled := False;
  FpmCopy.Enabled := False;
  FpmDelete.Enabled := False;

  FStatusBar.Panels[0].Text := ' Ln:' + IntToStr(FCaretPos.Y + 1);
  FStatusBar.Panels[1].Text := ' Col:' + IntToStr(FCaretPos.X);
end;

procedure TPHPEdit.DeleteChar;
var
  S: String;
begin
  FSRMove := False;

  if FCaretPos.X <= Length(FStringList[FCaretPos.Y]) then begin
    Modify;

    BeginDelChanged(FStringList[FCaretPos.Y][FCaretPos.X], FCaretPos, False);

    S := FStringList[FCaretPos.Y];
    Delete(S, FCaretPos.X, 1);
    FStringList[FCaretPos.Y] := S;
  end else begin
    if FCaretPos.Y + 1 < FStringList.Count then begin
      Modify;
      BeginDelChanged(#0,FCaretPos,True);

      S := FStringList[FCaretPos.Y] + FStringList[FCaretPos.Y + 1];
      FStringList[FCaretPos.Y] := S;
      FStringList.Delete(FCaretPos.Y + 1);
    end else begin
      //тупик
      FPaintBox.Repaint;
    end;
  end;

  SetScanStartLine(FCaretPos.Y);
  SetLength(FLineStateAr, FStringList.Count + 1);
  ReCalcScrollRange;
  CheckMaxLineLen(S);
  ValignWindowIfCursorHide;
  AlignWindowIfCursorHide;
  GoScan;
end;

procedure TPHPEdit.Paste;
begin
  if not(CaretPos.Y <= LineNo) then Exit;

  Modify;
  if TextSelected then begin
    DeleteText;  
  end;
  InsertText;

  FStatusBar.Panels[0].Text := ' Ln:' + IntToStr(FCaretPos.Y + 1);
  FStatusBar.Panels[1].Text := ' Col:' + IntToStr(FCaretPos.X);
end;

procedure TPHPEdit.Cut;
begin
  if FSelectedRange[0].Y < FSelectedRange[1].Y then begin
    if not(FSelectedRange[0].Y <= LineNo) then Exit;
    FStartLine := FSelectedRange[0].Y;
  end else begin
    if not(FSelectedRange[1].Y <= LineNo) then Exit;
    FStartLine := FSelectedRange[1].Y
  end;    

  SetScanStartLine(FStartLine);

  CopyToClipBoard;
  DeleteText;

  ValignWindowIfCursorHide;
  AlignWindowIfCursorHide;

  FCutMenu.Enabled := False;
  FCopyMenu.Enabled := False;
  FCutBtn.Enabled := False;
  FCopyBtn.Enabled := False;
  FDeleteMenu.Enabled := False;
  FpmCut.Enabled := False;
  FpmCopy.Enabled := False;
  FpmDelete.Enabled := False;

  Modify;
  HideSelection;

  FStatusBar.Panels[0].Text := ' Ln:' + IntToStr(FCaretPos.Y + 1);
  FStatusBar.Panels[1].Text := ' Col:' + IntToStr(FCaretPos.X);
end;

procedure TPHPEdit.SetSelection(SelFrom, SelTo: TPoint);
begin
  FSelectedRange[0].X := SelFrom.X;
  FSelectedRange[0].Y := SelFrom.Y;
  FSelectedRange[1].X := SelTo.X;
  FSelectedRange[1].Y := SelTo.Y;
  FCaretPos.X := SelTo.X;
  FCaretPos.Y := SelTo.Y;

  AlignWindowIfCursorHide;
  ValignWindowIfCursorHide;

  FPaintBox.Repaint;
end;

function TPHPEdit.FindFirst(FindState: TState; str: String): Boolean;
var
  i,j: Integer;
  FindPos: Integer;
  flag: Boolean;
begin
  flag := False;
  for i := 0 to FStringList.Count - 1 do begin
    FindPos := PosEx(str, FStringList[i], 1);
    if FindPos <> 0 then begin

       for j := 0 to FLineStateAr[i].Max do begin
        if FLineStateAr[i].J[j] > FindPos then begin
          if j > 0 then begin
            if FLineStateAr[i].Pos[j-1] = FindState then begin
              if (FindPos+Length(FFindTreeStr)+0  > Length(FStringList[i])) or
                 ((FStringList[i][FindPos+Length(FFindTreeStr)+0]) in Delim) then begin
                   SetSelection(Point(FindPos,i),Point(FindPos + Length(str),i));
                   flag := True;
                   Break;
              end;
            end;
          end;
        end;
      end;

    end;
    if flag then Break;
  end;

  Result := flag;
end;

function TPHPEdit.Find(FindState: TState; str: String; FromCursor, CaseSens, FindForward: Boolean): Boolean;
var
  i,j: Integer;
  FindPos: Integer;
  Offset: Integer;
  flag: Boolean;
begin
  if str = '' then Exit;

  Offset := FCaretPos.X;
  flag := False;

  if FindForward then begin
    if CaseSens then begin
      if FromCursor then begin
        for i := FCaretPos.Y to FStringList.Count - 1 do begin
          FindPos := PosEx(str, FStringList[i], Offset);

          if FindPos > 0 then begin
            if Integer(FindState) <> 255 then begin

               for j := 0 to FLineStateAr[i].Max do begin
                if FLineStateAr[i].J[j] > FindPos then begin
                  if j > 0 then begin
                    if FLineStateAr[i].Pos[j-1] = FindState then begin
                      if (FindPos+Length(FFindTreeStr)+0  > Length(FStringList[i])) or
                         ((FStringList[i][FindPos+Length(FFindTreeStr)+0]) in Delim) then begin
                           SetSelection(Point(FindPos,i),Point(FindPos + Length(str),i));
                           flag := True;
                           Break;
                      end;
                    end;
                  end;
                end;
              end;

            end
            else begin
              SetSelection(Point(FindPos,i),Point(FindPos + Length(str),i));
              flag := True;
              Break;
            end;
          end;
          Offset := 1;
          if flag then Break;
        end;
        {for i := FCaretPos.Y to FStringList.Count - 1 do begin
          FindPos := PosEx(str, FStringList[i], Offset);

          if FindPos > 0 then begin
            SetSelection(Point(FindPos,i),Point(FindPos + Length(str),i));
            flag := True;
            Break;
          end;
          Offset := 1;
        end; }
      end else begin
        for i := 0 to FStringList.Count - 1 do begin
          FindPos := PosEx(str, FStringList[i], 1);
          if FindPos <> 0 then begin
            SetSelection(Point(FindPos,i),Point(FindPos + Length(str),i));
            flag := True;
            Break;
          end;
        end;
      end;
    end else begin
      if FromCursor then begin
        for i := FCaretPos.Y to FStringList.Count - 1 do begin
          FindPos := PosEx(LowerCase(str), LowerCase(FStringList[i]), Offset);

          if FindPos > 0 then begin
            SetSelection(Point(FindPos,i),Point(FindPos + Length(str),i));
            flag := True;
            Break;
          end;
          Offset := 1;
        end;
      end else begin
        for i := 0 to FStringList.Count - 1 do begin
          FindPos := PosEx(LowerCase(str), LowerCase(FStringList[i]), 1);
          if FindPos <> 0 then begin
            SetSelection(Point(FindPos,i),Point(FindPos + Length(str),i));
            flag := True;
            Break;
          end;
        end;
      end;
    end;
  end else begin  //bacward
    if CaseSens then begin
      if FromCursor then begin
        Offset := Length(FStringList[FCaretPos.Y]) + 2 - FCaretPos.X;
        for i := FCaretPos.Y downto 0 do begin
          FindPos := PosEx(ReverseString(str), ReverseString(FStringList[i]), Offset);

          if FindPos > 0 then begin
            if Integer(FindState) <> 255 then begin
               for j := 0 to FLineStateAr[i].Max do begin
                FindPos := Length(FStringList[i]) - FindPos - Length(str) + 2;
                if FLineStateAr[i].J[j] > FindPos then begin
                  if j > 0 then begin
                    if FLineStateAr[i].Pos[j-1] = FindState then begin
                      if (FindPos+Length(FFindTreeStr)+0  > Length(FStringList[i])) or
                         ((FStringList[i][FindPos+Length(FFindTreeStr)+0]) in Delim) then begin
                           SetSelection(Point(FindPos + Length(str),i), Point(FindPos,i));
                           flag := True;
                           Break;
                      end;
                    end;
                  end;
                end;
              end;

            end
            else begin
              FindPos := Length(FStringList[i]) - FindPos - Length(str) + 2;
              SetSelection(Point(FindPos + Length(str),i), Point(FindPos,i));
              flag := True;
              Break;
            end;
          end;
          Offset := 1;
          if flag then Break;
        end;
      end else begin
        Offset := 1;
        for i := FStringList.Count - 1 downto 0 do begin
          FindPos := PosEx(ReverseString(str), ReverseString(FStringList[i]), Offset);

          if FindPos > 0 then begin
            FindPos := Length(FStringList[i]) - FindPos - Length(str) + 2;
            SetSelection(Point(FindPos + Length(str),i), Point(FindPos,i));
            flag := True;
            Break;
          end;
          Offset := 1;
        end;
      end;
    end else begin //not CaseSens
      if FromCursor then begin
        Offset := Length(FStringList[FCaretPos.Y]) + 2 - FCaretPos.X;
        for i := FCaretPos.Y downto 0 do begin
          FindPos := PosEx(LowerCase(ReverseString(str)), LowerCase(ReverseString(FStringList[i])), Offset);

          if FindPos > 0 then begin
            FindPos := Length(FStringList[i]) - FindPos - Length(str) + 2;
            SetSelection(Point(FindPos + Length(str),i), Point(FindPos,i));
            flag := True;
            Break;
          end;
          Offset := 1;
        end;
      end else begin
        Offset := 1;
        for i := FStringList.Count - 1 downto 0 do begin
          FindPos := PosEx(LowerCase(ReverseString(str)), LowerCase(ReverseString(FStringList[i])), Offset);

          if FindPos > 0 then begin
            FindPos := Length(FStringList[i]) - FindPos - Length(str) + 2;
            SetSelection(Point(FindPos + Length(str),i), Point(FindPos,i));
            flag := True;
            Break;
          end;
          Offset := 1;
        end;
      end;
    end;
  end;

  Result := flag;
end;

function TPHPEdit.CalcAll(FindState: TState; str: String): Integer;
var
  i, j, Offset, FindPos, Counter: Integer;
begin
  Offset := 1;
  Counter := 0;

  for i := 0 to FStringList.Count - 1 do begin
    FindPos := PosEx(str, FStringList[i], Offset);
    while FindPos <> 0 do begin
      if Integer(FindState) <> -1 then begin

        for j := 0 to FLineStateAr[i].Max do begin
          if FLineStateAr[i].J[j] > FindPos then begin
            if j > 0 then begin
              if FLineStateAr[i].Pos[j-1] = FindState then begin
                if (FindPos+Length(FFindTreeStr)+0  > Length(FStringList[i])) or
                   ((FStringList[i][FindPos+Length(FFindTreeStr)+0]) in Delim) then begin
                  Inc(Counter);
                  Break;
                end;
              end;
            end;
          end;
        end;

        Offset := FindPos + Length(str);
        FindPos := PosEx(str, FStringList[i], Offset);
      end else begin
        Inc(Counter);
        Offset := FindPos + Length(str);
        FindPos := PosEx(str, FStringList[i], Offset);
      end;
    end;
    Offset := 1;
  end;
  Result := Counter;
end;

function TPHPEdit.CalcFind(str: String; FromCursor, CaseSens, FindForward: Boolean): Integer;
var
  i: Integer;
  FindPos: Integer;
  Offset: Integer;
  Counter: Integer;
begin
  if str = '' then Exit;

  Counter := 0;

  if FindForward then begin
    if CaseSens then begin
      if FromCursor then begin
        Offset := FCaretPos.X;
        for i := FCaretPos.Y to FStringList.Count - 1 do begin
          FindPos := PosEx(str, FStringList[i], Offset);
          while FindPos <> 0 do begin
            Inc(Counter);
            Offset := FindPos + Length(str);
            FindPos := PosEx(str, FStringList[i], Offset);
          end;
          Offset := 1;
        end;
      end else begin
        Offset := 1;
        for i := 0 to FStringList.Count - 1 do begin
          FindPos := PosEx(str, FStringList[i], Offset);
          while FindPos <> 0 do begin
            Inc(Counter);
            Offset := FindPos + Length(str);
            FindPos := PosEx(str, FStringList[i], Offset);
          end;
          Offset := 1;
        end;
      end;
    end else begin
      if FromCursor then begin
        Offset := FCaretPos.X;
        for i := FCaretPos.Y to FStringList.Count - 1 do begin
          FindPos := PosEx(LowerCase(str), LowerCase(FStringList[i]), Offset);
          while FindPos <> 0 do begin
            Inc(Counter);
            Offset := FindPos + Length(str);
            FindPos := PosEx(LowerCase(str), LowerCase(FStringList[i]), Offset);
          end;
          Offset := 1;
        end;
      end else begin
        Offset := 1;
        for i := 0 to FStringList.Count - 1 do begin
          FindPos := PosEx(LowerCase(str), LowerCase(FStringList[i]), Offset);
          while FindPos <> 0 do begin
            Inc(Counter);
            Offset := FindPos + Length(str);
            FindPos := PosEx(LowerCase(str), LowerCase(FStringList[i]), Offset);
          end;
          Offset := 1;
        end;
      end;
    end;
  end else begin   //bacward
    if CaseSens then begin
      if FromCursor then begin
        Offset := Length(FStringList[FCaretPos.Y]) + 2 - FCaretPos.X;
        for i := FCaretPos.Y downto 0 do begin
          FindPos := PosEx(ReverseString(str), ReverseString(FStringList[i]), Offset);
          while FindPos <> 0 do begin
            Inc(Counter);
            Offset := FindPos + Length(str);
            FindPos := PosEx(ReverseString(str), ReverseString(FStringList[i]), Offset);
          end;
          Offset := 1;
        end;
      end else begin
        Offset := 1;
        for i := FStringList.Count - 1 downto 0 do begin
          FindPos := PosEx(ReverseString(str), ReverseString(FStringList[i]), Offset);
          while FindPos <> 0 do begin
            Inc(Counter);
            Offset := FindPos + Length(str);
            FindPos := PosEx(ReverseString(str), ReverseString(FStringList[i]), Offset);
          end;
          Offset := 1;
        end;
      end;
    end else begin //not CaseSens
      if FromCursor then begin
        Offset := Length(FStringList[FCaretPos.Y]) + 2 - FCaretPos.X;
        for i := FCaretPos.Y downto 0 do begin
          FindPos := PosEx(ReverseString(LowerCase(str)), ReverseString(LowerCase(FStringList[i])), Offset);
          while FindPos <> 0 do begin
            Inc(Counter);
            Offset := FindPos + Length(str);
            FindPos := PosEx(ReverseString(ReverseString(str)), ReverseString(ReverseString(FStringList[i])), Offset);
          end;
          Offset := 1;
        end;
      end else begin
        Offset := 1;
        for i := FStringList.Count - 1 downto 0 do begin
          FindPos := PosEx(ReverseString(ReverseString(str)), ReverseString(ReverseString(FStringList[i])), Offset);
          while FindPos <> 0 do begin
            Inc(Counter);
            Offset := FindPos + Length(str);
            FindPos := PosEx(ReverseString(ReverseString(str)), ReverseString(ReverseString(FStringList[i])), Offset);
          end;
          Offset := 1;
        end;
      end;
    end;
  end;

  Result := Counter;
end;

procedure TPHPEdit.FindAndSelectAll(const str: String; FindState: TState);
begin
  FFindTreeStr := str;
  FFindTreeState := FindState;
  FFindTreeItem := True;
  FPaintBox.Repaint;
end;

function TPHPEdit.Replace(str, ReplaceText: String; FindForward, FromCursor, CaseSens: Boolean): Integer;
var
  i,j: Integer;
  FindPos: Integer;
  Offset: Integer;
  S, fnS: String;
  ReplTail: PReplaceRec;
begin
  if str = '' then Exit;

  Offset := FCaretPos.X;

  if FindForward then begin
    if CaseSens then begin
      if FromCursor then begin
        for i := FCaretPos.Y to FStringList.Count - 1 do begin
          FindPos := PosEx(str, FStringList[i], Offset);

          if FindPos > 0 then begin
            S := FStringList[i];
            {ActionAdd(actDelete, Point(FindPos,i), Point(FindPos + Length(str), i), Copy(S, FindPos, Length(str)), '', nil);
            Delete(S, FindPos, Length(str));
            ActionAdd(actInsert, Point(FindPos,i), Point(FindPos + Length(ReplaceText), i), ReplaceText, '', nil);
            Insert(ReplaceText, S, FindPos);}
            New(ReplTail);
            ReplTail^.X := FindPos;
            ReplTail^.Y := i;
            ReplTail^.Next := nil;
            ActionAdd(actReplace, Point(0,0), Point(0,0), str, ReplaceText, False, ReplTail);
            Delete(S, FindPos, Length(str));
            Insert(ReplaceText, S, FindPos);
                        
            FStringList[i] := S;
            SetSelection(Point(FindPos,i),Point(FindPos + Length(ReplaceText),i));
            Break;
          end;
          Offset := 1;
        end;
      end else begin
        for i := 0 to FStringList.Count - 1 do begin
          FindPos := PosEx(str, FStringList[i], 1);

          if FindPos > 0 then begin
            S := FStringList[i];
            {ActionAdd(actDelete, Point(FindPos,i), Point(FindPos + Length(str), i), Copy(S, FindPos, Length(str)), '', nil);
            Delete(S, FindPos, Length(str));
            ActionAdd(actInsert, Point(FindPos,i), Point(FindPos + Length(ReplaceText), i), ReplaceText, '', nil);
            Insert(ReplaceText, S, FindPos); }
            New(ReplTail);
            ReplTail^.X := FindPos;
            ReplTail^.Y := i;
            ReplTail^.Next := nil;
            ActionAdd(actReplace, Point(0,0), Point(0,0), str, ReplaceText, False, ReplTail);
            Delete(S, FindPos, Length(str));
            Insert(ReplaceText, S, FindPos);
                        
            FStringList[i] := S;
            SetSelection(Point(FindPos,i),Point(FindPos + Length(ReplaceText),i));
            Break;
          end;
          Offset := 1;
        end;
      end;
    end else begin
      if FromCursor then begin
        for i := FCaretPos.Y to FStringList.Count - 1 do begin
          FindPos := PosEx(LowerCase(str), LowerCase(FStringList[i]), Offset);

          if FindPos > 0 then begin
            S := FStringList[i];
            {ActionAdd(actDelete, Point(FindPos,i), Point(FindPos + Length(str), i), Copy(S, FindPos, Length(str)), '', nil);
            Delete(S, FindPos, Length(str));
            ActionAdd(actInsert, Point(FindPos,i), Point(FindPos + Length(ReplaceText), i), ReplaceText, '', nil);
            Insert(ReplaceText, S, FindPos);}
            New(ReplTail);
            ReplTail^.X := FindPos;
            ReplTail^.Y := i;
            ReplTail^.Next := nil;
            ActionAdd(actReplace, Point(0,0), Point(0,0), str, ReplaceText, False, ReplTail);

            fnS := Copy(S, FindPos, Length(str));
            if str <> fnS then begin
              SetLength(ReplTail^.Mask, Length(str));
              for j := 1 to Length(str) do begin
                if str[j] <> fnS[j] then begin
                  ReplTail^.Mask[j-1] := fnS[j];
                end else begin
                  ReplTail^.Mask[j-1] := #0;
                end;
              end;
            end;

            Delete(S, FindPos, Length(str));
            Insert(ReplaceText, S, FindPos);
                        
            FStringList[i] := S;
            SetSelection(Point(FindPos,i),Point(FindPos + Length(ReplaceText),i));
            Break;
          end;
          Offset := 1;
        end;
      end else begin
        for i := 0 to FStringList.Count - 1 do begin
          FindPos := PosEx(LowerCase(str), LowerCase(FStringList[i]), 1);

          if FindPos > 0 then begin
            S := FStringList[i];
            {ActionAdd(actDelete, Point(FindPos,i), Point(FindPos + Length(str), i), Copy(S, FindPos, Length(str)), '', nil);
            Delete(S, FindPos, Length(str));
            ActionAdd(actInsert, Point(FindPos,i), Point(FindPos + Length(ReplaceText), i), ReplaceText, '', nil);
            Insert(ReplaceText, S, FindPos);}
            New(ReplTail);
            ReplTail^.X := FindPos;
            ReplTail^.Y := i;
            ReplTail^.Next := nil;
            ActionAdd(actReplace, Point(0,0), Point(0,0), str, ReplaceText, False, ReplTail);

            fnS := Copy(S, FindPos, Length(str));
            if str <> fnS then begin
              SetLength(ReplTail^.Mask, Length(str));
              for j := 1 to Length(str) do begin
                if str[j] <> fnS[j] then begin
                  ReplTail^.Mask[j-1] := fnS[j];
                end else begin
                  ReplTail^.Mask[j-1] := #0;
                end;
              end;
            end;
                          
            Delete(S, FindPos, Length(str));
            Insert(ReplaceText, S, FindPos);
                        
            FStringList[i] := S;
            SetSelection(Point(FindPos,i),Point(FindPos + Length(ReplaceText),i));
            Break;
          end;
          Offset := 1;
        end;
      end;
    end;
  end else begin   //backward
    if CaseSens then begin
      if FromCursor then begin
        Offset := Length(FStringList[FCaretPos.Y]) + 2 - FCaretPos.X;
        for i := FCaretPos.Y downto 0 do begin
          FindPos := PosEx(ReverseString(str), ReverseString(FStringList[i]), Offset);

          if FindPos > 0 then begin
            FindPos := Length(FStringList[i]) - FindPos - Length(str) + 2;
            S := FStringList[i];
            {ActionAdd(actDelete, Point(FindPos,i), Point(FindPos + Length(str), i), Copy(S, FindPos, Length(str)), '', nil);
            Delete(S, FindPos, Length(str));
            ActionAdd(actInsert, Point(FindPos,i), Point(FindPos + Length(ReplaceText), i), ReplaceText, '', nil);
            Insert(ReplaceText, S, FindPos);}
            New(ReplTail);
            ReplTail^.X := FindPos;
            ReplTail^.Y := i;
            ReplTail^.Next := nil;
            ActionAdd(actReplace, Point(0,0), Point(0,0), str, ReplaceText, False, ReplTail);
            Delete(S, FindPos, Length(str));
            Insert(ReplaceText, S, FindPos);            

            FStringList[i] := S;
            SetSelection(Point(FindPos + Length(ReplaceText),i), Point(FindPos,i));
            Break;
          end;
          Offset := 1;
        end;
      end else begin
        Offset := 1;
        for i := FStringList.Count - 1 downto 0 do begin
          FindPos := PosEx(ReverseString(str), ReverseString(FStringList[i]), Offset);

          if FindPos > 0 then begin
            FindPos := Length(FStringList[i]) - FindPos - Length(str) + 2;
            S := FStringList[i];
            {ActionAdd(actDelete, Point(FindPos,i), Point(FindPos + Length(str), i), Copy(S, FindPos, Length(str)), '', nil);
            Delete(S, FindPos, Length(str));
            ActionAdd(actInsert, Point(FindPos,i), Point(FindPos + Length(ReplaceText), i), ReplaceText, '', nil);
            Insert(ReplaceText, S, FindPos);}
            New(ReplTail);
            ReplTail^.X := FindPos;
            ReplTail^.Y := i;
            ReplTail^.Next := nil;
            ActionAdd(actReplace, Point(0,0), Point(0,0), str, ReplaceText, False, ReplTail);
            Delete(S, FindPos, Length(str));
            Insert(ReplaceText, S, FindPos);
                        
            FStringList[i] := S;
            SetSelection(Point(FindPos + Length(ReplaceText),i), Point(FindPos,i));
            Break;
          end;
          Offset := 1;
        end;
      end;
    end else begin //not CaseSens
      if FromCursor then begin
        Offset := Length(FStringList[FCaretPos.Y]) + 2 - FCaretPos.X;
        for i := FCaretPos.Y downto 0 do begin
          FindPos := PosEx(LowerCase(ReverseString(str)), LowerCase(ReverseString(FStringList[i])), Offset);

          if FindPos > 0 then begin
            FindPos := Length(FStringList[i]) - FindPos - Length(str) + 2;
            S := FStringList[i];
            {ActionAdd(actDelete, Point(FindPos,i), Point(FindPos + Length(str), i), Copy(S, FindPos, Length(str)), '', nil);
            Delete(S, FindPos, Length(str));
            ActionAdd(actInsert, Point(FindPos,i), Point(FindPos + Length(ReplaceText), i), ReplaceText, '', nil);
            Insert(ReplaceText, S, FindPos); }
            New(ReplTail);
            ReplTail^.X := FindPos;
            ReplTail^.Y := i;
            ReplTail^.Next := nil;
            ActionAdd(actReplace, Point(0,0), Point(0,0), str, ReplaceText, False, ReplTail);

            fnS := Copy(S, FindPos, Length(str));
            if str <> fnS then begin
              SetLength(ReplTail^.Mask, Length(str));
              for j := 1 to Length(str) do begin
                if str[j] <> fnS[j] then begin
                  ReplTail^.Mask[j-1] := fnS[j];
                end else begin
                  ReplTail^.Mask[j-1] := #0;
                end;
              end;
            end;

            Delete(S, FindPos, Length(str));
            Insert(ReplaceText, S, FindPos);

            FStringList[i] := S;
            SetSelection(Point(FindPos + Length(ReplaceText),i), Point(FindPos,i));
            Break;
          end;
          Offset := 1;
        end;
      end else begin
        Offset := 1;
        for i := FStringList.Count - 1 downto 0 do begin
          FindPos := PosEx(LowerCase(ReverseString(str)), LowerCase(ReverseString(FStringList[i])), Offset);

          if FindPos > 0 then begin
            FindPos := Length(FStringList[i]) - FindPos - Length(str) + 2;
            S := FStringList[i];
            {ActionAdd(actDelete, Point(FindPos,i), Point(FindPos + Length(str), i), Copy(S, FindPos, Length(str)), '', nil);
            Delete(S, FindPos, Length(str));
            ActionAdd(actInsert, Point(FindPos,i), Point(FindPos + Length(ReplaceText), i), ReplaceText, '', nil);
            Insert(ReplaceText, S, FindPos);}
            New(ReplTail);
            ReplTail^.X := FindPos;
            ReplTail^.Y := i;
            ReplTail^.Next := nil;
            ActionAdd(actReplace, Point(0,0), Point(0,0), str, ReplaceText, False, ReplTail);
            fnS := Copy(S, FindPos, Length(str));

            if str <> fnS then begin
              SetLength(ReplTail^.Mask, Length(str));
              for j := 1 to Length(str) do begin
                if str[j] <> fnS[j] then begin
                  ReplTail^.Mask[j-1] := fnS[j];
                end else begin
                  ReplTail^.Mask[j-1] := #0;
                end;
              end;
            end;

            Delete(S, FindPos, Length(str));
            Insert(ReplaceText, S, FindPos);

            FStringList[i] := S;
            SetSelection(Point(FindPos + Length(ReplaceText),i), Point(FindPos,i));
            Break;
          end;
          Offset := 1;
        end;
      end;
    end;
  end;

  Result := 1;

  Modify;
  SetScanStartLine(FCaretPos.Y);
  CheckMaxLineLen(FStringList[FCaretPos.Y]);
  ValignWindowIfCursorHide;
  AlignWindowIfCursorHide;
  GoScan;
end;

function TPHPEdit.ReplaceAll(str, ReplaceText: String; FindForward, FromCursor, CaseSens: Boolean): Integer;
var
  i,j: Integer;
  FindPos: Integer;
  Offset: Integer;
  S, STail, fnS: String;
  ReplCounter: Integer;
  flag: Boolean;
  ReplTail, NextReplRtr: PReplaceRec;
begin
  if str = '' then Exit;
  ReplCounter := 0;

  if FindForward then begin
    if CaseSens then begin
      if FromCursor then begin
        flag := False;
        Offset := FCaretPos.X;
        
        for i := FCaretPos.Y to FStringList.Count - 1 do begin
          FindPos := PosEx(str, FStringList[i], Offset);

          while FindPos <> 0 do begin
            if not flag then begin
              New(ReplTail);
              ReplTail^.X := FindPos;
              ReplTail^.Y := i;
              ReplTail^.Next := nil;
              ActionAdd(actReplace, Point(0,0), Point(0,0), str, ReplaceText, False, ReplTail);
              flag := True;
            end else begin
              New(NextReplRtr);
              NextReplRtr^.X := FindPos;
              NextReplRtr^.Y := i;
              NextReplRtr^.Next := nil;
              ReplTail^.Next := NextReplRtr;
              ReplTail := NextReplRtr;
            end;

            S := FStringList[i];
            Delete(S, FindPos, Length(str));
            Insert(ReplaceText, S, FindPos);
            FStringList[i] := S;

            Inc(ReplCounter);
            Offset := FindPos + Length(ReplaceText);
            FindPos := PosEx(str, FStringList[i], Offset);
          end;

          Offset := 1;
        end;
      end else begin
        flag := False;
        Offset := 1;

        for i := 0 to FStringList.Count - 1 do begin
          FindPos := PosEx(str, FStringList[i], Offset);

          while FindPos <> 0 do begin
            if not flag then begin
              New(ReplTail);
              ReplTail^.X := FindPos;
              ReplTail^.Y := i;
              ReplTail^.Next := nil;
              ActionAdd(actReplace, Point(0,0), Point(0,0), str, ReplaceText, False, ReplTail);
              flag := True;
            end else begin
              New(NextReplRtr);
              NextReplRtr^.X := FindPos;
              NextReplRtr^.Y := i;
              NextReplRtr^.Next := nil;
              ReplTail^.Next := NextReplRtr;
              ReplTail := NextReplRtr;
            end;

            S := FStringList[i];
            Delete(S, FindPos, Length(str));
            Insert(ReplaceText, S, FindPos);
            FStringList[i] := S;

            Inc(ReplCounter);
            Offset := FindPos + Length(ReplaceText);
            FindPos := PosEx(str, FStringList[i], Offset);
          end;

          Offset := 1;
        end;
      end;
    end else begin //not CaseSens
      if FromCursor then begin
        flag := False;
        Offset := FCaretPos.X;

        for i := FCaretPos.Y to FStringList.Count - 1 do begin
          FindPos := PosEx(LowerCase(str), LowerCase(FStringList[i]), Offset);

          while FindPos <> 0 do begin
            if not flag then begin
              New(ReplTail);
              ReplTail^.X := FindPos;
              ReplTail^.Y := i;
              ReplTail^.Next := nil;
              ActionAdd(actReplace, Point(0,0), Point(0,0), str, ReplaceText, False, ReplTail);
              flag := True;
            end else begin
              New(NextReplRtr);
              NextReplRtr^.X := FindPos;
              NextReplRtr^.Y := i;
              NextReplRtr^.Next := nil;
              ReplTail^.Next := NextReplRtr;
              ReplTail := NextReplRtr;
            end;

            S := FStringList[i];

            fnS := Copy(S, FindPos, Length(str));
            if str <> fnS then begin
              SetLength(ReplTail^.Mask, Length(str));
              for j := 1 to Length(str) do begin
                if str[j] <> fnS[j] then begin
                  ReplTail^.Mask[j-1] := fnS[j];
                end else begin
                  ReplTail^.Mask[j-1] := #0;
                end;
              end;
            end;

            Delete(S, FindPos, Length(str));
            Insert(ReplaceText, S, FindPos);
            FStringList[i] := S;

            Inc(ReplCounter);
            Offset := FindPos + Length(ReplaceText);
            FindPos := PosEx(LowerCase(str), LowerCase(FStringList[i]), Offset);
          end;
          Offset := 1;
        end;
      end else begin
        flag := False;
        Offset := 1;

        for i := 0 to FStringList.Count - 1 do begin
          FindPos := PosEx(LowerCase(str), LowerCase(FStringList[i]), Offset);

          while FindPos <> 0 do begin
            if not flag then begin
              New(ReplTail);
              ReplTail^.X := FindPos;
              ReplTail^.Y := i;
              ReplTail^.Next := nil;
              ActionAdd(actReplace, Point(0,0), Point(0,0), str, ReplaceText, False, ReplTail);
              flag := True;
            end else begin
              New(NextReplRtr);
              NextReplRtr^.X := FindPos;
              NextReplRtr^.Y := i;
              NextReplRtr^.Next := nil;
              ReplTail^.Next := NextReplRtr;
              ReplTail := NextReplRtr;
            end;

            S := FStringList[i];

            fnS := Copy(S, FindPos, Length(str));
            if str <> fnS then begin
              SetLength(ReplTail^.Mask, Length(str));
              for j := 1 to Length(str) do begin
                if str[j] <> fnS[j] then begin
                  ReplTail^.Mask[j-1] := fnS[j];
                end else begin
                  ReplTail^.Mask[j-1] := #0;
                end;
              end;
            end;
                        
            Delete(S, FindPos, Length(str));
            Insert(ReplaceText, S, FindPos);
            FStringList[i] := S;

            Inc(ReplCounter);
            Offset := FindPos + Length(ReplaceText);
            FindPos := PosEx(LowerCase(str), LowerCase(FStringList[i]), Offset);
          end;

          Offset := 1;
        end;
      end;
    end;
  end else begin   //backward
    if CaseSens then begin
      if FromCursor then begin
        flag := False;
        Offset := 1;

        for i := 0 to FCaretPos.Y do begin
          if i = FCaretPos.Y then begin
            S := Copy(FStringList[i], 1, FCaretPos.X-1);
            STail := Copy(FStringList[i], FCaretPos.X, Length(S));
          end else
            S := FStringList[i];

          FindPos := PosEx(str, S, Offset);

          while FindPos <> 0 do begin
            if not flag then begin
              New(ReplTail);
              ReplTail^.X := FindPos;
              ReplTail^.Y := i;
              ReplTail^.Next := nil;
              ActionAdd(actReplace, Point(0,0), Point(0,0), str, ReplaceText, False, ReplTail);
              flag := True;
            end else begin
              New(NextReplRtr);
              NextReplRtr^.X := FindPos;
              NextReplRtr^.Y := i;
              NextReplRtr^.Next := nil;
              ReplTail^.Next := NextReplRtr;
              ReplTail := NextReplRtr;
            end;

            Delete(S, FindPos, Length(str));
            Insert(ReplaceText, S, FindPos);
            FStringList[i] := S;

            Inc(ReplCounter);
            Offset := FindPos + Length(ReplaceText);
            FindPos := PosEx(str, S, Offset);
          end;

          if i = FCaretPos.Y then
            FStringList[i] := S + STail;

          Offset := 1;
        end;
      end else begin
        flag := False;
        Offset := 1;

        for i := 0 to FStringList.Count - 1 do begin
          S := FStringList[i];
          FindPos := PosEx(str, S, Offset);
          
          while FindPos <> 0 do begin
            if not flag then begin
              New(ReplTail);
              ReplTail^.X := FindPos;
              ReplTail^.Y := i;
              ReplTail^.Next := nil;
              ActionAdd(actReplace, Point(0,0), Point(0,0), str, ReplaceText, False, ReplTail);
              flag := True;
            end else begin
              New(NextReplRtr);
              NextReplRtr^.X := FindPos;
              NextReplRtr^.Y := i;
              NextReplRtr^.Next := nil;
              ReplTail^.Next := NextReplRtr;
              ReplTail := NextReplRtr;
            end;

            Delete(S, FindPos, Length(str));
            Insert(ReplaceText, S, FindPos);
            FStringList[i] := S;

            Inc(ReplCounter);
            Offset := FindPos + Length(ReplaceText);
            FindPos := PosEx(LowerCase(str), S, Offset);
          end;

          FStringList[i] := S;
          Offset := 1;
        end;
      end;
    end else begin //not CaseSens
      if FromCursor then begin
        flag := False;
        Offset := 1;

        for i := 0 to FCaretPos.Y do begin
          if i = FCaretPos.Y then begin
            S := Copy(FStringList[i], 1, FCaretPos.X-1);
            STail := Copy(FStringList[i], FCaretPos.X, Length(S));
          end else
            S := FStringList[i];

          FindPos := PosEx(LowerCase(str), LowerCase(S), Offset);

          while FindPos <> 0 do begin
            if not flag then begin
              New(ReplTail);
              ReplTail^.X := FindPos;
              ReplTail^.Y := i;
              ReplTail^.Next := nil;
              ActionAdd(actReplace, Point(0,0), Point(0,0), str, ReplaceText, False, ReplTail);
              flag := True;
            end else begin
              New(NextReplRtr);
              NextReplRtr^.X := FindPos;
              NextReplRtr^.Y := i;
              NextReplRtr^.Next := nil;
              ReplTail^.Next := NextReplRtr;
              ReplTail := NextReplRtr;
            end;

            fnS := Copy(S, FindPos, Length(str));
            if str <> fnS then begin
              SetLength(ReplTail^.Mask, Length(str));
              for j := 1 to Length(str) do begin
                if str[j] <> fnS[j] then begin
                  ReplTail^.Mask[j-1] := fnS[j];
                end else begin
                  ReplTail^.Mask[j-1] := #0;
                end;
              end;
            end;
                        
            Delete(S, FindPos, Length(str));
            Insert(ReplaceText, S, FindPos);
            FStringList[i] := S;

            Inc(ReplCounter);
            Offset := FindPos + Length(ReplaceText);
            FindPos := PosEx(LowerCase(str), LowerCase(S), Offset);
          end;

          if i = FCaretPos.Y then
            FStringList[i] := S + STail;

          Offset := 1;
        end;
      end else begin
        flag := False;
        Offset := 1;

        for i := 0 to FStringList.Count - 1 do begin
          S := FStringList[i];
          FindPos := PosEx(LowerCase(str), LowerCase(S), Offset);
          
          while FindPos <> 0 do begin
            if not flag then begin
              New(ReplTail);
              ReplTail^.X := FindPos;
              ReplTail^.Y := i;
              ReplTail^.Next := nil;
              ActionAdd(actReplace, Point(0,0), Point(0,0), str, ReplaceText, False, ReplTail);
              flag := True;
            end else begin
              New(NextReplRtr);
              NextReplRtr^.X := FindPos;
              NextReplRtr^.Y := i;
              NextReplRtr^.Next := nil;
              ReplTail^.Next := NextReplRtr;
              ReplTail := NextReplRtr;
            end;

            fnS := Copy(S, FindPos, Length(str));
            if str <> fnS then begin
              SetLength(ReplTail^.Mask, Length(str));
              for j := 1 to Length(str) do begin
                if str[j] <> fnS[j] then begin
                  ReplTail^.Mask[j-1] := fnS[j];
                end else begin
                  ReplTail^.Mask[j-1] := #0;
                end;
              end;
            end;
                        
            Delete(S, FindPos, Length(str));
            Insert(ReplaceText, S, FindPos);
            FStringList[i] := S;

            Inc(ReplCounter);
            Offset := FindPos + Length(ReplaceText);
            FindPos := PosEx(LowerCase(str), LowerCase(S), Offset);
          end;

          FStringList[i] := S;
          Offset := 1;
        end;
      end;
    end;
  end;

  Result := ReplCounter;

  Modify;
  SetScanStartLine(0);
  ScanMaxLineLen;
  FPaintBox.Repaint;
  GoScan;
end;

procedure TPHPEdit.BeginKeyChanged(Ch: Char; CharPos: TPoint; Sp: String);
var
  TopIndex: Integer;
begin
  if (not FKeyChanged)  then begin
    FBkText := '';
    TopIndex := Length(FUndoStack);
    SetLength(FUndoStack, TopIndex + 1);
    FKeyChgBeginPos.X := CharPos.X;
    FKeyChgBeginPos.Y := CharPos.Y;
    FKeyChgEndPos.X := CharPos.X;
    FKeyChgEndPos.Y := CharPos.Y;
    FKeyChanged := True;
  end;

  if FKeyChanged then begin
    if ((CharPos.X) <> FKeyChgEndPos.X) or (CharPos.Y <> FKeyChgEndPos.Y {FKeyChgBeginPos.Y}) then begin
      FKeyChanged := False;
      BeginKeyChanged(Ch, CharPos, Sp);
    end else begin

      if Ch = #13 then begin
        FBkText := FBkText + #13#10 + Sp;
        FKeyChgEndPos.X := 1 + Length(Sp);
        CharPos.X := 1 + Length(Sp);
        Inc(FKeyChgEndPos.Y);
      end else begin
        Inc(FKeyChgEndPos.X);
        FBkText := FBkText + Ch;
      end;
        
      TopIndex := Length(FUndoStack) - 1;
      FUndoStack[TopIndex].ActType := actInsert;
      FUndoStack[TopIndex].Text := FBkText;
      FUndoStack[TopIndex].BeginPos.X := FKeyChgBeginPos.X;
      FUndoStack[TopIndex].BeginPos.Y := FKeyChgBeginPos.Y;
      FUndoStack[TopIndex].EndPos.X := FKeyChgEndPos.X;
      FUndoStack[TopIndex].EndPos.Y := FKeyChgEndPos.Y;
    end;
  end;
end;

procedure TPHPEdit.BeginBkSpaceChanged(Ch: Char; CharPos: TPoint);
var
  TopIndex: Integer;
begin
  if not FBkChanged then begin
    FBkText := '';
    TopIndex := Length(FUndoStack);
    SetLength(FUndoStack, TopIndex + 1);
    FKeyChgBeginPos.X := CharPos.X;
    FKeyChgBeginPos.Y := CharPos.Y;
    FKeyChgEndPos.X := CharPos.X;
    FKeyChgEndPos.Y := CharPos.Y;
    FBkChanged := True;
  end;

  if FBkChanged then begin
    if (((CharPos.X) <> FKeyChgBeginPos.X) or (CharPos.Y <> FKeyChgBeginPos.Y)) then begin
      FBkChanged := False;
      BeginBkSpaceChanged(Ch, CharPos);
    end else begin

      if (Ch = #8) then begin
        Dec(FKeyChgBeginPos.Y);
        FKeyChgBeginPos.X := Length(FStringList[CharPos.Y-1]) + 1;
        FBkText := FBkText + #10#13;
      end else begin
        Dec(FKeyChgBeginPos.X);
        FBkText := FBkText + Ch;
      end;

      TopIndex := Length(FUndoStack) - 1;
      FUndoStack[TopIndex].ActType := actDelete;
      FUndoStack[TopIndex].Text := ReverseString(FBkText);
      FUndoStack[TopIndex].BeginPos.X := FKeyChgBeginPos.X;
      FUndoStack[TopIndex].BeginPos.Y := FKeyChgBeginPos.Y;
      FUndoStack[TopIndex].EndPos.X := FKeyChgEndPos.X;
      FUndoStack[TopIndex].EndPos.Y := FKeyChgEndPos.Y;
    end;
  end;
end;

procedure TPHPEdit.BeginDelChanged(Ch: Char; CharPos: TPoint; Return: Boolean);
var
  TopIndex: Integer;
begin
  if not FDelChanged then begin
    FBkText := '';
    TopIndex := Length(FUndoStack);
    SetLength(FUndoStack, TopIndex + 1);
    FKeyChgBeginPos.X := CharPos.X;
    FKeyChgBeginPos.Y := CharPos.Y;
    FKeyChgEndPos.X := CharPos.X;
    FKeyChgEndPos.Y := CharPos.Y;
    FDelChanged := True;
  end;

  if FDelChanged then begin
    if (((CharPos.X) <> FKeyChgBeginPos.X) or (CharPos.Y <> FKeyChgBeginPos.Y)) then begin
      FDelChanged := False;
      BeginDelChanged(Ch, CharPos, Return);
    end else begin
      if Return then begin
        Inc(FKeyChgEndPos.Y);
        FKeyChgEndPos.X := 1;
        FBkText := #10#13 + FBkText;
      end else begin
        Inc(FKeyChgEndPos.X);
        FBkText := Ch + FBkText;
      end;


      TopIndex := Length(FUndoStack) - 1;
      FUndoStack[TopIndex].ActType := actDelete;
      FUndoStack[TopIndex].Text := ReverseString(FBkText);
      FUndoStack[TopIndex].BeginPos.X := FKeyChgBeginPos.X;
      FUndoStack[TopIndex].BeginPos.Y := FKeyChgBeginPos.Y;
      FUndoStack[TopIndex].EndPos.X := FKeyChgEndPos.X;
      FUndoStack[TopIndex].EndPos.Y := FKeyChgEndPos.Y;
    end;
  end;
end;

procedure TPHPEdit.LoadFromFile(const FileName: String);
var
  i,j: Integer;
  s: String;
begin
  HideSelection;
  FCaretPos.X := 1;
  FCaretPos.Y := 0;

  FPaintBox.Repaint;
  FNumBox.Repaint;

  FStringList.LoadFromFile(FileName);

  if FStringList.EncodingStr = 'ANSI' then
    FEncodingMenu.Items[0].Checked := True
  else
  if FStringList.EncodingStr = 'UTF-8 BOM'then
    FEncodingMenu.Items[2].Checked := True
  else
  if FStringList.EncodingStr = 'UCS-2 BE'then
    FEncodingMenu.Items[3].Checked := True
  else
  if FStringList.EncodingStr = 'UCS-2 LE'then
    FEncodingMenu.Items[4].Checked := True;

  if FStringList.Count = 0 then FStringList.Add('');

  if (FStringList.EncodingStr = 'ANSI') then begin
    if IsUTF8String(FStringList.Text) then begin
      FStringList.EncodingStr := 'UTF-8';
      FEncodingMenu.Items[1].Checked := True;
      for i := 0 to FStringList.Count - 1 do begin
        FStringList[i] := UTF8ToString(FStringList[i]);
      end;
    end;
  end;

  FStatusBar.Panels[2].Text := FStringList.EncodingStr;

  for i := 0 to FStringList.Count - 1 do begin
    FStringList[i] := StringReplace(FStringList[i], #9, '  ', [rfReplaceAll, rfIgnoreCase]);
    FStringList[i] := StringReplace(FStringList[i], #10, #13#10, [rfReplaceAll, rfIgnoreCase]);
    FStringList[i] := StringReplace(FStringList[i], #13#13, #13, [rfReplaceAll, rfIgnoreCase]);
  end;

  SetLength(FLineStateAr, FStringList.Count+1);
  FVertScrollBar.Position := 0;
  FHorzScrollBar.Position := 0;
  ScanMaxLineLen;
  ReCalcScrollRange;
  FVertScrollBar.Max := FStringList.Count;
  SetScanStartLine(0);

  if FStringList.Count > 0 then begin
    for i := 0 to FStringList.Count - 1 do begin
      SetLength(FLineStateAr[i].Pos, 10);
      SetLength(FLineStateAr[i].J, 10);
      FLineStateAr[i].Max := 0;
    end;
    FScanFromLine := 0;
    FOpenTimer.Enabled := True;
    GoScan;
  end;

  FNumBox.Repaint;
  Realign;
  FNumBox.Repaint;
end;

procedure TPHPEdit.SaveToFile(const FileName: String);
begin
  if FStringList.EncodingStr = 'ANSI' then
    FStringList.SaveToFile(FileName, TEncoding.ANSI)
  else if FStringList.EncodingStr = 'UTF-8 BOM' then begin
    FStringList.SaveToFile(FileName, TEncoding.UTF8)
  end else if FStringList.EncodingStr = 'UCS-2 LE' then
    FStringList.SaveToFile(FileName, TEncoding.Unicode)
  else if FStringList.EncodingStr = 'UCS-2 BE' then
    FStringList.SaveToFile(FileName, TEncoding.BigEndianUnicode)
  else if FStringList.EncodingStr = 'UTF-8' then begin
    FStringList.WriteBOM := False;
    FStringList.SaveToFile(FileName, TEncoding.UTF8)
  end;
end;

procedure TPHPEdit.GoScan;
begin
  if not FRepaintTimer.Enabled then FRepaintTimer.Enabled := True;
  if InScan then begin
    ResetScaner(FScanFromLine);
  end else begin
    ResetScaner(FScanFromLine);
    ScanText(FLineStateAr);
  end;
end;

procedure TPHPEdit.VertScroll(Sender: TObject);
var
  VisibleLineCount: Integer;
  i: Integer;
begin
  if (FVertScrollBar.Position > LineNo - (FEndLine - FStartLine)) and
     (FStringList.Count > (FVertScrollBar.Position + (FEndLine - FStartLine))) then begin
    FVertScrollBar.Position := LineNo;
    Exit;
  end;

  FStartLine := FVertScrollBar.Position;

  if (FStartLine + FPaintBox.ClientHeight div FLineHeight) < FStringList.Count then
    VisibleLineCount :=  FPaintBox.ClientHeight div FLineHeight + 1
  else
    VisibleLineCount := FStringList.Count - FStartLine;

  FEndLine := FStartLine + VisibleLineCount;

  FPaintBox.Repaint;
  FNumBox.Repaint;
  FDebugBox.Repaint;
end;

procedure TPHPEdit.HorzScroll(Sender: TObject);
begin
  FHorsStartPos := FHorzScrollBar.Position;
  FPaintBox.Repaint;
end;

procedure TPHPEdit.DrawTransparentBmp(Cnv: TCanvas; x,y: Integer; Bmp: TBitmap;
                             clTransparent: TColor);
var
  bmpXOR, bmpAND, bmpINVAND, bmpTarget: TBitmap;
  oldcol: Longint;
begin
  try
    bmpAND := TBitmap.Create;
    bmpAND.Width := Bmp.Width;
    bmpAND.Height := Bmp.Height;
    bmpAND.Monochrome := True;
    oldcol := SetBkColor(Bmp.Canvas.Handle, ColorToRGB(clTransparent));
    BitBlt(bmpAND.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height, Bmp.Canvas.Handle,
           0,0, SRCCOPY);
    SetBkColor(Bmp.Canvas.Handle, oldcol);

    bmpINVAND := TBitmap.Create;
    bmpINVAND.Width := Bmp.Width;
    bmpINVAND.Height := Bmp.Height;
    bmpINVAND.Monochrome := True;
    BitBlt(bmpINVAND.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height,
           bmpAND.Canvas.Handle, 0,0, NOTSRCCOPY);

    bmpXOR := TBitmap.Create;
    bmpXOR.Width := Bmp.Width;
    bmpXOR.Height := Bmp.Height;
    BitBlt(bmpXOR.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height, Bmp.Canvas.Handle,
           0,0, SRCCOPY);
    BitBlt(bmpXOR.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height,
           bmpINVAND.Canvas.Handle, 0,0, SRCAND);

    bmpTarget := TBitmap.Create;
    bmpTarget.Width := Bmp.Width;
    bmpTarget.Height := Bmp.Height;
    BitBlt(bmpTarget.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height, Cnv.Handle, x,y,
           SRCCOPY);
    BitBlt(bmpTarget.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height,
           bmpAND.Canvas.Handle, 0,0, SRCAND);
    BitBlt(bmpTarget.Canvas.Handle, 0,0,Bmp.Width,Bmp.Height,
           bmpXOR.Canvas.Handle, 0,0, SRCINVERT);
    BitBlt(Cnv.Handle, x,y,Bmp.Width,Bmp.Height, bmpTarget.Canvas.Handle, 0,0,
           SRCCOPY);
  finally
    bmpXOR.Free;
    bmpAND.Free;
    bmpINVAND.Free;
    bmpTarget.Free;
  end;
end;

procedure TPHPEdit.DebugPaint(Sender: TObject);
var
  i: Integer;
begin
  FDebugBox.Canvas.Brush.Color := clSilver;
  FDebugBox.Canvas.Pen.Color := clSilver;
  FDebugBox.Canvas.Rectangle(0,0,FDebugBox.Width,FDebugBox.Height);


  FDebugBox.Canvas.Brush.Color := clRed;
  FDebugBox.Canvas.Pen.Color := clRed;

  for i := 0 to Length(FDebugBreakPointArray) - 1 do begin
    FDebugBox.Canvas.Ellipse(3,
                             FLineHeight * (FDebugBreakPointArray[i] - 1) - (FVertScrollBar.Position * FLineHeight) + 3,
                             FLineHeight - 3,
                             LineHeight * (FDebugBreakPointArray[i] - 1) + FLineHeight - (FVertScrollBar.Position * FLineHeight) - 3);
  end;
end;

procedure TPHPEdit.DebugClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i,j: Integer;
  LnNo: Integer;
  Flag: Boolean;
begin
  LnNo := (Y div FLineHeight) + FVertScrollBar.Position + 1;

  Flag := False;
  for i := 0 to Length(FDebugBreakPointArray) - 1 do begin
    if FDebugBreakPointArray[i] = LnNo then begin
      for j := i to Length(FDebugBreakPointArray) - 2 do begin
        FDebugBreakPointArray[j] := FDebugBreakPointArray[j+1];
      end;
      SetLength(FDebugBreakPointArray, Length(FDebugBreakPointArray) - 1);
      Flag := True;
      Break;
    end;
  end;

  if (not Flag) then begin
    if (LnNo > FStringList.Count - 1) then Exit;
    SetLength(FDebugBreakPointArray, Length(FDebugBreakPointArray) + 1);
    FDebugBreakPointArray[Length(FDebugBreakPointArray) - 1] := LnNo;
  end;

  MainFormPND.DBGpServer.BreakPointSet(LnNo);

  FDebugBox.Repaint;
end;

procedure TPHPEdit.NumPaint(Sender: TObject);
var
  i,n: Integer;
  B: TBitmap;
begin
  //FNumBox.Width := (GetCountOfDigit(FStringList.Count) + 1) * FCharWidth + 5;
  FNumBox.Canvas.Brush.Color := RGB(215,215,215);
  FNumBox.Canvas.FillRect(Rect(0,0,FNumBox.Width,FNumBox.Height));
  FNumBox.Canvas.Pen.Color := clSilver;
  FNumBox.Canvas.MoveTo(FNumBox.Width-1,0);
  FNumBox.Canvas.LineTo(FNumBox.Width-1,FNumBox.Height);

  FNumBox.Canvas.Font.Color := clWhite;
  n := 1;

  for i := FStartLine to FEndLine - 1 do begin
    if (SCREENSCALE = 1.50) then begin
      FNumBox.Canvas.TextOut(Round(FNumBox.Width) + 0 - GetCountOfDigit(i+1)*FCharWidth ,(n-1)*FLineHeight,IntToStr(i+1));
    end
    else if (SCREENSCALE = 1.25) then begin
      FNumBox.Canvas.TextOut(Round(FNumBox.Width) + 0 - GetCountOfDigit(i+1)*FCharWidth ,(n-1)*FLineHeight,IntToStr(i+1));
    end
    else begin
      FNumBox.Canvas.TextOut(Round(FNumBox.Width) - 5 - GetCountOfDigit(i+1)*FCharWidth ,(n-1)*FLineHeight,IntToStr(i+1));
    end;

    if i = FBackRefY then begin
      B := TBitmap.Create;
      B.Handle := LoadBitmap(HInstance,'BACKREF');
      DrawTransparentBmp(FNumBox.Canvas, 3, (n-1)*FLineHeight+3, B, RGB(0,0,0));
    end;
    Inc(n);
  end;

end;

procedure TPHPEdit.NumMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
begin
  if ((Y div FLineHeight) + FStartLine) = FBackRefY then begin
    FNumBox.Cursor := crHandPoint;
    FRefArrowBackActiv := True;
  end
  else begin
    FNumBox.Cursor := crArrow;
    FRefArrowBackActiv := False;
  end;
end;

procedure TPHPEdit.NumClick(Sender: TObject);
var
  i: Integer;
  flag: Boolean;
begin
  if FRefArrowBackActiv then begin
    FBackRefY := -1;
    FNumBox.Repaint;

    flag := False;

    for i := 0 to Length(Docs) - 1 do begin
      if Docs[i] <> nil then begin
        if Docs[i].ID = FBackDocID then begin
          flag := True;
          Break;
        end;
      end;
    end;

    if flag then begin
      MainFormPND.TabControl.SelectTab(FBackDocID);
      MainFormPND.TabControl.Update;
      Docs[FBackDocID].SetCursor(1, FBackY);
      Docs[FBackDocID].Repaint;
      Docs[FBackDocID].ValignWindowIfCursorHide;
    end;
  end;
end;

procedure TPHPEdit.Paint(Sender: TObject);
var
  i,j,n: Integer;
  PredColorBr, PredColorPn: TColor;
  Offset, Counter, FindPos: Integer;
begin
  Offset := 1;
  Counter := 0;

  FPaintBox.Canvas.Brush.Color := StyleConfiguratorForm.ColorAr[1];
  FPaintBox.Canvas.Pen.Color := StyleConfiguratorForm.ColorAr[1];
  FPaintBox.Canvas.Rectangle(0,0,FPaintBox.Width, FPaintBox.Height);
  n := 0;
  predstate := ScanNormal;

  for i := FStartLine to FEndLine - 1 do begin
    predj := 1;

    if (FLineStateAr[i].Max = 0) and (Length(FLineStateAr[i].J) = 0) then Exit;
    for j := 0 to FLineStateAr[i].Max do begin

      if ((predj-FHorsStartPos) * FCharWidth) > FPaintBox.Width then Break;

      if (j+1) <= FLineStateAr[i].Max then begin
        if FLineStateAr[i].J[j+1] < FHorsStartPos then Continue;
      end;

      case predstate of
        ScanNormal:begin
          if StyleConfiguratorForm.BoldAr[3] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[3];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanOpenCurlPHP: begin
          if StyleConfiguratorForm.BoldAr[3] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[3];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanCloseCurlPHP: begin
          if StyleConfiguratorForm.BoldAr[3] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[3];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanPHP,
        ScanOpenRoundPHP,
        ScanCloseRoundPHP:begin
          if StyleConfiguratorForm.BoldAr[3] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[3];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanDoubleQuoted,
        ScanSingleQuoted,
        ScanDblStringJS,
        ScanSingStringJS:begin
          if StyleConfiguratorForm.BoldAr[4] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[4];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanComment,
        ScanLineComment:begin
          if StyleConfiguratorForm.BoldAr[5] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[5];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanVar:begin
          if StyleConfiguratorForm.BoldAr[6] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[6];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanReserv:begin
          if StyleConfiguratorForm.BoldAr[7] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[7];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
          FPaintBox.Canvas.Font.Style := [];
        end;
        ScanFunc:begin
          if StyleConfiguratorForm.BoldAr[8] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[8];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanDigit:begin
          if StyleConfiguratorForm.BoldAr[9] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[9];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanPHPTag:begin
          if StyleConfiguratorForm.BoldAr[10] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[10];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
          FPaintBox.Canvas.Font.Style := [];
        end;
        ScanHTMLTag:begin
          if StyleConfiguratorForm.BoldAr[11] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[11];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanHTMLAttr:begin
          if StyleConfiguratorForm.BoldAr[13] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[13];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanOpenHTML,
        ScanOpenCSS,
        ScanOpenJS:begin
          if StyleConfiguratorForm.BoldAr[12] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[12];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanCloseHTML,
        ScanCloseCSS,
        ScanCloseJS:begin
          if StyleConfiguratorForm.BoldAr[12] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[12];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanDblQHTML,
        ScanSingQHTML,
        ScanDblQCSS,
        ScanSingQCSS,
        ScanDblQJS,
        ScanSingQJS:begin
          if StyleConfiguratorForm.BoldAr[26] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[26];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanHTMLComment,
        ScanLineJSComment,
        ScanJSComment:begin
          if StyleConfiguratorForm.BoldAr[14] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[14];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanHTMLHeader:begin
          if StyleConfiguratorForm.BoldAr[15] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[15];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanCSSTag:begin
          if StyleConfiguratorForm.BoldAr[16] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[16];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanCSSBody,
        ScanOpenCurlCSS,
        ScanCloseCurlCSS :begin
          if StyleConfiguratorForm.BoldAr[17] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[17];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
          FPaintBox.Canvas.Font.Style := [];
        end;
        ScanCSSAttr:begin
          if StyleConfiguratorForm.BoldAr[18] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[18];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
          FPaintBox.Canvas.Font.Style := [];
        end;
        ScanCSSComment:begin
          if StyleConfiguratorForm.BoldAr[19] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[19];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanJSTag:begin
          if StyleConfiguratorForm.BoldAr[20] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[20];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanJSBody,
        ScanOpenCurlJS, ScanCloseCurlJS, ScanOpenRoundJS, ScanCloseRoundJS: begin
          if StyleConfiguratorForm.BoldAr[21] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[21];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanJSReserv:begin
          if StyleConfiguratorForm.BoldAr[22] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[22];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
          FPaintBox.Canvas.Font.Style := [];
        end;
        ScanJSObj:begin
          if StyleConfiguratorForm.BoldAr[23] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[23];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
          FPaintBox.Canvas.Font.Style := [];
        end;
        ScanJSMetods:begin
          if StyleConfiguratorForm.BoldAr[24] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[24];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
        ScanJSProp:begin
          if StyleConfiguratorForm.BoldAr[25] then
            FPaintBox.Canvas.Font.Style := [fsBold]
          else
            FPaintBox.Canvas.Font.Style := [];

          FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[25];
          FPaintBox.Canvas.TextOut((predj-FHorsStartPos)*FCharWidth,n*FLineHeight,Copy(FStringList[i],predj,FLineStateAr[i].J[j]-predj));
        end;
      end;

      predj := FLineStateAr[i].J[j];
      predstate := FLineStateAr[i].Pos[j];
    end;

    if FFindTreeItem then begin
      FindPos := PosEx(FFindTreeStr, FStringList[i], Offset);
      while FindPos <> 0 do begin
        for j := 0 to FLineStateAr[i].Max do begin
          if FLineStateAr[i].J[j] > FindPos then begin
            if j > 0 then begin
              if FLineStateAr[i].Pos[j-1] = FFindTreeState then begin
                if (FindPos+Length(FFindTreeStr)+0  > Length(FStringList[i])) or
                   ((FStringList[i][FindPos+Length(FFindTreeStr)+0]) in Delim) then begin
                      Inc(Counter);
                      PredColorBr := FPaintBox.Canvas.Brush.Color;
                      PredColorPn := FPaintBox.Canvas.Pen.Color;
                      FPaintBox.Canvas.Pen.Color := RGB(230,230,230);
                      FPaintBox.Canvas.Brush.Color := RGB(230,230,230);
                      FPaintBox.Canvas.Rectangle((FindPos-HorsStartPos)*FCharWidth, n*FLineHeight,
                                                ((FindPos-HorsStartPos)+Length(FFindTreeStr))*FCharWidth, n*FLineHeight+FLineHeight);
                      FPaintBox.Canvas.Brush.Color := PredColorBr;
                      FPaintBox.Canvas.Pen.Color := PredColorPn;
                end;
              end;
            end;
            Break;
          end;
        end;
        Offset := FindPos + Length(FFindTreeStr);
        FindPos := PosEx(FFindTreeStr, FStringList[i], Offset);
      end;
    end;
    Offset := 1;

    if FBlockEdgingPaint then begin
      for j := 0 to FNewCurlPosPHP - 1 do begin
        if FCurlBlockArrayPHP[j].Visit then begin
          if (FCurlBlockArrayPHP[j].BBegin.Y >= FStartLine) and (FCurlBlockArrayPHP[j].BBegin.Y <= FEndLine) or
             (FCurlBlockArrayPHP[j].BEnd.Y >= FStartLine) and (FCurlBlockArrayPHP[j].BEnd.Y <= FEndLine) or
             (FCurlBlockArrayPHP[j].BEnd.Y >= FEndLine) and (FCurlBlockArrayPHP[j].BBegin.Y <= FStartLine)
          then begin
            if (FCurlBlockArrayPHP[j].BBegin.Y <> FCurlBlockArrayPHP[j].BEnd.Y) then begin

                FPaintBox.Canvas.Pen.Mode := pmCopy;

                case FCurlBlockArrayPHP[j].Level mod 4 of
                  0: FPaintBox.Canvas.Pen.Color := RGB(255,160,160);
                  1: FPaintBox.Canvas.Pen.Color := RGB(141,168,203);
                  2: FPaintBox.Canvas.Pen.Color := RGB(255,176,98);
                  3: FPaintBox.Canvas.Pen.Color := RGB(89,255,89);
                end;

                FPaintBox.Canvas.MoveTo((FCurlBlockArrayPHP[j].BEnd.X-FHorsStartPos)*FCharWidth-(FCharWidth div 2),(FCurlBlockArrayPHP[j].BEnd.Y-FStartLine)*FLineHeight+FLineHeight);
                FPaintBox.Canvas.LineTo((FCurlBlockArrayPHP[j].BEnd.X-FHorsStartPos)*FCharWidth+(FCharWidth div 2),(FCurlBlockArrayPHP[j].BEnd.Y-FStartLine)*FLineHeight+FLineHeight);

                FPaintBox.Canvas.MoveTo((FCurlBlockArrayPHP[j].BEnd.X-FHorsStartPos)*FCharWidth-(FCharWidth div 2),(FCurlBlockArrayPHP[j].BEnd.Y-FStartLine)*FLineHeight+FLineHeight);
                FPaintBox.Canvas.LineTo((FCurlBlockArrayPHP[j].BEnd.X-FHorsStartPos)*FCharWidth-(FCharWidth div 2),(FCurlBlockArrayPHP[j].BBegin.Y-FStartLine)*FLineHeight-1);

                //вержн€€ черточка
                FPaintBox.Canvas.MoveTo((FCurlBlockArrayPHP[j].BEnd.X-FHorsStartPos)*FCharWidth-(FCharWidth div 2),(FCurlBlockArrayPHP[j].BBegin.Y-FStartLine)*FLineHeight-1);
                FPaintBox.Canvas.LineTo((FCurlBlockArrayPHP[j].BEnd.X-FHorsStartPos)*FCharWidth+(FCharWidth div 2),(FCurlBlockArrayPHP[j].BBegin.Y-FStartLine)*FLineHeight-1);

                FPaintBox.Canvas.Pen.Mode := pmNotXor;
            end;
          end;
        end;
      end;


      for j := 0 to FNewCurlPosJS - 1 do begin
        if FCurlBlockArrayJS[j].Visit then begin
          if (FCurlBlockArrayJS[j].BBegin.Y >= FStartLine) and (FCurlBlockArrayJS[j].BBegin.Y <= FEndLine) or
             (FCurlBlockArrayJS[j].BEnd.Y >= FStartLine) and (FCurlBlockArrayJS[j].BEnd.Y <= FEndLine) or
             (FCurlBlockArrayJS[j].BEnd.Y >= FEndLine) and (FCurlBlockArrayJS[j].BBegin.Y <= FStartLine)
          then begin
            if (FCurlBlockArrayJS[j].BBegin.Y <> FCurlBlockArrayJS[j].BEnd.Y) then begin

                FPaintBox.Canvas.Pen.Mode := pmCopy;

                case FCurlBlockArrayJS[j].Level mod 4 of
                  0: FPaintBox.Canvas.Pen.Color := RGB(255,160,160);
                  1: FPaintBox.Canvas.Pen.Color := RGB(141,168,203);
                  2: FPaintBox.Canvas.Pen.Color := RGB(255,176,98);
                  3: FPaintBox.Canvas.Pen.Color := RGB(89,255,89);
                end;

                FPaintBox.Canvas.MoveTo((FCurlBlockArrayJS[j].BEnd.X-FHorsStartPos)*FCharWidth-(FCharWidth div 2),(FCurlBlockArrayJS[j].BEnd.Y-FStartLine)*FLineHeight+FLineHeight);
                FPaintBox.Canvas.LineTo((FCurlBlockArrayJS[j].BEnd.X-FHorsStartPos)*FCharWidth+(FCharWidth div 2),(FCurlBlockArrayJS[j].BEnd.Y-FStartLine)*FLineHeight+FLineHeight);

                FPaintBox.Canvas.MoveTo((FCurlBlockArrayJS[j].BEnd.X-FHorsStartPos)*FCharWidth-(FCharWidth div 2),(FCurlBlockArrayJS[j].BEnd.Y-FStartLine)*FLineHeight+FLineHeight);
                FPaintBox.Canvas.LineTo((FCurlBlockArrayJS[j].BEnd.X-FHorsStartPos)*FCharWidth-(FCharWidth div 2),(FCurlBlockArrayJS[j].BBegin.Y-FStartLine)*FLineHeight-1);

                //вержн€€ черточка
                FPaintBox.Canvas.MoveTo((FCurlBlockArrayJS[j].BEnd.X-FHorsStartPos)*FCharWidth-(FCharWidth div 2),(FCurlBlockArrayJS[j].BBegin.Y-FStartLine)*FLineHeight-1);
                FPaintBox.Canvas.LineTo((FCurlBlockArrayJS[j].BEnd.X-FHorsStartPos)*FCharWidth+(FCharWidth div 2),(FCurlBlockArrayJS[j].BBegin.Y-FStartLine)*FLineHeight-1);

                FPaintBox.Canvas.Pen.Mode := pmNotXor;
            end;
          end;
        end;
      end;
    end;

    if FFollowRef then begin
      if FFollowRefLine = i then begin
        FPaintBox.Canvas.Font.Color := clBlue;
        FPaintBox.Canvas.font.Style := [fsUnderline];
        FPaintBox.Cursor := crHandPoint;
        FPaintBox.Canvas.TextOut((FFollowRefPosFrom-FHorsStartPos) * FCharWidth,
                                 n * FLineHeight,
                                 FFollowStr);
      end;
    end else
      FPaintBox.Cursor := crIBeam;

    Inc(n);
  end;

  CaretPaint;
  SelectedRangePaint;

  if FSepLinePaint then begin
    FPaintBox.Canvas.Pen.Color := clSilver;
    FPaintBox.Canvas.MoveTo(FCharWidth*(81-FHorsStartPos),0);
    FPaintBox.Canvas.LineTo(FCharWidth*(81-FHorsStartPos),FPaintBox.Height);
  end;

  if DocMap <> nil then begin
    TDocMap(DocMap).Update;
  end;

  if FDebugCurLine <> -1 then begin
    FPaintBox.Canvas.Pen.Color := RGB(255,217,230);
    FPaintBox.Canvas.Brush.Color := RGB(255,217,230);
    FPaintBox.Canvas.Rectangle(0, (FDebugCurLine - FStartLine - 1) * FLineHeight, FPaintBox.Width,
                               (FDebugCurLine  - FStartLine - 1) * FLineHeight + FLineHeight);
  end;
end;


procedure TPHPEdit.SetFon(Color: TColor);
begin

end;

function TPHPEdit.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  FVertScrollBar.Position := FVertScrollBar.Position + 3;
end;

function TPHPEdit.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  FVertScrollBar.Position := FVertScrollBar.Position - 3;
end;

procedure TPHPEdit.CanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
var
  VisibleLineCount: Integer;
begin
  FStartLine := FVertScrollBar.Position;

  if (FStartLine + FPaintBox.ClientHeight div FLineHeight) < FStringList.Count then
    VisibleLineCount :=  FPaintBox.ClientHeight div FLineHeight + 1
  else
    VisibleLineCount := FStringList.Count - FStartLine;

  FEndLine := FStartLine + VisibleLineCount;

  FVertScrollBar.LargeChange := (FEndLine - FStartLine);

  FPaintBox.Repaint;
  FNumBox.Repaint;
end;

function TPHPEdit.GetCountOfDigit(Number: Integer): Integer;
var
  Count: Integer;
begin
  Count := 0;
  while (Number <> 0) do begin
    Inc(Count);
    Number := Number div 10;
  end;

  Result := Count;
end;

procedure TPHPEdit.InsertWord(Word: String; PrefLen: Integer; Replace, Suffix: Boolean);
var
  S: String;
  i, DelBegin, DelEnd: Integer;
  flag: Boolean;
  ReplTail: PReplaceRec;
begin
  Modify;
  HideSelection;

  if Replace then begin
    DelBegin := FCaretPos.X - PrefLen;

    if Suffix then begin
      flag := False;
      for i := FCaretPos.X to Length(FStringList[FCaretPos.Y]) do begin
        if not (IsCharAlpha(FStringList[FCaretPos.Y][i]) or (FStringList[FCaretPos.Y][i] in ['_','-']))  then begin
          DelEnd := i;
          flag := True;
          Break;
        end;
      end;
      if not flag then
        DelEnd := Length(FStringList[FCaretPos.Y]) + 1;
        
    end else
      DelEnd := FCaretPos.X;

    S := FStringList[FCaretPos.Y];

    New(ReplTail);
    ReplTail^.X := DelBegin;
    ReplTail^.Y := FCaretPos.Y;
    ReplTail^.Next := nil;
    ActionAdd(actReplace, Point(0,0), Point(0,0), Copy(S, DelBegin, DelEnd - DelBegin), Word, False, ReplTail);
    Delete(S, DelBegin, DelEnd - DelBegin);
    Insert(Word, S, DelBegin);

    FStringList[FCaretPos.Y] := S;
    FCaretPos.X := DelBegin + Length(Word);
  end else begin
    S := FStringList[FCaretPos.Y];
    ActionAdd(actInsert, Point(FCaretPos.X, FCaretPos.Y), Point(FCaretPos.X + Length(Word), FCaretPos.Y), Word, '', False, nil);
    Insert(Word, S, FCaretPos.X);
    FStringList[FCaretPos.Y] := S;
    FCaretPos.X := FCaretPos.X  + Length(Word);
  end;

  ReCalcScrollRange;
  CheckMaxLineLen(FStringList[FCaretPos.Y]);
  ValignWindowIfCursorHide;
  AlignWindowIfCursorHide;
  GoScan;
end;

procedure TPHPEdit.ScanAfterInsertWord;
begin
  SetLength(FLineStateAr, FStringList.Count + 1);
  ReCalcScrollRange;
  SetScanStartLine(FVertScrollBar.Position);
  ScanMaxLineLen;
  GoScan;

  ValignWindowIfCursorHide;
  AlignWindowIfCursorHide;
end;

procedure TPHPEdit.KeyPress(var Key: Char);
var
  S, Space: String;
  i,j,spos,fpos: Integer;
begin
  SetScanStartLine(FCaretPos.Y);
  FSRMove := False;
  Modify;

  if TextSelected and not FStartSelected then begin
    DeleteSelection;
    SetLength(FLineStateAr, FStringList.Count + 1);
    ReCalcScrollRange;

    FCutMenu.Enabled := False;
    FCopyMenu.Enabled := False;
    FCutBtn.Enabled := False;
    FCopyBtn.Enabled := False;
    FpmCut.Enabled := False;
    FpmCopy.Enabled := False;
    FpmDelete.Enabled := False;
  end;

  if IsCharPrint(Key) then begin

    Space := '';

    if FCaretPos.X-1 > Length(FStringList[FCaretPos.Y]) then begin
      for i := 0 to FCaretPos.X-2 - Length(FStringList[FCaretPos.Y])  do
        Space := Space + ' ';
    end;

    S := FStringList[FCaretPos.Y];
    if Length(Space) > 0 then  S := S + Space;

    if Ord(Key) <> 9 then begin
      BeginKeyChanged(Key, FCaretPos, '');

      Insert(Key, S, Length(Space) + FCaretPos.X);
      FStringList[FCaretPos.Y] := S;
      Inc(FCaretPos.X);
    end else begin
      BeginKeyChanged(' ', FCaretPos, '');
      Inc(FCaretPos.X, 1);
      BeginKeyChanged(' ', FCaretPos, '');

      Insert('  ', S, Length(Space) + FCaretPos.X - 1);
      FStringList[FCaretPos.Y] := S;
      Inc(FCaretPos.X, 1);
    end;

    CheckMaxLineLen(S);
  end;

  if (Key <> #13) and (Key <> #8) then begin
    ValignWindowIfCursorHide;
    AlignWindowIfCursorHide;
    GoScan;
  end;

  HideSelection;

  FStatusBar.Panels[0].Text := ' Ln:' + IntToStr(FCaretPos.Y + 1);
  FStatusBar.Panels[1].Text := ' Col:' + IntToStr(FCaretPos.X);
  FStatusBar.Refresh; 
end;

procedure TPHPEdit.ProcRepaintTimer(Sender: TObject);
begin
  FPaintBox.Repaint;
  FNumBox.Repaint;
  FRepaintTimer.Enabled := False;
end;

procedure TPHPEdit.ProcRepaintWaitTimer(Sender: TObject);
begin
  FPaintBox.Repaint;
  FNumBox.Repaint;
  FRepaintWaitTimer.Enabled := False;
end;

procedure TPHPEdit.ProcDblClickTimer(Sender: TObject);
begin
  FDblClickTimer.Enabled := False;
end;

procedure TPHPEdit.ProcCaretMerguTimer(Sender: TObject);
begin
  Inc(MergCounter);

  if (MergCounter mod 2 = 0) then
    FPaintBox.Canvas.Pen.Color := clGreen
  else
    FPaintBox.Canvas.Pen.Color := FFonColor;

  FPaintBox.Canvas.MoveTo((FCaretPos.X-FHorsStartPos)*FCharWidth,(FCaretPos.Y-FStartLine)*FLineHeight);
  FPaintBox.Canvas.LineTo((FCaretPos.X-FHorsStartPos)*FCharWidth,(FCaretPos.Y-FStartLine)*FLineHeight+FLineHeight);
  FPaintBox.Canvas.MoveTo((FCaretPos.X-FHorsStartPos)*FCharWidth-1,(FCaretPos.Y-FStartLine)*FLineHeight);
  FPaintBox.Canvas.LineTo((FCaretPos.X-FHorsStartPos)*FCharWidth-1,(FCaretPos.Y-FStartLine)*FLineHeight+FLineHeight);
end;

procedure TPHPEdit.ProcOpenTimer(Sender: TObject);
begin
  FPaintBox.Repaint;
  FNumBox.Repaint;
  FOpenTimer.Enabled := False;
end;

procedure TPHPEdit.ProcClassFunc(Sender: TObject);
begin
  FClassFuncWaitTick := FClassFuncWaitTick + FClassFuncTimer.Interval;
  if FClassFuncWaitTick > 1000 then begin
    FClassFuncTimer.Enabled := False;
    ClassFuncListScan;
  end;
end;

procedure TPHPEdit.ProcTreeTimer(Sender: TObject);
begin
  FTreeScanWaitTick := FTreeScanWaitTick + FTreeTimer.Interval;
  if FTreeScanWaitTick > 2000 then begin
    if not FInScanTree then begin
      FTreeTimer.Enabled := False;
      ResetTreeScaner;
      ScanTree;
    end else
      LineNoTr := Length(FLineStateAr);
  end;
end;

function TPHPEdit.IsCorrectIdent(const Ident: String): Boolean;
var
  i: Integer;
begin
  Result := True;
  if Length(Ident) = 0 then
    Result := False
  else if not IsCharAlpha(Ident[1]) and (Ident[1] <> '_') then
    Result := False
  else begin
    for i := 2 to Length(Ident) do begin
      if (not IsCharAlpha(Ident[i])) then begin
        if (not (Ident[i] in ['0'..'9','_'])) then begin
          Result := False;
          Break;
        end;
      end;
    end;
  end;
end;

function TPHPEdit.IsCharPrint(Key: Char): Boolean;
begin
  Result := False;
  if IsCharAlpha(Key) or (Key in ['0'..'9',' ','`','~','!','@','"','#','є','$',
                                  ';','%','^',':','&','?','*','(',')','-','_',
                                  '+','=','{','}','[',']','|','\','/','''',
                                  '<','>',',',#46])
                      or (Ord(Key) = 9)
  then Result := True;
end;

procedure TPHPEdit.DeleteSelection;
begin
  if TextSelected then begin
    if FSelectedRange[0].Y = FSelectedRange[1].Y then begin
       FStartLine := FSelectedRange[0].Y;
       SetScanStartLine(FStartLine);

      if FSelectedRange[0].X < FSelectedRange[1].X then
        ActionAdd(actDelete, FSelectedRange[0], FSelectedRange[1], DeleteTextBlock(FSelectedRange[0], FSelectedRange[1]), '', False, nil)
      else
        ActionAdd(actDelete, FSelectedRange[1], FSelectedRange[0], DeleteTextBlock(FSelectedRange[0], FSelectedRange[1]), '', False, nil);
    end else
    if FSelectedRange[0].Y < FSelectedRange[1].Y then begin
       FStartLine := FSelectedRange[0].Y;
       SetScanStartLine(FStartLine);
       ActionAdd(actDelete, FSelectedRange[0], FSelectedRange[1], DeleteTextBlock(FSelectedRange[0], FSelectedRange[1]), '', False, nil)
    end else begin
       FStartLine := FSelectedRange[1].Y;
       SetScanStartLine(FStartLine);
       ActionAdd(actDelete, FSelectedRange[1], FSelectedRange[0], DeleteTextBlock(FSelectedRange[0], FSelectedRange[1]), '', False, nil);
    end;
    HideSelection;
  end;
end;

procedure TPHPEdit.DeleteText;
begin
  DeleteSelection;
  SetLength(FLineStateAr, FStringList.Count + 1);
  ReCalcScrollRange;
  ScanMaxLineLen;
  ValignWindowIfCursorHide;
  AlignWindowIfCursorHide;  
  GoScan;
end;

procedure TPHPEdit.KeyDown(var Key: Word; Shift: TShiftState);
var
  i,spos,fpos,sp: Integer;
  S, Space, Spc: String;
  NewCaretPos: TPoint;
begin
  FFindTreeItem := False;
  FStatusBar.Panels[3].Text := '';

  SetScanStartLine(FCaretPos.Y-1); //-1 if BackSpace
  FCaretMerguTimer.Enabled := False;
  if (MergCounter mod 2) <> 0  then Dec(MergCounter);

  if Key = 17 then Exit;
  if Key <> 16 then FSRMove := False;

  if Key = 37 then begin
    if FCaretPos.X > 1 then Dec(FCaretPos.X)
    else if FCaretPos.Y > 0 then begin
      Dec(FCaretPos.Y);
      FCaretPos.X := Length(FStringList[FCaretPos.Y]) + 1;
    end;
    ValignWindowIfCursorHide;
    AlignWindowIfCursorHide;    
    FPaintBox.Repaint;
  end;
  if Key = 39 then begin
    if FCaretPos.X <= Length(FStringList[FCaretPos.Y]) then Inc(FCaretPos.X)
    else if FCaretPos.Y < FStringList.Count - 1 then begin
      Inc(FCaretPos.Y);
      FCaretPos.X := 1;
    end;
    ValignWindowIfCursorHide;
    AlignWindowIfCursorHide;
    FPaintBox.Repaint;
  end;
  if Key = 38 then begin
    if FCaretPos.Y > 0 then begin
      Dec(FCaretPos.Y);
      if FCaretPos.X > Length(FStringList[FCaretPos.Y]) then
        FCaretPos.X := Length(FStringList[FCaretPos.Y]) + 1;
    end;
    ValignWindowIfCursorHide;
    AlignWindowIfCursorHide;
    FPaintBox.Repaint;
  end;
  if Key = 40 then begin
    if FCaretPos.Y < FStringList.Count-1 then begin
      Inc(FCaretPos.Y);
      if FCaretPos.X > Length(FStringList[FCaretPos.Y]) then
        FCaretPos.X := Length(FStringList[FCaretPos.Y]) + 1;
    end;
    
    ValignWindowIfCursorHide;
    AlignWindowIfCursorHide;
    FPaintBox.Repaint;
  end;

  if Key = 8 then begin
    if TextSelected then begin
      Modify;
      DeleteSelection;
      SetLength(FLineStateAr, FStringList.Count + 1);
      ReCalcScrollRange;
      ScanMaxLineLen;
      GoScan;

      FCutMenu.Enabled := False;
      FCopyMenu.Enabled := False;
      FCutBtn.Enabled := False;
      FCopyBtn.Enabled := False;
      FpmCut.Enabled := False;
      FpmCopy.Enabled := False;
      FpmDelete.Enabled := False;
    end else begin
      if FCaretPos.X > 1 then begin
        Modify;
        if FCaretPos.X <= Length(FStringList[FCaretPos.Y]) + 1 then begin
          BeginBkSpaceChanged(FStringList[FCaretPos.Y][FCaretPos.X-1],FCaretPos);

          S := FStringList[FCaretPos.Y];
          Delete(S, FCaretPos.X-1, 1);
          FStringList[FCaretPos.Y] := S;
          ScanMaxLineLen;
        end;
    
        Dec(FCaretPos.X);
        ValignWindowIfCursorHide;
        AlignWindowIfCursorHide;
        GoScan;
      end else begin
        if FCaretPos.Y > 0 then begin
          try
            Modify;
            BeginBkSpaceChanged(#8, FCaretPos);

            FCaretPos.X := Length(FStringList[FCaretPos.Y-1]) + 1;

            S := FStringList[FCaretPos.Y-1] + FStringList[FCaretPos.Y];
            FStringList[FCaretPos.Y-1] := S;
            CheckMaxLineLen(S);
            FStringList.Delete(FCaretPos.Y);
            FCaretPos.Y := FCaretPos.Y - 1;

            //на экран вниз
            if FCaretPos.Y < FStartLine then begin
               if FCaretPos.Y <> FVertScrollBar.Position then begin
                 FVertScrollBar.Position := FVertScrollBar.Position - (FEndLine - FStartLine);
               end;
            end;

            SetLength(FLineStateAr, FStringList.Count + 1);
            ReCalcScrollRange;
            ValignWindowIfCursorHide;
            AlignWindowIfCursorHide;
            GoScan;
          except on E: Exception do
            ShowMessage(E.ClassName  + ' Error: ' + E.Message);
          end;
        end else begin
          //тупик
          FPaintBox.Repaint;
        end;
      end;
    end; //else TextSelected
  end;
       
  if Key = 13 then begin
    Modify;
    if TextSelected then begin
      DeleteSelection;

      FCutMenu.Enabled := False;
      FCopyMenu.Enabled := False;
      FCutBtn.Enabled := False;
      FCopyBtn.Enabled := False;
      FpmCut.Enabled := False;
      FpmCopy.Enabled := False;
      FpmDelete.Enabled := False;
    end;

    S := FStringList[FCaretPos.Y];
    sp := 1;
    Spc := '';

    if (FCaretPos.X) >= Length(S) then begin
      sp := FCaretPos.X;
      for i := 1 to sp do begin
        Spc := Spc + ' ';
      end;
    end;

    for i := 1 to Length(S) do begin
      if (S[i] <> #32) or (i = FCaretPos.X) then begin
        sp := i;
        Break;
      end else
        Spc := Spc + ' ';
    end;

    BeginKeyChanged(#13,FCaretPos, Spc);

    if FCaretPos.X <= Length(FStringList[FCaretPos.Y]) then begin
      FStringList.Insert(FCaretPos.Y + 1, Spc + Space + Copy(FStringList[FCaretPos.Y], FCaretPos.X, Length(S) - FCaretPos.X + 1));
      Delete(S, FCaretPos.X, Length(S) - FCaretPos.X + 1);
      FStringList[FCaretPos.Y] :=  S;

      FCaretPos.X := sp;
      FCaretPos.Y := FCaretPos.Y + 1;
    end else begin
      FStringList.Insert(FCaretPos.Y + 1,'');

      FCaretPos.X := sp;
      FCaretPos.Y := FCaretPos.Y + 1;
    end;

    if FCaretPos.Y > FStartLine + (FPaintBox.Height div FLineHeight) - 1 then begin
     if FVertScrollBar.Position < FStringList.Count - 1 then begin
       FVertScrollBar.Position := FCaretPos.Y + (FPaintBox.Height div FLineHeight) + 1;
      end;
    end;

    //на экран вверх
    {if FCaretPos.Y > FEndLine-1 then begin
      if FVertScrollBar.Position < FStringList.Count - 1 then begin
         FVertScrollBar.Position := FVertScrollBar.Position + (FEndLine - FStartLine);
      end;
    end; }

    SetLength(FLineStateAr, FStringList.Count + 1);
    ReCalcScrollRange;
    ScanMaxLineLen;
    ValignWindowIfCursorHide;
    AlignWindowIfCursorHide;
    GoScan;
  end;

  if Key = 33 then begin
     if FVertScrollBar.Position - (FEndLine - FStartLine) > 0 then begin
       FVertScrollBar.Position := FVertScrollBar.Position - (FEndLine - FStartLine);
       FCaretPos.Y := FCaretPos.Y - (FEndLine - FStartLine);

       if ssShift in Shift then begin
         FSelectedRange[1].X := FCaretPos.X;
         FSelectedRange[1].Y := FCaretPos.Y;
       end;

     end else begin
       if ssShift in Shift then begin
         FCaretPos.X := 1;
         FCaretPos.Y := 0;

         FSelectedRange[1].X := FCaretPos.X;
         FSelectedRange[1].Y := FCaretPos.Y;
       end;
     end;

     ValignWindowIfCursorHide;
     AlignWindowIfCursorHide;
     FPaintBox.Repaint;
  end;

  if Key = 34 then begin
     if (FVertScrollBar.Position + (FEndLine - FStartLine)) < FStringList.Count then begin
       FVertScrollBar.Position := FVertScrollBar.Position + (FEndLine - FStartLine);
       FCaretPos.Y := FCaretPos.Y + (FEndLine - FStartLine);

       if ssShift in Shift then begin
         FSelectedRange[1].X := FCaretPos.X;
         FSelectedRange[1].Y := FCaretPos.Y;
       end;

     end else begin
       if ssShift in Shift then begin
         FCaretPos.X := Length(FStringList[FStringList.Count-1]) + 1;
         FCaretPos.Y := FStringList.Count - 1;

         FSelectedRange[1].X := FCaretPos.X;
         FSelectedRange[1].Y := FCaretPos.Y;
       end;
     end;

     ValignWindowIfCursorHide;
     AlignWindowIfCursorHide;
     FPaintBox.Repaint;
  end;

  if (not TextSelected) and (FStartSelected) then begin
    if Key = 16 then begin
      FSelectedRange[0].X := FCaretPos.X;
      FSelectedRange[0].Y := FCaretPos.Y;
      FSelectedRange[1].X := FCaretPos.X;
      FSelectedRange[1].Y := FCaretPos.Y;
      FStartSelected := True;
      FPaintBox.Repaint;
    end;
  end else begin
    if ssShift in Shift then begin
      if (Key = 37) or (Key = 38) or (Key = 39) or (Key = 40) then begin
        FSelectedRange[1].X := FCaretPos.X;
        FSelectedRange[1].Y := FCaretPos.Y;

          if TextSelected then begin
              FCutBtn.Enabled := True;
              FCopyBtn.Enabled := True;
              FCutMenu.Enabled := True;
              FCopyMenu.Enabled := True;
              FDeleteMenu.Enabled := True;
              FpmCut.Enabled := True;
              FpmCopy.Enabled := True;
              FpmDelete.Enabled := True;
          end else begin
              FCutBtn.Enabled := False;
              FCopyBtn.Enabled := False;
              FCutMenu.Enabled := False;
              FCopyMenu.Enabled := False;
              FDeleteMenu.Enabled := False;
              FpmCut.Enabled := False;
              FpmCopy.Enabled := False;
              FpmDelete.Enabled := False;
          end;

        FPaintBox.Repaint;
      end;
    end else begin      
      if (Key = 37) or (Key = 38) or (Key = 39) or (Key = 40)  then begin
         HideSelection;
         FPaintBox.Repaint;
         
         FCutMenu.Enabled := False;
         FCopyMenu.Enabled := False;
         FCutBtn.Enabled := False;
         FCopyBtn.Enabled := False;
         FpmCut.Enabled := False;
         FpmCopy.Enabled := False;
         FpmDelete.Enabled := False;
      end;
    end;
  end;

  FStatusBar.Panels[0].Text := ' Ln:' + IntToStr(FCaretPos.Y + 1);
  FStatusBar.Panels[1].Text := ' Col:' + IntToStr(FCaretPos.X);
  FStatusBar.Refresh;
end;

procedure TPHPEdit.InsertText;
begin
  CopyFromClipBoard;
  SetLength(FLineStateAr, FStringList.Count + 1);
  ReCalcScrollRange;
  ScanMaxLineLen;
  ValignWindowIfCursorHide;
  AlignWindowIfCursorHide;
  GoScan;
end;

procedure TPHPEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  FRepaintWaitTimer.Enabled := True;
  RunCursor;
end;

procedure TPHPEdit.CaretPaint;
begin
  FPaintBox.Canvas.Pen.Color := clGreen;
  FPaintBox.Canvas.MoveTo((FCaretPos.X-FHorsStartPos)*FCharWidth,(FCaretPos.Y-FStartLine)*FLineHeight);
  FPaintBox.Canvas.LineTo((FCaretPos.X-FHorsStartPos)*FCharWidth,(FCaretPos.Y-FStartLine)*FLineHeight+FLineHeight);
  FPaintBox.Canvas.MoveTo((FCaretPos.X-FHorsStartPos)*FCharWidth-1,(FCaretPos.Y-FStartLine)*FLineHeight);
  FPaintBox.Canvas.LineTo((FCaretPos.X-FHorsStartPos)*FCharWidth-1,(FCaretPos.Y-FStartLine)*FLineHeight+FLineHeight);
  FPaintBox.Canvas.Pen.Color := clBlack;
end;

procedure TPHPEdit.SelectedRangePaint;
var
  PredBrush, PredPen: TColor;
  i: Integer;
  Buf: Integer;
begin  
  PredBrush := FPaintBox.Canvas.Brush.Color;
  PredPen := FPaintBox.Canvas.Pen.Color;

  FPaintBox.Canvas.Brush.Color := StyleConfiguratorForm.ColorAr[2]; //RGB(240,240,240);
  FPaintBox.Canvas.Pen.Color := StyleConfiguratorForm.ColorAr[2]; //RGB(240,240,240);

  if FSelectedRange[0].Y = FSelectedRange[1].Y then begin
    FPaintBox.Canvas.Rectangle((FSelectedRange[0].X-FHorsStartPos)*FCharWidth,
                               (FSelectedRange[0].Y-FStartLine)*FLineHeight,
                               (FSelectedRange[1].X-FHorsStartPos)*FCharWidth,
                               (FSelectedRange[1].Y-FStartLine)*FLineHeight + FLineHeight);
  end;

  if FSelectedRange[1].Y - FSelectedRange[0].Y >= 1 then begin
    FPaintBox.Canvas.Rectangle((FSelectedRange[0].X-FHorsStartPos)*FCharWidth,
                               (FSelectedRange[0].Y-FStartLine)*FLineHeight,
                                FPaintBox.Width,
                               (FSelectedRange[0].Y-FStartLine)*FLineHeight + FLineHeight);
    FPaintBox.Canvas.Rectangle( 0,
                               (FSelectedRange[1].Y-FStartLine)*FLineHeight,
                               (FSelectedRange[1].X-FHorsStartPos)*FCharWidth,
                               (FSelectedRange[1].Y-FStartLine)*FLineHeight + FLineHeight);
    FPaintBox.Canvas.Rectangle( 0,
                               ((FSelectedRange[0].Y)-FStartLine)*FLineHeight+FLineHeight,
                                FPaintBox.Width,
                               ((FSelectedRange[1].Y)-FStartLine)*FLineHeight);
  end;


  if FSelectedRange[1].Y - FSelectedRange[0].Y <= -1 then begin
    FPaintBox.Canvas.Rectangle( 0,
                               (FSelectedRange[0].Y-FStartLine)*FLineHeight,
                               (FSelectedRange[0].X-FHorsStartPos)*FCharWidth,
                               (FSelectedRange[0].Y-FStartLine)*FLineHeight + FLineHeight);
    FPaintBox.Canvas.Rectangle((FSelectedRange[1].X-FHorsStartPos)*FCharWidth,
                               (FSelectedRange[1].Y-FStartLine)*FLineHeight,
                                FPaintBox.Width,
                               (FSelectedRange[1].Y-FStartLine)*FLineHeight + FLineHeight);
    FPaintBox.Canvas.Rectangle( 0,
                               ((FSelectedRange[1].Y)-FStartLine)*FLineHeight+FLineHeight,
                                FPaintBox.Width,
                               ((FSelectedRange[0].Y)-FStartLine)*FLineHeight);
  end;

  FPaintBox.Canvas.Pen.Color := PredPen;
  FPaintBox.Canvas.Brush.Color := PredBrush;
end;

procedure TPHPEdit.MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
begin
  FFindTreeItem := False;
  FStatusBar.Panels[3].Text := '';

  SetFocus;
  FCaretMerguTimer.Enabled := False;
  if (MergCounter mod 2) <> 0 then Dec(MergCounter);

  FKeyChanged := False;
  FDelChanged := False;
  FBkChanged  := False;

  if (ssLeft in Shift) then begin
    FCutBtn.Enabled := False;
    FCopyBtn.Enabled := False;
    FCutMenu.Enabled := False;
    FCopyMenu.Enabled := False;
    FDeleteMenu.Enabled := False;
    FpmCut.Enabled := False;
    FpmCopy.Enabled := False;
    FpmDelete.Enabled := False;
  end;

  FMoveX := X;

  if ssRight in Shift then begin
    Exit;
  end;

  if not FInDBlClick then begin

    FCaretPos.X := ((X+FCharWidth div 2) div FCharWidth) + FHorsStartPos;
    FCaretPos.Y := (Y div FLineHeight) + FStartLine;

    if FCaretPos.Y >= FStringList.Count then begin
      FCaretPos.Y := FStringList.Count - 1;
    end;

    if FCaretPos.X < 1 then FCaretPos.X := 1;

    if FCaretPos.X > Length(FStringList[FCaretPos.Y]) then begin
      FCaretPos.X := Length(FStringList[FCaretPos.Y]) + 1;
    end;

    FStartSelected := True;

    if not(ssShift in Shift) then begin
      FSelectedRange[0].X := FCaretPos.X;
      FSelectedRange[0].Y := FCaretPos.Y;
      FSelectedRange[1].X := FCaretPos.X;
      FSelectedRange[1].Y := FCaretPos.Y;
      FPaintBox.Repaint;
    end else begin
      FSelectedRange[1].X := FCaretPos.X;
      FSelectedRange[1].Y := FCaretPos.Y;
      FPaintBox.Repaint;
    end;
  end
    else FCaretPos.X := FSelectedRange[1].X;

  if FSelectedRange[0].X > Length(FStringList[FSelectedRange[0].Y]) then
    FSelectedRange[0].X := Length(FStringList[FSelectedRange[0].Y]) + 1;

  if FSelectedRange[1].X > Length(FStringList[FSelectedRange[1].Y]) then
    FSelectedRange[1].X := Length(FStringList[FSelectedRange[1].Y]) + 1;

  FSRMove := True;
  FPaintBox.Repaint;

  SetScanStartLine(FCaretPos.Y);

  FStatusBar.Panels[0].Text := ' Ln:' + IntToStr(FCaretPos.Y + 1);
  FStatusBar.Panels[1].Text := ' Col:' + IntToStr(FCaretPos.X);
  FStatusBar.Refresh;
end;

procedure TPHPEdit.MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  DownPos,n,i: Integer;
begin
  FMouseX := X;
  FMouseY := Y;

  if FSRMove then begin
    FCaretPos.X := ((X+4) div FCharWidth) + FHorsStartPos;
    FCaretPos.Y := (Y div FLineHeight) + FStartLine;

    if X > FPaintBox.Width then begin
      FHorzScrollBar.Position := FHorzScrollBar.Position + 3;
    end;

    if X < 0 then begin
      FHorzScrollBar.Position := FHorzScrollBar.Position - 3;
    end;

    if FCaretPos.Y > FStringList.Count - 1 then begin
      FCaretPos.Y := FStringList.Count - 1;
    end;

    if FCaretPos.Y < 0 then begin
      FCaretPos.Y := 0;
    end;

    if FCaretPos.X < 1 then FCaretPos.X := 1;

    if FCaretPos.X > Length(FStringList[FCaretPos.Y]) then begin
      FCaretPos.X := Length(FStringList[FCaretPos.Y]) + 1;
    end;

    if (TextSelected or FStartSelected) then begin
     FSelectedRange[1].X := FCaretPos.X;
     FSelectedRange[1].Y := FCaretPos.Y;
    end;

    if Y > FPaintBox.Height then begin
      FVertScrollBar.Position := FVertScrollBar.Position + 3;
    end;
    if Y < 0 then begin
      FVertScrollBar.Position := FVertScrollBar.Position - 3;
    end;

    if FSelectedRange[0].X > Length(FStringList[FSelectedRange[0].Y]) then
      FSelectedRange[0].X := Length(FStringList[FSelectedRange[0].Y]) + 1;

    if FSelectedRange[1].X > Length(FStringList[FSelectedRange[1].Y]) then
      FSelectedRange[1].X := Length(FStringList[FSelectedRange[1].Y]) + 1;

    FPaintBox.Repaint;

    if TextSelected then begin
        FCutBtn.Enabled := True;
        FCopyBtn.Enabled := True;
        FCutMenu.Enabled := True;
        FCopyMenu.Enabled := True;
        FDeleteMenu.Enabled := True;
        FpmCut.Enabled := True;
        FpmCopy.Enabled := True;
        FpmDelete.Enabled := True;
    end else begin
        FCutBtn.Enabled := False;
        FCopyBtn.Enabled := False;
        FCutMenu.Enabled := False;
        FCopyMenu.Enabled := False;
        FDeleteMenu.Enabled := False;
        FpmCut.Enabled := False;
        FpmCopy.Enabled := False;
        FpmDelete.Enabled := False;
    end;

    SetScanStartLine(FCaretPos.Y);

    FStatusBar.Panels[0].Text := ' Ln:' + IntToStr(FCaretPos.Y + 1);
    FStatusBar.Panels[1].Text := ' Col:' + IntToStr(FCaretPos.X);
    FStatusBar.Refresh;
  end;
end;

procedure TPHPEdit.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FCaretMerguTimer.Enabled := True;

  FSRMove := False;
  FInDBlClick := False;
  FStartSelected := False;

  if TextSelected then begin
      FCutBtn.Enabled := True;
      FCopyBtn.Enabled := True;
      FCutMenu.Enabled := True;
      FCopyMenu.Enabled := True;
      FDeleteMenu.Enabled := True;
      FpmCut.Enabled := True;
      FpmCopy.Enabled := True;
      FpmDelete.Enabled := True;
  end else begin
      FCutBtn.Enabled := False;
      FCopyBtn.Enabled := False;
      FCutMenu.Enabled := False;
      FCopyMenu.Enabled := False;
      FDeleteMenu.Enabled := False;
      FpmCut.Enabled := False;
      FpmCopy.Enabled := False;
      FpmDelete.Enabled := False;
  end;
end;

function TPHPEdit.GetSelectedText: String;
var
  i: Integer;
  s: String;
begin
  s := '';
  if FSelectedRange[0].Y = FSelectedRange[1].Y then begin
     if FSelectedRange[0].X <= FSelectedRange[1].X then begin
       s := Copy(FStringList[FSelectedRange[0].Y], FSelectedRange[0].X, FSelectedRange[1].X-FSelectedRange[0].X);
     end else begin
       s := Copy(FStringList[FSelectedRange[0].Y], FSelectedRange[1].X, FSelectedRange[0].X-FSelectedRange[1].X);
     end;
  end;

  if FSelectedRange[1].Y - FSelectedRange[0].Y >= 1 then begin
    s := s + Copy(FStringList[FSelectedRange[0].Y], FSelectedRange[0].X, Length(FStringList[FSelectedRange[0].Y]))+#13#10;
    for i := FSelectedRange[0].Y + 1 to FSelectedRange[1].Y - 1 do begin
      s := s + FStringList[i]+#13#10;
    end;
    s := s + Copy(FStringList[FSelectedRange[1].Y], 1, FSelectedRange[1].X-1);
  end;

  if FSelectedRange[1].Y - FSelectedRange[0].Y <= -1 then begin
    s := s + Copy(FStringList[FSelectedRange[1].Y], FSelectedRange[1].X, Length(FStringList[FSelectedRange[1].Y]))+#13#10;
    for i := FSelectedRange[1].Y + 1 to FSelectedRange[0].Y - 1 do begin
      s := s + FStringList[i]+#13#10;
    end;
    s := s + Copy(FStringList[FSelectedRange[0].Y], 1, FSelectedRange[0].X-1);
  end;

  Result := s;
end;

procedure TPHPEdit.CopyToClipBoard;
begin
  Clipboard.AsText := GetSelectedText;
end;

procedure TPHPEdit.InsertTextBlock(Text: String; BeginY, BeginX: Integer);
var
  i,n,spos,fpos,epos,len: Integer;
  StrCount: Integer;
  S,Space: String;
  BeginS, EndS: String;
  FullLines: array of String;
  BufText: String;
  BeginPos, EndPos: TPoint;
begin
  SetScanStartLine(FCaretPos.Y);

  StrCount := 0;

  BufText := Text;
  BufText := StringReplace(BufText, #9, '  ', [rfReplaceAll, rfIgnoreCase]);

  for i := 1 to Length(BufText) do begin
    if BufText[i] = #13 then begin
      Inc(StrCount);
    end;
  end;

  if (Length(BufText) > 0) and (StrCount = 0) then begin
    Space := '';

    if BeginX-1 > Length(FStringList[BeginY]) then begin
      for i := 0 to BeginX-2 - Length(FStringList[BeginY])  do
        Space := Space + ' ';
    end;

    S := FStringList[BeginY];
    if Length(Space) > 0 then  S := S + Space;
    Insert(BufText, S, Length(Space) + BeginX);
    FStringList[BeginY] := S;
    BeginX := BeginX + Length(BufText);
    FCaretPos.X := BeginX;
    FCaretPos.Y := BeginY;     
    
    CheckMaxLineLen(S);
  end;

  if StrCount = 1 then begin
    Space := '';

    if BeginX-1 > Length(FStringList[BeginY]) then begin
      for i := 0 to BeginX-2 - Length(FStringList[BeginY])  do
        Space := Space + ' ';
    end;

    for i := 1 to Length(BufText) do begin
      if BufText[i] = #13 then begin
        fpos := i-1;
        Break;
      end;
    end;
    BeginS := Copy(BufText,1,fpos);
    EndS := Copy(BufText,fpos+3,Length(BufText)-(fpos+2));
    len := Length(EndS);
    S := FStringList[BeginY];
    BeginS := Copy(S,1,BeginX-1) + Space + BeginS;
    EndS := EndS + Copy(S,(BeginX), Length(S));

    FStringList[BeginY] := BeginS;
    FStringList.Insert(BeginY+1, EndS);

    FCaretPos.Y := BeginY + 1;
    FCaretPos.X := len+1;
  end;

  if StrCount > 1 then begin
    SetLength(FullLines, StrCount-1);

    Space := '';

    if BeginX-1 > Length(FStringList[BeginY]) then begin
      for i := 0 to BeginX-2 - Length(FStringList[BeginY])  do
        Space := Space + ' ';
    end;

    for i := 1 to Length(BufText) do begin
      if BufText[i] = #13 then begin
        fpos := i-1;
        Break;
      end;
    end;
    BeginS := Copy(BufText,1,fpos);

    for i := Length(BufText) downto 1 do begin
      if BufText[i] = #10 then begin
        epos := i+1;
        Break;
      end;
    end;
    EndS := Copy(BufText,epos,Length(BufText)-(epos-1));

    n := 0;
    spos := fpos+3;
    for i := fpos+3 to epos do begin
      if i <= Length(BufText) then begin
        if BufText[i] = #13 then begin
           S := Copy(BufText,spos,i-spos);
           FullLines[n] := S;
           spos := i+2;
           Inc(n);
        end;
      end;
    end;

    len := Length(EndS);
    S := FStringList[BeginY];
    BeginS := Copy(S,1,BeginX-1) + Space + BeginS;
    EndS := EndS + Copy(S,(BeginX), Length(S));

    FStringList[BeginY] := BeginS;

    n := 0;
    for i := 0 to Length(FullLines) - 1 do begin
      Inc(n);
      FStringList.Insert(BeginY + n, FullLines[i]);    
    end;

    Inc(n);
    FStringList.Insert(BeginY + n, EndS);

    SetLength(FLineStateAr,FStringList.Count + 1);

    FCaretPos.Y := BeginY + n;
    FCaretPos.X := len+1;

    SetLength(FullLines,0);
  end;
end;

function TPHPEdit.DeleteTextBlock(BeginPos, EndPos: TPoint): String;
var
  S: String;
  DeletedText, TopDeletedText, BottomDeletedText: String;
  BeginSelectedX, EndSelectedX: Integer;
  BeginSelectedY, EndSelectedY: Integer;
  i: Integer;
begin
  DeletedText := '';
  TopDeletedText := '';
  BottomDeletedText := '';

  if BeginPos.Y  = EndPos.Y then begin
    if BeginPos.X < EndPos.X then begin
      BeginSelectedX := BeginPos.X;
      EndSelectedX := EndPos.X;
    end else begin
      BeginSelectedX := EndPos.X;
      EndSelectedX := BeginPos.X;
    end;

    S := FStringList[BeginPos.Y];
    DeletedText := Copy(S, BeginSelectedX, EndSelectedX - BeginSelectedX);
    Delete(S, BeginSelectedX, EndSelectedX - BeginSelectedX);
    FStringList[BeginPos.Y] := S;

    FCaretPos.X := BeginSelectedX;
    FCaretPos.Y := BeginPos.Y; 
  end;

  if ABS(BeginPos.Y - EndPos.Y) >= 1 then begin
    if BeginPos.Y < EndPos.Y then begin
      S := FStringList[BeginPos.Y];
      TopDeletedText := Copy(S, BeginPos.X, Length(S) - BeginPos.X + 1) + #13#10;
      Delete(S, BeginPos.X, Length(S) - BeginPos.X + 1);
      FStringList[BeginPos.Y] := S;

      S := FStringList[EndPos.Y];
      BottomDeletedText := Copy(S, 1, EndPos.X - 1);
      Delete(S, 1, EndPos.X - 1);
      FStringList[EndPos.Y] := S;

      FStringList[BeginPos.Y] := FStringList[BeginPos.Y] + FStringList[EndPos.Y];
      FStringList.Delete(EndPos.Y);

      BeginSelectedX := BeginPos.X;
      BeginSelectedY := BeginPos.Y;
      EndSelectedX := EndPos.X;
      EndSelectedY := EndPos.Y;
    end else begin
      S := FStringList[EndPos.Y];
      TopDeletedText := Copy(S, EndPos.X, Length(S) - EndPos.X + 1) + #13#10;
      Delete(S, EndPos.X, Length(S) - EndPos.X + 1);
      FStringList[EndPos.Y] := S;

      S := FStringList[BeginPos.Y];
      BottomDeletedText := DeletedText + Copy(S, 1, BeginPos.X - 1);
      Delete(S, 1, BeginPos.X - 1);
      FStringList[BeginPos.Y] := S;

      FStringList[EndPos.Y] := FStringList[EndPos.Y] + FStringList[BeginPos.Y];
      FStringList.Delete(BeginPos.Y);

      BeginSelectedX := EndPos.X;
      BeginSelectedY := EndPos.Y;
      EndSelectedX := BeginPos.X;
      EndSelectedY := BeginPos.Y;
    end;

    for i := BeginSelectedY + 1 to EndSelectedY - 1 do begin
      DeletedText := DeletedText + FStringList[i] + #13#10;
    end;
    for i := EndSelectedY - 1 downto BeginSelectedY + 1 do begin
      FStringList.Delete(i);
    end;

    FCaretPos.X := BeginSelectedX;
    FCaretPos.Y := BeginSelectedY; 
  end;

  Result := TopDeletedText + DeletedText + BottomDeletedText;
end;

procedure TPHPEdit.CopyFromClipBoard;
var
  BufText: String;
  BeginPos: TPoint;
  i: Integer;
begin
  BufText := Clipboard.AsText;
  BufText := StringReplace(BufText, #9, '  ', [rfReplaceAll, rfIgnoreCase]);
  BufText := StringReplace(BufText, #10, #13#10, [rfReplaceAll, rfIgnoreCase]);
  BufText := StringReplace(BufText, #13#13, #13, [rfReplaceAll, rfIgnoreCase]);

  BeginPos.X := FCaretPos.X;
  BeginPos.Y := FCaretPos.Y;


  if LineNo < FCaretPos.Y then begin
    //добавить в очередь
  end else begin
    InsertTextBlock(BufText, FCaretPos.Y, FCaretPos.X);
    ActionAdd(actInsert, BeginPos, FCaretPos, BufText, '', False, nil);
  end;
end;


procedure TPHPEdit.ReCalcScrollRange;
var
  VisibleLineCount: Integer;
begin
  DCount := GetCountOfDigit(FStringList.Count);
  //15 = arrow width
  if (DCount * FCharWidth + 5) > 50 - 15 then
    FNumBox.ClientWidth := DCount * FCharWidth + 10 + 15
  else
    FNumBox.ClientWidth := 50;

  FVertScrollBar.Max := FStringList.Count;
  FStartLine := FVertScrollBar.Position;

  if (FStartLine + FPaintBox.ClientHeight div FLineHeight) < FStringList.Count then
    VisibleLineCount :=  FPaintBox.ClientHeight div FLineHeight + 1
  else
    VisibleLineCount := FStringList.Count - FStartLine;

  FEndLine := FStartLine + VisibleLineCount;
end;

procedure TPHPEdit.SetCursor(X,Y: Integer);
begin
  FCaretPos.X := X;

  if Y <= (FStringList.Count - 1) then
    FCaretPos.Y := Y
  else begin
    if FStringList.Count - 2 >= 0 then begin
      FCaretPos.Y := FStringList.Count - 2;
    end;  
  end;
  
  AlignWindowIfCursorHide;
  FStatusBar.Panels[0].Text := ' Ln:' + IntToStr(FCaretPos.Y + 1);
  FStatusBar.Panels[1].Text := ' Col:' + IntToStr(FCaretPos.X);
  FStatusBar.Refresh; 
  FPaintBox.Repaint;
end;

procedure TPHPEdit.ScrollTo(Y: Integer);
begin
  FVertScrollBar.Position := Y;
  AlignWindowIfCursorHide;
  FPaintBox.Repaint;
end;

procedure TPHPEdit.RefJumpTo(X,Y: Integer; BackDocID, BackY: Integer);
begin
  FVertScrollBar.Position := Y;
  FHorzScrollBar.Position := 0;
  AlignWindowIfCursorHide;
  FBackDocID := BackDocID;
  FBackY := BackY;
  FBackRefY := Y;
  FPaintBox.Repaint;
end;

function TPHPEdit.GetVertScrollPos: Integer;
begin
  Result := FVertScrollBar.Position;
end;

procedure TPHPEdit.HideSelection;
begin
  FSelectedRange[0].X := FCaretPos.X;
  FSelectedRange[0].Y := FCaretPos.Y;
  FSelectedRange[1].X := FCaretPos.X;
  FSelectedRange[1].Y := FCaretPos.Y;
  FStartSelected := False;
end;

procedure TPHPEdit.SetScanStartLine(LineN: Integer);
var
  i: Integer;
begin
  if LineN > 0 then
    FScanFromLine := LineN - 1
  else
    FScanFromLine := 0;
end;

procedure TPHPEdit.ValignWindowIfCursorHide;
begin
  //Scroll Up
  if FCaretPos.Y < FStartLine then begin
   if FCaretPos.Y <> FVertScrollBar.Position then begin
     FVertScrollBar.Position := FCaretPos.Y;
   end;
  end;
  //Scroll Down
  if FCaretPos.Y > FStartLine + (FPaintBox.Height div FLineHeight) - 1 then begin
   if FVertScrollBar.Position < FStringList.Count - 1 then begin
     FVertScrollBar.Position := FCaretPos.Y - (FPaintBox.Height div FLineHeight) + 1;
    end;
  end;
end;

procedure TPHPEdit.AlignWindowIfCursorHide;
begin
  //Scroll Left
  if FCaretPos.X <= FHorsStartPos then begin
     FHorzScrollBar.Position := FCaretPos.X - 2;
  end;
  //Scroll Right
  if FCaretPos.X > FHorsStartPos + FPaintBox.Width div FCharWidth then begin
     FHorzScrollBar.Position := FCaretPos.X  - (FPaintBox.Width div FCharWidth - 5);
  end;
end;

function TPHPEdit.TextSelected: Boolean;
begin
  if ((FSelectedRange[0].X - FSelectedRange[1].X) <> 0) or
     ((FSelectedRange[0].Y - FSelectedRange[1].Y) <> 0) {or FStartSelected} then
    Result := True
  else
    Result := False;
end;

function TPHPEdit.TextSelectedForFind: String;
var
  str: String;
  sfrom,sto: Integer;
begin
  str := '';
  if TextSelected then begin
    if (FSelectedRange[0].Y - FSelectedRange[1].Y) = 0 then begin
      if FSelectedRange[0].X > FSelectedRange[1].X then begin
        sfrom := FSelectedRange[1].X;
        sto := FSelectedRange[0].X - FSelectedRange[1].X;
      end
      else begin
        sfrom := FSelectedRange[0].X;
        sto := FSelectedRange[1].X - FSelectedRange[0].X;
      end;
      str := Copy(FStringList[FSelectedRange[0].Y],sfrom,sto);
    end;
  end;
  Result := str;

end;

procedure TPHPEdit.SelectAll;
begin
  FSelectedRange[0].X := 1;
  FSelectedRange[0].Y := 0;
  FSelectedRange[1].X := Length(FStringList[FStringList.Count - 1]) + 1;
  FSelectedRange[1].Y := FStringList.Count - 1;
  FCaretPos.X := Length(FStringList[FStringList.Count - 1]) + 1;
  FCaretPos.Y := FStringList.Count - 1;

  FCutBtn.Enabled := True;
  FCopyBtn.Enabled := True;
  FCutMenu.Enabled := True;
  FCopyMenu.Enabled := True;
  FDeleteMenu.Enabled := True;
  FpmCut.Enabled := True;
  FpmCopy.Enabled := True;
  FpmDelete.Enabled := True;

  FPaintBox.Repaint;
end;

procedure TPHPEdit.DblClick(Sender: TObject);
var
  i: Integer;
  Ch: Char;
  FirstChar: Boolean;
begin
  if Length(FStringList[FCaretPos.Y]) > 0 then begin
    //select word
    if FCaretPos.X <= Length(FStringList[FCaretPos.Y]) then begin
      Ch := FStringList[FCaretPos.Y][FCaretPos.X];
      if (IsCharAlpha(Ch) or (Ch in ['0'..'9','_']))  then begin

        for i := FCaretPos.X downto 1 do begin
          Ch := FStringList[FCaretPos.Y][i];
          if not (IsCharAlpha(Ch) or (Ch in ['0'..'9','_'])) then begin
            FSelectedRange[0].X := i+1;
            FSelectedRange[0].Y := FCaretPos.Y;
            Break;
          end;
          if (i = 1) then begin
            FSelectedRange[0].X := i;
            FSelectedRange[0].Y := FCaretPos.Y;
          end;
        end;

        for i := FCaretPos.X to Length(FStringList[FCaretPos.Y]) do begin
          Ch := FStringList[FCaretPos.Y][i];
          if not (IsCharAlpha(Ch) or (Ch in ['0'..'9','_'])) then begin
            FSelectedRange[1].X := i;
            FSelectedRange[1].Y := FCaretPos.Y;
            Break;
          end;
          if (i = Length(FStringList[FCaretPos.Y])) then begin
            FSelectedRange[1].X := i+1;
            FSelectedRange[1].Y := FCaretPos.Y;
          end;
        end;

      end else begin
        FirstChar := False;

        for i := FCaretPos.X downto 1 do begin
          Ch := FStringList[FCaretPos.Y][i];
          if not FirstChar and (IsCharAlpha(Ch) or (Ch in ['0'..'9','_'])) then begin
            FirstChar := True;
            FSelectedRange[1].X := i+1;
            FSelectedRange[1].Y := FCaretPos.Y;
          end;

          if FirstChar and not (IsCharAlpha(Ch) or (Ch in ['0'..'9','_']))  then begin
            FSelectedRange[0].X := i+1;
            FSelectedRange[0].Y := FCaretPos.Y;
            Break;
          end;

          if FirstChar and (i=1) then begin
            FSelectedRange[0].X := i;
            FSelectedRange[0].Y := FCaretPos.Y;
            Break;
          end;
        end;

        if (FSelectedRange[1].X - FSelectedRange[0].X = 0) then begin
          FirstChar := False;

          for i := FSelectedRange[1].X to Length(FStringList[FCaretPos.Y])  do begin
            Ch := FStringList[FCaretPos.Y][i];
            if not FirstChar and (IsCharAlpha(Ch) or (Ch in ['0'..'9','_'])) then begin
              FirstChar := True;
              FSelectedRange[0].X := i;
              FSelectedRange[0].Y := FCaretPos.Y;
            end;

            if FirstChar and not (IsCharAlpha(Ch) or (Ch in ['0'..'9','_'])) then begin
              FSelectedRange[1].X := i;
              FSelectedRange[1].Y := FCaretPos.Y;
              Break;
            end;

            if FirstChar and (i=Length(FStringList[FCaretPos.Y])) then begin
              FSelectedRange[1].X := i+1;
              FSelectedRange[1].Y := FCaretPos.Y;
              Break;
            end;
          end;
        end;
      end;
    end;
    //end select word

    if FCaretPos.X > Length(FStringList[FCaretPos.Y]) then begin
      FirstChar := False;

      for i := Length(FStringList[FCaretPos.Y]) downto 1 do begin
        Ch := FStringList[FCaretPos.Y][i];
        if not FirstChar and (IsCharAlpha(Ch) or (Ch in ['0'..'9','_'])) then begin
          FirstChar := True;
          FSelectedRange[1].X := i+1;
          FSelectedRange[1].Y := FCaretPos.Y;
        end;

        if FirstChar and not (IsCharAlpha(Ch) or (Ch in ['0'..'9','_'])) then begin
          FSelectedRange[0].X := i+1;
          FSelectedRange[0].Y := FCaretPos.Y;
          Break;
        end;

        if FirstChar and (i=1) then begin
          FSelectedRange[0].X := i;
          FSelectedRange[0].Y := FCaretPos.Y;
          Break;
        end;
      end;
    end;
    if (FSelectedRange[1].X - FSelectedRange[0].X = 0) then begin
      FSelectedRange[0].X := 1;
      FSelectedRange[0].Y := FCaretPos.Y;
      FSelectedRange[1].X := Length(FStringList[FCaretPos.Y]) + 1;
      FSelectedRange[1].Y := FCaretPos.Y;
    end;
  end;

  FInDBlClick := True;
  FPaintBox.Repaint;
end;

procedure TPHPEdit.CheckMaxLineLen(str: String);
begin
  if Length(str) > FMaxLineLength then begin
    FMaxLineLength := Length(str);
    FHorzScrollBar.Max :=FMaxLineLength + 1 + FHorzScrollBar.PageSize;
  end;
end;

procedure TPHPEdit.ScanMaxLineLen;
var
  i: Integer;
begin
  FMaxLineLength := 0;
  for i := 0 to FStringList.Count - 1 do begin
    if Length(FStringList[i]) > FMaxLineLength then
      FMaxLineLength := Length(FStringList[i]);
  end;
  FHorzScrollBar.Max :=FMaxLineLength + 1 + FHorzScrollBar.PageSize;
end;

procedure TPHPEdit.ActionAdd(AType: TActionType; BeginPos, EndPos: TPoint; Text, ReplText: String; RBlock: Boolean; Ref: PReplaceRec);
var
  i, PtrCounter: Integer;
  NextPtr: PReplaceRec;
  PtrArray: array of Pointer;
begin
  SetLength(FUndoStack, Length(FUndoStack)+1);
  FUndoStack[Length(FUndoStack)-1].ActType := AType;
  FUndoStack[Length(FUndoStack)-1].BeginPos.X := BeginPos.X;
  FUndoStack[Length(FUndoStack)-1].BeginPos.Y := BeginPos.Y;
  FUndoStack[Length(FUndoStack)-1].EndPos.X := EndPos.X;
  FUndoStack[Length(FUndoStack)-1].EndPos.Y := EndPos.Y;
  FUndoStack[Length(FUndoStack)-1].RpBlock := RBlock;
  FUndoStack[Length(FUndoStack)-1].Ref := Ref;

  FUndoStack[Length(FUndoStack)-1].Text := Text;
  FUndoStack[Length(FUndoStack)-1].ReplText := ReplText;

  {----------------------------------------------------------------------------}
  PtrCounter := 0;
  for i := 0 to Length(FRedoStack) - 1 do begin
    NextPtr := FRedoStack[i].Ref;
    while NextPtr <> nil do begin
      NextPtr := NextPtr^.Next;
      Inc(PtrCounter);
    end;
  end;

  SetLength(PtrArray, PtrCounter);
  PtrCounter := 0;
  for i := 0 to Length(FRedoStack) - 1 do begin
    NextPtr := FRedoStack[i].Ref;
    while NextPtr <> nil do begin
      PtrArray[PtrCounter] := NextPtr;
      NextPtr := NextPtr^.Next;
      Inc(PtrCounter);
    end;
  end;

  for i := 0 to Length(PtrArray) - 1 do begin
    SetLength(PReplaceRec(PtrArray[i])^.Mask, 0);
    Dispose(PtrArray[i]);
  end;

  SetLength(PtrArray, 0);
  SetLength(FRedoStack, 0);
  {----------------------------------------------------------------------------}
end;

procedure TPHPEdit.SwapUR(URType: TURType);
begin
  if URType = urUndo then begin
    SetLength(FRedoStack, Length(FRedoStack) + 1);

    FRedoStack[Length(FRedoStack) - 1].ActType := FUndoStack[Length(FUndoStack) - 1].ActType;
    FRedoStack[Length(FRedoStack) - 1].Text := FUndoStack[Length(FUndoStack) - 1].Text;
    FRedoStack[Length(FRedoStack) - 1].ReplText := FUndoStack[Length(FUndoStack) - 1].ReplText;
    FRedoStack[Length(FRedoStack) - 1].BeginPos.X := FUndoStack[Length(FUndoStack) - 1].BeginPos.X;
    FRedoStack[Length(FRedoStack) - 1].BeginPos.Y := FUndoStack[Length(FUndoStack) - 1].BeginPos.Y;
    FRedoStack[Length(FRedoStack) - 1].EndPos.X := FUndoStack[Length(FUndoStack) - 1].EndPos.X;
    FRedoStack[Length(FRedoStack) - 1].EndPos.Y := FUndoStack[Length(FUndoStack) - 1].EndPos.Y;
    FRedoStack[Length(FRedoStack) - 1].RpBlock := FUndoStack[Length(FUndoStack) - 1].RpBlock;
    FRedoStack[Length(FRedoStack) - 1].Ref := FUndoStack[Length(FUndoStack) - 1].Ref;
  end;

  if URType = urRedo then begin
    SetLength(FUndoStack, Length(FUndoStack) + 1);

    FUndoStack[Length(FUndoStack) - 1].ActType := FRedoStack[Length(FRedoStack) - 1].ActType;
    FUndoStack[Length(FUndoStack) - 1].Text := FRedoStack[Length(FRedoStack) - 1].Text;
    FUndoStack[Length(FUndoStack) - 1].ReplText := FRedoStack[Length(FRedoStack) - 1].ReplText;    
    FUndoStack[Length(FUndoStack) - 1].BeginPos.X := FRedoStack[Length(FRedoStack) - 1].BeginPos.X;
    FUndoStack[Length(FUndoStack) - 1].BeginPos.Y := FRedoStack[Length(FRedoStack) - 1].BeginPos.Y;
    FUndoStack[Length(FUndoStack) - 1].EndPos.X := FRedoStack[Length(FRedoStack) - 1].EndPos.X;
    FUndoStack[Length(FUndoStack) - 1].EndPos.Y := FRedoStack[Length(FRedoStack) - 1].EndPos.Y;
    FUndoStack[Length(FUndoStack) - 1].RpBlock := FRedoStack[Length(FRedoStack) - 1].RpBlock;
    FUndoStack[Length(FUndoStack) - 1].Ref := FRedoStack[Length(FRedoStack) - 1].Ref;
  end;
end;

procedure TPHPEdit.Undo;
var
  TopIndex: Integer;
  BeginPos, EndPos: TPoint;
  S, InsS: String;
  NextPtr: PReplaceRec;
  ScanFrom, CurLine, shf, replcounter: Integer;
  i, PrLen: Integer;
  ValignBlock: Boolean;
begin
  FKeyChanged := False;
  FDelChanged := False;
  FBkChanged  := False;
  ValignBlock := False;
  
  if Length(FUndoStack) = 0 then Exit;
  TopIndex := Length(FUndoStack) - 1;
  if FUndoStack[TopIndex].BeginPos.Y >= LineNo then begin
    Exit;
  end;

  BeginPos.X := FUndoStack[TopIndex].BeginPos.X;
  BeginPos.Y := FUndoStack[TopIndex].BeginPos.Y;
  EndPos.X := FUndoStack[TopIndex].EndPos.X;
  EndPos.Y := FUndoStack[TopIndex].EndPos.Y;
  ScanFrom := BeginPos.Y;

  SwapUR(urUndo);

  if FUndoStack[TopIndex].ActType = actInsert then begin
    DeleteTextBlock(BeginPos, EndPos);
    SetLength(FUndoStack, Length(FUndoStack) - 1);
    ValignBlock := True;
  end else if FUndoStack[TopIndex].ActType = actDelete then begin
    InsertTextBlock(FUndoStack[TopIndex].Text, BeginPos.Y, BeginPos.X);
    SetLength(FUndoStack, Length(FUndoStack) - 1);
    ValignBlock := True;
  end else if FUndoStack[TopIndex].ActType = actReplace then begin
    replcounter := 0;
    CurLine := 0;
    shf := 0;

    NextPtr := FUndoStack[TopIndex].Ref;
    while NextPtr <> nil do begin
      Inc(replcounter);
      BeginPos.X := NextPtr^.X;
      BeginPos.Y := NextPtr^.Y;
      EndPos.X := NextPtr^.X + Length(FUndoStack[TopIndex].ReplText);
      EndPos.Y := NextPtr^.Y;

      if BeginPos.Y <> CurLine then begin
        CurLine := BeginPos.Y;
        shf := 0;
      end;
      
      S := FStringList[BeginPos.Y];
      PrLen := Length(S);
      Delete(S, BeginPos.X-shf, Length(FUndoStack[TopIndex].ReplText));
      InsS := FUndoStack[TopIndex].Text;
      for i := 0 to Length(NextPtr^.Mask) - 1 do begin
        if NextPtr^.Mask[i] <> #0 then InsS[i+1] := NextPtr^.Mask[i];
      end;
      Insert(InsS, S, BeginPos.X-shf);
      FStringList[BeginPos.Y] := S;
      shf := shf + (Length(FUndoStack[TopIndex].ReplText) -  Length(FUndoStack[TopIndex].Text));

      NextPtr := NextPtr^.Next;
      if ScanFrom > BeginPos.Y then ScanFrom := BeginPos.Y;
    end;

    if FUndoStack[TopIndex].RpBlock then begin
      FCaretPos.Y := BeginPos.Y;
      FCaretPos.X := 1;
      ValignBlock := True;
    end
    else if (replcounter = 1)  then begin
      FCaretPos.X := BeginPos.X + Length(FUndoStack[TopIndex].Text);
      FCaretPos.Y := BeginPos.Y;
    end;

    SetLength(FUndoStack, Length(FUndoStack) - 1);
  end;

  SetLength(FLineStateAr, FStringList.Count + 1);
  ReCalcScrollRange;
  SetScanStartLine(ScanFrom);
  ScanMaxLineLen;
  if (replcounter = 1) or ValignBlock then begin
    ValignWindowIfCursorHide;
    AlignWindowIfCursorHide;
  end;
  GoScan;
end;

procedure TPHPEdit.Redo;
var
  TopIndex: Integer;
  BeginPos, EndPos: TPoint;
  S: String;
  Nx: Boolean;
  NextPtr: PReplaceRec;
  ScanFrom, replcounter: Integer;
  replflag: Boolean;
  ValignBlock: Boolean;
begin
  FKeyChanged := False;
  FDelChanged := False;
  FBkChanged  := False;
  replflag := False;
  ValignBlock := False;
  
  if Length(FRedoStack) = 0 then Exit;
  TopIndex := Length(FRedoStack) - 1;
  if FRedoStack[TopIndex].BeginPos.Y >= LineNo then begin
    Exit;
  end;

  BeginPos.X := FRedoStack[TopIndex].BeginPos.X;
  BeginPos.Y := FRedoStack[TopIndex].BeginPos.Y;
  EndPos.X := FRedoStack[TopIndex].EndPos.X;
  EndPos.Y := FRedoStack[TopIndex].EndPos.Y;
  ScanFrom := BeginPos.Y;

  SwapUR(urRedo);

  if FRedoStack[TopIndex].ActType = actInsert then begin
    InsertTextBlock(FRedoStack[TopIndex].Text, BeginPos.Y, BeginPos.X);
    SetLength(FRedoStack, Length(FRedoStack) - 1);
    ValignBlock := True;
  end else if FRedoStack[TopIndex].ActType = actDelete then begin
    DeleteTextBlock(BeginPos, EndPos);
    SetLength(FRedoStack, Length(FRedoStack) - 1);
    ValignBlock := True;
  end else if FRedoStack[TopIndex].ActType = actReplace then begin
    NextPtr := FRedoStack[TopIndex].Ref;
    replcounter := 0;

    while NextPtr <> nil do begin
      Inc(replcounter);
      BeginPos.X := NextPtr^.X;
      BeginPos.Y := NextPtr^.Y;
      EndPos.X := NextPtr^.X + Length(FRedoStack[TopIndex].Text);
      EndPos.Y := NextPtr^.Y;

      S := FStringList[BeginPos.Y];
      Delete(S, BeginPos.X, Length(FRedoStack[TopIndex].Text));
      Insert(FRedoStack[TopIndex].ReplText, S, BeginPos.X);
      FStringList[BeginPos.Y] := S;

      NextPtr := NextPtr^.Next;
      //ScanFrom := BeginPos.Y;
      if ScanFrom > BeginPos.Y then ScanFrom := BeginPos.Y;
    end;

    if FRedoStack[TopIndex].RpBlock then begin
      FCaretPos.Y := BeginPos.Y;
      FCaretPos.X := 1;
      ValignBlock := True;
    end
    else if replcounter = 1 then begin
      FCaretPos.X := BeginPos.X + Length(FRedoStack[TopIndex].ReplText);
      FCaretPos.Y := BeginPos.Y;
    end
    else if replcounter > 1 then begin
      replflag :=  True;
    end;
    
    SetLength(FRedoStack, Length(FRedoStack) - 1);
  end;
  
  SetLength(FLineStateAr, FStringList.Count + 1);
  ReCalcScrollRange;
  SetScanStartLine(ScanFrom);
  ScanMaxLineLen;
  if not replflag or ValignBlock then begin
    ValignWindowIfCursorHide;
    AlignWindowIfCursorHide;
  end;
  GoScan;
end;

procedure TPHPEdit.Update;
begin
  FPaintBox.Repaint;
end;

procedure TPHPEdit.ReScale;
begin
  FScrollSeparator.Width := FVertScrollBar.Width;
  FScrollSeparator.Height := FVertScrollBar.Width;
  FHorzScrollPanel.Height := FVertScrollBar.Width;
  FPaintBox.Repaint;
  FNumBox.Repaint;
end;

procedure TPHPEdit.AddCurlPHP(X,Y: Integer; Level: Integer; Tp: Byte);
var
  i: Integer;
begin
  if Tp = 1 then begin
    if (Length(FCurlBlockArrayPHP) - 20) < FNewCurlPosPHP then begin
      SetLength(FCurlBlockArrayPHP, Length(FCurlBlockArrayPHP) + 40);
    end;
    FCurlBlockArrayPHP[FNewCurlPosPHP].BBegin.X := X;
    FCurlBlockArrayPHP[FNewCurlPosPHP].BBegin.Y := Y;
    FCurlBlockArrayPHP[FNewCurlPosPHP].BEnd.X := 0;
    FCurlBlockArrayPHP[FNewCurlPosPHP].BEnd.Y := 0;
    FCurlBlockArrayPHP[FNewCurlPosPHP].Level := Level;
    FCurlBlockArrayPHP[FNewCurlPosPHP].Visit := False;
    Inc(FNewCurlPosPHP);
  end
  else if Tp = 0 then begin
    for i := FNewCurlPosPHP - 1 downto 0 do begin
      if not FCurlBlockArrayPHP[i].Visit then begin
        FCurlBlockArrayPHP[i].Visit := True;
        FCurlBlockArrayPHP[i].BEnd.X := X;
        FCurlBlockArrayPHP[i].BEnd.Y := Y;
        Break;
      end;
    end;
  end;
end;

procedure TPHPEdit.AddCurlJS(X,Y: Integer; Level: Integer; Tp: Byte);
var
  i: Integer;
begin
  if Tp = 1 then begin
    if (Length(FCurlBlockArrayJS) - 20) < FNewCurlPosJS then begin
      SetLength(FCurlBlockArrayJS, Length(FCurlBlockArrayJS) + 40);
    end;
    FCurlBlockArrayJS[FNewCurlPosJS].BBegin.X := X;
    FCurlBlockArrayJS[FNewCurlPosJS].BBegin.Y := Y;
    FCurlBlockArrayJS[FNewCurlPosJS].BEnd.X := 0;
    FCurlBlockArrayJS[FNewCurlPosJS].BEnd.Y := 0;
    FCurlBlockArrayJS[FNewCurlPosJS].Level := Level;
    FCurlBlockArrayJS[FNewCurlPosJS].Visit := False;
    Inc(FNewCurlPosJS);
  end
  else if Tp = 0 then begin
    for i := FNewCurlPosJS - 1 downto 0 do begin
      if not FCurlBlockArrayJS[i].Visit then begin
        FCurlBlockArrayJS[i].Visit := True;
        FCurlBlockArrayJS[i].BEnd.X := X;
        FCurlBlockArrayJS[i].BEnd.Y := Y;
        Break;
      end;
    end;
  end;
end;

procedure TPHPEdit.RescanCurlBlocksPHP(StartLine: Integer);
var
  i,j: Integer;
begin
  for j := FNewCurlPosPHP to Length(FCurlBlockArrayPHP) - 1 do begin
    FCurlBlockArrayPHP[j].BBegin.Y := 0;
    FCurlBlockArrayPHP[j].BBegin.X := 0;
    FCurlBlockArrayPHP[j].BEnd.Y := 0;
    FCurlBlockArrayPHP[j].BEnd.X := 0;
    FCurlBlockArrayPHP[j].Visit := False;
  end;

  for i := 0 to Length(FCurlBlockArrayPHP) - 1 do begin
    if (FCurlBlockArrayPHP[i].BBegin.Y >= StartLine) then begin
      FNewCurlPosPHP := i;
      Break;
    end;
  end;

  for j := FNewCurlPosPHP - 1 downto 0 do begin
    if FCurlBlockArrayPHP[j].BEnd.Y >= StartLine then begin
      FCurlBlockArrayPHP[j].Visit := False;
    end;
  end;
end;

procedure TPHPEdit.RescanCurlBlocksJS(StartLine: Integer);
var
  i,j: Integer;
begin
  for j := FNewCurlPosJS to Length(FCurlBlockArrayJS) - 1 do begin
    FCurlBlockArrayJS[j].BBegin.Y := 0;
    FCurlBlockArrayJS[j].BBegin.X := 0;
    FCurlBlockArrayJS[j].BEnd.Y := 0;
    FCurlBlockArrayJS[j].BEnd.X := 0;
    FCurlBlockArrayJS[j].Visit := False;
  end;

  for i := 0 to Length(FCurlBlockArrayJS) - 1 do begin
    if (FCurlBlockArrayJS[i].BBegin.Y >= StartLine) then begin
      FNewCurlPosJS := i;
      Break;
    end;
  end;

  for j := FNewCurlPosJS - 1 downto 0 do begin
    if FCurlBlockArrayJS[j].BEnd.Y >= StartLine then begin
      FCurlBlockArrayJS[j].Visit := False;
    end;
  end;
end;

procedure TPHPEdit.AddState(var StateAr: TStateArray; LineN:Integer; State: TState; var NewPos: Integer; j: Integer);
var
  i,slen: Integer;
begin
  if (Length(StateAr[LineN].Pos) - 5) < NewPos then begin
    SetLength(StateAr[LineN].Pos, Length(StateAr[LineN].Pos) + 10);
    SetLength(StateAr[LineN].J, Length(StateAr[LineN].J) + 10);
  end;

  if NewPos > 0 then begin
    slen := j - StateAr[LineN].J[NewPos-1];

    if slen > FBigStringPartLen then begin
      for i := 0 to (slen div FBigStringPartLen) - 1 do begin
        StateAr[LineN].Pos[NewPos] := StateAr[LineN].Pos[NewPos-1];
        StateAr[LineN].J[NewPos] :=  StateAr[LineN].J[NewPos-1] + FBigStringPartLen;
        StateAr[LineN].Max := NewPos;
        Inc(NewPos);

        if (Length(StateAr[LineN].Pos) - 5) < NewPos then begin
          SetLength(StateAr[LineN].Pos, Length(StateAr[LineN].Pos) + 10);
          SetLength(StateAr[LineN].J, Length(StateAr[LineN].J) + 10);
        end;
      end;

      StateAr[LineN].Pos[NewPos] := State;
      StateAr[LineN].J[NewPos] :=  StateAr[LineN].J[NewPos-1] + slen mod FBigStringPartLen;
      StateAr[LineN].Max := NewPos;
    end else begin
      StateAr[LineN].Pos[NewPos] := State;
      StateAr[LineN].J[NewPos] := j;
      StateAr[LineN].Max := NewPos;
    end
  end else begin
    StateAr[LineN].Pos[NewPos] := State;
    StateAr[LineN].J[NewPos] := j;
    StateAr[LineN].Max := NewPos;
  end;

end;

procedure TPHPEdit.ResetScaner(StartLine: Integer);
var
  i,j: Integer;
begin
  gS := ''; //FStringList[StartLine];
  CurWord := '';
  LinePos := 0;
  LineNo := StartLine;
  LineNoTr := Length(FLineStateAr);
  gi := 2;
  Next := True;

  if StartLine > 0 then begin
    FLevelPHP := FLineStateAr[LineNo-1].LevelPHP;
    FLevelJS := FLineStateAr[LineNo-1].LevelJS;
  end
  else begin
    FLevelPHP := 0;
    FLevelJS := 0;
  end;

  RescanCurlBlocksPHP(StartLine);
  RescanCurlBlocksJS(StartLine);

  if LineNo = 0 then begin
    case ScanMode of
      smPHP,smHTML,smXML,smTXT: State := ScanNormal;
      smJS: State := ScanJSBody;
      smCSS: State := ScanCSSBody;
    end;

  end else if FLineStateAr[LineNo-1].Max <> 0 then
    State := FLineStateAr[LineNo-1].Pos[FLineStateAr[LineNo-1].Max]
  else begin
    case ScanMode of
      smPHP,smHTML,smXML,smTXT: State := ScanNormal;
      smJS: State := ScanJSBody;
      smCSS: State := ScanCSSBody;
    end;
  end;

  if LineNo > 0 then begin
    if (FLineStateAr[LineNo-1].Max = 0) and (Length(FLineStateAr[LineNo-1].Pos) > 0) then begin
      State := FLineStateAr[LineNo-1].Pos[FLineStateAr[LineNo-1].Max];
    end;
  end
  else begin

  end;

  AddState(FLineStateAr, LineNo, State, LinePos, 1);
  Inc(LinePos);
end;

procedure TPHPEdit.ScanText(var StateAr: TStateArray);
const
  BiDelimList: array[0..7] of String = ('>=', '<=', '!=', '==','||','/*','*/','//');
var
  Ch, NextCh: Char;
  BiDelim: String;
  FirstVarCh: Boolean;
  i,j: Integer;

  function FindBiDelim(const BiDelim: String): Boolean;
  var
    i: Integer;
    Res: Boolean;
  begin
    Res := False;
    for i := 0 to Length(BiDelimList) - 1 do begin
      if BiDelim = BiDelimList[i] then begin
        Res := True;
        Break;
      end;
    end;
    Result := Res;
  end;

  function isDigit(const Digit: String): Boolean;
  var
    i: Integer;
    Res: Boolean;
  begin
    Res := True;
    {not digit}
    if not(Digit[1] in ['0'..'9']) then begin
      Result := False;
      Exit;
    end;
    {2,16}
    if (Digit[1] = '0') and (Length(Digit) > 2) then begin
      {2}
      if (Digit[2] = 'b') then begin
        for i := 3 to Length(Digit) do begin
          if not(Digit[i] in ['0','1']) then begin
            Res := False;
            Break;
          end;
        end;
      end
      {16}
      else if (Digit[2] = 'x') or (Digit[2] = 'X') then begin
        for i := 3 to Length(Digit) do begin
          if not(Digit[i] in ['0'..'9','a','b','c','d','e','f', 'A', 'B', 'C', 'D', 'E', 'F']) then begin
            Res := False;
            Break;
          end;
        end;
      end
      {8}
      else  begin
        for i := 3 to Length(Digit) do begin
          if not(Digit[i] in ['0'..'9']) then begin {or ['0'..'7']}
            Res := False;
            Break;
          end;
        end;
      end
    end
    {8,10}
    else begin
      for i := 2 to Length(Digit) do begin
        if not(Digit[i] in ['0'..'9']) then begin
          Res := False;
          Break;
        end;
      end;
    end;
    Result := Res;
  end;

begin
  InScan := True;

  while LineNo < FStringList.Count  do begin
    if FTerminate then
      Break
    else begin
      gS := FStringList[LineNo] + #13#10;
      gi := 2;

      case FScanMode of
        smPHP: begin
          //AddState(FLineStateAr, LineNo, ScanNormal, LinePos, 1);
          //Inc(LinePos);
          
          while gi <= Length(gS) + 1 do begin
            Ch := gS[gi-1];
            if gi <= Length(gS) then
              NextCh := gS[gi]
            else NextCh := #32;

            case State of
              ScanNormal: begin
                if Copy(gS,gi-1,5) = '<?php' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanNormal;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanNormal;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanNormal;
                end
                else if (LowerCase(Copy(gS,gi-1,6)) = '<style')  then begin
                  if (Length(gS) >= (gi + 5)) and (gS[gi+5] in Delim) then begin
                    State := ScanCSSTag;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,5);
                    State := ScanOpenCSS;
                    AddState(StateAr, LineNo, State, LinePos, gi);
                    Inc(LinePos);
                  end;
                end
                else if (LowerCase(Copy(gS,gi-1,7)) = '<script') then begin
                  if (Length(gS) >= (gi + 6)) and (gS[gi+6] in Delim) then begin
                    State := ScanJSTag;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,6);
                    State := ScanOpenJS;
                    AddState(StateAr, LineNo, State, LinePos, gi);
                    Inc(LinePos);
                  end;
                end
                else if (Ch = '<') and (NextCh = '/') then begin
                  for i := gi+1 to Length(gs) do begin
                    if (gS[i] in Delim) then begin
                      if CurWord <> '' then begin
                        if LowerCase(CurWord) = 'style' then begin
                          AddState(StateAr, LineNo, ScanCSSTag, LinePos, i-Length(CurWord)-2);
                          Inc(LinePos);
                          State := ScanCloseCSS;
                          AddState(StateAr, LineNo, State, LinePos, i);
                          Inc(LinePos);
                          gi := i;
                        end
                        else if FHtmlTagList.Find(CurWord, FIndex) then begin
                          AddState(StateAr, LineNo, ScanHTMLTag, LinePos, i-Length(CurWord)-2);
                          Inc(LinePos);
                          State := ScanCloseHTML;
                          AddState(StateAr, LineNo, State, LinePos, i);
                          Inc(LinePos);
                          gi := i;
                        end;
                      end;
                      CurWord := '';
                      Break;
                    end else
                     CurWord := CurWord + gS[i];
                  end;
                end
                else if Copy(gS,gi-1,4) = '<!--' then begin
                  State := ScanHTMLComment;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Inc(gi,3);
                end
                else if (Copy(gS,gi-1,2) = '<!') then begin
                  if (Length(gS) >= gi+1) and (gS[gi+1] in ['a'..'z','A'..'Z']) then begin
                    State := ScanHTMLHeader;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,1);
                  end;
                end
                else if Ch = '<' then begin

                  for i := gi to Length(gs) do begin
                    if (gS[i] in Delim) then begin
                      if CurWord <> '' then begin
                        if FHtmlTagList.Find(CurWord, FIndex) then begin
                          AddState(StateAr, LineNo, ScanHTMLTag, LinePos, i-Length(CurWord)-1);
                          Inc(LinePos);
                          State := ScanOpenHTML;
                          AddState(StateAr, LineNo, State, LinePos, i);
                          Inc(LinePos);
                          gi := i;
                        end;
                      end;
                      CurWord := '';
                      Break;
                    end else
                     CurWord := CurWord + gS[i];
                  end;

                end;
              end;

              {HTMLSCAN HTMLSCAN HTMLSCAN HTMLSCAN HTMLSCAN HTMLSCAN HTMLSCAN}
              ScanOpenHTML: begin
                if Copy(gS,gi-1,5) = '<?php' then begin

                  if (CurWord <> '')  then begin
                    if (FHtmlAttrList.Find(CurWord, FIndex)) or (FHtmlMethodsList.Find(CurWord, FIndex)) then begin
                      AddState(StateAr, LineNo, ScanHTMLAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanOpenHTML, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;

                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanOpenHTML;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin

                  if (CurWord <> '')  then begin
                    if (FHtmlAttrList.Find(CurWord, FIndex)) or (FHtmlMethodsList.Find(CurWord, FIndex)) then begin
                      AddState(StateAr, LineNo, ScanHTMLAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanOpenHTML, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;

                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanOpenHTML;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin

                  if (CurWord <> '')  then begin
                    if (FHtmlAttrList.Find(CurWord, FIndex)) or (FHtmlMethodsList.Find(CurWord, FIndex)) then begin
                      AddState(StateAr, LineNo, ScanHTMLAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanOpenHTML, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;

                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanOpenHTML;
                end
                else if Copy(gS,gi-1,4) = '<!--' then begin
                  State := ScanHTMLComment;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Inc(gi,3);
                end
                else if (Copy(gS,gi-1,2) = '<!') then begin
                  if (Length(gS) >= gi+1) and (gS[gi+1] in ['a'..'z','A'..'Z']) then begin
                    State := ScanHTMLHeader;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,1); {or Inc(gi,1)}
                  end;
                end
                else if (Ch in Delim) and (Ch <> '-')  then begin
                  if (CurWord <> '')  then begin
                    if (FHtmlAttrList.Find(CurWord, FIndex)) or (FHtmlMethodsList.Find(CurWord, FIndex)) then begin
                      AddState(StateAr, LineNo, ScanHTMLAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                      AddState(StateAr, LineNo, ScanOpenHTML, LinePos, gi-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanOpenHTML, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;

                  if (Ch = '/') and (NextCh = '>') then begin
                    AddState(StateAr, LineNo, ScanHTMLTag, LinePos, gi-1);
                    Inc(LinePos);
                    State := ScanNormal;
                    AddState(StateAr, LineNo, State, LinePos, gi+1);
                    Inc(LinePos);
                  end
                  else if Ch = '>' then begin
                    AddState(StateAr, LineNo, ScanHTMLTag, LinePos, gi-1);
                    Inc(LinePos);
                    State := ScanNormal;
                    AddState(StateAr, LineNo, State, LinePos, gi);
                    Inc(LinePos);
                  end
                  else if Ch = '"' then begin
                    State := ScanDblQHTML;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end
                  else if Ch = '''' then begin
                    State := ScanSingQHTML;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end;
                end
                else
                  CurWord := CurWord + Ch;
              end;

              ScanDblQHTML: begin
                if Copy(gS,gi-1,5) = '<?php' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanDblQHTML;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanDblQHTML;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanDblQHTML;
                end
                else if Ch = '"' then begin
                  State := ScanOpenHTML;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;

              ScanSingQHTML: begin
                if Copy(gS,gi-1,5) = '<?php' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanSingQHTML;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanSingQHTML;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanSingQHTML;
                end
                else if Ch = '''' then begin
                  State := ScanOpenHTML;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;

              ScanCloseHTML: begin
                if Copy(gS,gi-1,5) = '<?php' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanCloseHTML;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanCloseHTML;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanCloseHTML;
                end
                else if Copy(gS,gi-1,4) = '<!--' then begin
                  State := ScanHTMLComment;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Inc(gi,3);
                end
                else if (Copy(gS,gi-1,2) = '<!') then begin
                  if (Length(gS) >= gi+1) and (gS[gi+1] in ['a'..'z','A'..'Z']) then begin
                    State := ScanHTMLHeader;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,1);
                  end;
                end
                else if Ch = '>' then begin
                  AddState(StateAr, LineNo, ScanHTMLTag, LinePos, gi-1);
                  Inc(LinePos);
                  State := ScanNormal;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;

              ScanHTMLComment: begin
                if Copy(gS,gi-1,5) = '<?php' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanHTMLComment;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanHTMLComment;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanHTMLComment;
                end
                else if Copy(gS,gi-1,3) = '-->' then begin
                  State := ScanNormal;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                end
              end;

              ScanHTMLHeader: begin
                if Copy(gS,gi-1,5) = '<?php' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanHTMLHeader;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanHTMLHeader;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanHTMLHeader;
                end
                else if Ch = '>' then begin
                  AddState(StateAr, LineNo, ScanHTMLHeader, LinePos, gi);
                  Inc(LinePos);
                  State := ScanNormal;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end
              end; 
              {END SCANHTML END SCANHTML END SCANHTML END SCANHTML END SCANHTML}
              {----------------------------------------------------------------}
              {SCANCSS SCANCSS SCANCSS SCANCSS SCANCSS SCANCSS SCANCSS SCANCSS }
              ScanOpenCSS: begin
                if Copy(gS,gi-1,5) = '<?php' then begin

                  if (CurWord <> '')  then begin
                    if (FHtmlAttrList.Find(CurWord, FIndex)) or (FHtmlMethodsList.Find(CurWord, FIndex)) then begin
                      AddState(StateAr, LineNo, ScanHTMLAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanOpenCSS, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;

                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanOpenCSS;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin

                  if (CurWord <> '')  then begin
                    if (FHtmlAttrList.Find(CurWord, FIndex)) or (FHtmlMethodsList.Find(CurWord, FIndex)) then begin
                      AddState(StateAr, LineNo, ScanHTMLAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanOpenCSS, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;

                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanOpenCSS;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin

                  if (CurWord <> '')  then begin
                    if (FHtmlAttrList.Find(CurWord, FIndex)) or (FHtmlMethodsList.Find(CurWord, FIndex)) then begin
                      AddState(StateAr, LineNo, ScanHTMLAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanOpenCSS, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;

                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanOpenCSS;
                end
                else if Copy(gS,gi-1,4) = '<!--' then begin
                  State := ScanHTMLComment;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Inc(gi,3);
                end
                else if (Copy(gS,gi-1,2) = '<!') then begin
                  if (Length(gS) >= gi+1) and (gS[gi+1] in ['a'..'z','A'..'Z']) then begin
                    State := ScanHTMLHeader;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,1);
                  end;
                end
                else if (Ch in Delim)  then begin
                  if (CurWord <> '')  then begin
                    if (FHtmlAttrList.Find(CurWord, FIndex)) or (FHtmlMethodsList.Find(CurWord, FIndex))then begin
                      AddState(StateAr, LineNo, ScanHTMLAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                      AddState(StateAr, LineNo, ScanOpenCSS, LinePos, gi-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanOpenCSS, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;

                  if (Ch = '/') and (NextCh = '>') then begin
                    AddState(StateAr, LineNo, ScanCSSTag, LinePos, gi-1);
                    Inc(LinePos);
                    State := ScanNormal;
                    AddState(StateAr, LineNo, State, LinePos, gi+1);
                    Inc(LinePos);
                  end
                  else if Ch = '>' then begin
                    AddState(StateAr, LineNo, ScanCSSTag, LinePos, gi-1);
                    Inc(LinePos);
                    State := ScanCSSBody;
                    AddState(StateAr, LineNo, State, LinePos, gi);
                    Inc(LinePos);
                  end
                  else if Ch = '"' then begin
                    State := ScanDblQCSS;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end
                  else if Ch = '''' then begin
                    State := ScanSingQCSS;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end;
                end
                else
                  CurWord := CurWord + Ch;
              end;

              ScanDblQCSS: begin
                if Copy(gS,gi-1,5) = '<?php' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanDblQCSS;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanDblQCSS;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanDblQCSS;
                end
                else if Ch = '"' then begin
                  State := ScanOpenCSS;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;

              ScanSingQCSS: begin
                if Copy(gS,gi-1,5) = '<?php' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanSingQCSS;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanSingQCSS;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanSingQCSS;
                end
                else if Ch = '''' then begin
                  State := ScanOpenCSS;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;
          
              ScanCloseCSS: begin
                if Copy(gS,gi-1,5) = '<?php' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanCloseCSS;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanCloseCSS;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanCloseCSS;
                end
                else if Copy(gS,gi-1,4) = '<!--' then begin
                  State := ScanHTMLComment;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Inc(gi,3);
                end
                else if (Copy(gS,gi-1,2) = '<!') then begin
                  if (Length(gS) >= gi+1) and (gS[gi+1] in ['a'..'z','A'..'Z']) then begin
                    State := ScanHTMLHeader;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,1); {or Inc(gi,1)}
                  end;
                end
                else if Ch = '>' then begin
                  AddState(StateAr, LineNo, ScanCSSTag, LinePos, gi-1);
                  Inc(LinePos);
                  State := ScanNormal;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;

              ScanCSSBody: begin
                if Copy(gS,gi-1,5) = '<?php' then begin

                  if (CurWord <> '')  then begin
                    if FCSSAttrList.Find(CurWord, FIndex) then begin
                      AddState(StateAr, LineNo, ScanCSSAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanCSSBody, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;

                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanCSSBody;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin

                  if (CurWord <> '')  then begin
                    if FCSSAttrList.Find(CurWord, FIndex) then begin
                      AddState(StateAr, LineNo, ScanCSSAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanCSSBody, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;

                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanCSSBody;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin

                  if (CurWord <> '')  then begin
                    if FCSSAttrList.Find(CurWord, FIndex) then begin
                      AddState(StateAr, LineNo, ScanCSSAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanCSSBody, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;

                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanCSSBody;
                end
                else if (Ch = '<') and (NextCh = '/') then begin

                  if (CurWord <> '')  then begin
                    if FCSSAttrList.Find(CurWord, FIndex) then begin
                      AddState(StateAr, LineNo, ScanCSSAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanCSSBody, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;

                  for i := gi+1 to Length(gs) do begin
                    if (gS[i] in Delim) then begin
                      if CurWord <> '' then begin
                        if LowerCase(CurWord) = 'style' then begin
                          AddState(StateAr, LineNo, ScanCSSTag, LinePos, i-Length(CurWord)-2);
                          Inc(LinePos);
                          State := ScanCloseCSS;
                          AddState(StateAr, LineNo, State, LinePos, i);
                          Inc(LinePos);
                          gi := i;
                        end
                      end;
                      CurWord := '';
                      Break;
                    end else
                      CurWord := CurWord + gS[i];
                  end;
                end;

                if (Ch in Delim) and (Ch <> '-')  then begin
                  if (CurWord <> '')  then begin
                    if FCSSAttrList.Find(CurWord, FIndex) then begin
                      AddState(StateAr, LineNo, ScanCSSAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                      AddState(StateAr, LineNo, ScanCSSBody, LinePos, gi-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanCSSBody, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;
                end;

                if (Ch = '/') and (NextCh = '*') then begin
                  state := ScanCSSComment;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Inc(gi);
                end
                else if Ch = '{' then begin
                  AddState(StateAr, LineNo, ScanOpenCurlCSS, LinePos, gi-1);
                  Inc(LinePos);
                  AddState(StateAr, LineNo, ScanCSSBody, LinePos, gi);
                  Inc(LinePos);
                end
                else if Ch = '}' then begin
                  AddState(StateAr, LineNo, ScanCloseCurlCSS, LinePos, gi-1);
                  Inc(LinePos);
                  AddState(StateAr, LineNo, ScanCSSBody, LinePos, gi);
                  Inc(LinePos);
                end;


                if not(Ch in Delim) then CurWord := CurWord + Ch;
                if (Ch = '-') then CurWord := CurWord + Ch;
              end;

              ScanCSSComment: begin
              if Copy(gS,gi-1,5) = '<?php' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanCSSComment;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanCSSComment;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanCSSComment;
                end
                else if (Ch = '*') and (NextCh = '/') then begin
                  State := ScanCSSBody;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                end;
              end;
              {END SCANCSS END SCANCSS END SCANCSS END SCANCSS END SCANCSS}
              {-----------------------------------------------------------}
              {SCANJS SCANJS SCANJS SCANJS SCANJS SCANJS SCANJS SCANJS SCANJS}
              ScanOpenJS: begin
                if Copy(gS,gi-1,5) = '<?php' then begin

                  if (CurWord <> '')  then begin
                    if (FHtmlAttrList.Find(CurWord, FIndex)) or (FHtmlMethodsList.Find(CurWord, FIndex)) then begin
                      AddState(StateAr, LineNo, ScanHTMLAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanOpenCSS, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;

                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanOpenJS;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin

                  if (CurWord <> '')  then begin
                    if (FHtmlAttrList.Find(CurWord, FIndex)) or (FHtmlMethodsList.Find(CurWord, FIndex)) then begin
                      AddState(StateAr, LineNo, ScanHTMLAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanOpenJS, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;

                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanOpenJS;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin

                  if (CurWord <> '')  then begin
                    if (FHtmlAttrList.Find(CurWord, FIndex)) or (FHtmlMethodsList.Find(CurWord, FIndex)) then begin
                      AddState(StateAr, LineNo, ScanHTMLAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanOpenJS, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;

                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanOpenJS;
                end
                else if Copy(gS,gi-1,4) = '<!--' then begin
                  State := ScanHTMLComment;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Inc(gi,3);
                end
                else if (Copy(gS,gi-1,2) = '<!') then begin
                  if (Length(gS) >= gi+1) and (gS[gi+1] in ['a'..'z','A'..'Z']) then begin
                    State := ScanHTMLHeader;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,1);
                  end;
                end
                else if (Ch in Delim)  then begin
                  if (CurWord <> '')  then begin
                    if (FHtmlAttrList.Find(CurWord, FIndex)) or (FHtmlMethodsList.Find(CurWord, FIndex)) then begin
                      AddState(StateAr, LineNo, ScanHTMLAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                      AddState(StateAr, LineNo, ScanOpenJS, LinePos, gi-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanOpenJS, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;

                  if (Ch = '/') and (NextCh = '>') then begin
                    AddState(StateAr, LineNo, ScanJSTag, LinePos, gi-1);
                    Inc(LinePos);
                    State := ScanNormal;
                    AddState(StateAr, LineNo, State, LinePos, gi+1);
                    Inc(LinePos);
                  end
                  else if Ch = '>' then begin
                    AddState(StateAr, LineNo, ScanJSTag, LinePos, gi-1);
                    Inc(LinePos);
                    State := ScanJSBody;
                    AddState(StateAr, LineNo, State, LinePos, gi);
                    Inc(LinePos);
                  end
                  else if Ch = '"' then begin
                    State := ScanDblQJS;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end
                  else if Ch = '''' then begin
                    State := ScanSingQJS;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end
                end
                else
                  CurWord := CurWord + Ch;
              end;

              ScanDblQJS: begin
                if Copy(gS,gi-1,5) = '<?php' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanDblQJS;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanDblQJS;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanDblQJS;
                end
                else if Ch = '"' then begin
                  State := ScanOpenJS;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;

              ScanSingQJS: begin
                if Copy(gS,gi-1,5) = '<?php' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanSingQJS;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanSingQJS;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanSingQJS;
                end
                else if Ch = '''' then begin
                  State := ScanOpenJS;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;

              ScanCloseJS: begin
                if Copy(gS,gi-1,5) = '<?php' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanCloseJS;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanCloseJS;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanCloseJS;
                end
                else if Copy(gS,gi-1,4) = '<!--' then begin
                  State := ScanHTMLComment;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Inc(gi,3);
                end
                else if (Copy(gS,gi-1,2) = '<!') then begin
                  if (Length(gS) >= gi+1) and (gS[gi+1] in ['a'..'z','A'..'Z']) then begin
                    State := ScanHTMLHeader;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,1);
                  end;
                end
                else if Ch = '>' then begin
                  AddState(StateAr, LineNo, ScanJSTag, LinePos, gi-1);
                  Inc(LinePos);
                  State := ScanNormal;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;

              ScanJSBody: begin
                Next := True;

                if Copy(gS,gi-1,5) = '<?php' then begin
                  if (CurWord <> '')  then begin
                    if isDigit(CurWord) then begin
                      AddState(StateAr, LineNo, ScanDigit, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos)
                    end
                    else if FJSReservList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSReserv, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSObjectList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSObj, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSMethodsList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSMetods, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSPropList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSProp, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end;

                    AddState(StateAr, LineNo, ScanJSBody, LinePos, gi-1);
                    Inc(LinePos);
                    CurWord := '';
                  end;

                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanJSBody;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin
                  if (CurWord <> '')  then begin
                    if isDigit(CurWord) then begin
                      AddState(StateAr, LineNo, ScanDigit, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos)
                    end
                    else if FJSReservList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSReserv, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSObjectList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSObj, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSMethodsList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSMetods, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSPropList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSProp, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end;

                    AddState(StateAr, LineNo, ScanJSBody, LinePos, gi-1);
                    Inc(LinePos);
                    CurWord := '';
                  end;

                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanJSBody;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin
                  if (CurWord <> '')  then begin
                    if isDigit(CurWord) then begin
                      AddState(StateAr, LineNo, ScanDigit, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos)
                    end
                    else if FJSReservList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSReserv, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSObjectList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSObj, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSMethodsList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSMetods, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSPropList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSProp, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end;

                    AddState(StateAr, LineNo, ScanJSBody, LinePos, gi-1);
                    Inc(LinePos);
                    CurWord := '';
                  end;

                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanJSBody;
                end
                else if (Ch = '<') and (NextCh = '/') then begin
                  if (CurWord <> '')  then begin
                    if isDigit(CurWord) then begin
                      AddState(StateAr, LineNo, ScanDigit, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos)
                    end
                    else if FJSReservList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSReserv, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSObjectList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSObj, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSMethodsList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSMetods, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSPropList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSProp, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end;

                    AddState(StateAr, LineNo, ScanJSBody, LinePos, gi-1);
                    Inc(LinePos);
                    CurWord := '';
                  end;

                  for i := gi+1 to Length(gs) do begin
                    if (gS[i] in Delim) then begin
                      if CurWord <> '' then begin
                        if LowerCase(CurWord) = 'script' then begin
                          AddState(StateAr, LineNo, ScanJSTag, LinePos, i-Length(CurWord)-2);
                          Inc(LinePos);
                          State := ScanCloseJS;
                          AddState(StateAr, LineNo, State, LinePos, i);
                          Inc(LinePos);
                          gi := i;
                        end
                      end;
                      CurWord := '';
                      Break;
                    end else
                      CurWord := CurWord + gS[i];
                  end;
                end;

                if (Ch in Delim)  then begin
                  if (CurWord <> '')  then begin
                    if isDigit(CurWord) then begin
                      AddState(StateAr, LineNo, ScanDigit, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos)
                    end
                    else if FJSReservList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSReserv, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSObjectList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSObj, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSMethodsList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSMetods, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSPropList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSProp, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end;

                    AddState(StateAr, LineNo, ScanJSBody, LinePos, gi-1);
                    Inc(LinePos);
                    CurWord := '';
                  end;

                  if (Ch = '/') and (NextCh = '/')  then begin
                    State := ScanLineJSComment;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi);
                  end
                  else if (Ch = '/') and (NextCh = '*') then begin
                    state := ScanJSComment;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi);
                  end
                  else if Ch = '''' then begin
                    State := ScanSingStringJS;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end
                  else if Ch = '"' then begin
                    State := ScanDblStringJS;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end     
                  else if Ch = '{' then begin
                    Inc(FLevelJS);
                    AddCurlJS(gi-1, LineNo, FLevelJS, 1);
                    AddState(StateAr, LineNo, ScanOpenCurlJS, LinePos, gi-1);
                    Inc(LinePos);
                    AddState(StateAr, LineNo, ScanJSBody, LinePos, gi);
                    Inc(LinePos);
                  end    
                  else if Ch = '}' then begin
                    AddCurlJS(gi-1, LineNo, FLevelJS, 0);
                    Dec(FLevelJS);
                    AddState(StateAr, LineNo, ScanCloseCurlJS, LinePos, gi-1);
                    Inc(LinePos);
                    AddState(StateAr, LineNo, ScanJSBody, LinePos, gi);
                    Inc(LinePos);
                  end  
                  else if Ch = '(' then begin
                    AddState(StateAr, LineNo, ScanOpenRoundJS, LinePos, gi-1);
                    Inc(LinePos);
                    AddState(StateAr, LineNo, ScanJSBody, LinePos, gi);
                    Inc(LinePos);
                  end  
                  else if Ch = ')' then begin
                    AddState(StateAr, LineNo, ScanCloseRoundJS, LinePos, gi-1);
                    Inc(LinePos);
                    AddState(StateAr, LineNo, ScanJSBody, LinePos, gi);
                    Inc(LinePos);
                  end                                      
                end else 
                  CurWord := CurWord + Ch;
              end;

              ScanSingStringJS: begin
                if (Ch = '\') and (NextCh = '''') then begin
                  Inc(gi);
                end;
                if Ch = '''' then begin
                  CurWord := '';
                  State := ScanJSBody;
                  Inc(gi);
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Next := False;
                end else if Copy(gS,gi-1,5) = '<?php' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanSingStringJS;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanSingStringJS;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanSingStringJS;
                end
              end;
              ScanDblStringJS: begin
                if (Ch = '\') and (NextCh = '"') then begin
                  Inc(gi);
                end;
                if Ch = '"' then begin
                  CurWord := '';
                  State := ScanJSBody;
                  Inc(gi);
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Next := False;
                end
                else if Copy(gS,gi-1,5) = '<?php' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanDblStringJS;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanDblStringJS;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanDblStringJS;
                end
              end;

              ScanJSComment: begin
              if Copy(gS,gi-1,5) = '<?php' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+4);
                  Inc(LinePos);
                  Inc(gi,4);
                  ReturnState := ScanJSComment;
                end
                else if Copy(gS,gi-1,3) = '<?=' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                  ReturnState := ScanJSComment;
                end
                else if Copy(gS,gi-1,2) = '<?' then begin
                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  state := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                  ReturnState := ScanJSComment;
                end
                else if (Ch = '*') and (NextCh = '/') then begin
                  State := ScanJSBody;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                end;
              end;

              ScanLineJSComment: begin
                if Ch = #10 then begin
                  CurWord := '';
                  State := ScanJSBody;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                end;
              end;
              {END SCANJS END SCANJS END SCANJS END SCANJS END SCANJS END SCANJS}

              ScanPHP: begin
                Next := True;

                if Ch = '''' then begin         
                  if CurWord <> '' then begin
                    //<-CurWord
                    if isDigit(CurWord) then begin
                      AddState(StateAr, LineNo, ScanDigit, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos)
                    end
                    else if FPHPReservList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanReserv, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FPHPFuncList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanFunc, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;
                  //<-Ch
                  State := ScanSingleQuoted;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                end
                else if Ch = '"' then begin
                  if CurWord <> '' then begin
                    //<-CurWord
                    if isDigit(CurWord) then begin
                      AddState(StateAr, LineNo, ScanDigit, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos)
                    end
                    else if FPHPReservList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanReserv, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FPHPFuncList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanFunc, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end;  ;
                    CurWord := '';
                  end;
                  //<-Ch
                  State := ScanDoubleQuoted;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                end
                else if (Ch in Delim) and (Ch <> ':') and (Ch <> '\') and (Ch <> '-') then begin
                  if CurWord <> '' then begin

                    if isDigit(CurWord) then begin
                      AddState(StateAr, LineNo, ScanDigit, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos)
                    end
                    else if FPHPReservList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanReserv, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FPHPFuncList.Find(CurWord,FIndex) then begin

                      AddState(StateAr, LineNo, ScanFunc, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';

                    AddState(StateAr, LineNo, ScanPHP, LinePos, gi-1);
                    Inc(LinePos);
                  end;
                  if Ch = '#' then begin
                    State := ScanLineComment;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end
                  else if Ch = '$' then begin
                    State := ScanVar;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    FirstVarCh := True;
                  end
                  else if Ch = '{' then begin
                    Inc(FLevelPHP);
                    AddCurlPHP(gi-1, LineNo, FLevelPHP, 1);
                    AddState(StateAr, LineNo, ScanOpenCurlPHP, LinePos, gi-1);
                    Inc(LinePos);
                    AddState(StateAr, LineNo, ScanPHP, LinePos, gi);
                    Inc(LinePos);
                  end
                  else if Ch = '}' then begin
                    AddCurlPHP(gi-1, LineNo, FLevelPHP, 0);
                    Dec(FLevelPHP);
                    AddState(StateAr, LineNo, ScanCloseCurlPHP, LinePos, gi-1);
                    Inc(LinePos);
                    AddState(StateAr, LineNo, ScanPHP, LinePos, gi);
                    Inc(LinePos);
                  end
                  else if Ch = '(' then begin
                    AddState(StateAr, LineNo, ScanOpenRoundPHP, LinePos, gi-1);
                    Inc(LinePos);
                    AddState(StateAr, LineNo, ScanPHP, LinePos, gi);
                    Inc(LinePos);
                  end
                  else if Ch = ')' then begin
                    AddState(StateAr, LineNo, ScanCloseRoundPHP, LinePos, gi-1);
                    Inc(LinePos);
                    AddState(StateAr, LineNo, ScanPHP, LinePos, gi);
                    Inc(LinePos);
                  end;
                  if (NextCh in Delim) then begin
                    BiDelim := Ch + NextCh;
                    if FindBiDelim(BiDelim) then begin
                      if BiDelim = '/*' then begin
                        State := ScanComment;
                        AddState(StateAr, LineNo, State, LinePos, gi-1);
                        Inc(LinePos);
                        Inc(gi,1);
                      end else if BiDelim = '//' then begin
                        State := ScanLineComment;
                        AddState(StateAr, LineNo, State, LinePos, gi-1);
                        Inc(LinePos);
                        Inc(gi);
                      end else begin
                        //<-BiDelim
                      end;
                      Ch := #32;
                    end;
                  end;
                  if not(Ch in [#9,#10,#13,#32]) then
                    //<-Ch
                end else
                  CurWord := CurWord + Ch;

                if Copy(gS,gi-1,2) = '?>' then begin
                  if ReturnState = ScanNull then ReturnState := ScanNormal;

                  AddState(StateAr, LineNo, ScanPHPTag, LinePos, gi-1);
                  Inc(LinePos);
                  State := ReturnState;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi,1);

                  ReturnState := ScanNull;
                end;
              end;

              ScanSingleQuoted: begin
                if (Ch = '\') and (NextCh = '''') then begin
                  Inc(gi);
                end;
                if Ch = '''' then begin
                  CurWord := '';
                  State := ScanPHP;
                  Inc(gi);
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Next := False;
                end
              end;
              ScanDoubleQuoted: begin
                if (Ch = '\') and (NextCh = '"') then begin
                  Inc(gi);
                end;
                if Ch = '"' then begin
                  CurWord := '';
                  State := ScanPHP;
                  Inc(gi);
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Next := False;
                end
              end;
              ScanComment: begin
                if (Ch = '*') and (NextCh = '/') then begin
                  CurWord := '';
                  Inc(gi,2);
                  State := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Next := False;
                end;
              end;
              ScanLineComment: begin
                if Ch = #10 then begin
                  CurWord := '';
                  State := ScanPHP;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                end;
              end;
              ScanVar: begin
                if FirstVarCh then begin
                  if not (Ch in ['_','a'..'z','A'..'Z','$']) then begin
                    CurWord := '';
                    State := ScanPHP;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Next := False;
                  end;
                  FirstVarCh := False;
                end else begin
                  if not (Ch in ['_','a'..'z','A'..'Z','0'..'9','$']) then begin
                    CurWord := '';
                    State := ScanPHP;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Next := False;
                  end;
                end;
              end;
            end;

            if Next then begin
              Inc(gi);
            end;

            if (Ch = #10) and (LineNo < Length(StateAr)-1) then begin
              FLineStateAr[LineNo].LevelPHP := FLevelPHP;
              FLineStateAr[LineNo].LevelJS := FLevelJS;

              AddState(StateAr, LineNo, State, LinePos, gi-1);
              Inc(LineNo);
              LinePos := 0;

              AddState(StateAr, LineNo, State, LinePos, 1);
              Inc(LinePos);

              if LineNo mod FPerProcessMessages = 0 then
                Application.ProcessMessages;

            end;
          end;
        end;

        smHTML: begin
          //AddState(FLineStateAr, LineNo, ScanNormal, LinePos, 1);
          //Inc(LinePos);
          
          while gi <= Length(gS) + 1 do begin
            Ch := gS[gi-1];
            if gi <= Length(gS) then
              NextCh := gS[gi]
            else NextCh := #32;

            case State of
              ScanNormal: begin
                if (LowerCase(Copy(gS,gi-1,6)) = '<style')  then begin
                  if (Length(gS) >= (gi + 5)) and (gS[gi+5] in Delim) then begin
                    State := ScanCSSTag;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,5);
                    State := ScanOpenCSS;
                    AddState(StateAr, LineNo, State, LinePos, gi);
                    Inc(LinePos);
                  end;
                end
                else if (LowerCase(Copy(gS,gi-1,7)) = '<script') then begin
                  if (Length(gS) >= (gi + 6)) and (gS[gi+6] in Delim) then begin
                    State := ScanJSTag;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,6);
                    State := ScanOpenJS;
                    AddState(StateAr, LineNo, State, LinePos, gi);
                    Inc(LinePos);
                  end;
                end
                else if (Ch = '<') and (NextCh = '/') then begin
                  for i := gi+1 to Length(gs) do begin
                    if (gS[i] in Delim) then begin
                      if CurWord <> '' then begin
                        if LowerCase(CurWord) = 'style' then begin
                          AddState(StateAr, LineNo, ScanCSSTag, LinePos, i-Length(CurWord)-2);
                          Inc(LinePos);
                          State := ScanCloseCSS;
                          AddState(StateAr, LineNo, State, LinePos, i);
                          Inc(LinePos);
                          gi := i;
                        end
                        else if FHtmlTagList.Find(CurWord, FIndex) then begin
                          AddState(StateAr, LineNo, ScanHTMLTag, LinePos, i-Length(CurWord)-2);
                          Inc(LinePos);
                          State := ScanCloseHTML;
                          AddState(StateAr, LineNo, State, LinePos, i);
                          Inc(LinePos);
                          gi := i;
                        end;
                      end;
                      CurWord := '';
                      Break;
                    end else
                     CurWord := CurWord + gS[i];
                  end;
                end
                else if Copy(gS,gi-1,4) = '<!--' then begin
                  State := ScanHTMLComment;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Inc(gi,3);
                end
                else if (Copy(gS,gi-1,2) = '<!') then begin
                  if (Length(gS) >= gi+1) and (gS[gi+1] in ['a'..'z','A'..'Z']) then begin
                    State := ScanHTMLHeader;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,1);
                  end;
                end
                else if Ch = '<' then begin

                  for i := gi to Length(gs) do begin
                    if (gS[i] in Delim) then begin
                      if CurWord <> '' then begin
                        if FHtmlTagList.Find(CurWord, FIndex) then begin
                          AddState(StateAr, LineNo, ScanHTMLTag, LinePos, i-Length(CurWord)-1);
                          Inc(LinePos);
                          State := ScanOpenHTML;
                          AddState(StateAr, LineNo, State, LinePos, i);
                          Inc(LinePos);
                          gi := i;
                        end;
                      end;
                      CurWord := '';
                      Break;
                    end else
                     CurWord := CurWord + gS[i];
                  end;

                end;
              end;

              ScanOpenHTML: begin
               if Copy(gS,gi-1,4) = '<!--' then begin
                  State := ScanHTMLComment;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Inc(gi,3);
                end
                else if (Copy(gS,gi-1,2) = '<!') then begin
                  if (Length(gS) >= gi+1) and (gS[gi+1] in ['a'..'z','A'..'Z']) then begin
                    State := ScanHTMLHeader;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,1); {or Inc(gi,1)}
                  end;
                end
                else if (Ch in Delim) and (Ch <> '-')  then begin
                  if (CurWord <> '')  then begin
                    if (FHtmlAttrList.Find(CurWord, FIndex)) or (FHtmlMethodsList.Find(CurWord, FIndex)) then begin
                      AddState(StateAr, LineNo, ScanHTMLAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                      AddState(StateAr, LineNo, ScanOpenHTML, LinePos, gi-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanOpenHTML, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;

                  if (Ch = '/') and (NextCh = '>') then begin
                    AddState(StateAr, LineNo, ScanHTMLTag, LinePos, gi-1);
                    Inc(LinePos);
                    State := ScanNormal;
                    AddState(StateAr, LineNo, State, LinePos, gi+1);
                    Inc(LinePos);
                  end
                  else if Ch = '>' then begin
                    AddState(StateAr, LineNo, ScanHTMLTag, LinePos, gi-1);
                    Inc(LinePos);
                    State := ScanNormal;
                    AddState(StateAr, LineNo, State, LinePos, gi);
                    Inc(LinePos);
                  end
                  else if Ch = '"' then begin
                    State := ScanDblQHTML;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end
                  else if Ch = '''' then begin
                    State := ScanSingQHTML;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end;
                end
                else
                  CurWord := CurWord + Ch;
              end;

              ScanDblQHTML: begin
                if Ch = '"' then begin
                  State := ScanOpenHTML;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;

              ScanSingQHTML: begin
                if Ch = '''' then begin
                  State := ScanOpenHTML;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;

              ScanCloseHTML: begin
                if Copy(gS,gi-1,4) = '<!--' then begin
                  State := ScanHTMLComment;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Inc(gi,3);
                end
                else if (Copy(gS,gi-1,2) = '<!') then begin
                  if (Length(gS) >= gi+1) and (gS[gi+1] in ['a'..'z','A'..'Z']) then begin
                    State := ScanHTMLHeader;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,1);
                  end;
                end
                else if Ch = '>' then begin
                  AddState(StateAr, LineNo, ScanHTMLTag, LinePos, gi-1);
                  Inc(LinePos);
                  State := ScanNormal;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;

              ScanHTMLComment: begin
               if Copy(gS,gi-1,3) = '-->' then begin
                  State := ScanNormal;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                end
              end;

              ScanHTMLHeader: begin
                if Ch = '>' then begin
                  AddState(StateAr, LineNo, ScanHTMLHeader, LinePos, gi);
                  Inc(LinePos);
                  State := ScanNormal;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end
              end;

              ScanOpenCSS: begin
                if Copy(gS,gi-1,4) = '<!--' then begin
                  State := ScanHTMLComment;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Inc(gi,3);
                end
                else if (Copy(gS,gi-1,2) = '<!') then begin
                  if (Length(gS) >= gi+1) and (gS[gi+1] in ['a'..'z','A'..'Z']) then begin
                    State := ScanHTMLHeader;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,1);
                  end;
                end
                else if (Ch in Delim)  then begin
                  if (CurWord <> '')  then begin
                    if (FHtmlAttrList.Find(CurWord, FIndex)) or (FHtmlMethodsList.Find(CurWord, FIndex)) then begin
                      AddState(StateAr, LineNo, ScanHTMLAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                      AddState(StateAr, LineNo, ScanOpenCSS, LinePos, gi-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanOpenCSS, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;

                  if (Ch = '/') and (NextCh = '>') then begin
                    AddState(StateAr, LineNo, ScanCSSTag, LinePos, gi-1);
                    Inc(LinePos);
                    State := ScanNormal;
                    AddState(StateAr, LineNo, State, LinePos, gi+1);
                    Inc(LinePos);
                  end
                  else if Ch = '>' then begin
                    AddState(StateAr, LineNo, ScanCSSTag, LinePos, gi-1);
                    Inc(LinePos);
                    State := ScanCSSBody;
                    AddState(StateAr, LineNo, State, LinePos, gi);
                    Inc(LinePos);
                  end
                  else if Ch = '"' then begin
                    State := ScanDblQCSS;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end
                  else if Ch = '''' then begin
                    State := ScanSingQCSS;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end;
                end
                else
                  CurWord := CurWord + Ch;
              end;

              ScanDblQCSS: begin
                if Ch = '"' then begin
                  State := ScanOpenCSS;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;

              ScanSingQCSS: begin
                if Ch = '''' then begin
                  State := ScanOpenCSS;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;

              ScanCloseCSS: begin
                if Copy(gS,gi-1,4) = '<!--' then begin
                  State := ScanHTMLComment;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Inc(gi,3);
                end
                else if (Copy(gS,gi-1,2) = '<!') then begin
                  if (Length(gS) >= gi+1) and (gS[gi+1] in ['a'..'z','A'..'Z']) then begin
                    State := ScanHTMLHeader;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,1); {or Inc(gi,1)}
                  end;
                end
                else if Ch = '>' then begin
                  AddState(StateAr, LineNo, ScanCSSTag, LinePos, gi-1);
                  Inc(LinePos);
                  State := ScanNormal;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;

              ScanCSSBody: begin
                if (Ch = '<') and (NextCh = '/') then begin

                  if (CurWord <> '')  then begin
                    if FCSSAttrList.Find(CurWord, FIndex) then begin
                      AddState(StateAr, LineNo, ScanCSSAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanCSSBody, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;

                  for i := gi+1 to Length(gs) do begin
                    if (gS[i] in Delim) then begin
                      if CurWord <> '' then begin
                        if LowerCase(CurWord) = 'style' then begin
                          AddState(StateAr, LineNo, ScanCSSTag, LinePos, i-Length(CurWord)-2);
                          Inc(LinePos);
                          State := ScanCloseCSS;
                          AddState(StateAr, LineNo, State, LinePos, i);
                          Inc(LinePos);
                          gi := i;
                        end
                      end;
                      CurWord := '';
                      Break;
                    end else
                      CurWord := CurWord + gS[i];
                  end;
                end;
                
                if (Ch in Delim) and (Ch <> '-')  then begin
                  if (CurWord <> '')  then begin
                    if FCSSAttrList.Find(CurWord, FIndex) then begin
                      AddState(StateAr, LineNo, ScanCSSAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                      AddState(StateAr, LineNo, ScanCSSBody, LinePos, gi-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanCSSBody, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;
                end;

                if (Ch = '/') and (NextCh = '*') then begin
                  state := ScanCSSComment;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Inc(gi);
                end
                else if Ch = '{' then begin
                  AddState(StateAr, LineNo, ScanOpenCurlCSS, LinePos, gi-1);
                  Inc(LinePos);
                  AddState(StateAr, LineNo, ScanCSSBody, LinePos, gi);
                  Inc(LinePos);
                end
                else if Ch = '}' then begin
                  AddState(StateAr, LineNo, ScanCloseCurlCSS, LinePos, gi-1);
                  Inc(LinePos);
                  AddState(StateAr, LineNo, ScanCSSBody, LinePos, gi);
                  Inc(LinePos);
                end;

                if not(Ch in Delim) then CurWord := CurWord + Ch;
                if (Ch = '-') then CurWord := CurWord + Ch;
              end;

              ScanCSSComment: begin
                if (Ch = '*') and (NextCh = '/') then begin
                  State := ScanCSSBody;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                end;
              end;

              ScanOpenJS: begin
                if Copy(gS,gi-1,4) = '<!--' then begin
                  State := ScanHTMLComment;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Inc(gi,3);
                end
                else if (Copy(gS,gi-1,2) = '<!') then begin
                  if (Length(gS) >= gi+1) and (gS[gi+1] in ['a'..'z','A'..'Z']) then begin
                    State := ScanHTMLHeader;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,1);
                  end;
                end
                else if (Ch in Delim)  then begin
                  if (CurWord <> '')  then begin
                    if (FHtmlAttrList.Find(CurWord, FIndex)) or (FHtmlMethodsList.Find(CurWord, FIndex)) then begin
                      AddState(StateAr, LineNo, ScanHTMLAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                      AddState(StateAr, LineNo, ScanOpenJS, LinePos, gi-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanOpenJS, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;

                  if (Ch = '/') and (NextCh = '>') then begin
                    AddState(StateAr, LineNo, ScanJSTag, LinePos, gi-1);
                    Inc(LinePos);
                    State := ScanNormal;
                    AddState(StateAr, LineNo, State, LinePos, gi+1);
                    Inc(LinePos);
                  end
                  else if Ch = '>' then begin
                    AddState(StateAr, LineNo, ScanJSTag, LinePos, gi-1);
                    Inc(LinePos);
                    State := ScanJSBody;
                    AddState(StateAr, LineNo, State, LinePos, gi);
                    Inc(LinePos);
                  end
                  else if Ch = '"' then begin
                    State := ScanDblQJS;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end
                  else if Ch = '''' then begin
                    State := ScanSingQJS;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end
                end
                else
                  CurWord := CurWord + Ch;
              end;

              ScanDblQJS: begin
                if Ch = '"' then begin
                  State := ScanOpenJS;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;

              ScanSingQJS: begin
                if Ch = '''' then begin
                  State := ScanOpenJS;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;

              ScanCloseJS: begin
                if Copy(gS,gi-1,4) = '<!--' then begin
                  State := ScanHTMLComment;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Inc(gi,3);
                end
                else if (Copy(gS,gi-1,2) = '<!') then begin
                  if (Length(gS) >= gi+1) and (gS[gi+1] in ['a'..'z','A'..'Z']) then begin
                    State := ScanHTMLHeader;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,1);
                  end;
                end
                else if Ch = '>' then begin
                  AddState(StateAr, LineNo, ScanJSTag, LinePos, gi-1);
                  Inc(LinePos);
                  State := ScanNormal;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;

              ScanJSBody: begin
                Next := True;

                if (Ch = '<') and (NextCh = '/') then begin
                  if (CurWord <> '')  then begin
                    if isDigit(CurWord) then begin
                      AddState(StateAr, LineNo, ScanDigit, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos)
                    end
                    else if FJSReservList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSReserv, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSObjectList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSObj, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSMethodsList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSMetods, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSPropList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSProp, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end;

                    AddState(StateAr, LineNo, ScanJSBody, LinePos, gi-1);
                    Inc(LinePos);
                    CurWord := '';
                  end;

                  for i := gi+1 to Length(gs) do begin
                    if (gS[i] in Delim) then begin
                      if CurWord <> '' then begin
                        if LowerCase(CurWord) = 'script' then begin
                          AddState(StateAr, LineNo, ScanJSTag, LinePos, i-Length(CurWord)-2);
                          Inc(LinePos);
                          State := ScanCloseJS;
                          AddState(StateAr, LineNo, State, LinePos, i);
                          Inc(LinePos);
                          gi := i;
                        end
                      end;
                      CurWord := '';
                      Break;
                    end else
                      CurWord := CurWord + gS[i];
                  end;
                end;
                if (Ch in Delim)  then begin
                  if (CurWord <> '')  then begin
                    if isDigit(CurWord) then begin
                      AddState(StateAr, LineNo, ScanDigit, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos)
                    end
                    else if FJSReservList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSReserv, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSObjectList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSObj, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSMethodsList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSMetods, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSPropList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSProp, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end;

                    AddState(StateAr, LineNo, ScanJSBody, LinePos, gi-1);
                    Inc(LinePos);
                    CurWord := '';
                  end;

                  if (Ch = '/') and (NextCh = '/')  then begin
                    State := ScanLineJSComment;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi);
                  end
                  else if (Ch = '/') and (NextCh = '*') then begin
                    state := ScanJSComment;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi);
                  end
                  else if Ch = '''' then begin
                    State := ScanSingStringJS;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end
                  else if Ch = '"' then begin
                    State := ScanDblStringJS;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end
                  else if Ch = '{' then begin
                    Inc(FLevelJS);
                    AddCurlJS(gi-1, LineNo, FLevelJS, 1);
                    AddState(StateAr, LineNo, ScanOpenCurlJS, LinePos, gi-1);
                    Inc(LinePos);
                    AddState(StateAr, LineNo, ScanJSBody, LinePos, gi);
                    Inc(LinePos);
                  end
                  else if Ch = '}' then begin
                    AddCurlJS(gi-1, LineNo, FLevelJS, 0);
                    Dec(FLevelJS);
                    AddState(StateAr, LineNo, ScanCloseCurlJS, LinePos, gi-1);
                    Inc(LinePos);
                    AddState(StateAr, LineNo, ScanJSBody, LinePos, gi);
                    Inc(LinePos);
                  end  
                  else if Ch = '(' then begin
                    AddState(StateAr, LineNo, ScanOpenRoundJS, LinePos, gi-1);
                    Inc(LinePos);
                    AddState(StateAr, LineNo, ScanJSBody, LinePos, gi);
                    Inc(LinePos);
                  end  
                  else if Ch = ')' then begin
                    AddState(StateAr, LineNo, ScanCloseRoundJS, LinePos, gi-1);
                    Inc(LinePos);
                    AddState(StateAr, LineNo, ScanJSBody, LinePos, gi);
                    Inc(LinePos);
                  end;
                end else 
                  CurWord := CurWord + Ch;
              end;

              ScanSingStringJS: begin
                if (Ch = '\') and (NextCh = '''') then begin
                  Inc(gi);
                end;
                if Ch = '''' then begin
                  CurWord := '';
                  State := ScanJSBody;
                  Inc(gi);
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Next := False;
                end;
              end;
              ScanDblStringJS: begin
                if (Ch = '\') and (NextCh = '"') then begin
                  Inc(gi);
                end;
                if Ch = '"' then begin
                  CurWord := '';
                  State := ScanJSBody;
                  Inc(gi);
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Next := False;
                end;
              end;

              ScanJSComment: begin
                if (Ch = '*') and (NextCh = '/') then begin
                  State := ScanJSBody;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                end;
              end;

              ScanLineJSComment: begin
                if Ch = #10 then begin
                  CurWord := '';
                  State := ScanJSBody;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                end;
              end;
            end;

            if Next then begin
              Inc(gi);
            end;

            if (Ch = #10) and (LineNo < Length(StateAr)-1) then begin
              FLineStateAr[LineNo].LevelJS := FLevelJS;
              AddState(StateAr, LineNo, State, LinePos, gi-1);
              Inc(LineNo);
              LinePos := 0;

              AddState(StateAr, LineNo, State, LinePos, 1);
              Inc(LinePos);

              if LineNo mod FPerProcessMessages = 0 then
                Application.ProcessMessages;
            end;
          end;
        end;// End smHTML

        smJS: begin
          //AddState(FLineStateAr, LineNo, ScanJSBody, LinePos, 1);
          //Inc(LinePos);

          while gi <= Length(gS) + 1 do begin
            Ch := gS[gi-1];
            if gi <= Length(gS) then
              NextCh := gS[gi]
            else NextCh := #32;

            case State of
              ScanJSBody: begin
                Next := True;

                if (Ch in Delim)  then begin
                  if (CurWord <> '')  then begin
                    if isDigit(CurWord) then begin
                      AddState(StateAr, LineNo, ScanDigit, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos)
                    end
                    else if FJSReservList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSReserv, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSObjectList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSObj, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSMethodsList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSMetods, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end
                    else if FJSPropList.Find(CurWord,FIndex) then begin
                      AddState(StateAr, LineNo, ScanJSProp, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                    end;

                    AddState(StateAr, LineNo, ScanJSBody, LinePos, gi-1);
                    Inc(LinePos);
                    CurWord := '';
                  end;

                  if (Ch = '/') and (NextCh = '/')  then begin
                    State := ScanLineJSComment;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi);
                  end
                  else if (Ch = '/') and (NextCh = '*') then begin
                    state := ScanJSComment;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi);
                  end
                  else if Ch = '''' then begin
                    State := ScanSingStringJS;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end
                  else if Ch = '"' then begin
                    State := ScanDblStringJS;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end
                  else if Ch = '{' then begin
                    Inc(FLevelJS);
                    AddCurlJS(gi-1, LineNo, FLevelJS, 1);
                    AddState(StateAr, LineNo, ScanOpenCurlJS, LinePos, gi-1);
                    Inc(LinePos);
                    AddState(StateAr, LineNo, ScanJSBody, LinePos, gi);
                    Inc(LinePos);
                  end
                  else if Ch = '}' then begin
                    AddCurlJS(gi-1, LineNo, FLevelJS, 0);
                    Dec(FLevelJS);
                    AddState(StateAr, LineNo, ScanCloseCurlJS, LinePos, gi-1);
                    Inc(LinePos);
                    AddState(StateAr, LineNo, ScanJSBody, LinePos, gi);
                    Inc(LinePos);
                  end
                  else if Ch = '(' then begin
                    AddState(StateAr, LineNo, ScanOpenRoundJS, LinePos, gi-1);
                    Inc(LinePos);
                    AddState(StateAr, LineNo, ScanJSBody, LinePos, gi);
                    Inc(LinePos);
                  end
                  else if Ch = ')' then begin
                    AddState(StateAr, LineNo, ScanCloseRoundJS, LinePos, gi-1);
                    Inc(LinePos);
                    AddState(StateAr, LineNo, ScanJSBody, LinePos, gi);
                    Inc(LinePos);
                  end;
                end else
                  CurWord := CurWord + Ch;
              end;

              ScanSingStringJS: begin
                if (Ch = '\') and (NextCh = '''') then begin
                  Inc(gi);
                end;
               {if (Ch = '\') and (NextCh = '''') then begin
                  Inc(gi);
                end; }
                if Ch = '''' then begin
                  CurWord := '';
                  State := ScanJSBody;
                  Inc(gi);
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Next := False;
                end;
              end;
              ScanDblStringJS: begin
                if (Ch = '\') and (NextCh = '"') then begin
                  Inc(gi);
                end;
                {if (Ch = '\') and (NextCh = '"') then begin
                  Inc(gi);
                end; }
                if Ch = '"' then begin
                  CurWord := '';
                  State := ScanJSBody;
                  Inc(gi);
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Next := False;
                end;
              end;

              ScanJSComment: begin
                if (Ch = '*') and (NextCh = '/') then begin
                  State := ScanJSBody;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                  Inc(gi);
                end;
              end;

              ScanLineJSComment: begin
                if Ch = #10 then begin
                  CurWord := '';
                  State := ScanJSBody;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                end;
              end;
            end;
            {END SCANJS END SCANJS END SCANJS END SCANJS END SCANJS END SCANJS}

            if Next then begin
              Inc(gi);
            end;

            if (Ch = #10) and (LineNo < Length(StateAr)-1) then begin
              FLineStateAr[LineNo].LevelJS := FLevelJS;
              AddState(StateAr, LineNo, State, LinePos, gi-1);
              Inc(LineNo);
              LinePos := 0;

              AddState(StateAr, LineNo, State, LinePos, 1);
              Inc(LinePos);

              if LineNo mod FPerProcessMessages = 0 then
                Application.ProcessMessages;
            end;
          end;
        end;// End smJS

        smCSS: begin
          //AddState(FLineStateAr, LineNo, ScanCSSBody, LinePos, 1);
          //Inc(LinePos);
          
          while gi <= Length(gS) + 1 do begin
            Ch := gS[gi-1];
            if gi <= Length(gS) then
              NextCh := gS[gi]
            else NextCh := #32;

            case State of

              ScanCSSBody: begin
                if (Ch in Delim) and (Ch <> '-')  then begin
                  if (CurWord <> '')  then begin
                    if FCSSAttrList.Find(CurWord, FIndex) then begin
                      AddState(StateAr, LineNo, ScanCSSAttr, LinePos, gi-Length(CurWord)-1);
                      Inc(LinePos);
                      AddState(StateAr, LineNo, ScanCSSBody, LinePos, gi-1);
                      Inc(LinePos);
                    end else begin
                      AddState(StateAr, LineNo, ScanCSSBody, LinePos, gi-1);
                      Inc(LinePos);
                    end;
                    CurWord := '';
                  end;
                end;

                if (Ch = '/') and (NextCh = '*') then begin
                  state := ScanCSSComment;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Inc(gi);
                end
                else if Ch = '{' then begin
                  AddState(StateAr, LineNo, ScanOpenCurlCSS, LinePos, gi-1);
                  Inc(LinePos);
                  AddState(StateAr, LineNo, ScanCSSBody, LinePos, gi);
                  Inc(LinePos);
                end
                else if Ch = '}' then begin
                  AddState(StateAr, LineNo, ScanCloseCurlCSS, LinePos, gi-1);
                  Inc(LinePos);
                  AddState(StateAr, LineNo, ScanCSSBody, LinePos, gi);
                  Inc(LinePos);
                end;


                if not(Ch in Delim) then CurWord := CurWord + Ch;
                if (Ch = '-') then CurWord := CurWord + Ch;
              end;

              ScanCSSComment: begin
                if (Ch = '*') and (NextCh = '/') then begin
                  State := ScanCSSBody;
                  AddState(StateAr, LineNo, State, LinePos, gi+1);
                  Inc(LinePos);
                end;
              end;
            end;

            if Next then begin
              Inc(gi);
            end;

            if (Ch = #10) and (LineNo < Length(StateAr)-1) then begin
              AddState(StateAr, LineNo, State, LinePos, gi-1);
              Inc(LineNo);
              LinePos := 0;

              AddState(StateAr, LineNo, State, LinePos, 1);
              Inc(LinePos);

              if LineNo mod FPerProcessMessages = 0 then
                Application.ProcessMessages;
            end;
          end;
        end;// End smCSS


        smXML: begin
          //AddState(FLineStateAr, LineNo, ScanNormal, LinePos, 1);
          //Inc(LinePos);

          while gi <= Length(gS) + 1 do begin
            Ch := gS[gi-1];
            if gi <= Length(gS) then
              NextCh := gS[gi]
            else NextCh := #32;

            case State of
              ScanNormal: begin
                if (Ch = '<') and (NextCh = '/') then begin
                  for i := gi+1 to Length(gs) do begin
                    if (gS[i] in Delim) then begin
                      if CurWord <> '' then begin
                        AddState(StateAr, LineNo, ScanHTMLTag, LinePos, i-Length(CurWord)-2);
                        Inc(LinePos);
                        State := ScanCloseHTML;
                        AddState(StateAr, LineNo, State, LinePos, i);
                        Inc(LinePos);
                        gi := i;
                      end;
                      CurWord := '';
                      Break;
                    end else
                     CurWord := CurWord + gS[i];
                  end;
                end
                else if Copy(gS,gi-1,4) = '<!--' then begin
                  State := ScanHTMLComment;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Inc(gi,3);
                end
                {else if (Copy(gS,gi-1,2) = '<!') then begin
                  if (Length(gS) >= gi+1) and (gS[gi+1] in ['a'..'z','A'..'Z']) then begin
                    State := ScanHTMLHeader;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,1);
                  end;
                end }
                else if (Ch = '<') and (NextCh = '?') then begin

                  for i := gi+1 to Length(gS) do begin
                    if (gS[i] in Delim) then begin
                      if CurWord <> '' then begin
                        AddState(StateAr, LineNo, ScanHTMLTag, LinePos, gi-1);
                        Inc(LinePos);
                        State := ScanOpenHTML;
                        AddState(StateAr, LineNo, State, LinePos, i-1+Length(CurWord));
                        Inc(LinePos);
                        gi := i;
                      end;
                      
                      CurWord := '';
                      Break;
                    end else
                     CurWord := CurWord + gS[i];
                  end;

                end
                else if Ch = '<' then begin

                  for i := gi to Length(gs) do begin
                    if (gS[i] in Delim) then begin
                      if CurWord <> '' then begin
                        AddState(StateAr, LineNo, ScanHTMLTag, LinePos, i-Length(CurWord)-1);
                        Inc(LinePos);
                        State := ScanOpenHTML;
                        AddState(StateAr, LineNo, State, LinePos, i);
                        Inc(LinePos);
                        gi := i;
                      end;
                      CurWord := '';
                      Break;
                    end else
                     CurWord := CurWord + gS[i];
                  end;

                end;
              end;

              ScanOpenHTML: begin
               if Copy(gS,gi-1,4) = '<!--' then begin
                  State := ScanHTMLComment;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Inc(gi,3);
                end
                else if (Copy(gS,gi-1,2) = '<!') then begin
                  if (Length(gS) >= gi+1) and (gS[gi+1] in ['a'..'z','A'..'Z']) then begin
                    State := ScanHTMLHeader;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,1);
                  end;
                end
                else if (Ch in Delim)  then begin
                  if (CurWord <> '')  then begin
                    AddState(StateAr, LineNo, ScanHTMLAttr, LinePos, gi-Length(CurWord)-1);
                    Inc(LinePos);
                    AddState(StateAr, LineNo, ScanOpenHTML, LinePos, gi-1);
                    Inc(LinePos);
                    CurWord := '';
                  end;

                  if (Ch = '/') and (NextCh = '>') then begin
                    AddState(StateAr, LineNo, ScanHTMLTag, LinePos, gi-1);
                    Inc(LinePos);
                    State := ScanNormal;
                    AddState(StateAr, LineNo, State, LinePos, gi+1);
                    Inc(LinePos);
                  end
                  else if (Ch = '?') and (NextCh = '>') then begin
                    AddState(StateAr, LineNo, ScanHTMLTag, LinePos, gi-1);
                    Inc(LinePos);
                    State := ScanNormal;
                    AddState(StateAr, LineNo, State, LinePos, gi+1);
                    Inc(LinePos);
                    Inc(gi);
                  end
                  else if Ch = '>' then begin
                    AddState(StateAr, LineNo, ScanHTMLTag, LinePos, gi-1);
                    Inc(LinePos);
                    State := ScanNormal;
                    AddState(StateAr, LineNo, State, LinePos, gi);
                    Inc(LinePos);
                  end
                  else if Ch = '"' then begin
                    State := ScanDblQHTML;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end
                  else if Ch = '''' then begin
                    State := ScanSingQHTML;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                  end;
                end
                else
                  CurWord := CurWord + Ch;
              end;

              ScanDblQHTML: begin
                if Ch = '"' then begin
                  State := ScanOpenHTML;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;

              ScanSingQHTML: begin
                if Ch = '''' then begin
                  State := ScanOpenHTML;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;

              ScanCloseHTML: begin
                if Copy(gS,gi-1,4) = '<!--' then begin
                  State := ScanHTMLComment;
                  AddState(StateAr, LineNo, State, LinePos, gi-1);
                  Inc(LinePos);
                  Inc(gi,3);
                end
                else if (Copy(gS,gi-1,2) = '<!') then begin
                  if (Length(gS) >= gi+1) and (gS[gi+1] in ['a'..'z','A'..'Z']) then begin
                    State := ScanHTMLHeader;
                    AddState(StateAr, LineNo, State, LinePos, gi-1);
                    Inc(LinePos);
                    Inc(gi,1);
                  end;
                end
                else if Ch = '>' then begin
                  AddState(StateAr, LineNo, ScanHTMLTag, LinePos, gi-1);
                  Inc(LinePos);
                  State := ScanNormal;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end;
              end;

              ScanHTMLComment: begin
               if Copy(gS,gi-1,3) = '-->' then begin
                  State := ScanNormal;
                  AddState(StateAr, LineNo, State, LinePos, gi+2);
                  Inc(LinePos);
                  Inc(gi,2);
                end
              end;

              ScanHTMLHeader: begin
                if Ch = '>' then begin
                  AddState(StateAr, LineNo, ScanHTMLHeader, LinePos, gi);
                  Inc(LinePos);
                  State := ScanNormal;
                  AddState(StateAr, LineNo, State, LinePos, gi);
                  Inc(LinePos);
                end
              end;
            end;

            if Next then begin
              Inc(gi);
            end;

            if (Ch = #10) and (LineNo < Length(StateAr)-1) then begin
              AddState(StateAr, LineNo, State, LinePos, gi-1);
              Inc(LineNo);
              LinePos := 0;

              AddState(StateAr, LineNo, State, LinePos, 1);
              Inc(LinePos);

              if LineNo mod FPerProcessMessages = 0 then
                Application.ProcessMessages;
            end;
          end;
        end;// End smXML

        smTXT: begin

          while gi <= Length(gS) + 1 do begin
            Ch := gS[gi-1];
            if gi <= Length(gS) then
              NextCh := gS[gi]
            else NextCh := #32;

            Inc(gi);

            if (Ch = #10) and (LineNo < Length(StateAr)-1) then begin
              AddState(StateAr, LineNo, State, LinePos, gi-1);
              Inc(LineNo);
              LinePos := 0;

              AddState(StateAr, LineNo, State, LinePos, 1);
              Inc(LinePos);

              if LineNo mod FPerProcessMessages = 0 then
                Application.ProcessMessages;
            end;
          end;
        end;
      end;
    end;
  end;

  FPaintBox.Repaint;
  InScan := False;

  FClassFuncWaitTick := 0;
  if FClassFuncTimer.Enabled = False then FClassFuncTimer.Enabled := True;

  if FClassView <> nil then begin
    if not FSuspendTree then begin
      FTreeScanWaitTick := 0;
      if FTreeTimer.Enabled = False then FTreeTimer.Enabled := True;
    end;
  end;
end;

procedure TPHPEdit.ClassFuncListScan;
type
  TWaitState = (sctNull, sctDefine, sctDefineBody, sctConst, sctInclude, sctRequire,
                sctRequireBody, sctClassName, sctFunction, sctInterface, sctTrait,
                sctOpenLevel, sctCurlBody, sctRoundBody,
                sctHTMLIncludeStr,
                sctOpenLevelJS, sctCurlBodyJS, sctRoundBodyJS,
                sctJSFunctionName, sctJSClassName,
                sctJSVar);
var
  j: Integer;
  ReservStr, IdentStr: String;
  WaitState: TWaitState;
  CurLineNo: Integer;

begin
  FPHPUserClassList.Clear;
  FPHPUserFuncList.Clear;
  CurLineNo := 0;
  while CurLineNo < Length(FLineStateAr) - 1 do begin
    predj := 1;
    if FTerminate {or FSuspendTree} then
      Break
    else begin
      if (FLineStateAr[CurLineNo].Max = 0) and (Length(FLineStateAr[CurLineNo].J) = 0) then
      else
      for j := 0 to FLineStateAr[CurLineNo].Max do begin
        case predstate of
          ScanReserv:begin
            ReservStr := Copy(FStringList[CurLineNo],predj,FLineStateAr[CurLineNo].J[j]-predj);
            if ReservStr = 'class' then begin
              WaitState := sctClassName;
            end
            else if ReservStr = 'function' then begin
              WaitState := sctFunction;
            end
            else if ReservStr = 'interface' then begin
              WaitState := sctInterface;
            end
            else if ReservStr = 'trait' then begin
              WaitState := sctTrait;
            end
          end;
          ScanFunc: begin

          end;
          ScanVar:begin

          end;
          ScanPHP: begin
            if (WaitState = sctClassName) or (WaitState = sctFunction) or (WaitState = sctInterface) or (WaitState = sctTrait) then begin
              IdentStr := Trim(Copy(FStringList[CurLineNo],predj,FLineStateAr[CurLineNo].J[j]-predj));
              if IsCorrectIdent(IdentStr) then begin
                case WaitState of
                  sctClassName: begin
                    FPHPUserClassList.AddObject(IdentStr, TObject(CurLineNo));
                    WaitState := sctNull;
                  end;
                  sctFunction: begin
                    FPHPUserFuncList.AddObject(IdentStr, TObject(CurLineNo));
                    WaitState := sctNull;
                  end;
                  sctTrait: begin
                    FPHPUserClassList.AddObject(IdentStr, TObject(CurLineNo));
                    WaitState := sctNull;
                  end;
                  sctInterface: begin
                    FPHPUserClassList.AddObject(IdentStr, TObject(CurLineNo));
                    WaitState := sctNull;
                  end;
                end;
              end;
            end;
          end;
          ScanOpenCurlPHP: begin

          end;
          ScanOpenRoundPHP: begin

          end;
          ScanCloseCurlPHP: begin

          end;
          ScanCloseRoundPHP: begin

          end;
          ScanSingleQuoted, ScanDoubleQuoted: begin

          end;

          //JSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSJS
          ScanJSReserv: begin

          end;
          ScanJSBody: begin

          end;

          ScanOpenCurlJS: begin

          end;
          ScanOpenRoundJS: begin

          end;
          ScanCloseCurlJS: begin

          end;
          ScanCloseRoundJS: begin

          end;
          ScanJSProp: begin

          end;
          //JSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSJS
        end;
        predj := FLineStateAr[CurLineNo].J[j];
        predstate := FLineStateAr[CurLineNo].Pos[j];
      end;

      Inc(CurLineNo);
    end;

    if CurLineNo mod FPerProcessMessages = 0 then Application.ProcessMessages;
  end;

  FPHPUserClassList.Sort;
  FPHPUserFuncList.Sort;
end;

procedure TPHPEdit.ResetTreeScaner;
var
  i: Integer;
begin
  LineNoTr := 0;
  FTreeScanWaitTick := 0;
end;

procedure TPHPEdit.ScanTree;
type
  TWaitState = (sctNull, sctDefine, sctDefineBody, sctConst, sctInclude, sctRequire,
                sctRequireBody, sctClassName, sctFunction, sctInterface, sctTrait,
                sctOpenLevel, sctCurlBody, sctRoundBody,
                sctHTMLIncludeStr,
                sctOpenLevelJS, sctCurlBodyJS, sctRoundBodyJS,
                sctJSFunctionName, sctJSClassName,
                sctJSVar);
var
  i, j, n, predj, LineNoBack: Integer;
  predstate, backstate: TState;
  ReservStr, VarStr, IdentStr, StrStr: String;
  flag, BrFlag: Boolean;
  CurClassNode, LastNode, RefNode: TTreeNode;
  WaitState: TWaitState;

  LevelStack: array of TWaitState;
  RoundSubLevels: array of Integer;
  CurlSubLevels: array of Integer;
  TopStackInd: Integer;

  LevelStackJS: array of TWaitState;
  RoundSubLevelsJS: array of Integer;
  CurlSubLevelsJS: array of Integer;
  TopStackIndJS: Integer;

  NodePHPConstants:  TTreeNode;
  NodePHPVariables:  TTreeNode;
  NodePHPClasses:    TTreeNode;
  NodePHPFunctions:  TTreeNode;
  NodePHPTraits:     TTreeNode;
  NodePHPInterfaces: TTreeNode;
  NodePHPIncludes:   TTreeNode;
  NodeHTMLIncludes:  TTreeNode;
  NodeJSVariables:   TTreeNode;
  NodeJSClasses:     TTreeNode;
  NodeJSFunctions:   TTreeNode;
  NodeCSSSelectors:  TTreeNode;

  PHPVariableStringList: TStringList;

  procedure LevelStackPush(LastState: TWaitState; Tp: Byte); //Tp=0-Round Tp=1-Curl
  begin
    if Length(LevelStack) < TopStackInd + 20 then begin
      SetLength(LevelStack, Length(LevelStack) + 40);
      SetLength(RoundSubLevels, Length(RoundSubLevels) + 40);
      SetLength(CurlSubLevels, Length(CurlSubLevels) + 40);
    end;
    LevelStack[TopStackInd] := LastState;

    if Tp = 0 then
      RoundSubLevels[TopStackInd] := 1
    else
      CurlSubLevels[TopStackInd] := 1;

    Inc(TopStackInd);
  end;

  function LevelStackPop: TWaitState;
  begin
    if TopStackInd > 0 then begin
      Result :=  LevelStack[TopStackInd-1];
      Dec(TopStackInd);
    end;
  end;

  procedure LevelStackPushJS(LastState: TWaitState; Tp: Byte); //Tp=0-Round Tp=1-Curl
  begin
    if Length(LevelStackJS) < TopStackIndJS + 20 then begin
      SetLength(LevelStackJS, Length(LevelStackJS) + 40);
      SetLength(RoundSubLevelsJS, Length(RoundSubLevelsJS) + 40);
      SetLength(CurlSubLevelsJS, Length(CurlSubLevelsJS) + 40);
    end;
    LevelStackJS[TopStackIndJS] := LastState;

    if Tp = 0 then
      RoundSubLevelsJS[TopStackIndJS] := 1
    else
      CurlSubLevelsJS[TopStackIndJS] := 1;

    Inc(TopStackIndJS);
  end;

  function LevelStackPopJS: TWaitState;
  begin
    if TopStackIndJS > 0 then begin
      Result :=  LevelStackJS[TopStackIndJS-1];
      Dec(TopStackIndJS);
    end;
  end;

 function AddNode(ParentNode: TTreeNode; Caption: String; Retry: Boolean; Index: Integer; CurState: TState): TTreeNode;
 var
   i: Integer;
   flag: Boolean;
   Node: TTreeNode;
 begin
   if not Retry then begin
     flag := False;
     for i := 0 to ParentNode.Count - 1 do begin
       if (ParentNode.Item[i].Text = Caption) and (ParentNode.Item[i].ImageIndex = Index) then begin
         flag := True;
         Result := nil;
         Break;
       end;
     end;

     if not flag then begin
       Node := FClassView.Items.AddChild(ParentNode, Trim(Caption));
       Node.ImageIndex := Index;
       Node.SelectedIndex := Index;
       Node.Data := Pointer(Integer(CurState));
       Result := Node;
     end;
   end else begin
     Node := FClassView.Items.AddChild(ParentNode, Trim(Caption));
     Node.ImageIndex := Index;
     Node.SelectedIndex := Index;
     Node.Data := Pointer(Integer(CurState));
     Result := Node;
   end;
 end;

begin
  FInScanTree := True;
  WaitState := sctNull;
  predstate := ScanNormal;
  TopStackInd := 0;
  TopStackIndJS := 0;

  PHPVariableStringList := TStringList.Create;

  FClassView.Items.BeginUpdate;

  try
    //очистка дерева
    for i := FClassView.Items.Count - 1 downto 0 do begin
      if (FClassView.Items[i].Level = 1) then begin
        FClassView.Items[i].DeleteChildren;
        if LineNoTr mod FPerProcessMessages = 0 then Application.ProcessMessages;
      end;
    end;
    //END очистка дерева
  except
  end;

  //PHP
  for i := 0 to FClassView.Items.Count - 1 do begin
    if (FClassView.Items[i].Level = 1) and (FClassView.Items[i].Text = 'Constants') and (FClassView.Items[i].Parent.Text = 'PHP') then begin
      NodePHPConstants := FClassView.Items[i];
      Break;
    end;
  end;

  for i := 0 to FClassView.Items.Count - 1 do begin
    if (FClassView.Items[i].Level = 1) and (FClassView.Items[i].Text = 'Variables') and (FClassView.Items[i].Parent.Text = 'PHP') then begin
      NodePHPVariables := FClassView.Items[i];
      Break;
    end;
  end;

  for i := 0 to FClassView.Items.Count - 1 do begin
    if (FClassView.Items[i].Level = 1) and (FClassView.Items[i].Text = 'Classes') and (FClassView.Items[i].Parent.Text = 'PHP') then begin
      NodePHPClasses := FClassView.Items[i];
      Break;
    end;
  end;

  for i := 0 to FClassView.Items.Count - 1 do begin
    if (FClassView.Items[i].Level = 1) and (FClassView.Items[i].Text = 'Functions') and (FClassView.Items[i].Parent.Text = 'PHP') then begin
      NodePHPFunctions := FClassView.Items[i];
      Break;
    end;
  end;

  for i := 0 to FClassView.Items.Count - 1 do begin
    if (FClassView.Items[i].Level = 1) and (FClassView.Items[i].Text = 'Interfaces') and (FClassView.Items[i].Parent.Text = 'PHP') then begin
      NodePHPInterfaces := FClassView.Items[i];
      Break;
    end;
  end;

  for i := 0 to FClassView.Items.Count - 1 do begin
    if (FClassView.Items[i].Level = 1) and (FClassView.Items[i].Text = 'Traits') and (FClassView.Items[i].Parent.Text = 'PHP') then begin
      NodePHPTraits := FClassView.Items[i];
      Break;
    end;
  end;

  for i := 0 to FClassView.Items.Count - 1 do begin
    if (FClassView.Items[i].Level = 1) and (FClassView.Items[i].Text = 'Includes') and (FClassView.Items[i].Parent.Text = 'PHP') then begin
      NodePHPIncludes := FClassView.Items[i];
      Break;
    end;
  end;
  //END PHP

  //HTML
  for i := 0 to FClassView.Items.Count - 1 do begin
    if (FClassView.Items[i].Level = 1) and (FClassView.Items[i].Text = 'Includes') and (FClassView.Items[i].Parent.Text = 'HTML') then begin
      NodeHTMLIncludes := FClassView.Items[i];
      Break;
    end;
  end;
  //END HTML

  //JS
  for i := 0 to FClassView.Items.Count - 1 do begin
    if (FClassView.Items[i].Level = 1) and (FClassView.Items[i].Text = 'Variables') and (FClassView.Items[i].Parent.Text = 'JavaScript') then begin
      CurClassNode := FClassView.Items[i];
      NodeJSVariables := FClassView.Items[i];
      Break;
    end;
  end;

  for i := 0 to FClassView.Items.Count - 1 do begin
    if (FClassView.Items[i].Level = 1) and (FClassView.Items[i].Text = 'Classes') and (FClassView.Items[i].Parent.Text = 'JavaScript') then begin
      CurClassNode := FClassView.Items[i];
      NodeJSClasses := FClassView.Items[i];
      Break;
    end;
  end;

  for i := 0 to FClassView.Items.Count - 1 do begin
    if (FClassView.Items[i].Level = 1) and (FClassView.Items[i].Text = 'Functions') and (FClassView.Items[i].Parent.Text = 'JavaScript') then begin
      CurClassNode := FClassView.Items[i];
      NodeJSFunctions := FClassView.Items[i];
      Break;
    end;
  end;
  //END JS

  //CSS
  for i := 0 to FClassView.Items.Count - 1 do begin
    if (FClassView.Items[i].Level = 1) and (FClassView.Items[i].Text = 'Selectors') and (FClassView.Items[i].Parent.Text = 'CSS') then begin
      NodeCSSSelectors := FClassView.Items[i];
      Break;
    end;
  end;
  //END CSS

  while LineNoTr < Length(FLineStateAr) - 1 do begin
    predj := 1;
    if FTerminate or FSuspendTree then
      Break
    else begin
      if (FLineStateAr[LineNoTr].Max = 0) and (Length(FLineStateAr[LineNoTr].J) = 0) then
      else
      for j := 0 to FLineStateAr[LineNoTr].Max do begin
        case predstate of
          ScanReserv:begin
            ReservStr := Copy(FStringList[LineNoTr],predj,FLineStateAr[LineNoTr].J[j]-predj);

            if ReservStr = 'class' then begin
              WaitState := sctClassName;
              if TopStackInd = 0 then begin
                CurClassNode := NodePHPClasses;
              end;
            end
            else if ReservStr = 'function' then begin
              WaitState := sctFunction;
              if TopStackInd = 0 then begin
                CurClassNode := NodePHPFunctions;
              end;
            end
            else if ReservStr = 'interface' then begin
              WaitState := sctInterface;
              if TopStackInd = 0 then begin
                CurClassNode := NodePHPInterfaces;
              end;
            end
            else if ReservStr = 'trait' then begin
              WaitState := sctTrait;
              if TopStackInd = 0 then begin
                CurClassNode := NodePHPTraits;
              end;
            end
            else if ReservStr = 'const' then begin
              WaitState := sctConst;
              if TopStackInd = 0 then begin
                CurClassNode := NodePHPConstants;
              end;
            end
            else if (ReservStr = 'include') or (ReservStr = 'include_once') then begin
              WaitState := sctInclude;
              if TopStackInd = 0 then begin
                CurClassNode := NodePHPIncludes;
              end;
            end
            else if (ReservStr = 'require') or (ReservStr = 'require_once') then begin
              WaitState := sctRequire;
              if TopStackInd = 0 then begin
                CurClassNode := NodePHPIncludes;
              end;
            end;

          end;
          ScanFunc: begin
            ReservStr := Copy(FStringList[LineNoTr],predj,FLineStateAr[LineNoTr].J[j]-predj);
            if ReservStr = 'define' then begin
              WaitState := sctDefineBody;
              if TopStackInd = 0 then begin
                CurClassNode := NodePHPConstants;
              end;
            end;
          end;
          ScanVar:begin
            VarStr := Copy(FStringList[LineNoTr],predj,FLineStateAr[LineNoTr].J[j]-predj);

            if TopStackInd = 0 then begin
              CurClassNode := NodePHPVariables;

              flag := False;
              for i := 0 to PHPVariableStringList.Count - 1 do begin
                if PHPVariableStringList[i] = VarStr then begin
                  flag := True;
                  Break;
                end;
              end;

              if not flag then begin
                PHPVariableStringList.Add(VarStr);
              end;
            end else begin

              flag := False;
              for i := 0 to CurClassNode.Count - 1 do begin
                if CurClassNode.Item[i].Text = VarStr then begin
                  flag := True;
                  Break;
                end;
              end;

              if not flag then begin
                if (WaitState = sctRoundBody) or (WaitState = sctNull) then begin
                  AddNode(CurClassNode, VarStr, False, 5, predstate);
                end else
                if (WaitState = sctCurlBody) or (WaitState = sctNull) then begin
                  AddNode(CurClassNode, VarStr, False, 6, predstate);
                end;
              end;
            end;
          end;
          ScanPHP: begin
            if (WaitState = sctClassName) or (WaitState = sctFunction) or (WaitState = sctInterface) or (WaitState = sctTrait) then begin
              IdentStr := Copy(FStringList[LineNoTr],predj,FLineStateAr[LineNoTr].J[j]-predj);
              if IsCorrectIdent(Trim(IdentStr)) then begin
                case WaitState of
                  sctClassName: begin
                    LastNode :=  AddNode(CurClassNode, IdentStr, True, 3, predstate);
                  end;
                  sctFunction: begin
                    LastNode :=  AddNode(CurClassNode, IdentStr, True, 4, predstate);
                  end;
                  sctTrait: begin
                    LastNode := AddNode(CurClassNode, IdentStr, True, 7, predstate);
                  end;
                  sctInterface: begin
                    LastNode := AddNode(CurClassNode, IdentStr, True, 8, predstate);
                  end;
                end;

                WaitState := sctOpenLevel;
              end else begin
                WaitState := sctNull;
              end;

            end
            else if WaitState = sctConst then begin
              IdentStr := Copy(FStringList[LineNoTr],predj,FLineStateAr[LineNoTr].J[j]-predj);

              if (Length(IdentStr) > 0) and (not(IdentStr[1] in ['0'..'9'])) then begin
                AddNode(CurClassNode, IdentStr, False, 1, ScanPHP);
                WaitState := sctNull;
              end;

            end;
          end;
          ScanOpenCurlPHP: begin
            if (WaitState = sctOpenLevel) then begin
              LevelStackPush(WaitState,1);
              WaitState := sctCurlBody;
              CurClassNode := LastNode;
            end else

            if TopStackInd > 0 then begin
              if (CurlSubLevels[TopStackInd-1] <> 0) then begin
                Inc(CurlSubLevels[TopStackInd-1]);
              end;
            end;
          end;
          ScanOpenRoundPHP: begin
            if WaitState = sctOpenLevel then begin
              LevelStackPush(WaitState,0);
              WaitState := sctRoundBody;
              CurClassNode := LastNode;
            end else

            if TopStackInd > 0 then begin
              if (RoundSubLevels[TopStackInd-1] <> 0) then begin
                Inc(RoundSubLevels[TopStackInd-1]);
              end;
            end;
          end;
          ScanCloseCurlPHP: begin
            if TopStackInd > 0 then begin
              if CurlSubLevels[TopStackInd-1] > 0 then begin
                Dec(CurlSubLevels[TopStackInd-1]);
                if (CurlSubLevels[TopStackInd-1] = 0) and (RoundSubLevels[TopStackInd-1] = 0) then begin
                  //WaitState := LevelStackPop;
                  WaitState := sctNull;
                  LevelStackPop;
                  CurClassNode := CurClassNode.Parent;
                end;
              end;
            end;
          end;
          ScanCloseRoundPHP: begin
            if TopStackInd > 0 then begin
              if RoundSubLevels[TopStackInd-1] > 0 then begin
                Dec(RoundSubLevels[TopStackInd-1]);
                if (RoundSubLevels[TopStackInd-1] = 0) and (CurlSubLevels[TopStackInd-1] = 0) then begin
                  WaitState :=  LevelStackPop;
                  CurClassNode := CurClassNode.Parent;
                end;
              end;
            end;
          end;
          ScanSingleQuoted, ScanDoubleQuoted: begin
            if WaitState = sctDefineBody then begin
              StrStr := Copy(FStringList[LineNoTr],predj,FLineStateAr[LineNoTr].J[j]-predj);
              if Length(StrStr) > 1 then begin
                StrStr := Copy(StrStr,2,Length(StrStr)-2);
              end;
              AddNode(CurClassNode, StrStr, False, 1, predstate);
              WaitState := sctNull;
            end else
            if WaitState = sctInclude then begin
              StrStr := Copy(FStringList[LineNoTr],predj,FLineStateAr[LineNoTr].J[j]-predj);
              if Length(StrStr) > 1 then begin
                StrStr := Copy(StrStr,2,Length(StrStr)-2);
              end;
              AddNode(CurClassNode, StrStr, False, 9, predstate);
              WaitState := sctNull;
            end else
            if WaitState = sctRequireBody then begin
              StrStr := Copy(FStringList[LineNoTr],predj,FLineStateAr[LineNoTr].J[j]-predj);
              if Length(StrStr) > 1 then begin
                StrStr := Copy(StrStr,2,Length(StrStr)-2);
              end;
              AddNode(CurClassNode, StrStr, False, 9, predstate);
              WaitState := sctNull;
            end;
          end;
          //HTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTML
          ScanHTMLAttr: begin
            StrStr := Copy(FStringList[LineNoTr],predj,FLineStateAr[LineNoTr].J[j]-predj);
            if (StrStr = 'href') or (StrStr = 'src') then begin
              WaitState := sctHTMLIncludeStr;
            end else begin
              WaitState := sctNull;
            end;
          end;
          ScanDblQHTML, ScanSingQHTML, ScanDblQJS, ScanSingQJS: begin
            if WaitState = sctHTMLIncludeStr then begin
              StrStr := Copy(FStringList[LineNoTr],predj,FLineStateAr[LineNoTr].J[j]-predj);
              if Length(StrStr) > 1 then begin
                StrStr := Copy(StrStr,2,Length(StrStr)-2);
              end;
              AddNode(NodeHTMLIncludes, StrStr, False, 9, predstate);
            end;
            WaitState := sctNull;
          end;
          //HTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTMLHTML

          //JSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSJS
          ScanJSReserv: begin
            ReservStr := Trim(Copy(FStringList[LineNoTr],predj,FLineStateAr[LineNoTr].J[j]-predj));
            if ReservStr = 'class' then begin
              if TopStackIndJS = 0 then begin
                CurClassNode := NodeJSClasses;
              end;

              flag := False;
              if (j >= 3) then begin
                StrStr := Trim(Copy(FStringList[LineNoTr],FLineStateAr[LineNoTr].J[j-2],FLineStateAr[LineNoTr].J[j-1]-FLineStateAr[LineNoTr].J[j-2]));
                IdentStr := Trim(Copy(FStringList[LineNoTr],FLineStateAr[LineNoTr].J[j-3],FLineStateAr[LineNoTr].J[j-2]-FLineStateAr[LineNoTr].J[j-3]));

                for i := 1 to Length(IdentStr) do begin
                  if not(IsCharAlpha(IdentStr[1])) then begin
                    IdentStr := Copy(IdentStr, 2, Length(IdentStr));
                  end else
                    Break;
                end;

                if StrStr = '=' then begin
                  if IsCorrectIdent(IdentStr) then begin
                    LastNode := AddNode(CurClassNode, IdentStr, True, 3, predstate);
                    WaitState := sctOpenLevelJS;
                    flag := True;
                  end;
                end;
              end;

              if not flag then begin
                WaitState := sctJSClassName;
              end;
            end else
            if ReservStr = 'function' then begin
              if TopStackIndJS = 0 then begin
                CurClassNode := NodeJSFunctions;
              end;

              flag := False;
              if (j >= 3) then begin
                StrStr := Trim(Copy(FStringList[LineNoTr],FLineStateAr[LineNoTr].J[j-2],FLineStateAr[LineNoTr].J[j-1]-FLineStateAr[LineNoTr].J[j-2]));
                IdentStr := Trim(Copy(FStringList[LineNoTr],FLineStateAr[LineNoTr].J[j-3],FLineStateAr[LineNoTr].J[j-2]-FLineStateAr[LineNoTr].J[j-3]));

                for i := 1 to Length(IdentStr) do begin
                  if not(IsCharAlpha(IdentStr[1])) then begin
                    IdentStr := Copy(IdentStr, 2, Length(IdentStr));
                  end else
                    Break;
                end;

                if StrStr = '=' then begin
                  if IsCorrectIdent(IdentStr) then begin
                    LastNode := AddNode(CurClassNode, IdentStr, True, 4, predstate);
                    WaitState := sctOpenLevelJS;
                    flag := True;
                  end;
                end;
              end;

              if not flag then begin
                WaitState := sctJSFunctionName;
              end;
            end else
            if (ReservStr = 'var') or (ReservStr = 'let') or (ReservStr = 'const') then begin
              WaitState := sctJSVar;
              flag := True;
              if TopStackIndJS = 0 then begin
                CurClassNode := NodeJSVariables;
              end;
            end;
          end;
          ScanJSBody: begin
            if (WaitState = sctJSFunctionName) or (WaitState = sctJSClassName) then begin
              IdentStr := Trim(Copy(FStringList[LineNoTr],predj,FLineStateAr[LineNoTr].J[j]-predj));
              if IsCorrectIdent(IdentStr) then begin
                case WaitState of
                  sctJSFunctionName: begin
                    LastNode := AddNode(CurClassNode, IdentStr, True, 4, predstate);
                  end;
                  sctJSClassName: begin
                    LastNode := AddNode(CurClassNode, IdentStr, True, 3, predstate);
                  end;
                end;

                WaitState := sctOpenLevelJS;
              end else begin
                WaitState := sctNull;
              end;

            end
            else if WaitState = sctJSVar then begin
              IdentStr := Trim(Copy(FStringList[LineNoTr],predj,FLineStateAr[LineNoTr].J[j]-predj));
              if flag then begin
                flag := False;
                if IsCorrectIdent(IdentStr) then begin
                  AddNode(CurClassNode, IdentStr, False, 2, predstate);
                end else
                  WaitState := sctNull;
              end else begin
                if (Length(IdentStr) > 0) then begin
                  if IdentStr[1] = ',' then begin
                    IdentStr := Copy(IdentStr,2,Length(IdentStr));
                    if IsCorrectIdent(IdentStr) then begin
                      AddNode(CurClassNode, IdentStr, False, 2, predstate);
                    end else
                      WaitState := sctNull;
                  end else
                    WaitState := sctNull;
                end else
                  WaitState := sctNull;
              end;
            end
            else if WaitState = sctRoundBodyJS then begin
              IdentStr := Copy(FStringList[LineNoTr],predj,FLineStateAr[LineNoTr].J[j]-predj);

              for i := 1 to Length(IdentStr) do begin
                if not(IsCharAlpha(IdentStr[1])) then begin
                  IdentStr := Copy(IdentStr, 2, Length(IdentStr));
                end else
                  Break;
              end;

              if IsCorrectIdent(IdentStr) then begin
                AddNode(CurClassNode, IdentStr, False, 5, predstate);
              end;
            end;
          end;

          ScanOpenCurlJS: begin
            if (WaitState = sctOpenLevelJS) then begin
              LevelStackPushJS(WaitState,1);
              WaitState := sctCurlBodyJS;
              CurClassNode := LastNode;
            end else

            if TopStackInd > 0 then begin
              if (CurlSubLevelsJS[TopStackIndJS-1] <> 0) then begin
                Inc(CurlSubLevelsJS[TopStackIndJS-1]);
              end;
            end;
          end;
          ScanOpenRoundJS: begin
            if WaitState = sctOpenLevelJS then begin
              LevelStackPushJS(WaitState,0);
              WaitState := sctRoundBodyJS;
              CurClassNode := LastNode;
            end else begin

              if TopStackIndJS > 0 then begin
                if (RoundSubLevelsJS[TopStackIndJS-1] <> 0) then begin
                  Inc(RoundSubLevelsJS[TopStackIndJS-1]);
                end;
              end;

              if (j >= 3) then begin
                IdentStr := Trim(Copy(FStringList[LineNoTr],FLineStateAr[LineNoTr].J[j-3],FLineStateAr[LineNoTr].J[j-2]-FLineStateAr[LineNoTr].J[j-3]));

                for i := 1 to Length(IdentStr) do begin
                  if not(IsCharAlpha(IdentStr[1])) then begin
                    IdentStr := Copy(IdentStr, 2, Length(IdentStr));
                  end else
                    Break;
                end;

                if IsCorrectIdent(IdentStr) then begin
                  flag := False;
                  if FJSReservList.Find(IdentStr,FIndex) then begin
                  end
                  else if FJSObjectList.Find(IdentStr,FIndex) then begin
                  end
                  else if FJSMethodsList.Find(IdentStr,FIndex) then begin
                  end
                  else if FJSPropList.Find(IdentStr,FIndex) and (IdentStr <> 'constructor') then begin
                  end else begin
                    if (j >= 4) then begin
                      StrStr := Trim(Copy(FStringList[LineNoTr],FLineStateAr[LineNoTr].J[j-4],FLineStateAr[LineNoTr].J[j-3]-FLineStateAr[LineNoTr].J[j-4]));
                      if StrStr = LowerCase('new') then flag := True
                    end;

                    if not flag then begin
                      if TopStackIndJS = 0 then begin
                        CurClassNode := NodeJSFunctions;
                      end;

                      if WaitState <> sctRoundBodyJS then begin
                        if IsCorrectIdent(IdentStr) then begin
                          RefNode := AddNode(CurClassNode, IdentStr, False, 13, predstate);
                          if RefNode <> nil then begin
                            LastNode := RefNode;
                            LevelStackPushJS(sctOpenLevelJS,0);
                            WaitState := sctRoundBodyJS;
                            CurClassNode := LastNode;
                          end;
                        end;
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
          ScanCloseCurlJS: begin
            if TopStackIndJS > 0 then begin
              if CurlSubLevelsJS[TopStackIndJS-1] > 0 then begin
                Dec(CurlSubLevelsJS[TopStackIndJS-1]);
                if (CurlSubLevelsJS[TopStackIndJS-1] = 0) and (RoundSubLevelsJS[TopStackIndJS-1] = 0) then begin
                  //WaitState := LevelStackPopJS;
                  WaitState := sctNull;
                  LevelStackPopJS;
                  CurClassNode := CurClassNode.Parent;
                end;
              end;
            end;
          end;
          ScanCloseRoundJS: begin
            if TopStackIndJS > 0 then begin
              if RoundSubLevelsJS[TopStackIndJS-1] > 0 then begin
                Dec(RoundSubLevelsJS[TopStackIndJS-1]);
                if (RoundSubLevelsJS[TopStackIndJS-1] = 0) and (CurlSubLevelsJS[TopStackIndJS-1] = 0) then begin
                  WaitState := LevelStackPopJS;
                  CurClassNode := CurClassNode.Parent;
                end;
              end;
            end;
          end;
          ScanJSProp: begin
            if WaitState = sctRoundBodyJS then begin
              IdentStr := Copy(FStringList[LineNoTr],predj,FLineStateAr[LineNoTr].J[j]-predj);
              AddNode(CurClassNode, IdentStr, True, 5, predstate);
            end;
          end;
          //JSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSSJSJS

          //CSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSS
          ScanOpenCurlCSS: begin
            for LineNoBack := LineNoTr downto 0 do begin
              BrFlag := False;
              n := FLineStateAr[LineNoBack].Max;
              if LineNoBack = LineNoTr then n := j-1;
              for i := n downto 0 do begin
                if i > 0 then begin
                  backstate := FLineStateAr[LineNoBack].Pos[i-1];
                end;
                if backstate <> ScanCSSBody then begin
                  BrFlag := True;
                  Break;
                end else begin
                  IdentStr := Trim(Copy(FStringList[LineNoBack],FLineStateAr[LineNoBack].J[i-1],FLineStateAr[LineNoBack].J[i]- FLineStateAr[LineNoBack].J[i-1]));
                  if Length(IdentStr) > 0 then begin
                    if FCSSAttrList.Find(IdentStr,FIndex) then begin
                    end
                    else if FCSSValList.Find(IdentStr,FIndex) then begin
                    end else begin
                      if Length(IdentStr) > 0 then begin
                        if IdentStr[1] = ',' then begin
                          IdentStr := Trim(Copy(IdentStr,2,Length(IdentStr)));
                        end;
                      end;
                      if Length(IdentStr) > 0 then begin
                        if (IdentStr[1] = '.') or (IdentStr[1] = '#') then begin
                          IdentStr := Trim(Copy(IdentStr,2,Length(IdentStr)));
                        end;
                      end;
                      if IsCorrectIdent(IdentStr) then begin
                        AddNode(NodeCSSSelectors, Trim(IdentStr), False, 15, ScanCSSBody);
                      end;
                    end;
                  end;
                end;
              end;
              if BrFlag then Break;
            end;
          end;
          //CSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSSCSS
        end;
        predj := FLineStateAr[LineNoTr].J[j];
        predstate := FLineStateAr[LineNoTr].Pos[j];
      end;

      Inc(LineNoTr);
    end;

    if LineNoTr mod FPerProcessMessages = 0 then Application.ProcessMessages;
  end;
  //--------------------------------------------------------------------------//
  //--------------------------------------------------------------------------//
  //--------------------------------------------------------------------------//
  NodePHPVariables.DeleteChildren;
  for i := 0 to PHPVariableStringList.Count - 1 do begin
    RefNode := FClassView.Items.AddChild(NodePHPVariables,PHPVariableStringList[i]);
    RefNode.ImageIndex := 2;
    RefNode.SelectedIndex := 2;
    RefNode.Data := Pointer(Integer(ScanVar));
  end;
  PHPVariableStringList.Free;

  FClassView.Items.EndUpdate;
  FPaintBox.Repaint;
  FInScanTree := False;
end;

procedure TPHPEdit.Terminate;
begin
  FTerminate := True;
end;

end.

