unit exemple_api_embed_pix;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  // --- UNITS DO MOTOR INDY (NATIVAS/DATAWARE) ---
  IdHTTP,              // O componente que faz o POST
  IdSSLOpenSSL,        // O componente que gerencia o SSL/TLS
  IdIOHandler,
  IdIOHandlerSocket,
  IdSSL,
  uRESTDWIdBase, uRESTDWAbout, uRESTDWBasicClass;       // Mantemos para compatibilidade visual

type
  TForm1 = class(TForm)
    // Visuais
    EditUser: TEdit;
    EditPass: TEdit;
    ButtonLogin: TButton;
    MemoLog: TMemo;

    // Visual (Deixamos aqui para não dar erro no Form, mas não vamos usar no código)
    DWClient: TRESTDWIdClientREST;

    procedure ButtonLoginClick(Sender: TObject);
  private
    function ExtractToken(const AJson: string): string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

// Se o Delphi reclamar que não conhece sslvTLSv1_2, usamos essa constante
const
  // Constante para TLS 1.2
  MY_TLS_1_2 = 5;

function TForm1.ExtractToken(const AJson: string): string;
var
  PosIni, PosFim: Integer;
  Key: string;
begin
  Result := '';
  Key := '"access_token":"';
  PosIni := Pos(Key, AJson);
  if PosIni > 0 then
  begin
    PosIni := PosIni + Length(Key);
    PosFim := Pos('"', Copy(AJson, PosIni, Length(AJson)));
    if PosFim > 0 then
      Result := Copy(AJson, PosIni, PosFim - 1);
  end;
end;

procedure TForm1.ButtonLoginClick(Sender: TObject);
var
  // Componentes Puros do Indy (Criação Manual)
  IdHTTP: TIdHTTP;
  IdSSL: TIdSSLIOHandlerSocketOpenSSL;
  vParams: TStringList;
  vResponse: string;
  vURL: string;
  Token: string;
begin
  vURL := 'https://sandbox.bcodex.io/bcdx-sso/login';

  // Criamos os componentes na memória
  IdHTTP := TIdHTTP.Create(nil);
  IdSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  vParams := TStringList.Create;

  try
    MemoLog.Lines.Clear;
    MemoLog.Lines.Add('Configurando TLS 1.2...');

    // --- A MÁGICA DO SSL ACONTECE AQUI ---
    try
       IdSSL.SSLOptions.Method := TIdSSLVersion(MY_TLS_1_2); // Força TLS 1.2
       IdSSL.SSLOptions.Mode := sslmClient;
    except
       // Fallback caso a versão do Indy não tenha o Enum exato
       IdSSL.SSLOptions.Method := sslvTLSv1;
    end;

    // Liga o SSL ao HTTP
    IdHTTP.IOHandler := IdSSL;

    // Configura Headers e Parâmetros
    IdHTTP.Request.ContentType := 'application/x-www-form-urlencoded';
    IdHTTP.Request.UserAgent := 'Mozilla/5.0'; // Ajuda a não ser bloqueado

    vParams.Add('username=' + EditUser.Text);
    vParams.Add('password=' + EditPass.Text);

    MemoLog.Lines.Add('Conectando em: ' + vURL);

    try
      // Faz o POST
      vResponse := IdHTTP.Post(vURL, vParams);

      MemoLog.Lines.Add('LOGIN SUCESSO! (Status 200)');

      // Extrai Token
      Token := ExtractToken(vResponse);

      if Token <> '' then
      begin
        MemoLog.Lines.Add('-----------------------------');
        MemoLog.Lines.Add('TOKEN: ' + Token);
        MemoLog.Lines.Add('-----------------------------');
      end
      else
      begin
        MemoLog.Lines.Add('Token não encontrado.');
        MemoLog.Lines.Add(vResponse);
      end;

    except
      on E: EIdHTTPProtocolException do
      begin
        // Erro HTTP (400, 401, 500)
        MemoLog.Lines.Add('Erro HTTP: ' + IntToStr(IdHTTP.ResponseCode));
        MemoLog.Lines.Add('Resposta: ' + E.ErrorMessage);
      end;
      on E: Exception do
      begin
        // Erro Geral (Conexão, SSL, etc)
        MemoLog.Lines.Add('Erro Fatal: ' + E.Message);
      end;
    end;

  finally
    // Limpa a memória
    IdHTTP.Free;
    IdSSL.Free;
    vParams.Free;
  end;
end;

end.
