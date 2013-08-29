Unit uMain;

Interface

Uses
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    StdCtrls,
    uEvo,
    ComCtrls,
    ExtCtrls;

Type
    TfmBFEvo = Class(TForm)
        pbBestValue: TProgressBar;
        Button1: TButton;
        Button2: TButton;
        meBestCode: TMemo;
        lbBetValue: TLabel;
        lbGeneration: TLabel;
        Procedure FormCreate(Sender: TObject);
        Procedure Button1Click(Sender: TObject);
        Procedure Button2Click(Sender: TObject);
        Procedure FormPaint(Sender: TObject);
        Procedure FormDestroy(Sender: TObject);
    Private
        { Private-Deklarationen }
        GenForm: TForm;
        GenImg: TImage;
        GenBMP: TBitmap;
    Public
        { Public-Deklarationen }
        Evo: TBFEvo;
        FCancel: boolean;
        Procedure EvoStep(best: TBFProgram; Var cancel: boolean);
    End;

Var
    fmBFEvo: TfmBFEvo;

Implementation

Uses
    uHelloWorld;

{$R *.dfm}

Procedure TfmBFEvo.FormCreate(Sender: TObject);
Begin
    Evo := TBFEvo.Create;
    Evo.EvClass := THelloWorld;
    Evo.OnEvStepDone := EvoStep;
    Evo.MaxEvoSteps := 10000;
    Evo.MutationRate := 0.25;

    GenForm := TForm.Create(Self);
    GenForm.ClientWidth := 500;
    GenForm.ClientHeight := 500;
    //    GenForm.OnPaint := FormPaint;

    GenImg := TImage.Create(GenForm);
    GenImg.Parent := GenForm;
    GenImg.AutoSize := True;

    GenBMP := GenImg.Picture.Bitmap;
    GenBMP.Width := 500;
    GenBMP.Height := 500;
End;

Procedure TfmBFEvo.Button1Click(Sender: TObject);
Begin
    FCancel := false;
    GenForm.Show;
    GenForm.Update;
    Evo.RunEvolution;
End;

Procedure TfmBFEvo.EvoStep(best: TBFProgram; Var cancel: boolean);

    Function Describe(p: TBFProgram): String;
    Begin
        Result := Format('Source: %s'#13#10 +
            'Correct: %s Correctness: %.5f'#13#10 +
            'Size: %d ExecTime: %d Score: %.5f'#13#10#13#10,
            [p.Source, BoolToStr(P.Correct), P.Correctness, P.SrcLen, P.ExecTime, P.Score]);
    End;

Var
    S: String;
    I: IntegeR;

Begin
    pbBestValue.Position := trunc(best.Score);

    S := '';
    For I := 0 To 4 Do
    Begin
        S := S + Describe(Evo.PoolItem[I]);
    End;

    meBestCode.Text := S;
    lbBetValue.Caption := Format('%.5f', [best.Score]);
    lbGeneration.Caption := IntToStr(Evo.Generation);

    FormPaint(Self);
    GenImg.Update;
    Application.ProcessMessages;
    GenForm.Update;
    Application.ProcessMessages;

    Cancel := FCancel;
End;

Procedure TfmBFEvo.Button2Click(Sender: TObject);
Begin
    FCancel := true;
End;

Procedure TfmBFEvo.FormPaint(Sender: TObject);
Var
    X, Y: Integer;
    MaxX, MaxY: Integer;

    S: String;

    PC: ^TColor;
Begin
    //Draw the GenPool Form contents ;-)
    GenBMP.PixelFormat := pf32bit;

    //Init the GenBMP background
    With GenBMP.Canvas Do
    Begin

        Brush.Color := clblack;
        FillRect(ClipRect);

        MaxY := 500;
        If Evo.PoolSize < 500 Then
        Begin
            MaxY := Evo.PoolSize;
        End;

        For Y := 0 To MaxY - 1 Do
        Begin
            S := Evo.PoolItem[Y].Source;
            MaxX := Length(S);

            PC := GenBMP.ScanLine[Y];
            For X := 0 To MaxX - 1 Do
            Begin
                If X >= 500 Then
                    Break;

                Case S[X] Of
                    '+': PC^ := $FF0000;
                    '-': PC^ := $00FFFF;
                    '<': PC^ := $00FF00;
                    '>': PC^ := $FF00FF;
                    '[': PC^ := $0000FF;
                    ']': PC^ := $FFFF00;
                    '.': PC^ := $FFFFFF;
                    '#': PC^ := $808080;
                    ',': PC^ := $000000;
                Else
                    Dec(PC);
                End;
                Inc(PC);
            End;
        End;
    End;

    GenImg.Update;
End;

Procedure TfmBFEvo.FormDestroy(Sender: TObject);
Begin
    FreeAndNil(GenForm);
    FreeAndNil(Evo);
End;

End.

