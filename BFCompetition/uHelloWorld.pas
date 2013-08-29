unit uHelloWorld;

interface

uses uEvo;

type

  THelloWorld = class(TBFPrgValidatorBase)
  protected
    procedure GetInput(Index: integer; var S: string); override;
    function ValidateResult: single; override;
    class function CommandSet: string; override;
    function MaxSteps: integer; override;
  end;

implementation

uses Math, SysUtils;

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
end;

{ THelloWorld }

class function THelloWorld.CommandSet: string;
begin
  Result := '.<>[]-+';
end;

procedure THelloWorld.GetInput(Index: integer; var S: string);
begin
  S := '0';
end;

function THelloWorld.MaxSteps: integer;
begin
  Result := 2000;
end;

function THelloWorld.ValidateResult: single;
var lev:integer;
begin
  lev:= DamerauLevenshteinDistance('Hello World!'#10,Output);
  Result:= exp(-lev);
  FProgram.Correct := 'Hello World!'#10 = Output;
end;

end.
 
