unit DBGp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls,
  XMLDoc, XMLDOM, XMLIntf, ActiveX, Vcl.ExtCtrls, Vcl.ComCtrls, Base64,
  Buttons, OverbyteIcsWndControl, OverbyteIcsWSocket, DBGpConfig;

type
  //TBreakPointType = (btLine, btCall, btReturn, btException, btConditional, btWatch);
  TBreakPoint = record
    Id: string;
    BreakPointType: string;
    FileName: string;
    LineNo: Integer;
    State: Boolean;
    FunctionName: string;
    Temporary: Boolean;
    Resolved: Integer;
    HitCount: Integer;
    HitValue: Integer;
    HitCondition: string;
    Exception: string;
    Expression: string;
  end;

  TWatch = record
    FileName: string;
    WatchName: string;
  end;

  TBreakPointList = array of TBreakPoint;
  TWatchList = array of TWatch;

  TDBGpServer = class(TWSocket)
  private
    FTransID: Integer;
    FEndInit: string;
    FEndResponse: string;
    FActivDoc: Integer;
    FTryConnCount: Integer;
    FTryRecvCount: Integer;
    FBreakPointList: TBreakPointList;
    FWatchList: TWatchList;
    FDebugPaintBox: TPaintBox;
    FLocalView: TTreeView;
    FGlobalView: TTreeView;
    FBPGrid: TStringGrid;
    FListenBtn: TToolButton;
    FRunNextBtn: TToolButton;
    FRunToCursorBtn: TToolButton;
    FTraceIntoBtn: TToolButton;
    FStepOverBtn: TToolButton;
    FStepOutBtn: TToolButton;
    FTimer: TTimer;
    FWaitTimeout: Integer;
    FDebFirstLine: Boolean;
    procedure SessionAvailable(Sender: TObject; Error: Word);
    procedure ClientDataAvailable(Sender : TObject; Error : Word);
    procedure ClientSessionClosed(Sender: TObject; Error: Word);
    function IsInteger(Str: string): Boolean;
    procedure ParseRecv(RecvText: string);
    procedure ParseContext(Tree: TTreeView; Xml: IXMLDocument);
    procedure ParseBreakPointList(Xml: IXMLDocument);
    procedure ParseStack(Xml: IXMLDocument);
    procedure ParseProperty(Xml: IXMLDocument);
    procedure ParseEval(Xml: IXMLDocument);
    procedure RunBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure RunNextBtnClick(Sender: TObject);
    procedure RunToCursorBtnClick(Sender: TObject);
    procedure TraceIntoBtnClick(Sender: TObject);
    procedure StepOverBtnClick(Sender: TObject);
    procedure StepOutBtnClick(Sender: TObject);
    procedure ProcTimer(Sender: TObject);
  public
    procedure InitInterface(DebPaintBox: TPaintBox;
      GlobalView, LocalView: TTreeView; BPGrid: TStringGrid);
    procedure SetButtons(ListenBtn, RunNextBtn, RunToCursorBtn, TraceIntoBtn, StepOverBtn,
      StepOutBtn: TToolButton);
    procedure Run(BindIP: string; BindPort: Integer);
    procedure Stop;
    function UriToFile(URI: string): string;
    procedure SendCommand(Cmd: string; Tail: String);
    procedure CloseConnection(ConnID: Integer);
    procedure BreakPointSet(Line: Integer);
    procedure UpdateTabs;
    procedure AddWatch(FileName, WatchName: string);
    procedure AddEval(FileName, EvalName: string);
    procedure DeleteWatch(Index: Integer);
    procedure UpdateWatches;
    procedure SendMisc;
    property ActivDoc: Integer read FActivDoc write FActivDoc;
    property BreakPointList: TBreakPointList read FBreakPointList;
    property DebFirstLine: Boolean read FDebFirstLine write FDebFirstLine;
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  end;

  TDBGpWSocket = class(TWSocket)
  private
    Status: string;
    StartSession: Boolean;
    TotalStr: string;
    FileUri: string;
    MainUri: string;
    Language: string;
    ProtocolVer: string;
    Appid: string;
    IdeKey: string;
    EngineVer: string;
    CurLine: Integer;
    BreakPointList: TBreakPointList;
    DocID: Integer;
    Data: Pointer;
    CommandQueue: TStringList;
    Ready: Boolean;
    Idle: Integer;
  public
    RecvAr: array of AnsiChar;
    L: Integer;
  end;

var
  DBGpClients: TList;

implementation

uses Main, AddEval, EvalView;

function CustomTreeSortProc(Node1, Node2: TTreeNode; Data: Longint): Integer; stdcall;
var
  val: Integer;
begin
  val := AnsiStrIComp(PChar(Node1.Text), PChar(Node2.Text));
  Exit(val);
end;


constructor TDBGpServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DBGpClients := TList.Create;
  FEndInit := '</init>';
  FEndResponse := '</response>';
  FTransID := 1;
  FActivDoc := -1;
  OnSessionAvailable := SessionAvailable;
  FTimer := TTimer.Create(nil);
  FTimer.Enabled := True;
  FTimer.Interval := 10;
  FTimer.OnTimer := ProcTimer;
  FWaitTimeout := 1000;
end;

destructor TDBGpServer.Destroy;
begin
  FTimer.Free;
  Stop;

  if Assigned(DBGpClients) then begin
    DBGpClients.Destroy;
    DBGpClients := nil;
  end;

  inherited Destroy;
end;

procedure TDBGpServer.InitInterface(DebPaintBox: TPaintBox;
  GlobalView, LocalView: TTreeView; BPGrid: TStringGrid);
begin
  FDebugPaintBox := DebPaintBox;
  FGlobalView := GlobalView;
  FLocalView := LocalView;
  FBPGrid := BPGrid;
end;

procedure TDBGpServer.SetButtons(ListenBtn, RunNextBtn, RunToCursorBtn, TraceIntoBtn, StepOverBtn,
  StepOutBtn: TToolButton);
begin
  FListenBtn := ListenBtn;
  FRunNextBtn := RunNextBtn;
  FRunToCursorBtn := RunToCursorBtn;
  FTraceIntoBtn := TraceIntoBtn;
  FStepOverBtn := StepOverBtn;
  FStepOutBtn := StepOutBtn;
  FRunToCursorBtn := RunToCursorBtn;
  FListenBtn.OnClick := RunBtnClick;
  FRunNextBtn.OnClick := RunNextBtnClick;
  FRunToCursorBtn.OnClick := RunToCursorBtnClick;
  FTraceIntoBtn.OnClick := TraceIntoBtnClick;
  FStepOverBtn.OnClick := StepOverBtnClick;
  FStepOutBtn.OnClick := StepOutBtnClick;
end;

procedure TDBGpServer.Run(BindIP: string; BindPort: Integer);
begin
  Addr := '0.0.0.0';
  Port := IntToStr(BindPort);
  Proto := 'tcp';
  Listen;

  FTryConnCount := 0;
  FTryRecvCount := 0;
end;

procedure TDBGpServer.Stop;
var
  i: Integer;
begin
  for i := 0 to Length(Docs) - 1 do begin
    if Docs[i] <> nil then begin
      Docs[i].DebugCurLine := -1;
      Docs[i].ClearBreakPoints;
      Docs[i].Repaint;
    end;
  end;
  FListenBtn.ImageIndex := 0;
  MainFormPND.DebugInfoPanel.Caption := '';
  MainFormPND.GlobalTreeView.Items.Clear;
  MainFormPND.LocalTreeView.Items.Clear;
  MainFormPND.WatchesView.Clear;
  MainFormPND.StackView.Clear;
  MainFormPND.BreakPointsView.Clear;

  FActivDoc := -1;
  FTryConnCount := 0;
  FTryRecvCount := 0;

  for i := DBGpClients.Count - 1 downto 0 do begin
    TDBGpWSocket(DBGpClients.Items[i]).CommandQueue.Clear;
    TDBGpWSocket(DBGpClients.Items[i]).Close;
  end;

  Close;
end;

procedure TDBGpServer.SessionAvailable(Sender: TObject; Error: Word);
var
  NewClient : TDBGpWSocket;
begin
  NewClient := TDBGpWSocket.Create(nil);
  DBGpClients.Add(NewClient);
  FActivDoc := DBGpClients.Count - 1;
  NewClient.LineMode := False;
  NewClient.OnDataAvailable := ClientDataAvailable;
  NewClient.OnSessionClosed := ClientSessionClosed;
  NewClient.HSocket := Self.Accept;
  NewClient.CommandQueue := TStringList.Create;
end;

procedure TDBGpServer.ClientDataAvailable(Sender : TObject; Error : Word);
var
  Buf: array [0..127] of AnsiChar;
  Len: Integer;
  i, PredL, StrFrom:  Integer;
  InitStrTerm: String;
  RespStrTerm: String;
  ResponseData: String;
begin
  Len := TDBGpWSocket(Sender).Receive(@Buf, Sizeof(Buf) - 1);
  if Len <= 0 then Exit;

  PredL := TDBGpWSocket(Sender).L;
  TDBGpWSocket(Sender).L := Length(TDBGpWSocket(Sender).RecvAr) + Len;
  SetLength(TDBGpWSocket(Sender).RecvAr, TDBGpWSocket(Sender).L);

  for i := 0 to Len - 1 do
    TDBGpWSocket(Sender).RecvAr[i + PredL] := Buf[i];

  SetString(InitStrTerm, PAnsiChar(@TDBGpWSocket(Sender).RecvAr[TDBGpWSocket(Sender).L - Length(FEndInit) - 1]), Length(FEndInit));
  SetString(RespStrTerm, PAnsiChar(@TDBGpWSocket(Sender).RecvAr[TDBGpWSocket(Sender).L - Length(FEndResponse) - 1]), Length(FEndResponse));
  if (InitStrTerm = FEndInit) or (RespStrTerm = FEndResponse) then begin
    for i := 0 to TDBGpWSocket(Sender).L - 1 do begin
      if TDBGpWSocket(Sender).RecvAr[i] = #0 then begin
        {[0,i-1] - size of Recv String}
        StrFrom := i + 1;
        Break;
      end;
    end;
    SetString(ResponseData, PAnsiChar(@TDBGpWSocket(Sender).RecvAr[StrFrom]), TDBGpWSocket(Sender).L - StrFrom);
    ParseRecv(ResponseData);
    //MainFormPND.ConsoleMemo.Lines.Add(ResponseData);
    SetLength(TDBGpWSocket(Sender).RecvAr, 0);
    TDBGpWSocket(Sender).L := 0;
    TDBGpWSocket(Sender).Ready := True;
  end;
end;

procedure TDBGpServer.ClientSessionClosed(Sender: TObject; Error: Word);
var
  Sock: TDBGpWSocket;
  Itm: Integer;
begin
  Sock := Sender as TDBGpWSocket;
  Sock.CommandQueue.Free;

  Itm := DBGpClients.IndexOf(Sock);

  if Itm >= 0 then
    DBGpClients.Delete(Itm);

  PostMessage(MainFormPND.Handle, WM_USER+7, 0, LongInt(Sock));
end;

function TDBGpServer.UriToFile(URI: String): String;
begin
  Result := '';
  if (Copy(URI, 1, 8) = 'file:///') and (Length(URI) > 9) and (URI[10] = ':') then begin
    URI := Copy(URI, 9, MaxInt);
    Result := StringReplace(URI, '/', '\', [rfReplaceAll]);
  end;
end;

procedure TDBGpServer.SendCommand(Cmd: string; Tail: String);
begin
  if (FActivDoc <> -1) and (DBGpClients.Count <> 0) then begin
    if Tail = '' then begin
      TDBGpWSocket(DBGpClients.Items[FActivDoc]).CommandQueue.Add(Cmd  + ' -i 1' + #0);
    end
    else begin
      TDBGpWSocket(DBGpClients.Items[FActivDoc]).CommandQueue.Add(Cmd  + ' -i 1' + Tail + #0);
    end;
  end;
end;

procedure TDBGpServer.CloseConnection(ConnID: Integer);
var
  i,j: Integer;
  Sock: TDBGpWSocket;
  Flag: Boolean;
begin
  if (ConnID > -1) and (ConnID < DBGpClients.Count) then begin
    Sock := TDBGpWSocket(DBGpClients.Items[ConnID]);
    Sock.Close;
    {REIndex Tab and Conn}
    for i := 0 to DBGpClients.Count - 1 do begin
      Sock := TDBGpWSocket(DBGpClients.Items[i]);
      Flag := False;
      for j := 0 to Length(Docs) - 1 do begin
        if Docs[j] <> nil then begin
          if UriToFile(Sock.FileUri) = Docs[j].GetDocPath then begin
            Sock.DocID := j;
            Docs[j].DebugConnectionID := i;
            Flag := True;
            //Break;
          end;
        end;
      end;
      if not Flag then begin
        Sock.DocID := -1;
      end;
    end;


    for j := 0 to Length(Docs) - 1 do begin
      Flag := False;
      for i := 0 to DBGpClients.Count - 1 do begin
        Sock := TDBGpWSocket(DBGpClients.Items[i]);
        if Docs[j] <> nil then begin
          if UriToFile(Sock.FileUri) = Docs[j].GetDocPath then begin
            Flag := True;
            //Break;
          end;
        end;
      end;
      if not Flag then begin
        if Docs[j] <> nil then begin
          Docs[j].DebugConnectionID := -1;
        end;
      end;
    end;
  end;
end;

function TDBGpServer.IsInteger(Str: string): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 1 to Length(Str) do begin
    if not (Str[i] in ['0'..'9']) then begin
      Result := False;
      Break;
    end;
  end;
end;

procedure TDBGpServer.ParseRecv(RecvText: string);
var
  AWSocket: TDBGpWSocket;
  Xml: IXMLDocument;
  Command: string;
  DebugFileName: string;
  ValidXML: Boolean;
  i,j: Integer;
  DocExists: Boolean;
  CurLine, Line: Integer;
  ActivDocNo: Integer;
  Err: string;
  flag: Boolean;
begin
  try
    CoInitialize(nil);
    Xml := TXMLDocument.Create(Application);
    Xml.Options := [];
    Xml.XML.Add(RecvText);
    Xml.Active := true;
    ValidXML := True;
  except
    ValidXML := False;
  end;

  AWSocket := TDBGpWSocket(DBGpClients.Items[FActivDoc]);
  if ValidXML then begin
    AWSocket.Status := '';
    if not AWSocket.StartSession then begin
      AWSocket.Status := '';
      AWSocket.FileUri :=  Xml.ChildNodes[1].Attributes['fileuri'];
      AWSocket.MainUri :=  Xml.ChildNodes[1].Attributes['fileuri'];
      AWSocket.Language :=  Xml.ChildNodes[1].Attributes['language'];
      AWSocket.ProtocolVer :=  Xml.ChildNodes[1].Attributes['protocol_version'];
      AWSocket.Appid:=  Xml.ChildNodes[1].Attributes['appid'];
      AWSocket.IdeKey :=  Xml.ChildNodes[1].Attributes['idekey'];
      AWSocket.EngineVer :=  Xml.ChildNodes[1].ChildNodes[0].Attributes['version'];

      Inc(FTryRecvCount);

      if (FTryConnCount - FTryRecvCount) > 0 then begin
        for i := FTryConnCount - 1 downto FTryRecvCount do begin
          CloseConnection(i);
        end;
        FTryConnCount := FTryRecvCount;
      end;

      for i := DBGpClients.Count - 2 downto 0 do begin
        if TDBGpWSocket(DBGpClients.Items[i]).FileUri = AWSocket.FileUri then begin
          CloseConnection(i);
          Break;
        end;

      end;

      DocExists := False;

      for i := 0 to Length(Docs) - 1 do begin
        if Docs[i] <> nil then begin
          if UriToFile(AWSocket.FileUri) = Docs[i].GetDocPath then begin
            //переход на нужный документ после обновления в браузере.
            TDBGpWSocket(DBGpClients.Items[DBGpClients.Count - 1]).DocID := i;
            Docs[i].DebugConnectionID := DBGpClients.Count - 1;
            Docs[i].DebugCurLine := -1;
            Docs[i].IsMainDebugStack := True;
            FActivDoc := DBGpClients.Count - 1;
            ActivDocNo := i;
            DocExists := True;
            Break;
          end;
        end;
      end;

      if not DocExists then begin
        CloseConnection(DBGpClients.Count - 1);
      end;

      if (DocExists) and (AWSocket.FileUri <> '') and (AWSocket.Language = 'PHP') then begin
        AWSocket.StartSession := True;
        AWSocket.Ready := True;

        SendMisc;

        //поставить точки останова всех док-ментов
        for i := 0 to Length(Docs) - 1 do begin
          if Docs[i] <> nil then begin
            for j := 0 to Length(Docs[i].DebugBreakPointArray) - 1 do begin
             Line := Docs[i].DebugBreakPointArray[j];
             SendCommand('breakpoint_set -t line -f '+ Docs[i].GetDocPath +
             ' -n ' + IntToStr(Line), '');
            end;
          end;
        end;
        {for i := 0 to Length(Docs[ActivDocNo].DebugBreakPointArray) - 1 do begin
         Line := Docs[ActivDocNo].DebugBreakPointArray[i];
         SendCommand('breakpoint_set -t line -f '+ AWSocket.FileUri +
         ' -n ' + IntToStr(Line), '');
        end;}

        if FDebFirstLine then begin
          SendCommand('step_into', '');
        end
        else begin
          SendCommand('run', '');
        end;

        MainFormPND.TabControl.SelectTab(ActivDocNo);
      end;

    end
    else begin
      {FStatus = [starting, stopping, stopped, running, break]}
      Command := Xml.ChildNodes[1].Attributes['command'];
      Err := '';
      if Xml.ChildNodes[1].HasChildNodes then begin
        Err := Xml.ChildNodes[1].ChildNodes[0].Attributes['code'];
        if (Err = '301') and (Command = 'context_get') then begin
          FLocalView.Items.Clear;
        end;
      end;

     if Command = 'status' then begin
        AWSocket.Status  := Xml.ChildNodes[1].Attributes['status'];
        MainFormPND.DebugInfoPanel.Caption := AWSocket.Status;
        Docs[AWSocket.DocID].DebugStatus := AWSocket.Status;
      end
      else if (Command = 'run') or (Command = 'step_into') or (Command = 'step_over') or (Command = 'step_out') then begin
        AWSocket.Status  := Xml.ChildNodes[1].Attributes['status'];
        MainFormPND.DebugInfoPanel.Caption := AWSocket.Status;

        if (AWSocket.Status = 'stopping') or (AWSocket.Status = 'stopped') then begin
          AWSocket.StartSession := False;
          Docs[AWSocket.DocID].DebugCurLine := -1;
          Docs[AWSocket.DocID].Repaint;
        end
        else begin
        //////////////////перескок
          CurLine := StrToInt(Xml.ChildNodes[1].ChildNodes[0].Attributes['lineno']);
          AWSocket.CurLine := CurLine;
          DebugFileName := Xml.ChildNodes[1].ChildNodes[0].Attributes['filename'];

          if (AWSocket.FileUri <> DebugFileName) or
             (Docs[MainFormPND.ActivDocID].GetDocPath <> UriToFile(DebugFileName)) then begin
            AWSocket.FileUri := DebugFileName;

            flag := False;
            for i := 0 to Length(Docs) - 1 do begin
              if Docs[i] <> nil then begin
                if Docs[i].GetDocPath = UriToFile(AWSocket.FileUri) then begin
                  flag := True;
                  MainFormPND.TabControl.SelectTab(Docs[i].ID);
                  Break;
                end;
              end;
            end;
            if not flag then
              MainFormPND.LoadDocFromFile(UriToFile(AWSocket.FileUri));

            MainFormPND.TabControl.Refresh;

            for i := 0 to Length(Docs) - 1 do begin
              if Docs[i] <> nil then begin
                if UriToFile(AWSocket.FileUri) = Docs[i].GetDocPath then begin
                  //переход на нужный документ после include.
                  TDBGpWSocket(DBGpClients.Items[FActivDoc]).DocID := i;
                  Docs[i].DebugConnectionID := DBGpClients.IndexOf(AWSocket);
                  Docs[i].DebugCurLine := -1;
                  FActivDoc := DBGpClients.IndexOf(AWSocket);
                  ActivDocNo := i;
                  Break;
                end;
              end;
            end;

          end;

          Docs[AWSocket.DocID].DebugCurLine := CurLine;
          Docs[AWSocket.DocID].SetCursor(1, CurLine-1);
          Docs[AWSocket.DocID].AlignWindowIfCursorHide;
          Docs[AWSocket.DocID].ValignWindowIfCursorHide;
          Docs[AWSocket.DocID].DebugStatus := AWSocket.Status;
        end;
        /////////////////
        Docs[AWSocket.DocID].DebugBox.Repaint;
        Docs[AWSocket.DocID].Repaint;
      end
      else if Command = 'context_get' then begin
        if Xml.ChildNodes[1].Attributes['context'] = '0' then begin
          ParseContext(FLocalView, Xml);
          FLocalView.SortType := stText;
        end
        else if Xml.ChildNodes[1].Attributes['context'] = '1' then begin
          ParseContext(FGlobalView, Xml);
          FLocalView.SortType := stText;
        end;
      end
      else if Command = 'breakpoint_set' then begin

      end
      else if Command = 'breakpoint_list' then begin
        ParseBreakPointList(Xml);
      end
      else if Command = 'stack_get' then begin
        ParseStack(Xml);
      end
      else if Command = 'property_get' then begin
        ParseProperty(Xml);
      end
      else if Command = 'eval' then begin
        ParseEval(Xml);
      end;
    end;
  end;

  if (Xml <> nil) then Xml.Active := False;
  Xml := nil;
end;

procedure TDBGpServer.ParseContext(Tree: TTreeView; Xml: IXMLDocument);
var
  Command: string;
  NItem: string;
  NType: string;
  NValue: string;
  ValidXML: Boolean;
  i: Integer;

  procedure IterateNodes(Xn: IXMLNode; ParentNode: TTreeNode);
  var
    ChildTreeNode: TTreeNode;
    i,j: Integer;
    FindFlag: Boolean;
  begin
    for i := 0 to Xn.ChildNodes.Count - 1 do begin
      NType :=  Xn.ChildNodes[i].Attributes['type'];

      if (NType <> '') then begin
        if (NType <> 'array') then begin

          if Xn.ChildNodes[i].Attributes['encoding'] = 'base64' then begin
            NValue := Decode64(Xn.ChildNodes[i].Text);
          end
          else begin
            NValue := Xn.ChildNodes[i].Text;
          end;

          NItem := Xn.ChildNodes[i].Attributes['name'] + ' = ' + NValue;
          FindFlag := False;

          if (ParentNode <> nil) then begin
            for j := 0 to ParentNode.Count - 1 do begin
              if (ParentNode.Item[j].Text = NItem) then begin
                ChildTreeNode := ParentNode.Item[j];
                FindFlag := True;
                Break;
              end;
            end;
          end
          else begin
            for j := 0 to Tree.Items.Count - 1 do begin
              if (Tree.Items.Item[j].Level = 0) and (Tree.Items.Item[j].Text = NItem) then begin
                ChildTreeNode := Tree.Items.Item[j];
                FindFlag := True;
                Break;
              end;
            end;
          end;

          if (not FindFlag) then begin
            ChildTreeNode := Tree.Items.AddChild(ParentNode, NItem);
          end;

          ChildTreeNode.Data := TObject(1);
        end
        else begin
          NItem :=  Xn.ChildNodes[i].Attributes['name'] + ' = {array} [' + IntToStr(Xn.ChildNodes[i].ChildNodes.Count) + ']';
          FindFlag := False;

          if (ParentNode <> nil) then begin
            for j := 0 to ParentNode.Count - 1 do begin
              if (ParentNode.Item[j].Text = NItem) then begin
                ChildTreeNode := ParentNode.Item[j];
                FindFlag := True;
                Break;
              end;
            end;
          end
          else begin
            for j := 0 to Tree.Items.Count - 1 do begin
              if (Tree.Items.Item[j].Level = 0) and (Tree.Items.Item[j].Text = NItem) then begin
                ChildTreeNode := Tree.Items.Item[j];
                FindFlag := True;
                Break;
              end;
            end;
          end;

          if (not FindFlag) then begin
            ChildTreeNode := Tree.Items.AddChild(ParentNode, NItem);
          end;

          ChildTreeNode.Data := TObject(1);
        end;

        IterateNodes(Xn.ChildNodes[i], ChildTreeNode);
      end;
    end;
  end;

begin
  try
    Tree.Items.BeginUpdate;

    for i := 0 to Tree.Items.Count - 1 do begin
      Tree.Items.Item[i].Data := TObject(0);
    end;

    IterateNodes(Xml.DocumentElement, nil);

    for i := Tree.Items.Count - 1 downto 0 do begin
      if (Integer(Tree.Items.Item[i].Data) = 0) then begin
        Tree.Items.Item[i].Delete;
      end;
    end;

    Tree.Items.CustomSort(@CustomTreeSortProc, 0);
    Tree.Items.EndUpdate;
  finally
  end;
end;

procedure TDBGpServer.ParseBreakPointList(Xml: IXMLDocument);
var
  Len, i: Integer;
  AWSocket: TDBGpWSocket;
  Item: TListItem;
begin
  AWSocket := TDBGpWSocket(DBGpClients.Items[FActivDoc]);
  Len := Xml.ChildNodes[1].ChildNodes.Count;
  SetLength(AWSocket.BreakPointList, Len);

  for i := 0 to Len - 1 do begin
    AWSocket.BreakPointList[i].Id := Xml.ChildNodes[1].ChildNodes[i].Attributes['id'];
    AWSocket.BreakPointList[i].BreakPointType := Xml.ChildNodes[1].ChildNodes[i].Attributes['type'];
    AWSocket.BreakPointList[i].FileName := Xml.ChildNodes[1].ChildNodes[i].Attributes['filename'];
    try
      AWSocket.BreakPointList[i].LineNo := StrToInt(Xml.ChildNodes[1].ChildNodes[i].Attributes['lineno']);
    except on EConvertError do
      AWSocket.BreakPointList[i].LineNo := 0;
    end;
    AWSocket.BreakPointList[i].State := (Xml.ChildNodes[1].ChildNodes[i].Attributes['state'] <> 'disabled');
    AWSocket.BreakPointList[i].FunctionName := Xml.ChildNodes[1].ChildNodes[i].Attributes['function'];
    AWSocket.BreakPointList[i].Temporary := (Xml.ChildNodes[1].ChildNodes[i].Attributes['state'] = 'temporary');
    try
      AWSocket.BreakPointList[i].HitCount := StrToInt(Xml.ChildNodes[1].ChildNodes[i].Attributes['hit_count']);
    except on EConvertError do
      AWSocket.BreakPointList[i].HitCount := 0;
    end;
    try
      AWSocket.BreakPointList[i].HitValue := StrToInt(Xml.ChildNodes[1].ChildNodes[i].Attributes['hit_value']);
    except on EConvertError do
      AWSocket.BreakPointList[i].HitValue := 0;
    end;
    AWSocket.BreakPointList[i].HitCondition := Xml.ChildNodes[1].ChildNodes[i].Attributes['hit_condition'];
    if (AWSocket.BreakPointList[i].HitCondition = '') then
      AWSocket.BreakPointList[i].HitCondition := '>=';
    AWSocket.BreakPointList[i].Exception := Xml.ChildNodes[1].ChildNodes[i].Attributes['exception'];

    if (Xml.ChildNodes[1].ChildNodes[i].HasChildNodes) then begin
      if (Xml.ChildNodes[1].ChildNodes[i].ChildNodes[0].NodeName = 'expression') then begin
        try
          AWSocket.BreakPointList[i].Expression := Xml.ChildNodes[1].ChildNodes[i].ChildNodes[0].ChildNodes[0].Text;
        except
          AWSocket.BreakPointList[i].Expression := '';
        end;
      end;
    end;
  end;

  MainFormPND.BreakPointsView.Items.Clear;

  for i := 1 to Len do begin
    Item := MainFormPND.BreakPointsView.Items.Add;
    Item.Caption := AWSocket.BreakPointList[i-1].BreakPointType;
    Item.SubItems.Add(IntToStr(AWSocket.BreakPointList[i-1].LineNo));
    Item.SubItems.Add(IntToStr(AWSocket.BreakPointList[i-1].HitCount));
   // FBreakPointList[i-1].LineNo := AWSocket.BreakPointList[i-1].LineNo;
  end;
end;

procedure TDBGpServer.ParseStack(Xml: IXMLDocument);
var
  Len, i: Integer;
  Item: TListItem;
begin
  Len := Xml.ChildNodes[1].ChildNodes.Count;
  MainFormPND.StackView.Items.Clear;

  for i := 0 to Len - 1 do begin
    Item := MainFormPND.StackView.Items.Add;
    Item.Caption := Xml.ChildNodes[1].ChildNodes[i].Attributes['level'];
    Item.SubItems.Add(Xml.ChildNodes[1].ChildNodes[i].Attributes['filename']);
    Item.SubItems.Add(Xml.ChildNodes[1].ChildNodes[i].Attributes['lineno']);
    Item.SubItems.Add(Xml.ChildNodes[1].ChildNodes[i].Attributes['where']);
    Item.SubItems.Add(Xml.ChildNodes[1].ChildNodes[i].Attributes['type']);
  end;
end;

procedure TDBGpServer.ParseProperty(Xml: IXMLDocument);
var
  i,j: Integer;
  Item: TListItem;
  AWSocket: TDBGpWSocket;
  WName: string;
  WValue: string;
  WType: string;
begin
  AWSocket := TDBGpWSocket(DBGpClients.Items[FActivDoc]);
  for i := 0 to Length(FWatchList) - 1 do begin
    if (UriToFile(AWSocket.FileUri) = FWatchList[i].FileName) then begin
      WName := Xml.ChildNodes[1].ChildNodes[0].Attributes['name'];
      if (FWatchList[i].WatchName = WName) then begin
        if (Xml.ChildNodes[1].ChildNodes[0].Attributes['encoding'] = 'base64') then begin
          WValue := Decode64(Xml.ChildNodes[1].ChildNodes[0].Text);
        end
        else begin
          WValue := Xml.ChildNodes[1].ChildNodes[0].Text;
        end;
        WType := Xml.ChildNodes[1].ChildNodes[0].Attributes['type'];
        for j := 0 to MainFormPND.WatchesView.Items.Count - 1  do begin
          Item := MainFormPND.WatchesView.Items[j];
          if (Item.Caption = WName) then begin
            Item.SubItems.Add(WValue);
            Item.SubItems.Add(WType);
          end;
        end;
      end;
    end;
  end;
end;

procedure TDBGpServer.ParseEval(Xml: IXMLDocument);
var
  WName: string;
  WValue: string;
  WType: string;
  Item: TListItem;
begin
  WName := AddEvalForm.EvalEdit.Text;

  if (Xml.ChildNodes[1].ChildNodes[0].Attributes['encoding'] = 'base64') then begin
    WValue := Decode64(Xml.ChildNodes[1].ChildNodes[0].Text);
  end
  else begin
    WValue := Xml.ChildNodes[1].ChildNodes[0].Text;
  end;

  WType := Xml.ChildNodes[1].ChildNodes[0].Attributes['type'];

  EvalViewForm.EvalListView.Clear;
  Item := EvalViewForm.EvalListView.Items.Add;
  Item.Caption := WName;
  Item.SubItems.Add(WValue);
  Item.SubItems.Add(WType);

  EvalViewForm.ShowModal;
end;

procedure TDBGpServer.BreakPointSet(Line: Integer);
var
  BpType: string;
  AWSocket: TDBGpWSocket;
  i: Integer;
  FindFlag: Boolean;
  ID: string;
begin
  if (FActivDoc <> -1) and (DBGpClients.Count <> 0) then begin
    AWSocket:= TDBGpWSocket(DBGpClients.Items[FActivDoc]);
    if (AWSocket.Ready) then begin

      BpType := 'line';
      AWSocket := TDBGpWSocket(DBGpClients.Items[FActivDoc]);

      FindFlag := False;
      for i := 0 to Length(AWSocket.BreakPointList) - 1 do begin
        if AWSocket.BreakPointList[i].LineNo = Line then begin
          ID := AWSocket.BreakPointList[i].Id;
          FindFlag := True;
          Break;
        end;
      end;

      if FindFlag then begin
        SendCommand('breakpoint_remove -d ' + ID, '');
      end
      else begin
        SendCommand('breakpoint_set -t ' + BpType + ' -f '+ AWSocket.FileUri +
        ' -n ' + IntToStr(Line), '');
      end;

      SendCommand('breakpoint_list', '');
    end;
  end;
end;

procedure TDBGpServer.RunBtnClick(Sender: TObject);
begin
  if TToolButton(Sender).ImageIndex = 0 then begin
    Run('127.0.0.1', 9000);
    TToolButton(Sender).ImageIndex := 1;
    MainFormPND.ItListen.Checked := True;
  end
  else begin
    Stop;
    TToolButton(Sender).ImageIndex := 0;
    MainFormPND.ItListen.Checked := False;
  end;
end;

procedure TDBGpServer.StopBtnClick(Sender: TObject);
begin

end;

procedure TDBGpServer.RunNextBtnClick(Sender: TObject);
begin
  if (FActivDoc <> -1) and (DBGpClients.Count <> 0) then begin
    SendCommand('run', '');
    SendCommand('context_get -c 1', '');
    SendCommand('context_get -c 0', '');
    SendCommand('breakpoint_list', '');
    SendCommand('stack_get', '');
    UpdateWatches;
    Docs[MainFormPND.ActivDocID].Repaint;
  end;
end;

procedure TDBGpServer.TraceIntoBtnClick(Sender: TObject);
begin
  if (FActivDoc <> -1) and (DBGpClients.Count <> 0) then begin
    SendCommand('step_into', '');
    SendCommand('context_get -c 1', '');
    SendCommand('context_get -c 0', '');
    SendCommand('breakpoint_list', '');
    SendCommand('stack_get', '');
    UpdateWatches;
    Docs[MainFormPND.ActivDocID].Repaint;
  end;
end;

procedure TDBGpServer.StepOverBtnClick(Sender: TObject);
begin
  if (FActivDoc <> -1) and (DBGpClients.Count <> 0) then begin
    SendCommand('step_over', '');
    SendCommand('context_get -c 1', '');
    SendCommand('context_get -c 0', '');
    SendCommand('breakpoint_list', '');
    SendCommand('stack_get', '');
    UpdateWatches;
    Docs[MainFormPND.ActivDocID].Repaint;
  end;
end;

procedure TDBGpServer.StepOutBtnClick(Sender: TObject);
begin
  if (FActivDoc <> -1) and (DBGpClients.Count <> 0) then begin
    SendCommand('step_out', '');
    SendCommand('context_get -c 1', '');
    SendCommand('context_get -c 0', '');
    SendCommand('breakpoint_list', '');
    SendCommand('stack_get', '');
    UpdateWatches;
    Docs[MainFormPND.ActivDocID].Repaint;
  end;
end;

procedure TDBGpServer.RunToCursorBtnClick(Sender: TObject);
var
  AWSocket: TDBGpWSocket;
  i, Line: Integer;
  flag: Boolean;
begin
  if (FActivDoc <> -1) and (DBGpClients.Count <> 0) then begin
    AWSocket := TDBGpWSocket(DBGpClients.Items[FActivDoc]);

    flag := False;
    for i := 0 to Length(Docs[MainFormPND.ActivDocID].DebugBreakPointArray) - 1 do begin
      Line := Docs[MainFormPND.ActivDocID].DebugBreakPointArray[i];
      if (Line = Docs[MainFormPND.ActivDocID].CaretPos.Y + 1) then begin
        flag := True;
        Break;
      end;
    end;

    if (Docs[MainFormPND.ActivDocID].DebugCurLine >= (Docs[MainFormPND.ActivDocID].CaretPos.Y + 1)) then begin
      flag := True;
    end;

    if (not flag) then begin
      SendCommand('breakpoint_set -t line -f '+ AWSocket.FileUri +
        ' -n ' +  IntToStr(Docs[MainFormPND.ActivDocID].CaretPos.Y + 1) +
        ' -r 1', '');
      Docs[MainFormPND.ActivDocID].AddBreakPointToList(Docs[MainFormPND.ActivDocID].CaretPos.Y + 1);
    end;

    SendCommand('run', '');
    SendCommand('context_get -c 1', '');
    SendCommand('context_get -c 0', '');
    SendCommand('breakpoint_list', '');
    SendCommand('stack_get', '');
    UpdateWatches;
    Docs[MainFormPND.ActivDocID].Repaint;
  end;
end;

procedure TDBGpServer.UpdateTabs;
begin
  if (FActivDoc <> -1) and (DBGpClients.Count <> 0) then begin
    SendCommand('context_get -c 1', '');
    SendCommand('context_get -c 0', '');
    SendCommand('breakpoint_list', '');
    SendCommand('stack_get', '');
    UpdateWatches;
    Docs[MainFormPND.ActivDocID].Repaint;
  end;
end;

procedure TDBGpServer.ProcTimer(Sender: TObject);
var
  Sock: TDBGpWSocket;
begin
  if (FActivDoc = -1) or (DBGpClients.Count = 0) then Exit;

  Sock := TDBGpWSocket(DBGpClients.Items[FActivDoc]);
  if Sock.StartSession then begin
    if Sock.CommandQueue.Count > 0 then begin
      Sock.Idle := Sock.Idle + TTimer(Sender).Interval;
      if (Sock.Ready) or (Sock.Idle > FWaitTimeout) then begin
        Sock.Ready := False;
        Sock.Idle := 0;
        Sock.SendStr(Sock.CommandQueue[0]);
        //MainFormPND.Memo1.Lines.Add(Sock.CommandQueue[0]);
        Sock.CommandQueue.Delete(0);
      end;
    end;
  end;
end;

procedure TDBGpServer.UpdateWatches;
var
  i: Integer;
  Item: TListItem;
begin
  MainFormPND.WatchesView.Items.Clear;
  for i := 0 to Length(FWatchList) - 1 do begin
    if (FWatchList[i].FileName = Docs[MainFormPND.ActivDocID].GetDocPath) then begin
      Item := MainFormPND.WatchesView.Items.Add;
      Item.Caption := FWatchList[i].WatchName;

      SendCommand('property_get -n ' + FWatchList[i].WatchName, '');
    end;
  end;
end;

procedure TDBGpServer.AddWatch(FileName, WatchName: string);
var
  i: Integer;
  flag: Boolean;
  Item: TListItem;
begin
  flag := False;
  for i := 0 to Length(FWatchList) - 1 do begin
    if (FWatchList[i].FileName = FileName) and (FWatchList[i].WatchName = WatchName) then begin
      flag := True;
      Break;
    end;
  end;

  if not flag then begin
    SetLength(FWatchList, Length(FWatchList) + 1);
    FWatchList[Length(FWatchList) - 1].FileName := FileName;
    FWatchList[Length(FWatchList) - 1].WatchName := WatchName;

    MainFormPND.WatchesView.Items.Clear;

    for i := 0 to Length(FWatchList) - 1 do begin
      if (FWatchList[i].FileName = Docs[MainFormPND.ActivDocID].GetDocPath) then begin
        Item := MainFormPND.WatchesView.Items.Add;
        Item.Caption := FWatchList[i].WatchName;
      end;
    end;
  end;

  if FActivDoc <> -1 then begin
    UpdateWatches;
  end;
end;

procedure TDBGpServer.AddEval(FileName, EvalName: string);
begin
  SendCommand('eval', ' -- ' + Encode64(EvalName));
end;

procedure TDBGpServer.DeleteWatch(Index: Integer);
var
  i: Integer;
begin
  for i := Index to Length(FWatchList) - 2 do begin
    FWatchList[i].FileName := FWatchList[i+1].FileName;
    FWatchList[i].WatchName := FWatchList[i+1].WatchName;
  end;
  SetLength(FWatchList, Length(FWatchList) - 1);
end;

procedure TDBGpServer.SendMisc;
var
  i: Integer;
begin
  SendCommand('feature_set -n max_depth -v ' + DBGpConfigForm.SpinDepth.Text, '');
  SendCommand('feature_set -n max_children -v ' + DBGpConfigForm.SpinChild.Text, '');
  SendCommand('feature_set -n max_data -v ' + DBGpConfigForm.SpinData.Text, '');
end;

end.
