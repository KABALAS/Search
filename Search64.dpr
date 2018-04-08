(**

 This module defines the Search Win32 console application. This application
 is designed to provide regular expression search capabilities for files on
 disk.

 @Version 1.2
 @Author  David Hoyle
 @Date    08 Apr 2018

 **)
Program Search64;

{$APPTYPE CONSOLE}
{$R *.RES}          



{$R 'SearchVersionInfo.res' 'SearchVersionInfo.RC'}

uses
  {$IFDEF EurekaLog}
  EMemLeaks,
  EResLeaks,
  ESendMailMAPI,
  ESendMailSMAPI,
  EDialogConsole,
  EDebugExports,
  EDebugJCL,
  EMapWin32,
  EAppConsole,
  ExceptionLog7,
  {$ENDIF EurekaLog}
  SysUtils,
  Search.FilesCls in 'Source\Search.FilesCls.pas',
  Search.Functions in 'Source\Search.Functions.pas',
  SearchEngine in 'Source\SearchEngine.pas',
  Search.Types in 'Source\Search.Types.pas',
  Search.RegExMatches in 'Source\Search.RegExMatches.pas',
  Search.FileCls in 'Source\Search.FileCls.pas',
  Search.Interfaces in 'Source\Search.Interfaces.pas';

ResourceString
  (** A resource string to define the Exception output format. **)
  strException = 'ESearchException: %s';
  (** A resource string for formatting information. **)
  strPressEnterToFinish = 'Press <Enter> to finish.';

Var
  (** A variable to hold whether an exception has occurred. **)
  boolException: Boolean;
  (** An interface reference for calling the search engine. **)
  SearchEngine : ISearchEngine;

Begin
  {$IFDEF EUREKALOG}
  SetEurekaLogState(DebugHook = 0);
  {$ENDIF}
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  boolException := False;
  SearchEngine := TSearch.Create;
  Try
    SearchEngine.Run;
  Except
    On E: ESearchException Do
      Begin
        OutputToConsoleLn(SearchEngine.ErrHnd, Format(strException, [E.Message]),
          SearchEngine.ExceptionColour);
        boolException := True;
      End;
  End;
  If clsDebug In CommandLineSwitches Then
    Begin
      OutputToConsoleLn(SearchEngine.StdHnd);
      OutputToConsole(SearchEngine.StdHnd, strPressEnterToFinish);
      Readln;
    End;
  If boolException Then
    Halt(1);
End.
