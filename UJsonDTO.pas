unit UJsonDTO;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections,System.StrUtils;

type

  TJsonDTO = class
  private
    FJSON: TJSONObject;
  public
    constructor Create(const jsonString: string);
    destructor Destroy; override;

    function ObterCodigo: string;
    function ObterNomeCliente: string;
    function ObterCPF: string;
    function ObterDataPedido: string;
    function ObterStatus: string;
    function ObterTotal: string;

    function ObterItens: TJSONArray;
  end;

implementation

constructor TJsonDTO.Create(const jsonString: string);
begin
  inherited Create;
  FJSON := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(jsonString), 0) as TJSONObject;
end;

destructor TJsonDTO.Destroy;
begin
  FJSON.DisposeOf;
  inherited;
end;

function TJsonDTO.ObterCodigo: string;
begin
  Result := FJSON.GetValue('codigo').ToString;
end;

function TJsonDTO.ObterNomeCliente: string;
begin
  Result := AnsiReplaceStr(FJSON.GetValue('nomeCliente').ToString, '"', '');
end;

function TJsonDTO.ObterCPF: string;
begin
  Result := AnsiReplaceStr(FJSON.GetValue('cpf').ToString, '"', '');
end;

function TJsonDTO.ObterDataPedido: string;
begin
  Result := AnsiReplaceStr(AnsiReplaceStr(FJSON.GetValue('dataPedido').ToString, '"', ''), '\', '');
end;

function TJsonDTO.ObterItens: TJSONArray;
begin
  Result := FJSON.GetValue<TJSONArray>('items');
end;

function TJsonDTO.ObterStatus: string;
begin
  Result := AnsiReplaceStr(FJSON.GetValue('status').ToString, '"', '');
end;

function TJsonDTO.ObterTotal: string;
begin
  Result := AnsiReplaceStr(FJSON.GetValue('total').ToString, '"', '');
end;


end.


