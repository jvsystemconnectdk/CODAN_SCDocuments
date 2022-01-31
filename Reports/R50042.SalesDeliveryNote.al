Report 50042 SalesDeliveryNote
{
    DefaultLayout = Word;
    Caption = 'Sales - Delivery Note';
    PreviewMode = PrintLayout;
    WordMergeDataItem = Header;


    dataset
    {
        dataitem(Header; "Sales Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Delivery Note';
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
            column(BankInfo; BankInfo)
            {
            }
            column(BankName; BankName)
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
            column(ShipmentAddress1; ShipToAddress[1])
            {
            }
            column(ShipmentAddress2; ShipToAddress[2])
            {
            }
            column(ShipmentAddress3; ShipToAddress[3])
            {
            }
            column(ShipmentAddress4; ShipToAddress[4])
            {
            }
            column(ShipmentAddress5; ShipToAddress[5])
            {
            }
            column(ShipmentAddress6; ShipToAddress[6])
            {
            }
            column(ShipmentAddress7; ShipToAddress[7])
            {
            }
            column(ShipmentAddress8; ShipToAddress[8])
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
            column(OrderNo; "Order No.")
            {
            }
            column(ShipmentMethodDescription; ShipmentMethod.Description)
            {
            }
            column(PaymentTermsDescription; PaymentTerms.Description)
            {
            }
            column(PaymentReference; PaymentRef)
            {
            }
            column(PaymentSpecText; PaymentSpecText)
            {
            }
            column(OrderDate; SCReportUtil.FixDateDDMMYYYY("Order Date"))
            {
            }
            column(ShipmentDate; SCReportUtil.FixDateDDMMYYYY("Shipment Date"))
            {
            }
            column(DocumentDate; SCReportUtil.FixDateDDMMYYYY("Posting Date"))
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
            column(Currency; Currency)
            {
            }
            column(FreightAmount; FreightAmount)
            {
            }
            column(EndDiscAmount; EndDiscTxt)
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
            dataitem(Line; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = Header;
                DataItemTableView = sorting("Document No.", "Line No.") where(Quantity = filter(<> 0));
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
                column(VATIdentifier_Line; '')
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
                column(LineLotNoSpec; LineLotNoSpec)
                {
                }
                column(LineExpirySpec; LineExpirySpec)
                {
                }

                trigger OnAfterGetRecord();
                var
                    Item: Record Item;
                    LineAmount: Decimal;
                    LineWeight: Decimal;
                begin
                    LineAmount := Quantity * "Unit Price" * (1 - Line."Line Discount %" / 100);
                    TotalSubTotal += LineAmount;
                    TotalAmount += LineAmount * (1 + Line."VAT %" / 100);
                    TotalAmountVAT += LineAmount * Line."VAT %" / 100;

                    ItemNumberOrg := "No.";
                    ItemNumber := SCReportUtil.FixItemNumber("No.");

                    QtyTxt := SCUtil.FixAmount(Quantity, 0, false);
                    PriceTxt := SCUtil.FixAmount("Unit Price", 2, false);
                    DiscTxt := SCUtil.FixAmount("Line Discount %", 0, false);
                    AmountTxt := SCUtil.FixAmount(LineAmount, 2, false);
                    DescriptionTxt := SCUtil.ShipmentLineDescription(Line, false, true);
                    UnitCode := Line."Unit of Measure";
                    if UnitCode = '' then
                        UnitCode := line."Unit of Measure Code";
                    SCReportUtil.GetShipmentLineLotSpec(Line."Document No.", Line."Line No.", LineLotNoSpec, LineExpirySpec)
                end;

            }
            dataitem(Totals; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(TotalSubTotal; TotalSubTotal)
                {
                }
                column(TotalAmountVAT; TotalAmountVAT)
                {
                }
                column(TotalAmount; TotalAmount)
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
                column(LblAmount; scutil.LabelTxt('LblAmount'))
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
                column(LbLEndDisc; EndDiscTxt)
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
                column(LblPallets; scutil.LabelTxt('LblPallets'))
                {
                }
                column(LblWeight; scutil.LabelTxt('LblWeight'))
                {
                }
                column(LblCartons; scutil.LabelTxt('LblCartons'))
                {
                }
                column(LblNetWeight; scutil.LabelTxt('LblNetWeight'))
                {
                }
                column(LblCartonsLine; scutil.LabelTxt('LblCartonsLine'))
                {
                }
                column(LblVatDeclaration; LblXVatDeclaration)
                {
                }
                column(LblLotNo; scutil.LabelTxt('LblLotNo'))
                {
                }
                column(LblLotExpiry; scutil.LabelTxt('LblLotExpiry'))
                {
                }

            }
            trigger OnAfterGetRecord();
            var
                Customer: Record Customer;
                CountryRegion: Record "Country/Region";
                InStr: InStream;
                CR: Char;
            begin
                Customer.Get(Header."Bill-to Customer No.");

                getReportInfo(LanguageCode, ReportNo);
                SCUtil.SetReportInfo(LanguageCode, ReportNo);
                CurrReport.Language := Language.GetLanguageID(LanguageCode);

                SCFileName := StrSubstNo(scutil.LabelTxt('LblFileName'), "No.");

                SCAddress.FormatShipmentBillingAddress(Header, InvoiceAddress, true);
                SCAddress.FormatShipmentShippingAddress(Header, ShipToAddress, true);
                SCAddress.GetCompanyAddress(CompanyNameTxt, CompanyAddress1, CompanyAddress2, CompanyPostCodeCity, CompanyCountry, CompanyPhone, CompanyURL, CompanyEmail, CompanyCVR);

                LblXVatDeclaration := '';
                if CountryRegion.GET(Header."Ship-to Country/Region Code") then
                    if CountryRegion."EU Country/Region Code" = '' then
                        LblXVatDeclaration := scutil.LabelTxt('LblVatDeclaration');

                if "Payment Terms Code" = '' then
                    PaymentTerms.Init
                else begin
                    if PaymentTerms.Get("Payment Terms Code") then
                        PaymentTerms.TranslateDescription(PaymentTerms, LanguageCode);
                end;

                if "Shipment Method Code" = '' then
                    ShipmentMethod.Init
                else begin
                    if ShipmentMethod.Get("Shipment Method Code") then
                        ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                end;

                CustCVRNo := Customer."VAT Registration No.";
                OurRef := SCUtil.SetShipmentOurRef(Header);
                Email := Header."Sell-to E-Mail";
                Phone := Header."Sell-to Phone No.";

                PostLineTxtCode := SCReportSetup.GetCode('TXTCODES', '', '', 'TxtCodeDeliveryNote');
                DocumentPostLineTxt := SCUtil.TextCodeDescription(PostLineTxtCode, "Language Code", false, false, false);

                TotalSubTotal := 0;
                TotalAmount := 0;
                TotalAmountVAT := 0;

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
        PaymentTerms: Record "Payment Terms";
        ShipmentMethod: Record "Shipment Method";
        Language: Codeunit Language;
        InvoiceAddress: array[8] of Text[50];
        ShipToAddress: array[8] of Text[50];
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
        LineDiscountPctText: Text;
        LineLotNoSpec: Text;
        LineExpirySpec: Text;
        DocumentPreLineTxt: Text;
        DocumentPostLineTxt: Text;
        DocumentReminderTxt: Text;
        PaymentSpecText: Text;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalPaymentDiscOnVAT: Decimal;
        SCPDFStatus: Integer;
        OurRef: Text[50];
        CustCVRNo: Text[20];
        CustEANNo: Text[20];
        Currency: Code[10];
        FreightAmount: Decimal;
        EndDiscPct: Decimal;
        EndDiscAmount: Decimal;
        EndDiscTxt: Text;
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
        LblxDiscPctTxt: Text;
        LblxTotalAmount: Text;
        LblxVATAmount: Text;
        LblXVatDeclaration: Text;
        VATPercent: Decimal;
        SCIBAN: Text;
        SCUtil: Codeunit SCReportUtil;
        SCAddress: Codeunit SCReportAddress;
        SCReportSetup: Record SCReportSetup;
        ReportNo: Integer;
        LanguageCode: Code[10];
        ShipmentNo: Code[20];
        PostLineTxtCode: code[10];
        UnitCode: text;
        ItemNumber: Code[20];
        ItemNumberOrg: Code[20];


    local procedure SC_GetGLN(): Code[13]
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
    begin
        RecRef.GetTable(Header);
        FldRef := RecRef.Field(13600);
        exit(Format(FldRef.Value));
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
