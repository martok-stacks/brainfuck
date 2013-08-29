Unit uABC;

Interface

Uses uEvo;

Type

    TABC = Class(TBFPrgValidatorBase)
    Protected
        Procedure GetInput(Index: integer; Var S: String); Override;
        Function ValidateResult: single; Override;
        Class Function CommandSet: String; Override;
        Function MaxSteps: integer; Override;
    End;

Implementation

Uses Math,
    SysUtils;

Function compareMyStrings(_S1, _S2: String): integer;
Var
    hit: Integer; // Number of identical chars
    p1, p2: Integer; // Position count
    l1, l2: Integer; // Length of strings
    pt: Integer; // for counter
    diff: Integer; // unsharp factor
    hstr: String; // help var for swapping strings
    // Array shows is position is already tested
    test: Array Of Boolean;
    S1, S2: String;
Begin
    S1 := UpperCase(trim(_S1)); // normalize
    S2 := UpperCase(trim(_S2)); // dito
    // einer von beiden oder beide null, dann wech
    If (length(S1) = 0) Or (length(S2) = 0) Then
        result := 0 // alternativ kann hier noch unterschieden werden, welcher null ist
    Else
    Begin
        // Test Length and swap, if s1 is smaller
        // we alway search along the longer string
        If Length(s1) < Length(s2) Then
        Begin
            hstr := s2;
            s2 := s1;
            s1 := hstr;
        End;
        // store length of strings to speed up the function
        l1 := Length(s1);
        l2 := Length(s2);
        p1 := 1;
        p2 := 1;
        hit := 0;
        // calc the unsharp factor depending on the length
        // of the strings. Its about a third of the length
        diff := Max(l1, l2) Div 3 + ABS(l1 - l2);
        // init the test array
        SetLength(test, l1 + 1);
        For pt := 1 To l1 Do
            test[pt] := False;
        // loop through the string
        Repeat
            // position tested?
            If Not test[p1] Then
            Begin
                // found a matching character?
                If (s1[p1] = s2[p2]) And (ABS(p1 - p2) <= diff) Then
                Begin
                    test[p1] := True;
                    Inc(hit); // increment the hit count
                    // next positions
                    Inc(p1);
                    Inc(p2);
                    If p1 > l1 Then
                        p1 := 1;
                End
                Else
                Begin
                    // Set test array
                    test[p1] := False;
                    Inc(p1);
                    // Loop back to next test position if end of the string
                    If p1 > l1 Then
                    Begin
                        While (p1 > 1) And Not (test[p1]) Do
                            Dec(p1);
                        Inc(p2)
                    End;
                End;
            End
            Else
            Begin
                Inc(p1);
                // Loop back to next test position if end of string
                If p1 > l1 Then
                Begin
                    Repeat Dec(p1);
                    Until (p1 = 1) Or test[p1];
                    Inc(p2);
                End;
            End;
        Until p2 > Length(s2);
        // calc procentual value
        // division durch null muss abgefangen werden!!
        Try
            Result := 100 * hit Div l1;
        Except
            result := 100;
        End;
    End;
End;

{ TABC }

Class Function TABC.CommandSet: String;
Begin
    Result := '.<>[]-+';
End;

Procedure TABC.GetInput(Index: integer; Var S: String);
Begin
    S := '0';
End;

Function TABC.MaxSteps: integer;
Begin
    Result := 1000;
End;

Function TABC.ValidateResult: single;
Begin
    Result := compareMyStrings('ABC', Output) / 100;
End;

End.
