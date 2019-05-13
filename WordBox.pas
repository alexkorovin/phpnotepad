unit WordBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Main, WordBoxInit, ExtCtrls, PHPEdit;

type
  TBoxHint = class(THintWindow)
  private
    Timer: TTimer;
    procedure ProcHideHint(Sender: TObject);
  public
    procedure Show(text: string; X,Y: Integer);
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMLBTNDOWN(var Message: TMessage); message WM_LBUTTONDOWN;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    constructor Create(AOwner: TWinControl);
    destructor Destroy; override;
  end;

  TLineBoxHint = class(THintWindow)
  private
    Timer: TTimer;
    HintPosition: TRect;
    s: string;
    procedure ProcHideLineHint(Sender: TObject);
  public
    procedure Show(text: string; X,Y: Integer);
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMLBTNDOWN(var Message: TMessage); message WM_LBUTTONDOWN;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    constructor Create(AOwner: TWinControl);
    destructor Destroy; override;
  end;

  TWordBox = class(TListBox)
  private
    FPHPFuncBmp: TBitmap;
    FJSObjBmp: TBitmap;
    FJSMthBmp: TBitmap;
    FPropBtm: TBitmap;
    FCSSAttrBmp: TBitmap;
    FHTMLTagBmp: TBitmap;
    lstIndex, fOldIndex: Integer;
    procedure ListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure LeaveMouse(Sender: TObject);
    procedure KeyPress(Sender: TObject; var Key: Char);
    procedure DblClick(Sender: TObject);
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer) ;
    procedure WMHotKey(var msg: TWMKeyDown); message WM_KEYDOWN;
  public
    PREF_: String;
    PlaceState: TState;
    PlaceScanMd: TScanMode;
    constructor Create(AOwner: TWinControl);
    destructor Destroy; override;
  end;

  TWordBoxForm = class(TForm)
    Panel: TPanel;
    procedure SetParams;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PanelResize(Sender: TObject);
  private
    LDragging: Boolean;
    BDragging: Boolean;
    iX: Integer;
    iY: Integer;
    ListBox: TWordBox;
  public
    { Public declarations }
  end;

var
  WordBoxForm: TWordBoxForm;

implementation

uses Types;

{$R *.dfm}
{$R WordBox.res}

constructor TWordBox.Create(AOwner: TWinControl);
begin
  inherited Create(AOwner);
  Style := lbOwnerDrawFixed;

  OnDrawItem := ListBoxDrawItem;
  OnKeyPress := KeyPress;
  OnDblClick := DblClick;
  OnMouseMove := MouseMove;
  OnMouseLeave := LeaveMouse;

  ShowHint := False;

  FJSObjBmp := TBitmap.Create;
  FJSObjBmp.Handle := LoadBitmap(HInstance,'JSOBJ');
  FPHPFuncBmp := TBitmap.Create;
  FPHPFuncBmp.Handle := LoadBitmap(HInstance,'PHPFUNC');
  FJSMthBmp := TBitmap.Create;
  FJSMthBmp.Handle := LoadBitmap(HInstance,'JSMTH');
  FPropBtm := TBitmap.Create;
  FPropBtm.Handle := LoadBitmap(HInstance,'PROP');
  FCSSAttrBmp := TBitmap.Create;
  FCSSAttrBmp.Handle := LoadBitmap(HInstance,'CSSATTR');
  FHTMLTagBmp := TBitmap.Create;
  FHTMLTagBmp.Handle := LoadBitmap(HInstance,'HTMLTAG');
end;

destructor TWordBox.Destroy;
begin
  inherited Destroy;
end;

procedure TWordBox.WMHotKey(var msg: TWMKeyDown);
var
  i,n,FIndex: Integer;
  str: String;
begin
  if not((msg.CharCode = 37) or (msg.CharCode = 39)) then begin
    inherited;
  end else begin
    Docs[MainFormPND.ActivDocID].SendKeyDown(msg.CharCode);

    if msg.CharCode = 37 then begin
      if Length(PREF_) > 0 then begin
        PREF_ := Copy(PREF_,1,Length(PREF_)-1)
      end
      else begin
        TForm(Parent).Close;
        Exit;
      end;
    end;

    if msg.CharCode = 39 then begin
      PREF_ := PREF_ + Docs[MainFormPND.ActivDocID].GetCaretChar;
    end;

    if msg.CharCode <> 13 then begin
      Clear;
      Items.BeginUpdate;

      if (PlaceState = ScanPHP) or (PlaceState = ScanFunc) then begin
        for i := 0 to PHPFuncList.Count - 1 do begin
          if Copy(PHPFuncList[i], Length(PHPFuncList[i])-1, 2) <> '::' then begin
            if PREF_ = Copy(PHPFuncList[i],1,Length(PREF_)) then
              AddItem(PHPFuncList[i], TObject(1004));
          end;
        end;
      end;
      if PlaceState = ScanNormal then begin
        for i := 0 to HtmlTagList.Count - 1 do begin
          if PREF_ = Copy(HtmlTagList[i],1,Length(PREF_)) then
            AddItem('<'+HtmlTagList[i]+'>',TObject(1005));
        end;
      end;
      if (PlaceState = ScanOpenHTML) or (PlaceState = ScanOpenCSS) or (PlaceState = ScanOpenJS)  then begin
        for i := 0 to HtmlAttrList.Count - 1 do begin
          if PREF_ = Copy(HtmlAttrList[i],1,Length(PREF_)) then
            AddItem(HtmlAttrList[i],TObject(1003));
        end;
        for i := 0 to HtmlMethodsList.Count - 1 do begin
          if PREF_ = Copy(HtmlMethodsList[i],1,Length(PREF_)) then
            AddItem(HtmlMethodsList[i],TObject(1002));
        end;
      end;
      if PlaceState = ScanCSSBody then begin
        for i := 0 to CSSAttrList.Count - 1 do begin
          if PREF_ = Copy(CSSAttrList[i],1,Length(PREF_)) then
            AddItem(CSSAttrList[i],TObject(1006));
        end;
        //поиск по атрибуту, можно загрузить только свойства атрибута
        if Items.Count = 0 then begin
          SetLength(PREF_, Length(PREF_) - 1);

          if CSSAttrList.Find(PREF_, FIndex) then begin
            for i := 0 to CSSValList.Count - 1 do begin
              AddItem(CSSValList[i],TObject(1003));
            end;
            PREF_  := '';
            PlaceState := ScanCSSVal;
          end;
        end;
      end;
      if PlaceState = ScanCSSVal then begin
        for i := 1 to Length(PREF_) do begin
          if PREF_[i] = ':' then begin
            PREF_ := Copy(PREF_,i+1,Length(PREF_));
            Break;
          end;
        end;

        for i := 0 to CSSValList.Count - 1 do begin
          if PREF_ = Copy(CSSValList[i],1,Length(PREF_)) then
            AddItem(CSSValList[i],TObject(1003));
        end;
      end;
      if (PlaceState = ScanJSBody) then begin
        for i := 0 to JSObjectList.Count - 1 do begin
          if PREF_ = Copy(JSObjectList[i],1,Length(PREF_)) then
            AddItem(JSObjectList[i], TObject(1001));
        end;
        for i := 0 to JSMethodsList.Count - 1 do begin
          if PREF_ = Copy(JSMethodsList[i],1,Length(PREF_)) then
            AddItem(JSMethodsList[i], TObject(1002));
        end;
        for i := 0 to JSPropList.Count - 1 do begin
          if PREF_ = Copy(JSPropList[i],1,Length(PREF_)) then
            AddItem(JSPropList[i], TObject(1003));
        end;
      end;
      if (PlaceState = ScanHTMLAttr) then begin
        for i := 0 to HtmlAttrList.Count - 1 do begin
          if PREF_ = Copy(HtmlAttrList[i],1,Length(PREF_)) then
            AddItem(HtmlAttrList[i],TObject(1003));
        end;
        for i := 0 to HtmlMethodsList.Count - 1 do begin
          if PREF_ = Copy(HtmlMethodsList[i],1,Length(PREF_)) then
            AddItem(HtmlMethodsList[i],TObject(1002));
        end;
      end;

      Items.EndUpdate;
      if Items.Count = 0 then TForm(Parent).Close;
    end;
  end;

  if msg.CharCode = 13 then begin
    case PlaceState of
      ScanPHP,
      ScanOpenCurlPHP,
      ScanCloseCurlPHP,
      ScanOpenRoundJS,
      ScanCloseRoundPHP: begin
        Docs[MainFormPND.ActivDocID].InsertWord(Items[ItemIndex], Length(PREF_), True, True);
      end;
      ScanFunc: begin
        Docs[MainFormPND.ActivDocID].InsertWord(Items[ItemIndex], Length(PREF_), True, True);
      end;
      ScanNormal: begin
        str := Items[ItemIndex];
        Insert('/',str,2);
        Docs[MainFormPND.ActivDocID].InsertWord(Items[ItemIndex]+str, Length(PREF_), True, False);
      end;
      ScanOpenHTML, ScanOpenCSS, ScanOpenJS: begin
        Docs[MainFormPND.ActivDocID].InsertWord(Items[ItemIndex]+'=""', Length(PREF_), True, True);
        //MainForm.Docs[MainForm.ActivDocID].DecCaretX;
      end;
      ScanCSSBody: begin
        Docs[MainFormPND.ActivDocID].InsertWord(Items[ItemIndex], Length(PREF_), True, True);
      end;
      ScanCSSVal: begin
        Docs[MainFormPND.ActivDocID].InsertWord(Items[ItemIndex], Length(PREF_), True, True);
      end;
      ScanJSBody: begin
        Docs[MainFormPND.ActivDocID].InsertWord(Items[ItemIndex], Length(PREF_), True, True);
      end;
    end;
    TForm(Parent).Visible := False;
    TForm(Parent).Close;
  end;

  if msg.CharCode = 27 then TForm(Parent).Close;
end;

procedure TWordBoxForm.FormCreate(Sender: TObject);
begin
  ListBox := TWordBox.Create(Self);
  ListBox.Parent := Self;
  Panel.Color := clBtnFace;
end;

procedure TWordBoxForm.SetParams;
var
  LF: Integer;
  i,j: Integer;
  FIndex: Integer;
  shf: Integer;
  HintWindow: TBoxHint;
begin
  shf := Docs[MainFormPND.ActivDocID].HorsStartPos * Docs[MainFormPND.ActivDocID].CharWidth;
  LF :=  Docs[MainFormPND.ActivDocID].CreateScreenAnchorBox;
  Left := Docs[MainFormPND.ActivDocID].ScreenAnchorBox.ClientToScreen(Point(0,0)).X + LF - shf;
  Top := Docs[MainFormPND.ActivDocID].ScreenAnchorBox.ClientToScreen(Point(0,0)).Y;

  if (Top + Height) > Screen.Height then begin
    Top := Top - Height - Docs[MainFormPND.ActivDocID].LineHeight;
  end;

  Docs[MainFormPND.ActivDocID].FreeScreenAnchorBox;

  ListBox.PlaceState := Docs[MainFormPND.ActivDocID].GetPlaceState.PlaceState;
  ListBox.PlaceScanMd := Docs[MainFormPND.ActivDocID].GetPlaceState.DocSmType;
  ListBox.PREF_ := Docs[MainFormPND.ActivDocID].GetPref;

  ListBox.Clear;
  ListBox.Items.BeginUpdate;

  if (ListBox.PlaceState = ScanPHP) or (ListBox.PlaceState = ScanFunc) or
     (ListBox.PlaceState = ScanOpenCurlPHP) or (ListBox.PlaceState = ScanCloseCurlPHP) or
     (ListBox.PlaceState = ScanOpenRoundJS) or (ListBox.PlaceState = ScanCloseRoundPHP)  then begin
    for i := 0 to PHPFuncList.Count - 1 do begin
      if Copy(PHPFuncList[i], Length(PHPFuncList[i])-1, 2) <> '::' then begin
        if ListBox.PREF_ = Copy(PHPFuncList[i],1,Length(ListBox.PREF_)) then
          ListBox.Items.AddObject(PHPFuncList[i], TObject(1004));
      end;
    end;
  end;
  if ListBox.PlaceState = ScanNormal then begin
    for i := 0 to HtmlTagList.Count - 1 do begin
      if ListBox.PREF_ = Copy(HtmlTagList[i],1,Length(ListBox.PREF_)) then
        ListBox.AddItem('<'+HtmlTagList[i]+'>',TObject(1005));
    end;
  end;
  if (ListBox.PlaceState = ScanOpenHTML) or (ListBox.PlaceState = ScanOpenCSS) or (ListBox.PlaceState = ScanOpenJS)  then begin
    for i := 0 to HtmlAttrList.Count - 1 do begin
      if ListBox.PREF_ = Copy(HtmlAttrList[i],1,Length(ListBox.PREF_)) then
        ListBox.AddItem(HtmlAttrList[i],TObject(1003));
    end;
    for i := 0 to HtmlMethodsList.Count - 1 do begin
      if ListBox.PREF_ = Copy(HtmlMethodsList[i],1,Length(ListBox.PREF_)) then
        ListBox.AddItem(HtmlMethodsList[i],TObject(1002));
    end;
  end;
  if ListBox.PlaceState = ScanCSSBody then begin
    for i := 0 to CSSAttrList.Count - 1 do begin
      if ListBox.PREF_ = Copy(CSSAttrList[i],1,Length(ListBox.PREF_)) then
        ListBox.AddItem(CSSAttrList[i],TObject(1006));
    end;
    //поиск по атрибуту, можно загрузить только свойства атрибута
    if ListBox.Items.Count = 0 then begin
      SetLength(ListBox.PREF_, Length(ListBox.PREF_) - 1);

      if CSSAttrList.Find(ListBox.PREF_, FIndex) then begin
        for i := 0 to CSSValList.Count - 1 do begin
          ListBox.AddItem(CSSValList[i],TObject(1003));
        end;
        ListBox.PREF_  := '';
        ListBox.PlaceState := ScanCSSVal;
      end;
    end;
  end;
  if ListBox.PlaceState = ScanCSSVal then begin
    for i := 1 to Length(ListBox.PREF_) do begin
      if ListBox.PREF_[i] = ':' then begin
        ListBox.PREF_ := Copy(ListBox.PREF_,i+1,Length(ListBox.PREF_));
        Break;
      end;
    end;

    for i := 0 to CSSValList.Count - 1 do begin
      if ListBox.PREF_ = Copy(CSSValList[i],1,Length(ListBox.PREF_)) then
        ListBox.AddItem(CSSValList[i],TObject(1003));
    end;
  end;
  if (ListBox.PlaceState = ScanJSBody) then begin
    for i := 0 to JSObjectList.Count - 1 do begin
      if ListBox.PREF_ = Copy(JSObjectList[i],1,Length(ListBox.PREF_)) then
        ListBox.AddItem(JSObjectList[i], TObject(1001));
    end;
    for i := 0 to JSMethodsList.Count - 1 do begin
      if ListBox.PREF_ = Copy(JSMethodsList[i],1,Length(ListBox.PREF_)) then
        ListBox.AddItem(JSMethodsList[i], TObject(1002));
    end;
    for i := 0 to JSPropList.Count - 1 do begin
      if ListBox.PREF_ = Copy(JSPropList[i],1,Length(ListBox.PREF_)) then
        ListBox.AddItem(JSPropList[i], TObject(1003));
    end;
  end;
  if (ListBox.PlaceState = ScanHTMLAttr)   then begin
    for i := 0 to HtmlAttrList.Count - 1 do begin
      if ListBox.PREF_ = Copy(HtmlAttrList[i],1,Length(ListBox.PREF_)) then
        ListBox.AddItem(HtmlAttrList[i],TObject(1003));
    end;
    for i := 0 to HtmlMethodsList.Count - 1 do begin
      if ListBox.PREF_ = Copy(HtmlMethodsList[i],1,Length(ListBox.PREF_)) then
        ListBox.AddItem(HtmlMethodsList[i],TObject(1002));
    end;
  end;

  ListBox.Items.EndUpdate;

  if ListBox.Items.Count = 0 then begin
    HintWindow := TBoxHint.Create(Self);
    HintWindow.Show('No offers',Left,Top);

    ListBox.Visible := False;
    WordBoxForm.Visible := False;
  end else begin
    WordBoxForm.Visible := True;
    ListBox.Visible := True;
  end;
end;

procedure TWordBoxForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Docs[MainFormPND.ActivDocID].SendKeyDown(Key);
  Close;
end;

procedure TWordBoxForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  Docs[MainFormPND.ActivDocID].SendKeyPress(Key);
  Close;
end;

procedure TWordBoxForm.PanelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (X > TPanel(Sender).Width - 5) then begin
    LDragging := True;
    iX := X;
  end
  else if (Y > TPanel(Sender).Height - 5) then begin
    BDragging := True;
    iY := Y;
  end;
end;

procedure TWordBoxForm.PanelMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (X > TPanel(Sender).Width - 5) then begin
    TPanel(Sender).Cursor := crSizeWE;
  end else
  if (Y > TPanel(Sender).Height - 5) then begin
    TPanel(Sender).Cursor := crSizeNS;
  end else begin
    TPanel(Sender).Cursor := crDefault;
  end;

  if LDragging then begin
    if (Width + (X - iX) < 500) and (Width + (X - iX) > 200) then begin
      Width := Width + (X - iX);
      iX := X;
      MainFormPND.BoxW := Width;
      ListBox.Repaint;
    end;
  end
  else if BDragging then begin
    if (Height + (Y - iY) < 300) and (Height + (Y - iY) > 100) then begin
      Height := Height + (Y - iY);
      iY := Y;
      MainFormPND.BoxH := Height;
      ListBox.Repaint;
    end;
  end;
end;

procedure TWordBoxForm.PanelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  LDragging := False;
  BDragging := False;
end;

procedure TWordBoxForm.PanelResize(Sender: TObject);
begin
  ListBox.SetBounds(3,3,Width-7,Height-7);
end;

procedure TWordBox.DblClick(Sender: TObject);
var
  str: String;
begin
  if ItemIndex = -1 then begin
    Exit;
  end;

  case PlaceState of
    ScanPHP,
    ScanOpenCurlPHP,
    ScanCloseCurlPHP,
    ScanOpenRoundJS,
    ScanCloseRoundPHP: begin
      Docs[MainFormPND.ActivDocID].InsertWord(Items[ItemIndex], Length(PREF_), True, True);
    end;
    ScanFunc: begin
      Docs[MainFormPND.ActivDocID].InsertWord(Items[ItemIndex], Length(PREF_), True, True);
    end;
    ScanNormal: begin
      str := Items[ItemIndex];
      Insert('/',str,2);
      Docs[MainFormPND.ActivDocID].InsertWord(Items[ItemIndex]+str, Length(PREF_), True, False);
    end;
    ScanOpenHTML, ScanOpenCSS, ScanOpenJS: begin
      Docs[MainFormPND.ActivDocID].InsertWord(Items[ItemIndex]+'=""', Length(PREF_), True, True);
      //MainForm.Docs[MainForm.ActivDocID].DecCaretX;
    end;
    ScanCSSBody: begin
      Docs[MainFormPND.ActivDocID].InsertWord(Items[ItemIndex], Length(PREF_), True, True);
    end;
    ScanCSSVal: begin
      Docs[MainFormPND.ActivDocID].InsertWord(Items[ItemIndex], Length(PREF_), True, True);
    end;
    ScanJSBody: begin
      Docs[MainFormPND.ActivDocID].InsertWord(Items[ItemIndex], Length(PREF_), True, True);
    end;
  end;
  TForm(Parent).Visible := False;
  TForm(Parent).Close;
end;

procedure TWordBox.MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  s: String;
  i, id: Integer;
  LineHint: TLineBoxHint;
begin
  with TListBox(Sender) do
  begin
    lstIndex := SendMessage(Handle, LB_ITEMFROMPOINT, 0, MakeLParam(x,y));

    if (fOldIndex <> lstIndex) and (lstIndex <> -1)  then begin
      Application.CancelHint;
      fOldIndex := lstIndex;

      if (lstIndex >= 0) and (lstIndex <= Items.Count-1) then begin
        s := Items[lstIndex];

        case Integer(Items.Objects[lstIndex]) of
          1001: id := 1001;
          1002: id := 1002;
          1003: id := 1003;
          1004: id := 1004;
          1005: id := 1005;
          1006: id := 1006;
        end;


        for i := 0 to PHPParamsList.Count - 1 do begin
          if (id = 1004) and (s = Copy(PHPParamsList[i],1,Length(s))) then begin
            s := s + ' '+Copy(PHPParamsList[i],Length(s)+1,Length(PHPParamsList[i]));
            if (Round(Length(s)*6*SCREENSCALE) + 50) > WordBoxForm.Width then begin
              LineHint := TLineBoxHint.Create(Self);
              LineHint.Show(s, WordBoxForm.Left+23,WordBoxForm.Top + Y div ItemHeight * ItemHeight);
            end;
            Break;
          end;
        end;
      end;
    end;
  end;
end;

procedure TWordBox.ListBoxDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  i: Integer;
  s: String;
  id: Integer;
begin
  with (Control as TListBox).Canvas do
  begin
    if odSelected in State then begin
      Brush.Color := $00FFD2A6;
    end;

    FillRect(Rect);

    case Integer(Items.Objects[Index]) of
      1001: begin
        Draw(Rect.Left, Rect.Top, FJSObjBmp);
        id := 1001;
      end;
      1002: begin
        Draw(Rect.Left, Rect.Top, FJSMthBmp);
        id := 1002;
      end;
      1003: begin
        Draw(Rect.Left, Rect.Top, FPropBtm);
        id := 1003;
      end;
      1004: begin
        Draw(Rect.Left, Rect.Top, FPHPFuncBmp);
        id := 1004;
      end;
      1005: begin
        Draw(Rect.Left, Rect.Top, FHTMLTagBmp);
        id := 1005;
      end;
      1006: begin
        Draw(Rect.Left, Rect.Top, FCSSAttrBmp);
        id := 1006;
      end;
    end;

    Font.Size := 8;
    Font.Name := 'Consolas';
    Font.Color := clBlack;

    s := (Control as TListBox).Items[Index];
    TextOut(Rect.Left+20, Rect.Top, s);

    for i := 0 to PHPParamsList.Count - 1 do begin
      if (id = 1004) and (s = Copy(PHPParamsList[i],1,Length(s))) then begin
        Font.Color := clGray;
        TextOut(Round((Length((Control as TListBox).Items[Index])*6) * SCREENSCALE) + 23, Rect.Top,
                Copy(PHPParamsList[i],Length(s)+1,Length(PHPParamsList[i])));
        Break;
      end;
    end;
  end;

end;

procedure TWordBox.LeaveMouse(Sender: TObject);
begin
 //lstIndex := -1;
 //fOldIndex := -1
end;

procedure TWordBox.KeyPress(Sender: TObject; var Key: Char);
var
  i, FIndex: Integer;
begin
  if Ord(Key) = 13 then begin
    TForm(Parent).Close;
    Exit;
  end;

  PREF_ := PREF_ + Key;

  Clear;
  Items.BeginUpdate;

  if (PlaceState = ScanPHP) or (PlaceState = ScanFunc) then begin
    for i := 0 to PHPFuncList.Count - 1 do begin
      if Copy(PHPFuncList[i], Length(PHPFuncList[i])-1, 2) <> '::' then begin
        if PREF_ = Copy(PHPFuncList[i],1,Length(PREF_)) then
          AddItem(PHPFuncList[i], TObject(1004));
      end;
    end;
  end;
  if PlaceState = ScanNormal then begin
    for i := 0 to HtmlTagList.Count - 1 do begin
      if PREF_ = Copy(HtmlTagList[i],1,Length(PREF_)) then
        AddItem('<'+HtmlTagList[i]+'>',TObject(1005));
    end;
  end;
  if (PlaceState = ScanOpenHTML) or (PlaceState = ScanOpenCSS) or (PlaceState = ScanOpenJS)  then begin
    for i := 0 to HtmlAttrList.Count - 1 do begin
      if PREF_ = Copy(HtmlAttrList[i],1,Length(PREF_)) then
        AddItem(HtmlAttrList[i],TObject(1003));
    end;
    for i := 0 to HtmlMethodsList.Count - 1 do begin
      if PREF_ = Copy(HtmlMethodsList[i],1,Length(PREF_)) then
        AddItem(HtmlMethodsList[i],TObject(1002));
    end;
  end;
  if PlaceState = ScanCSSBody then begin
    for i := 0 to CSSAttrList.Count - 1 do begin
      if PREF_ = Copy(CSSAttrList[i],1,Length(PREF_)) then
        AddItem(CSSAttrList[i],TObject(1006));
    end;
    //поиск по атрибуту, можно загрузить только свойства атрибута
    if Items.Count = 0 then begin
      SetLength(PREF_, Length(PREF_) - 1);

      if CSSAttrList.Find(PREF_, FIndex) then begin
        for i := 0 to CSSValList.Count - 1 do begin
          AddItem(CSSValList[i],TObject(1003));
        end;
        PREF_  := '';
        PlaceState := ScanCSSVal;
      end;
    end;
  end;
  if PlaceState = ScanCSSVal then begin
    for i := 1 to Length(PREF_) do begin
      if PREF_[i] = ':' then begin
        PREF_ := Copy(PREF_,i+1,Length(PREF_));
        Break;
      end;
    end;

    for i := 0 to CSSValList.Count - 1 do begin
      if PREF_ = Copy(CSSValList[i],1,Length(PREF_)) then
        AddItem(CSSValList[i],TObject(1003));
    end;
  end;
  if (PlaceState = ScanJSBody) then begin
    for i := 0 to JSObjectList.Count - 1 do begin
      if PREF_ = Copy(JSObjectList[i],1,Length(PREF_)) then
        AddItem(JSObjectList[i], TObject(1001));
    end;
    for i := 0 to JSMethodsList.Count - 1 do begin
      if PREF_ = Copy(JSMethodsList[i],1,Length(PREF_)) then
        AddItem(JSMethodsList[i], TObject(1002));
    end;
    for i := 0 to JSPropList.Count - 1 do begin
      if PREF_ = Copy(JSPropList[i],1,Length(PREF_)) then
        AddItem(JSPropList[i], TObject(1003));
    end;
  end;
  if (PlaceState = ScanHTMLAttr)  then begin
    for i := 0 to HtmlAttrList.Count - 1 do begin
      if PREF_ = Copy(HtmlAttrList[i],1,Length(PREF_)) then
        AddItem(HtmlAttrList[i],TObject(1003));
    end;
    for i := 0 to HtmlMethodsList.Count - 1 do begin
      if PREF_ = Copy(HtmlMethodsList[i],1,Length(PREF_)) then
        AddItem(HtmlMethodsList[i],TObject(1002));
    end;
  end;

  Items.EndUpdate;

  if Items.Count = 0 then TForm(Parent).Close;

  Docs[MainFormPND.ActivDocID].SendKeyPress(Key);
  Key := #0;
end;

constructor TBoxHint.Create(AOwner: TWinControl);
begin
  inherited Create(AOwner);
  Timer := TTimer.Create(nil);
  Timer.Enabled := False;
  Timer.Interval := 1000;
  Timer.OnTimer := ProcHideHint;
end;

destructor TBoxHint.Destroy;
begin
  Timer.Free;
  inherited Destroy;
end;

procedure TBoxHint.WMNCHitTest(var Message: TWMNCHitTest);
begin
  Message.Result := HTCLIENT;
end;

procedure TBoxHint.CMMouseLeave(var Message: TMessage);
begin
  ReleaseHandle;
end;

procedure TBoxHint.WMLBTNDOWN(var Message: TMessage);
begin
  //Clipboard.SetTextBuf(PChar(Caption));
  ReleaseHandle;
end;

procedure TBoxHint.Show(text: string; X,Y: Integer);
var
  HintPosition: TRect;
begin
  HintPosition.Left := X;
  HintPosition.Top := Y;
  HintPosition.Right := X + 60;
  HintPosition.Bottom := Y + 17;
  ActivateHint(HintPosition, text);
  Timer.Enabled := True;
end;

procedure TBoxHint.ProcHideHint(Sender: TObject);
begin
  ReleaseHandle;
  Timer.Enabled := False;
end;

constructor TLineBoxHint.Create(AOwner: TWinControl);
begin
  inherited Create(AOwner);
  Timer := TTimer.Create(nil);
  Timer.Enabled := False;
  Timer.Interval := 1;
  Timer.OnTimer := ProcHideLineHint;

  Canvas.Font.Name := 'Consolas';
  Canvas.Font.Size := 8;
end;

destructor TLineBoxHint.Destroy;
begin
  Timer.Free;
  inherited Destroy;
end;

procedure TLineBoxHint.WMNCHitTest(var Message: TWMNCHitTest);
begin
  Message.Result := HTCLIENT;
end;

procedure TLineBoxHint.CMMouseLeave(var Message: TMessage);
begin
  ReleaseHandle;
end;

procedure TLineBoxHint.WMLBTNDOWN(var Message: TMessage);
begin
  //Clipboard.SetTextBuf(PChar(Caption));
  ReleaseHandle;
end;

procedure TLineBoxHint.Show(text: string; X,Y: Integer);
begin
  HintPosition.Left := X;
  HintPosition.Top := Y;
  HintPosition.Right := X + Length(text)*6+10;
  HintPosition.Bottom := Y + 17;
  s := text;
  ActivateHint(HintPosition, s);
  Timer.Enabled := True;
end;

procedure TLineBoxHint.ProcHideLineHint(Sender: TObject);
begin
  if (Mouse.CursorPos.Y > Top + Height) or (Mouse.CursorPos.Y < Top) or
     (Mouse.CursorPos.X > Left + Width) or (Mouse.CursorPos.X < Left) then begin
    ReleaseHandle;
    Timer.Enabled := False;
  end;
end;

end.

