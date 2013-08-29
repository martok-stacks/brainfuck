unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Contnrs, StdCtrls, ExtCtrls;

type
  TValue = class
    Score: single;
    constructor Create(S: Single);
  end;

  TForm1 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Image2: TImage;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure OutputIm(c: TCanvas);
  public
    { Public-Deklarationen }
    Pool: TObjectList;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
type
  TDataArray = array of TValue;

function Merge(ll, rl: TDataArray): TDataArray;
var
  p, l, r, i: integer;
begin
  SetLength(Result, length(ll) + length(rl));
  p := 0;
  l := 0;
  r := 0;
  while (length(ll) > l) and (length(rl) > r) do
  begin
    if TValue(ll[l]).Score >= TValue(rl[r]).Score then
    begin
      Result[p] := ll[l];
      inc(l);
    end
    else
    begin
      Result[p] := rl[r];
      inc(r);
    end;
    inc(p);
  end;
  for i := l to high(ll) do
  begin
    Result[p] := ll[i];
    inc(p);
  end;
  for i := r to high(rl) do
  begin
    Result[p] := rl[i];
    inc(p);
  end;
end;

function MergeSort(L: TDataArray): TDataArray;
var
  ll, rl: TDataArray;
begin
  SetLength(ll, 0);
  SetLength(rl, 0);
  if Length(L) <= 1 then
    Result := copy(L, 0, length(L))
  else
  begin
    ll := copy(L, 0, length(L) div 2);
    rl := copy(L, length(L) div 2, maxint);
    Result := Merge(MergeSort(ll), MergeSort(rl));
  end;
end;

procedure MergeSortList(L: TObjectList);
var
  A: TDataArray;
  I: integer;
  OldOO: boolean;
begin
  Setlength(A, L.Count);
  for i := 0 to high(A) do
    A[i] := TValue(L[i]);
  A := MergeSort(A);
  OldOO := L.OwnsObjects;
  try
    L.OwnsObjects := false;
    for i := 0 to high(A) do
      L.Items[i] := A[i];
  finally
    L.OwnsObjects := OldOO;
  end;
end;

{ TValue }

constructor TValue.Create(S: Single);
begin
  inherited Create;
  Score := S;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Pool := TObjectList.Create(true);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: integer;
begin
  Pool.Clear;
  for i := 0 to 800 - 1 do
    Pool.Add(TValue.Create(random * 100));
  OutputIm(Image1.Canvas);
end;

procedure TForm1.OutputIm(c: TCanvas);
var
  i: integer;
begin
  C.Brush.Color := clWhite;
  C.FillRect(Rect(0, 0, 500, Pool.Count));
  for i := 0 to Pool.Count - 1 do
  begin
    C.Pen.Color := round(Tvalue(Pool[i]).Score / 100 * 255);
    C.MoveTo(0, i);
    C.LineTo(round(Tvalue(Pool[i]).Score * 2), i);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  MergeSortList(Pool);
  OutputIm(Image2.Canvas);
  Image2.Canvas.Pen.Color := clLime;
  Image2.Canvas.MoveTo(200, 0);
  Image2.Canvas.LineTo(0, Pool.Count - 1);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Button1.Click;
  Button2.Click;
end;

end.

