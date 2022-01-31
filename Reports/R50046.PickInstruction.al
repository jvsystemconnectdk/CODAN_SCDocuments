Report 50046 SalesSalesPicklist
{
    DefaultLayout = Word;
    Caption = 'Sales - Picklist';
    PreviewMode = PrintLayout;
    WordMergeDataItem = Header;


    dataset
    {
        dataitem(Header; "Sales Header")
        {
            RequestFilterFields = "No.", "Sell-to Customer No.";
            RequestFilterHeading = 'Picklist';
            column(SCFileName; SCFileName)
            {
            }
            column(CompanyInfo; CompanyInfo)
            {
            }
            column(CompanyName; CompanyNameTxt)
            {
            }
            column(CompanyAddress; CompanyAddress)
            {
            }
            column(CompanyPostcodeCity; CompanyPostCodeCity)
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
            column(BankRegNo; BankRegNo)
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
            column(ShipmentContact; ShipToContact)
            {
            }
            column(ShipmentMail; ShipToEMail)
            {
            }
            column(ShipmentPhone; ShipToPhone)
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
            column(OrderNo; '')
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
            column(DocumentDate; SCReportUtil.FixDateDDMMYYYY(Today()))
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
            column(TotalLineDiscAmount; TotalLineDiscAmountX)
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
            column(WorkDescription; WorkDescription)
            {
            }
            column(ContactName; ContactName)
            {
            }
            column(DocumentTitle_Lbl; SCReportUtil.LabelTxt('LblDocument'))
            {
            }
            column(Page_Lbl; SCReportUtil.LabelTxt('LblPage'))
            {
            }
            column(Invoice_Lbl; '')
            {
            }
            dataitem(Line; "Sales Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemLinkReference = Header;
                DataItemTableView = sorting("Document No.", "Line No.");
                column(ItemNo_Line; "No.")
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
                column(ShipmentDate_Line; SCReportUtil.FixDateDDMMYYYY("Shipment Date"))
                {
                }
                column(LotSerialNoText; LotSerialNoText)
                {
                }
                column(LocationCode; "Location Code")
                {
                }

                trigger OnAfterGetRecord();
                var
                    LineQty: Decimal;
                    LineAmount: Decimal;

                begin

                    LineQty := "Outstanding Quantity";
                    if LineQty = 0 then
                        CurrReport.Skip();

                    LineAmount := LineQty * "Unit Price" * (1 - "Line Discount %" / 100);

                    QtyTxt := SCReportUtil.FixAmount(LineQty, 2, false);
                    PriceTxt := SCReportUtil.FixAmount("Unit Price", 2, false);
                    DiscTxt := SCReportUtil.FixAmount("Line Discount %", 2, false);
                    AmountTxt := SCReportUtil.FixAmount(LineAmount, 2, false);
                    DescriptionTxt := SCReportUtil.SalesLineDescription(Line, false, false);
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
            }
            dataitem(Labels; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(LblDocument; SCReportUtil.LabelTxt('LblDocument'))
                {
                }
                column(LblDocumentNo; SCReportUtil.LabelTxt('LblDocumentNo'))
                {
                }
                column(LblDocumentDate; SCReportUtil.LabelTxt('LblDocumentDate'))
                {
                }
                column(LblBillingAddress; SCReportUtil.LabelTxt('LblBillingAddress'))
                {
                }
                column(LblShipAddress; SCReportUtil.LabelTxt('LblShipAddress'))
                {
                }
                column(LblPage; SCReportUtil.LabelTxt('LblPage'))
                {
                }
                column(LblYourOrder; SCReportUtil.LabelTxt('LblYourOrder'))
                {
                }
                column(LblYourRef; SCReportUtil.LabelTxt('LblYourRef'))
                {
                }
                column(LblYourCVR; SCReportUtil.LabelTxt('LblYourCVR'))
                {
                }
                column(LblYourEAN; SCReportUtil.LabelTxt('LblYourEAN'))
                {
                }
                column(LblAccountNo; SCReportUtil.LabelTxt('LblAccountNo'))
                {
                }
                column(LblOrderDate; SCReportUtil.LabelTxt('LblOrderDate'))
                {
                }
                column(LblShipDate; SCReportUtil.LabelTxt('LblShipDate'))
                {
                }
                column(LblDueDate; SCReportUtil.LabelTxt('LblDueDate'))
                {
                }
                column(LblPayLatest; SCReportUtil.LabelTxt('LblPayLatest'))
                {
                }
                column(LblOrderNo; SCReportUtil.LabelTxt('LblOrderNo'))
                {
                }
                column(LblDlvNote; SCReportUtil.LabelTxt('LblDlvNote'))
                {
                }
                column(LblOurRef; SCReportUtil.LabelTxt('LblOurRef'))
                {
                }
                column(LblPayment; SCReportUtil.LabelTxt('LblPayment'))
                {
                }
                column(LblBankName; SCReportUtil.LabelTxt('LblBankName'))
                {
                }
                column(LblBankAcc; SCReportUtil.LabelTxt('LblBankAcc'))
                {
                }
                column(LblIBAN; SCReportUtil.LabelTxt('LblIBAN'))
                {
                }
                column(LblSWIFT; SCReportUtil.LabelTxt('LblSWIFT'))
                {
                }
                column(LblShipmentNo; SCReportUtil.LabelTxt('LblShipmentNo'))
                {
                }
                column(LblShipTerms; SCReportUtil.LabelTxt('LblShipTerms'))
                {
                }
                column(LblShipMethod; SCReportUtil.LabelTxt('LblShipMethod'))
                {
                }
                column(LblYourItemNo; SCReportUtil.LabelTxt('LblYourItemNo'))
                {
                }
                column(LblPosNo; SCReportUtil.LabelTxt('LblPosNo'))
                {
                }
                column(LblItemNo; SCReportUtil.LabelTxt('LblItemNo'))
                {
                }
                column(LblDescription; SCReportUtil.LabelTxt('LblDescription'))
                {
                }
                column(LblQty; SCReportUtil.LabelTxt('LblQty'))
                {
                }
                column(LblDlvQty; SCReportUtil.LabelTxt('LblDlvQty'))
                {
                }
                column(LblRestQty; SCReportUtil.LabelTxt('LblRestQty'))
                {
                }
                column(LblPrice; SCReportUtil.LabelTxt('LblPrice'))
                {
                }
                column(LblDisc; LblxDiscPctTxt)
                {
                }
                column(LblAmount; LblxAmount)
                {
                }
                column(LblLineDate; SCReportUtil.LabelTxt('LblLineDate'))
                {
                }
                column(LblEmployeNo; SCReportUtil.LabelTxt('LblEmployeNo'))
                {
                }
                column(LblSubTotal; SCReportUtil.LabelTxt('LblSubTotal'))
                {
                }
                column(LblFreight; SCReportUtil.LabelTxt('LblFreight'))
                {
                }
                column(LbLEndDisc; LblxEndDiscTxt)
                {
                }
                column(LblVAT; SCReportUtil.LabelTxt('LblVAT'))
                {
                }
                column(LblVATAmount; LblxVATAmount)
                {
                }
                column(LblExVATAmount; SCReportUtil.LabelTxt('LblExVATAmount'))
                {
                }
                column(LblCurrency; SCReportUtil.LabelTxt('LblCurrency'))
                {
                }
                column(LblTotalAmount; LblxTotalAmount)
                {
                }
                column(LblPaymentId; PaymentRefTxt)
                {
                }
                column(LblPaymentDueTxt; SCReportUtil.LabelTxt('LblPaymentDueTxt'))
                {
                }
                column(LblSubText1; SCReportUtil.LabelTxt('LblSubText1'))
                {
                }
                column(LblSubText2; SCReportUtil.LabelTxt('LblSubText2'))
                {
                }
                column(SCFooterFixParm; SCReportUtil.LabelTxt('LblSCFooterFixParm'))
                {
                }
                column(SCFooterFixText; SCReportUtil.LabelTxt('LblSCFooterFixText'))
                {
                }
                column(LblSCContent; SCReportUtil.LabelTxt('LblSCContent'))
                {
                }
                column(LblSCDuty; SCReportUtil.LabelTxt('LblSCDuty'))
                {
                }
                column(LblUnit; SCReportUtil.LabelTxt('LblUnit'))
                {
                }
                column(LblPhone; SCReportUtil.LabelTxt('LblPhone'))
                {
                }
                column(LblWeb; SCReportUtil.LabelTxt('LblWeb'))
                {
                }
                column(LblMail; SCReportUtil.LabelTxt('LblMail'))
                {
                }
                column(LblCVRNo; SCReportUtil.LabelTxt('LBLCVRNo'))
                {
                }
                column(LblExportNo; SCReportUtil.LabelTxt('LblExportNo'))
                {
                }
                column(LblRegNo; SCReportUtil.LabelTxt('LblRegNo'))
                {
                }
                column(LblExternalDocNo; SCReportUtil.LabelTxt('LblExternalDocNo'))
                {
                }
                column(LblContactName; SCReportUtil.LabelTxt('LblContactName'))
                {
                }
                column(LblTotalLineDiscAmount; LblXTotalLineDiscAmount)
                {
                }

            }
            trigger OnAfterGetRecord();
            var
                PaymentMethod: Record "Payment Method";
                Customer: Record Customer;
                SalesLine: Record "Sales Line";
                VatValueFound: Boolean;
                DocumentType: enum "Sales Comment Document Type";
                EUCountry: Boolean;

            begin
                Customer.Get(Header."Bill-to Customer No.");

                getReportInfo(LanguageCode, ReportNo);
                SCReportUtil.SetReportInfo(LanguageCode, ReportNo);
                CurrReport.Language := Language.GetLanguageID(LanguageCode);

                SCFileName := StrSubstNo(SCReportUtil.LabelTxt('LblFileName'), "No.");

                WorkDescription := Header.GetWorkDescription();
                ContactName := Header."Sell-to Contact";

                SCReportAddress.FormatSalesBillingAddress(Header, InvoiceAddress, true);
                SCReportAddress.FormatSalesShippingAddress(Header, ShipToAddress, true);

                CurrencyCode := SCReportUtil.SetCurrency("Currency Code");
                LblxTotalAmount := StrSubstNo(SCReportUtil.LabelTxt('LblTotalAmount'), CurrencyCode);
                VATPct := SCReportUtil.SalesSetVATPctSpec(Header, false, VatValueFound, EUCountry);
                if VatValueFound then
                    LblxVATAmount := StrSubstNo(SCReportUtil.LabelTxt('LblVATAmountText'), VATPct)
                else
                    LblxVATAmount := SCReportUtil.LabelTxt('LblVATFree');

                LblxAmount := StrSubstNo(SCReportUtil.LabelTxt('LblAmount'), CurrencyCode);

                LineDiscountPctText := '';
                LblXTotalLineDiscAmount := '';
                TotalLineDiscAmountX := '';
                TotalLineDiscAmount := 0;
                SalesLine.Reset;
                SalesLine.SetRange("Document Type", Header."Document Type");
                SalesLine.SetRange("Document No.", Header."No.");
                SalesLine.SetFilter("Line Discount %", '<>%1', 0);
                if SalesLine.Findset then begin
                    LineDiscountPctText := SCReportUtil.LabelTxt('LblDisc');
                    repeat
                        TotalLineDiscAmount += (SalesLine.Quantity * SalesLine."Unit Price" * SalesLine."Line Discount %" / 100)
                    until SalesLine.Next() = 0;
                end;
                if TotalLineDiscAmount <> 0 then begin
                    LblXTotalLineDiscAmount := SCReportUtil.LabelTxt('LblTotalLineDiscAmount');
                    TotalLineDiscAmountX := SCReportUtil.FixAmount(TotalLineDiscAmount, 2, false);
                end;

                SCReportAddress.GetCompanyAddressInfo(CompanyNameTxt, CompanyInfo, true, false);

                PaymentTerms.Init;
                if "Shipment Method Code" = '' then
                    ShipmentMethod.Init
                else begin
                    if ShipmentMethod.Get("Shipment Method Code") then
                        ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                end;

                CustCVRNo := Customer."VAT Registration No.";
                CustEANNo := SC_GetGLN(0);
                OurRef := SCReportUtil.SetSalesOurRef(Header);
                Email := Header."Sell-to E-Mail";
                Phone := Header."Sell-to Phone No.";
                ShipToContact := Header."Ship-to Contact";

                //if SCReportSetup.DocumentCommentPicklist then begin
                //    DocumentPreLineTxt := SCReportUtil.SetDocumentPreLineTxt(DocumentType::Order, "No.");
                //    DocumentPostLineTxt := SCReportUtil.SetDocumentPostLineTxt(DocumentType::Order, "No.");
                //end;
                //DocumentPostLineTxt += SCReportUtil.TextCodeDescription(SCReportSetup.TextCodePicklist, "Language Code", false, false, false);

                EndDiscAmount := 0;
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
        CompanyInformation: Record "Company Information";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        SCFileName: text;
        Language: Codeunit Language;
        InvoiceAddress: array[8] of Text[50];
        ShipToAddress: array[8] of Text[50];
        ShipToContact: Text;
        ShipToPhone: Text;
        ShipToEmail: Text;
        SalesPersonText: Text[30];
        TotalText: Text[50];
        LineDiscountPctText: Text;
        DocumentPreLineTxt: Text;
        DocumentPostLineTxt: Text;
        DocumentReminderTxt: Text;
        PaymentSpecText: Text;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalLineDiscAmount: Decimal;
        TotalLineDiscAmountX: Text;
        TotalPaymentDiscOnVAT: Decimal;
        SCPDFStatus: Integer;
        OurRef: Text[50];
        CustCVRNo: Text[20];
        CustEANNo: Text[20];
        CurrencyCode: Code[10];
        FreightAmount: Decimal;
        EndDiscPct: Decimal;
        EndDiscAmount: Decimal;
        LblxEndDiscTxt: Text;
        VATPct: Text;
        DescriptionTxt: Text;
        LotSerialNoText: Text;
        QtyTxt: Text;
        PriceTxt: Text;
        DiscTxt: Text;
        AmountTxt: Text;
        PaymentRef: Text;
        PaymentRefTxt: Text;
        CompanyNameTxt: Text;
        CompanyInfo: Text;
        CompanyAddress: Text;
        CompanyPostCodeCity: Text;
        CompanyCountry: Text;
        CompanyPhone: Text;
        CompanyURL: Text;
        CompanyEmail: Text;
        CompanyCVR: Text;
        CompanyExportNo: Text;
        CompanyRegNo: Text;
        Email: text;
        Phone: text;
        BankInfo: Text;
        BankName: Text;
        BankRegNo: Text;
        BankAccount: Text;
        Iban: Text;
        SWIFT: Text;
        LblxAmount: text;
        LblxDiscPctTxt: Text;
        LblxTotalAmount: Text;
        LblxVATAmount: Text;
        LblxTotalLineDiscAmount: Text;
        VATPercent: Decimal;
        SCIBAN: Text;
        SCReportUtil: Codeunit SCReportUtil;
        SCReportAddress: Codeunit SCReportAddress;
        ReportNo: Integer;
        LanguageCode: Code[10];
        ShipmentNo: Code[20];
        SkipSCPDF: Boolean;
        UnitCode: text;
        WorkDescription: Text;
        ContactName: Text;

    local procedure SC_GetGLN(FldNo: Integer): Code[13]
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
    begin
        if FldNo <> 0 then begin
            FldRef := RecRef.Field(FldNo);
            exit(Format(FldRef.Value));
        end;
    end;

    procedure SetSkipSCPDF()
    begin
        SkipSCPDF := true;
    end;

    local procedure getReportInfo(var LanguageCodeX: Code[10]; var ReportNoX: Integer)
    var
        SCReportSetup: Record SCReportSetup;
    begin
        LanguageCodeX := SCReportSetup.GetCode('LANGUAGE', '', '', 'DefaultLanguageCode');
        Evaluate(ReportNoX, SCReportUtil.StrKeep(CurrReport.ObjectId(false), '0123456789'));
    end;
}
