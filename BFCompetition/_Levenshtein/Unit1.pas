unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, math, Grids;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Label1: TLabel;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function DamerauLevenshteinDistance(str1, str2: string): integer;
var
  d: array of array of integer;
  i, j, cost: integer;
begin
  setlength(d, length(str1) + 1);
  for i := 0 to high(d) do
  begin
    setlength(d[i], length(str2) + 1);
    d[i, 0] := i;
  end;
  for j := 0 to high(d[0])  do
    d[0, j] := j;
  for i := 1 to high(d) do
    for j := 1 to high(d[0]) do
    begin
      if (str1[i] = str2[j]) then
        cost := 0 else
          cost := 1;
      d[i, j] := min(d[i - 1, j] + 1,      // Löschen
                 min(d[i, j - 1] + 1,      // Einfügen
                 d[i - 1, j - 1] + cost)); // Ersetzen
      if ((i > 1) and (j > 1) and (str1[i - 1] = str2[j - 2]) and (str1[i - 2] = str2[j - 1])) then
        d[i, j] := min(d[i, j], d[i - 2, j - 2] + cost);
    end;
  result := d[high(d), high(d[0])];
  // TEST
  with Form1 do
  begin
    for i := 0 to Stringgrid1.ColCount - 1 do
      for j := 0 to Stringgrid1.RowCount - 1 do
        Stringgrid1.Cells[i, j] := '';
    for i := 1 to length(str1) do
      Stringgrid1.Cells[i + 1, 0] := str1[i];
    for i := 1 to length(str2) do
      Stringgrid1.Cells[0, i + 1] := str2[i];
    for i := 0 to high(d) do
      for j := 0 to high(d[i]) do
        Stringgrid1.Cells[i + 1, j + 1] := inttostr(d[i, j]);
  end;
end;

  
procedure TForm1.Button1Click(Sender: TObject);
begin
  label1.Caption := 'Unterschiede: ' + inttostr(DamerauLevenshteinDistance(Edit1.text, Edit2.Text));
end;

end.
