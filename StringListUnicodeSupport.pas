unit StringListUnicodeSupport;

interface

uses
  SysUtils,
  Classes,
  Encoding;

type
  TStringList = class(Classes.TStringList)
  public
    EncodingStr: String;
    CodePage: Cardinal;
    procedure LoadFromFile(const FileName: string); overload; override;
    procedure LoadFromFile(const FileName: string; Encoding: TEncoding); reintroduce; overload; virtual;
    procedure LoadFromStream(Stream: TStream); overload; override;
    procedure LoadFromStream(Stream: TStream; Encoding: TEncoding); reintroduce; overload; virtual;
    procedure SaveToFile(const FileName: string); overload; override;
    procedure SaveToFile(const FileName: string; Encoding: TEncoding); reintroduce; overload; virtual;
    procedure SaveToStream(Stream: TStream); overload; override;
    procedure SaveToStream(Stream: TStream; Encoding: TEncoding); reintroduce; overload; virtual;
  end;

implementation

uses Main;
{ TStringList }

procedure TStringList.LoadFromFile(const FileName: string);
begin
  LoadFromFile(FileName, nil);
end;

procedure TStringList.LoadFromFile(const FileName: string; Encoding: TEncoding);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream, Encoding);
  finally
    Stream.Free;
  end;
end;

procedure TStringList.LoadFromStream(Stream: TStream);
begin
  LoadFromStream(Stream, nil);
end;

procedure TStringList.LoadFromStream(Stream: TStream; Encoding: TEncoding);
var
  Size: Integer;
  Buffer: TBytes;
  CName: String;
begin
  BeginUpdate;
  try
    Size := Stream.Size - Stream.Position;
    SetLength(Buffer, Size);
    Stream.Read(Buffer[0], Size);

    Size := TEncoding.GetBufferEncoding(Buffer, Encoding);
    SetTextStr(Encoding.GetString(Buffer, Size, Length(Buffer) - Size));

    CName := Encoding.ClassName;
    CodePage := 0;

    if CName = 'TMBCSEncoding' then begin
      CodePage := TMBCSEncoding(Encoding).GetCodePage;
      EncodingStr := 'ANSI';
    end
    else if CName = 'TUTF8Encoding' then
      EncodingStr := 'UTF-8 BOM'
    else if CName = 'TUnicodeEncoding' then
      EncodingStr := 'UCS-2 LE'
    else if CName = 'TBigEndianUnicodeEncoding' then
      EncodingStr := 'UCS-2 BE';

  finally
    EndUpdate;
  end;
end;

procedure TStringList.SaveToFile(const FileName: string);
begin
  SaveToFile(FileName, nil);
end;

procedure TStringList.SaveToFile(const FileName: string; Encoding: TEncoding);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream, Encoding);
  finally
    Stream.Free;
  end;
end;

procedure TStringList.SaveToStream(Stream: TStream);
begin
  SaveToStream(Stream, nil);
end;

procedure TStringList.SaveToStream(Stream: TStream; Encoding: TEncoding);
var
  Buffer, Preamble: TBytes;
begin
  if Encoding = nil then
    Encoding := TEncoding.Default;
  Buffer := Encoding.GetBytes(GetTextStr);
  Preamble := Encoding.GetPreamble;
  if Length(Preamble) > 0 then
    Stream.WriteBuffer(Preamble[0], Length(Preamble));
  Stream.WriteBuffer(Buffer[0], Length(Buffer));
end;

end.
