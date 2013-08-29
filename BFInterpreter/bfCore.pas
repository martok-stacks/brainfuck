{-----------------------------------------------------------------------------
 Unit Name: bfcore
 Author:    Sebastian Huetter
 Date:      2007-04-08
 Purpose:   Core for Brainfuck. OOP here too ;)
            NOTE: define FULL_OOP in Project Options to be able to assign
              events to object methods!

 History:   2007-04-08 initial release
                       [BenBE]: fixed loop issue
 
------------------------------------------------------------------------------
 Copyright Notice: If you copy or modify this file, this block
   _must_ be preserved! If you are using this code in your projects,
   I would like to see a word of thanks in the About-Box or a similar place.
-----------------------------------------------------------------------------}
unit bfcore;

interface

type
  TTape = array of smallint;
  TStack = array of word;

  TWriteEv = procedure (C:char) {$IFDEF FULL_OOP}of object{$ENDIF};
  TReadNumEv = procedure (var n:integer) {$IFDEF FULL_OOP}of object{$ENDIF};
  TReadChrEv = procedure (var c:char) {$IFDEF FULL_OOP}of object{$ENDIF};
  TStepEv = procedure (const programm:string; const prg:integer; const Daten: TTape;
               const ptr:integer; const Stack: TStack) {$IFDEF FULL_OOP}of object{$ENDIF};

  TBF = class
    tmp,programm:string;
    Daten: TTape;
    Stack:TStack;
    ptr,prg:integer;
  private
    FOnReadChr: TReadChrEv;
    FOnReadNum: TReadNumEv;
    FOnWrite: TWriteEv;
    FOnBeforeStep,
    FOnAfterStep: TStepEv;
    FCycle: integer;
    {$IFDEF FULL_OOP}
    procedure ReadChrEv(var c: char);
    procedure ReadNumEv(var n: word);
    procedure WriteEv(C: char);
    {$ENDIF}
  public
    constructor Create;
    procedure Init(APrg:string);
    procedure InitFromFile(AFile:string);
    procedure Run;
    procedure Step;
    property OnWrite : TWriteEv read FOnWrite write FOnWrite;
    property OnReadNum : TReadNumEv read FOnReadNum write FOnReadNum;
    property OnReadChr : TReadChrEv read FOnReadChr write FOnReadChr;
    property OnBeforeStep: TStepEv read FOnBeforeStep write FOnBeforeStep;
    property OnAfterStep: TStepEv read FOnAfterStep write FOnAfterStep;
    property Cycle: integer read FCycle;
  end;

const
  TapeLength = 512;
  BF_CODE_CHARS =  ['.',',','#','[',']','>','<','+','-'];


implementation

procedure {$IFDEF FULL_OOP}TBF.{$ENDIF}WriteEv   (C:char);
begin
  Write(C);
end;

procedure {$IFDEF FULL_OOP}TBF.{$ENDIF}ReadNumEv (var n:integer);
begin
  Readln(n);
end;

procedure {$IFDEF FULL_OOP}TBF.{$ENDIF}ReadChrEv (var c:char);
begin
  ReadLn(C);
end;

{ TBF }

constructor TBF.Create;
begin
  FOnReadChr:= ReadChrEv;
  FOnReadNum:= ReadNumEv;
  FOnWrite:= WriteEv;
  Init('');
end;

procedure TBF.Init(APrg: string);
begin
  Setlength(Daten,TapeLength*2+1);
  Fillchar(Daten[0],length(Daten)*sizeof(word),0);
  Setlength(Stack,0);
  ptr:= TapeLength;
  prg:= 1;
  FCycle:= 0;
  programm:= APrg;
end;

procedure TBF.InitFromFile(AFile: string);
var f:TextFile;
    s,p:string;
begin
  Assign(F,AFile);
  Reset(F);
  p:= '';
  while not EOF(F) do begin
    Readln(F,s);
    p:= p + S + #13#10;
  end;
  CloseFile(F);
  Init(P);
end;

procedure TBF.Run;
begin
  while prg<=length(programm) do begin
    Step;
  end;
end;

procedure TBF.Step;
var
  i,j:integer;
  c:char;
begin
  while (prg<=length(programm)) and              // search for good code
        not (programm[prg] in BF_CODE_CHARS) do 
    inc(prg);
  if prg>length(programm) then exit;             // nothing / end
  if prg=length(programm) then
    ReadLn;

  inc(FCycle);
  if @FOnBeforeStep<>nil then
    FOnBeforeStep(programm,prg, Daten, ptr, Stack);
  case programm[prg] of
    '>' : if ptr<TapeLength shl 1 then inc(ptr);
    '<' : if ptr>0 then dec(ptr);
    '+' : inc(Daten[ptr]);
    '-' : dec(Daten[ptr]);
    '.' : FOnWrite(chr(Daten[ptr]));
    ',' : begin
            FOnReadChr(c);
            Daten[ptr]:= ord(c);
          end;
    '#' : begin
            FOnReadNum(j);
            Daten[ptr]:= j;
          end;
    '[' : begin
            Setlength(Stack,length(Stack)+1);
            Stack[high(Stack)]:= prg;
            if Daten[ptr]=0 then begin
              j:= 0;
              for i:= prg to length(programm) do begin
                case programm[i] of
                  '[' : inc(j);
                  ']' : begin
                          dec(j);
                          if j=0 then begin
                            prg:= i;
                            Setlength(Stack,length(Stack)-1);
                            break;
                          end;
                        end;
                end;
              end;
            end;
          end;
    ']' : begin
            if length(Stack)>0 then begin
              if Daten[ptr]<>0 then
                prg:= Stack[high(Stack)]-1;
              Setlength(Stack,length(Stack)-1);
            end;
          end;
  end;
  inc(prg);
  if @FOnAfterStep<>nil then
    FOnAfterStep(programm,prg, Daten, ptr, Stack);
end;

end.
