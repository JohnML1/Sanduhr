unit Unit1;

{$mode objfpc}{$H+}

interface

uses
<<<<<<< HEAD
  FileUtil, lazutf8, Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, EditBtn, StdCtrls, ComCtrls, IniPropStorage, MaskEdit, Menus,
  Buttons, UniqueInstance,  DateUtils, LCLType,crt;
=======
  locale_de,  Filesrc, FileUtil, lazutf8, Classes, SysUtils, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, EditBtn, StdCtrls, ComCtrls,
  IniPropStorage, MaskEdit, Menus, Buttons, UniqueInstance, DateUtils, LCLType {$IFDEF windows} , MMSystem  {$ENDIF };
>>>>>>> parent of 13eb9eb... OHNE locale_de

type

  { TForm1 }

  TForm1 = class(TForm)
    ApplicationProperties1: TApplicationProperties;
    EditZeitspanne: TMaskEdit;
    IniPropStorage1: TIniPropStorage;
    Label1: TLabel;
    MenuItem1: TMenuItem;
    MnSchliessen: TMenuItem;
    Panel1: TPanel;
    PopupTrayIcon: TPopupMenu;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    TimerEinschalten: TBitBtn;
    TrayIcon1: TTrayIcon;
    UniqueInstance1: TUniqueInstance;
    UpDown1: TUpDown;
    procedure ApplicationProperties1Hint(Sender: TObject);
    procedure EditZeitspanneChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Anzeigen(Sender: TObject);
    procedure MnSchliessenClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TimerEinschaltenClick(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure UpDown1ChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: SmallInt; Direction: TUpDownDirection);
  private

  public
    function  CheckTime(ToCheck : String): boolean;

  end;

var
  Form1: TForm1;
  SecsCount : integer = 0;
  SoundFile : string;

implementation

{$R *.lfm}

{ TForm1 }

uses unit2;

procedure TForm1.FormShow(Sender: TObject);
begin
  EditZeitspanne.SetFocus;
  EditZeitspanne.SelStart:=3;
  EditZeitspanne.SelLength:=2;
  EditZeitspanne.Invalidate;
  Application.ProcessMessages;
  //EditZeitspanne.SetFocus;

end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
var AllowUpdate : boolean;
begin
  if Key = VK_ESCAPE then Application.Mainform.close;
  if Key = VK_RETURN then TimerEinschaltenClick(Sender);

  (* TUpDown per Pfeil hoch/runter steuern *)
  if Key = VK_UP then
  begin
   AllowUpdate := true;
   UpDown1ChangingEx(Sender, AllowUpdate, 1, updUp)
  end;
  if Key = VK_Down then
  begin
   AllowUpdate := true;
   UpDown1ChangingEx(Sender, AllowUpdate, 1, updDown)
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  IniPropStorage1.IniFileName:=ChangeFileExt(Application.ExeName,'.ini');

end;

procedure TForm1.ApplicationProperties1Hint(Sender: TObject);
begin
  EditZeitspanne.Hint:=EditZeitspanne.Caption;
end;

procedure TForm1.EditZeitspanneChange(Sender: TObject);
var val : string;
begin
  val := EditZeitspanne.EditText;
  CheckTime(val);
end;

procedure TForm1.Anzeigen(Sender: TObject);
begin
   Application.MainForm.Visible:=true;
end;

procedure TForm1.MnSchliessenClick(Sender: TObject);
begin
  Application.MainForm.Close;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var val, SecsCountTime : TTime;
    secs, secs1 : int64;
begin
  (* globale Variable für verstrichene Sekunden erhöhen *)
  SecsCount := SecsCount +1;

  (* die verstrichenen Sekunden in TTime umrechnen
    'OneSecond' ist in DateUtils definiet als Bruchteil eines Tages? *)
  SecsCountTime := SecsCount * OneSecond;

  (* ZielZeit laut EditZeitspanne.Text in TDateTime umwandeln  *)
  val := StrToDateTimeDef(EditZeitspanne.Text,0);

  (* wieviel Sekunden liegen zwischen vertrichenen Sekunden und EditZeitspanne.Text *)
  secs := SecondsBetween(SecsCountTime ,val);

  Statusbar1.SimpleText:= ' noch: ' + FormatDateTime('hh:nn:ss',val - SecsCountTime);
  TrayIcon1.Hint:=Statusbar1.SimpleText;

  {$IFDEF Linux}
    //TrayIcon1.BalloonHint:=Statusbar1.SimpleText;
    //TrayIcon1.ShowBalloonHint;

  {$ENDIF Linux}



  if secs = 0 then
  begin
     Timer1.Enabled:=false;
     TrayIcon1.Visible:=false;
     Application.MainForm.Visible := true;
     Application.ProcessMessages;

     FrmAlaram.ShowModal;
     Application.ProcessMessages;


  end;
end;

procedure TForm1.TimerEinschaltenClick(Sender: TObject);
var val : string;
begin
   val := EditZeitspanne.EditText;
   if not CheckTime(val) then
   begin
      raise Exception.Create(val + ' konnte nicht in Zeit umgewandelt werden!');
   end;


   SecsCount := 0;
   TrayIcon1.Visible:=true;
   Timer1.Enabled:= true ;
   Application.MainForm.Hide;
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  {$IFDEF Linux}
      TrayIcon1.BalloonHint:=Statusbar1.SimpleText;
      TrayIcon1.ShowBalloonHint;

  {$ENDIF Linux}
end;

procedure TForm1.UpDown1ChangingEx(Sender: TObject; var AllowChange: Boolean;
  NewValue: SmallInt; Direction: TUpDownDirection);
  var
  SelFrom, SelTo : integer;
  val : TDateTime;
begin
  (* wenn mehr als zwei Zeichen selektiert wurden
     nur die Minuten auswählen *)
  if EditZeitspanne.SelLength > 2 then
  begin
     EditZeitspanne.SelStart := 3;
     EditZeitspanne.SelLength := 2;
  end;

  (* sicherstellen, dass Stunden, Minuten, Sekunden aus
     00:00:00 selektiert werden *)
  case EditZeitspanne.SelStart of
     0..2:
     begin
        EditZeitspanne.SelStart := 0;
        EditZeitspanne.SelLength:=2;
     end;
     3..5:
     begin
       EditZeitspanne.SelStart := 3;
       EditZeitspanne.SelLength:=2;
     end;
     6..8:
     begin
       EditZeitspanne.SelStart := 6;
       EditZeitspanne.SelLength:=2;
     end;


  end;

  SelFrom := EditZeitspanne.SelStart;
  SelTo := EditZeitspanne.SelLength;


  (* Prüfung obs zu TTime konvertiert werden kann *)
  val := StrToTimeDef(EditZeitspanne.EditText,-1);
  if val = -1 then
   raise  Exception.Create(EditZeitspanne.EditText + ' konnte nicht in Zeit umgewandelt werden!');


  (* Zeit erhöhen *)
  if Direction = updUp then
  begin
     case SelFrom of
        0:
        begin
          val := incHour(Val);
        end;
        3:
        begin
          val := incMinute(Val);
        end;
        6:
        begin
          val := incSecond(Val);
        end;
     end;
  end
  (* Zeit reduzieren *)
  else if Direction = updDown then
  begin
     case SelFrom of
        0:
        begin
          val := incHour(Val,-1);
        end;
        3:
        begin
          val := incMinute(Val,-1);
        end;
        6:
        begin
          val := incSecond(Val,-1);
        end;
     end;

  end;

  (* Neuen Wert im EditZeitspanne anzeigen und Selektion rekonstruieren *)
  EditZeitspanne.Text := TimeToStr(val);
  EditZeitspanne.SelStart := SelFrom;
  EditZeitspanne.SelLength := SelTo;
  (* Anzeige updaten *)
  for  SelFrom := 0 to 3 do
  begin
  EditZeitspanne.Refresh;
  Application.ProcessMessages;
  end;

end;

function TForm1.CheckTime(ToCheck: String): boolean;
var val : string;
begin
    (* checken ob korrekte Zeit eingegeben *)
    StatusBar1.SimpleText := '';
    Result := true;
    val := EditZeitspanne.EditText;
    if StrToTimeDef(val,-1) = -1 then
    begin
     Result := false;
     StatusBar1.SimpleText := EditZeitspanne.EditText  + ' ist keine korrekte Zeit!';
    end;

end;

end.

