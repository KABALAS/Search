unit TestApplicationFunction;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit
  being tested.

}

interface

uses
  TestFramework, Windows, SysUtils, Classes, Graphics;

type
  TDGHTestCase = Class(TTestCase)
  Public
    Procedure CheckTolerance(dblExpected, dblActual, dblTolerance : Double; strMsg : String = '');
  End;

  TestApplicationFunctions = Class(TDGHTestCase)
  Published
    procedure TestIncrementSwitchPosition;
    Procedure TestGetRangeString;
    Procedure TestGetDateRange;
    Procedure TestGetSummaryLevel;
    Procedure TestGetSizeRange;
    Procedure TestGetAttributes;
    Procedure TestGetOrderBy;
    Procedure TestGetSearchInInfo;
    Procedure TestGetDateType;
    Procedure TestGetExclusions;
    Procedure TestGetOwnerSwitch;
    Procedure TestOutputAttributes;
    procedure TestCheckSizeRange;
    procedure TestCheckFileAttributes;
    Procedure TestCheckExclusions;
    Procedure TestCheckOwner;
  End;

implementation

Uses
  ApplicationFunctions, DGHLibrary, FileHandling;

procedure TDGHTestCase.CheckTolerance(dblExpected, dblActual,
  dblTolerance: Double; strMsg: String = '');
begin
  Check(Abs(dblExpected - dblActual) < dblTolerance,
    Format('%s : Expected %1.4f, Actual %1.4f (Delta %1.4f)',
    [strMsg, dblExpected, dblActual, Abs(dblExpected - dblActual)]));
end;

{ TestApplicationFunctions }

procedure TestApplicationFunctions.TestCheckExclusions;

Var
  slExclusions : TstringList;
  strPath : String;
  recSearch : TSearchRec;
  boolFound : Boolean;

begin
  slExclusions := TStringList.Create;
  Try
    slExclusions.Add('\borland\');
    slExclusions.Add('myfile.pas');
    strPath := 'C:\Program Files\Boland\BDS\4.0\Source\';
    recSearch.Name := 'MyFile.dfm';
    boolFound := True;
    CheckExclusions(strPath, recSearch.Name, boolFound, slExclusions);
    CheckEquals(True, boolFound, 'Test 1');
    strPath := 'C:\Program Files\Borland\BDS\4.0\Source\';
    boolFound := True;
    CheckExclusions(strPath, recSearch.Name, boolFound, slExclusions);
    CheckEquals(False, boolFound, 'Test 2');
    strPath := 'C:\Program Files\Boland\BDS\4.0\Source\';
    recSearch.Name := 'MyFile.pas';
    boolFound := True;
    CheckExclusions(strPath, recSearch.Name, boolFound, slExclusions);
    CheckEquals(False, boolFound, 'Test 3');
    strPath := 'C:\Program Files\Borland\BDS\4.0\Source\';
    recSearch.Name := 'MyFile.pas';
    boolFound := True;
    CheckExclusions(strPath, recSearch.Name, boolFound, slExclusions);
    CheckEquals(False, boolFound, 'Test 4');
  Finally
    slExclusions.Free;
  End;
end;

procedure TestApplicationFunctions.TestCheckFileAttributes;

Var
  recSearch : TSearchRec;
  iFileAttrs, iTypeAttrs : Integer;
  boolFound : Boolean;

begin
  CommandLineSwitches := [clsAttrRange];
  recSearch.Attr := 0;
  iFileAttrs := faReadOnly;
  iTypeAttrs := iFileOnly;
  boolFound := True;
  CheckFileAttributes(recSearch.Attr, iFileAttrs, iTypeAttrs, boolFound);
  CheckEquals(False, boolFound, 'Test 1');
  recSearch.Attr := faReadOnly Or faArchive Or faSysFile Or faHidden;
  iFileAttrs := iFileOnly;
  boolFound := True;
  CheckFileAttributes(recSearch.Attr, iFileAttrs, iTypeAttrs, boolFound);
  CheckEquals(False, boolFound, 'Test 2');
  iFileAttrs := faReadOnly;
  boolFound := True;
  CheckFileAttributes(recSearch.Attr, iFileAttrs, iTypeAttrs, boolFound);
  CheckEquals(True, boolFound, 'Test 3');
  iFileAttrs := faArchive;
  boolFound := True;
  CheckFileAttributes(recSearch.Attr, iFileAttrs, iTypeAttrs, boolFound);
  CheckEquals(True, boolFound, 'Test 4');
  iFileAttrs := 0;
  boolFound := True;
  CheckFileAttributes(recSearch.Attr, iFileAttrs, iTypeAttrs, boolFound);
  CheckEquals(True, boolFound, 'Test 5');
  iFileAttrs := faSysFile;
  boolFound := True;
  CheckFileAttributes(recSearch.Attr, iFileAttrs, iTypeAttrs, boolFound);
  CheckEquals(True, boolFound, 'Test 6');
  iFileAttrs := faHidden;
  boolFound := True;
  CheckFileAttributes(recSearch.Attr, iFileAttrs, iTypeAttrs, boolFound);
  CheckEquals(True, boolFound, 'Test 7');
  iFileAttrs := faReadOnly or faArchive;
  boolFound := True;
  CheckFileAttributes(recSearch.Attr, iFileAttrs, iTypeAttrs, boolFound);
  CheckEquals(True, boolFound, 'Test 8');
  iFileAttrs := 0;
  boolFound := True;
  CheckFileAttributes(recSearch.Attr, iFileAttrs, iTypeAttrs, boolFound);
  CheckEquals(True, boolFound, 'Test 5');
end;

procedure TestApplicationFunctions.TestCheckOwner;

Var
  bool : Boolean;

begin
  bool := True;
  CheckOwner('Rail\HoylD', 'Rail\HoylD', ospExact, osEquals, bool);
  Check(bool, 'Test 1');
  bool := True;
  CheckOwner('Rail\HoylD', 'Rail\Hoyle', ospExact, osNotEquals, bool);
  Check(bool, 'Test 2');
  bool := True;
  CheckOwner('Rail\HoylD', 'HoylD', ospEnd, osEquals, bool);
  Check(bool, 'Test 3');
  bool := True;
  CheckOwner('Rail\HoylD', 'Rail\Hoyl', ospStart, osEquals, bool);
  Check(bool, 'Test 4');
  bool := True;
  CheckOwner('Rail\HoylD', 'Hoyl', ospMiddle, osEquals, bool);
  Check(bool, 'Test 5');
end;

procedure TestApplicationFunctions.TestCheckSizeRange;

Var
  iSize, iLSize, iUSize : Int64;
  bool : Boolean;

begin
  CommandLineSwitches := [clsSizeRange];
  iLSize := 1000;
  iUSize := 2000;
  iSize := 1500;
  bool := True;
  CheckSizeRange(iSize, iLSize, iUSize, bool);
  Check(bool, 'Test 1');
  iSize := 500;
  bool := True;
  CheckSizeRange(iSize, iLSize, iUSize, bool);
  Check(Not bool, 'Test 2');
  iSize := 2500;
  bool := True;
  CheckSizeRange(iSize, iLSize, iUSize, bool);
  Check(Not bool, 'Test 3');
end;

procedure TestApplicationFunctions.TestGetAttributes;

Var
  slParams : TStringList;
  iSwitch, iIndex, iFileAttrs, iTypeAttrs : Integer;

begin
  slParams := TstringList.Create;
  Try
    slParams.Text := 'My.exe'#13#10'*.pas';
    iSwitch := 1;
    iIndex := 2;
    Try
      GetAttributes(slParams, iSwitch, iIndex, iFileAttrs, iTypeAttrs);
    Except
      On E : ESearchException Do
        Check(True);
      Else
        Check(False);
    End;
    slParams.Text := 'my.exe'#13#10'/t[f]';
    iSwitch := 1;
    iIndex := 2;
    GetAttributes(slParams, iSwitch, iIndex, iFileAttrs, iTypeAttrs);
    Check(iFileAttrs = 0);
    Check(iTypeAttrs = iFileOnly);
    slParams.Text := 'my.exe'#13#10'/t[d]';
    iSwitch := 1;
    iIndex := 2;
    GetAttributes(slParams, iSwitch, iIndex, iFileAttrs, iTypeAttrs);
    Check(iFileAttrs = 0);
    Check(iTypeAttrs = faDirectory);
    slParams.Text := 'my.exe'#13#10'/t[v]';
    iSwitch := 1;
    iIndex := 2;
    GetAttributes(slParams, iSwitch, iIndex, iFileAttrs, iTypeAttrs);
    Check(iFileAttrs = 0);
    Check(iTypeAttrs = faVolumeID);
    slParams.Text := 'my.exe'#13#10'/t[r]';
    iSwitch := 1;
    iIndex := 2;
    GetAttributes(slParams, iSwitch, iIndex, iFileAttrs, iTypeAttrs);
    Check(iFileAttrs = faReadOnly);
    Check(iTypeAttrs = iFileOnly);
    slParams.Text := 'my.exe'#13#10'/t[a]';
    iSwitch := 1;
    iIndex := 2;
    GetAttributes(slParams, iSwitch, iIndex, iFileAttrs, iTypeAttrs);
    Check(iFileAttrs = faArchive);
    Check(iTypeAttrs = iFileOnly);
    slParams.Text := 'my.exe'#13#10'/t[s]';
    iSwitch := 1;
    iIndex := 2;
    GetAttributes(slParams, iSwitch, iIndex, iFileAttrs, iTypeAttrs);
    Check(iFileAttrs = faSysFile);
    Check(iTypeAttrs = iFileOnly);
    slParams.Text := 'my.exe'#13#10'/t[h]';
    iSwitch := 1;
    iIndex := 2;
    GetAttributes(slParams, iSwitch, iIndex, iFileAttrs, iTypeAttrs);
    Check(iFileAttrs = faHidden);
    Check(iTypeAttrs = iFileOnly);
    slParams.Text := 'my.exe'#13#10'/t[frash]';
    iSwitch := 1;
    iIndex := 2;
    GetAttributes(slParams, iSwitch, iIndex, iFileAttrs, iTypeAttrs);
    Check(iFileAttrs = faReadOnly Or faArchive Or faSysFile Or faHidden);
    Check(iTypeAttrs = iFileOnly);
  Finally
    slParams.Free;
  End;
end;

procedure TestApplicationFunctions.TestGetDateRange;

Const
  dblTolerance = 1 / (24 * 60 * 60 * 999);

Var
  slParams : TStringList;
  iSwitch, iIndex : Integer;
  dtLDate, dtUDate : Double;

begin
  slParams := TStringList.Create;
  Try
    slParams.Text := 'My.exe'#13#10'/d';
    iSwitch := 1;
    iIndex := 2;
    Try
      GetDateRange(slParams, iSwitch, iIndex, dtLDate, dtUdate);
    Except
      On E : ESearchException Do
        Check(True);
      Else
        Check(False);
    End;
    slParams.Text := 'My.exe'#13#10'/d[';
    iSwitch := 1;
    iIndex := 2;
    Try
      GetDateRange(slParams, iSwitch, iIndex, dtLDate, dtUdate);
    Except
      On E : ESearchException Do
        Check(True);
      Else
        Check(False);
    End;
    slParams.Text := 'My.exe'#13#10'/d[-';
    iSwitch := 1;
    iIndex := 2;
    Try
      GetDateRange(slParams, iSwitch, iIndex, dtLDate, dtUdate);
    Except
      On E : ESearchException Do
        Check(True);
      Else
        Check(False);
    End;
    slParams.Text := 'My.exe'#13#10'/d[-]';
    iSwitch := 1;
    iIndex := 2;
    GetDateRange(slParams, iSwitch, iIndex, dtLDate, dtUdate);
    CheckTolerance(dtLDate, EncodeDate(1900, 1, 1) + EncodeTime(0, 0, 0, 0), dblTolerance, 'Test 1.1');
    CheckTolerance(dtUDate, EncodeDate(2099, 12, 31) + EncodeTime(23, 59, 59, 999), dblTolerance, 'Test 1.2');
    slParams.Text := 'My.exe'#13#10'/d[12/Jan/2007-]';
    iSwitch := 1;
    iIndex := 2;
    GetDateRange(slParams, iSwitch, iIndex, dtLDate, dtUdate);
    CheckTolerance(dtLDate, EncodeDate(2007, 1, 12) + EncodeTime(0, 0, 0, 0), dblTolerance, 'Test 2.1');
    CheckTolerance(dtUDate, EncodeDate(2099, 12, 31) + EncodeTime(23, 59, 59, 999), dblTolerance, 'Test 2.2');
    slParams.Text := 'My.exe'#13#10'/d[12/Jan/2007-31/Jan/2007]';
    iSwitch := 1;
    iIndex := 2;
    GetDateRange(slParams, iSwitch, iIndex, dtLDate, dtUdate);
    CheckTolerance(dtLDate, EncodeDate(2007, 1, 12) + EncodeTime(0, 0, 0, 0), dblTolerance, 'Test 3.1');
    CheckTolerance(dtUDate, EncodeDate(2007, 1, 31) + EncodeTime(23, 59, 59, 999), dblTolerance, 'Test 3.2');
    slParams.Text := 'My.exe'#13#10'/d[12/Jan/2007 12:34-31/Jan/2007 23:50]';
    iSwitch := 1;
    iIndex := 2;
    GetDateRange(slParams, iSwitch, iIndex, dtLDate, dtUdate);
    CheckTolerance(dtLDate, EncodeDate(2007, 1, 12) + EncodeTime(12, 34, 0, 0), dblTolerance, 'Test 4.1');
    CheckTolerance(dtUDate, EncodeDate(2007, 1, 31) + EncodeTime(23, 50, 0, 0), dblTolerance, 'Test 4.2');
  Finally
    slParams.Free;
  End;
end;

procedure TestApplicationFunctions.TestGetDateType;

Var
  slParams : TStringList;
  iSwitch, iIndex : Integer;
  DateType : TDateType;

begin
  slParams := TStringList.Create;
  Try
    slParams.Text := 'my.exe'#13#10'/e';
    iSwitch := 1;
    iIndex := 2;
    Try
      GetDateType(slParams, iSwitch, iIndex, DateType);
    Except
      On E : ESearchException Do
        Check(True);
      Else
        Check(False);
    End;
    slParams.Text := 'my.exe'#13#10'/e:';
    iSwitch := 1;
    iIndex := 2;
    Try
      GetDateType(slParams, iSwitch, iIndex, DateType);
    Except
      On E : ESearchException Do
        Check(True);
      Else
        Check(False);
    End;
    slParams.Text := 'my.exe'#13#10'/e:z';
    iSwitch := 1;
    iIndex := 2;
    Try
      GetDateType(slParams, iSwitch, iIndex, DateType);
    Except
      On E : ESearchException Do
        Check(True);
      Else
        Check(False);
    End;
    slParams.Text := 'my.exe'#13#10'/e:c';
    iSwitch := 1;
    iIndex := 2;
    GetDateType(slParams, iSwitch, iIndex, DateType);
    Check(dtCreation = DateType, 'Test 1');
    slParams.Text := 'my.exe'#13#10'/e:a';
    iSwitch := 1;
    iIndex := 2;
    GetDateType(slParams, iSwitch, iIndex, DateType);
    Check(dtLastAccess = DateType, 'Test 2');
    slParams.Text := 'my.exe'#13#10'/e:w';
    iSwitch := 1;
    iIndex := 2;
    GetDateType(slParams, iSwitch, iIndex, DateType);
    Check(dtLastWrite = DateType, 'Test 3');
  Finally
    slParams.Free;
  End;
end;

procedure TestApplicationFunctions.TestGetExclusions;

Var
  slParams : TStringList;
  iSwitch, iIndex : Integer;
  strExlFileName : String;

begin
  slParams := TStringList.Create;
  Try
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/x';
    Try
      GetExclusions(slParams, iSwitch, iIndex, strExlFileName);
    Except
      On E : ESearchException Do
        Check(True);
      Else
        Check(False);
    End;
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/x[';
    Try
      GetExclusions(slParams, iSwitch, iIndex, strExlFileName);
    Except
      On E : ESearchException Do
        Check(True);
      Else
        Check(False);
    End;
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/x[filename';
    Try
      GetExclusions(slParams, iSwitch, iIndex, strExlFileName);
    Except
      On E : ESearchException Do
        Check(True);
      Else
        Check(False);
    End;
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/x[filename]';
    GetExclusions(slParams, iSwitch, iIndex, strExlFileName);
    CheckEquals('filename', strExlFileName, 'Test 1');
  Finally
    slParams.Free;
  End;
end;

procedure TestApplicationFunctions.TestGetOrderBy;

Var
  slParams : TStringList;
  iSwitch, iIndex : Integer;
  OrderFilesDirection : TOrderDirection;
  OrderFilesBy : TOrderBy;


begin
  slParams := TStringList.Create;
  Try
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/o';
    Try
      GetOrderBy(slParams, iSwitch, iIndex, OrderFilesDirection, OrderFilesBy);
    Except
      On E: Exception Do
        Check(True);
      Else
        Check(False);
    End;
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/o:';
    Try
      GetOrderBy(slParams, iSwitch, iIndex, OrderFilesDirection, OrderFilesBy);
    Except
      On E: Exception Do
        Check(True);
      Else
        Check(False);
    End;
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/o:z';
    Try
      GetOrderBy(slParams, iSwitch, iIndex, OrderFilesDirection, OrderFilesBy);
    Except
      On E: Exception Do
        Check(True);
      Else
        Check(False);
    End;
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/o:n';
    GetOrderBy(slParams, iSwitch, iIndex, OrderFilesDirection, OrderFilesBy);
    Check(OrderFilesDirection = odAscending, 'Test 1.1');
    Check(OrderFilesBy = obName, 'Test 1.2');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/o:+n';
    GetOrderBy(slParams, iSwitch, iIndex, OrderFilesDirection, OrderFilesBy);
    Check(OrderFilesDirection = odAscending, 'Test 1.3');
    Check(OrderFilesBy = obName, 'Test 1.4');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/o:-n';
    GetOrderBy(slParams, iSwitch, iIndex, OrderFilesDirection, OrderFilesBy);
    Check(OrderFilesDirection = odDescending, 'Test 1.5');
    Check(OrderFilesBy = obName, 'Test 1.6');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/o:a';
    GetOrderBy(slParams, iSwitch, iIndex, OrderFilesDirection, OrderFilesBy);
    Check(OrderFilesDirection = odAscending, 'Test 2.1');
    Check(OrderFilesBy = obAttribute, 'Test 2.2');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/o:+a';
    GetOrderBy(slParams, iSwitch, iIndex, OrderFilesDirection, OrderFilesBy);
    Check(OrderFilesDirection = odAscending, 'Test 2.3');
    Check(OrderFilesBy = obAttribute, 'Test 2.4');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/o:-a';
    GetOrderBy(slParams, iSwitch, iIndex, OrderFilesDirection, OrderFilesBy);
    Check(OrderFilesDirection = odDescending, 'Test 2.5');
    Check(OrderFilesBy = obAttribute, 'Test 2.6');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/o:d';
    GetOrderBy(slParams, iSwitch, iIndex, OrderFilesDirection, OrderFilesBy);
    Check(OrderFilesDirection = odAscending, 'Test 3.1');
    Check(OrderFilesBy = obDate, 'Test 3.2');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/o:+d';
    GetOrderBy(slParams, iSwitch, iIndex, OrderFilesDirection, OrderFilesBy);
    Check(OrderFilesDirection = odAscending, 'Test 3.3');
    Check(OrderFilesBy = obDate, 'Test 3.4');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/o:-d';
    GetOrderBy(slParams, iSwitch, iIndex, OrderFilesDirection, OrderFilesBy);
    Check(OrderFilesDirection = odDescending, 'Test 3.5');
    Check(OrderFilesBy = obDate, 'Test 3.6');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/o:o';
    GetOrderBy(slParams, iSwitch, iIndex, OrderFilesDirection, OrderFilesBy);
    Check(OrderFilesDirection = odAscending, 'Test 4.1');
    Check(OrderFilesBy = obOwner, 'Test 4.2');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/o:+o';
    GetOrderBy(slParams, iSwitch, iIndex, OrderFilesDirection, OrderFilesBy);
    Check(OrderFilesDirection = odAscending, 'Test 4.3');
    Check(OrderFilesBy = obOwner, 'Test 4.4');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/o:-o';
    GetOrderBy(slParams, iSwitch, iIndex, OrderFilesDirection, OrderFilesBy);
    Check(OrderFilesDirection = odDescending, 'Test 4.5');
    Check(OrderFilesBy = obOwner, 'Test 4.6');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/o:s';
    GetOrderBy(slParams, iSwitch, iIndex, OrderFilesDirection, OrderFilesBy);
    Check(OrderFilesDirection = odAscending, 'Test 5.1');
    Check(OrderFilesBy = obSize, 'Test 5.2');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/o:+s';
    GetOrderBy(slParams, iSwitch, iIndex, OrderFilesDirection, OrderFilesBy);
    Check(OrderFilesDirection = odAscending, 'Test 5.3');
    Check(OrderFilesBy = obSize, 'Test 5.4');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/o:-s';
    GetOrderBy(slParams, iSwitch, iIndex, OrderFilesDirection, OrderFilesBy);
    Check(OrderFilesDirection = odDescending, 'Test 5.5');
    Check(OrderFilesBy = obSize, 'Test 5.6');
  Finally
    slParams.Free;
  End;
end;

procedure TestApplicationFunctions.TestGetOwnerSwitch;

Var
  slParams : TStringList;
  iSwitch, iIndex : Integer;
  OwnerSearch : TOwnerSearch;
  OwnerSearchPos : TOwnerSearchPos;
  strOwnerSearch : String;

begin
  slParams := TStringList.Create;
  Try
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/w';
    GetOwnerSwitch(slParams, iSwitch, iIndex, OwnerSearch, OwnerSearchPos, strOwnerSearch);
    Check(OwnerSearch = osEquals, 'Test 1.1');
    Check(OwnerSearchPos = ospNone, 'Test 1.2');
    CheckEquals('', strOwnerSearch, 'Test 1.3');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/w[';
    Try
      GetOwnerSwitch(slParams, iSwitch, iIndex, OwnerSearch, OwnerSearchPos, strOwnerSearch);
    Except
      On E: Exception Do
        Check(True);
      Else
        Check(False);
    End;
    slParams.Text := 'my.exe'#13#10'/w[HoylD';
    Try
      GetOwnerSwitch(slParams, iSwitch, iIndex, OwnerSearch, OwnerSearchPos, strOwnerSearch);
    Except
      On E: Exception Do
        Check(True);
      Else
        Check(False);
    End;
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/w[hoyld]';
    GetOwnerSwitch(slParams, iSwitch, iIndex, OwnerSearch, OwnerSearchPos, strOwnerSearch);
    Check(OwnerSearch = osEquals, 'Test 2.1');
    Check(OwnerSearchPos = ospExact, 'Test 2.2');
    CheckEquals('hoyld', strOwnerSearch, 'Test 2.3');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/w[!hoyld]';
    GetOwnerSwitch(slParams, iSwitch, iIndex, OwnerSearch, OwnerSearchPos, strOwnerSearch);
    Check(OwnerSearch = osNotEquals, 'Test 3.1');
    Check(OwnerSearchPos = ospExact, 'Test 3.2');
    CheckEquals('hoyld', strOwnerSearch, 'Test 3.3');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/w[*hoyld]';
    GetOwnerSwitch(slParams, iSwitch, iIndex, OwnerSearch, OwnerSearchPos, strOwnerSearch);
    Check(OwnerSearch = osEquals, 'Test 4.1');
    Check(OwnerSearchPos = ospEnd, 'Test 4.2');
    CheckEquals('hoyld', strOwnerSearch, 'Test 4.3');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/w[!*hoyld]';
    GetOwnerSwitch(slParams, iSwitch, iIndex, OwnerSearch, OwnerSearchPos, strOwnerSearch);
    Check(OwnerSearch = osNotEquals, 'Test 5.1');
    Check(OwnerSearchPos = ospEnd, 'Test 5.2');
    CheckEquals('hoyld', strOwnerSearch, 'Test 5.3');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/w[hoyld*]';
    GetOwnerSwitch(slParams, iSwitch, iIndex, OwnerSearch, OwnerSearchPos, strOwnerSearch);
    Check(OwnerSearch = osEquals, 'Test 6.1');
    Check(OwnerSearchPos = ospStart, 'Test 6.2');
    CheckEquals('hoyld', strOwnerSearch, 'Test 6.3');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/w[!hoyld*]';
    GetOwnerSwitch(slParams, iSwitch, iIndex, OwnerSearch, OwnerSearchPos, strOwnerSearch);
    Check(OwnerSearch = osNotEquals, 'Test 7.1');
    Check(OwnerSearchPos = ospStart, 'Test 7.2');
    CheckEquals('hoyld', strOwnerSearch, 'Test 7.3');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/w[*hoyld*]';
    GetOwnerSwitch(slParams, iSwitch, iIndex, OwnerSearch, OwnerSearchPos, strOwnerSearch);
    Check(OwnerSearch = osEquals, 'Test 8.1');
    Check(OwnerSearchPos = ospMiddle, 'Test 8.2');
    CheckEquals('hoyld', strOwnerSearch, 'Test 8.3');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/w[!*hoyld*]';
    GetOwnerSwitch(slParams, iSwitch, iIndex, OwnerSearch, OwnerSearchPos, strOwnerSearch);
    Check(OwnerSearch = osNotEquals, 'Test 9.1');
    Check(OwnerSearchPos = ospMiddle, 'Test 9.2');
    CheckEquals('hoyld', strOwnerSearch, 'Test 9.3');
  Finally
    slParams.Free;
  End;
end;

procedure TestApplicationFunctions.TestGetRangeString;

Var
  slParams : TStringList;
  iSwitch, iIndex : Integer;
  chEndToken : Char;
  strExceptionMsg : String;
  strValue : String;

begin
  slParams := TStringList.Create;
  Try
    iSwitch := 1;
    iIndex := 3;
    chEndToken := '-';
    slParams.Text := 'my.exe'#13#10'/s[1000-2000]';
    GetRangeString(slParams, chEndToken, strExceptionMsg, iIndex, iSwitch, strValue);
    CheckEquals('1000', strValue, 'Test 1');
    iSwitch := 1;
    iIndex := 8;
    chEndToken := ']';
    slParams.Text := 'my.exe'#13#10'/s[1000-2000]';
    GetRangeString(slParams, chEndToken, strExceptionMsg, iIndex, iSwitch, strValue);
    CheckEquals('2000', strValue, 'Test 2');
    iSwitch := 1;
    iIndex := 8;
    chEndToken := 'z';
    slParams.Text := 'my.exe'#13#10'/s[1000-2000]';
    Try
      GetRangeString(slParams, chEndToken, strExceptionMsg, iIndex, iSwitch, strValue);
    Except
      On E : ESearchException Do
        Check(True);
      Else
        Check(False);
    End;
  Finally
    slParams.Free;
  End;
end;

procedure TestApplicationFunctions.TestGetSearchInInfo;

Var
  slParams : TStringList;
  iSwitch, iIndex : Integer;
  strSearchInText : String;

begin
  slParams := TStringList.Create;
  Try
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/i';
    Try
      GetSearchInInfo(slParams, iSwitch, iIndex, strSearchInText);
    Except
      On E: ESearchException Do
        Check(True);
      Else
        Check(False);
    End;
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/i[';
    Try
      GetSearchInInfo(slParams, iSwitch, iIndex, strSearchInText);
    Except
      On E: ESearchException Do
        Check(True);
      Else
        Check(False);
    End;
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/i[hello';
    Try
      GetSearchInInfo(slParams, iSwitch, iIndex, strSearchInText);
    Except
      On E: ESearchException Do
        Check(True);
      Else
        Check(False);
    End;
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/i[hello]';
    GetSearchInInfo(slParams, iSwitch, iIndex, strSearchInText);
    CheckEquals('hello', strSearchInText, 'Test 1');
  Finally
    slParams.Free;
  End;
end;

procedure TestApplicationFunctions.TestGetSizeRange;

Var
  slParams : TStringList;
  iSwitch, iIndex : Integer;
  iLSize, iUSize : Int64;

begin
  slParams := TStringList.Create;
  Try
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/z';
    Try
      GetSizeRange(slParams, iSwitch, iIndex, iLSize, iUSize);
    Except
      On E : ESearchException Do
        Check(True);
      Else
        Check(False);
    End;
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/z[';
    Try
      GetSizeRange(slParams, iSwitch, iIndex, iLSize, iUSize);
    Except
      On E : ESearchException Do
        Check(True);
      Else
        Check(False);
    End;
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/z[-';
    Try
      GetSizeRange(slParams, iSwitch, iIndex, iLSize, iUSize);
    Except
      On E : ESearchException Do
        Check(True);
      Else
        Check(False);
    End;
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/z[-]';
    GetSizeRange(slParams, iSwitch, iIndex, iLSize, iUSize);
    CheckEquals(0, iLSize, 'Test 1.1');
    CheckEquals($F00000000000000, iUSize, 'Test 1.2');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/z[1000-]';
    GetSizeRange(slParams, iSwitch, iIndex, iLSize, iUSize);
    CheckEquals(1000, iLSize, 'Test 2.1');
    CheckEquals($F00000000000000, iUSize, 'Test 2.2');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/z[-2000]';
    GetSizeRange(slParams, iSwitch, iIndex, iLSize, iUSize);
    CheckEquals(0, iLSize, 'Test 3.1');
    CheckEquals(2000, iUSize, 'Test 3.2');
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/z[1000-2000]';
    GetSizeRange(slParams, iSwitch, iIndex, iLSize, iUSize);
    CheckEquals(1000, iLSize, 'Test 4.1');
    CheckEquals(2000, iUSize, 'Test 4.2');
  Finally
    slParams.Free;
  End;
end;

procedure TestApplicationFunctions.TestGetSummaryLevel;

Var
  slParams : TStringList;
  iSwitch, iIndex, iSummaryLevel : Integer;

begin
  slParams := TStringList.Create;
  Try
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/1';
    iSummaryLevel := 1;
    Try
      GetSummaryLevel(slParams, iSwitch, iIndex, iSummaryLevel);
    Except
      On E : ESearchException Do
        Check(True);
      Else
        Check(False);
    End;
    iSwitch := 1;
    iIndex := 2;
    slParams.Text := 'my.exe'#13#10'/1';
    iSummaryLevel := 0;
    GetSummaryLevel(slParams, iSwitch, iIndex, iSummaryLevel);
    CheckEquals(1, iSummaryLevel, 'Test 1.1');
  Finally
    slParams.Free;
  End;
end;

procedure TestApplicationFunctions.TestIncrementSwitchPosition;

Var
  sl : TStringList;
  iIndex, iSwitch : Integer;

begin
  sl := TstringList.Create;
  Try
    sl.Add('EXE');
    sl.Add('Item1');
    sl.Add('Item2');
    iIndex := 1;
    iSwitch := 1;
    IncrementSwitchPosition(sl, iIndex, iSwitch, 'Test Failure.');
    CheckEquals(2, iIndex);
    iIndex := 5;
    iSwitch := 1;
    Try
      IncrementSwitchPosition(sl, iIndex, iSwitch, 'Test Failure.');
    Except
      On E : ESearchException Do
        Check(True);
      Else
        Check(False);
    End;
  Finally
    sl.Free;
  End;
end;

procedure TestApplicationFunctions.TestOutputAttributes;

Var
  S : String;

begin
  S := OutputAttributes(0);
  CheckEquals('....F..', S, '....F..');
  S := OutputAttributes(faArchive);
  CheckEquals('.A..F..', S, '.A..F..');
  S := OutputAttributes(faReadOnly);
  CheckEquals('R...F..', S, 'R...F..');
  S := OutputAttributes(faSysFile);
  CheckEquals('..S.F..', S, '..S.F..');
  S := OutputAttributes(faHidden);
  CheckEquals('...HF..', S, '...HF..');
  S := OutputAttributes(faReadOnly Or faArchive Or faSysFile Or faHidden);
  CheckEquals('RASHF..', S, 'RASHF..');
  S := OutputAttributes(faReadOnly Or faArchive Or faSysFile Or faHidden or faDirectory);
  CheckEquals('RASH.D.', S, 'RASH.D.');
  S := OutputAttributes(faReadOnly Or faArchive Or faSysFile Or faHidden Or faVolumeID);
  CheckEquals('RASH..V', S, 'RASH..V');
end;

initialization
  // Register any test cases with the test runner
  RegisterTest('Application Functions', TestApplicationFunctions.Suite);
end.

