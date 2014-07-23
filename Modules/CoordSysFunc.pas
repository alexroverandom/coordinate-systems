unit CoordSysFunc;

interface

function RadToDegInDms(rad: double): Integer;
function RadToMinInDms(rad: double): Integer;
function RadToSecInDms(rad: double): Integer;
function GetCompres(a, b: Double): Double;
function GetExcentr(): Double;
function GetExcentr1(): Double;
function GetExcentrKras(): Double;
function GetExcentr1Kras(): Double;
function DmsToRad(deg, min, sec: Double): Double;
function GetDmsToRad(degStr, minStr, secStr: string): Double;
// using procedures where variables are passed as parameters
procedure RadToDms(rad: Double; var deg, min, sec: Double);
procedure GeographicToMercator(lat, long: Double; var _x, _y: Double);
procedure GeographicToGeocentric(lat, long, height: Double; var _x, _y, _z: Double);
procedure GeographicToLambert(lat, long, latMin, latMax, lat0, long0: Double;
  var _x, _y: Double);
procedure WGS_84ToSK_42(lat, long, heig: Double; var _lat, _long, _heig: Double);
procedure GeographicToAzimut(lat, long, heig, crossLat: Double; var _x, _y: Double);
procedure GeographicToGauss(lat, long, heig: Double; isKrasovsky: Boolean;
  var _x, _y: Double; var Nzone: Integer; var LitZone: string); overload;
procedure GeographicToGauss(lat, long: Double; Nzone: Integer;
  var _x, _y: Double); overload;
procedure GetMeridianArcValue(latMin, latMax: Double; var Xlat: Double);
procedure GetModelCoords(lat, long: Double; var i, j: Integer);
procedure GetListGauss(lat, long: Double; scale: Integer;
   var latMin, latMax, longMin, longMax, step: Double);
procedure GetListGauss1000(lat, long: Double;
   var latMin, latMax, longMin, longMax, step: Double);
procedure GetListGauss500(lat, long: Double;
   var latMin, latMax, longMin, longMax, step: Double);
procedure GetListGauss100(lat, long: Double;
   var latMin, latMax, longMin, longMax,step: Double);
procedure GetListGauss50(lat, long: Double;
   var latMin, latMax, longMin, longMax, step: Double);
procedure GetListGauss25(lat, long: Double;
   var latMin, latMax, longMin, longMax, step: Double);
procedure GetListGauss10(lat, long: Double;
   var latMin, latMax, longMin, longMax, step: Double);
function DegSingle(deg: Integer): Integer;
function GetArcAngle(longMin, longMax: Integer): Integer;
function GetStartAngle(longMax: Integer): Integer;
function RadToSec(rad: Double): Double;
function DegToSec(deg: Double): Double;
function GetScaleFactor(scale: string): Integer;
function GetNomenclatura(scale: Integer; nZone: Integer; const litZone: string;
  lat, long: Double): string;
procedure Devide4(lat, long: Double; depth: Integer; latMin, latMax, longMin,
  longMax: Double; var nomencl: string);

implementation

uses System.SysUtils, Math;

const
  BIG_ELIPSE_PARAM = 6378137;
  SMALL_ELIPSE_PARAM = 6356752.3142;
  BIG_ELIPSE_PARAM_KRASOVSKY = 6378245;
  SMALL_ELIPSE_PARAM_KRASOVSKY = 6356863.0188;
  RAD_IN_SEC = 206264.8062;
  // parameters of transformation WGS-84 to SK-42 (Krasovsky)
  _DX = 23.92;
  _DY = -141.27;
  _DZ = -80.9;
  RAD_SEC = 206265;
  Zones: array[1..23] of string = ('A','B','C','D','E','F','G','H','I','J','K',
    'L','M','N','O','P','Q','R','S','T','U','V','W');
  NomenclArray : array[1..12] of string = ('À', 'Á', 'Â', 'Ã', 'à', 'á', 'â',
    'ã', '1', '2', '3', '4');
// excentricities of WGS-84
function GetExcentr(): Double;
begin
  Result := Sqrt(1 - (Sqr(SMALL_ELIPSE_PARAM / BIG_ELIPSE_PARAM)));
end;

function GetExcentr1(): Double;
begin
  Result := Sqrt(Sqr(BIG_ELIPSE_PARAM / SMALL_ELIPSE_PARAM) - 1);
end;

// excentricities of Krasovsky ellipsoide
function GetExcentrKras(): Double;
begin
  Result := Sqrt(1 - (Sqr(SMALL_ELIPSE_PARAM_KRASOVSKY / BIG_ELIPSE_PARAM_KRASOVSKY)));
end;

function GetExcentr1Kras(): Double;
begin
  Result := Sqrt(Sqr(BIG_ELIPSE_PARAM_KRASOVSKY / SMALL_ELIPSE_PARAM_KRASOVSKY) - 1);
end;

// Compression of ellipsoide
function GetCompres(a, b: Double): Double;
begin
  Result := (a - b) / a;
end;

function RadToDegInDms(rad: double): Integer;
var degDouble: Double;
begin
  degDouble:= rad * 180 / Pi;
  Result:= Trunc(degDouble);
end;

function RadToMinInDms(rad: double): Integer;
var degDouble, minDouble: Double;
begin
  degDouble:= rad * 180 / Pi;
  minDouble:= Frac(degDouble) * 60;
  Result:= Trunc(minDouble);
end;

function RadToSecInDms(rad: double): Integer;
var degDouble, minDouble, secDouble: Double;
begin
  degDouble:= rad * 180 / Pi;
  minDouble:= Frac(degDouble) * 60;
  secDouble:= Frac(minDouble) * 60;
  Result := Trunc(secDouble);
end;

procedure RadToDms(rad: Double; var deg, min, sec: Double);
var degDouble, minDouble, secDouble: Double;
begin
  degDouble := rad * 180 / Pi;
  deg := Trunc(degDouble);
  minDouble := Frac(degDouble) * 60;
  min := Trunc(minDouble);
  secDouble := Frac(minDouble) * 60;
  sec := Trunc(secDouble);
end;

function DegToSec(deg: Double): Double;
begin
  Result := deg * 3600;
end;

function RadToSec(rad: Double): Double;
begin
  Result := rad * (180 / Pi) * 3600;
end;

function DmsToRad(deg, min, sec: Double): Double;
var rad: Double;
begin
  if deg>=0 then
  begin
    min:= min + sec / 60;
    deg:= deg + min / 60;
    rad:= deg * Pi / 180;
  end
  else
  begin
    min:= min - sec / 60;
    deg:= deg - min / 60;
    rad:= deg * Pi / 180;
  end;
  Result:= rad;
end;

// Transform input text values of Latitudes and Longitudes to radians
function GetDmsToRad(degStr, minStr, secStr: string): Double;
var deg, min, sec: Double;
begin
  deg:= StrToFloat(degStr);
  min:= StrToFloat(minStr);
  sec:= StrToFloat(secStr);
  Result:= DmsToRad(deg, min, sec);
end;

procedure GeographicToMercator(lat, long: Double; var _x, _y: Double);
var e: Double;
begin
  _x:= BIG_ELIPSE_PARAM * long;
  e := GetExcentr();
  _y:= BIG_ELIPSE_PARAM * Ln((Tan(lat/2 + pi/4))*
    (Power((1-e*Sin(lat))/(1+e*Sin(lat)),(e/2))));
end;

// think that Earth is sphere
procedure GeographicToGeocentric(lat, long, height: Double; var _x, _y, _z: Double);
var
  R: Double;
begin
  R:= BIG_ELIPSE_PARAM + height;
  _x:= R * Cos(lat) * Cos(long);
  _y:= R * Cos(lat) * Sin(long);
  _z:= R * Sin(lat);
end;

// not used in this program!
procedure GeographicToLambert(lat, long, latMin, latMax, lat0, long0: Double;
  var _x, _y: Double);
var n, F, g, g0: Double;
begin
  n := (Ln(Cos(latMin)/ Cos(latMax)))/(Ln(Tan(latMax/2 + Pi/4)*Cotan(latMin/2 + Pi/4)));
  F := (Cos(latMin) * Power(Tan(latMin/2 + Pi/4), n)) / n;
  g := F * Power(Cotan(lat/2 + Pi/4), n);
  g0 := F * Power(Cotan(lat0/2 + Pi/4), n);
  _x := g * Sin(n * (long - long0));
  _y := g0 - g * Cos(n * (long - long0));
end;

procedure GeographicToAzimut(lat, long, heig, crossLat: Double; var _x, _y: Double);
var g, latKras, longKras, heigKras: Double;
begin
  WGS_84ToSK_42(lat, long, heig, latKras, longKras, heigKras);
  g := BIG_ELIPSE_PARAM_KRASOVSKY * (1 + Sin(crossLat)) * Tan(Pi/4 - latKras/2);
  _x := g * Cos(longKras);
  _y := g * Sin(longKras);
end;

// Use to get Gauss projection's coords from geographic WGS-84 coords
procedure GeographicToGauss(lat, long, heig: Double; isKrasovsky: Boolean;
  var _x, _y: Double; var Nzone: Integer; var LitZone: string);
var n2, e, t, lsec, N, Xlat, latKras, longKras, heigKras, x1,x2,x3, y1,y2,y3
  : Double; long0, _nZone, _litZone: Integer;
begin
  if isKrasovsky = true then
  begin
    latKras := lat;
    longKras := long;
    heigKras := heig;
  end
  else
  begin
    WGS_84ToSK_42(lat, long, heig, latKras, longKras, heigKras);
  end;
  n2 := Sqr(GetExcentr1Kras()) * Sqr(Cos(latKras));
  t := Tan(latKras);
  e := GetExcentrKras();
  GetMeridianArcValue(0,lat,Xlat);
  N := BIG_ELIPSE_PARAM_KRASOVSKY / (Sqrt(1 - Sqr(e * Sin(latKras))));
  // find number of zone
  if long >= 0 then
  begin
    long0 := (Trunc(RadToDeg(longKras)) div 6) * 6 + 3;
    _nZone := (Trunc(RadToDeg(longKras)) div 6) + 1;
    Nzone := _nZone + 30;
  end
  else
  begin
    long0 := (Trunc(RadToDeg(longKras)) div 6) * 6 - 3;
    _nZone := Trunc(RadToDeg(longKras)) div 6;
    Nzone := _nZone + 30;
  end;
  lsec :=  DegToSec(RadToDeg(longKras) - long0);
  // find letter of zone
  _litZone := (Trunc(RadToDeg(lat)) div 4) + 1;
  LitZone := Zones[_litZone];
  x1 := (N/2)*Sqr(lsec/RAD_SEC)*Sin(latKras)*Cos(latKras);
  x2 := (N/24)*Power((lsec/RAD_SEC),4)*Sin(latKras)*Power(Cos(latKras),3) *
    (5 - Sqr(t) + 9*n2 + 4*Power(n2, 2));
  x3 := (N/720)*Power((lsec/RAD_SEC), 6) *
    Sin(latKras)*Power(Cos(latKras), 5)*(61 - 58*Sqr(t) + Power(t, 4));
  _x := Xlat + x1 + x2 + x3;
  y1 := N*(lsec/RAD_SEC)*Cos(latKras);
  y2 := (N/6)*Power((lsec/RAD_SEC), 3)*Power(Cos(latKras), 3)*(1 - Sqr(t) + n2);
  y3 :=  (N/120)*Power((lsec/RAD_SEC), 5) * Power(Cos(latKras), 5)*
    (5 - 18*Sqr(t) + Power(t, 4) + 14*n2 - 58*n2*Sqr(t));
  _y := y1 + y2 + y3 + 500000;
end;

// use to get Gauss projection's coords from SK-42 geo coords
// (to min and max Latitudes and Longitudes)
procedure GeographicToGauss(lat, long: Double; NZone: Integer; var _x, _y: Double);
var n2, e, t, lsec, N, Xlat, x1,x2,x3, y1,y2,y3: Double; long0: Integer;
begin
  n2 := Sqr(GetExcentr1Kras()) * Sqr(Cos(lat));
  t := Tan(lat);
  e := GetExcentrKras();
  GetMeridianArcValue(0,lat,Xlat);
  N := BIG_ELIPSE_PARAM_KRASOVSKY / (Sqrt(1 - Sqr(e * Sin(lat))));
  long0 := (NZone - 30) * 6 - 3;
  lsec :=  DegToSec(RadToDeg(long) - long0);
  x1 := (N/2)*Sqr(lsec/RAD_SEC)*Sin(lat)*Cos(lat);
  x2 := (N/24)*Power((lsec/RAD_SEC),4)*Sin(lat)*Power(Cos(lat),3) *
    (5 - Sqr(t) + 9*n2 + 4*Power(n2, 2));
  x3 := (N/720)*Power((lsec/RAD_SEC), 6) *
    Sin(lat)*Power(Cos(lat), 5)*(61 - 58*Sqr(t) + Power(t, 4));
  _x := Xlat + x1 + x2 + x3;
  y1 := N*(lsec/RAD_SEC)*Cos(lat);
  y2 := (N/6)*Power((lsec/RAD_SEC), 3)*Power(Cos(lat), 3)*(1 - Sqr(t) + n2);
  y3 :=  (N/120)*Power((lsec/RAD_SEC), 5) * Power(Cos(lat), 5)*
    (5 - 18*Sqr(t) + Power(t, 4) + 14*n2 - 58*n2*Sqr(t));
  _y := y1 + y2 + y3 + 500000;
end;

// Transformation with Molodensky method
procedure WGS_84ToSK_42(lat, long, heig: Double; var _lat, _long, _heig: Double);
var dLat, dLong, dHeig, M1, N1, e1, e2, f1, f2: Double;
begin
  e1 := GetExcentr();
  e2 := GetExcentrKras();
  f1 := GetCompres(BIG_ELIPSE_PARAM, SMALL_ELIPSE_PARAM);
  f2 := GetCompres(BIG_ELIPSE_PARAM_KRASOVSKY, SMALL_ELIPSE_PARAM_KRASOVSKY);
  M1 := (BIG_ELIPSE_PARAM * (1 - Sqr(e1)))/(Sqrt(Power((1 - Sqr(e1*Sin(lat))), 3)));
  N1 := BIG_ELIPSE_PARAM / (Sqrt(1 - Sqr(e1*Sin(lat))));
  dLat := (-_DX*Sin(lat)*Cos(long) - _DY*Sin(lat)*Sin(long) + _DZ*Cos(long) +
    (BIG_ELIPSE_PARAM_KRASOVSKY - BIG_ELIPSE_PARAM)*(N1*Sqr(e1)*Sin(lat)*Cos(lat))/
      (BIG_ELIPSE_PARAM) + (f2 - f1)*(M1*BIG_ELIPSE_PARAM/SMALL_ELIPSE_PARAM +
        N1*SMALL_ELIPSE_PARAM/BIG_ELIPSE_PARAM)*Sin(lat)*Cos(lat)) / (M1 + heig);
  dLong := (-_DX*Sin(long) + _DY*Cos(long)) / (Cos(lat)*(M1 + heig));
  dHeig := _DX*Cos(lat)*Cos(long) + _DY*Cos(lat)*Sin(long) + _DZ*Sin(lat) -
    BIG_ELIPSE_PARAM*(BIG_ELIPSE_PARAM_KRASOVSKY - BIG_ELIPSE_PARAM)/N1  +
      (f2 - f1)*SMALL_ELIPSE_PARAM*N1*Sqr(Sin(lat))/BIG_ELIPSE_PARAM;
  _lat := lat + dLat;
  _long := long + dLong;
  _heig := heig + dHeig;
end;

// get back single value of degrees in 0..360
function DegSingle(deg: Integer): Integer;
var countCicles: Integer;
begin
  if deg > 360 then
  begin
    countCicles := deg div 360;
    Result := deg - 360 * countCicles;
  end
  else
  if deg <= 0 then
  begin
    countCicles := deg div 360;
    Result := deg + 360 * (countCicles + 1);
  end
  else
  begin
    Result := deg;
  end;
end;

// in athimuth projection find start angle to draw arcs
function GetStartAngle(longMax: Integer): Integer;
begin
  Result := DegSingle(360 - longMax);
end;

// in athimuth projection find value of segment angle to draw arcs
function GetArcAngle(longMin, longMax: Integer): Integer;
begin
  Result := DegSingle(longMax - longMin);
end;

// find value of meridian arc in special Latitude with Krasovsky ellipsoide
procedure GetMeridianArcValue(latMin, latMax: Double; var Xlat: Double);
var Mmin, Mmax, Mmiddle, latMiddle, dLat: Double;
begin
  latMiddle := (latMin + latMax)/2;
  Mmin := (BIG_ELIPSE_PARAM_KRASOVSKY*(1 - Sqr(GetExcentrKras()))) / (1 -
    Sqr(GetExcentrKras()*Sin(latMin)));
  Mmax := (BIG_ELIPSE_PARAM_KRASOVSKY*(1 - Sqr(GetExcentrKras()))) / (1 -
    Sqr(GetExcentrKras()*Sin(latMax)));
  Mmiddle := (BIG_ELIPSE_PARAM_KRASOVSKY*(1 - Sqr(GetExcentrKras()))) / (1 -
    Sqr(GetExcentrKras()*Sin(latMiddle)));
  dLat := RadToSec(latMax - latMin);
  Xlat := (Mmin + Mmax + 4 * Mmiddle)*(dLat/(6*RAD_SEC));
end;

// find min and max values of List projection borders
procedure GetListGauss(lat, long: Double; scale: Integer;
  var latMin, latMax, longMin, longMax, step: Double);
begin
  case scale of
    1000: GetListGauss1000(lat,long, latMin, latMax, longMin, longMax, step);
    500: GetListGauss500(lat,long, latMin, latMax, longMin, longMax, step);
    100: GetListGauss100(lat,long, latMin, latMax, longMin, longMax, step);
    50: GetListGauss50(lat,long, latMin, latMax, longMin, longMax, step);
    25: GetListGauss25(lat,long, latMin, latMax, longMin, longMax, step);
    10: GetListGauss10(lat,long, latMin, latMax, longMin, longMax, step);
  end;
end;

// for scale 1:1 000 000
procedure GetListGauss1000(lat, long: Double; var latMin, latMax, longMin,
  longMax, step: Double);
begin
  if long >= 0 then
  begin
    longMin := (Trunc(RadToDeg(long)) div 6) * 6;
    longMax := longMin + 6;
  end
  else
  begin
    longMax := (Trunc(RadToDeg(long)) div 6) * 6;
    longMin := longMax - 6;
  end;
  if lat >= 0 then
  begin
    latMin := (Trunc(RadToDeg(lat)) div 4) * 4;
    latMax := latMin + 4;
  end
  else
  begin
    latMax := (Trunc(RadToDeg(lat)) div 4) * 4;
    latMin := latMax - 4;
  end;
  step := 1;
end;

// for scale 1: 500 000
procedure GetListGauss500(lat, long: Double;
   var latMin, latMax, longMin, longMax, step: Double);
begin
  GetListGauss1000(lat,long, latMin, latMax, longMin, longMax, step);
  if RadToDeg(lat) < (latMin + (latMax-latMin)/2) then
  begin
    latMax := latMin + Round((latMax-latMin)/2);
  end
  else
  begin
    latMin := latMin + Round((latMax-latMin)/2);
  end;
  if RadToDeg(long) < (longMin + (longMax - longMin)/2) then
  begin
    longMax := longMin + Round((longMax - longMin)/2);
  end
  else
  begin
    longMin := longMin + Round((longMax - longMin)/2);
  end;
end;

// for scale 1: 100 000
procedure GetListGauss100(lat, long: Double;
   var latMin, latMax, longMin, longMax, step: Double);
var latMinutes, longMinutes: Double;
begin
  GetListGauss1000(lat,long, latMin, latMax, longMin, longMax, step);
  latMinutes := RadToDeg(lat) * 60;
  latMin := latMin + ((Trunc(latMinutes - latMin*60) div 20)*20 / 60);
  latMax := latMin + 20/60;
  longMinutes := RadToDeg(long) * 60;
  longMin := longMin + ((Trunc(longMinutes - longMin*60) div 30)*30 / 60);
  longMax := longMin + 30/60;
  step := 10/60;
end;

// for scale 1: 50 000
procedure GetListGauss50(lat, long: Double;
   var latMin, latMax, longMin, longMax, step: Double);
var latMinutes, longMinutes: Double;
begin
  GetListGauss100(lat,long, latMin, latMax, longMin, longMax, step);
  latMinutes := RadToDeg(lat) * 60;
  latMin := latMin + ((Trunc(latMinutes - latMin*60) div 10)*10 / 60);
  latMax := latMin + 10/60;
  longMinutes := RadToDeg(long) * 60;
  longMin := longMin + ((Trunc(longMinutes - longMin*60) div 15)*15 / 60);
  longMax := longMin + 15/60;
  step := 5/60;
end;

// for scale 1: 25 000
procedure GetListGauss25(lat, long: Double;
   var latMin, latMax, longMin, longMax, step: Double);
var latSeconds, longSeconds: Double;
begin
  GetListGauss50(lat,long, latMin, latMax, longMin, longMax, step);
  latSeconds := RadToDeg(lat) * 3600;
  latMin := latMin + ((Trunc(latSeconds - latMin*3600) div 300)* 300 / 3600);
  latMax := latMin + 5/60;
  longSeconds := RadToDeg(long) * 3600;
  longMin := longMin + ((Trunc(longSeconds - longMin*3600) div 450)*450 / 3600);
  longMax := longMin + 450/3600;
  step := 30/3600;
end;

// for scale 1 : 10 000
procedure GetListGauss10(lat, long: Double;
   var latMin, latMax, longMin, longMax, step: Double);
var latSeconds, longSeconds: Double;
begin
  GetListGauss25(lat,long, latMin, latMax, longMin, longMax, step);
  latSeconds := RadToDeg(lat) * 3600;
  latMin := latMin + ((Trunc(latSeconds - latMin*3600) div 150)* 150 / 3600);
  latMax := latMin + 150/3600;
  longSeconds := RadToDeg(long) * 3600;
  longMin := longMin + ((Trunc(longSeconds - longMin*3600) div 225)*225 / 3600);
  longMax := longMin + 225/3600;
  step := 15/3600;
end;

function GetScaleFactor(scale: string): Integer;
var scl: Integer;
begin
  scl := 1000;
  if scale = '1:1000000' then
  begin
    scl := 1000;
  end
  else
  begin
    if scale = '1:500000' then
    begin
      scl := 500;
    end
    else
    if scale = '1:100000' then
    begin
      scl := 100;
    end
    else
    if (scale = '1:50000') then
    begin
      scl := 50;
    end
    else
    if scale = '1:25000' then
    begin
      scl := 25;
    end
    else
    if scale = '1:10000' then
    begin
      scl := 10;
    end;
  end;
  Result := scl;
end;

// must be refactored!!!
// but now it works good
function GetNomenclatura(scale: Integer; nZone: Integer; const litZone: string;
  lat, long: Double): string;
var nomencl: string; numI, numJ : Integer; latMin, latMax, longMin, longMax, step
  : Double;
begin
  nomencl := IntToStr(nZone) + '-' + litZone;
  case scale of
    1000:
    begin
      GetListGauss(lat, long, scale, latMin, latMax, longMin, longMax, step);
      nomencl := IntToStr(nZone) + '-' + litZone;
    end;
    500:
    begin
      GetListGauss1000(lat, long, latMin, latMax, longMin, longMax, step);
      if RadToDeg(lat) > (latMin + (latMax - latMin)/2) then
      begin
        if RadToDeg(long) < (longMin + (longMax - longMin)/2)  then
        begin
          nomencl := nomencl + '-' + 'A';
        end
        else
        begin
          nomencl := nomencl + '-' + 'Á';
        end;
      end
      else
      begin
        if RadToDeg(long) < (longMin + (longMax - longMin)/2)  then
        begin
          nomencl := nomencl + '-' + 'Â';
        end
        else
        begin
          nomencl := nomencl + '-' + 'Ã';
        end;
      end;
    end;
    100:
    begin
      GetListGauss1000(lat, long, latMin, latMax, longMin, longMax, step);
      numI := 12 - (Trunc((RadToDegInDms(lat) - latMin)*60) div 20);
      numJ := ((Trunc((RadToDeg(long) - longMin))*60) div 30) + 1;
      nomencl := nomencl + '-' + IntToStr((numI - 1)*12 + numJ);
    end;
    50:
    begin
      GetListGauss1000(lat, long, latMin, latMax, longMin, longMax, step);
      numI := 12 - (Trunc((RadToDegInDms(lat) - latMin)*60) div 20);
      numJ := ((Trunc((RadToDeg(long) - longMin))*60) div 30) + 1;
      nomencl := nomencl + '-' + IntToStr((numI - 1)*12 + numJ);
      GetListGauss100(lat, long, latMin, latMax, longMin, longMax, step);
      if RadToDeg(lat) > (latMin + (latMax - latMin)/2) then
      begin
        if RadToDeg(long) < (longMin + (longMax - longMin)/2)  then
        begin
          nomencl := nomencl + '-' + 'A';
        end
        else
        begin
          nomencl := nomencl + '-' + 'Á';
        end;
      end
      else
      begin
        if RadToDeg(long) < (longMin + (longMax - longMin)/2)  then
        begin
          nomencl := nomencl + '-' + 'Â';
        end
        else
        begin
          nomencl := nomencl + '-' + 'Ã';
        end;
      end;
    end;
    25:
    begin
      GetListGauss1000(lat, long, latMin, latMax, longMin, longMax, step);
      numI := 12 - (Trunc((RadToDegInDms(lat) - latMin)*60) div 20);
      numJ := ((Trunc((RadToDeg(long) - longMin))*60) div 30) + 1;
      nomencl := nomencl + '-' + IntToStr((numI - 1)*12 + numJ);
      GetListGauss100(lat, long, latMin, latMax, longMin, longMax, step);
      if RadToDeg(lat) > (latMin + (latMax - latMin)/2) then
      begin
        if RadToDeg(long) < (longMin + (longMax - longMin)/2)  then
        begin
          nomencl := nomencl + '-' + 'A';
        end
        else
        begin
          nomencl := nomencl + '-' + 'Á';
        end;
      end
      else
      begin
        if RadToDeg(long) < (longMin + (longMax - longMin)/2)  then
        begin
          nomencl := nomencl + '-' + 'Â';
        end
        else
        begin
          nomencl := nomencl + '-' + 'Ã';
        end;
      end;
      GetListGauss50(lat, long, latMin, latMax, longMin, longMax, step);
      if RadToDeg(lat) > (latMin + (latMax - latMin)/2) then
      begin
        if RadToDeg(long) < (longMin + (longMax - longMin)/2)  then
        begin
          nomencl := nomencl + '-' + 'a';
        end
        else
        begin
          nomencl := nomencl + '-' + 'á';
        end;
      end
      else
      begin
        if RadToDeg(long) < (longMin + (longMax - longMin)/2)  then
        begin
          nomencl := nomencl + '-' + 'â';
        end
        else
        begin
          nomencl := nomencl + '-' + 'ã';
        end;
      end;
    end;
    10:
    begin
      GetListGauss1000(lat, long, latMin, latMax, longMin, longMax, step);
      numI := 12 - (Trunc((RadToDegInDms(lat) - latMin)*60) div 20);
      numJ := ((Trunc((RadToDeg(long) - longMin))*60) div 30) + 1;
      nomencl := nomencl + '-' + IntToStr((numI - 1)*12 + numJ);
      GetListGauss100(lat, long, latMin, latMax, longMin, longMax, step);
      if RadToDeg(lat) > (latMin + (latMax - latMin)/2) then
      begin
        if RadToDeg(long) < (longMin + (longMax - longMin)/2)  then
        begin
          nomencl := nomencl + '-' + 'A';
        end
        else
        begin
          nomencl := nomencl + '-' + 'Á';
        end;
      end
      else
      begin
        if RadToDeg(long) < (longMin + (longMax - longMin)/2)  then
        begin
          nomencl := nomencl + '-' + 'Â';
        end
        else
        begin
          nomencl := nomencl + '-' + 'Ã';
        end;
      end;
      GetListGauss50(lat, long, latMin, latMax, longMin, longMax, step);
      if RadToDeg(lat) > (latMin + (latMax - latMin)/2) then
      begin
        if RadToDeg(long) < (longMin + (longMax - longMin)/2)  then
        begin
          nomencl := nomencl + '-' + 'a';
        end
        else
        begin
          nomencl := nomencl + '-' + 'á';
        end;
      end
      else
      begin
        if RadToDeg(long) < (longMin + (longMax - longMin)/2)  then
        begin
          nomencl := nomencl + '-' + 'â';
        end
        else
        begin
          nomencl := nomencl + '-' + 'ã';
        end;
      end;
      GetListGauss25(lat, long, latMin, latMax, longMin, longMax, step);
      if RadToDeg(lat) > (latMin + (latMax - latMin)/2) then
      begin
        if RadToDeg(long) < (longMin + (longMax - longMin)/2)  then
        begin
          nomencl := nomencl + '-' + '1';
        end
        else
        begin
          nomencl := nomencl + '-' + '2';
        end;
      end
      else
      begin
        if RadToDeg(long) < (longMin + (longMax - longMin)/2)  then
        begin
          nomencl := nomencl + '-' + '3';
        end
        else
        begin
          nomencl := nomencl + '-' + '4';
        end;
      end;
    end;
  end;
  Result := nomencl;
end;

{function GetNomenclatura(scale: Integer; nZone: Integer; const litZone: string;
  lat, long: Double): string;
var nomencl: string; numI, numJ : Integer; latMin, latMax, longMin, longMax, step
  : Double;
begin
  nomencl := IntToStr(nZone) + '-' + litZone;
  if scale = 1000 then
  begin
    Result := nomencl;
  end
  else
  begin
    GetListGauss1000(lat, long, latMin, latMax, longMin, longMax, step);
    if scale = 500 then
    begin
      Devide4(lat, long, 0, latMin, latMax, longMin, longMax, nomencl);
      Result := nomencl;
    end
    else
      numI := 12 - (Trunc((RadToDegInDms(lat) - latMin)*60) div 20);
      numJ := ((Trunc((RadToDeg(long) - longMin))*60) div 30) + 1;
      nomencl := nomencl + '-' + IntToStr((numI - 1)*12 + numJ);
      if scale = 100 then
      begin
        Result := nomencl;
      end
      else
        GetListGauss100(lat, long, latMin, latMax, longMin, longMax, step);
        Devide4(lat, long, 0, latMin, latMax, longMin, longMax, nomencl);
        if scale = 50 then
        begin
          Result := nomencl;
        end
        else
          GetListGauss50(lat, long, latMin, latMax, longMin, longMax, step);
          Devide4(lat, long, 4, latMin, latMax, longMin, longMax, nomencl);
          if scale = 25 then
          begin
            Result := nomencl;
          end
          else
            GetListGauss25(lat, long, latMin, latMax, longMin, longMax, step);
            Devide4(lat, long, 8, latMin, latMax, longMin, longMax, nomencl);
            Result := nomencl;
  end;
end; }



procedure Devide4(lat, long: Double; depth: Integer; latMin, latMax, longMin,
  longMax: Double; var nomencl: string);
var numI, numJ : Integer; step: Double;
begin
  if RadToDeg(lat) > (latMin + (latMax - latMin)/2) then
  begin
    if RadToDeg(long) < (longMin + (longMax - longMin)/2)  then
    begin
      nomencl := nomencl + '-' + NomenclArray[depth + 1];
    end
    else
    begin
      nomencl := nomencl + '-' + NomenclArray[depth + 2];
    end;
  end
  else
  begin
    if RadToDeg(long) < (longMin + (longMax - longMin)/2)  then
    begin
      nomencl := nomencl + '-' + NomenclArray[depth + 3];
    end
    else
    begin
      nomencl := nomencl + '-' + NomenclArray[depth + 4];
    end;
  end;
end;


// lat, long in degrees
// used in other project
// Ethiopia
procedure GetModelCoords(lat, long: Double; var i, j: Integer);
var latSec, longSec: Double;
begin
  if (lat > 10) and (lat < 12) and (long > 34) and (long < 36) then
  begin
    latSec := (12 - lat)*3600;
    longSec := (long - 34) * 3600;
    i := (Round(latSec) div 3) + 1;
    j := (Round(longSec) div 3) + 1;
  end;
end;
end.
