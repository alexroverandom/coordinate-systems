type 
	TMercatorProjection = class
	constructor TMercatorProjection.Create
	
	XMercator: Double;
	YMercator: Double;
	paramHoriz: Double;
	paramVert: Double;
	canvas: TCanvas;
	latMin: Double;
	latMax: Double;
	longMin: Double;
	longMax: Double;
	
	procedure DrawMercator();
	procedure DrawPoint();
	procedure DrawParalels();
	procedure DrawMeridians();
	
end;

implementation

uses SysUtils;

constructor TMercatorProjection.Create();
begin
	
end;

procedure DrawMercator(XMercator, YMercator: Double; latMin, latMax, longMin,
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