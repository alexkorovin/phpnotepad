unit ShortHelp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TShortHelpForm = class(TForm)
    Memo: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ShortHelpForm: TShortHelpForm;

implementation

{$R *.dfm}

end.
