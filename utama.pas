unit utama;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ExtDlgs;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnPattern1: TButton;
    btnPattern2: TButton;
    btnTexture: TButton;
    btnGenerate: TButton;
    btnSave: TButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    OpenPictureDialog2: TOpenPictureDialog;
    OpenPictureDialog3: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    ScrollBox1: TScrollBox;
    procedure btnGenerateClick(Sender: TObject);
    procedure btnPattern1Click(Sender: TObject);
    procedure btnPattern2Click(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnTextureClick(Sender: TObject);
    procedure Grayscale(functionGray: Byte);
    procedure Biner1();
    procedure Biner2();
    procedure Arithmetic();
    procedure LPF();
    procedure HPF();
    procedure EdgeD();
    procedure Invers(functionInvers: Byte);
    procedure Snowflake();
    procedure Flower();
    procedure Texture();
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

uses
  windows;

var
  Arith:
  record
    bitmapBiner: array[0..1000, 0..1000] of Boolean;
    bitmapBiner2: array[0..1000, 0..1000] of Boolean;
    bitmapBiner3: array[0..1000, 0..1000] of Boolean;
  end;

  FL:
  record
    bitmapR, bitmapG, bitmapB: array[0..1000, 0..1000] of Byte;
    gray: array[0..1000, 0..1000] of Byte;
    bitmapBiner: array[0..1000, 0..1000] of Boolean;
    bitmapBiner2: array[0..1000, 0..1000] of Boolean;
    bitmapBinerColor: array[0..1000, 0..1000] of Byte;
    invers: array[0..1000, 0..1000] of Byte;
  end;

  Snow:
  record
    bitmapR, bitmapG, bitmapB: array[0..1000, 0..1000] of Byte;
    invers: array[0..1000, 0..1000] of Byte;
  end;

  T:
  record
    bitmapR, bitmapG, bitmapB: array[0..1000, 0..1000] of Byte;
  end;

  DT:
  record
    gray: array[0..1000, 0..1000] of Byte;
    inversGray: array[0..1000, 0..1000] of Byte;
    bitmapFilterGray: array[0..1000, 0..1000] of Byte;
  end;

  SM:
  record
    bitmapFilterR, bitmapFilterG, bitmapFilterB: array[0..1000, 0..1000] of Byte;
  end;
  SH:
  record
    bitmapFilterR, bitmapFilterG, bitmapFilterB: array[0..1000, 0..1000] of Byte;
  end;

procedure TForm1.btnPattern1Click(Sender: TObject);
var
  x, y: Integer;
begin
  if OpenPictureDialog1.Execute then
  begin
    Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
    for y:=0 to Image1.Height-1 do
    begin
      for x:=0 to Image1.Width-1 do
      begin
        FL.bitmapR[x,y] := GetRValue(Image1.Canvas.Pixels[x,y]);
        FL.bitmapG[x,y] := GetGValue(Image1.Canvas.Pixels[x,y]);
        FL.bitmapB[x,y] := GetBValue(Image1.Canvas.Pixels[x,y]);
      end;
    end;
  end;
end;

procedure TForm1.btnPattern2Click(Sender: TObject);
var
  x, y: Integer;
begin
  if OpenPictureDialog2.Execute then
  begin
    Image2.Picture.LoadFromFile(OpenPictureDialog2.FileName);
    for y:=0 to Image2.Height-1 do
    begin
      for x:=0 to Image2.Width-1 do
      begin
        Snow.bitmapR[x,y] := GetRValue(Image2.Canvas.Pixels[x,y]);
        Snow.bitmapG[x,y] := GetGValue(Image2.Canvas.Pixels[x,y]);
        Snow.bitmapB[x,y] := GetBValue(Image2.Canvas.Pixels[x,y]);
      end;
    end;
  end;
end;

procedure TForm1.btnTextureClick(Sender: TObject);
var
  x, y: Integer;
begin
  if OpenPictureDialog3.Execute then
  begin
    Image3.Picture.LoadFromFile(OpenPictureDialog3.FileName);
    for y:=0 to Image3.Height-1 do
    begin
      for x:=0 to Image3.Width-1 do
      begin
        T.bitmapR[x,y] := GetRValue(Image3.Canvas.Pixels[x,y]);
        T.bitmapG[x,y] := GetGValue(Image3.Canvas.Pixels[x,y]);
        T.bitmapB[x,y] := GetBValue(Image3.Canvas.Pixels[x,y]);
      end;
    end;
  end;
end;

procedure TForm1.btnSaveClick(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
  begin
    Image4.Picture.SaveToFile(SavePictureDialog1.FileName);

    ShowMessage('Batik pattern saved successfully');
  end;
end;

procedure TForm1.Grayscale(functionGray: Byte);
var
  x,y: Integer;
begin
  if functionGray = 1 then
  begin
    for y:=0 to Image1.Height-1 do
    begin
      for x:=0 to Image1.Width-1 do
      begin
        FL.gray[x,y] := (FL.bitmapR[x,y] + FL.bitmapG[x,y] + FL.bitmapB[x,y]) div 3;
      end;
    end;
  end

  else if functionGray = 2 then
  begin
    for y:=0 to Image2.Height-1 do
    begin
      for x:=0 to Image2.Width-1 do
      begin
        DT.gray[x,y] := (Snow.bitmapR[x,y] + Snow.bitmapG[x,y] + Snow.bitmapB[x,y]) div 3;
      end;
    end;
  end;
end;

procedure TForm1.Biner1();
var
  x, y: Integer;
  functionGray: Byte;
begin
  functionGray := 1;
  Grayscale(functionGray);

  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      if FL.gray[x,y] > 1 then
      begin
        FL.bitmapBiner[x,y] := true;
      end
      else
      begin
        FL.bitmapBiner[x,y] := false;
      end;
    end;
  end;
end;

procedure TForm1.Biner2();
var
  x, y: Integer;
begin
  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      if FL.gray[x,y] > 165 then
      begin
        FL.bitmapBiner2[x,y] := true;
      end
      else
      begin
        FL.bitmapBiner2[x,y] := false;
      end;
    end;
  end;
end;

procedure TForm1.Invers(functionInvers: Byte);
var
  x,y: Integer;
begin
  if functionInvers = 1 then
  begin
    for y:=0 to Image2.Height-1 do
    begin
      for x:=0 to Image2.Width-1 do
      begin
        DT.inversGray[x,y] := 255 - DT.bitmapFilterGray[x, y];
      end;
    end;
  end

  else if functionInvers = 2 then
  begin
    for y:=0 to Image2.Height-1 do
    begin
      for x:=0 to Image2.Width-1 do
      begin
        Snow.invers[x,y] := 255 - DT.inversGray[x,y];
      end;
    end;
  end
end;

procedure TForm1.Arithmetic();
var
  x,y: Integer;
begin
  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      if Snow.invers[x,y] > 127 then
      begin
        Arith.bitmapBiner2[x,y] := true;
      end
      else
      begin
        Arith.bitmapBiner2[x,y] := false;
      end;
    end;
  end;

  for y:=0 to Image1.Height-1 do
  begin
    for x:=0 to Image1.Width-1 do
    begin
      Arith.bitmapBiner[x,y] := (not FL.bitmapBiner[x,y]) and Arith.bitmapBiner2[x,y];

      Arith.bitmapBiner3[x,y] := Arith.bitmapBiner[x,y] or FL.bitmapBiner2[x,y];
    end;
  end;
end;

procedure TForm1.LPF();
var
  x,y: Integer;
  kernel: array[1..3, 1..3] of Single =
  (
    (1.0/9.0, 1.0/9.0, 1.0/9.0),
    (1.0/9.0, 1.0/9.0, 1.0/9.0),
    (1.0/9.0, 1.0/9.0, 1.0/9.0)
  );
  i,j: Integer;
  index_x, index_y: Integer;
  filterR, filterG, filterB: Double;
begin
  for y:=0 to Image3.Height-1 do
  begin
    for x:=0 to Image3.Width-1 do
    begin
      filterR := 0;
      filterG := 0;
      filterB := 0;

      for j:=1 to 3 do
      begin
        for i:=1 to 3 do
        begin
          index_x := x - (i - 2);
          index_y := y - (j - 2);

          if index_x < 0 then
          begin
            index_x := 0;
          end;

          if index_x > Image3.Width-1 then
          begin
            index_x := Image3.Width-1;
          end;

          if index_y < 0 then
          begin
            index_y := 0;
          end;

          if index_y > Image3.Height-1 then
          begin
            index_y := Image3.Height-1;
          end;

          filterR := filterR + T.bitmapR[index_x, index_y] * kernel[i,j];
          filterG := filterG + T.bitmapG[index_x, index_y] * kernel[i,j];
          filterB := filterB + T.bitmapB[index_x, index_y] * kernel[i,j];
        end;
      end;

      if filterR < 0 then
      begin
        filterR := 0;
      end;

      if filterR > 255 then
      begin
        filterR := 255;
      end;

      if filterG < 0 then
      begin
        filterG := 0;
      end;

      if filterG > 255 then
      begin
        filterG := 255;
      end;

      if filterB < 0 then
      begin
        filterB := 0;
      end;

      if filterB > 255 then
      begin
        filterB := 255;
      end;

      SM.bitmapFilterR[x,y] := Round(filterR);
      SM.bitmapFilterG[x,y] := Round(filterG);
      SM.bitmapFilterB[x,y] := Round(filterB);
    end;
  end;
end;

procedure TForm1.HPF();
var
  x,y: Integer;
  kernel: array[1..3, 1..3] of Integer =
  (
    (-1, -1, -1),
    (-1, 9, -1),
    (-1, -1, -1)
  );
  i,j: Integer;
  index_x, index_y: Integer;
  filterR, filterG, filterB: Double;
begin
  for y:=0 to Image3.Height-1 do
  begin
    for x:=0 to Image3.Width-1 do
    begin
      filterR := 0;
      filterG := 0;
      filterB := 0;

      for j:=1 to 3 do
      begin
        for i:=1 to 3 do
        begin
          index_x := x - (i - 2);
          index_y := y - (j - 2);

          if index_x < 0 then
          begin
            index_x := 0;
          end;

          if index_x > Image3.Width-1 then
          begin
            index_x := Image3.Width-1;
          end;

          if index_y < 0 then
          begin
            index_y := 0;
          end;

          if index_y > Image3.Height-1 then
          begin
            index_y := Image3.Height-1;
          end;

          filterR := filterR + SM.bitmapFilterR[index_x, index_y] * kernel[i,j];
          filterG := filterG + SM.bitmapFilterG[index_x, index_y] * kernel[i,j];
          filterB := filterB + SM.bitmapFilterB[index_x, index_y] * kernel[i,j];
        end;
      end;

      if filterR < 0 then
      begin
        filterR := 0;
      end;

      if filterR > 255 then
      begin
        filterR := 255;
      end;

      if filterG < 0 then
      begin
        filterG := 0;
      end;

      if filterG > 255 then
      begin
        filterG := 255;
      end;

      if filterB < 0 then
      begin
        filterB := 0;
      end;

      if filterB > 255 then
      begin
        filterB := 255;
      end;

      SH.bitmapFilterR[x,y] := Round(filterR);
      SH.bitmapFilterG[x,y] := Round(filterG);
      SH.bitmapFilterB[x,y] := Round(filterB);
    end;
  end;
end;

procedure TForm1.EdgeD();
var
  x,y: Integer;
  kernel: array[1..3, 1..3] of Integer =
  (
    (-1, -1, -1),
    (-1, 8, -1),
    (-1, -1, -1)
  );
  i,j: Integer;
  index_x, index_y: Integer;
  filterGray: Integer;
  functionGray: Byte;
begin
  functionGray:= 2;
  Grayscale(functionGray);

  for y:=0 to Image2.Height-1 do
  begin
    for x:=0 to Image2.Width-1 do
    begin
      filterGray := 0;

      for j:=1 to 3 do
      begin
        for i:=1 to 3 do
        begin
          index_x := x - (i - 2);
          index_y := y - (j - 2);

          if index_x < 0 then
          begin
            index_x := 0;
          end;

          if index_x > Image2.Width-1 then
          begin
            index_x := Image2.Width-1;
          end;

          if index_y < 0 then
          begin
            index_y := 0;
          end;

          if index_y > Image2.Height-1 then
          begin
            index_y := Image2.Height-1;
          end;

          filterGray := filterGray + DT.gray[index_x, index_y] * kernel[i,j];
        end;
      end;

      if filterGray < 0 then
      begin
        filterGray := 0;
      end;

      if filterGray > 255 then
      begin
        filterGray := 255;
      end;

      DT.bitmapFilterGray[x,y] := filterGray;
    end;
  end;
  Invers(1);
end;

procedure TForm1.Flower();
begin
  Biner1();
  Biner2();
end;

procedure TForm1.Snowflake();
begin
  EdgeD();
  Invers(2);
end;

procedure TForm1.Texture();
begin
  LPF();
  HPF();
end;

procedure TForm1.btnGenerateClick(Sender: TObject);
var
  x,y: Integer;
begin
  Flower();
  Snowflake();
  Texture();
  Arithmetic();

  Image4.Height := Image1.Height;
  Image4.Width := Image1.Width;

  for y:=0 to Image4.Height-1 do
  begin
    for x:=0 to Image4.Height-1 do
    begin
      if Arith.bitmapBiner3[x,y] then
      begin
        Image4.Canvas.Pixels[x,y] := RGB(SH.bitmapFilterR[x,y], SH.bitmapFilterG[x,y], SH.bitmapFilterB[x,y]);
      end
      else
      begin
        Image4.Canvas.Pixels[x,y] := RGB(0 ,0 ,0);
      end;
    end;
  end;
end;

end.

