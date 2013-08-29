unit uHelloWorld;

interface

uses uEvo;

type

  THelloWorld = class(TBFPrgValidatorBase)
  public
    procedure GetInput(Index: integer; var S: string); override;
    function ValidateResult: single; override;
    class function CommandSet: string; override;
    function MaxSteps: integer; override;
  end;

implementation

uses 
    Math, 
    SysUtils;

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
begin
  Result:= exp(-Random);
  FProgram.Correct := 'Hello World!'#10 = Output;
end;

end.
 
