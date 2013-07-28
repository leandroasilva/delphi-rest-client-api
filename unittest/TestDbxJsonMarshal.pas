﻿unit TestDbxJsonMarshal;

interface

uses TestFramework, DbxJsonMarshal, TypesToTest, RestJsonUtils,
     Generics.Collections, SuperObject, Data.DbxJson, DBXJsonHelpers,
  DBXJsonUnMarshal;

type
  TTestDbxJsonMarshal = class(TTestCase)
  private
    FObject: TAllTypes;
    FJson: TJSONValue;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure valueInteger;
    procedure valueDouble;
    procedure valueInt64;
    procedure valueCurrency;
    procedure valueSingle;
    procedure valueExtended;
    procedure valueComp;
    procedure valueString;
    procedure valueAnsiString;
    procedure valueStringRenamed;
    procedure valueChar;
    procedure valueAnsiChar;
    procedure valueBooleanTrue;
    procedure valueBooleanFalse;
    procedure valueDateTime;
    procedure valueEnum;
    procedure valueSet;
    procedure valueObject;
    procedure valueList;
    procedure valueObjectList;
  end;

  TTestDbxJsonMarshalCompatibility = class(TTestCase)
  private
    vRoot: TAllTypes;
    vChild1, vChild2, vChild3, vChild4: TAllTypes;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
     procedure CompareResultWithSuperObject;
     procedure MarshalAndUnMarshal;
  end;

implementation

uses System.DateUtils, System.SysUtils;

{ TTestDbxJsonMarshal }

procedure TTestDbxJsonMarshal.SetUp;
begin
  inherited;
  FObject := TAllTypes.Create;
end;

procedure TTestDbxJsonMarshal.TearDown;
begin
  inherited;
  FObject.Free;
  FJson.Free;
end;

procedure TTestDbxJsonMarshal.valueAnsiChar;
begin
  FObject.valueAnsiChar := 'F';

  FJson := TDBXJsonMarshal.ToJson(FObject);

  CheckNotNull(FJson);
  CheckEquals('F', FJson.AsJsonObject.Get('valueAnsiChar').JsonValue.AsJsonString.Value);
end;

procedure TTestDbxJsonMarshal.valueAnsiString;
begin
  FObject.valueAnsiString := 'marshal - #';

  FJson := TDBXJsonMarshal.ToJson(FObject);

  CheckNotNull(FJson);
  CheckEquals('marshal - #', FJson.AsJsonObject.Get('valueAnsiString').JsonValue.AsJsonString.Value);
end;

procedure TTestDbxJsonMarshal.valueBooleanFalse;
begin
  FObject.valueBoolean := False;

  FJson := TDBXJsonMarshal.ToJson(FObject);

  CheckNotNull(FJson);
  CheckTrue(FJson.AsJsonObject.Get('valueBoolean').JsonValue.IsJsonFalse);
end;

procedure TTestDbxJsonMarshal.valueBooleanTrue;
begin
  FObject.valueBoolean := True;

  FJson := TDBXJsonMarshal.ToJson(FObject);

  CheckNotNull(FJson);
  CheckTrue(FJson.AsJsonObject.Get('valueBoolean').JsonValue.IsJsonTrue);
end;

procedure TTestDbxJsonMarshal.valueChar;
begin
  FObject.valueChar := '资';

  FJson := TDBXJsonMarshal.ToJson(FObject);

  CheckNotNull(FJson);
  CheckEquals('资', FJson.AsJsonObject.Get('valueChar').JsonValue.AsJsonString.Value);
end;

procedure TTestDbxJsonMarshal.valueComp;
begin
  FObject.valueComp := 123456789;

  FJson := TDBXJsonMarshal.ToJson(FObject);

  CheckNotNull(FJson);
  CheckEquals(123456789, FJson.AsJsonObject.Get('valueComp').JsonValue.AsJsonNumber.AsInt64);
end;

procedure TTestDbxJsonMarshal.valueCurrency;
begin
  FObject.valueCurrency := 123.45;

  FJson := TDBXJsonMarshal.ToJson(FObject);

  CheckNotNull(FJson);
  CheckEquals(123.45, FJson.AsJsonObject.Get('valueCurrency').JsonValue.AsJsonNumber.AsDouble, 0.001);
end;

procedure TTestDbxJsonMarshal.valueDateTime;
var
  vJavaDate: Int64;
begin
  FObject.valueDateTime := Now;

  vJavaDate := DelphiToJavaDateTime(FObject.valueDateTime);

  FJson := TDBXJsonMarshal.ToJson(FObject);

  CheckNotNull(FJson);
  CheckEquals(vJavaDate, FJson.AsJsonObject.Get('valueDateTime').JsonValue.AsJsonNumber.AsInt64);

end;

procedure TTestDbxJsonMarshal.valueDouble;
begin
  FObject.valueDouble := 123.45;

  FJson := TDBXJsonMarshal.ToJson(FObject);

  CheckNotNull(FJson);
  CheckEquals(123.45, FJson.AsJsonObject.Get('valueDouble').JsonValue.AsJsonNumber.AsDouble, 0.001);
end;

procedure TTestDbxJsonMarshal.valueEnum;
begin
  FObject.valueEnum := etTwo;

  FJson := TDBXJsonMarshal.ToJson(FObject);

  CheckNotNull(FJson);
  CheckEquals(1, FJson.AsJsonObject.Get('valueEnum').JsonValue.AsJsonNumber.AsInt);
end;

procedure TTestDbxJsonMarshal.valueExtended;
begin
  FObject.valueExtended := 123.45;

  FJson := TDBXJsonMarshal.ToJson(FObject);

  CheckNotNull(FJson);
  CheckEquals(123.45, FJson.AsJsonObject.Get('valueExtended').JsonValue.AsJsonNumber.AsDouble, 0.001);
end;

procedure TTestDbxJsonMarshal.valueInt64;
begin
  FObject.valueInt64 := 123456789;

  FJson := TDBXJsonMarshal.ToJson(FObject);

  CheckNotNull(FJson);
  CheckEquals(123456789, FJson.AsJsonObject.Get('valueInt64').JsonValue.AsJsonNumber.AsInt64);
end;

procedure TTestDbxJsonMarshal.valueInteger;
begin
  FObject.valueInteger := 123;

  FJson := TDBXJsonMarshal.ToJson(FObject);

  CheckNotNull(FJson);
  CheckEquals(123, FJson.AsJsonObject.Get('valueInteger').JsonValue.AsJsonNumber.AsInt);
end;

procedure TTestDbxJsonMarshal.valueList;
var
  vItem: TAllTypes;
  vObject: TJSONValue;
begin
  vItem := TAllTypes.Create;
  vItem.valueInteger := 456;

  FObject.valueInteger := 123;
  FObject.valueList := TList<TAllTypes>.Create;
  FObject.valueList.Add(vItem);

  FJson := TDBXJsonMarshal.ToJson(FObject);

  CheckNotNull(FJson);
  CheckEquals(123, FJson.AsJsonObject.Get('valueInteger').JsonValue.AsJsonNumber.AsInt);

  vObject := FJson.AsJsonObject.Get('valueList').JsonValue;
  CheckNotNull(vObject);
  CheckTrue(vObject.IsJsonArray);
  CheckEquals(1, vObject.AsJsonArray.Size);
  CheckEquals(456, vObject.AsJsonArray.Get(0).AsJsonObject.Get('valueInteger').JsonValue.AsJsonNumber.AsInt);
end;

procedure TTestDbxJsonMarshal.valueObject;
var
  vObject: TJSONValue;
begin
  FObject.valueInteger := 123;
  FObject.valueTObject := TAllTypes.Create;
  FObject.valueTObject.valueInteger := 456;

  FJson := TDBXJsonMarshal.ToJson(FObject);

  CheckNotNull(FJson);
  CheckEquals(123, FJson.AsJsonObject.Get('valueInteger').JsonValue.AsJsonNumber.AsInt);

  vObject := FJson.AsJsonObject.Get('valueTObject').JsonValue;
  CheckNotNull(vObject);
  CheckTrue(vObject.IsJsonObject);
  CheckEquals(456, vObject.AsJsonObject.Get('valueInteger').JsonValue.AsJsonNumber.AsInt);
end;

procedure TTestDbxJsonMarshal.valueObjectList;
var
  vItem: TAllTypes;
  vObject: TJSONValue;
begin
  vItem := TAllTypes.Create;
  vItem.valueInteger := 456;

  FObject.valueInteger := 123;
  FObject.valueObjectList := TObjectList<TAllTypes>.Create;
  FObject.valueObjectList.Add(vItem);

  FJson := TDBXJsonMarshal.ToJson(FObject);

  CheckNotNull(FJson);
  CheckEquals(123, FJson.AsJsonObject.Get('valueInteger').JsonValue.AsJsonNumber.AsInt);

  vObject := FJson.AsJsonObject.Get('valueObjectList').JsonValue;
  CheckNotNull(vObject);
  CheckTrue(vObject.IsJsonArray);
  CheckEquals(1, vObject.AsJsonArray.Size);
  CheckEquals(456, vObject.AsJsonArray.Get(0).AsJsonObject.Get('valueInteger').JsonValue.AsJsonNumber.AsInt);
end;

procedure TTestDbxJsonMarshal.valueSet;
begin
  FObject.valueSet := [etOne, etThree];

  FJson := TDBXJsonMarshal.ToJson(FObject);

  CheckNotNull(FJson);
  CheckEquals(5, FJson.AsJsonObject.Get('valueSet').JsonValue.AsJsonNumber.AsInt);
end;

procedure TTestDbxJsonMarshal.valueSingle;
begin
  FObject.valueSingle := 123.45;

  FJson := TDBXJsonMarshal.ToJson(FObject);

  CheckNotNull(FJson);
  CheckEquals(123.45, FJson.AsJsonObject.Get('valueSingle').JsonValue.AsJsonNumber.AsDouble, 0.001);
end;

procedure TTestDbxJsonMarshal.valueString;
begin
  FObject.valueString := 'marshal - 资';

  FJson := TDBXJsonMarshal.ToJson(FObject);

  CheckNotNull(FJson);
  CheckEquals('marshal - 资', FJson.AsJsonObject.Get('valueString').JsonValue.AsJsonString.Value);
end;

procedure TTestDbxJsonMarshal.valueStringRenamed;
begin
  FObject.fieldNameRenamed := 'marshal';

  FJson := TDBXJsonMarshal.ToJson(FObject);

  CheckNotNull(FJson);
  CheckNotNull(FJson.AsJsonObject.Get('renamed'));
  CheckEquals('marshal', FJson.AsJsonObject.Get('renamed').JsonValue.AsJsonString.Value);
end;

{ TTestDbxJsonMarshalCompatibility }

procedure TTestDbxJsonMarshalCompatibility.CompareResultWithSuperObject;
var
  vMyJson: string;
  vRestored: TAllTypes;
begin
  vMyJson := TDBXJsonMarshal.ToJsonText(vRoot);

  vRestored := TAllTypes.FromJson(vMyJson);
  try
    CheckEquals(TDBXJsonMarshal.ToJsonText(vRoot), TDBXJsonMarshal.ToJsonText(vRestored));
  finally
    vRestored.Free;
  end;
end;

procedure TTestDbxJsonMarshalCompatibility.MarshalAndUnMarshal;
var
  vMyJson: string;
  vRestored: TAllTypes;
begin
  vMyJson := TDBXJsonMarshal.ToJsonText(vRoot);

  vRestored := TDBXJsonUnmarshal.FromJson<TAllTypes>(vMyJson);
  try
    CheckEquals(vRoot.ToJson.AsJSon, vRestored.ToJson().AsJSon());
  finally
    vRestored.Free;
  end;
end;

procedure TTestDbxJsonMarshalCompatibility.SetUp;
begin
  inherited;
  vChild1 := TAllTypes.Create;
  vChild1.valueInteger := 123;
  vChild1.fieldDefaultValue := 'default';

  vChild2 := TAllTypes.Create;
  vChild2.valueDouble := 1.23;
  vChild2.fieldDefaultValue := 'default';

  vChild3 := TAllTypes.Create;
  vChild3.valueString := 'third';
  vChild3.fieldDefaultValue := 'default';

  vChild4 := TAllTypes.Create;
  vChild4.valueDateTime := Now;
  vChild4.fieldDefaultValue := 'default';

  vRoot := TAllTypes.Create;
  vRoot.valueInteger := 123456;
  vRoot.valueDouble := 123456.78;
  vRoot.valueCurrency := 123456.78;
  vRoot.valueString := 'json object';
  vRoot.valueAnsiChar := 'F';
  vRoot.valueChar := '资';
  vRoot.valueInt64 := 123456789;
  vRoot.valueSingle := 1234;
  vRoot.valueExtended := 123456789;
  vRoot.valueComp := 123456789;
  vRoot.fieldNameRenamed := 'renamed';
  vRoot.fieldDefaultValue := 'default';
  vRoot.valueBoolean := True;
  vRoot.valueDateTime := Now;
  vRoot.valueEnum := etThree;
  vRoot.valueSet := [etOne, etThree];

  vRoot.valueTObject := TAllTypes.Create;
  vRoot.valueTObject.fieldDefaultValue := 'default';
  vRoot.valueList := TList<TAllTypes>.Create;
  vRoot.valueList.Add(vChild1);
  vRoot.valueList.Add(vChild2);
  vRoot.valueObjectList := TObjectList<TAllTypes>.Create;
  vRoot.valueObjectList.Add(vChild3);
  vRoot.valueObjectList.Add(vChild4);
end;

procedure TTestDbxJsonMarshalCompatibility.TearDown;
begin
  inherited;
  vRoot.Free;
end;

initialization
  RegisterTest(TTestDbxJsonMarshal.Suite);
  RegisterTest(TTestDbxJsonMarshalCompatibility.Suite);

end.