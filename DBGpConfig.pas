unit DBGpConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.Buttons, XMLDoc, XMLIntf;

type
  TDBGpConfigForm = class(TForm)
    GroupBox1: TGroupBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    SpinDepth: TSpinEdit;
    SpinChild: TSpinEdit;
    SpinData: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    CheckBoxBreakAtFirst: TCheckBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Init;
  end;

var
  DBGpConfigForm: TDBGpConfigForm;

implementation

{$R *.dfm}

uses Main;

procedure TDBGpConfigForm.BitBtn1Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TDBGpConfigForm.BitBtn2Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TDBGpConfigForm.FormActivate(Sender: TObject);
begin
  if (MainFormPND.BreakAtFirst) then CheckBoxBreakAtFirst.Checked := True
  else CheckBoxBreakAtFirst.Checked := False;

  Init;
end;

procedure TDBGpConfigForm.FormCreate(Sender: TObject);
begin
  Init;
end;

procedure TDBGpConfigForm.Init;
var
  XMLDocument: TXMLDocument;
  AFile: String;
  Root: IXMLNode;
begin
  try
    AFile := ExtractFilePath(Application.ExeName)+'\AppData\DBGp.xml';
    XMLDocument := TXMLDocument.Create(Application);
    XMLDocument.LoadFromFile(AFile);
    XMLDocument.Active := True;

    Root := XMLDocument.DocumentElement;
    if Root.ChildNodes[0].NodeName = 'Misc' then begin
      SpinDepth.Value := StrToInt(Root.ChildNodes[0].ChildNodes[0].Text);
      SpinChild.Value := StrToInt(Root.ChildNodes[0].ChildNodes[1].Text);
      SpinData.Value := StrToInt(Root.ChildNodes[0].ChildNodes[2].Text);
    end;

  except
    SpinDepth.Value := 3;
    SpinChild.Value := 15;
    SpinData.Value := 512;
  end;
end;

end.
