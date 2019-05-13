unit DocumentMap;

interface
          
uses
  Windows, Controls, Classes, Forms, ExtCtrls, Graphics, StdCtrls, Dialogs,
  Types, Messages, ClipBrd, Buttons, ComCtrls, Menus, Printers, PHPEdit;

type
  TDocMap = class(TPanel)
  private
    FPaintBox: TPaintBox;
    FPHPEdit: TPHPEdit;
    FLineHeight: Integer;
    FCharWidth: Integer;
    FRectangle: array[0..1] of TPoint;
    FPredVertPos: Integer;
    FPrVertPos: Integer;
    FShf: Integer;
    FClickShf: Integer;
    FPredClickShf: Integer;
    FMove: Boolean;
  public
    procedure Update;
    procedure Paint(Sender: TObject);
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    constructor Create(AOwner: TWinControl);
    destructor Destroy; override;
  end;

implementation

uses Main, SysUtils, StyleConfigurator;

constructor TDocMap.Create(AOwner: TWinControl);
begin
  inherited Create(AOwner);
  Parent := AOwner;
  FPHPEdit := TPHPEdit(AOwner);

  Color := clWhite;
  Font.Color := clRed;
  Font.Name := 'Courier New';
  Font.Size := 4;

  if (SCREENSCALE = 1.25)  then begin
    FLineHeight := 6;
    FCharWidth := 4;
  end
  else  if (SCREENSCALE = 1.50)  then begin
    FLineHeight := 8;
    FCharWidth := 5;
  end
  else begin
    FLineHeight := 4;
    FCharWidth := 3;
  end;

  FPredVertPos := 0;
  FPrVertPos := 0;
  FShf := 0;
  FClickShf := 0;
  FPredClickShf := 0;

  BevelOuter := bvNone;
  BevelInner := bvNone;
  DoubleBuffered := True;
  ControlStyle := ControlStyle + [csOpaque];

  FPaintBox := TPaintBox.Create(Self);
  FPaintBox.Parent := Self;
  FPaintBox.Align := alClient;
  FPaintBox.Canvas.Pen.Mode := pmNotXor;
  FPaintBox.OnPaint := Paint;


  FPaintBox.OnMouseDown := MouseDown;
  FPaintBox.OnMouseMove := MouseMove;
  FPaintBox.OnMouseUp := MouseUp;
end;

destructor TDocMap.Destroy;
begin
  inherited Destroy;
end;

procedure TDocMap.Paint(Sender: TObject);
var
  BeginLine, EndLine: Integer;
  i,j,n,predj: Integer;
  predstate: TState;
begin
  if FPrVertPos > FPHPEdit.GetVertScrollPos then begin
    //Scroll Up
    FShf := FShf - (FPredVertPos - FPHPEdit.GetVertScrollPos);
    FPredVertPos := FPHPEdit.GetVertScrollPos + 0;
    FPrVertPos := FPHPEdit.GetVertScrollPos + 1;

    FPredClickShf := FShf;
    
    if (FShf > 0) then begin
      FRectangle[0].X := 0;
      FRectangle[0].Y := FShf * FLineHeight;
      FRectangle[1].X := FPaintBox.Height;
      FRectangle[1].Y := FShf * FLineHeight + FPHPEdit.GetPaintWndHeight div FPHPEdit.LineHeight * FLineHeight;

      BeginLine := FPHPEdit.StartLine - FShf;
      EndLine := BeginLine + (FPaintBox.Height div FLineHeight) + 1;
    end else begin
      FShf := 0;
      FRectangle[0].X := 0;
      FRectangle[0].Y := FShf * FLineHeight;
      FRectangle[1].X := FPaintBox.Height;
      FRectangle[1].Y := FShf * FLineHeight + FPHPEdit.GetPaintWndHeight div FPHPEdit.LineHeight * FLineHeight;

      BeginLine := FPHPEdit.StartLine;
      EndLine := BeginLine + (FPaintBox.Height div FLineHeight) + 1;
    end;
  end else begin
    //Scroll Down
    FShf := FShf + (FPHPEdit.GetVertScrollPos - FPredVertPos);
    if FShf < 0 then FShf := 0;

    FPredVertPos := FPHPEdit.GetVertScrollPos;
    FPrVertPos := FPHPEdit.GetVertScrollPos;

    FPredClickShf := FShf;

    if (FShf * FLineHeight + FPHPEdit.GetPaintWndHeight div FPHPEdit.LineHeight * FLineHeight) < FPaintBox.Height then begin
      FRectangle[0].X := 0;
      FRectangle[0].Y := FShf * FLineHeight;
      FRectangle[1].X := FPaintBox.Height;
      FRectangle[1].Y := FShf * FLineHeight + FPHPEdit.GetPaintWndHeight div FPHPEdit.LineHeight * FLineHeight;

      BeginLine := FPHPEdit.StartLine - FShf;
      EndLine := BeginLine + (FPaintBox.Height div FLineHeight) + 1;
    end else begin
      FShf := (FPaintBox.Height div FLineHeight) - (FPHPEdit.GetPaintWndHeight div FPHPEdit.LineHeight) + 1;
      FRectangle[0].X := 0;
      FRectangle[0].Y := FShf * FLineHeight;
      FRectangle[1].X := FPaintBox.Height;
      FRectangle[1].Y := FShf * FLineHeight + FPHPEdit.GetPaintWndHeight div FPHPEdit.LineHeight * FLineHeight;

      BeginLine := FPHPEdit.StartLine - FShf;
      EndLine := BeginLine + (FPaintBox.Height div FLineHeight) + 1;
    end;
  end;


  FPaintBox.Canvas.Brush.Color := StyleConfiguratorForm.ColorAr[1];
  FPaintBox.Canvas.Pen.Color := StyleConfiguratorForm.ColorAr[1];
  FPaintBox.Canvas.Rectangle(0,0,FPaintBox.Width, FPaintBox.Height);

  n := 0;
  predstate := ScanNormal;

  for i := BeginLine to EndLine - 1 do begin
    if (i < FPHPEdit.StringList.Count) and (i >= 0) then begin
      predj := 1;
      if (FPHPEdit.LineStateAr[i].Max = 0) and (Length(FPHPEdit.LineStateAr[i].J) = 0) then Exit;
      for j := 0 to FPHPEdit.LineStateAr[i].Max do begin

        if ((predj-FPHPEdit.HorsStartPos) * FCharWidth) > FPaintBox.Width then Break;

        if (j+1) <= FPHPEdit.LineStateAr[i].Max then begin
          if FPHPEdit.LineStateAr[i].J[j+1] < FPHPEdit.HorsStartPos then Continue;
        end;

        case predstate of
          ScanNormal:begin
            if StyleConfiguratorForm.BoldAr[3] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[3];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
          end;
          ScanPHP,
          ScanOpenRoundPHP,
          ScanCloseRoundPHP,
          ScanOpenCurlPHP,
          ScanCloseCurlPHP,
          ScanOpenRoundJS,
          ScanCloseRoundJS,
          ScanOpenCurlJS,
          ScanCloseCurlJS,
          ScanOpenCurlCSS,
          ScanCloseCurlCSS:begin
            if StyleConfiguratorForm.BoldAr[3] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[3];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
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
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
          end;
          ScanComment,
          ScanLineComment:begin
            if StyleConfiguratorForm.BoldAr[5] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[5];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
          end;
          ScanVar:begin
            if StyleConfiguratorForm.BoldAr[6] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[6];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
          end;
          ScanReserv:begin
            if StyleConfiguratorForm.BoldAr[7] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[7];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
            FPaintBox.Canvas.Font.Style := [];
          end;
          ScanFunc:begin
            if StyleConfiguratorForm.BoldAr[8] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[8];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
          end;
          ScanDigit:begin
            if StyleConfiguratorForm.BoldAr[9] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[9];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
          end;
          ScanPHPTag:begin
            if StyleConfiguratorForm.BoldAr[10] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[10];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
            FPaintBox.Canvas.Font.Style := [];
          end;
          ScanHTMLTag:begin
            if StyleConfiguratorForm.BoldAr[11] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[11];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
          end;
          ScanHTMLAttr:begin
            if StyleConfiguratorForm.BoldAr[13] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[13];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
          end;
          ScanOpenHTML,
          ScanOpenCSS,
          ScanOpenJS:begin
            if StyleConfiguratorForm.BoldAr[12] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[12];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
          end;
          ScanCloseHTML,
          ScanCloseCSS,
          ScanCloseJS:begin
            if StyleConfiguratorForm.BoldAr[12] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[12];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
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
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
          end;
          ScanHTMLComment,
          ScanLineJSComment,
          ScanJSComment:begin
            if StyleConfiguratorForm.BoldAr[14] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[14];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
          end;
          ScanHTMLHeader:begin
            if StyleConfiguratorForm.BoldAr[15] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[15];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
          end;
          ScanCSSTag:begin
            if StyleConfiguratorForm.BoldAr[16] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[16];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
          end;
          ScanCSSBody:begin
            if StyleConfiguratorForm.BoldAr[17] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[17];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
            FPaintBox.Canvas.Font.Style := [];
          end;
          ScanCSSAttr:begin
            if StyleConfiguratorForm.BoldAr[18] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[18];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
            FPaintBox.Canvas.Font.Style := [];
          end;
          ScanCSSComment:begin
            if StyleConfiguratorForm.BoldAr[19] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[19];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
          end;
          ScanJSTag:begin
            if StyleConfiguratorForm.BoldAr[20] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[20];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
          end;
          ScanJSBody:begin
            if StyleConfiguratorForm.BoldAr[21] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[21];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
          end;
          ScanJSReserv:begin
            if StyleConfiguratorForm.BoldAr[22] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[22];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
            FPaintBox.Canvas.Font.Style := [];
          end;
          ScanJSObj:begin
            if StyleConfiguratorForm.BoldAr[23] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[23];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
            FPaintBox.Canvas.Font.Style := [];
          end;
          ScanJSMetods:begin
            if StyleConfiguratorForm.BoldAr[24] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[24];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
          end;
          ScanJSProp:begin
            if StyleConfiguratorForm.BoldAr[25] then
              FPaintBox.Canvas.Font.Style := [fsBold]
            else
              FPaintBox.Canvas.Font.Style := [];

            FPaintBox.Canvas.Font.Color := StyleConfiguratorForm.ColorAr[25];
            FPaintBox.Canvas.TextOut((predj-FPHPEdit.HorsStartPos)*FCharWidth,n*FLineHeight,Copy(FPHPEdit.StringList[i],predj,FPHPEdit.LineStateAr[i].J[j]-predj));
          end;
        end;

        predj := FPHPEdit.LineStateAr[i].J[j];
        predstate := FPHPEdit.LineStateAr[i].Pos[j];
      end;
      Inc(n);
    end;
  end;
  //FPaintBox.Canvas.Pen.Style := psDot;
  FPaintBox.Canvas.Pen.Color := RGB(245,245,245);;
  FPaintBox.Canvas.MoveTo(1,0);
  FPaintBox.Canvas.LineTo(1,FPaintBox.Height);

  if StyleConfiguratorForm.ListBox.ItemIndex <> 0 then begin
    FPaintBox.Canvas.Pen.Color := StyleConfiguratorForm.ColorAr[2];
    FPaintBox.Canvas.Brush.Color := StyleConfiguratorForm.ColorAr[2];
  end
  else begin
    FPaintBox.Canvas.Pen.Color := RGB(255,250,175);
    FPaintBox.Canvas.Brush.Color := RGB(255,250,175);
  end;
  FPaintBox.Canvas.Rectangle(FRectangle[0].X, FRectangle[0].Y, FRectangle[1].X, FRectangle[1].Y);
end;

procedure TDocMap.Update;
begin
  FPaintBox.Repaint;
end;

procedure TDocMap.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMove := True;

  FClickShf := (Y div FLineHeight) - (FPHPEdit.GetPaintWndHeight div FPHPEdit.LineHeight div 2);
  if (FPHPEdit.StringList.Count - 1) > (FPHPEdit.GetVertScrollPos + (FClickShf - FPredClickShf)) then begin
    FShf := FPredClickShf;
    FPHPEdit.ScrollTo(FPHPEdit.GetVertScrollPos + (FClickShf - FPredClickShf));
    FPredClickShf := FClickShf;
  end else begin
    FPHPEdit.ScrollTo(FPHPEdit.GetVertScrollPos + ABS(FClickShf));
  end;

  if FClickShf < 0  then begin
    FPHPEdit.ScrollTo(FPHPEdit.GetVertScrollPos - ABS(FClickShf));
  end;
  if FClickShf > (FPaintBox.Height div FLineHeight) - (FPHPEdit.GetPaintWndHeight div FPHPEdit.LineHeight) then begin
    FPHPEdit.ScrollTo(FPHPEdit.GetVertScrollPos + ABS(FClickShf - FPredClickShf));
  end;
end;

procedure TDocMap.MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if FMove then begin
    FClickShf := (Y div FLineHeight) - (FPHPEdit.GetPaintWndHeight div FPHPEdit.LineHeight div 2);
    if (FPHPEdit.StringList.Count - 1) > (FPHPEdit.GetVertScrollPos + (FClickShf - FPredClickShf)) then begin
      FShf := FPredClickShf;
      FPHPEdit.ScrollTo(FPHPEdit.GetVertScrollPos + (FClickShf - FPredClickShf));
      FPredClickShf := FClickShf;
    end else begin
      FPHPEdit.ScrollTo(FPHPEdit.GetVertScrollPos + ABS(FClickShf));
    end;

    if FClickShf < 0  then begin
      FPHPEdit.ScrollTo(FPHPEdit.GetVertScrollPos - ABS(FClickShf));
    end;
    if FClickShf > (FPaintBox.Height div FLineHeight) - (FPHPEdit.GetPaintWndHeight div FPHPEdit.LineHeight) then begin
      FPHPEdit.ScrollTo(FPHPEdit.GetVertScrollPos + ABS(FClickShf - FPredClickShf));
    end;
  end;
end;

procedure TDocMap.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMove := False;
end;

end.
