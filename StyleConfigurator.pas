unit StyleConfigurator;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, XMLDoc, XMLIntf;

type
  TStyleConfiguratorForm = class(TForm)
    ListPanel: TPanel;
    ButtonPanel: TPanel;
    MainPanel: TPanel;
    AddBtn: TSpeedButton;
    DelBtn: TSpeedButton;
    UpdBtn: TSpeedButton;
    AplBtn: TSpeedButton;
    ScrollBox: TScrollBox;
    BkLabel: TLabel;
    SelLabel: TLabel;
    BkPanel: TPanel;
    SelPanel: TPanel;
    StrLabel: TLabel;
    NorrmTextLabel: TLabel;
    PHPCommLabel: TLabel;
    PHPVarLabel: TLabel;
    PHPReservLabel: TLabel;
    PHPFuncLabel: TLabel;
    DigLabel: TLabel;
    PHPTagLabel: TLabel;
    HTMLTagLabel: TLabel;
    HTMLAttrLabel: TLabel;
    InHtmlLabel: TLabel;
    CommHTMLJSLabel: TLabel;
    HTMLHeaderLabel: TLabel;
    CSSTagLabel: TLabel;
    CSSBodyLabel: TLabel;
    CSSAttrLabel: TLabel;
    CSSCommLabel: TLabel;
    JSTagLabel: TLabel;
    JSBodyLabel: TLabel;
    JSReservLabel: TLabel;
    JSObjLabel: TLabel;
    JSMetLabel: TLabel;
    JSPropLabel: TLabel;
    NormTextPanel: TPanel;
    StrPanel: TPanel;
    PHPCommPanel: TPanel;
    PHPVarPanel: TPanel;
    PHPReservPanel: TPanel;
    PHPFuncPanel: TPanel;
    DigPanel: TPanel;
    PHPTagPanel: TPanel;
    HTMLTagPanel: TPanel;
    HTMLInTagPanel: TPanel;
    HTMLAttrPanel: TPanel;
    HTMLJSCommPanel: TPanel;
    HTMLHeaderPanel: TPanel;
    CSSTagPanel: TPanel;
    CSSBodyPanel: TPanel;
    CSSAttrPanel: TPanel;
    CSSCommPanel: TPanel;
    JSTagPanel: TPanel;
    JSBodyPanel: TPanel;
    JSReservPanel: TPanel;
    JSObjPanel: TPanel;
    JSMetPanel: TPanel;
    JSPropPanel: TPanel;
    Bold03: TCheckBox;
    Bold04: TCheckBox;
    Bold05: TCheckBox;
    Bold06: TCheckBox;
    Bold07: TCheckBox;
    Bold08: TCheckBox;
    Bold09: TCheckBox;
    Bold10: TCheckBox;
    Bold11: TCheckBox;
    Bold12: TCheckBox;
    Bold13: TCheckBox;
    Bold14: TCheckBox;
    Bold15: TCheckBox;
    Bold16: TCheckBox;
    Bold17: TCheckBox;
    Bold18: TCheckBox;
    Bold19: TCheckBox;
    Bold20: TCheckBox;
    Bold21: TCheckBox;
    Bold22: TCheckBox;
    Bold23: TCheckBox;
    Bold24: TCheckBox;
    Bold25: TCheckBox;
    Img01: TImage;
    Img02: TImage;
    Img03: TImage;
    Img04: TImage;
    Img05: TImage;
    Img06: TImage;
    Img07: TImage;
    Img08: TImage;
    Img09: TImage;
    Img10: TImage;
    Img11: TImage;
    Img12: TImage;
    Img13: TImage;
    Img14: TImage;
    Img15: TImage;
    Img16: TImage;
    Img17: TImage;
    Img18: TImage;
    Img19: TImage;
    Img20: TImage;
    Img21: TImage;
    Img22: TImage;
    Img23: TImage;
    Img24: TImage;
    Img25: TImage;
    ColorDialog: TColorDialog;
    ListBox: TListBox;
    Bold26: TCheckBox;
    HTMLValPanel: TPanel;
    Img26: TImage;
    HTMLValLabel: TLabel;
    procedure Img01Click(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure DelBtnClick(Sender: TObject);
    procedure UpdBtnClick(Sender: TObject);
    procedure AplBtnClick(Sender: TObject);
    procedure Bold03Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    StyleColorArray: array of array of TColor;
    StyleBoldArray: array of array of Boolean;
    ImagesPtr: array[1..26] of TImage;
    BoldPtr: array[1..26] of TCheckBox;
    SelIdx: Integer;
  public
    ColorAr: array[1..26] of TColor;
    BoldAr: array[1..26] of Boolean;
  end;

var
  StyleConfiguratorForm: TStyleConfiguratorForm;

implementation

uses Main;

{$R *.dfm}

procedure TStyleConfiguratorForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i,j: Integer;
  StyleList: TStringList;
  Encoding: TEncoding;
begin
  try
    Encoding := TUTF8Encoding.Create;
    StyleList := TStringList.Create;
    StyleList.Add('<?xml version="1.0" encoding="UTF-8" ?>');
    StyleList.Add('<PHPNotepad>');
    for i := 1 to ListBox.Count - 1 do begin
      StyleList.Add('  <Style>');
      StyleList.Add('    <Name>'+ListBox.Items.Strings[i]+'</Name>');
      if ListBox.ItemIndex = i then begin
        StyleList.Add('    <Activ>True</Activ>');
      end else begin
        StyleList.Add('    <Activ>False</Activ>');
      end;
      for j := 0 to 25 do begin
        StyleList.Add('    <Color'+IntToStr(j+1)+'>'+ColorToString(StyleColorArray[i,j])+'</Color'+IntToStr(j+1)+'>');
        if StyleBoldArray[i,j] then begin
          StyleList.Add('    <Bold'+IntToStr(j+1)+'>True</Bold'+IntToStr(j+1)+'>');
        end else begin
          StyleList.Add('    <Bold'+IntToStr(j+1)+'>False</Bold'+IntToStr(j+1)+'>');
        end;
      end;
      StyleList.Add('  </Style>');
    end;
    StyleList.Add('</PHPNotepad>');
    StyleList.SaveToFile(ExtractFilePath(Application.ExeName)+'\AppData\styles.xml', Encoding);
  except
  end;
end;

procedure TStyleConfiguratorForm.FormCreate(Sender: TObject);
var
  i,j: Integer;
  XMLDocument: TXMLDocument;
  Root, Child: IXMLNode;
  AFile: String;
  TopIndex: Integer;
  colorj, boldj: Integer;
begin
  ListBox.AddItem('Default', TObject(0));
  Listbox.Selected[0]:= True;
  SelIdx := 0;

  SetLength(StyleColorArray, 1, 26);    SetLength(StyleBoldArray, 1, 26);
  StyleColorArray[0,0]  := clWhite;     StyleBoldArray[0,0]  := False;
  StyleColorArray[0,1]  := $00F4F4F4;   StyleBoldArray[0,1]  := False;
  StyleColorArray[0,2]  := clBlack;     StyleBoldArray[0,2]  := False;
  StyleColorArray[0,3]  := clGreen;     StyleBoldArray[0,3]  := False;
  StyleColorArray[0,4]  := $0005B4F5;   StyleBoldArray[0,4]  := False;
  StyleColorArray[0,5]  := clGray;      StyleBoldArray[0,5]  := False;
  StyleColorArray[0,6]  := $00FF874B;     StyleBoldArray[0,6]  := True;
  StyleColorArray[0,7]  := clBlue;      StyleBoldArray[0,7]  := False;
  StyleColorArray[0,8]  := clRed;       StyleBoldArray[0,8]  := False;
  StyleColorArray[0,9]  := clRed;       StyleBoldArray[0,9]  := True;
  StyleColorArray[0,10] := $00FF972F;   StyleBoldArray[0,10] := False;
  StyleColorArray[0,11] := clBlack;     StyleBoldArray[0,11] := False;
  StyleColorArray[0,12] := clOlive;     StyleBoldArray[0,12] := False;
  StyleColorArray[0,13] := $00ADADAD;   StyleBoldArray[0,13] := False;
  StyleColorArray[0,14] := $00FFE9B9;   StyleBoldArray[0,14] := False;
  StyleColorArray[0,15] := $000080FF;   StyleBoldArray[0,15] := False;
  StyleColorArray[0,16] := clBlack;     StyleBoldArray[0,16] := True;
  StyleColorArray[0,17] := $00FF0080;   StyleBoldArray[0,17] := True;
  StyleColorArray[0,18] := $00A4A4A4;   StyleBoldArray[0,18] := False;
  StyleColorArray[0,19] := clRed;       StyleBoldArray[0,19] := False;
  StyleColorArray[0,20] := clBlack;     StyleBoldArray[0,20] := False;
  StyleColorArray[0,21] := clBlue;      StyleBoldArray[0,21] := True;
  StyleColorArray[0,22] := $000062C4;   StyleBoldArray[0,22] := True;
  StyleColorArray[0,23] := clGray;      StyleBoldArray[0,23] := False;
  StyleColorArray[0,24] := $00408080;   StyleBoldArray[0,24] := False;
  StyleColorArray[0,25] := clPurple;    StyleBoldArray[0,25] := False;

  ImagesPtr[1]  := Img01;
  ImagesPtr[2]  := Img02;
  ImagesPtr[3]  := Img03;             BoldPtr[3]  := Bold03;
  ImagesPtr[4]  := Img04;             BoldPtr[4]  := Bold04;
  ImagesPtr[5]  := Img05;             BoldPtr[5]  := Bold05;
  ImagesPtr[6]  := Img06;             BoldPtr[6]  := Bold06;
  ImagesPtr[7]  := Img07;             BoldPtr[7]  := Bold07;
  ImagesPtr[8]  := Img08;             BoldPtr[8]  := Bold08;
  ImagesPtr[9]  := Img09;             BoldPtr[9]  := Bold09;
  ImagesPtr[10] := Img10;             BoldPtr[10] := Bold10;
  ImagesPtr[11] := Img11;             BoldPtr[11] := Bold11;
  ImagesPtr[12] := Img12;             BoldPtr[12] := Bold12;
  ImagesPtr[13] := Img13;             BoldPtr[13] := Bold13;
  ImagesPtr[14] := Img14;             BoldPtr[14] := Bold14;
  ImagesPtr[15] := Img15;             BoldPtr[15] := Bold15;
  ImagesPtr[16] := Img16;             BoldPtr[16] := Bold16;
  ImagesPtr[17] := Img17;             BoldPtr[17] := Bold17;
  ImagesPtr[18] := Img18;             BoldPtr[18] := Bold18;
  ImagesPtr[19] := Img19;             BoldPtr[19] := Bold19;
  ImagesPtr[20] := Img20;             BoldPtr[20] := Bold20;
  ImagesPtr[21] := Img21;             BoldPtr[21] := Bold21;
  ImagesPtr[22] := Img22;             BoldPtr[22] := Bold22;
  ImagesPtr[23] := Img23;             BoldPtr[23] := Bold23;
  ImagesPtr[24] := Img24;             BoldPtr[24] := Bold24;
  ImagesPtr[25] := Img25;             BoldPtr[25] := Bold25;
  ImagesPtr[26] := Img26;             BoldPtr[26] := Bold26;

  try
    AFile := ExtractFilePath(Application.ExeName)+'\AppData\styles.xml';
    XMLDocument := TXMLDocument.Create(Application);
    XMLDocument.LoadFromFile(AFile);
    XMLDocument.Active := True;

    Root := XMLDocument.DocumentElement;
    TopIndex := 1;
    for i := 0 to Root.ChildNodes.Count - 1 do begin
      if Root.ChildNodes[i].NodeName = 'Style' then begin
        Child := Root.ChildNodes[i];
        ListBox.AddItem(Child.ChildNodes[0].Text, TObject(i+1));

        if StrToBool(Child.ChildNodes[1].Text) then begin
          Listbox.Selected[i+1]:= True;
          SelIdx := i+1;
        end;

        SetLength(StyleColorArray, TopIndex+1, 26);
        SetLength(StyleBoldArray, TopIndex+1, 26);

        colorj := 0;
        boldj := 0;
        for j := 2 to Child.ChildNodes.Count - 1 do begin
          if (j mod 2) = 0 then begin
            StyleColorArray[TopIndex, colorj] := StringToColor(Child.ChildNodes[j].Text);
            Inc(colorj);
          end else begin
            StyleBoldArray[TopIndex, boldj] := StrToBool(Child.ChildNodes[j].Text);
            Inc(boldj);
          end;
        end;
        Inc(TopIndex);
      end;
    end;

  except
    Listbox.Selected[0]:= True;
    SelIdx := 0;
  end;

  for i := 1 to 26 do begin
    ImagesPtr[i].Canvas.Pen.Color := clBtnFace;
    ImagesPtr[i].Canvas.Brush.Color := clBtnFace;
    ImagesPtr[i].Canvas.Rectangle(0,0,TImage(Sender).Width,TImage(Sender).Height);

    ImagesPtr[i].Canvas.Brush.Color := StyleColorArray[SelIdx, i - 1];
    ImagesPtr[i].Canvas.Rectangle(2,2,16,16);
  end;

  for i := 3 to 26 do begin
    BoldPtr[i].Checked := StyleBoldArray[SelIdx, i - 1];
    if ListBox.ItemIndex = 0 then begin
      BoldPtr[i].Enabled := False;
    end else begin
      BoldPtr[i].Enabled := True;
    end;
  end;

  for i := 1 to 26 do begin
    ColorAr[i] := StyleColorArray[ListBox.ItemIndex, i - 1];
    BoldAr[i] := StyleBoldArray[ListBox.ItemIndex, i - 1];
  end;
end;

procedure TStyleConfiguratorForm.Img01Click(Sender: TObject);
begin
  if ListBox.ItemIndex <> 0 then begin
    ColorDialog.Color := ColorAr[TImage(Sender).Tag];
    if ColorDialog.Execute then begin
      TImage(Sender).Canvas.Pen.Color := TPanel(TWinControl(Sender).Parent).Color;
      TImage(Sender).Canvas.Brush.Color := TPanel(TWinControl(Sender).Parent).Color;
      TImage(Sender).Canvas.Rectangle(0,0,TImage(Sender).Width,TImage(Sender).Height);

      TImage(Sender).Canvas.Brush.Color := ColorDialog.Color;
      TImage(Sender).Canvas.Rectangle(2,2,16,16);

      StyleColorArray[ListBox.ItemIndex, TImage(Sender).Tag - 1] := ColorDialog.Color;
    end;
  end;
end;

procedure TStyleConfiguratorForm.ListBoxClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 1 to 26 do begin
    ImagesPtr[i].Canvas.Pen.Color := clBtnFace;
    ImagesPtr[i].Canvas.Brush.Color := clBtnFace;
    ImagesPtr[i].Canvas.Rectangle(0,0,20,20);

    ImagesPtr[i].Canvas.Brush.Color := StyleColorArray[ListBox.ItemIndex, i - 1];
    ImagesPtr[i].Canvas.Rectangle(2,2,16,16);
  end;

  for i := 3 to 26 do begin
    BoldPtr[i].Checked := StyleBoldArray[ListBox.ItemIndex, i - 1];
    if ListBox.ItemIndex = 0 then begin
      BoldPtr[i].Enabled := False;
    end else begin
      BoldPtr[i].Enabled := True;
    end;
  end;
end;

procedure TStyleConfiguratorForm.Bold03Click(Sender: TObject);
begin
  if ListBox.ItemIndex <> 0 then begin
    if TCheckBox(Sender).Checked then begin
      StyleBoldArray[ListBox.ItemIndex, TImage(Sender).Tag - 1] := True;
    end else begin
      StyleBoldArray[ListBox.ItemIndex, TImage(Sender).Tag - 1] := False;
    end;
  end;
end;

procedure TStyleConfiguratorForm.AddBtnClick(Sender: TObject);
var
  i: Integer;
  NewItem: String;
  flag: Boolean;
begin
  NewItem := InputBox('Add style','Style name:','');

  if NewItem <> '' then begin
    flag := False;
    for i := 0 to ListBox.Count - 1 do begin
      if UpperCase(ListBox.Items.Strings[i]) = UpperCase(NewItem) then begin
        ShowMessage('This style name already exists');
        flag := True;
      end;
    end;

    if not flag then begin
      ListBox.AddItem(NewItem,nil);
      SetLength(StyleColorArray, Length(StyleColorArray) + 1, 26);
      SetLength(StyleBoldArray, Length(StyleBoldArray) + 1, 26);

      Listbox.Selected[Listbox.Count - 1] := True;
      SelIdx := Listbox.Count - 1;

      for i := 1 to 26 do begin
        ImagesPtr[i].Canvas.Pen.Color := clBtnFace;
        ImagesPtr[i].Canvas.Brush.Color := clBtnFace;
        ImagesPtr[i].Canvas.Rectangle(0,0,20,20);

        ImagesPtr[i].Canvas.Brush.Color := StyleColorArray[ListBox.ItemIndex, i - 1];
        ImagesPtr[i].Canvas.Rectangle(2,2,16,16);
      end;

      for i := 3 to 26 do begin
        BoldPtr[i].Checked := StyleBoldArray[ListBox.ItemIndex, i - 1];
        if ListBox.ItemIndex = 0 then begin
          BoldPtr[i].Enabled := False;
        end else begin
          BoldPtr[i].Enabled := True;
        end;
      end;
    end;
  end;
end;

procedure TStyleConfiguratorForm.DelBtnClick(Sender: TObject);
var
  BtnSelID, i,j, delid: Integer;
begin
  if ListBox.ItemIndex <> 0 then begin
    BtnSelID := MessageBox(Handle, PChar('Do you really want to delete?'), PChar('Delete'), MB_YESNO+MB_ICONQUESTION);

    if BtnSelID = mrYes then begin
      for i := ListBox.ItemIndex to ListBox.Count - 2 do begin
        for j := 0 to 25 do begin
          StyleColorArray[i,j] := StyleColorArray[i+1,j];
          StyleBoldArray[i,j] := StyleBoldArray[i+1,j];
        end;
      end;

      SetLength(StyleColorArray, Length(StyleColorArray) - 1, 25);
      SetLength(StyleBoldArray, Length(StyleBoldArray) - 1, 25);
      delid := ListBox.ItemIndex;
      ListBox.Items.Delete(ListBox.ItemIndex);

      Listbox.Selected[delid - 1]:= True;
      SelIdx := delid - 1;

      for i := 1 to 26 do begin
        ImagesPtr[i].Canvas.Pen.Color := clBtnFace;
        ImagesPtr[i].Canvas.Brush.Color := clBtnFace;
        ImagesPtr[i].Canvas.Rectangle(0,0,20,20);

        ImagesPtr[i].Canvas.Brush.Color := StyleColorArray[ListBox.ItemIndex, i - 1];
        ImagesPtr[i].Canvas.Rectangle(2,2,16,16);
      end;

      for i := 3 to 26 do begin
        BoldPtr[i].Checked := StyleBoldArray[ListBox.ItemIndex, i - 1];
        if ListBox.ItemIndex = 0 then begin
          BoldPtr[i].Enabled := False;
        end else begin
          BoldPtr[i].Enabled := True;
        end;
      end;
    end;
  end;
end;


procedure TStyleConfiguratorForm.UpdBtnClick(Sender: TObject);
var
  i: Integer;
  NewItem: String;
  flag: Boolean;
begin
  if ListBox.ItemIndex <> 0 then begin
    NewItem := InputBox('Add style','Style name:',ListBox.Items.Strings[ListBox.ItemIndex]);
    if NewItem <> ListBox.Items.Strings[ListBox.ItemIndex] then begin
      flag := False;
      for i := 0 to ListBox.Count - 1 do begin
        if UpperCase(ListBox.Items.Strings[i]) = UpperCase(NewItem) then begin
          ShowMessage('This style name already exists');
          flag := True;
        end;
      end;

      if not flag then begin
        ListBox.Items.Strings[ListBox.ItemIndex] := NewItem;
      end;
    end;
  end;
end;

procedure TStyleConfiguratorForm.AplBtnClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 1 to 26 do begin
    ColorAr[i] := StyleColorArray[ListBox.ItemIndex, i - 1];
    BoldAr[i] := StyleBoldArray[ListBox.ItemIndex, i - 1];
  end;

  for i := 0 to Length(Docs) - 1 do begin
    if Docs[i] <> nil then begin
      Docs[i].Repaint;
    end;
  end;
end;

end.
