{-----------------------------------------------------------------------------
 Name:      bf  - Brainfuck Interpreter
 Author:    Sebastian Huetter
 Date:      2007-04-07
 Purpose:

 History:   2007-03-23 initial release
            2007-04-07 some fixes
            2007-04-08 translated to OOP

------------------------------------------------------------------------------
 Copyright Notice: If you copy or modify this file, this block
   _must_ be preserved! If you are using this code in your projects,
   I would like to see a word of thanks in the About-Box or a similar place.
-----------------------------------------------------------------------------}
program bf;

{$APPTYPE CONSOLE}

uses
  bfcore in 'bfcore.pas';

var tmp,programm:string;

    b:TBF;
begin
  if ParamCount>0 then begin
    b:= TBF.Create;
    try
      b.InitFromFile(Paramstr(1));
      WriteLn(ErrOutput, '---= Programmstart =----------------------');

      b.Run;
      WriteLn(ErrOutput, '---= Programmende =-----------------------');
     finally
      b.Free;
    end;
    exit;
  end;
  Writeln('bf - Brainfuck Interpreter by Martok, v0.5');
  WriteLn('------------------------------------------');
  b:= TBF.Create;
  try
    programm:= '';
    WriteLn('Programm eingeben oder ::Datei fuer Dateinamen');
    WriteLn('Leerzeile beendet Eingabe');
    WriteLn('------------------------------------------');
    repeat
      Readln(tmp);
      if copy(tmp,1,2)='::' then begin
        b.InitFromFile(copy(tmp,3,maxint));
        break;
      end;
      programm:= programm + tmp;
    until tmp='';
    if Programm>'' then
      b.Init(programm);
    WriteLn('---= Programmstart =----------------------');

    b.Run;
    Writeln;
    WriteLn('---= Programmende =-----------------------');
    WriteLn('Taste druecken....');
    readln;
  finally
    b.Free;
  end;
end.
