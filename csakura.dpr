program csakura;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes,
  use_sakura_dll in 'use_sakura_dll.pas';

procedure showHelp;
begin
  Writeln('=== sakuramml.com ===');
  Writeln('[USAGE]');
  Writeln('csakura mmlfile [midifile]');
  Writeln('csakura -e mmlcode [midifile]');
end;

var
  i: Integer;
  mml, midi, src: string;
  s: TStringList;
begin
  i := 1;
  mml := '';
  midi := '';
  src := '';
  while i <= ParamCount do
  begin
    // Check Parmeter options
    if ParamStr(i) = '-e' then
    begin
      Inc(i);
      src := ParamStr(i);
      Inc(i);
      continue;
    end;
    // get source code
    if (src = '') and (mml = '') then begin
      mml := ParamStr(i);
      Inc(i);
      continue;
    end;
    if (mml <> '') and (midi = '') then begin
      midi := ParamStr(i);
      Inc(i);
      continue;
    end;
    // WriteLn(ParamStr(i));
    Inc(i);
  end;

  if (src <> '') and (midi = '') then begin
    midi := 'a.mid';
  end else begin
    if (mml <> '') and (midi = '') then begin
      midi := ChangeFileExt(mml, '.mid');
    end;
    if mml = '' then
    begin
      showHelp;
      Exit;
    end;
    // �\�[�X�R�[�h�̓ǂݍ���
    s := TStringList.Create;
    try
      try
        s.LoadFromFile(mml);
        src := s.Text;
      except
        Writeln('Failed .. Could not load mml file: ', mml);
        Exit;
      end;
    finally
      s.Free;
    end;
  end;

  if mmlCompile(src, midi) then
  begin
    Writeln('Success!');
  end else begin
    Writeln('Failed...');
    Writeln(mmlErrorMessage);
  end;
  
end.