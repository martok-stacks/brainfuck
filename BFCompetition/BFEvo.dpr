Program BFEvo;

Uses
    Forms,
    uMain In 'uMain.pas' {fmBFEvo},
    uEvo In 'uEvo.pas';

{$R *.res}

Begin
    Application.Initialize;
    Application.CreateForm(TfmBFEvo, fmBFEvo);
    Application.Run;
End.

