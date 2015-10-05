(**

 This module defines the Search Win32 console application. This application
 is designed to provide regular expression search capabilities for files on
 disk.

 @Version 1.0
 @Author  David Hoyle
 @Date    17 Dec 2012

 **)
Program Search64;

{$APPTYPE CONSOLE}
{$R *.RES}          

{$R 'Search64VersionInfo.res' 'Search64VersionInfo.RC'}

uses
  SysUtils,
  DGHLibrary in '..\..\library\DGHLibrary.pas',
  FileHandling in 'Source\FileHandling.pas',
  checkforupdates in '..\..\LIBRARY\checkforupdates.pas',
  ApplicationFunctions in 'Source\ApplicationFunctions.pas',
  SearchEngine in 'Source\SearchEngine.pas';

ResourceString
  (** A resource string to define the Exception output format. **)
  strException = 'ESearchException: %s';
  (** A resource string for formatting information. **)
  strPressEnterToFinish = 'Press <Enter> to finish.';

Var
  (** A variable to hold whether an exception has occurred. **)
  boolException: Boolean;

Begin
  {$IFDEF EURALOG}
  SetEurekaLogState(Not IsDebuggerPresent);
  {$ENDIF}
  ReportMemoryLeaksOnShutdown := IsDebuggerPresent;
  boolException := False;
  With TSearch.Create Do
    Try
      Try
        Run;
      Except
        On E: ESearchException Do
          Begin
            OutputToConsoleLn(ErrorHnd, Format(strException, [E.Message]), ExceptionColour);
            boolException := True;
          End;
      End;
      If clsDebug In CommandLineSwitches Then
        Begin
          OutputToConsoleLn(StdHnd);
          OutputToConsole(StdHnd, strPressEnterToFinish);
          Readln;
        End;
    Finally
      Free;
    End;
  If boolException Then
    Halt(1);
End.