Report 50044 SalesCreditMemo
{
    DefaultLayout = Word;
    Caption = 'Sales - Credit Memo';
    PreviewMode = PrintLayout;
    WordMergeDataItem = Header;

    Permissions = TableData "Sales Shipment Buffer" = rimd;

    dataset
    {
        dataitem(Header; "Sales Cr.Memo Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Credit Memo';
            column(SCFileName; SCFileName)
            {
            }
            column(CompanyPicture; CompanyInformation.Picture)
            {
            }
            column(CompanyInfo; CompanyInfo)
            {
            }
            column(CompanyName; CompanyNameTxt)
            {
            }
            column(CompanyAddress; CompanyAddress1)
            {
            }
            column(CompanyAddress2; CompanyAddress2)
            {
            }
            column(CompanyPostCodeCity; CompanyPostCodeCity)
            {
            }
            column(CompanyCountry; CompanyCountry)
            {
            }
            column(CompanyPhone; CompanyPhone)
            {
            }
            column(CompanyURL; CompanyURL)
            {
            }
            column(CompanyEmail; CompanyEmail)
            {
            }
            column(CompanyCVR; CompanyCVR)
            {
            }
            column(CompanyExportNo; CompanyExportNo)
            {
            }
            column(CompanyRegNo; CompanyRegNo)
            {
            }
            column(BankName; BankName)
            {
            }
            column(BankInfo; BankInfo)
            {
            }
            column(BankAccount; BankAccount)
            {
            }
            column(IBAN; SCIBAN)
            {
            }
            column(SWIFT; SWIFT)
            {
            }
            column(InvoiceAddress1; InvoiceAddress[1])
            {
            }
            column(InvoiceAddress2; InvoiceAddress[2])
            {
            }
            column(InvoiceAddress3; InvoiceAddress[3])
            {
            }
            column(InvoiceAddress4; InvoiceAddress[4])
            {
            }
            column(InvoiceAddress5; InvoiceAddress[5])
            {
            }
            column(InvoiceAddress6; InvoiceAddress[6])
            {
            }
            column(InvoiceAddress7; InvoiceAddress[7])
            {
            }
            column(InvoiceAddress8; InvoiceAddress[8])
            {
            }
            column(ShipmentAddress1; ShipToAddr[1])
            {
            }
            column(ShipmentAddress2; ShipToAddr[2])
            {
            }
            column(ShipmentAddress3; ShipToAddr[3])
            {
            }
            column(ShipmentAddress4; ShipToAddr[4])
            {
            }
            column(ShipmentAddress5; ShipToAddr[5])
            {
            }
            column(ShipmentAddress6; ShipToAddr[6])
            {
            }
            column(ShipmentAddress7; ShipToAddr[7])
            {
            }
            column(ShipmentAddress8; ShipToAddr[8])
            {
            }
            column(ShipmentMethodDescription; ShipmentDescription)
            {
            }
            column(PaymentTermsDescription; PaymentTerms.Description)
            {
            }
            column(AccountNo; "Sell-to Customer No.")
            {
            }
            column(InvoiceAccountNo; "Bill-to Customer No.")
            {
            }
            column(DocumentNo; "No.")
            {
            }
            column(OrderNo; "Return Order No.")
            {
            }
            column(PaymentReference; PaymentRef)
            {
            }
            column(PaymentSpecText; PaymentSpecText)
            {
            }
            column(ShipmentDate; SCReportUtil.FixDateDDMMYYYY("Shipment Date"))
            {
            }
            column(DocumentDate; SCReportUtil.FixDateDDMMYYYY("Posting Date"))
            {
            }
            column(OrderDate; SCReportUtil.FixDateDDMMYYYY("Posting Date"))
            {
            }
            column(DueDate; SCReportUtil.FixDateDDMMYYYY("Due Date"))
            {
            }
            column(YourReference; "Your Reference")
            {
            }
            column(ExternalDocNo; "External Document No.")
            {
            }
            column(OurRef; OurRef)
            {
            }
            column(Email; Email)
            {
            }
            column(Phone; Phone)
            {
            }
            column(CustCVRNo; CustCVRNo)
            {
            }
            column(CustEANNo; CustEANNo)
            {
            }
            column(Currency; CurrencyCode)
            {
            }
            column(FreightAmount; FreightAmount)
            {
            }
            column(EndDiscAmount; EndDiscAmount)
            {
            }
            column(VATPct; VATPct)
            {
            }
            column(DocumentPreLineTxt; DocumentPreLineTxt)
            {
            }
            column(DocumentPostLineTxt; DocumentPostLineTxt)
            {
            }
            column(DocumentReminderTxt; DocumentReminderTxt)
            {
            }
            column(VATFreeText; VATFreeText)
            {
            }
            dataitem(Line; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = Header;
                DataItemTableView = sorting("Document No.", "Line No.");
                column(ItemNo_Line; ItemNumber)
                {
                }
                column(ItemNoOrg_Line; ItemNumberOrg)
                {
                }
                column(Description_Line; DescriptionTxt)
                {
                }
                column(Quantity_Line; QtyTxt)
                {
                }
                column(UnitOfMeasure; UnitCode)
                {
                }
                column(UnitPrice; PriceTxt)
                {
                }
                column(LineDiscPct; DiscTxt)
                {
                }
                column(LineAmount_Line; AmountTxt)
                {
                }
                column(VATIdentifier_Line; "VAT Identifier")
                {
                }
                column(VATPct_Line; "VAT %")
                {
                }
                column(ShipmentNo_Line; ShipmentNo)
                {
                }
                column(Position_Line; SCPosition)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    TotalSubTotal -= "Line Amount";
                    TotalInvDiscAmount += "Inv. Discount Amount";
                    TotalAmount -= Amount;
                    TotalAmountVAT -= "Amount Including VAT" - Amount;
                    TotalAmountInclVAT -= "Amount Including VAT";
                    TotalPaymentDiscOnVAT -= -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");

                    ItemNumberOrg := "No.";
                    ItemNumber := SCReportUtil.FixItemNumber("No.");

                    QtyTxt := SCUtil.FixAmount(-Quantity, 0, false);
                    PriceTxt := SCUtil.FixAmount("Unit Price", 4, false);
                    DiscTxt := SCUtil.FixAmount("Line Discount %", 0, false);
                    AmountTxt := SCUtil.FixAmount(-"Line Amount", 2, false);
                    DescriptionTxt := SCUtil.CrMemoLineDescription(Line, false, true);

                    ShipmentNo := '';
                    if Line.Type = Line.Type::Item then
                        ShipmentNo := SCSpecial.SCGetSalesCrMemoShptLines(Line."Document No.", Line."Line No.");

                    UnitCode := Line."Unit of Measure";
                    if UnitCode = '' then
                        UnitCode := line."Unit of Measure Code";
                end;

            }
            dataitem(Totals; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(TotalNetAmount; TotalAmount)
                {
                }
                column(TotalAmountIncludingVAT; TotalAmountInclVAT)
                {
                }
                column(TotalVATAmount; TotalAmountVAT)
                {
                }
                column(TotalInvoiceDiscountAmount; TotalInvDiscAmount)
                {
                }
                column(TotalPaymentDiscountOnVAT; TotalPaymentDiscOnVAT)
                {
                }
                column(TotalSubTotal; TotalSubTotal)
                {
                }
                column(TotalSubTotalMinusInvoiceDiscount; TotalSubTotal + TotalInvDiscAmount)
                {
                }
                column(TotalText; TotalText)
                {
                }
            }
            dataitem(Labels; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(LblDocument; scutil.LabelTxt('LblDocument'))
                {
                }
                column(LblDocumentNo; scutil.LabelTxt('LblDocumentNo'))
                {
                }
                column(LblDocumentDate; scutil.LabelTxt('LblDocumentDate'))
                {
                }
                column(LblBillingAddress; scutil.LabelTxt('LblBillingAddress'))
                {
                }
                column(LblShipAddress; scutil.LabelTxt('LblShipAddress'))
                {
                }
                column(LblPage; scutil.LabelTxt('LblPage'))
                {
                }
                column(LblYourOrder; scutil.LabelTxt('LblYourOrder'))
                {
                }
                column(LblYourRef; scutil.LabelTxt('LblYourRef'))
                {
                }
                column(LblYourCVR; scutil.LabelTxt('LblYourCVR'))
                {
                }
                column(LblYourEAN; scutil.LabelTxt('LblYourEAN'))
                {
                }
                column(LblAccountNo; scutil.LabelTxt('LblAccountNo'))
                {
                }
                column(LblOrderDate; scutil.LabelTxt('LblOrderDate'))
                {
                }
                column(LblShipDate; scutil.LabelTxt('LblShipDate'))
                {
                }
                column(LblDueDate; scutil.LabelTxt('LblDueDate'))
                {
                }
                column(LblPayLatest; scutil.LabelTxt('LblPayLatest'))
                {
                }
                column(LblOrderNo; scutil.LabelTxt('LblOrderNo'))
                {
                }
                column(LblDlvNote; scutil.LabelTxt('LblDlvNote'))
                {
                }
                column(LblOurRef; scutil.LabelTxt('LblOurRef'))
                {
                }
                column(LblPayment; scutil.LabelTxt('LblPayment'))
                {
                }
                column(LblBankName; scutil.LabelTxt('LblBankName'))
                {
                }
                column(LblBankAcc; scutil.LabelTxt('LblBankAcc'))
                {
                }
                column(LblIBAN; scutil.LabelTxt('LblIBAN'))
                {
                }
                column(LblSWIFT; scutil.LabelTxt('LblSWIFT'))
                {
                }
                column(LblShipmentNo; scutil.LabelTxt('LblShipmentNo'))
                {
                }
                column(LblShipTerms; scutil.LabelTxt('LblShipTerms'))
                {
                }
                column(LblShipMethod; scutil.LabelTxt('LblShipMethod'))
                {
                }
                column(LblYourItemNo; scutil.LabelTxt('LblYourItemNo'))
                {
                }
                column(LblPosNo; scutil.LabelTxt('LblPosNo'))
                {
                }
                column(LblItemNo; scutil.LabelTxt('LblItemNo'))
                {
                }
                column(LblDescription; scutil.LabelTxt('LblDescription'))
                {
                }
                column(LblQty; scutil.LabelTxt('LblQty'))
                {
                }
                column(LblDlvQty; scutil.LabelTxt('LblDlvQty'))
                {
                }
                column(LblRestQty; scutil.LabelTxt('LblRestQty'))
                {
                }
                column(LblPrice; scutil.LabelTxt('LblPrice'))
                {
                }
                column(LblDisc; LblxDiscPctTxt)
                {
                }
                column(LblAmount; LblxAmount)
                {
                }
                column(LblLineDate; scutil.LabelTxt('LblLineDate'))
                {
                }
                column(LblEmployeNo; scutil.LabelTxt('LblEmployeNo'))
                {
                }
                column(LblSubTotal; scutil.LabelTxt('LblSubTotal'))
                {
                }
                column(LblFreight; scutil.LabelTxt('LblFreight'))
                {
                }
                column(LbLEndDisc; LblxEndDiscTxt)
                {
                }
                column(LblVAT; scutil.LabelTxt('LblVAT'))
                {
                }
                column(LblVATAmount; LblxVATAmount)
                {
                }
                column(LblExVATAmount; scutil.LabelTxt('LblExVATAmount'))
                {
                }
                column(LblCurrency; scutil.LabelTxt('LblCurrency'))
                {
                }
                column(LblTotalAmount; LblxTotalAmount)
                {
                }
                column(LblPaymentId; PaymentRefTxt)
                {
                }
                column(LblPaymentDueTxt; scutil.LabelTxt('LblPaymentDueTxt'))
                {
                }
                column(LblSubText1; scutil.LabelTxt('LblSubText1'))
                {
                }
                column(LblSubText2; scutil.LabelTxt('LblSubText2'))
                {
                }
                column(SCFooterFixParm; scutil.LabelTxt('LblSCFooterFixParm'))
                {
                }
                column(SCFooterFixText; scutil.LabelTxt('LblSCFooterFixText'))
                {
                }
                column(LblSCContent; scutil.LabelTxt('LblSCContent'))
                {
                }
                column(LblSCDuty; scutil.LabelTxt('LblSCDuty'))
                {
                }
                column(LblUnit; scutil.LabelTxt('LblUnit'))
                {
                }
                column(LblWeb; scutil.LabelTxt('LblWeb'))
                {
                }
                column(LblMail; scutil.LabelTxt('LblMail'))
                {
                }
                column(LblExportNo; scutil.LabelTxt('LblExportNo'))
                {
                }
                column(LblRegNo; scutil.LabelTxt('LblRegNo'))
                {
                }
                column(LblPhoneNo; scutil.LabelTxt('LblPhoneNo'))
                {
                }
                column(LblVatRegNo; scutil.LabelTxt('LblVatRegNo'))
                {
                }
            }
            trigger OnAfterGetRecord();
            var
                Customer: Record Customer;
                SalesCrMemoLine: Record "Sales Cr.Memo Line";
                Item: Record Item;
                VatValueFound: Boolean;
                FirstItemNo: Code[20];
                EUCountry: Boolean;

            begin
                Customer.Get(Header."Bill-to Customer No.");

                if not CurrReport.Preview then
                    Codeunit.Run(Codeunit::"Sales Cr. Memo-Printed", Header);

                getReportInfo(LanguageCode, ReportNo);
                SCUtil.SetReportInfo(LanguageCode, ReportNo);
                CurrReport.Language := Language.GetLanguageID(LanguageCode);

                SCFileName := StrSubstNo(scutil.LabelTxt('LblFileName'), "No.");

                SCAddress.FormatCrMemoBillingAddress(Header, InvoiceAddress, true);
                SCAddress.FormatCrMemoShippingAddress(Header, ShipToAddr, true);
                SCAddress.GetCompanyAddress(CompanyNameTxt, CompanyAddress1, CompanyAddress2, CompanyPostCodeCity, CompanyCountry, CompanyPhone, CompanyURL, CompanyEmail, CompanyCVR);

                CurrencyCode := SCUtil.SetCurrency("Currency Code");
                VATPct := SCUtil.CrMemoSetVATPctSpec(Header, false, VatValueFound, EUCountry);
                if VatValueFound or not EUCountry then begin
                    LblxVATAmount := StrSubstNo(scutil.LabelTxt('LblVATAmountText'), VATPct);
                    if VatValueFound then
                        LblxTotalAmount := StrSubstNo(scutil.LabelTxt('LblTotalAmountInclVAT'), CurrencyCode)
                    else
                        LblxTotalAmount := StrSubstNo(scutil.LabelTxt('LblTotalAmount'), CurrencyCode);
                    VATFreeText := '';
                end else begin
                    LblxVATAmount := scutil.LabelTxt('LblVATFree');
                    LblxTotalAmount := StrSubstNo(scutil.LabelTxt('LblTotalAmount'), CurrencyCode);
                    VATFreeText := '';
                    FirstItemNo := '';
                    SalesCrMemoLine.Reset;
                    SalesCrMemoLine.SetRange("Document No.", Header."No.");
                    SalesCrMemoLine.SetRange(Type, SalesCrMemoLine.Type::Item);
                    if SalesCrMemoLine.FindFirst() then
                        FirstItemNo := SalesCrMemoLine."No.";
                    if FirstItemNo <> '' then begin
                        if Item.get(FirstItemNo) then begin
                            if item.Type = item.Type::Service then begin
                                VATFreeText := scutil.LabelTxt('LblVATFreeSpecService');
                            end else begin
                                VATFreeText := scutil.LabelTxt('LblVATFreeSpecItem');
                            end;
                        end;
                    end;
                end;



                LblxAmount := StrSubstNo(scutil.LabelTxt('LblAmount'), CurrencyCode);

                SCIBAN := SCSpecial.SCSetIBAN(CurrencyCode);

                LblxDiscPctTxt := '';
                SalesCrMemoLine.Reset;
                SalesCrMemoLine.SetRange("Document No.", Header."No.");
                SalesCrMemoLine.SetFilter("Line Discount %", '<>%1', 0);
                if SalesCrMemoLine.FindFirst then
                    LblxDiscPctTxt := scutil.LabelTxt('LblDisc');

                if "Payment Terms Code" = '' then
                    PaymentTerms.Init
                else begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                end;

                if "Shipment Method Code" = '' then
                    ShipmentMethod.Init
                else begin
                    ShipmentMethod.Get("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                end;

                CustCVRNo := Customer."VAT Registration No.";
                CustEANNo := SC_GetGLN(0);
                OurRef := SCUtil.SetCreditMemoOurRef(Header);
                Email := Header."Sell-to E-Mail";
                Phone := Header."Sell-to Phone No.";

                PostLineTxtCode := SCReportSetup.GetCode('TXTCODES', '', '', 'TxtCodeCrMemo');
                DocumentPostLineTxt := SCUtil.TextCodeDescription(PostLineTxtCode, "Language Code", false, false, false);

                TotalSubTotal := 0;
                TotalInvDiscAmount := 0;
                TotalAmount := 0;
                TotalAmountVAT := 0;
                TotalAmountInclVAT := 0;
                TotalPaymentDiscOnVAT := 0;

            end;

        }
    }


    requestpage
    {
        SaveValues = true;

        layout
        {
        }

    }

    trigger OnInitReport()
    begin
        CompanyInformation.Get;
        CompanyInformation.CalcFields(Picture);
    end;

    var
        SCReportUtil: Codeunit SCReportUtil;
        CompanyInformation: Record "Company Information";
        SCFileName: text;
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        SalesSetup: Record "Sales & Receivables Setup";
        Language: Codeunit Language;
        VATClause: Record "VAT Clause";
        PostedShipmentDate: Date;
        InvoiceAddress: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyNameTxt: Text;
        CompanyInfo: Text;
        CompanyAddress1: Text;
        CompanyAddress2: Text;
        CompanyPostCodeCity: Text;
        CompanyCountry: Text;
        CompanyPhone: Text;
        CompanyURL: Text;
        CompanyEmail: Text;
        CompanyCVR: Text;
        CompanyExportNo: Text;
        CompanyRegNo: Text;
        SalesPersonText: Text[30];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        LineDiscountPctText: Text;
        DocumentPreLineTxt: Text;
        DocumentPostLineTxt: Text;
        DocumentReminderTxt: Text;
        PaymentSpecText: Text;
        MoreLines: Boolean;
        CopyText: Text[30];
        CrMemoPostLineTxt: Text;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalPaymentDiscOnVAT: Decimal;
        TransHeaderAmount: Decimal;
        CalculatedExchRate: Decimal;
        ExchangeRateText: Text;
        VATBaseLCY: Decimal;
        VATAmountLCY: Decimal;
        TotalVATBaseLCY: Decimal;
        TotalVATAmountLCY: Decimal;
        PrevLineAmount: Decimal;
        SCPDFStatus: Integer;
        OurRef: Text[50];
        CustCVRNo: Text[20];
        CustEANNo: Text[20];
        DescriptionX: Text;
        ShipmentDescription: Text[50];
        CurrencyCode: Code[10];
        FreightAmount: Decimal;
        EndDiscPct: Decimal;
        EndDiscAmount: Decimal;
        LblxEndDiscTxt: Text;
        VATPct: Text;
        DescriptionTxt: Text;
        QtyTxt: Text;
        PriceTxt: Text;
        DiscTxt: Text;
        AmountTxt: Text;
        PaymentRef: Text;
        PaymentRefTxt: Text;
        Email: text;
        Phone: text;
        BankInfo: Text;
        BankName: Text;
        BankAccount: Text;
        Iban: Text;
        SWIFT: Text;
        LastLine: Integer;
        LblxAmount: text;
        LblxDiscPctTxt: Text;
        LblxTotalAmount: Text;
        LblxVATAmount: Text;
        QtyDecimals: Integer;
        PriceDecimals: Integer;
        InvoiceTxtCode: Code[20];
        VATPercent: Decimal;
        SCIBAN: Text;
        SCUtil: Codeunit SCReportUtil;
        SCAddress: Codeunit SCReportAddress;
        SCSpecial: Codeunit SCReportSpecial;
        SCReportSetup: Record SCReportSetup;
        ReportNo: Integer;
        LanguageCode: Code[10];
        ShipmentNo: Code[20];
        SkipSCPDF: Boolean;
        PostLineTxtCode: code[10];
        UnitCode: text;
        ItemNumber: Code[20];
        ItemNumberOrg: Code[20];
        VATFreeText: Text;

    local procedure SC_GetGLN(FldNo: Integer): Code[13]
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
    begin
        RecRef.GetTable(Header);
        FldRef := RecRef.Field(FldNo);
        exit(Format(FldRef.Value));
    end;

    procedure SetSkipSCPDF()
    begin
        SkipSCPDF := true;
    end;

    local procedure getReportInfo(var LanguageCodeX: Code[10]; var ReportNoX: Integer)
    var
        SCReportSetup: Record SCReportSetup;
        DefaultLanguageCode: Code[10];
    begin
        LanguageCodeX := Header."Language Code";
        if LanguageCodeX = '' then
            LanguageCodeX := SCReportSetup.GetCode('LANGUAGE', '', '', 'DefaultLanguageCode');
        Evaluate(ReportNoX, SCUtil.StrKeep(CurrReport.ObjectId(false), '0123456789'));
    end;

}
