program flog;

uses
  Forms,
  UFormMain in '..\Source\UFormMain.pas' {frmMain},
  UFormView in '..\Source\UFormView.pas' {frmView},
  UClassView in '..\Source\UClassView.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
