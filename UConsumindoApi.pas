unit UConsumindoApi;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ComCtrls, Vcl.ExtCtrls,System.JSON, Vcl.Mask,System.StrUtils, Data.DB,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.Imaging.pngimage, Vcl.NumberBox,
  REST.Authenticator.Basic,Data.DBXJSON,RESTRequest4D;

type
  TFConsumindoApi = class(TForm)
    rcPedido: TRESTClient;
    rqPedido: TRESTRequest;
    rpPedido: TRESTResponse;
    cdsItens: TClientDataSet;
    dsItens: TDataSource;
    cdsItensseq: TIntegerField;
    cdsItensproduto: TStringField;
    cdsItensQtd: TIntegerField;
    cdsItensTotal: TCurrencyField;
    cdsItensvalor: TCurrencyField;
    PgJson: TPageControl;
    Aba2: TTabSheet;
    Pagina: TPageControl;
    Pag1: TTabSheet;
    Pag2: TTabSheet;
    DBGrid1: TDBGrid;
    Aba1: TTabSheet;
    TbCadastro: TPageControl;
    AbaCliente: TTabSheet;
    Label9: TLabel;
    edCliente: TEdit;
    Label10: TLabel;
    edCpfCli: TEdit;
    Image1: TImage;
    SpeedButton1: TSpeedButton;
    cdsCliente: TClientDataSet;
    dsCliente: TDataSource;
    cdsClienteCliente: TStringField;
    cdsClientecpf: TStringField;
    dbgCliente: TDBGrid;
    cdsClienteCodcli: TIntegerField;
    rqCadastro: TRESTRequest;
    rcCadastro: TRESTClient;
    rpCadastro: TRESTResponse;
    AbaProduto: TTabSheet;
    Label11: TLabel;
    edProduto: TEdit;
    Label12: TLabel;
    edpreco: TEdit;
    Image2: TImage;
    btnProduto: TSpeedButton;
    cdsProduto: TClientDataSet;
    dsProduto: TDataSource;
    ddgProduto: TDBGrid;
    cdsProdutoCodProd: TIntegerField;
    cdsProdutoProduto: TStringField;
    cdsProdutopreco: TCurrencyField;
    Texto: TTabSheet;
    MRespostaJson: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    edNum: TEdit;
    BtnPesquisar: TBitBtn;
    rdJson: TRadioGroup;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Panel2: TPanel;
    edPedido: TEdit;
    edNome: TEdit;
    edCpf: TEdit;
    edData: TMaskEdit;
    Panel3: TPanel;
    edValor: TEdit;
    Panel4: TPanel;
    EdStatus: TEdit;
    Label3: TLabel;
    edPedcli: TEdit;
    Label2: TLabel;
    Panel5: TPanel;
    EdNomecli: TEdit;
    Label13: TLabel;
    Panel6: TPanel;
    EdPedNomeProd: TEdit;
    Label14: TLabel;
    Panel7: TPanel;
    EdPedPreco: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    EdPedQtd: TNumberBox;
    Panel8: TPanel;
    EdPedTot: TEdit;
    Image3: TImage;
    EdPedProd: TEdit;
    DBGrid2: TDBGrid;
    btnSalvar: TBitBtn;
    cdsItensSubtotal: TAggregateField;
    AbaUsuario: TTabSheet;
    Label17: TLabel;
    Label18: TLabel;
    Image4: TImage;
    edUsuario: TEdit;
    edSenha: TEdit;
    gpEnvio: TRadioGroup;
    AbaAuth: TTabSheet;
    Label19: TLabel;
    Label20: TLabel;
    Image5: TImage;
    edautusu: TEdit;
    edautsenha: TEdit;
    Mauth: TMemo;
    procedure BtnPesquisarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure btnProdutoClick(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure EdPedQtdExit(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure edPedcliExit(Sender: TObject);
    procedure EdPedProdExit(Sender: TObject);
    procedure edprecoExit(Sender: TObject);
    procedure edCpfCliExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edprecoKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure edSenhaExit(Sender: TObject);
    procedure TbCadastroChange(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure edautsenhaExit(Sender: TObject);
  private
    { Private declarations }
    Url :String;
    Json : String;
    JJson : TJSONObject;
    procedure BuscaApi(STipo, sUrl,Scodigo,sdata: String);
  public
    { Public declarations }
    procedure LimparCampos;
    procedure Colorir(sTexto : string);
    function AdicinaCadastro(sTipo,sNome, Scpf,sUrl,spreco,sSenha: String; bTipUsu : Boolean) : Boolean;
    procedure Salvar(STipo : String);
  end;

var
  FConsumindoApi: TFConsumindoApi;

implementation

{$R *.dfm}

uses UJsonDTO,Uusuario;

function TFConsumindoApi.AdicinaCadastro(sTipo,sNome, Scpf,sUrl,spreco,sSenha: String; bTipUsu : Boolean) : Boolean;
var
 JsonBody : TJSONObject;
 lJsonResponse : IResponse;
 token : String;
 jsonResposta: TJSONObject;
 JsonResp : String;
begin
  Result := True;
  token := Mauth.Lines.Text;
  if gpEnvio.ItemIndex = 1 then
  begin
    if sTipo = 'C' then // Cliente
    begin
    lJsonResponse := TRequest.New.BaseURL(sUrl)
            .ContentType('application/json')
            .TokenBearer(token)
            .AddBody('{"nome":"'+ sNome + '","cpf":"' + Scpf +'","}')
            .Post;
    end;
  end
  Else
  if gpEnvio.ItemIndex = 0 then
  begin
    Try
      Try
        JsonBody := TJSONObject.Create;

        if sTipo = 'C' then // Cliente
        begin
          JsonBody.AddPair('nome',sNome);
          JsonBody.AddPair('cpf',Scpf);
        end
        else
        if sTipo = 'P' then // Produto
        begin
          JsonBody.AddPair('descricao',sNome);
          JsonBody.AddPair('preco', TJSONNumber.Create(StrToCurr(spreco)));
        end
        else
        if sTipo = 'U' then // Usuário
        begin
          JsonBody.AddPair('login',sNome);
          JsonBody.AddPair('senha',sSenha);
          JsonBody.AddPair('admin', TJSONBool.Create(bTipUsu));
        end
        else
        if sTipo = 'A' then // Autenticação
        begin
          JsonBody.AddPair('login',sNome);
          JsonBody.AddPair('senha',sSenha);
        end;

        // post
        rqCadastro.Params.Clear;
        rcCadastro.Authenticator := nil;

        rcCadastro.BaseURL :=  sUrl;

        if (sTipo = 'P') or (sTipo = 'C') then // Usuário
        begin
         rqCadastro.AcceptEncoding:='UTF-8';

          rqCadastro.Params.AddHeader('Authorization',
            'Bearer ' + token);
        end;

        rqCadastro.Body.ClearBody;
        rqCadastro.Body.Add(JsonBody.ToString, ContentTypeFromString('application/json'));

        rqCadastro.Method := rmPOST;

        rqCadastro.Execute;

        // trata o retorno
        if rqCadastro.Response.StatusCode = 403  then
        begin
          ShowMessage('Api Forbidden');
          exit;
        end
        else
        begin
           if sTipo = 'C' then
            ShowMessage('Cliente enviado para Api com sucesso')
           else
           if sTipo = 'P' then
            ShowMessage('Produto enviado para Api com sucesso')
           else
           if sTipo = 'U' then
             ShowMessage('Usuário enviado para Api com sucesso')
           else
           if sTipo = 'A' then
           begin
             JsonResp := '';
             Mauth.Clear;
             try
              // Obter os valores específicos do JSON
              Mauth.Lines.add(rqCadastro.Response.JSONText);

             // Ler o Json
             JsonResp := Mauth.Lines.Text;
             Mauth.Clear;

             jsonResposta := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JsonResp) ,0) as TJSONObject;
             // Alimenta o Pedido
             Mauth.Lines.Add(AnsiReplaceStr(jsonResposta.GetValue('token').ToString, '"', ''));
            finally
              jsonResposta.Free;
            end;
            ShowMessage('Usuário autenticado com sucesso');
           end;
        end;

      except on ex : Exception do
      begin
        if sTipo = 'A' then
          Application.MessageBox('Usuário não encontrado!' + #13 +
          'Usuário ou senha inválido! ','Atenção',MB_ICONEXCLAMATION)
        else
          ShowMessage('Erro da Api' + ex.Message);

        Result := False;
        exit;
      end;

      End;

    Finally
      JsonBody.DisposeOf;
    End;
  end;

end;

procedure TFConsumindoApi.BtnPesquisarClick(Sender: TObject);
var
   ArrayItem : TJSONArray;
   icodigo : integer;
   lJsonDTO : TJsonDTO;
   i : Integer;
begin
   LimparCampos;
   cdsItens.EmptyDataSet;
   MRespostaJson.Clear;

  Url:= 'http://localhost:8080/api/pedidos/' +
        edNum.Text;

  rcPedido.BaseURL :=  Url;
  rqPedido.Execute;
  MRespostaJson.Lines.add(rqPedido.Response.JSONText);

  // Ler o Json
  Json := MRespostaJson.Lines.Text;

  if Trim(Json) = ''   then
  begin
    Application.MessageBox('Pedido não encontrado!','Atenção',MB_ICONEXCLAMATION);
    edNum.Text := '';
    edNum.SetFocus;
    Abort;
  end;

  if rdJson.ItemIndex = 0 then
  begin
    // começa a desmontar o Json
    JJson := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json) ,0) as TJSONObject;

    // Alimenta o Pedido
    edPedido.Text := JJson.GetValue('codigo').ToString;
    edNome.Text := AnsiReplaceStr(JJson.GetValue('nomeCliente').ToString, '"', '');
    edCpf.Text := AnsiReplaceStr(JJson.GetValue('cpf').ToString, '"', '');
    edData.Text := AnsiReplaceStr(AnsiReplaceStr(JJson.GetValue('dataPedido').ToString, '"', ''),'\','');
    EdStatus.Text := AnsiReplaceStr(JJson.GetValue('status').ToString, '"', '');
    Colorir(EdStatus.Text);
    edValor.Text := AnsiReplaceStr(JJson.GetValue('total').ToString, '"', '');

    //  Alimenta o Itens
    ArrayItem := JJson.GetValue<TJSONArray>('items');

    for i := 0 to ArrayItem.Size - 1 do
    begin
        cdsItens.Append;
        cdsItensseq.AsInteger := i + 1;
        cdsItensproduto.AsString :=ArrayItem[i].GetValue<String>('descricaoProduto');
        cdsItensvalor.AsCurrency := StrToCurr( AnsiReplaceStr(ArrayItem[i].GetValue<String>('precoUnitario'), '.', ','));
        cdsItensQtd.AsString :=ArrayItem[i].GetValue<String>('quantidade');
        cdsItensTotal.AsCurrency := cdsItensvalor.AsCurrency  * cdsItensQtd.AsInteger ;
        cdsItens.Post;
    end;

    JJson.DisposeOf;
  end
  else
  begin
    lJsonDTO :=  TJsonDTO.Create(json);

    edPedido.Text := lJsonDTO.ObterCodigo;
    edNome.Text := AnsiReplaceStr(lJsonDTO.ObterNomeCliente, '"', '');
    edCpf.Text := AnsiReplaceStr(lJsonDTO.ObterCPF, '"', '');
    edData.Text := AnsiReplaceStr(AnsiReplaceStr(lJsonDTO.ObterDataPedido, '"', ''),'\','');
    EdStatus.Text := AnsiReplaceStr(lJsonDTO.ObterStatus, '"', '');
    Colorir(EdStatus.Text);
    edValor.Text := AnsiReplaceStr(lJsonDTO.ObterTotal, '"', '');

    //  Alimenta o Itens
    ArrayItem := lJsonDTO.ObterItens;

    for i := 0 to ArrayItem.Size - 1 do
    begin
        cdsItens.Append;
        cdsItensseq.AsInteger := i + 1;
        cdsItensproduto.AsString :=ArrayItem[i].GetValue<String>('descricaoProduto');
        cdsItensvalor.AsCurrency := StrToCurr( AnsiReplaceStr(ArrayItem[i].GetValue<String>('precoUnitario'), '.', ','));
        cdsItensQtd.AsString :=ArrayItem[i].GetValue<String>('quantidade');
        cdsItensTotal.AsCurrency := cdsItensvalor.AsCurrency  * cdsItensQtd.AsInteger ;
        cdsItens.Post;
    end;

    lJsonDTO.Destroy;

    Pagina.ActivePage := Pag2;
  end;

end;

procedure TFConsumindoApi.btnProdutoClick(Sender: TObject);
begin
  BuscaApi ('P','http://localhost:8080/api/produto','','S');
end;

procedure TFConsumindoApi.btnSalvarClick(Sender: TObject);
begin
  if Trim(edPedcli.Text) = '' then
  begin
    Application.MessageBox('Clientte não pode ser vazio!','Atenção',MB_ICONEXCLAMATION);
    edPedcli.SetFocus;
    exit;
  end;

  if Trim(EdPedProd.Text) = '' then
  begin
    Application.MessageBox('Produto não pode ser vazio!','Atenção',MB_ICONEXCLAMATION);
    EdPedProd.SetFocus;
    exit;
  end;

   cdsItens.Append;
   cdsItensseq.AsInteger := StrToInt( EdPedProd.Text);
   cdsItensproduto.AsString := EdPedNomeProd.Text;
   cdsItensvalor.AsCurrency := StrToCurr( EdPedPreco.Text);
   cdsItensQtd.AsInteger := EdPedQtd.ValueInt;
   cdsItensTotal.AsCurrency := StrToCurr(EdPedTot.Text) ;
   cdsItens.Post;

  EdPedProd.Clear;
  EdPedPreco.Clear;
  EdPedNomeProd.Clear;
  EdPedQtd.Clear;
  EdPedTot.Clear;
  edautsenha.Clear;
  edautusu.Clear;
  EdPedProd.SetFocus;
end;

procedure TFConsumindoApi.FormCreate(Sender: TObject);
begin
  PgJson.ActivePageIndex := 0;
  Pagina.ActivePageIndex := 0;
  TbCadastro.ActivePage := AbaUsuario;

  edCliente.Clear;
  edCpfCli.Clear;
  edProduto.Clear;
  edpreco.Text := '0,00';
  edPedcli.Clear;
  EdNomecli.Clear;
  EdPedProd.Clear;
  EdPedPreco.Clear;
  EdPedQtd.Clear;
  edSenha.Clear;
  edUsuario.Clear;
  cdsItens.CreateDataSet;
  cdsItens.Open;
  cdsCliente.CreateDataSet;
  cdsCliente.Open;
  cdsProduto.CreateDataSet;
  cdsProduto.Open;
end;

procedure TFConsumindoApi.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and not (ActiveControl is TMemo) then
     begin
          Perform(WM_NEXTDLGCTL,0,0);
     end;
end;

procedure TFConsumindoApi.FormShow(Sender: TObject);
begin
  edUsuario.SetFocus;
end;

procedure TFConsumindoApi.Image1Click(Sender: TObject);
begin
  Salvar('C');
end;

procedure TFConsumindoApi.Image2Click(Sender: TObject);
begin
    Salvar('P');
end;

procedure TFConsumindoApi.Image3Click(Sender: TObject);
var
 JsonPedido : TJSONObject;
 JsonProduto :TJSONObject;
 JsonArryItens : TJSONArray;
begin

    Try
      JsonPedido := TJSONObject.Create;
      JsonPedido.AddPair('cliente',edPedcli.Text);
      JsonPedido.AddPair('total', TJSONNumber.Create(StrToCurr(cdsItensSubtotal.Text)));

      JsonArryItens := TJSONArray.Create;

      cdsItens.DisableControls;
      cdsItens.First;

      while not cdsItens.Eof do
      begin
        JsonProduto := TJSONObject.Create;

        JsonProduto.AddPair('produto',TJSONNumber.Create(cdsItensseq.AsInteger));
        JsonProduto.AddPair('quantidade', TJSONNumber.Create(cdsItensQtd.AsInteger));

        JsonArryItens.AddElement(JsonProduto);

        cdsItens.Next;
      end;


      cdsItens.EnableControls;
      JsonPedido.AddPair('items',JsonArryItens);

      // post
      rqCadastro.Params.Clear;
      rqCadastro.Body.ClearBody; // Limpar o corpo da requisição
      rqCadastro.Method := rmPOST;
      rcCadastro.BaseURL :=  'http://localhost:8080/api/pedidos';

      rqCadastro.Body.Add(JsonPedido.ToString,
                            ContentTypeFromString('application/json'));// conten-type - dizendo que é um Json

      rqCadastro.Execute;

      // trata o retorno
      if rqCadastro.Response.StatusCode <> 201  then
      begin
        ShowMessage(rqCadastro.Response.ErrorMessage);
        exit;
      end
      else
      begin
          ShowMessage('Pedido ' + rpCadastro.Content + ' enviado para Api com sucesso');

      end;
    Finally

    End;

  edPedcli.Clear;
  EdNomecli.Clear;
  EdPedProd.Clear;
  EdPedPreco.Clear;
  EdPedNomeProd.Clear;
  EdPedQtd.Clear;
  EdPedTot.Clear;
  edPedcli.SetFocus;
  cdsItens.EmptyDataSet;

end;

procedure TFConsumindoApi.Image4Click(Sender: TObject);
begin
  Salvar('U');
end;

procedure TFConsumindoApi.Image5Click(Sender: TObject);
begin
  Salvar('A');
end;

procedure TFConsumindoApi.LimparCampos;
begin
  edPedido.Text := '';
  edNome.Text := '';
  edCpf.Text := '';
  edData.Text := '';
  EdStatus.Text := '';
  edValor.Text := '';

end;

procedure TFConsumindoApi.BuscaApi(STipo,sUrl,Scodigo,sdata : String);
var
 ArrayCliente : TJSONArray;
 ArrayProduto : TJSONArray;
 i : Integer;

begin
  if STipo = 'C' then
    cdsCliente.EmptyDataSet
  else
    cdsProduto.EmptyDataSet;

  Url:= sUrl;

  MRespostaJson.Lines.Clear;
  rcCadastro.BaseURL := Trim(Url + Scodigo);
  rqCadastro.Method := rmGET;
  rqCadastro.Execute;

  MRespostaJson.Lines.add(rqCadastro.Response.JSONText);

  // Ler o Json
  Json := MRespostaJson.Lines.Text;

  if STipo = 'C' then
  begin
    // começa a desmontar o Json
    if sdata = 'S' then
    begin
      ArrayCliente := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json) ,0) as TJSONArray;

      if ArrayCliente.Size > 0 then
      begin
        for i := 0 to ArrayCliente.Size - 1 do
        begin
          cdsCliente.Append;
          cdsClienteCodcli.AsInteger := ArrayCliente[i].GetValue<Integer>('id');
          cdsClienteCliente.AsString := ArrayCliente[i].GetValue<String>('nome');
          cdsClientecpf.AsString :=  ArrayCliente[i].GetValue<String>('cpf');
          cdsCliente.Post;
        end;
      end
      else
      begin
        ShowMessage('Não dados de cliente para consumir o Api');
      end;
    end
    else
    begin
      JJson := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json) ,0) as TJSONObject;

      if JJson <> nil then
      begin
        edPedcli.Text := JJson.GetValue('id').ToString;
        EdNomecli.Text :=  AnsiReplaceStr(JJson.GetValue('nome').ToString, '"', '');
      end
      else
      begin
        Application.MessageBox('Cliente não cadastrado!','Atenção',MB_ICONEXCLAMATION);
        edPedcli.SetFocus;
      end;
    end;
  end
  else
  if STipo = 'P' then
  begin
    if sdata = 'S' then
    begin
      // começa a desmontar o Json
      ArrayProduto := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json) ,0) as TJSONArray;

      if ArrayProduto.Size > 0 then
      begin
        for i := 0 to ArrayProduto.Size - 1 do
        begin
          cdsProduto.Append;
          cdsProdutoCodProd.AsInteger := ArrayProduto[i].GetValue<Integer>('id');
          cdsProdutoProduto.AsString := ArrayProduto[i].GetValue<String>('descricao');
          cdsProdutopreco.AsCurrency := StrToCurr( AnsiReplaceStr(ArrayProduto[i].GetValue<String>('preco'), '.', ','));
          cdsProduto.Post;
        end
      end
      else
      begin
        ShowMessage('Não dados de produto para consumir o Api');
      end
    end
    else
    begin
      JJson := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json) ,0) as TJSONObject;

      if JJson <> nil then
      begin
        EdPedProd.Text := JJson.GetValue('id').ToString;
        EdPedNomeProd.Text :=  AnsiReplaceStr(JJson.GetValue('descricao').ToString, '"', '');
        EdPedPreco.Text := AnsiReplaceStr(JJson.GetValue('preco').ToString, '.', ',');
        EdPedPreco.Text := FormatFloat('###,##0.00',StrToCurr(EdPedPreco.Text));
      end
      else
      begin
        Application.MessageBox('Produto não cadastrado!','Atenção',MB_ICONEXCLAMATION);
        EdPedProd.SetFocus;
      end;
    end;
  end;


  JJson.DisposeOf;
end;

procedure TFConsumindoApi.Salvar(STipo: String);
begin
  if STipo = 'U' then
  begin
    if Trim(edUsuario.Text) = '' then
    begin
      Application.MessageBox('Usuário não pode ser vazio!','Atenção',MB_ICONEXCLAMATION);
      PgJson.ActivePageIndex := 0;
      TbCadastro.ActivePage := AbaUsuario;
      edUsuario.SetFocus;
      exit;
    end;

    if Trim(edSenha.Text) = '' then
    begin
      Application.MessageBox('Senha não pode ser vazio!','Atenção',MB_ICONEXCLAMATION);
      PgJson.ActivePageIndex := 0;
      TbCadastro.ActivePage := AbaUsuario;
      edSenha.SetFocus;
      exit;
    end;

    if AdicinaCadastro('U',edUsuario.Text,'','http://localhost:8080/api/usuarios','',edSenha.Text,True) = True  then
    begin
      edUsuario.Clear;
      edSenha.Clear;
      PgJson.ActivePageIndex := 0;
      TbCadastro.ActivePage := AbaUsuario;
      edUsuario.SetFocus;
    end
  end
  else
  if STipo = 'C' then
  begin
    if Trim(edCliente.Text) = '' then
    begin
      Application.MessageBox('Cliente não pode ser vazio!','Atenção',MB_ICONEXCLAMATION);
      PgJson.ActivePageIndex := 0;
      TbCadastro.ActivePage := AbaCliente;
      edCliente.SetFocus;
      exit;
    end;

    if Trim(edCpfCli.Text) = '' then
    begin
      Application.MessageBox('Cpf não pode ser vazio!','Atenção',MB_ICONEXCLAMATION);
      PgJson.ActivePageIndex := 0;
      TbCadastro.ActivePage := AbaCliente;
      edCpfCli.SetFocus;
      exit;
    end;

    if AdicinaCadastro('C',edCliente.Text,edCpfCli.Text,'http://localhost:8080/api/clientes','','',False) = True  then
    begin
      edCliente.Clear;
      edCpfCli.Clear;
      PgJson.ActivePageIndex := 0;
      TbCadastro.ActivePage := AbaCliente;
      edCliente.SetFocus;
    end;
  end
  else
  if STipo = 'P' then
  begin
    if Trim(edProduto.Text) = '' then
    begin
      Application.MessageBox('Produto não pode ser vazio!','Atenção',MB_ICONEXCLAMATION);
      PgJson.ActivePageIndex := 0;
      TbCadastro.ActivePage := AbaProduto;
      edProduto.SetFocus;
      exit;
    end;

    if Trim(edpreco.Text) = '' then
    begin
      Application.MessageBox('Preço Unitário não pode ser vazio!','Atenção',MB_ICONEXCLAMATION);
      PgJson.ActivePageIndex := 0;
      TbCadastro.ActivePage := AbaProduto;
      edpreco.SetFocus;
      exit;
    end;

    if StrToCurr(edpreco.Text) <=0 then
    begin
      Application.MessageBox('Preço Unitário não aceita valor menor ou igual a 0!','Atenção',MB_ICONEXCLAMATION);
      PgJson.ActivePageIndex := 0;
      TbCadastro.ActivePage := AbaProduto;
      edpreco.SetFocus;
      exit;
    end;

    if AdicinaCadastro('P',edProduto.Text,edpreco.Text,'http://localhost:8080/api/produto',edpreco.Text,'',False) Then
    begin
      edProduto.Clear;
      PgJson.ActivePageIndex := 0;
      TbCadastro.ActivePage := AbaProduto;
      edProduto.SetFocus;
      edpreco.Text := '0,00';
    end;
  end
  else
  if STipo = 'A' then
  begin
    if Trim(edautusu.Text) = '' then
    begin
      Application.MessageBox('Usuário não pode ser vazio!','Atenção',MB_ICONEXCLAMATION);
      PgJson.ActivePageIndex := 0;
      TbCadastro.ActivePage := AbaAuth;
      edautusu.SetFocus;
      exit;
    end;

    if Trim(edautsenha.Text) = '' then
    begin
      Application.MessageBox('Senha não pode ser vazio!','Atenção',MB_ICONEXCLAMATION);
      PgJson.ActivePageIndex := 0;
      TbCadastro.ActivePage := AbaAuth;
      edautsenha.SetFocus;
      exit;
    end;

    Mauth.Clear;

    if AdicinaCadastro('A',edautusu.Text,'','http://localhost:8080/api/usuarios/auth','',edautsenha.Text,True) = True  then
    begin
      edautusu.Clear;
      edautsenha.Clear;
      PgJson.ActivePageIndex := 0;
      TbCadastro.ActivePage := AbaAuth;
      edautusu.SetFocus;
    end
  end;
end;

procedure TFConsumindoApi.SpeedButton1Click(Sender: TObject);
begin
  BuscaApi ('C','http://localhost:8080/api/clientes','','S');
end;

procedure TFConsumindoApi.TbCadastroChange(Sender: TObject);
begin
  if TbCadastro.ActivePage = AbaUsuario then
    edUsuario.SetFocus
  else
  if TbCadastro.ActivePage = AbaCliente then
    edCliente.SetFocus
  else
  if TbCadastro.ActivePage = AbaProduto then
    edProduto.SetFocus
  else
  if TbCadastro.ActivePage = AbaAuth then
    edautusu.SetFocus;
end;

procedure TFConsumindoApi.Colorir(sTexto : string);
begin
    if sTexto = UpperCase('realizado') then
      EdStatus.Font.Color := clGreen
    else EdStatus.Font.Color := clRed;
end;


procedure TFConsumindoApi.edautsenhaExit(Sender: TObject);
begin
   Salvar('A');
end;

procedure TFConsumindoApi.edCpfCliExit(Sender: TObject);
begin
  Salvar('C');
end;

procedure TFConsumindoApi.edPedcliExit(Sender: TObject);
begin
  if Trim(edPedcli.Text) = '' then
    exit;

  cdsItens.EmptyDataSet;

  BuscaApi('C','http://localhost:8080/api/clientes','/' + edPedcli.Text,'N');

end;

procedure TFConsumindoApi.EdPedProdExit(Sender: TObject);
begin
  if Trim(EdPedProd.Text) = '' then
    exit;

  BuscaApi('P','http://localhost:8080/api/produto','/' + EdPedProd.Text,'N');

end;

procedure TFConsumindoApi.EdPedQtdExit(Sender: TObject);
var
 dTotal : Double;
begin
  if Trim(EdPedQtd.Text) = '' then
  begin
    Application.MessageBox('Quandtidade não pode ser vazio!','Atenção',MB_ICONEXCLAMATION);
    EdPedQtd.SetFocus;
    exit;
  end;


  if EdPedQtd.ValueInt <= 0 then
  begin
    Application.MessageBox('Quandtidade não pode ser igual ou menor a 0!','Atenção',MB_ICONEXCLAMATION);
    EdPedQtd.SetFocus;
    exit;
  end;


  dTotal :=  StrToCurr(EdPedPreco.Text) * EdPedQtd.ValueInt;
  EdPedTot.Text := FormatFloat('###,##0.00',dTotal);

  btnSalvarClick(Sender);
end;

procedure TFConsumindoApi.edprecoExit(Sender: TObject);
begin
  Salvar('P');
end;

procedure TFConsumindoApi.edprecoKeyPress(Sender: TObject; var Key: Char);
begin
   if (key in ['0'..'9',','] = false)  then
    key := #0;
end;

procedure TFConsumindoApi.edSenhaExit(Sender: TObject);
begin
  Salvar('U');
end;

end.
