unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, LCLType,  DateUtils;

type

  { TFrmAlaram }

  TFrmAlaram = class(TForm)
    Edit1 : TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Timer1 : TTimer;
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Timer1StartTimer(Sender : TObject);
    procedure Timer1Timer(Sender : TObject);
  private

  public

  end;

var
  FrmAlaram: TFrmAlaram;
  SecsCount1: integer = 0;
  BlinkCount: integer = 0;


implementation

{$R *.lfm}

uses unit1;

{ TFrmAlaram }

procedure TFrmAlaram.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    FrmAlaram.Close;
    Application.Restore;
  end;
end;

procedure TFrmAlaram.FormShow(Sender: TObject);
begin
  Panel2.Caption := form1.EditZeitspanne.Caption;
  FrmAlaram.Top := 0;
  FrmAlaram.Left := 0;
  SecsCount1 := 0;
  BlinkCount := 0;
  FrmAlaram.Timer1.Enabled := true;
end;

procedure TFrmAlaram.Timer1StartTimer(Sender : TObject);
begin
  Edit1.Caption := '';
end;

procedure TFrmAlaram.Timer1Timer(Sender : TObject);
var
  val, SecsCountTime: TTime;
  secs, secs1: int64;
begin
  (* globale Variable für verstrichene Sekunden erhöhen *)
   inc(SecsCount1);

  (* die verstrichenen Sekunden in TTime umrechnen
    'OneSecond' ist in DateUtils definiet als Bruchteil eines Tages? *)
  SecsCountTime := SecsCount1 * OneSecond;


  inc(BlinkCount);

  if BlinkCount <= 10 then
  begin
    Edit1.Font.Color := clRed;
  end
  else
      Edit1.Font.Color := clDefault;

  Edit1.Text := FormatDateTime('hh:nn:ss',SecsCountTime);





end;


end.


