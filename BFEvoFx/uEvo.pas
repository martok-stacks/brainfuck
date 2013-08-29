Unit uEvo;

Interface

Uses
    Classes,
    Contnrs,
    bfcore;

Type
    TBFEvo = Class;
    TBFProgram = Class;

    TBFPrgValidatorClass = Class Of TBFPrgValidatorBase;
    TBFPrgValidatorBase = Class
    Private
        FMax: integer;
        InputIdx: integer;
        Procedure ReadChrEv(Var c: char);
        Procedure ReadNumEv(Var n: word);
        Procedure WriteEv(C: char);
    Protected
        BF: TBF;
        Output: String;
        FProgram: TBFProgram;
        Procedure GetInput(Index: integer; Var S: String); Virtual; Abstract;
        Function ValidateResult: single; Virtual; Abstract;
        Class Function CommandSet: String; Virtual; Abstract;
        Function MaxSteps: integer; Virtual; Abstract;
    Public
        Constructor Create;
        Procedure Load(P: TBFProgram);
        Procedure Run;
        Procedure Score;
    End;

    TEvStepEvent = Procedure(best: TBFProgram; Var cancel: boolean) Of Object;

    TBFProgram = Class
    Private
        FOwner: TBFEvo;
        FSource: String;
        FTerminates: Boolean; //Tells if the program terminates
        FExectime: Integer; //Number of clock cycles to execute
        FCorrect: Boolean; //Tells if the programm gives the fully correct output
        FCorrectness: Extended; //Value between 0 and 1 giving a grade of the output validness
        FScore: Extended;
        Procedure SetCorrectness(Const Value: Extended);
        Procedure SetScore(Const Value: Extended);
        Procedure SetSource(Const Value: String);
        Procedure SetTerminates(Const Value: Boolean);
        Procedure SetCorrect(Const Value: Boolean);
        Function GetLength: Integer;
        Procedure SetExecTime(Const Value: Integer);
    Public
        Constructor Create(AOwner: TBFEvo); Reintroduce; Virtual;
        Function Clone: TBFProgram;
        Procedure Evolve; //Optimize the program by simple rules
        Procedure Mutate; //Mutate the program in some different ways
        Property Score: Extended Read FScore Write SetScore;
        Property Correct: Boolean Read FCorrect Write SetCorrect;
        Property Correctness: Extended Read FCorrectness Write SetCorrectness;
        Property Source: String Read FSource Write SetSource;
        Property SrcLen: Integer Read GetLength;
        Property Terminates: Boolean Read FTerminates Write SetTerminates;
        Property ExecTime: Integer Read FExecTime Write SetExecTime;
    End;

    TBFEvo = Class
    Private
        FEvClass: TBFPrgValidatorClass;
        FMaxEvoSteps: integer;
        FMutationRate: Extended;
        FOnEvStepDone: TEvStepEvent;
        FGeneration: integer;
        Function GetPoolItem(ItemID: Integer): TBFProgram;
        Function GetPoolSize: Integer;
    Protected
        ProgramPool: TObjectList;
        Procedure RandomInit; // Zufallsprogramme erzeugen
        Procedure Mutate; // Verbliebene mutieren lassen
        Procedure Evolve; // Alle laufen lassen und Wert messen
        Procedure Level; // Evolve, schlechte weg, Mutate + neue
        Procedure ValidSort; // sortieren nach Wert
        Function StepDone: boolean;
    Public
        Constructor Create;
        Destructor Destroy; Override;
        Property EvClass: TBFPrgValidatorClass Read FEvClass Write FEvClass;
        Property MaxEvoSteps: integer Read FMaxEvoSteps Write FMaxEvoSteps;
        Property MutationRate: Extended Read FMutationRate Write FMutationRate;
        Procedure RunEvolution;
        Property Generation: integer Read FGeneration;
        Property OnEvStepDone: TEvStepEvent Read FOnEvStepDone Write FOnEvStepDone;

        Property PoolSize: Integer Read GetPoolSize;
        Property PoolItem[ItemID: Integer]: TBFProgram Read GetPoolItem;
    End;

Implementation

Uses
    SysUtils,
    Math;

Const
    OPT_SCORE = 10000;

    { TBFPrgValidatorBase }

Procedure TBFPrgValidatorBase.WriteEv(C: char);
Begin
    Output := Output + C;
End;

Procedure TBFPrgValidatorBase.ReadNumEv(Var n: word);
Var
    s: String;
Begin
    s := '';
    GetInput(InputIdx, s);
    inc(InputIdx);
    n := StrToInt(s);
End;

Procedure TBFPrgValidatorBase.ReadChrEv(Var c: char);
Var
    s: String;
Begin
    s := '';
    GetInput(InputIdx, s);
    inc(InputIdx);
    c := s[1];
End;

Constructor TBFPrgValidatorBase.Create;
Begin
    Inherited Create;
    BF := TBF.Create;
    BF.OnWrite := WriteEv;
    BF.OnReadNum := ReadNumEv;
    BF.OnReadChr := ReadChrEv;
    FMax := MaxSteps;
End;

Procedure TBFPrgValidatorBase.Load(P: TBFProgram);
Begin
    Output := '';
    InputIdx := 0;
    FProgram := P;
    BF.Init(P.Source);
End;

Procedure TBFPrgValidatorBase.Run;
Var
    n: integer;
Begin
    n := 0;
    While (BF.prg <= length(bf.programm)) And (n < FMax) Do
    Begin
        BF.Step;
        inc(n);
    End;
    FProgram.FExectime := N;
    FProgram.Terminates := (n < FMax) Or (BF.prg > length(bf.programm));
End;

Procedure TBFPrgValidatorBase.Score;
Begin
    //Hier ggf. anpassen ;-)
    FProgram.Correctness := ValidateResult;
    If (FProgram.SrcLen = 0) Or (FProgram.FExectime = 0) Then
        FProgram.Score := 0
    Else
        FProgram.Score := Power(FProgram.Correctness, 4) * (10000 / FProgram.SrcLen) * (1000 / FProgram.FExectime);

    If Not FProgram.Terminates Then
        FProgram.Score := FProgram.Score / 4;

    If FProgram.Correct Then
    Begin
        FProgram.Score := FProgram.Score * 16;
    End;
End;

{ TBFEvo }

Constructor TBFEvo.Create;
Begin
    Inherited Create;
    Randomize;
    FMaxEvoSteps := 1000;
    FMutationRate := 0.05;
    FEvClass := Nil;
    ProgramPool := TObjectList.Create(False);
End;

Destructor TBFEvo.Destroy;
Begin
    ProgramPool.Free;
    Inherited;
End;

Procedure TBFEvo.RandomInit;
Var
    st, p: String;
    i, j: integer;

    BFprogram: TBFProgram;
Begin
    //Hier kann u.U. geändert werden. Festcodierte Programme sind aber weniger wünschenswert ...
    st := FEvClass.CommandSet + ' ';
    For i := 0 To 63 Do
    Begin
        SetLength(p, Random(1000));
        For j := 1 To length(p) Do
        Begin
            p[j] := st[random(length(st)) + 1];
        End;
        BFprogram := TBFProgram.Create(Self);
        BFprogram.Source := p;
        ProgramPool.Add(BFprogram);
    End;
End;

Procedure TBFEvo.Mutate;
Var
    i, j: integer;
    p: TBFProgram;
Begin
    For i := 0 To ProgramPool.Count - 1 Do
    Begin
        For j := 0 To Random(Trunc(TBFProgram(ProgramPool[i]).Score)) Do
        Begin
            If Random(5) = 0 Then
            Begin
                p := TBFProgram(ProgramPool[i]).Clone;
                p.Evolve;
                p.Mutate;
                p.Evolve;
                ProgramPool.Add(p);
            End;
        End;
    End;
End;

Procedure TBFEvo.Evolve;
Var
    tester: TBFPrgValidatorBase;
    i: integer;
Begin
    tester := FEvClass.Create;
    Try
        For i := 0 To ProgramPool.Count - 1 Do
        Begin
            Tester.Load(TBFProgram(ProgramPool[i]));
            tester.Run;
            tester.Score;
        End;
    Finally
        tester.Free;
    End;
End;

Procedure TBFEvo.Level;
Var
    i: integer;
    P: TBFProgram;
Begin
    Evolve;
    ValidSort;

    For i := ProgramPool.Count - 1 Downto 5000 Do // loesche die schlechten Programme (lasse einen Grundpool übrig
    Begin
        P := TBFProgram(ProgramPool[i]);
        ProgramPool.Delete(i);
        FreeAndNil(P);
    End;

    Mutate;
End;

Type
    TDataArray = Array Of TBFProgram;

Function Merge(ll, rl: TDataArray): TDataArray;
Var
    p, l, r, i: integer;
Begin
    SetLength(Result, length(ll) + length(rl));
    p := 0;
    l := 0;
    r := 0;
    While (length(ll) > l) And (length(rl) > r) Do
    Begin
        If TBFProgram(ll[l]).Score >= TBFProgram(rl[r]).Score Then
        Begin
            Result[p] := ll[l];
            inc(l);
        End
        Else
        Begin
            Result[p] := rl[r];
            inc(r);
        End;
        inc(p);
    End;
    For i := l To high(ll) Do
    Begin
        Result[p] := ll[i];
        inc(p);
    End;
    For i := r To high(rl) Do
    Begin
        Result[p] := rl[i];
        inc(p);
    End;
End;

Function MergeSort(L: TDataArray): TDataArray;
Var
    ll, rl: TDataArray;
Begin
    SetLength(ll, 0);
    SetLength(rl, 0);
    If Length(L) <= 1 Then
        Result := copy(L, 0, length(L))
    Else
    Begin
        ll := copy(L, 0, length(L) Div 2);
        rl := copy(L, length(L) Div 2, maxint);
        Result := Merge(MergeSort(ll), MergeSort(rl));
    End;
End;

Procedure MergeSortList(L: TObjectList);
Var
    A: TDataArray;
    I: integer;
    OldOO: boolean;
Begin
    Setlength(A, L.Count);
    For i := 0 To high(A) Do
        A[i] := TBFProgram(L[i]);
    A := MergeSort(A);
    OldOO := L.OwnsObjects;
    Try
        L.OwnsObjects := false;
        For i := 0 To high(A) Do
            L.Items[i] := A[i];
    Finally
        L.OwnsObjects := OldOO;
    End;
End;

Procedure TBFEvo.ValidSort;
Begin
    MergeSortList(ProgramPool);
End;

Procedure TBFEvo.RunEvolution;
Begin
    If FEvClass = Nil Then
        Raise Exception.Create('Keine Validatorklasse bekannt!');

    RandomInit;

    FGeneration := 0;
    While (FGeneration < FMaxEvoSteps) And
        (TBFProgram(ProgramPool[0]).Score < OPT_SCORE) Do
    Begin
        Level;

        If StepDone Then
            break;

        inc(FGeneration);
    End;
End;

Function TBFEvo.StepDone: boolean;
Begin
    Result := True;
    If Assigned(FOnEvStepDone) Then
        FOnEvStepDone(TBFProgram(ProgramPool[0]), Result);
End;

Function TBFEvo.GetPoolItem(ItemID: Integer): TBFProgram;
Begin
    Result := TBFProgram(ProgramPool[ItemID]);
End;

Function TBFEvo.GetPoolSize: Integer;
Begin
    Result := ProgramPool.Count;
End;

{ TBFProgram }

Function TBFProgram.Clone: TBFProgram;
Begin
    Result := TBFProgram.Create(FOwner);
    Result.Source := Source;
End;

Constructor TBFProgram.Create(AOwner: TBFEvo);
Begin
    Inherited Create;
    FOwner := AOwner;
    FTerminates := False;
    FExectime := 0;
    FCorrect := False;
    FCorrectness := 0.0;
    FScore := 0.0;
    Source := '';
End;

Procedure TBFProgram.Evolve;
Var
    Src: String;
Begin
    Src := Source;

    // TODO: Implement the evolution ;-)

    Source := Trim(Src);
End;

Function TBFProgram.GetLength: Integer;
Var
    i: integer;
Begin
    Result := 0;
    For i := 1 To Length(Source) Do
        If Source[i] <> ' ' Then
            inc(Result);
End;

Procedure TBFProgram.Mutate;
Var
    Src: String;
Begin
    Src := Source;

    // TODO: Implement the Mutation ;-)

    Source := Src;
End;

Procedure TBFProgram.SetCorrect(Const Value: Boolean);
Begin
    FCorrect := Value;
End;

Procedure TBFProgram.SetCorrectness(Const Value: Extended);
Begin
    FCorrectness := Value;
End;

Procedure TBFProgram.SetExecTime(Const Value: Integer);
Begin
    FExecTime := Value;
End;

Procedure TBFProgram.SetScore(Const Value: Extended);
Begin
    FScore := Value;
End;

Procedure TBFProgram.SetSource(Const Value: String);
Begin
    FSource := Value;
    Correct := false;
    Correctness := 0.0;
    Terminates := false;
    Score := 0.0;
End;

Procedure TBFProgram.SetTerminates(Const Value: Boolean);
Begin
    FTerminates := Value;
End;

End.

