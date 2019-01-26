unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, LCLType;

type

  { TFrmAlaram }

  TFrmAlaram = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  FrmAlaram: TFrmAlaram;

implementation

{$R *.lfm}

uses unit1;

{ TFrmAlaram }

procedure TFrmAlaram.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Key = VK_RETURN then
  begin
    FrmAlaram.Close;
    Application.Restore;
  end;
end;

procedure TFrmAlaram.FormShow(Sender: TObject);
begin
  Panel2.Caption:= form1.EditZeitspanne.Caption;
  FrmAlaram.Top := 0;
  FrmAlaram.Left:= 0;
end;


end.

