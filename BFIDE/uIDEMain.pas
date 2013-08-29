unit uIDEMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SynEdit, bfCore, Grids;

const
  UM_NEXTSTEP = WM_USER + 1234;

type
  TfmBF = class(TForm)
    Panel1: TPanel;
    sgTape: TStringGrid;
    Label1: TLabel;
    Panel2: TPanel;
    seInput: TSynEdit;
    Label2: TLabel;
    pnEnter: TPanel;
    edEnter: TEdit;
    Label3: TLabel;
    lbEnterType: TLabel;
    seOutput: TSynEdit;
    OpenDialog1: TOpenDialog;
    Label4: TLabel;
    lbStack: TListBox;
    SaveDialog1: TSaveDialog;
    Label5: TLabel;
    Panel3: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    lbCodeLength: TLabel;
    lbCycle: TLabel;
    Panel4: TPanel;
    btnStart: TButton;
    btnLoad: TButton;
    cbSteps: TCheckBox;
    btnNext: TButton;
    cbSlow: TCheckBox;
    btnSave: TButton;
    procedure btnStartClick(Sender: TObject);
    procedure edEnterKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnLoadClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure seInputChange(Sender: TObject);
  private
    { Private-Deklarationen }
    BF: TBF;
    Entered: boolean;
    min_ptr, max_ptr: word;
    procedure NextMsg(var Msg: TMessage); message UM_NEXTSTEP;
  public
    { Public-Deklarationen }
    function GetEnter(C: string): string;
    procedure DebugUpdate(const prg: word; const Daten: TTape; const ptr: word; const Stack: TStack);
  end;

var
  fmBF: TfmBF;

implementation

{$R *.dfm}

procedure Delay(ms: DWORD);
var
  T: DWORD;
begin
  T := GetTickCount + ms;
  while T > GetTickCount do
    Application.ProcessMessages;
end;

procedure WriteEv(C: char);
begin
  fmBF.seOutput.Text := fmBF.seOutput.Text + C;
end;

procedure ReadNumEv(var n: word);
var s:String;
begin
  s:= fmBF.GetEnter('Zahl');
  if s>'' then
    n := StrToInt(s)
  else
    n:= 13;
end;

procedure ReadChrEv(var c: char);
var s:String;
begin
  s:= fmBF.GetEnter('Zeichen');
  if s>'' then
    C := s[1]
  else
    C:= #13;
end;

procedure BefStep(const programm: string; const prg: word; const Daten: TTape;
  const ptr: word; const Stack: TStack);
begin
  fmBF.DebugUpdate(prg, Daten, ptr, Stack);     
end;

procedure AftStep(const programm: string; const prg: word; const Daten: TTape;
  const ptr: word; const Stack: TStack);
begin
  if fmBF.cbSlow.Checked then
  begin
    Delay(20);
  end;
  Application.ProcessMessages;
  if (not fmBF.cbSteps.Checked) and (prg <= length(programm)) then
    PostMessage(fmBF.Handle, UM_NEXTSTEP, 0, 0);
end;

procedure TfmBF.FormCreate(Sender: TObject);
begin
  BF := TBF.Create;
  BF.OnReadChr := ReadChrEv;
  BF.OnReadNum := ReadNumEv;
  BF.OnWrite := WriteEv;
  BF.OnBeforeStep := BefStep;
  BF.OnAfterStep := AftStep;
end;

procedure TfmBF.btnLoadClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    seInput.Lines.LoadFromFile(OpenDialog1.FileName);
  seInputChange(Self);
end;

procedure TfmBF.btnSaveClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    seInput.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TfmBF.btnStartClick(Sender: TObject);
begin
  min_ptr := TapeLength;
  max_ptr := TapeLength;
  seOutput.Clear;
  bf.Init(seInput.Text);
  BF.Step;
end;

function TfmBF.GetEnter(C: string): string;
begin
  pnEnter.Show;
  pnEnter.Top := 100000;
  lbEnterType.Caption := C;
  edEnter.Text := '';
  edEnter.SetFocus;
  Entered := false;
  Result := edEnter.Text;
  while not Entered do
    Application.ProcessMessages;
  Result := edEnter.Text;
  pnEnter.Hide;
end;

procedure TfmBF.edEnterKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Entered := true;
end;

procedure TfmBF.DebugUpdate(const prg: word;
  const Daten: TTape; const ptr: word; const Stack: TStack);
var
  i: integer;
begin
  seInput.SelStart := prg - 1;
  seInput.SelLength := 1;
  if min_ptr > ptr then
    min_ptr := ptr;
  if max_ptr < ptr then
    max_ptr := ptr;
  sgTape.RowCount := max_ptr - min_ptr + 1;
  for i := min_ptr to max_ptr do
    if i = ptr then
      sgTape.Rows[i - min_ptr].Text := '>' + inttostr(i) + #13#10 + Inttostr(Daten[i])
    else
      sgTape.Rows[i - min_ptr].Text := inttostr(i) + #13#10 + Inttostr(Daten[i]);

  lbStack.Clear;
  lbStack.Items.BeginUpdate;
  for i := 0 to high(Stack) do
    lbStack.Items.Insert(0, IntToStr(stack[i]));
  lbStack.Items.EndUpdate;
  lbCycle.Caption:= IntToStr(BF.Cycle);
end;

procedure TfmBF.btnNextClick(Sender: TObject);
begin
  BF.Step;
end;

procedure TfmBF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F7: btnNext.Click;
    VK_F9: btnStart.Click;
  end;
end;

procedure TfmBF.NextMsg(var Msg: TMessage);
begin
  btnNext.Click;
end;

procedure TfmBF.seInputChange(Sender: TObject);
var i,j:integer;
begin
  j:= 0;
  for i:= 1 to Length(seInput.Text) do
    if seInput.Text[i] in BF_CODE_CHARS then
      inc(j);
  lbCodeLength.Caption:= IntToStr(j);
end;

end.

