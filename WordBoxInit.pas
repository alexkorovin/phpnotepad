unit WordBoxInit;

interface

uses
  Classes, XMLDoc, XMLIntf, Forms, SysUtils, StdCtrls, Controls, Windows,
  PHPEdit, Dialogs, Messages, StringListUnicodeSupport;

procedure InitScaner;
procedure LoadStringListFromResource(const ResName: string; SL : TStringList);

var
  PHPReservList: TStringList;
  PHPFuncList: TStringList;
  PHPParamsList: TStringList;
  HtmlTagList: TStringList;
  HtmlAttrList: TStringList;
  HtmlMethodsList: TStringList;
  JSObjectList: TStringList;
  JSMethodsList: TStringList;
  JSPropList: TStringList;
  JSReservList: TStringList;
  CSSAttrList: TStringList;
  CSSValList: TStringList;

implementation

{$R resword.res}

procedure LoadStringListFromResource(const ResName: string; SL: TStringList);
var
  RS: TResourceStream;
begin
  RS := TResourceStream.Create(HInstance, ResName, RT_RCDATA);
  try
    SL.LoadFromStream(RS);
  finally
    RS.Free;
  end;
end;

procedure InitScaner;
var
  XMLDocument: TXMLDocument;
  Root, Child: IXMLNode;
  AFile: String;
  i,j: Integer;
begin
  PHPReservList := TStringList.Create;
  PHPFuncList := TStringList.Create;
  PHPParamsList := TStringList.Create;
  HtmlTagList := TStringList.Create;
  HtmlAttrList := TStringList.Create;
  HtmlMethodsList := TStringList.Create;
  JSObjectList := TStringList.Create;
  JSMethodsList := TStringList.Create;
  JSPropList := TStringList.Create;
  JSReservList := TStringList.Create;
  CSSAttrList := TStringList.Create;
  CSSValList := TStringList.Create;

  LoadStringListFromResource('PHPReserv', PHPReservList);
  LoadStringListFromResource('PHPRarams', PHPParamsList);
  LoadStringListFromResource('PHPFunc', PHPFuncList);
  LoadStringListFromResource('HTMLTag', HtmlTagList);
  LoadStringListFromResource('HTMLAttr', HtmlAttrList);
  LoadStringListFromResource('HTMLMethods', HtmlMethodsList);
  LoadStringListFromResource('JSObj', JSObjectList);
  LoadStringListFromResource('JSMethod', JSMethodsList);
  LoadStringListFromResource('JSProp', JSPropList);
  LoadStringListFromResource('JSReserv', JSReservList);
  LoadStringListFromResource('CSSAttr', CSSAttrList);
  LoadStringListFromResource('CSSVal', CSSValList);


  {PHPReservList.LoadFromFile(ExtractFilePath(Application.ExeName)+'\util\PHPReserv.txt');
  PHPFuncList.LoadFromFile(ExtractFilePath(Application.ExeName)+'\util\PHPFunc.txt');
  HtmlTagList.LoadFromFile(ExtractFilePath(Application.ExeName)+'\util\HTMLTag.txt');
  HtmlAttrList.LoadFromFile(ExtractFilePath(Application.ExeName)+'\util\HTMLAttr.txt');
  HtmlMethodsList.LoadFromFile(ExtractFilePath(Application.ExeName)+'\util\HTMLMethods.txt');
  JSPropList.LoadFromFile(ExtractFilePath(Application.ExeName)+'\util\JSProp.txt');
  JSMethodsList.LoadFromFile(ExtractFilePath(Application.ExeName)+'\util\JSMethod.txt');
  JSObjectList.LoadFromFile(ExtractFilePath(Application.ExeName)+'\util\JSObj.txt');
  JSReservList.LoadFromFile(ExtractFilePath(Application.ExeName)+'\util\JSReserv.txt');
  CSSAttrList.LoadFromFile(ExtractFilePath(Application.ExeName)+'\util\CSSAttr.txt');
  CSSValList.LoadFromFile(ExtractFilePath(Application.ExeName)+'\util\CSSVal.txt'); }

  PHPReservList.Sort;
  PHPFuncList.Sort;
  PHPParamsList.Sort;
  HtmlTagList.Sort;
  HtmlAttrList.Sort;
  HtmlMethodsList.Sort;
  JSPropList.Sort;
  JSMethodsList.Sort;
  JSObjectList.Sort;
  JSReservList.Sort;
  CSSAttrList.Sort;
  CSSValList.Sort;

 { for i := 0 to PHPReservList.Count - 1 do begin
    PHPReservList[i] := Trim(PHPReservList[i]);
  end;
  for i := 0 to PHPFuncList.Count - 1 do begin
    PHPFuncList[i] := Trim(PHPFuncList[i]);
  end;
  for i := 0 to HtmlTagList.Count - 1 do begin
    HtmlTagList[i] := Trim(HtmlTagList[i]);
  end;
  for i := 0 to HtmlAttrList.Count - 1 do begin
    HtmlAttrList[i] := Trim(HtmlAttrList[i]);
  end;
  for i := 0 to HtmlMethodsList.Count - 1 do begin
    HtmlMethodsList[i] := Trim(HtmlMethodsList[i]);
  end;
  for i := 0 to JSPropList.Count - 1 do begin
    JSPropList[i] := Trim(JSPropList[i]);
  end;
  for i := 0 to JSMethodsList.Count - 1 do begin
    JSMethodsList[i] := Trim(JSMethodsList[i]);
  end;
  for i := 0 to JSObjectList.Count - 1 do begin
    JSObjectList[i] := Trim(JSObjectList[i]);
  end;
  for i := 0 to JSReservList.Count - 1 do begin
    JSReservList[i] := Trim(JSReservList[i]);
  end;
  for i := 0 to CSSAttrList.Count - 1 do begin
    CSSAttrList[i] := Trim(CSSAttrList[i]);
  end;
  for i := 0 to CSSValList.Count - 1 do begin
    CSSValList[i] := Trim(CSSValList[i]);
  end;

  PHPReservList.SaveToFile(ExtractFilePath(Application.ExeName)+'\util\PHPReserv.txt');
  PHPFuncList.SaveToFile(ExtractFilePath(Application.ExeName)+'\util\PHPFunc.txt');
  HtmlTagList.SaveToFile(ExtractFilePath(Application.ExeName)+'\util\HTMLTag.txt');
  HtmlAttrList.SaveToFile(ExtractFilePath(Application.ExeName)+'\util\HTMLAttr.txt');
  HtmlMethodsList.SaveToFile(ExtractFilePath(Application.ExeName)+'\util\HTMLMethods.txt');
  JSPropList.SaveToFile(ExtractFilePath(Application.ExeName)+'\util\JSProp.txt');
  JSMethodsList.SaveToFile(ExtractFilePath(Application.ExeName)+'\util\JSMethod.txt');
  JSObjectList.SaveToFile(ExtractFilePath(Application.ExeName)+'\util\JSObj.txt');
  JSReservList.SaveToFile(ExtractFilePath(Application.ExeName)+'\util\JSReserv.txt');
  CSSAttrList.SaveToFile(ExtractFilePath(Application.ExeName)+'\util\CSSAttr.txt');
  CSSValList.SaveToFile(ExtractFilePath(Application.ExeName)+'\util\CSSVal.txt');  }
 { try
    AFile := ExtractFilePath(Application.ExeName)+'\PHPNotepad.xml';
    XMLDocument := TXMLDocument.Create(Application);
    XMLDocument.LoadFromFile(AFile);
    XMLDocument.Active := True;
  except
    Exit;
  end;

  try
    Root := XMLDocument.DocumentElement;
    for i := 0 to Root.ChildNodes.Count - 1 do begin
      if Root.ChildNodes[i].NodeName = 'PHPReserved' then begin
        Child := Root.ChildNodes[i];
        for j := 0 to Child.ChildNodes.Count - 1 do begin
          if Child.ChildNodes[j].NodeName = 'Reserved' then begin
            PHPReservList.Add(Child.ChildNodes[j].Text);
          end;
        end;
      end;
      if Root.ChildNodes[i].NodeName = 'PHPFunction' then begin
        Child := Root.ChildNodes[i];
        for j := 0 to Child.ChildNodes.Count - 1 do begin
          if Child.ChildNodes[j].NodeName = 'Function' then begin
            PHPFuncList.Add(Child.ChildNodes[j].Text);
          end;
        end;
      end;

      if Root.ChildNodes[i].NodeName = 'HTMLTag' then begin
        Child := Root.ChildNodes[i];
        for j := 0 to Child.ChildNodes.Count - 1 do begin
          if Child.ChildNodes[j].NodeName = 'Tag' then begin
            HtmlTagList.Add(Child.ChildNodes[j].Text);
          end;
        end;
      end;

      if Root.ChildNodes[i].NodeName = 'HTMLAttribute' then begin
        Child := Root.ChildNodes[i];
        for j := 0 to Child.ChildNodes.Count - 1 do begin
          if Child.ChildNodes[j].NodeName = 'Attribute' then begin
            HtmlAttrList.Add(Child.ChildNodes[j].Text);
          end;
        end;
      end;

      if Root.ChildNodes[i].NodeName = 'JSReserved' then begin
        Child := Root.ChildNodes[i];
        for j := 0 to Child.ChildNodes.Count - 1 do begin
          if Child.ChildNodes[j].NodeName = 'Reserved' then begin
            JSReservList.Add(Child.ChildNodes[j].Text);
          end;
        end;
      end;

      if Root.ChildNodes[i].NodeName = 'JSObject' then begin
        Child := Root.ChildNodes[i];
        for j := 0 to Child.ChildNodes.Count - 1 do begin
          if Child.ChildNodes[j].NodeName = 'Object' then begin
            JSObjectList.Add(Child.ChildNodes[j].Text);
          end;
        end;
      end;

      if Root.ChildNodes[i].NodeName = 'JSMethod' then begin
        Child := Root.ChildNodes[i];
        for j := 0 to Child.ChildNodes.Count - 1 do begin
          if Child.ChildNodes[j].NodeName = 'Method' then begin
            JSMethodsList.Add(Child.ChildNodes[j].Text);
          end;
        end;
      end;

      if Root.ChildNodes[i].NodeName = 'JSProperties' then begin
        Child := Root.ChildNodes[i];
        for j := 0 to Child.ChildNodes.Count - 1 do begin
          if Child.ChildNodes[j].NodeName = 'Properties' then begin
            JSPropList.Add(Child.ChildNodes[j].Text);
          end;
        end;
      end;

      if Root.ChildNodes[i].NodeName = 'CSSAttribute' then begin
        Child := Root.ChildNodes[i];
        for j := 0 to Child.ChildNodes.Count - 1 do begin
          if Child.ChildNodes[j].NodeName = 'Attribute' then begin
            CSSAttrList.Add(Child.ChildNodes[j].Text);
          end;
        end;
      end;

      if Root.ChildNodes[i].NodeName = 'CSSValue' then begin
        Child := Root.ChildNodes[i];
        for j := 0 to Child.ChildNodes.Count - 1 do begin
          if Child.ChildNodes[j].NodeName = 'Value' then begin
            CSSAttrList.Add(Child.ChildNodes[j].Text);
          end;
        end;
      end;
    end;
  except
  end;

  try
    XMLDocument.Free;
  except
  end;
    PHPFuncList.SaveToFile(ExtractFilePath(Application.ExeName)+'\util\PHPFunc.txt'); }
end;

end.
