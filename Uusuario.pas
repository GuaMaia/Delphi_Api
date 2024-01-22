unit Uusuario;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections,System.StrUtils;

type
  Tusuario = Class

  private
    FJSON: TJSONObject;
  public
    constructor Create(const jsonString: string);
    destructor Destroy; override;

    function ObterLogin: string;
    function ObterSenha: string;
    function ObterTipoUsuario: Boolean;

  End;

implementation

{ Tusuario }

constructor Tusuario.Create(const jsonString: string);
begin
  inherited Create;
  FJSON := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(jsonString), 0) as TJSONObject;
end;

destructor Tusuario.Destroy;
begin
  FJSON.DisposeOf;
  inherited;
end;

function Tusuario.ObterLogin: string;
begin
  Result := FJSON.GetValue('login').ToString;
end;

function Tusuario.ObterSenha: string;
begin
  Result := FJSON.GetValue('senha').ToString
end;

function Tusuario.ObterTipoUsuario: Boolean;
var
 bAdmin : Boolean;
begin
  if FJSON.TryGetValue<Boolean>('admin', bAdmin) then
    Result :=True
  else
    Result := False;
end;

end.
