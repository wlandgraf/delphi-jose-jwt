{******************************************************************************}
{                                                                              }
{  Delphi JOSE Library                                                         }
{  Copyright (c) 2015 Paolo Rossi                                              }
{  https://github.com/paolo-rossi/delphi-jose-jwt                              }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");             }
{  you may not use this file except in compliance with the License.            }
{  You may obtain a copy of the License at                                     }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                              }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS,           }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{******************************************************************************}

unit JOSE.Providers;

{$I ..\JOSE.inc}

interface

uses
  JOSE.Providers.Interfaces;

type
  /// <summary>
  ///   Global crypto/encoding providers.
  /// </summary>
  TJOSEProviders = class
  private
    class var FBase64: IJOSEBase64Provider;
    class var FHMAC: IJOSEHmacProvider;
{$IFDEF RSA_SIGNING}
    class var FCertificate: IJOSECertificateProvider;
    class var FRSA: IJOSESignerRSA;
    class var FECDSA: IJOSESignerECDSA;
{$ENDIF}
    class procedure EnsureDefaults; static;
    class function GetBase64: IJOSEBase64Provider; static;
    class function GetHMAC: IJOSEHmacProvider; static;
    class procedure SetBase64(const AValue: IJOSEBase64Provider); static;
    class procedure SetHMAC(const AValue: IJOSEHmacProvider); static;
{$IFDEF RSA_SIGNING}
    class procedure EnsureSigningStack; static;
    class function GetCertificate: IJOSECertificateProvider; static;
    class function GetRSA: IJOSESignerRSA; static;
    class function GetECDSA: IJOSESignerECDSA; static;
    class procedure SetCertificate(const AValue: IJOSECertificateProvider); static;
    class procedure SetRSA(const AValue: IJOSESignerRSA); static;
    class procedure SetECDSA(const AValue: IJOSESignerECDSA); static;
{$ENDIF}
  public
    class property Base64: IJOSEBase64Provider read GetBase64 write SetBase64;
    class property HMAC: IJOSEHmacProvider read GetHMAC write SetHMAC;
{$IFDEF RSA_SIGNING}
    class property Certificate: IJOSECertificateProvider read GetCertificate write SetCertificate;
    class property RSA: IJOSESignerRSA read GetRSA write SetRSA;
    class property ECDSA: IJOSESignerECDSA read GetECDSA write SetECDSA;
{$ENDIF}
  end;

implementation

uses
  JOSE.Providers.Default;

{ TJOSEProviders }

class procedure TJOSEProviders.EnsureDefaults;
begin
  if FBase64 = nil then
    FBase64 := TDefaultBase64Provider.Create;
  if FHMAC = nil then
    FHMAC := TDefaultHmacProvider.Create;
end;

class function TJOSEProviders.GetBase64: IJOSEBase64Provider;
begin
  EnsureDefaults;
  Result := FBase64;
end;

class function TJOSEProviders.GetHMAC: IJOSEHmacProvider;
begin
  EnsureDefaults;
  Result := FHMAC;
end;

class procedure TJOSEProviders.SetBase64(const AValue: IJOSEBase64Provider);
begin
  FBase64 := AValue;
end;

class procedure TJOSEProviders.SetHMAC(const AValue: IJOSEHmacProvider);
begin
  FHMAC := AValue;
end;

{$IFDEF RSA_SIGNING}

class procedure TJOSEProviders.EnsureSigningStack;
begin
  EnsureDefaults;
  if FCertificate = nil then
    FCertificate := TDefaultCertificateProvider.Create;
  if FRSA = nil then
    FRSA := TDefaultRSAProvider.Create(FCertificate);
  if FECDSA = nil then
    FECDSA := TDefaultECDSAProvider.Create;
end;

class function TJOSEProviders.GetCertificate: IJOSECertificateProvider;
begin
  EnsureSigningStack;
  Result := FCertificate;
end;

class function TJOSEProviders.GetRSA: IJOSESignerRSA;
begin
  EnsureSigningStack;
  Result := FRSA;
end;

class function TJOSEProviders.GetECDSA: IJOSESignerECDSA;
begin
  EnsureSigningStack;
  Result := FECDSA;
end;

class procedure TJOSEProviders.SetCertificate(const AValue: IJOSECertificateProvider);
begin
  FCertificate := AValue;
  FRSA := nil;
end;

class procedure TJOSEProviders.SetRSA(const AValue: IJOSESignerRSA);
begin
  FRSA := AValue;
end;

class procedure TJOSEProviders.SetECDSA(const AValue: IJOSESignerECDSA);
begin
  FECDSA := AValue;
end;

{$ENDIF}

end.
