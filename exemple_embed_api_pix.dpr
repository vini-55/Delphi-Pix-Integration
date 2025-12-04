program exemple_embed_api_pix;

uses
  Vcl.Forms,
  exemple_api_embed_pix in 'exemple_api_embed_pix.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
