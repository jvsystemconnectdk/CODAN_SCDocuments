Page 50042 CountryCurrencyBankInfo
{
    Caption = 'Country/Currency-Bankinfo';
    PageType = List;
    SourceTable = CountryCurrencyBankInfo;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(CountryCode; Rec.CountryCode)
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; Rec.CurrencyCode)
                {
                    ApplicationArea = Basic;
                }
                field(BankName; Rec.BankName)
                {
                    ApplicationArea = Basic;
                }
                field(BankAddress; Rec.BankAddress)
                {
                    ApplicationArea = Basic;
                }
                field(BankRegNo; Rec.BankRegNo)
                {
                    ApplicationArea = Basic;
                }
                field(BankAccount; Rec.BankAccount)
                {
                    ApplicationArea = Basic;
                }
                field(Iban; Rec.Iban)
                {
                    ApplicationArea = Basic;
                }
                field(SWIFTCode; Rec.SWIFTCode)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
}

