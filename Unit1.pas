unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TForm1 = class(TForm)
    IdHTTP1: TIdHTTP;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function GetIP(): String;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  JSON, System.Generics.Collections;

procedure TForm1.FormCreate(Sender: TObject);
begin
  self.Caption := GetIP;
end;

function TForm1.GetIP: String;
var
  LJsonObj: TJSONObject;
  str: string;
  http: TIdHTTP;
  i: byte;
  lb: TLabeledEdit;
  t: integer;
begin
  str := '';
  http := TIdHTTP.Create(nil);
  try
    str := http.Get('http://ipinfo.io/json');
    LJsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(str), 0)
      as TJSONObject;
    t := 0;
    for i := 0 to pred(LJsonObj.Count) do
    begin
      lb := TLabeledEdit.Create(Form1);
      lb.Parent := Form1;
      with lb do
      begin
        lb.EditLabel.Caption := LJsonObj.Pairs[i].JsonString.Value;
        lb.Text := LJsonObj.Pairs[i].JsonValue.Value;
        lb.Left := 16;
        lb.Width := 611;
        t := t + 48;
        lb.Top := t;
        lb.Anchors := [akLeft, akTop, akRight];
      end;
    end;
    str := LJsonObj.GetValue('ip').Value;
    LJsonObj.Free;
    http.Free;
  Except
  end;
  Result := str;
end;

end.
