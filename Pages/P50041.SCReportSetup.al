Page 50041 SCReportSetup
{
    Caption = 'Report parameters';
    DeleteAllowed = false;
    InsertAllowed = false;
    ShowFilter = false;
    UsageCategory = Administration;
    ApplicationArea = All;
    AdditionalSearchTerms = 'Report,Layout,Document,setup';

    layout
    {
        area(content)
        {
            group(LanguageSetup)
            {
                Caption = 'Language Setup';
                Visible = true;
                field(DefaultLanguageCode; DefaultLanguageCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Default Language Code';

                    trigger OnValidate()
                    begin
                        SCReportSetup.SetCode('LANGUAGE', '', '', 'DefaultLanguageCode', DefaultLanguageCode);
                    end;
                }
            }
            group(Layout)
            {
                Caption = 'Layout Setup';
                Visible = true;
                field(ShowCustomerItemNo; ShowCustomerItemNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Customer Item No.';

                    trigger OnValidate()
                    begin
                        SCReportSetup.SetBoolean('LAYOUT', '', '', 'ShowCustomerItemNo', ShowCustomerItemNo);
                    end;
                }

                field(HideItemNoVariant; HideItemNoVariant)
                {
                    ApplicationArea = Basic;
                    Caption = 'Hide Item Variant';

                    trigger OnValidate()
                    begin
                        SCReportSetup.SetBoolean('LAYOUT', '', '', 'HideItemNoVariant', HideItemNoVariant);
                    end;
                }
            }

            group(IBANSetup)
            {
                Caption = 'IBAN setup';
                Visible = false;
                field(IBAN_DKK; IBAN_DKK)
                {
                    ApplicationArea = Basic;
                    Caption = 'IBAN DKK';

                    trigger OnValidate()
                    begin
                        SCReportSetup.SetText('IBAN', '', '', 'IBAN_DKK', IBAN_DKK);
                    end;
                }
                field(IBAN_EUR; IBAN_EUR)
                {
                    ApplicationArea = Basic;
                    Caption = 'IBAN EUR';

                    trigger OnValidate()
                    begin
                        SCReportSetup.SetText('IBAN', '', '', 'IBAN_EUR', IBAN_EUR);
                    end;
                }
                field(IBAN_USD; IBAN_USD)
                {
                    ApplicationArea = Basic;
                    Caption = 'IBAN USD';

                    trigger OnValidate()
                    begin
                        SCReportSetup.SetText('IBAN', '', '', 'IBAN_USD', IBAN_USD);
                    end;
                }
            }
            group(FIK)
            {
                Caption = 'FIK';
                Visible = true;
                field(FIKPaymentMethod; FIKPaymentMethod)
                {
                    ApplicationArea = Basic;
                    Caption = 'Paym.Method code';
                    TableRelation = "Payment Method";
                    trigger OnValidate()
                    begin
                        SCReportSetup.SetCode('FIK', '', '', 'FIKPaymentMethod', FIKPaymentMethod);
                    end;
                }
            }

            group(TxtCode)
            {
                Caption = 'Text Codes';
                Visible = true;
                field(TxtCodeConfirmation; TxtCodeConfirmation)
                {
                    ApplicationArea = Basic;
                    Caption = 'Confirmation';
                    TableRelation = "Standard Text";
                    trigger OnValidate()
                    begin
                        SCReportSetup.SetCode('TXTCODES', '', '', 'TxtCodeConfirmation', TxtCodeConfirmation);
                    end;
                }
                field(TxtCodeInvoice; TxtCodeInvoice)
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoice';
                    TableRelation = "Standard Text";
                    trigger OnValidate()
                    begin
                        SCReportSetup.SetCode('TXTCODES', '', '', 'TxtCodeInvoice', TxtCodeInvoice);
                    end;
                }
                field(TxtCodeCrMemo; TxtCodeCrMemo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Credit Memo';

                    trigger OnValidate()
                    begin
                        SCReportSetup.SetCode('TXTCODES', '', '', 'TxtCodeCrMemo', TxtCodeCrMemo);
                    end;
                }
                field(TxtCodeDeliveryNote; TxtCodeDeliveryNote)
                {
                    ApplicationArea = Basic;
                    Caption = 'Delivery Note';
                    TableRelation = "Standard Text";
                    trigger OnValidate()
                    begin
                        SCReportSetup.SetCode('TXTCODES', '', '', 'TxtCodeDeliveryNote', TxtCodeDeliveryNote);
                    end;
                }
                field(TxtCodeProformainvoice; TxtCodeProformainvoice)
                {
                    ApplicationArea = Basic;
                    Caption = 'Proforma Invoice';
                    TableRelation = "Standard Text";
                    trigger OnValidate()
                    begin
                        SCReportSetup.SetCode('TXTCODES', '', '', 'TxtCodeProformainvoice', TxtCodeProformainvoice);
                    end;
                }
                field(TxtCodePurchase; TxtCodePurchase)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase';
                    TableRelation = "Standard Text";
                    trigger OnValidate()
                    begin
                        SCReportSetup.SetCode('TXTCODES', '', '', 'TxtCodePurchase', TxtCodePurchase);
                    end;
                }

            }
        }
    }

    actions
    {
        area(navigation)
        {

            action(ImportTxtFile)
            {
                ApplicationArea = Basic;
                Caption = 'Report label translation';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Translation;
                RunObject = page ReportLabelTranslation;
            }

            action(BankInfo)
            {
                ApplicationArea = Basic;
                Caption = 'Bank info setup';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Bank;
                RunObject = page CountryCurrencyBankInfo;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Clear(SCReportSetup);
        IBAN_DKK := SCReportSetup.GetText('IBAN', '', '', 'IBAN_DKK');
        IBAN_EUR := SCReportSetup.GetText('IBAN', '', '', 'IBAN_EUR');
        IBAN_USD := SCReportSetup.GetText('IBAN', '', '', 'IBAN_USD');
        DefaultLanguageCode := SCReportSetup.GetCode('LANGUAGE', '', '', 'DefaultLanguageCode');

        TxtCodeConfirmation := SCReportSetup.GetCode('TXTCODES', '', '', 'TxtCodeConfirmation');
        TxtCodeInvoice := SCReportSetup.GetCode('TXTCODES', '', '', 'TxtCodeInvoice');
        TxtCodeCrMemo := SCReportSetup.GetCode('TXTCODES', '', '', 'TxtCodeCrMemo');
        TxtCodeDeliveryNote := SCReportSetup.GetCode('TXTCODES', '', '', 'TxtCodeDeliveryNote');
        TxtCodeProformainvoice := SCReportSetup.GetCode('TXTCODES', '', '', 'TxtCodeProformainvoice');
        TxtCodePurchase := SCReportSetup.GetCode('TXTCODES', '', '', 'TxtCodePurchase');

        ShowCustomerItemNo := SCReportSetup.GetBoolean('LAYOUT', '', '', 'ShowCustomerItemNo');
        HideItemNoVariant := SCReportSetup.GetBoolean('LAYOUT', '', '', 'HideItemNoVariant');

        FIKPaymentMethod := SCReportSetup.GetCode('FIK', '', '', 'FIKPaymentMethod');

    end;

    var
        SCReportSetup: Record SCReportSetup;
        IBAN_DKK: Text;
        IBAN_EUR: Text;
        IBAN_USD: Text;
        DefaultLanguageCode: Code[10];
        TxtCodeInvoice: Code[20];
        TxtCodeCrMemo: Code[20];
        TxtCodeConfirmation: Code[20];
        TxtCodeProformainvoice: Code[20];
        TxtCodeDeliveryNote: Code[20];
        TxtCodePurchase: Code[20];
        FIKPaymentMethod: Code[20];
        ShowCustomerItemNo: Boolean;
        HideItemNoVariant: Boolean;

}

