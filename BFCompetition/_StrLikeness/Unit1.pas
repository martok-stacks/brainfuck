unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

uses Math;

{$R *.dfm}

function StringLikeness(Ptrn, Str: string): single;
var
  lf, m: single;
  j, i: integer;
  P, S: string;
begin
  lf := length(Ptrn) / (length(Ptrn) + Abs(length(Ptrn) - length(Str)));
  P := Ptrn;
  S := Str;
  m := 0;
  j := length(P);
  if length(S) < j then
    j := length(S);
  for i := 1 to j do
  begin
    if length(S) >= i then
      m := m + 1 / (1 + Abs(ord(S[i]) - ord(P[i]))); // Abstand der Zeichen
  end;
  m := m / length(P);                   // Durchschnittspunkte
  m := m * 0.6 + lf * 0.4;              // Längenfaktor mit 40% einbeziehen
  Result := m;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Label1.Caption := FormatFloat('0.000', StringLikeness(Edit1.Text, Edit2.Text));
end;

end.

