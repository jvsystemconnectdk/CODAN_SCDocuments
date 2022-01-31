Report 50040 PurchaseRequisition
{
    DefaultLayout = Word;
    Caption = 'Purchase Requisition';
    PreviewMode = PrintLayout;
    WordMergeDataItem = Header;

    dataset
    {
        dataitem(Header; "Purchase Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Purchase Order';
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
            column(InvoiceAddress1; SupplierAddr[1])
            {
            }
            column(InvoiceAddress2; SupplierAddr[2])
            {
            }
            column(InvoiceAddress3; SupplierAddr[3])
            {
            }
            column(InvoiceAddress4; SupplierAddr[4])
            {
            }
            column(InvoiceAddress5; SupplierAddr[5])
            {
            }
            column(InvoiceAddress6; SupplierAddr[6])
            {
            }
            column(InvoiceAddress7; SupplierAddr[7])
            {
            }
            column(InvoiceAddress8; SupplierAddr[8])
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
            column(YourReference; "Your Reference")
            {
            }
            column(YourOrder; Header."Vendor Order No.")
            {
            }
            column(OurRef; OurRef)
            {
            }
            column(PurchaserEmail; PurchaserEmail)
            {
            }
            column(PurchaserPhone; PurchaserPhone)
            {
            }
            column(ShipmentMethodDescription; ShipmentMethod.Description)
            {
            }
            column(PaymentTermsDescription; PaymentTerms.Description)
            {
            }
            column(AccountNo; "Buy-from Vendor No.")
            {
            }
            column(PaytoVendorNo; "Pay-to Vendor No.")
            {
            }
            column(DocumentDate; SCReportUtil.FixDateDDMMYYYY("Order Date"))
            {
            }
            column(DueDate; SCReportUtil.FixDateDDMMYYYY("Due Date"))
            {
            }
            column(ReqReceiptDate; SCReportUtil.FixDateDDMMYYYY("Requested Receipt Date"))
            {
            }
            column(DocumentNo; "No.")
            {
            }
            column(OrderNo; "No.")
            {
            }
            column(Currency; CurrencyCode)
            {
            }
            column(VATPct; VATPct)
            {
            }
            column(DocumentPostLineTxt; DocumentPostLineTxt)
            {
            }
            column(SCSupplyEmail; SCSupplyEmail)
            {
            }
            dataitem(Line; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = Header;
                DataItemTableView = sorting("Document No.", "Line No.");
                UseTemporary = true;
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
                column(VendItemNo; VendItemNoX)
                {
                }
                column(Requested_Receipt_Date_Line; Format("Requested Receipt Date", 0, '<Day,2>-<Month,2>-<Year4>'))
                {
                }
                column(VendorItemNo_Line; Line."Vendor Item No.")
                {
                }

                trigger OnAfterGetRecord()
                var
                    Item: Record Item;
                    UnitPrice: Decimal;
                begin
                    if Type = Type::"G/L Account" then
                        "No." := '';

                    if "Line Discount %" = 0 then
                        LineDiscountPctText := ''
                    else
                        LineDiscountPctText := StrSubstNo('%1%', -ROUND("Line Discount %", 0.1));

                    ItemNumberOrg := "No.";
                    ItemNumber := SCReportUtil.FixItemNumber("No.");

                    TransHeaderAmount += PrevLineAmount;
                    PrevLineAmount := "Line Amount";
                    TotalSubTotal += "Line Amount";
                    TotalInvDiscAmount -= "Inv. Discount Amount";
                    TotalAmount += Amount;
                    TotalAmountVAT += "Amount Including VAT" - Amount;
                    TotalAmountInclVAT += "Amount Including VAT";
                    TotalPaymentDiscOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");

                    QtyTxt := SCUtil.FixAmount(Quantity, 0, false);
                    PriceTxt := SCUtil.FixAmount(Line."Unit Cost", 2, false);
                    DiscTxt := SCUtil.FixAmount("Line Discount %", 2, false);
                    AmountTxt := SCUtil.FixAmount(Amount, 2, false);
                    DescriptionTxt := SCUtil.PurchaseLineDescription(Line, false, false);

                    UnitCode := Line."Unit of Measure";
                    if UnitCode = '' then
                        UnitCode := line."Unit of Measure Code";
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Line No.", 0, "Line No.");
                    //CurrReport.CreateTotals("Line Amount", Amount, "Amount Including VAT", "Inv. Discount Amount");
                    TransHeaderAmount := 0;
                    PrevLineAmount := 0;
                end;
            }
            dataitem(VATAmountLine; "VAT Amount Line")
            {
                DataItemTableView = sorting("VAT Identifier", "VAT Calculation Type", "Tax Group Code", "Use Tax", Positive);
                UseTemporary = true;
                column(InvoiceDiscountAmount_VATAmountLine; "Invoice Discount Amount")
                {
                }
                column(InvoiceDiscountBaseAmount_VATAmountLine; "Inv. Disc. Base Amount")
                {
                }
                column(LineAmount_VatAmountLine; "Line Amount")
                {
                }
                column(VATAmount_VatAmountLine; "VAT Amount")
                {
                }
                column(VATAmountLCY_VATAmountLine; VATAmountLCY)
                {
                }
                column(VATBase_VatAmountLine; "VAT Base")
                {
                }
                column(VATBaseLCY_VATAmountLine; VATBaseLCY)
                {
                }
                column(VATIdentifier_VatAmountLine; "VAT Identifier")
                {
                }
                column(VATPct_VatAmountLine; "VAT %")
                {
                }
                column(NoOfVATIdentifiers; Count)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    VATBaseLCY :=
                      GetBaseLCY(
                        Header."Posting Date", Header."Currency Code",
                        Header."Currency Factor");
                    VATAmountLCY :=
                      GetAmountLCY(
                        Header."Posting Date", Header."Currency Code",
                        Header."Currency Factor");

                    TotalVATBaseLCY += VATBaseLCY;
                    TotalVATAmountLCY += VATAmountLCY;

                end;

                trigger OnPreDataItem()
                begin
                    //CurrReport.CreateTotals(
                    //  "Line Amount", "Inv. Disc. Base Amount",
                    //  "Invoice Discount Amount", "VAT Base", "VAT Amount",
                    //  VATBaseLCY, VATAmountLCY);

                    TotalVATBaseLCY := 0;
                    TotalVATAmountLCY := 0;

                    VATClauseLine.DeleteAll;
                end;
            }
            dataitem(VATClauseLine; "VAT Amount Line")
            {
                UseTemporary = true;
                column(VATIdentifier_VATClauseLine; "VAT Identifier")
                {
                }
                column(Code_VATClauseLine; VATClause.Code)
                {
                }
                column(Description_VATClauseLine; VATClause.Description)
                {
                }
                column(Description2_VATClauseLine; VATClause."Description 2")
                {
                }
                column(VATAmount_VATClauseLine; "VAT Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(NoOfVATClauses; Count)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "VAT Clause Code" = '' then
                        CurrReport.Skip;
                    if not VATClause.Get("VAT Clause Code") then
                        CurrReport.Skip;
                    VATClause.TranslateDescription(Header."Language Code");
                end;
            }
            dataitem(ReportTotalsLine; "Report Totals Buffer")
            {
                DataItemTableView = sorting("Line No.");
                UseTemporary = true;
                column(Description_ReportTotalsLine; Description)
                {
                }
                column(Amount_ReportTotalsLine; Amount)
                {
                }
                column(AmountFormatted_ReportTotalsLine; "Amount Formatted")
                {
                }
                column(FontBold_ReportTotalsLine; "Font Bold")
                {
                }
                column(FontUnderline_ReportTotalsLine; "Font Underline")
                {
                }
            }
            dataitem(Totals; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(TotalNetAmount; TotalAmount)
                {
                }
                column(TotalVATBaseLCY; TotalVATBaseLCY)
                {
                }
                column(TotalAmountIncludingVAT; TotalAmountInclVAT)
                {
                }
                column(TotalVATAmount; TotalAmountVAT)
                {
                }
                column(TotalVATAmountLCY; TotalVATAmountLCY)
                {
                }
                column(TotalInvoiceDiscountAmount; TotalInvDiscAmount)
                {
                }
                column(TotalPaymentDiscountOnVAT; TotalPaymentDiscOnVAT)
                {
                }
                column(TotalVATAmountText; VATAmountLine.VATAmountText)
                {
                }
                column(TotalExcludingVATText; TotalExclVATText)
                {
                }
                column(TotalIncludingVATText; TotalInclVATText)
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

            dataitem(Labels; "Integer")
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

            trigger OnAfterGetRecord()
            var
                PurchPost: Codeunit "Purch.-Post";
                VatValueFound: Boolean;
            begin
                Clear(Line);
                Clear(PurchPost);
                VATAmountLine.DeleteAll;
                Line.DeleteAll;
                PurchPost.GetPurchLines(Header, Line, 0);
                Line.CalcVATAmountLines(0, Header, Line, VATAmountLine);
                Line.UpdateVATOnLines(0, Header, Line, VATAmountLine);

                if not CurrReport.Preview then
                    Codeunit.Run(Codeunit::"Purch.Header-Printed", Header);


                getReportInfo(LanguageCode, ReportNo);
                SCUtil.SetReportInfo(LanguageCode, ReportNo);
                CurrReport.Language := Language.GetLanguageID(LanguageCode);

                SCFileName := StrSubstNo(scutil.LabelTxt('LblFileName'), "No.");

                if Header."Purchaser Code" = '' then begin
                    SalespersonPurchaser.Init;
                    SalesPersonText := '';
                end else begin
                    SalespersonPurchaser.Get("Purchaser Code");
                end;

                SCVendor.Reset;
                SCVendor.Get(Header."Buy-from Vendor No.");
                SCSupplyEmail := SCVendor."E-Mail";

                SCAddress.FormatPurchBuyFromAddress(Header, SupplierAddr, false);
                SCAddress.GetCompanyAddress(CompanyNameTxt, CompanyAddress1, CompanyAddress2, CompanyPostCodeCity, CompanyCountry, CompanyPhone, CompanyURL, CompanyEmail, CompanyCVR);
                SCAddress.FormatCompanyAddress(ShipToAddr);

                CurrencyCode := SCUtil.SetCurrency("Currency Code");
                VATPct := SCUtil.PurchaseSetVATPctSpec(Header, true, VatValueFound);
                if VatValueFound then begin
                    LblxVATAmount := StrSubstNo(scutil.LabelTxt('LblVATAmountText'), VATPct);
                    LblxTotalAmount := StrSubstNo(scutil.LabelTxt('LblTotalAmountInclVAT'), CurrencyCode);
                end else begin
                    LblxVATAmount := scutil.LabelTxt('LblVATFree');
                    LblxTotalAmount := StrSubstNo(scutil.LabelTxt('LblTotalAmount'), CurrencyCode);
                end;

                LblxAmount := StrSubstNo(scutil.LabelTxt('LblAmount'), CurrencyCode);

                if "Payment Terms Code" = '' then
                    PaymentTerms.Init
                else begin
                    if PaymentTerms.Get("Payment Terms Code") then
                        PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                end;

                if "Payment Method Code" = '' then
                    PaymentMethod.Init
                else
                    if PaymentMethod.Get("Payment Method Code") then;

                if "Shipment Method Code" = '' then
                    ShipmentMethod.Init
                else begin
                    if ShipmentMethod.Get("Shipment Method Code") then
                        ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                end;

                OurRef := SCUtil.SetPurchaseOurRef(Header);
                PurchaserEmail := SCSpecial.SetPurchaserEmail(header);
                PurchaserPhone := SCSpecial.SetPurchaserPhone(Header);

                TotalSubTotal := 0;
                TotalInvDiscAmount := 0;
                TotalAmount := 0;
                TotalAmountVAT := 0;
                TotalAmountInclVAT := 0;
                TotalPaymentDiscOnVAT := 0;

                DocumentPostLineTxt := SCUtil.TextCodeDescription('PO', LanguageCode, false, false, false);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
        }

        actions
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
        CountryRegion: Record "Country/Region";
        SCVendor: Record Vendor;
        Language: Codeunit Language;
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        VATClause: Record "VAT Clause";
        SupplierAddr: array[8] of Text[50];
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
        LblxAmount: text;
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        LineDiscountPctText: Text;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalPaymentDiscOnVAT: Decimal;
        TransHeaderAmount: Decimal;
        VATBaseLCY: Decimal;
        VATAmountLCY: Decimal;
        TotalVATBaseLCY: Decimal;
        TotalVATAmountLCY: Decimal;
        PrevLineAmount: Decimal;
        DocumentPostLineTxt: Text;
        OurRef: Text;
        VendItemNoX: Code[20];
        DescriptionTxt: Text;
        QtyTxt: Text;
        PriceTxt: Text;
        DiscTxt: Text;
        AmountTxt: Text;
        CurrencyCode: Code[10];
        VATPct: Text;
        TotalNetWeight: Decimal;
        BankInfo: Text;
        SCSupplyEmail: Text[80];
        CurrencySymbol: Text[10];
        PurchaserEmail: text;
        PurchaserPhone: text;
        LblxEndDiscTxt: Text;
        LblxDiscPctTxt: Text;
        LblxTotalAmount: Text;
        LblxVATAmount: Text;
        SCUtil: Codeunit SCReportUtil;
        SCAddress: Codeunit SCReportAddress;
        SCSpecial: Codeunit SCReportSpecial;
        ReportNo: Integer;
        LanguageCode: Code[10];
        UnitCode: text;
        ItemNumber: Code[20];
        ItemNumberOrg: Code[20];


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

