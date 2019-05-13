unit TabControl;

interface

uses
  Windows, ExtCtrls, Controls, Buttons, Graphics, Classes, Forms, SysUtils, Dialogs;

type
  TTabNotify = procedure(Sender: TObject; var TabID: Integer) of Object;

  TTabs = record
    Caption: String;
    Width: Integer;
    PtrID: Integer;
    Activ: Boolean;
  end;

  TTabControl = class(TPanel)
  private
    FScrollBtnPanel: TPanel;
    FScrollLeftBtn: TSpeedButton;
    FScrollRightBtn: TSpeedButton;
    FPaintBox: TPaintBox;
    FScrollPos: Integer;
    FTabMove: Boolean;
    FMoveFrom: Integer;
    FMoveTo: Integer;
    FMoveX: Integer;
    FWhiteBmp: TBitmap;
    FGrayBmp: TBitmap;
    FChoiceTab: TTabNotify;
    FCloseTab: TTabNotify;
    procedure Paint(Sender: TObject);
    procedure ScrollLeft(Sender: TObject);
    procedure ScrollRight(Sender: TObject);
    procedure SwapTab(PosFrom, PosTo: Integer);
    procedure ScrollRightIfHide(Pos: Integer);
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MouseLeave(Sender: TObject);
  public
    constructor Create(AOwner: TWinControl);
    destructor Destroy; override;
    procedure CloseTab(TabID: Integer);
    procedure AddTab(Caption: String; ID: Integer);
    procedure Update;
    function GetTabCount: Integer;
    function Title(Index: Integer): String;
    procedure RenameTab(Index: Integer; Caption: String);
    procedure SelectTab(TabID: Integer);
    procedure ReScale;
    property OnChoiceTab: TTabNotify read FChoiceTab write FChoiceTab;
    property OnCloseTab: TTabNotify read FCloseTab write FCloseTab;
    property ScrollPos: Integer read FScrollPos write FScrollPos;
  end;

var
  TabArray: array of TTabs;

implementation

uses Main;

{$R TabControl.res}

constructor TTabControl.Create(AOwner: TWinControl);
begin
  inherited Create(AOwner);
  Parent := AOwner;
  DoubleBuffered := True;
  Color := RGB(215,215,215);
  Height := 20;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  Font.Color := clGray;
  Font.Name := 'Courier New';
  Font.Size := 10;
  FScrollPos := 0;

  FScrollBtnPanel := TPanel.Create(Self);
  FScrollBtnPanel.Parent := Self;
  FScrollBtnPanel.Width := 40;
  FScrollBtnPanel.Align := alRight;
  FScrollBtnPanel.BevelInner := bvNone;
  FScrollBtnPanel.BevelOuter := bvNone;

  FScrollLeftBtn := TSpeedButton.Create(FScrollBtnPanel);
  FScrollLeftBtn.Parent := FScrollBtnPanel;
  FScrollLeftBtn.SetBounds(0,0,20,Height);
  FScrollLeftBtn.Caption := '<';
  FScrollLeftBtn.Font.Name := 'MS Sans Serif';
  FScrollLeftBtn.Font.Style := [fsBold];
  FScrollLeftBtn.Layout := blGlyphBottom;
  FScrollLeftBtn.OnClick := ScrollLeft;

  FScrollRightBtn := TSpeedButton.Create(FScrollBtnPanel);
  FScrollRightBtn.Parent := FScrollBtnPanel;
  FScrollRightBtn.SetBounds(20,0,20,Height);
  FScrollRightBtn.Caption := '>';
  FScrollRightBtn.Font.Name := 'MS Sans Serif';
  FScrollRightBtn.Font.Style := [fsBold];
  FScrollRightBtn.Layout := blGlyphBottom;
  FScrollRightBtn.OnClick := ScrollRight;

  FPaintBox := TPaintBox.Create(Self);
  FPaintBox.Parent := Self;
  FPaintBox.Align := alClient;
  FPaintBox.OnPaint := Paint;
  FPaintBox.OnMouseDown := MouseDown;
  FPaintBox.OnMouseMove := MouseMove;
  FPaintBox.OnMouseUp := MouseUp;
  FPaintBox.OnMouseLeave := MouseLeave;
  FPaintBox.Cursor := crDefault;

  FWhiteBmp := TBitmap.Create;
  FWhiteBmp.Handle := LoadBitmap(HInstance,'CLOSEBTNWHITE');

  FGrayBmp := TBitmap.Create;
  FGrayBmp.Handle := LoadBitmap(HInstance,'CLOSEBTNGRAY');
end;

destructor TTabControl.Destroy;
begin
  {}
  inherited Destroy;
end;

procedure TTabControl.Paint(Sender: TObject);
var
  i,j,left: Integer;
begin
  FPaintBox.Canvas.Pen.Color := clGray;
  left := 8;
  for i := FScrollPos to Length(TabArray) - 1 do begin
    FPaintBox.Canvas.TextOut(left,3,TabArray[i].Caption);

    FPaintBox.Canvas.MoveTo(left-8 + Round(TabArray[i].Width * SCREENSCALE),0);
    FPaintBox.Canvas.LineTo(left-8 + Round(TabArray[i].Width * SCREENSCALE),FPaintBox.Height);

    if TabArray[i].Activ then begin
      FPaintBox.Canvas.MoveTo(left-8, 0);
      FPaintBox.Canvas.LineTo(left-8 + Round(TabArray[i].Width * SCREENSCALE), 0);
      FPaintBox.Canvas.MoveTo(left-8,0);
      FPaintBox.Canvas.LineTo(left-8,FPaintBox.Height);
      FPaintBox.Canvas.MoveTo(left-8 + Round(TabArray[i].Width * SCREENSCALE), 0);
      FPaintBox.Canvas.LineTo(left-8 + Round(TabArray[i].Width * SCREENSCALE), FPaintBox.Height);
      FPaintBox.Canvas.MoveTo(0, FPaintBox.Height-1);
      FPaintBox.Canvas.LineTo(left-8, FPaintBox.Height-1);
      FPaintBox.Canvas.MoveTo(left-8 + Round(TabArray[i].Width * SCREENSCALE), FPaintBox.Height-1);
      FPaintBox.Canvas.LineTo(Round(TabArray[i].Width * SCREENSCALE), FPaintBox.Height-1);
    end;
    FPaintBox.Canvas.Draw(left-8 + Round(TabArray[i].Width * SCREENSCALE) - 15, 4, FWhiteBmp);
    left := left + Round(TabArray[i].Width * SCREENSCALE);
  end;
end;

procedure TTabControl.ScrollLeft(Sender: TObject);
begin
  if FScrollPos > 0 then begin
    Dec(FScrollPos);
    FPaintBox.Repaint;
  end;
end;

procedure TTabControl.ScrollRight(Sender: TObject);
begin
  if FScrollPos < Length(TabArray) - 1 then begin
    Inc(FScrollPos);
    FPaintBox.Repaint;
  end;
end;

procedure TTabControl.AddTab(Caption: String; ID: Integer);
var
  i: Integer;
begin
  for i := 0 to Length(TabArray) - 1 do begin
    if ID = TabArray[i].PtrID then begin
      //raise Exception.CreateFmt('duplicate value of id : ' + IntToStr(ID), [name]);
      Exit;
    end;
  end;
  SetLength(TabArray, Length(TabArray) + 1);
  TabArray[Length(TabArray) - 1].Caption := Caption;
  TabArray[Length(TabArray) - 1].Width := 8 + Length(Caption) * 8 + 20;
  TabArray[Length(TabArray) - 1].PtrID := ID;
  SelectTab(TabArray[Length(TabArray) - 1].PtrID);
  FPaintBox.Repaint;
end;

procedure TTabControl.SwapTab(PosFrom, PosTo: Integer);
var
  i: Integer;
  BufBuf: TTabs;
begin
  BufBuf.Caption := TabArray[PosFrom].Caption;
  BufBuf.Width := TabArray[PosFrom].Width;
  BufBuf.Activ := TabArray[PosFrom].Activ;
  BufBuf.PtrID := TabArray[PosFrom].PtrID;

  for i := PosFrom to Length(TabArray) - 2 do begin
    TabArray[i].Caption := TabArray[i+1].Caption;
    TabArray[i].Width := TabArray[i+1].Width;
    TabArray[i].Activ := TabArray[i+1].Activ;
    TabArray[i].PtrID := TabArray[i+1].PtrID;
  end;

  for i := Length(TabArray) - 1 downto PosTo + 1 do begin
    TabArray[i].Caption := TabArray[i-1].Caption;
    TabArray[i].Width := TabArray[i-1].Width;
    TabArray[i].Activ := TabArray[i-1].Activ;
    TabArray[i].PtrID := TabArray[i-1].PtrID;
  end;

  TabArray[PosTo].Caption := BufBuf.Caption;
  TabArray[PosTo].Width := BufBuf.Width;
  TabArray[PosTo].Activ := BufBuf.Activ;
  TabArray[PosTo].PtrID := BufBuf.PtrID;
end;

procedure TTabControl.CloseTab(TabID: Integer);
var
  i, from: Integer;
begin
  if Assigned(FCloseTab) then FCloseTab(Self, TabID);
  if (TabId = -1) then Exit;

  if Length(TabArray) > 1 then begin
    for i := 0 to Length(TabArray) - 1 do begin
      if TabArray[i].PtrID = TabID then begin
        from := i;

        if TabArray[i].Activ then begin
          if i < Length(TabArray) - 1 then SelectTab(TabArray[i+1].PtrID)
          else if (i > 0) then begin
             SelectTab(TabArray[i-1].PtrID);
             ScrollRightIfHide(i-1);
          end;
        end;
        if i > 0 then ScrollRightIfHide(i-1);

        Break;
      end;
    end;

    for i := from to Length(TabArray) - 2 do begin
      TabArray[i].Caption := TabArray[i+1].Caption;
      TabArray[i].Width := TabArray[i+1].Width;
      TabArray[i].Activ := TabArray[i+1].Activ;
      TabArray[i].PtrID := TabArray[i+1].PtrID;
    end;
    SetLength(TabArray,Length(TabArray) - 1);
  end else
    SetLength(TabArray,0);
end;

procedure TTabControl.SelectTab(TabID: Integer);
var
  i, TabLeft, ActivI: Integer;
begin
  for i := 0 to Length(TabArray) - 1 do begin
    if TabArray[i].PtrID = TabID then begin
      TabArray[i].Activ := True;
      ActivI := i
    end else
      TabArray[i].Activ := False
  end;

  TabLeft := 0;
  for i := FScrollPos to ActivI do begin
      TabLeft := TabLeft + Round(TabArray[i].Width * SCREENSCALE);
  end;
  while (TabLeft > Width) do begin
    Inc(FScrollPos);
    TabLeft := 0;
    for i := FScrollPos to ActivI do begin
      TabLeft := TabLeft + Round(TabArray[i].Width * SCREENSCALE);
    end;
  end;

  if Assigned(FChoiceTab) then FChoiceTab(Self, TabID);
end;

procedure TTabControl.ScrollRightIfHide(Pos: Integer);
begin
  if Pos <= FScrollPos then begin
    FScrollPos := Pos;
    FPaintBox.Repaint;
  end;
end;

procedure TTabControl.Update;
begin
  FPaintBox.Repaint;
end;

procedure TTabControl.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i, left: Integer;
  ActivNo: Integer;
  L,R: Integer;
begin
  ActivNo := -1;
  FMoveFrom := ActivNo;
  FMoveTo := ActivNo;
  FMoveX := X;

  left := 0;
  for i := FScrollPos to Length(TabArray) - 1 do begin
    left := left + Round(TabArray[i].Width * SCREENSCALE);
    if X < left then begin
      //на крестик
      if (X < left - 3) and (X > left - 15) and (Y > 4) and (Y < 16) then begin
        CloseTab(TabArray[i].PtrID);
        FTabMove := False;
      //end на крестик
      end else begin
        ActivNo := i;
        FTabMove := True;
      end;

      Break;
    end;
  end;

  if ActivNo <> - 1 then begin
   // if not FTabArray[ActivNo].Activ then begin
      SelectTab(TabArray[ActivNo].PtrID);
      FMoveFrom := ActivNo;
      FMoveTo := ActivNo;
   // end;
  end;

  FPaintBox.Repaint;
end;

procedure TTabControl.MouseMove(Sender: TObject; Shift:
  TShiftState; X, Y: Integer);
var
  i,left: Integer;
begin
  //FPaintBox.Repaint;
  if FTabMove and (ABS(X - FMoveX) > 5) then begin
    Screen.Cursor := crDrag;
    FMoveTo := -1;
    left := 0;
    for i := FScrollPos to Length(TabArray) - 1 do begin
      left := left + Round(TabArray[i].Width * SCREENSCALE);
      if X < left then begin
        FMoveTo := i;
        Break;
      end;
    end;
  end else begin
    left := 0;
    for i := FScrollPos to Length(TabArray) - 1 do begin
      left := left + Round(TabArray[i].Width * SCREENSCALE);
      if X < left then begin
        //на крестик
        if (X < left - 3) and (X > left - 15) and (Y > 4) and (Y < 16) then
          FPaintBox.Canvas.Draw(left - 15, 4, FGrayBmp)
        else
          FPaintBox.Canvas.Draw(left - 15, 4, FWhiteBmp);
        //end на крести
        Break;
      end;
    end;
  end;
end;

procedure TTabControl.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FTabMove then begin
    Screen.Cursor := crDefault;
    if (FMoveFrom <> - 1) and (FMoveTo <> - 1) and (FMoveFrom <> FMoveTo) then begin
      SwapTab(FMoveFrom, FMoveTo);
    end;
    FTabMove := False;
  end;

  FPaintBox.Repaint;
end;

procedure TTabControl.MouseLeave(Sender: TObject);
begin
  FPaintBox.Repaint;
end;

function TTabControl.GetTabCount: Integer;
begin
  Result := Length(TabArray);
end;

function TTabControl.Title(Index: Integer): String;
begin
  Result := TabArray[Index].Caption;
end;

procedure TTabControl.RenameTab(Index: Integer; Caption: String);
var
  Idx, i: Integer;
begin
  for i := 0 to Length(TabArray) - 1 do begin
    if TabArray[i].PtrID = Index then begin
      Idx := i;
      Break;
    end;
  end;

  TabArray[Idx].Caption := Caption;
  TabArray[Idx].Width := 8 + Length(Caption) * 8 + 20;
end;

procedure TTabControl.ReScale;
var
  Sz: Integer;
begin
  Align := alClient;
  FScrollBtnPanel.Height := Round(Self.Height * SCREENSCALE);
  FScrollBtnPanel.Width := FScrollBtnPanel.Height * 2;
  FScrollBtnPanel.Align := alRight;
  Sz := FScrollBtnPanel.Height;
  FScrollLeftBtn.SetBounds(0,0,Sz,Sz);
  FScrollRightBtn.SetBounds(Sz,0,Sz,Sz);
end;

end.
