unit FormCoordSystems;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Objects, FMX.Edit,
  FMX.ListBox, FMX.Objects3D, FMX.Types3D, FMX.Ani;

type
  TFormCoordSys = class(TForm)
    grbInputData: TGroupBox;
    lblLatitude: TLabel;
    lblLongitude: TLabel;
    lblH: TLabel;
    edtLatitudeDeg: TEdit;
    edtLongitudeDeg: TEdit;
    edtH: TEdit;
    lblX: TLabel;
    lblY: TLabel;
    lblZ: TLabel;
    expMercator: TExpander;
    expAzimut: TExpander;
    lblXMercator: TLabel;
    lblYMercator: TLabel;
    lblXAzimut: TLabel;
    lblYAzimut: TLabel;
    edtXMercator: TEdit;
    edtYMercator: TEdit;
    edtLatitudeMin: TEdit;
    edtLatitudeSec: TEdit;
    edtLongitudeMin: TEdit;
    edtLongitudeSec: TEdit;
    lblLegend: TLabel;
    edtXAzimut: TEdit;
    edtYAzimut: TEdit;
    edtXGeocenter: TEdit;
    edtYGeocenter: TEdit;
    edtZGeocenter: TEdit;
    pnlData: TPanel;
    lblInfo: TLabel;
    pnlGraphics: TPanel;
    expGeocenter: TExpander;
    pnlUP: TPanel;
    pnlDown: TPanel;
    splHorizontal: TSplitter;
    lblLatBase: TLabel;
    pnlMercatorUL: TPanel;
    splVertUp: TSplitter;
    pnlAzimutUR: TPanel;
    pnlGaussDL: TPanel;
    splVertDown: TSplitter;
    pnlCoordModel3D: TPanel;
    imgMercator: TImage;
    pnlMercatorParams: TPanel;
    lblMercatoParams: TLabel;
    chbAllMercator: TCheckBox;
    cbLatMinMercator: TComboBox;
    cbLatMaxMercator: TComboBox;
    cbLongMinMercator: TComboBox;
    cbLongMaxMercator: TComboBox;
    lblMin: TLabel;
    lblMax: TLabel;
    lblMercLat: TLabel;
    lblMercLong: TLabel;
    cbStepMercator: TComboBox;
    lblStepMercator: TLabel;
    expGauss: TExpander;
    trbCrossLatitude: TTrackBar;
    edtCrossLatitude: TEdit;
    edtXGauss: TEdit;
    edtYGauss: TEdit;
    lblXGauss: TLabel;
    lblYGauss: TLabel;
    lblNomenclatura: TLabel;
    lblScale: TLabel;
    cbScale: TComboBox;
    edtNomenclatura: TEdit;
    pnlGaussParams: TPanel;
    imgGauss: TImage;
    pnlAzimut: TPanel;
    imgAzimut: TImage;
    lblGaussParams: TLabel;
    lblAzimutParams: TLabel;
    cbLatMaxAzimut: TComboBox;
    cbLatMinAzimut: TComboBox;
    cbLongMinAzimut: TComboBox;
    cbLongMaxAzimut: TComboBox;
    lblMaxAzim: TLabel;
    lblMinAzim: TLabel;
    lblAzimLat: TLabel;
    cbStepLatAzimut: TComboBox;
    lblStepAzimut: TLabel;
    chbAllAzimut: TCheckBox;
    lblAzimLong: TLabel;
    cbStepLongAzimut: TComboBox;
    lblStepGauss: TLabel;
    vp3dGeo: TViewport3D;
    cmrGeo: TCamera;
    lghtGeo: TLight;
    mdl3dGeo: TModel3D;
    sphrGeo: TSphere;
    grd3dGeo: TGrid3D;
    btnHelpGeocenter: TButton;
    btnHelpMercator: TButton;
    btnHelpGauss: TButton;
    btnHelpAzimut: TButton;
    btnHelpGeo: TButton;
    procedure FormCreate(Sender: TObject);
    procedure pnlGraphicsResize(Sender: TObject);
    procedure edtLongitudeDegChange(Sender: TObject);
    procedure edtHChange(Sender: TObject);
    procedure edtLatitudeDegKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure chbAllMercatorChange(Sender: TObject);
    procedure cbStepMercatorChange(Sender: TObject);
    procedure trbCrossLatitudeChange(Sender: TObject);
    procedure chbAllAzimutChange(Sender: TObject);
    procedure cbStepLatAzimutChange(Sender: TObject);
    procedure imgAzimutResize(Sender: TObject);
    procedure cbScaleChange(Sender: TObject);
    procedure edtLatitudeDegChange(Sender: TObject);
    procedure btnHelpGeoClick(Sender: TObject);
    procedure btnHelpGeocenterClick(Sender: TObject);
    procedure btnHelpMercatorClick(Sender: TObject);
    procedure btnHelpGaussClick(Sender: TObject);
    procedure btnHelpAzimutClick(Sender: TObject);
  private
    procedure ShowData();
    procedure Calc(lat, long, _height: Double);
    procedure ShowOutData();
    procedure DrawData();
    procedure ClearFields();
    procedure ClearFieldsMercator();
    procedure ClearFieldsGeocentric();
    procedure ClearFieldsGauss();
    procedure ClearFieldsAzimut();
    procedure DrawMercator(X, Y: Double; latMin, latMax, longMin, longMax: Double;
      step: Integer; canvas: TCanvas);
    procedure DrawAzimut(X, Y: Double; latMin,
      latMax, longMin, longMax, stepLat, stepLong: Integer; canvas: TCanvas);
    procedure DrawGauss(X, Y, latMin, latMax, longMin, longMax, step: Double;
      canvas: TCanvas);
    procedure PreDrawMercator();
    procedure PreDrawAzimut();
    procedure PreDrawGauss();

    var
      Latitude, Longitude, gHeight, MercatorX, MercatorY,
        GeocentricX, GeocentricY, GeocentricZ, LatitudeSK_42, LongitudeSK_42,
        gHeightSK_42, AzimutX, AzimutY, GaussX, GaussY, stepGauss: Double;
        Nzone: Integer; LitZone, Nomenclatura: string;
        HTMLFile: string;
  public
    { Public declarations }
  end;

var
  FormCoordSys: TFormCoordSys;

implementation

{$R *.fmx}

uses
  Windows, Math, ShellAPI, CoordSysFunc;

procedure SetValue(i: Integer; edit: TEdit); overload; forward;
procedure SetValue(d: Double; edit: TEdit); overload; forward;
procedure SetValue(s: String; edit: TEdit); overload; forward;

procedure SetValue(i: Integer; edit: TEdit);
var onChangeOld: TNotifyEvent;
begin
  onChangeOld := edit.OnChange;
  edit.OnChange := nil;
  edit.Text := IntToStr(i);
  edit.OnChange := onChangeOld;
end;

procedure SetValue(d: Double; edit: TEdit);
var onChangeOld: TNotifyEvent;
begin
  onChangeOld := edit.OnChange;
  edit.OnChange := nil;
  edit.Text := FloatToStrF(d, ffGeneral, 11, 3);
  edit.OnChange := onChangeOld;
end;

procedure SetValue(s: String; edit: TEdit);
var onChangeOld: TNotifyEvent;
begin
  onChangeOld := edit.OnChange;
  edit.OnChange := nil;
  edit.Text := s;
  edit.OnChange := onChangeOld;
end;

procedure TFormCoordSys.btnHelpAzimutClick(Sender: TObject);
begin
  HTMLFile := 'help\azimut.html';
  ShellExecute(0, 'open', PWideChar(HTMLFile), nil, nil, SW_SHOWNORMAL);
end;

procedure TFormCoordSys.btnHelpGaussClick(Sender: TObject);
begin
  HTMLFile := 'help\gauss.html';
  ShellExecute(0, 'open', PChar(HTMLFile), nil, nil, SW_SHOWNORMAL);
end;

procedure TFormCoordSys.btnHelpGeocenterClick(Sender: TObject);
begin
  HTMLFile := 'help\geocenter.html';
  ShellExecute(0, 'open', PChar(HTMLFile), nil, nil, SW_SHOWNORMAL);
end;

procedure TFormCoordSys.btnHelpGeoClick(Sender: TObject);
begin
  HTMLFile := 'help\geographic.html';
  ShellExecute(0, 'open', PChar(HTMLFile), nil, nil, SW_SHOWNORMAL);
end;

procedure TFormCoordSys.btnHelpMercatorClick(Sender: TObject);
begin
  HTMLFile := 'help\mercator.html';
  ShellExecute(0, 'open', PChar(HTMLFile), nil, nil, SW_SHOWNORMAL);
end;

procedure TFormCoordSys.Calc(lat, long, _height: Double);
begin
  GeographicToGeocentric(lat, long, _height, GeocentricX,
     GeocentricY, GeocentricZ);
  GeographicToMercator(lat, long, MercatorX, MercatorY);
  GeographicToAzimut(lat, long, _height, DegToRad(StrToFloat(edtCrossLatitude.Text)),
     AzimutX, AzimutY);
  GeographicToGauss(lat, long, _height, false, GaussX, GaussY, Nzone, LitZone);
end;

procedure TFormCoordSys.ShowOutData();
begin
  SetValue(GeocentricX, edtXGeocenter);
  SetValue(GeocentricY, edtYGeocenter);
  SetValue(GeocentricZ, edtZGeocenter);
  SetValue(MercatorX, edtXMercator);
  SetValue(MercatorY, edtYMercator);
  SetValue(AzimutX, edtXAzimut);
  SetValue(AzimutY, edtYAzimut);
  SetValue(GaussX, edtXGauss);
  SetValue(GaussY + Nzone*1000000, edtYGauss);
end;

procedure TFormCoordSys.DrawData();
begin
  PreDrawMercator();
  PreDrawAzimut();
  PreDrawGauss();
end;

procedure TFormCoordSys.trbCrossLatitudeChange(Sender: TObject);
begin
  edtCrossLatitude.Text := IntToStr(Round(trbCrossLatitude.Value));
  GeographicToAzimut(Latitude, Longitude, gHeight, DegToRad(StrToFloat(edtCrossLatitude.Text)),
     AzimutX, AzimutY);
  ShowOutData();
  PreDrawAzimut();
end;

procedure TFormCoordSys.PreDrawMercator();
begin
  if chbAllMercator.IsChecked = true then
  begin
    // -90 and 90 cannot be used!
    DrawMercator(MercatorX, MercatorY, -89, 89, -180, 180,
      StrToInt(cbStepMercator.Selected.Text), imgMercator.Bitmap.Canvas);
  end
  else
  begin
    DrawMercator(MercatorX, MercatorY, StrToInt(cbLatMinMercator.Selected.Text),
      StrToInt(cbLatMaxMercator.Selected.Text), StrToInt(cbLongMinMercator.Selected.Text),
      StrToInt(cbLongMaxMercator.Selected.Text), StrToInt(cbStepMercator.Selected.Text),
      imgMercator.Bitmap.Canvas);
  end;
end;

procedure TFormCoordSys.PreDrawAzimut();
begin
  if chbAllAzimut.IsChecked = True then
  begin
    DrawAzimut(AzimutX, AzimutY, 0, 90, -180, 180, StrToInt(cbStepLatAzimut.Selected.Text),
      StrToInt(cbStepLongAzimut.Selected.Text), imgAzimut.Bitmap.Canvas);
  end
  else
  begin
    DrawAzimut(AzimutX, AzimutY, StrToInt(cbLatMinAzimut.Selected.Text),
      StrToInt(cbLatMaxAzimut.Selected.Text), StrToInt(cbLongMinAzimut.Selected.Text),
      StrToInt(cbLongMaxAzimut.Selected.Text), StrToInt(cbStepLatAzimut.Selected.Text),
      StrToInt(cbStepLongAzimut.Selected.Text), imgAzimut.Bitmap.Canvas);
  end;
end;

procedure TFormCoordSys.PreDrawGauss();
var latMin, latMax, longMin, longMax, step: Double;
begin
  GetListGauss(Latitude, Longitude, GetScaleFactor(cbScale.Selected.Text),
    latMin, latMax, longMin, longMax, step);
    if step >= 1 then
    begin
      stepGauss := step;
      lblStepGauss.Text := IntToStr(Round(stepGauss)) + ' deg';
    end
    else
    if step >= (1/60) then
    begin
      stepGauss := step * 60;
      lblStepGauss.Text := IntToStr(Round(stepGauss)) + #39;
    end
    else
    begin
      stepGauss := step * 3600;
      lblStepGauss.Text := IntToStr(Round(stepGauss)) + #39 + #39;
    end;
  DrawGauss(GaussX, GaussY, latMin, latMax, longMin, longMax, step,
    imgGauss.Bitmap.Canvas);
end;

procedure TFormCoordSys.cbScaleChange(Sender: TObject);
begin
  PreDrawGauss();
end;

procedure TFormCoordSys.cbStepLatAzimutChange(Sender: TObject);
begin
  PreDrawAzimut();
end;

procedure TFormCoordSys.cbStepMercatorChange(Sender: TObject);
begin
  if (StrToInt(cbLatMinMercator.Selected.Text) < StrToInt(cbLatMaxMercator.Selected.Text))
     or (StrToInt(cbLongMinMercator.Selected.Text) < StrToInt(cbLongMaxMercator.Selected.Text)) then
  begin
    PreDrawMercator();
  end
  else
  begin
    imgMercator.Bitmap.Clear(TAlphaColors.White);
    imgMercator.Repaint;
  end;
end;

procedure TFormCoordSys.chbAllMercatorChange(Sender: TObject);
begin
  if chbAllMercator.IsChecked = true then
  begin
    cbLatMinMercator.Enabled := False;
    cbLatMaxMercator.Enabled := False;
    cbLongMinMercator.Enabled := False;
    cbLongMaxMercator.Enabled := False;
    PreDrawMercator();
  end
  else
  begin
    cbLatMinMercator.Enabled := True;
    cbLatMaxMercator.Enabled := True;
    cbLongMinMercator.Enabled := True;
    cbLongMaxMercator.Enabled := True;
    PreDrawMercator();
  end;
end;

procedure TFormCoordSys.chbAllAzimutChange(Sender: TObject);
begin
  if chbAllAzimut.IsChecked = true then
  begin
    cbLatMinAzimut.Enabled := False;
    cbLatMaxAzimut.Enabled := False;
    cbLongMinAzimut.Enabled := False;
    cbLongMaxAzimut.Enabled := False;
    PreDrawAzimut();
  end
  else
  begin
    cbLatMinAzimut.Enabled := True;
    cbLatMaxAzimut.Enabled := True;
    cbLongMinAzimut.Enabled := True;
    cbLongMaxAzimut.Enabled := True;
    PreDrawAzimut();
  end;
end;

procedure TFormCoordSys.edtHChange(Sender: TObject);
var _height: Double;
begin
  ClearFields();
  try
    _height := StrToFloat(edtH.Text);
    gHeight := _height;
    Calc(Latitude, Longitude, gHeight);
    ShowOutData();
  except
    on EConvertError do
  end;
end;

procedure TFormCoordSys.edtLatitudeDegChange(Sender: TObject);
var deg, min, sec: Double;
begin
  ClearFields();
  try
    deg := StrToFloat(edtLatitudeDeg.Text);
    if (deg < 90) and (deg > -90) then
    begin
      min := StrToFloat(edtLatitudeMin.Text);
      if (min > 60)or(min < 0) then
      begin
        min := 0;
      end;
      sec := StrToFloat(edtLatitudeSec.Text);
      if (sec > 60)or(sec < 0) then
      begin
        sec := 0;
      end;
      Latitude := DmsToRad(deg, min, sec);
      ShowData();
    end
    else
    begin
      if deg >= 90 then
      begin
        deg := 90;
      end
      else
      begin
        deg := -90;
      end;
      min := 0;
      sec := 0;
      Latitude := DmsToRad(deg, min, sec);
      ShowData();
    end;
    Calc(Latitude, Longitude, gHeight);
    ShowOutData();
    DrawData();
  except
   on EConvertError do
  end;
end;

procedure TFormCoordSys.edtLatitudeDegKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
var OnChange: TNotifyEvent;
begin
  OnChange := TEdit(Sender).OnChange;
  if @OnChange <> nil then
    OnChange(Sender);
end;

procedure TFormCoordSys.edtLongitudeDegChange(Sender: TObject);
var deg, min, sec: Double;
begin
  ClearFields();
  try
    deg := StrToFloat(edtLongitudeDeg.Text);
    if (deg < 180) and (deg > -180) then
    begin
      min := StrToFloat(edtLongitudeMin.Text);
      if (min > 60)or(min < 0) then
      begin
        min := 50;
      end;
      sec := StrToFloat(edtLongitudeSec.Text);
      if (sec > 60)or(sec < 0) then
      begin
        sec := 50;
      end;
      Longitude := DmsToRad(deg, min, sec);
      ShowData();
    end
    else
    begin
      if deg >= 180 then
      begin
        deg := 179;
      end
      else
      begin
        deg := -179;
      end;
      min :=50;
      sec := 50;
      Longitude := DmsToRad(deg, min, sec);
      ShowData();
    end;
    Calc(Latitude, Longitude, gHeight);
    ShowOutData();
    DrawData();
  except
    on EConvertError do
  end;
end;

procedure TFormCoordSys.FormCreate(Sender: TObject);
var
  I, counter: Integer; onResize: TNotifyEvent;
begin
  onResize := imgAzimut.OnResize;
  imgAzimut.OnResize := nil;
  HTMLFile := 'help/geographic.html';
  // Set values to Comboboxes of Mercator and stereographic visualization params
  for counter := -4 to 4 do
  begin
    I:= counter * 20;
    cbLatMinMercator.Items.Add(IntToStr(I));
    cbLatMaxMercator.Items.Add(IntToStr(I));
    if I >= 0 then
    begin
      cbLatMinAzimut.Items.Add(IntToStr(I));
      cbLatMaxAzimut.Items.Add(IntToStr(I));
    end;
  end;
  for counter := -9 to 9 do
  begin
    I := counter * 20;
    cbLongMinMercator.Items.Add(IntToStr(I));
    cbLongMaxMercator.Items.Add(IntToStr(I));
    cbLongMinAzimut.Items.Add(IntToStr(I));
    cbLongMaxAzimut.Items.Add(IntToStr(I));
  end;
  // Set step param of Mercator's and stereographic's projections visualization
  cbStepMercator.Items.Add(IntToStr(5));
  cbStepMercator.Items.Add(IntToStr(10));
  cbStepMercator.Items.Add(IntToStr(20));
  cbStepLatAzimut.Items.Add(IntToStr(5));
  cbStepLatAzimut.Items.Add(IntToStr(10));
  cbStepLatAzimut.Items.Add(IntToStr(20));
  cbStepLongAzimut.Items.Add(IntToStr(5));
  cbStepLongAzimut.Items.Add(IntToStr(10));
  cbStepLongAzimut.Items.Add(IntToStr(20));

  // Set List of scales
  cbScale.Items.Add('1:1000000');
  cbScale.Items.Add('1:500000');
  cbScale.Items.Add('1:100000');
  cbScale.Items.Add('1:50000');
  cbScale.Items.Add('1:25000');
  cbScale.Items.Add('1:10000');

  // Set geographic coords of Kiev as default values
  Latitude := DmsToRad(50,27,01);
  Longitude := DmsToRad(30,31,22);
  gHeight := 202;
  ShowData();
  Calc(Latitude, Longitude, gHeight);
  ShowOutData();
  // Make an equivalent size of all graphic panels
  pnlGraphicsResize(nil);
  imgMercator.Bitmap.SetSize(Round(imgMercator.Width), Round(imgMercator.Height));
  imgAzimut.Bitmap.SetSize(Round(imgAzimut.Width), Round(imgAzimut.Height));
  imgGauss.Bitmap.SetSize(Round(imgGauss.Width), Round(imgGauss.Height));
  imgMercator.Bitmap.Canvas.Fill.Color := TAlphaColors.Black;
  imgMercator.Bitmap.Canvas.Font.Size := 10;
  imgAzimut.Bitmap.Canvas.Fill.Color := TAlphaColors.Black;
  imgAzimut.Bitmap.Canvas.Font.Size := 10;
  imgGauss.Bitmap.Canvas.Fill.Color := TAlphaColors.Black;
  imgGauss.Bitmap.Canvas.Font.Size := 10;
  imgMercator.Bitmap.Canvas.Stroke.Color := TAlphaColors.Blue;
  imgAzimut.Bitmap.Canvas.Stroke.Color := TAlphaColors.Blue;
  imgGauss.Bitmap.Canvas.Stroke.Color := TAlphaColors.Blue;
  DrawData();
  imgAzimut.OnResize := onResize;
end;

procedure TFormCoordSys.imgAzimutResize(Sender: TObject);
begin
  imgMercator.Bitmap.SetSize(Round(imgMercator.Width), Round(imgMercator.Height));
  imgAzimut.Bitmap.SetSize(Round(imgAzimut.Width), Round(imgAzimut.Height));
  imgGauss.Bitmap.SetSize(Round(imgGauss.Width), Round(imgGauss.Height));
  DrawData();
end;

procedure TFormCoordSys.pnlGraphicsResize(Sender: TObject);
begin
  pnlUP.Height := (pnlGraphics.Height - splHorizontal.Height) / 2;
  pnlMercatorUL.Width := (pnlGraphics.Width - splVertUp.Width) / 2;
  pnlGaussDL.Width := (pnlGraphics.Width - splVertDown.Width) / 2;
end;

procedure TFormCoordSys.ShowData();
begin
  // Set values to Latitude edits
  SetValue(RadToDegInDms(Latitude), edtLatitudeDeg);
  SetValue(RadToMinInDms(Latitude), edtLatitudeMin);
  SetValue(RadToSecInDms(Latitude), edtLatitudeSec);

  // Set values to Longitude edits
  SetValue(RadToDegInDms(Longitude), edtLongitudeDeg);
  SetValue(RadToMinInDms(Longitude), edtLongitudeMin);
  SetValue(RadToSecInDms(Longitude), edtLongitudeSec);

  // Set values to Height edit
  SetValue(gHeight, edtH);
end;

procedure TFormCoordSys.ClearFields();
begin
  ClearFieldsMercator();
  ClearFieldsGeocentric();
  ClearFieldsGauss();
  ClearFieldsAzimut();
end;

procedure TFormCoordSys.ClearFieldsGauss();
begin
  SetValue('', edtXGauss);
  SetValue('', edtYGauss);
end;

procedure TFormCoordSys.ClearFieldsAzimut();
begin
  SetValue('', edtXAzimut);
  SetValue('', edtYAzimut);
end;

procedure TFormCoordSys.ClearFieldsMercator();
begin
  SetValue('', edtXMercator);
  SetValue('', edtYMercator);
end;

procedure TFormCoordSys.ClearFieldsGeocentric();
begin
  SetValue('', edtXGeocenter);
  SetValue('', edtYGeocenter);
  SetValue('', edtZGeocenter);
end;

procedure TFormCoordSys.DrawMercator(X, Y: Double; latMin, latMax, longMin,
   longMax: Double; step: Integer; canvas: TCanvas);
var XMaxPaint, YMaxPaint, Lat, Long: Integer;
  pointStart, pointStop: TPointF; Xmin, Ymin, Xmax, Ymax, horiz, vert,
  paramMercatorHoriz, paramMercatorVert, _x, _y: Double; _temp: string;
  rect: TRectF; rectText: TRectF; pointText : TPointF;
begin
  // Clear Bitmap to get empty Canvas to draw
  imgMercator.Bitmap.Clear(TAlphaColors.White);
  if (latMin < latMax) and (longMin < longMax) then
  begin
    // Set borders for paint
    YMaxPaint := Round(imgMercator.Height-40);
    XMaxPaint := Round(imgMercator.Width-40);
    // Find Min and Max Coords for visualization
    GeographicToMercator(DegToRad(latMin), DegToRad(longMin), Xmin, Ymin);
    GeographicToMercator(DegToRad(latMax), DegToRad(longMax), Xmax, Ymax);
    horiz := Xmax - Xmin;
    vert := Ymax - Ymin;
    // Params of convertation to screen coords
    paramMercatorVert := YMaxPaint/vert;
    paramMercatorHoriz := XMaxPaint/horiz;
    Lat := Round(latMin);
    Long := Round(longMin);
    with canvas do
    begin
      if Lat < -80 then
      begin
        Lat := -80;
      end;
      canvas.BeginScene();
      canvas.Stroke.Color := TAlphaColors.Blue;
      // Draw meridians
      while Long <= longMax do
      begin
        GeographicToMercator(DegToRad(latMin), DegToRad(Long), _x, _y);
        pointStart := TPointF.Create(Round((_x - Xmin)*paramMercatorHoriz) + 20,
          Round((vert - (_y - Ymin))*paramMercatorVert) + 20);
        GeographicTOMercator(DegToRad(latMax), DegToRad(Long), _x, _y);
        pointStop := TPointF.Create(Round((_x - Xmin)*paramMercatorHoriz + 20),
          Round((vert - (_y - Ymin))*paramMercatorVert) + 20);
        canvas.DrawLine(pointStart, pointStop, 100);
        // Draw numeration of Longitudes ... -20, 0, 20, 40, 60 ...
        if (Long mod 20) = 0 then
        begin
          canvas.Fill.Color := TAlphaColors.Black;
          pointText := TPointF.Create(pointStart.X - 10, pointStart.Y + 2);
          rectText := TRectF.Create(pointText, 20, 18);
          canvas.FillText(rectText, IntToStr(Abs(Long)), False, 100,
            [TFillTextFlag.ftRightToLeft], TTextAlign.taCenter, TTextAlign.taCenter);
          pointText := TPointF.Create(pointStop.X - 10, pointStop.Y - 16);
          rectText := TRectF.Create(pointText, 20, 14);
          canvas.FillText(rectText, IntToStr(Abs(Long)), False, 100,
            [TFillTextFlag.ftRightToLeft], TTextAlign.taCenter, TTextAlign.taCenter);
        end;
        Long := Long + step;
      end;
      // Draw parallels
      while Lat <= latMax do
      begin
        GeographicToMercator(DegToRad(Lat), DegToRad(longMin), _x, _y);
        pointStart := TPointF.Create(Round((_x - Xmin)*paramMercatorHoriz) + 20,
          Round((vert - (_y - Ymin))*paramMercatorVert) + 20);
        GeographicTOMercator(DegToRad(Lat), DegToRad(longMax), _x, _y);
        pointStop := TPointF.Create(Round((_x - Xmin)*paramMercatorHoriz + 20),
          Round((vert - (_y - Ymin))*paramMercatorVert) + 20);
        canvas.DrawLine(pointStart, pointStop, 100);
        // Draw numeration of Latitudes ... 0, 20, 40 ...
        if (Lat mod 20) = 0 then
        begin
          pointText := TPointF.Create(pointStart.X - 18, pointStart.Y -6);
          rectText := TRectF.Create(pointText, 16, 12);
          canvas.FillText(rectText, IntToStr(Abs(Lat)), False, 100,
            [TFillTextFlag.ftRightToLeft], TTextAlign.taCenter, TTextAlign.taCenter);
          pointText := TPointF.Create(pointStop.X + 2, pointStop.Y - 6);
          rectText := TRectF.Create(pointText, 16, 12);
          canvas.FillText(rectText, IntToStr(Abs(Lat)), False, 100,
            [TFillTextFlag.ftRightToLeft], TTextAlign.taCenter, TTextAlign.taCenter);
        end;
        Lat := Lat + step;
      end;
      // Draw point that has input geographic coords
      pointStart := TPointF.Create(Round((X - Xmin)*paramMercatorHoriz) + 20,
          Round((vert - (Y - Ymin))*paramMercatorVert) + 20);
      rect := TRectF.Create(pointStart.X - 3, pointStart.Y - 3,
        pointStart.X + 3, pointStart.Y + 3);
      Canvas.Fill.Color := TAlphaColors.Red;
      canvas.FillEllipse(rect, 100);
      Canvas.Fill.Color := TAlphaColors.Black;
      canvas.EndScene();
    end;
  end;
  imgMercator.Repaint();
end;

procedure TFormCoordSys.DrawAzimut(X, Y: Double; latMin,
  latMax, longMin, longMax, stepLat, stepLong: Integer; canvas: TCanvas);
var XMaxPaint, YMaxPaint, rAzimut, Xmin, Xmax, Ymin, Ymax, _x, _y, paramTransform,
  paramVert, horiz, vert: Double; dx, dy, _longText: Integer;
  centerX, centerY, R, Rmax, Lat, Long: Integer; rect, rectText: TRectF;
  pointStart, pointStop, pointCenter, pointRadius, pointText: TPointF;
begin
  imgAzimut.Bitmap.Clear(TAlphaColors.Lightskyblue);
  canvas.Fill.Color := TAlphaColors.Black;
  if (latMin < latMax) then
  begin
    YMaxPaint := Round(imgAzimut.Height-40);
    XMaxPaint := Round(imgAzimut.Width-40);
    centerX := Round(imgAzimut.Width / 2);
    centerY := Round(imgAzimut.Height / 2);
    GeographicToAzimut(DegToRad(latMin), DegToRad(0), gHeight,
      DegToRad(StrToInt(edtCrossLatitude.Text)), _x, _y);
    horiz := _x * 2;
    vert := _x * 2;
    paramTransform := YMaxPaint / vert;
    Rmax := Round(_x * paramTransform);
    pointCenter := TPointF.Create(centerX, centerY);
    Lat := Round(latMin);
    Long := Round(longMin);
    // Draw section
    with canvas do
    begin
      canvas.BeginScene();
      canvas.Fill.Color := TAlphaColors.White;
      canvas.Stroke.Color := TAlphaColors.Blue;
      while Long >= longMax do
      begin
        longMax := longMax + 360;
      end;
      // Draw Meridians
      while Long <= longMax do
      begin
        pointStart := TPointF.Create(centerX + Rmax * Cos(DegToRad(Long)),
          centerY - Rmax * Sin(DegToRad(Long)));
        GeographicToAzimut(DegToRad(latMax), DegToRad(0), gHeight,
          DegToRad(StrToInt(edtCrossLatitude.Text)), _x, _y);
        rAzimut := _x;
        R := Round(rAzimut * paramTransform);
        pointStop := TPointF.Create(centerX + R * Cos(DegToRad(Long)),
          centerY - R * Sin(DegToRad(Long)));
        canvas.DrawLine(pointStart, pointStop, 100);
        Canvas.Fill.Color := TAlphaColors.Black;
        // Draw longitude values of meridians that are devided by 20
        if (Long mod 20) = 0 then
        begin
          _longText := Long;
          while _longText > 180 do
          begin
            _longText := _longText - 360;
          end;
          pointText := TPointF.Create(centerX+(Rmax+10)*(pointStart.X-centerX)/Rmax - 11,
            centerY+(Rmax+10)*(pointStart.Y-centerY)/Rmax - 10);
          rectText := TRectF.Create(pointText, 20, 18);
          canvas.FillText(rectText, IntToStr(Abs(_longText)), False, 100,
            [TFillTextFlag.ftRightToLeft], TTextAlign.taCenter, TTextAlign.taCenter);
        end;
        Long := Long + stepLong;
      end;
      // Draw paralels as arcs of ellipse with a=b=R
      while Lat <= latMax do
      begin
        GeographicToAzimut(DegToRad(Lat), DegToRad(0), gHeight,
          DegToRad(StrToInt(edtCrossLatitude.Text)), _x, _y);
        rAzimut := _x;
        R := Round(rAzimut * paramTransform);
        pointRadius := TPointF.Create(R, R);
        canvas.DrawArc(pointCenter, pointRadius, GetStartAngle(longMax),
          GetArcAngle(longMin, longMax), 100);
        // Draw latitude values of paralels that are devided by 20
        if (Lat mod 20) = 0 then
        begin
          dx := 0;
          dy := 0;
          if longMax = 0 then
          begin
            dx := -12;
          end;
            pointText := TPointF.Create(centerX + Round(R*Cos(DegToRad(GetStartAngle(longMax)))+1+dx),
              centerY + Round(R*Sin(DegToRad(GetStartAngle(longMax))))+dy);
            rectText := TRectF.Create(pointText, 10, 10);
            canvas.FillText(rectText, IntToStr(Abs(Lat)), False, 100,
              [TFillTextFlag.ftRightToLeft], TTextAlign.taCenter, TTextAlign.taCenter);
          dx := 0;
          dy := 0;
          if longMin = 0 then
          begin
            dx := -12;
          end;
          pointText := TPointF.Create(centerX + Round(R*Cos(DegToRad(GetStartAngle(longMin)))+1+dx),
            centerY + Round(R*Sin(DegToRad(GetStartAngle(longMin))))+dy);
          rectText := TRectF.Create(pointText, 10, 10);
          canvas.FillText(rectText, IntToStr(Abs(Lat)), False, 100,
            [TFillTextFlag.ftRightToLeft], TTextAlign.taCenter, TTextAlign.taCenter);
        end;
        Lat := Lat + stepLat;
      end;
      // Draw point with input geographic coords
      Canvas.Fill.Color := TAlphaColors.Black;
      pointStart := TPointF.Create(centerX + Round(X*paramTransform),
        centerY - Round(Y*paramTransform));
      rect := TRectF.Create(pointStart.X - 3, pointStart.Y - 3,
        pointStart.X + 3, pointStart.Y + 3);
      Canvas.Fill.Color := TAlphaColors.Red;
      canvas.FillEllipse(rect, 100);
      Canvas.Fill.Color := TAlphaColors.Black;
      canvas.EndScene();
    end;
  end;
  imgAzimut.Repaint();
end;

procedure TFormCoordSys.DrawGauss(X, Y, latMin, latMax, longMin, longMax, step
  : Double; canvas: TCanvas);
var XMaxPaint, YMaxPaint: Integer;
  pointStart, pointStop: TPointF; Xmin, Ymin, Xmax, Ymax, horiz, vert,
  paramGaussHoriz, paramGaussVert, _x, _y, Lat, Long: Double; _temp: string;
  rect: TRectF; rectText: TRectF; pointText : TPointF; I, J: Integer;
begin
  imgGauss.Bitmap.Clear(TAlphaColors.White);
  // Set borders for paint
  YMaxPaint := Round(imgGauss.Height-40);
  XMaxPaint := Round(imgGauss.Width-80);
  // Find Min and Max Coords for visualization
  GeographicToGauss(DegToRad(latMin), DegToRad(longMin), Nzone, Xmin, Ymin);
  GeographicToGauss(DegToRad(latMin), DegToRad(longMax), Nzone, _x, Ymax);
  //Ymax := 500000 - (Ymax - 500000);
  GeographicToGauss(DegToRad(latMax), DegToRad(longMax), Nzone, Xmax, _y);
  if Ymax < _y then
  begin
    Ymax := _y;
  end;
  vert := Abs(Xmax - Xmin);
  horiz := Abs(Ymax - Ymin);
  // Params of convertation to screen coords
  paramGaussHoriz := XMaxPaint/horiz;
  paramGaussVert := YMaxPaint/vert;
  Lat := latMin;
  Long := longMin;
  //Draw section
  canvas.BeginScene();
  canvas.Stroke.Color := TAlphaColors.Blue;
  // Draw meridians
  for I := 0 to Round((longMax-longMin)/step) do
  begin
    Long := longMin + I * step;
    GeographicToGauss(DegToRad(latMin), DegToRad(Long), Nzone, _x, _y);
    pointStart := TPointF.Create(Round((_y - Ymin)*paramGaussHoriz) + 40,
      Round((vert - (_x - Xmin))*paramGaussVert) + 20);
    GeographicToGauss(DegToRad(latMax), DegToRad(Long), Nzone, _x, _y);
    pointStop := TPointF.Create(Round((_y - ymin)*paramGaussHoriz + 40),
      Round((vert - (_x - Xmin))*paramGaussVert) + 20);
    if (Long = longMin) or (Long = longMax) then
    begin
      canvas.Stroke.Color := TAlphaColors.Blueviolet;
    end;
    canvas.DrawLine(pointStart, pointStop, 100);
    canvas.Stroke.Color := TAlphaColors.Blue;
    // Longitude's numbers are drawing
      canvas.Fill.Color := TAlphaColors.Black;
      pointText := TPointF.Create(pointStart.X - 10, pointStart.Y + 2);
      rectText := TRectF.Create(pointText, 25, 18);
      canvas.FillText(rectText, FloatToStrF(Abs(Long), ffGeneral, 4,2), False, 100,
        [TFillTextFlag.ftRightToLeft], TTextAlign.taCenter, TTextAlign.taCenter);
      pointText := TPointF.Create(pointStop.X - 10, pointStop.Y - 16);
      rectText := TRectF.Create(pointText, 25, 14);
      canvas.FillText(rectText, FloatToStrF(Abs(Long), ffGeneral, 4,2), False, 100,
        [TFillTextFlag.ftRightToLeft], TTextAlign.taCenter, TTextAlign.taCenter);
  end;
  // Draw parallels
  for I := 0 to Round((latMax-latMin)/step) do
  begin
    Lat := latMin + I * step;
      // Draw lines of paralel between two meridians
    Long := longMin;
    for J := 0 to Round((longMax-longMin)/step)-1 do
    begin
      Long := longMin + J * step;
      GeographicToGauss(DegToRad(Lat), DegToRad(Long), Nzone, _x, _y);
      pointStart := TPointF.Create(Round((_y - Ymin)*paramGaussHoriz) + 40,
        Round((vert - (_x - Xmin))*paramGaussVert) + 20);
      GeographicToGauss(DegToRad(Lat), DegToRad(Long + step), Nzone, _x, _y);
      pointStop := TPointF.Create(Round((_y - Ymin)*paramGaussHoriz + 40),
        Round((vert - (_x - Xmin))*paramGaussVert) + 20);
      if (Lat = latMin) or (Lat = latMax) then
      begin
        canvas.Stroke.Color := TAlphaColors.Blueviolet;
      end;
      canvas.DrawLine(pointStart, pointStop, 100);
      canvas.Stroke.Color := TAlphaColors.Blue;
    end;
    // find points to text position
    GeographicToGauss(DegToRad(Lat), DegToRad(longMin), Nzone, _x, _y);
    pointStart := TPointF.Create(Round((_y - Ymin)*paramGaussHoriz) + 40,
      Round((vert - (_x - Xmin))*paramGaussVert) + 20);
    GeographicToGauss(DegToRad(Lat), DegToRad(longMax), Nzone, _x, _y);
    pointStop := TPointF.Create(Round((_y - Ymin)*paramGaussHoriz + 40),
      Round((vert - (_x - Xmin))*paramGaussVert) + 20);
    // Draw numeration of Latitudes ...
    pointText := TPointF.Create(pointStart.X - 25, pointStart.Y -6);
    rectText := TRectF.Create(pointText, 25, 12);
    canvas.FillText(rectText, FloatToStrF(Abs(Lat), ffGeneral, 4,2), False, 100,
      [TFillTextFlag.ftRightToLeft], TTextAlign.taCenter, TTextAlign.taCenter);
    pointText := TPointF.Create(pointStop.X + 2, pointStop.Y - 6);
    rectText := TRectF.Create(pointText, 25, 12);
    canvas.FillText(rectText, FloatToStrF(Abs(Lat), ffGeneral, 4,2), False, 100,
      [TFillTextFlag.ftRightToLeft], TTextAlign.taCenter, TTextAlign.taCenter);
  end;
  // Draw point that has input geographic coords
  if Longitude >= 0 then
  begin
    pointStart := TPointF.Create(Round((Y - Ymin)*paramGaussHoriz) + 40,
      Round((vert - (X - Xmin))*paramGaussVert) + 20);
    rect := TRectF.Create(pointStart.X - 3, pointStart.Y - 3,
      pointStart.X + 3, pointStart.Y + 3);
    Canvas.Fill.Color := TAlphaColors.Red;
    canvas.FillEllipse(rect, 100);
  end
  else
  begin
    pointStart := TPointF.Create(Round(((Y) - Ymin)*paramGaussHoriz) + 40,
      Round((vert - (X - Xmin))*paramGaussVert) + 20);
    rect := TRectF.Create(pointStart.X - 3, pointStart.Y - 3,
      pointStart.X + 3, pointStart.Y + 3);
    Canvas.Fill.Color := TAlphaColors.Red;
    canvas.FillEllipse(rect, 100);
  end;
  Canvas.Fill.Color := TAlphaColors.Black;
  canvas.EndScene();
  // Find and show "Nomenclatura"
  Nomenclatura := GetNomenclatura(GetScaleFactor(cbScale.Selected.Text), Nzone,
    LitZone, Latitude, Longitude);
  SetValue(Nomenclatura, edtNomenclatura);
end;

end.
