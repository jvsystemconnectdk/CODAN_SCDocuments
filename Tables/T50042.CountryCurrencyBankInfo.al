Table 50042 CountryCurrencyBankInfo
{
    Caption = 'Country/Currency-accounts';

    fields
    {
        field(1; CountryCode; Code[10])
        {
            Caption = 'Country';
            TableRelation = "Country/Region";
        }
        field(2; CurrencyCode; Code[10])
        {
            Caption = 'Currency';
            TableRelation = Currency;
        }
        field(3; Iban; Text[40])
        {
            Caption = 'IBAN';
        }
        field(4; SWIFTCode; Text[10])
        {
            Caption = 'SWIFT Code';
        }
        field(5; BankName; Text[50])
        {
            Caption = 'Bank Name';
        }
        field(6; BankAccount; Text[30])
        {
            Caption = 'Bank Account';
        }
        field(7; BankRegNo; Text[10])
        {
            Caption = 'Reg.No.';
        }
        field(8; BankAddress; Text[50])
        {
            Caption = 'Bank Address';
        }
    }

    keys
    {
        key(Key1; CountryCode, CurrencyCode)
        {
        }
    }

    procedure FetchBankInfo(CountryCurrencyBankInfo: Record CountryCurrencyBankInfo; var ParmBankName: Text; var ParmBankAccount: Text; var ParmIBAN: Text; var ParmSWIFT: Text)
    var
        LblRegNo: label 'Reg. No.';
        LblAccNo: label 'Account No.';
        LblIBAN: label 'IBAN';
        LblSWIFT: label 'SWIFT';
    begin
        if CountryCurrencyBankInfo.BankName <> '' then begin
            ParmBankName := CountryCurrencyBankInfo.BankName;
            if CountryCurrencyBankInfo.BankAddress <> '' then
                ParmBankName += ', ' + CountryCurrencyBankInfo.BankAddress;
        end;
        if CountryCurrencyBankInfo.BankAccount <> '' then begin
            if CountryCurrencyBankInfo.BankRegNo <> '' then
                ParmBankAccount := CountryCurrencyBankInfo.BankRegNo + ' ';
            ParmBankAccount += CountryCurrencyBankInfo.BankAccount;
        end;
        if CountryCurrencyBankInfo.Iban <> '' then
            ParmIBAN := CountryCurrencyBankInfo.Iban;
        if CountryCurrencyBankInfo.SWIFTCode <> '' then
            ParmSWIFT := CountryCurrencyBankInfo.SWIFTCode;
    end;

    procedure GetCompanyBankInfoExt(CountryCode: Code[10]; Currency: Code[10]; var BankName: Text; var BankAccount: Text; var Iban: Text; var SWIFT: Text)
    var
        CompanyInformation: Record "Company Information";
        CountryCurrencyBankInfo: Record CountryCurrencyBankInfo;
    begin
        if CompanyInformation.Get then begin
            BankName := CompanyInformation."Bank Name";
            BankAccount := CompanyInformation."Bank Branch No." + CompanyInformation."Bank Account No.";
            Iban := CompanyInformation.Iban;
            SWIFT := CompanyInformation."SWIFT Code";
        end;
        if CountryCurrencyBankInfo.Get(CountryCode, Currency) then begin
            FetchBankInfo(CountryCurrencyBankInfo, BankName, BankAccount, Iban, SWIFT);
        end else begin
            if CountryCurrencyBankInfo.Get('', Currency) then begin
                FetchBankInfo(CountryCurrencyBankInfo, BankName, BankAccount, Iban, SWIFT);
            end else begin
                if CountryCurrencyBankInfo.Get(CountryCode, '') then begin
                    FetchBankInfo(CountryCurrencyBankInfo, BankName, BankAccount, Iban, SWIFT);
                end else begin
                    if CountryCurrencyBankInfo.Get('', '') then begin
                        FetchBankInfo(CountryCurrencyBankInfo, BankName, BankAccount, Iban, SWIFT);
                    end;
                end;
            end;
        end;
    end;
}

