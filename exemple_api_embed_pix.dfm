object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object EditUser: TEdit
    Left = 24
    Top = 192
    Width = 121
    Height = 23
    TabOrder = 0
    Text = 'Usu'#225'rio'
  end
  object EditPass: TEdit
    Left = 24
    Top = 240
    Width = 121
    Height = 23
    TabOrder = 1
    Text = 'Senha'
  end
  object ButtonLogin: TButton
    Left = 134
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Gerar Token'
    TabOrder = 2
    OnClick = ButtonLoginClick
  end
  object MemoLog: TMemo
    Left = 24
    Top = 344
    Width = 185
    Height = 89
    Lines.Strings = (
      'MemoLog')
    TabOrder = 3
  end
  object DWClient: TRESTDWIdClientREST
    UseSSL = False
    UserAgent = 
      'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, l' +
      'ike Gecko) Chrome/41.0.2227.0 Safari/537.36'
    Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Charset = 'utf8'
    ContentEncoding = 'gzip, identity'
    MaxAuthRetries = 0
    ContentType = 'application/x-www-form-urlencoded'
    RequestCharset = esUtf8
    RequestTimeOut = 5000
    ConnectTimeOut = 5000
    RedirectMaximum = 1
    AllowCookies = False
    HandleRedirects = False
    AuthenticationOptions.AuthorizationOption = rdwAONone
    AccessControlAllowOrigin = '*'
    ProxyOptions.ProxyPort = 0
    VerifyCert = False
    SSLVersions = []
    CertMode = sslmUnassigned
    PortCert = 0
    Left = 280
    Top = 328
  end
end
