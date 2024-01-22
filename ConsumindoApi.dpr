program ConsumindoApi;

uses
  Vcl.Forms,
  UConsumindoApi in 'UConsumindoApi.pas' {FConsumindoApi},
  UJsonDTO in 'UJsonDTO.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFConsumindoApi, FConsumindoApi);
  Application.Run;
end.
