program CoordSystems;

uses
  System.SysUtils,
  FMX.Forms,
  FormCoordSystems in 'Forms\FormCoordSystems.pas' {FormCoordSys},
  CoordSysFunc in 'Modules\CoordSysFunc.pas';

{$R *.res}

begin
  FormatSettings.DecimalSeparator := '.';
  Application.Initialize;
  Application.CreateForm(TFormCoordSys, FormCoordSys);
  Application.Run;
end.
