program IDE;

uses
  Forms,
  uIDEMain in 'uIDEMain.pas' {fmBF};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmBF, fmBF);
  Application.Run;
end.
