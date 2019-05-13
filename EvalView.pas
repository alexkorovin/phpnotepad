unit EvalView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls;

type
  TEvalViewForm = class(TForm)
    EvalListView: TListView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EvalViewForm: TEvalViewForm;

implementation

{$R *.dfm}

end.
