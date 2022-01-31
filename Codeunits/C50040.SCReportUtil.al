Codeunit 50040 SCReportUtil
{

    procedure SetReportInfo(LanguageCodeX: Code[10]; ReportNoX: Integer)
    begin
        ReportNo := ReportNoX;
        LanguageCode := LanguageCodeX;
    end;

    procedure LabelTxt(LabelSpec: text) LabelText: Text
    var
        ReportLabelTranslation: Record ReportLabelTranslation;
        SCReportSetup: Record SCReportSetup;
        DefaultLanguageCode: Code[10];
    begin
        LabelText := ReportLabelTranslation.getTranslation(ReportNo, LabelSpec, LanguageCode);
        if LabelText = '' then begin
            DefaultLanguageCode := SCReportSetup.GetCode('LANGUAGE', '', '', 'DefaultLanguageCode');
            LabelText := ReportLabelTranslation.getTranslation(ReportNo, LabelSpec, DefaultLanguageCode);
        end;
    end;

    procedure FixDate(FIDate: Text[20]; var PostingDate: Date): Boolean
    var
        DateTxt: Text[20];
    begin

        DateTxt := CopyStr(FIDate, 7, 2) + '-' + CopyStr(FIDate, 5, 2) + '-' + CopyStr(FIDate, 1, 4);
        if Evaluate(PostingDate, DateTxt) = true then
            exit(true)
        else
            exit(false);
    end;

    procedure FixDateDDMMYYYY(DateX: Date) DateTxt: Text;
    begin
        DateTxt := FORMAT(DateX, 10, '<Day,2>.<Month,2>.<Year4>');
    end;

    procedure FixDateYYYYMMDD(DateX: Date) DateTxt: Text;
    begin
        DateTxt := FORMAT(DateX, 10, '<Year4>.<Month,2>.<Day,2>');
    end;

    procedure FixDateYYYYMM(DateX: Date) DateTxt: Text;
    begin
        DateTxt := FORMAT(DateX, 10, '<Year4>-<Month,2>');
    end;

    procedure FixAmount(Amount: Decimal; Decimals: Integer; ShowZero: Boolean): Text
    begin

        if (Amount = 0) and (not ShowZero) then begin

            exit('');
        end else begin

            case Decimals of
                0:
                    exit(Format(Round(Amount, 1), 0, '<Sign><Integer Thousand>'));
                1:
                    exit(Format(Round(Amount, 0.1), 0, '<Sign><Integer Thousand><Decimals,2><Precision,1:1>'));
                2:
                    exit(Format(Round(Amount, 0.01), 0, '<Sign><Integer Thousand><Decimals,3><Precision,2:2>'));
                3:
                    exit(Format(Round(Amount, 0.001), 0, '<Sign><Integer Thousand><Decimals,4><Precision,3:3>'));
                4:
                    exit(Format(Round(Amount, 0.0001), 0, '<Sign><Integer Thousand><Decimals,5><Precision,4:4>'));
                else
                    exit(Format(amount));
            end;
        end;

    end;

    procedure TrimValue(InValue: Text): Text
    begin

        InValue := DelChr(InValue, '<>', ' ');
        if CopyStr(InValue, 1, 1) = '"' then begin

            InValue := DelStr(InValue, 1, 1);
            if CopyStr(InValue, StrLen(InValue), 1) = '"' then begin

                InValue := DelStr(InValue, StrLen(InValue), 1);
            end;
        end;
        InValue := DelChr(InValue, '<>', ' ');
        exit(InValue)
    end;

    procedure StrReplace(InText: Text; FromText: Text; ToText: Text): Text
    begin

        while StrPos(InText, FromText) > 0 do
            InText := DelStr(InText, StrPos(InText, FromText)) + ToText + CopyStr(InText, StrPos(InText, FromText) + StrLen(FromText));

        exit(InText);
    end;

    procedure StrKeep(InputString: Text[250]; KeepString: Text[250]): Text[250]
    var
        StrKeep: Text[30];
        Result: Text[20];
    begin

        Result := DelChr(InputString, '=', DelChr(InputString, '=', KeepString));
        exit(Result);
    end;

    procedure LineBreak(): Text
    var
        CR: Char;

    begin
        CR := 10;
        exit(Format(CR));
    end;

    procedure FixLineBreak(InText: Text): Text
    var
        CR: Char;

    begin
        CR := 10;
        exit(StrReplace(InText, '{CRLF}', Format(CR)));
    end;

    procedure FixItemNumber(ItemNo: Code[20]) FixedItemNo: Code[20]
    var
        SCReportSetup: Record SCReportSetup;
        HideItemNoVariant: Boolean;
        CharCount: Integer;
        CharIdx: Integer;
        CharTxt: Text;
        PunctCount: Integer;
        LastPunct: Integer;

    begin
        FixedItemNo := ItemNo;
        CharCount := StrLen(FixedItemNo);
        for CharIdx := 1 to CharCount do begin
            CharTxt := CopyStr(FixedItemNo, CharIdx, 1);
            if CharTxt = '.' then begin
                LastPunct := CharIdx;
                PunctCount += 1;
            end;
        end;
        if (PunctCount > 1) and (LastPunct > 1) then begin
            FixedItemNo := CopyStr(FixedItemNo, 1, LastPunct - 1)
        end;
        /*
        if FixedItemNo <> '' then begin
            HideItemNoVariant := SCReportSetup.GetBoolean('LAYOUT', '', '', 'HideItemNoVariant');
            if HideItemNoVariant then begin
                if StrLen(FixedItemNo) > 1 then
                    if CopyStr(FixedItemNo, StrLen(FixedItemNo) - 1, 1) = '.' then begin
                        FixedItemNo := DelStr(FixedItemNo, StrLen(FixedItemNo) - 1, 2);
                    end else begin
                        if StrLen(FixedItemNo) > 2 then
                            if CopyStr(FixedItemNo, StrLen(FixedItemNo) - 2, 1) = '.' then
                                FixedItemNo := DelStr(FixedItemNo, StrLen(FixedItemNo) - 2, 3);
                    end;
            end;
        end;
        */
    end;

    procedure GetShipmentLineLotSpec(ShipmentNo: Code[20]; LineNo: Integer; var LotSpec: Text; var ExpirySpec: text)
    var
        TrackingSpecification: Record "Tracking Specification" temporary;
        ItemTrackingDocManagement: Codeunit "Item Tracking Doc. Management";

    begin
        LotSpec := '';
        ExpirySpec := '';
        if TrackingSpecification.IsTemporary then begin
            TrackingSpecification.RESET;
            TrackingSpecification.DELETEALL();
            ItemTrackingDocManagement.RetrieveDocumentItemTracking(TrackingSpecification, ShipmentNo, DATABASE::"Sales Shipment Header", 0);
            TrackingSpecification.SETRANGE("Source Ref. No.", LineNo);
            if TrackingSpecification.FINDSET then begin
                repeat
                    if LotSpec <> '' then begin
                        LotSpec += LineBreak();
                        ExpirySpec += LineBreak();
                    end;
                    LotSpec += TrackingSpecification."Lot No.";
                    ExpirySpec += FixDateYYYYMMDD(TrackingSpecification."Expiration Date");
                until TrackingSpecification.NEXT = 0;
            end;
        end;
        ;
    end;

    procedure SalesLineDescription(SalesLine: Record "Sales Line"; HTML: Boolean; ExtraLine: Boolean) Description: Text
    var
        SalesCommentLine: Record "Sales Comment Line";
        ItemReference: Record "Item Reference";
        SalesHeader: Record "Sales Header";
        SCReportSetup: Record SCReportSetup;
        ShowCustomerItemNo: Boolean;

    begin
        Description := SalesLine.Description;
        if SalesLine."Description 2" <> '' then
            Description := Description + LineBreak() + SalesLine."Description 2";
        SalesCommentLine.Reset;
        SalesCommentLine.SetRange("Document Type", SalesLine."Document Type");
        SalesCommentLine.SetRange("No.", SalesLine."Document No.");
        SalesCommentLine.SetRange("Document Line No.", SalesLine."Line No.");
        SalesCommentLine.SetCurrentkey("Document Type", "No.", "Document Line No.", "Line No.");
        if SalesCommentLine.FindSet then begin
            repeat
                Description := Description + LineBreak() + SalesCommentLine.Comment;
            until SalesCommentLine.Next = 0;
        end;
        if SalesLine.Type = SalesLine.Type::Item then begin
            ShowCustomerItemNo := SCReportSetup.GetBoolean('LAYOUT', '', '', 'ShowCustomerItemNo');
            if ShowCustomerItemNo then begin
                if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
                    ItemReference.Reset;
                    ItemReference.SetRange(ItemReference."Item No.", SalesLine."No.");
                    ItemReference.SetRange("Reference Type", ItemReference."Reference type"::Customer);
                    ItemReference.SetRange("Reference Type No.", SalesHeader."Sell-to Customer No.");
                    ItemReference.SetFilter("Reference No.", '<>%1', '');
                    if ItemReference.FindFirst then
                        Description := Description + LineBreak() + STRSUBSTNO(LabelTxt('LblYourItemNo'), ItemReference."Reference No.");
                end;
            end;
        end;
        if ExtraLine then
            Description += LineBreak();
    end;

    procedure ShipmentLineDescription(SalesShipmentLine: Record "Sales Shipment Line"; HTML: Boolean; ExtraLine: Boolean) Description: Text
    var
        SalesCommentLine: Record "Sales Comment Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
        ItemReference: Record "Item Reference";
        SCReportSetup: Record SCReportSetup;
        TrackingSpecification: Record "Tracking Specification" temporary;
        ItemTrackingDocManagement: Codeunit "Item Tracking Doc. Management";
        TrackingLineNo: Integer;
        ShowCustomerItemNo: Boolean;

    begin
        Description := SalesShipmentLine.Description;
        if SalesShipmentLine."Description 2" <> '' then
            Description := Description + LineBreak() + SalesShipmentLine."Description 2";
        SalesCommentLine.Reset;
        SalesCommentLine.SetRange("Document Type", SalesCommentLine."document type"::Shipment);
        SalesCommentLine.SetRange("No.", SalesShipmentLine."Document No.");
        SalesCommentLine.SetRange("Document Line No.", SalesShipmentLine."Line No.");
        SalesCommentLine.SetCurrentkey("Document Type", "No.", "Document Line No.", "Line No.");
        if SalesCommentLine.FindSet then begin
            repeat
                Description := Description + LineBreak() + SalesCommentLine.Comment;
            until SalesCommentLine.Next = 0;
        end;
        if SalesShipmentLine.Type = SalesShipmentLine.Type::Item then begin
            ShowCustomerItemNo := SCReportSetup.GetBoolean('LAYOUT', '', '', 'ShowCustomerItemNo');
            if ShowCustomerItemNo then begin
                if SalesShipmentHeader.Get(SalesShipmentLine."Document No.") then begin
                    ItemReference.Reset;
                    ItemReference.SetRange(ItemReference."Item No.", SalesShipmentLine."No.");
                    ItemReference.SetRange("Reference Type", ItemReference."Reference type"::Customer);
                    ItemReference.SetRange("Reference Type No.", SalesShipmentHeader."Sell-to Customer No.");
                    ItemReference.SetFilter("Reference No.", '<>%1', '');
                    if ItemReference.FindFirst then
                        Description := Description + LineBreak() + STRSUBSTNO(LabelTxt('LblYourItemNo'), ItemReference."Reference No.");
                end;
            end;

            TrackingSpecification.Reset();
            TrackingSpecification.DeleteAll();
            ItemTrackingDocManagement.RetrieveDocumentItemTracking(TrackingSpecification, SalesShipmentLine."Document No.", DATABASE::"Sales Shipment Header", 0);
            TrackingSpecification.SetRange("Source Ref. No.", SalesShipmentLine."Line No.");
            if TrackingSpecification.FindSet() then begin
                repeat

                    Description := Description + LineBreak() + STRSUBSTNO(LabelTxt('LblLOTNo'), TrackingSpecification."Lot No.", TrackingSpecification."Quantity (Base)", SalesShipmentLine."Unit of Measure");
                until TrackingSpecification.Next() = 0;
            end;

        end;
        if ExtraLine then
            Description += LineBreak();
    end;

    procedure InvoiceLineDescription(SalesInvoiceLine: Record "Sales Invoice Line"; HTML: Boolean; ExtraLine: Boolean) Description: Text
    var
        Item: Record Item;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCommentLine: Record "Sales Comment Line";
        ItemReference: Record "Item Reference";
        ItemSpec: text;
        SCReportSetup: Record SCReportSetup;
        ShowCustomerItemNo: Boolean;

    begin
        Description := SalesInvoiceLine.Description;
        if SalesInvoiceLine."Description 2" <> '' then
            Description := Description + LineBreak() + SalesInvoiceLine."Description 2";
        if Item.Get(SalesInvoiceLine."No.") then begin
            ItemSpec := '';
            if Item.GTIN <> '' then
                ItemSpec := STRSUBSTNO(LabelTxt('LblYourEAN'), Item.GTIN);
            if ItemSpec <> '' then
                Description := Description + LineBreak() + ItemSpec;

        end;
        SalesCommentLine.Reset();
        SalesCommentLine.SetRange("Document Type", SalesCommentLine."Document Type"::"Posted Invoice");
        SalesCommentLine.SetRange("No.", SalesInvoiceLine."Document No.");
        SalesCommentLine.SetRange("Document Line No.", SalesInvoiceLine."Line No.");
        SalesCommentLine.SetCurrentKey("Document Type", "No.", "Document Line No.", "Line No.");
        if SalesCommentLine.FindSet() then begin
            repeat
                Description := Description + LineBreak() + SalesCommentLine.Comment;
            until SalesCommentLine.NEXT = 0;
        end;
        if SalesInvoiceLine.Type = SalesInvoiceLine.Type::Item then begin
            ShowCustomerItemNo := SCReportSetup.GetBoolean('LAYOUT', '', '', 'ShowCustomerItemNo');
            if ShowCustomerItemNo then begin
                if SalesInvoiceHeader.Get(SalesInvoiceLine."Document No.") then begin
                    ItemReference.Reset();
                    ItemReference.SetRange(ItemReference."Item No.", SalesInvoiceLine."No.");
                    ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::Customer);
                    ItemReference.SetRange("Reference Type No.", SalesInvoiceHeader."Sell-to Customer No.");
                    ItemReference.SetFilter("Reference No.", '<>%1', '');
                    if ItemReference.FindSet() then
                        Description := Description + LineBreak() + STRSUBSTNO(LabelTxt('LblYourItemNo'), ItemReference."Reference No.");

                end;
            end;
        end;
        if ExtraLine then
            Description += LineBreak();
    end;

    procedure CrMemoLineDescription(SalesCrMemoLine: Record "Sales Cr.Memo Line"; HTML: Boolean; ExtraLine: Boolean) Description: Text
    var
        SalesCommentLine: Record "Sales Comment Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ItemReference: Record "Item Reference";
        SCReportSetup: Record SCReportSetup;
        ShowCustomerItemNo: Boolean;

    begin
        Description := SalesCrMemoLine.Description;
        if SalesCrMemoLine."Description 2" <> '' then
            Description := Description + LineBreak() + SalesCrMemoLine."Description 2";
        SalesCommentLine.Reset;
        SalesCommentLine.SetRange("Document Type", SalesCommentLine."document type"::"Posted Credit Memo");
        SalesCommentLine.SetRange("No.", SalesCrMemoLine."Document No.");
        SalesCommentLine.SetRange("Document Line No.", SalesCrMemoLine."Line No.");
        SalesCommentLine.SetCurrentkey("Document Type", "No.", "Document Line No.", "Line No.");
        if SalesCommentLine.FindSet then begin
            repeat
                Description := Description + LineBreak() + SalesCommentLine.Comment;
            until SalesCommentLine.Next = 0;
        end;
        if SalesCrMemoLine.Type = SalesCrMemoLine.Type::Item then begin
            ShowCustomerItemNo := SCReportSetup.GetBoolean('LAYOUT', '', '', 'ShowCustomerItemNo');
            if ShowCustomerItemNo then begin
                if SalesCrMemoHeader.Get(SalesCrMemoLine."Document No.") then begin
                    ItemReference.Reset;
                    ItemReference.SetRange(ItemReference."Item No.", SalesCrMemoLine."No.");
                    ItemReference.SetRange("Reference Type", ItemReference."Reference type"::Customer);
                    ItemReference.SetRange("Reference Type No.", SalesCrMemoHeader."Sell-to Customer No.");
                    ItemReference.SetFilter("Reference No.", '<>%1', '');
                    if ItemReference.FindFirst then
                        Description := Description + LineBreak() + STRSUBSTNO(LabelTxt('LblYourItemNo'), ItemReference."Reference No.");
                end;
            end;
        end;
        if ExtraLine then
            Description += LineBreak();
    end;

    procedure PurchaseLineDescription(PurchaseLine: Record "Purchase Line"; HTML: Boolean; ExtraLine: Boolean) Description: Text
    var
        PurchCommentLine: Record "Purch. Comment Line";
        CustItem: Text;
    begin
        Description := PurchaseLine.Description;
        //IF PurchaseLine."Description 2" <> '' THEN
        //  Description := Description + LineBreak(HTML) + PurchaseLine."Description 2";
        PurchCommentLine.Reset;
        PurchCommentLine.SetRange("Document Type", PurchCommentLine."document type"::Order);
        PurchCommentLine.SetRange("No.", PurchaseLine."Document No.");
        PurchCommentLine.SetRange("Document Line No.", PurchaseLine."Line No.");
        PurchCommentLine.SetCurrentkey("Document Type", "No.", "Document Line No.", "Line No.");
        if PurchCommentLine.FindSet then begin
            repeat
                Description := Description + LineBreak() + PurchCommentLine.Comment;
            until PurchCommentLine.Next = 0;
        end;
        if ExtraLine then
            Description += LineBreak();
    end;

    procedure PurchaseReceiptLineDescription(PurchaseRcptLine: Record "Purch. Rcpt. Line"; HTML: Boolean; ExtraLine: Boolean) Description: Text
    var
        PurchCommentLine: Record "Purch. Comment Line";
        CustItem: Text;
    begin
        Description := PurchaseRcptLine.Description;
        //IF PurchaseLine."Description 2" <> '' THEN
        //  Description := Description + LineBreak(HTML) + PurchaseLine."Description 2";
        PurchCommentLine.Reset;
        PurchCommentLine.SetRange("Document Type", PurchCommentLine."document type"::"Posted Invoice");
        PurchCommentLine.SetRange("No.", PurchaseRcptLine."Document No.");
        PurchCommentLine.SetRange("Document Line No.", PurchaseRcptLine."Line No.");
        PurchCommentLine.SetCurrentkey("Document Type", "No.", "Document Line No.", "Line No.");
        if PurchCommentLine.FindSet then begin
            repeat
                Description := Description + LineBreak() + PurchCommentLine.Comment;
            until PurchCommentLine.Next = 0;
        end;
        if ExtraLine then
            Description += LineBreak();
    end;

    procedure PurchaseInvoiceLineDescription(PurchaseInvoiceLine: Record "Purch. inv. Line"; HTML: Boolean; ExtraLine: Boolean) Description: Text
    var
        PurchCommentLine: Record "Purch. Comment Line";
        CustItem: Text;
    begin
        Description := PurchaseInvoiceLine.Description;
        //IF PurchaseLine."Description 2" <> '' THEN
        //  Description := Description + LineBreak(HTML) + PurchaseLine."Description 2";
        PurchCommentLine.Reset;
        PurchCommentLine.SetRange("Document Type", PurchCommentLine."document type"::"Posted Invoice");
        PurchCommentLine.SetRange("No.", PurchaseInvoiceLine."Document No.");
        PurchCommentLine.SetRange("Document Line No.", PurchaseInvoiceLine."Line No.");
        PurchCommentLine.SetCurrentkey("Document Type", "No.", "Document Line No.", "Line No.");
        if PurchCommentLine.FindSet then begin
            repeat
                Description := Description + LineBreak() + PurchCommentLine.Comment;
            until PurchCommentLine.Next = 0;
        end;
        if ExtraLine then
            Description += LineBreak();
    end;

    procedure GetCompanyDetails(var Name: Text; var Address: Text; var PostCodeZip: Text; var CountryName: Text; var Phone: Text; var Email: Text; var Web: Text; var CVR: Text)
    var
        CompanyInformation: Record "Company Information";
        CountryRegion: Record "Country/Region";
    begin

        Name := '';
        Address := '';
        PostCodeZip := '';
        CountryName := '';
        Phone := '';
        Email := '';
        Web := '';
        CVR := '';
        if CompanyInformation.Get() then begin

            Name := CompanyInformation.Name;
            Address := CompanyInformation.Address;
            PostCodeZip := CompanyInformation."Post Code" + ' ' + CompanyInformation.City;
            if CountryRegion.Get(CompanyInformation."Country/Region Code") then
                CountryName := CountryRegion.Name;
            Phone := CompanyInformation."Phone No.";
            Email := CompanyInformation."E-Mail";
            Web := CompanyInformation."Home Page";
            CVR := CompanyInformation."VAT Registration No.";
        end;
    end;




    procedure GetCompanyAddressInfo(var CompanyName: Text; var CompanyInfoX: Text; NameInInfo: Boolean)
    var
        CompanyInformation: Record "Company Information";
        CountryRegion: Record "Country/Region";

    begin

        CompanyName := '';
        CompanyInfoX := '';
        if CompanyInformation.Get() then begin

            if NameInInfo then
                CompanyInfoX := CompanyInformation.Name + '{CRLF}'
            else
                CompanyName := CompanyInformation.Name;
            CompanyInfoX += CompanyInformation.Address + '{CRLF}' +
                                'DK-' + CompanyInformation."Post Code" + ' ' + CompanyInformation.City;
            if CompanyInformation."Country/Region Code" <> '' then
                if CountryRegion.Get(CompanyInformation."Country/Region Code") then
                    CompanyInfoX += ', ' + CountryRegion.Name;
            CompanyInfoX += '{CRLF}';
            if CompanyInformation."Home Page" <> '' then
                CompanyInfoX += CompanyInformation."Home Page" + ', ';
            if CompanyInformation."Phone No." <> '' then
                CompanyInfoX += 'Telefon' + ': ' + CompanyInformation."Phone No.";
            CompanyInfoX += '{CRLF}';
            if CompanyInformation."VAT Registration No." <> '' then
                CompanyInfoX += 'CVR-nr' + ': ' + CompanyInformation."VAT Registration No.";
            CompanyInfoX += '{CRLF}';
            if CompanyInformation."Home Page" <> '' then
                CompanyInfoX += '{CRLF}' + CompanyInformation."Home Page";
            if CompanyInformation."E-Mail" <> '' then
                CompanyInfoX += '{CRLF}' + CompanyInformation."E-Mail";
        end;
    end;

    procedure GetCompanyBankInfo(var BankName: Text; var BankAccount: Text; var IBAN: Text; var SWifT: Text)
    var
        CompanyInformation: Record "Company Information";

    begin
        if CompanyInformation.get() then begin
            BankName := CompanyInformation."Bank Name";
            BankAccount := CompanyInformation."Bank Branch No." + CompanyInformation."Bank Account No.";
            IBAN := CompanyInformation.IBAN;
            SWifT := CompanyInformation."SWifT Code";
        end;
    end;

    procedure GetCompanyBankInfoExt(CountryCode: Code[10]; Currency: Code[10]; var BankName: Text; var BankAccount: Text; var IBAN: Text; var SWifT: Text)
    var
        CompanyInformation: Record "Company Information";

    begin

        if CompanyInformation.get() then begin

            BankName := CompanyInformation."Bank Name";
            BankAccount := CompanyInformation."Bank Branch No." + CompanyInformation."Bank Account No.";
            IBAN := CompanyInformation.IBAN;
            SWifT := CompanyInformation."SWifT Code";
        end;
    end;


    procedure SetSalesOurRef(SalesHeader: Record "Sales Header") OurRef: Text
    begin
        OurRef := SalesHeader."No.";
    end;

    procedure SetPurchaseOurRef(PurchaseHeader: Record "Purchase Header") OurRef: Text
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";

    begin
        OurRef := PurchaseHeader."Purchaser Code";
        if SalespersonPurchaser.get(PurchaseHeader."Purchaser Code") then
            if SalespersonPurchaser.Name <> '' then
                OurRef := SalespersonPurchaser.Name;
    end;

    procedure SetRcptPurchaseOurRef(PurchRcptHeader: Record "Purch. Rcpt. Header") OurRef: Text
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";

    begin
        OurRef := PurchRcptHeader."Purchaser Code";
        if SalespersonPurchaser.get(PurchRcptHeader."Purchaser Code") then
            if SalespersonPurchaser.Name <> '' then
                OurRef := SalespersonPurchaser.Name;
    end;

    procedure SetInvPurchaseOurRef(PurchInvHeader: Record "Purch. Inv. Header") OurRef: Text
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";

    begin
        OurRef := PurchInvHeader."Purchaser Code";
        if SalespersonPurchaser.get(PurchInvHeader."Purchaser Code") then
            if SalespersonPurchaser.Name <> '' then
                OurRef := SalespersonPurchaser.Name;
    end;

    procedure SetShipmentOurRef(SalesShipmentHeader: Record "Sales Shipment Header") OurRef: Text
    begin
        OurRef := SalesShipmentHeader."Order No.";
        if OurRef = '' then
            OurRef := SalesShipmentHeader."No.";
    end;

    procedure SetInvoiceOurRef(SalesInvoiceHeader: Record "Sales Invoice Header") OurRef: Text
    begin
        OurRef := SalesInvoiceHeader."Order No.";
        if OurRef = '' then
            OurRef := SalesInvoiceHeader."No.";
    end;

    procedure SetCreditMemoOurRef(SalesCrMemoHeader: Record "Sales Cr.Memo Header") OurRef: Text
    begin
        OurRef := SalesCrMemoHeader."Return Order No.";
        if OurRef = '' then
            OurRef := SalesCrMemoHeader."No.";
    end;

    procedure SetCurrency(CurrencyCode: Code[10]): Code[10]
    var
        GeneralLedgerSetup: Record "General Ledger Setup";

    begin

        if CurrencyCode <> '' then begin

            exit(CurrencyCode)
        end else begin

            if GeneralLedgerSetup.GET then
                exit(GeneralLedgerSetup."LCY Code");
        end;
    end;


    procedure SalesSetVATPctSpec(SalesHeader: Record "Sales Header"; AddPctChar: Boolean; var ValueFound: Boolean; var EUCountry: Boolean) VATPct: Text
    var
        SalesLine: Record "Sales Line";
        VATPostingSetup: Record "VAT Posting Setup";
        CountryRegion: Record "Country/Region";
        VATPctNum: Decimal;

    begin
        if CountryRegion.get(SalesHeader."Bill-to Country/Region Code") then
            if CountryRegion."EU Country/Region Code" <> '' then
                EUCountry := true;

        VATPctNum := 0;
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindFirst() then
            if VATPostingSetup.GET(SalesLine."VAT Bus. Posting Group", SalesLine."VAT Prod. Posting Group") then
                if VATPostingSetup."Reverse Chrg. VAT Acc." = '' then
                    VATPctNum := VATPostingSetup."VAT %";
        VATPct := FixAmount(VATPctNum, 0, true);
        if AddPctChar then
            VATPct += '%';
        if VATPctNum <> 0 then
            ValueFound := true;
    end;

    procedure InvoiceSetVATPctSpec(SalesInvoiceHeader: Record "Sales Invoice Header"; AddPctChar: Boolean; var ValueFound: Boolean; var EUCountry: Boolean) VATPct: Text
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        VATPostingSetup: Record "VAT Posting Setup";
        CountryRegion: Record "Country/Region";
        VATPctNum: Decimal;

    begin
        if CountryRegion.get(SalesInvoiceHeader."Bill-to Country/Region Code") then
            if CountryRegion."EU Country/Region Code" <> '' then
                EUCountry := true;

        VATPctNum := 0;
        SalesInvoiceLine.Reset();
        SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
        SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type::Item);
        if SalesInvoiceLine.FindFirst() then begin
            if VATPostingSetup.GET(SalesInvoiceLine."VAT Bus. Posting Group", SalesInvoiceLine."VAT Prod. Posting Group") then begin
                if VATPostingSetup."Reverse Chrg. VAT Acc." = '' then begin
                    VATPctNum := VATPostingSetup."VAT %";
                end;
            end;
        end;
        VATPct := FixAmount(VATPctNum, 0, true);
        if AddPctChar then
            VATPct += '%';
        if VATPctNum <> 0 then
            ValueFound := true;
    end;

    procedure CrMemoSetVATPctSpec(SalesCrMemoHeader: Record "Sales Cr.Memo Header"; AddPctChar: Boolean; var ValueFound: Boolean; var EUCountry: Boolean) VATPct: Text
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        VATPostingSetup: Record "VAT Posting Setup";
        CountryRegion: Record "Country/Region";
        VATPctNum: Decimal;

    begin
        if CountryRegion.get(SalesCrMemoHeader."Bill-to Country/Region Code") then
            if CountryRegion."EU Country/Region Code" <> '' then
                EUCountry := true;

        VATPctNum := 0;
        SalesCrMemoLine.Reset();
        SalesCrMemoLine.SetRange("Document No.", SalesCrMemoHeader."No.");
        SalesCrMemoLine.SetRange(Type, SalesCrMemoLine.Type::Item);
        if SalesCrMemoLine.FindFirst() then
            if VATPostingSetup.GET(SalesCrMemoLine."VAT Bus. Posting Group", SalesCrMemoLine."VAT Prod. Posting Group") then
                if VATPostingSetup."Reverse Chrg. VAT Acc." = '' then
                    VATPctNum := VATPostingSetup."VAT %";
        VATPct := FixAmount(VATPctNum, 0, true);
        if AddPctChar then
            VATPct += '%';
        if VATPctNum <> 0 then
            ValueFound := true;

    end;

    procedure PurchaseSetVATPctSpec(PurchaseHeader: Record "Purchase Header"; AddPctChar: Boolean; var ValueFound: Boolean) VATPct: Text
    var
        PurchaseLine: Record "Purchase Line";
        VATPostingSetup: Record "VAT Posting Setup";
        VATPctNum: Decimal;

    begin

        VATPctNum := 0;
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        if PurchaseLine.FindFirst() then
            if VATPostingSetup.GET(PurchaseLine."VAT Bus. Posting Group", PurchaseLine."VAT Prod. Posting Group") then
                if VATPostingSetup."Reverse Chrg. VAT Acc." = '' then
                    VATPctNum := VATPostingSetup."VAT %";
        VATPct := FixAmount(VATPctNum, 0, true);
        if AddPctChar then
            VATPct += '%';
        if VATPctNum <> 0 then
            ValueFound := true;

    end;

    procedure PurchaseRcptSetVATPctSpec(PurchRcptHeader: Record "Purch. Rcpt. Header"; AddPctChar: Boolean; var ValueFound: Boolean) VATPct: Text
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        VATPostingSetup: Record "VAT Posting Setup";
        VATPctNum: Decimal;

    begin

        VATPctNum := 0;
        PurchRcptLine.Reset();
        PurchRcptLine.SetRange("Document No.", PurchRcptHeader."No.");
        PurchRcptLine.SetRange(Type, PurchRcptLine.Type::Item);
        if PurchRcptLine.FindFirst() then
            if VATPostingSetup.GET(PurchRcptLine."VAT Bus. Posting Group", PurchRcptLine."VAT Prod. Posting Group") then
                if VATPostingSetup."Reverse Chrg. VAT Acc." = '' then
                    VATPctNum := VATPostingSetup."VAT %";
        VATPct := FixAmount(VATPctNum, 0, true);
        if AddPctChar then
            VATPct += '%';
        if VATPctNum <> 0 then
            ValueFound := true;

    end;

    procedure PurchaseInvSetVATPctSpec(PurchInvHeader: Record "Purch. Inv. Header"; AddPctChar: Boolean; var ValueFound: Boolean) VATPct: Text
    var
        PurchInvLine: Record "Purch. Inv. Line";
        VATPostingSetup: Record "VAT Posting Setup";
        VATPctNum: Decimal;

    begin

        VATPctNum := 0;
        PurchInvLine.Reset();
        PurchInvLine.SetRange("Document No.", PurchInvHeader."No.");
        PurchInvLine.SetRange(Type, PurchInvLine.Type::Item);
        if PurchInvLine.FindFirst() then
            if VATPostingSetup.GET(PurchInvLine."VAT Bus. Posting Group", PurchInvLine."VAT Prod. Posting Group") then
                if VATPostingSetup."Reverse Chrg. VAT Acc." = '' then
                    VATPctNum := VATPostingSetup."VAT %";
        VATPct := FixAmount(VATPctNum, 0, true);
        if AddPctChar then
            VATPct += '%';
        if VATPctNum <> 0 then
            ValueFound := true;

    end;


    procedure TextCodeDescription(TextCode: Code[20]; LanguageCode: Code[10]; HTML: Boolean; ForceLineBreak: Boolean; Extraline: Boolean) Description: Text
    var
        ExtendedTextHeader: Record "Extended Text Header";
        ExtendedTextLine: Record "Extended Text Line";

    begin
        if TextCode <> '' then begin
            ExtendedTextHeader.Reset();
            ExtendedTextHeader.SetRange("Table Name", ExtendedTextHeader."Table Name"::"Standard Text");
            ExtendedTextHeader.SetRange("No.", TextCode);
            ExtendedTextHeader.SetRange("Language Code", LanguageCode);
            if ExtendedTextHeader.FindSet() then begin
                ExtendedTextLine.Reset();
                ExtendedTextLine.SetRange("Table Name", ExtendedTextHeader."Table Name");
                ExtendedTextLine.SetRange("No.", ExtendedTextHeader."No.");
                ExtendedTextLine.SetRange("Language Code", ExtendedTextHeader."Language Code");
                ExtendedTextLine.SetRange("Text No.", ExtendedTextHeader."Text No.");
                if ExtendedTextLine.FINDSET then begin
                    repeat
                        Description += ExtendedTextLine.Text;
                        if ForceLineBreak then
                            Description += LineBreak()
                        else
                            Description := TrimValue(Description) + ' ';
                    until ExtendedTextLine.NEXT = 0;
                End;
            End else begin
                ExtendedTextHeader.Reset();
                ExtendedTextHeader.SetRange("Table Name", ExtendedTextHeader."Table Name"::"Standard Text");
                ExtendedTextHeader.SetRange("No.", TextCode);
                ExtendedTextHeader.SetRange("All Language Codes", TRUE);
                if ExtendedTextHeader.FindSet() then begin

                    ExtendedTextLine.Reset();
                    ExtendedTextLine.SetRange("Table Name", ExtendedTextHeader."Table Name");
                    ExtendedTextLine.SetRange("No.", ExtendedTextHeader."No.");
                    ExtendedTextLine.SetRange("Language Code", ExtendedTextHeader."Language Code");
                    ExtendedTextLine.SetRange("Text No.", ExtendedTextHeader."Text No.");
                    if ExtendedTextLine.FindSet() then begin
                        repeat
                            Description += ExtendedTextLine.Text;
                            if ForceLineBreak then
                                Description += LineBreak()
                            else
                                Description := TrimValue(Description) + ' ';
                        until ExtendedTextLine.NEXT = 0;
                    End;
                End;
            End;
            Description := TrimValue(StrReplace(Description, '\n', LineBreak()));
            if Extraline then
                Description += LineBreak();
        End;
    end;


    procedure PurchaseRequisitionForm()
    var
        PurchaseHeader: Record "Purchase Header";
        SCFetchPurchase: Report SCFetchPurchase;
        TmpPurchaseHeaderSelected: Record "Purchase Header" temporary;
        PurchaseRequisitionForm: report PurchaseRequisitionForm;
        DialogX: Dialog;
        OStream: OutStream;
        Istream: InStream;
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        FileName: Text;
        JID: Text;
        FileCount: Integer;
        c: Integer;

    begin
        Clear(SCFetchPurchase);
        SCFetchPurchase.RunModal();
        SCFetchPurchase.GetPurchaseHeaderSelected(TmpPurchaseHeaderSelected);
        TmpPurchaseHeaderSelected.reset;
        if TmpPurchaseHeaderSelected.FindSet() then begin
            if Confirm('Udskriv %1 købsordrer?', true, TmpPurchaseHeaderSelected.Count) then begin
                DialogX.Open('Købsordre: ######1#\Nummer: ##2#');
                if CreatePDFMergefolder(JID) then begin
                    repeat
                        PurchaseHeader.reset;
                        PurchaseHeader.SetRange("No.", TmpPurchaseHeaderSelected."No.");
                        if PurchaseHeader.FindFirst() then begin
                            c += 1;
                            DialogX.Update(1, PurchaseHeader."No.");
                            DialogX.Update(2, C);
                            Clear(PurchaseRequisitionForm);
                            RecRef.GetTable(PurchaseHeader);
                            Clear(TempBlob);
                            TempBlob.CreateOutStream(OStream);
                            PurchaseRequisitionForm.SaveAs('', ReportFormat::Pdf, OStream, RecRef);
                            DialogX.Update(1, PurchaseHeader."No.");
                            DialogX.Update(2, C);
                            TempBlob.CreateInStream(Istream);
                            if AddPDFDocument(JID, Istream, PurchaseHeader."No.") then
                                FileCount += 1;
                        end;
                    until TmpPurchaseHeaderSelected.Next() = 0;
                    if FileCount > 0 then
                        MergePDFDocument(JID);
                end;
                DialogX.Close();
            end;
        end;
    end;


    local procedure CreatePDFMergefolder(var JID: Text): Boolean
    var
        url: Text;
        JsonResponse: Text;
        JToken: JsonToken;

    begin
        JID := '';
        url := 'http://svc.schost.dk:8585/systemconnect/webapi/pdf/processor/api/mergejob/create';
        if HttpGet(url, JsonResponse) then begin
            if IsResponseSucces(JsonResponse) then begin
                if JToken.ReadFrom(jsonresponse) then begin
                    JID := GetJSonTokenTxt(JToken, 'jid');
                end;
            end;
        end;
        if JID <> '' then
            exit(true);
    end;

    local procedure AddPDFDocument(JID: Text; IStream: InStream; No: Code[20]): Boolean
    var
        Base64Convert: Codeunit "Base64 Convert";
        PDFBase64Txt: Text;
        JObject: JsonObject;
        Payload: Text;
        url: Text;
        JsonResponse: Text;

    begin
        PDFBase64Txt := Base64Convert.ToBase64(IStream);
        if PDFBase64Txt <> '' then begin
            Payload := '';
            Clear(JObject);
            JObject.Add('filename', StrSubstNo('%1.pdf', No));
            JObject.Add('content', PDFBase64Txt);
            JObject.WriteTo(Payload);
            url := 'http://svc.schost.dk:8585/systemconnect/webapi/pdf/processor/api/mergejob/addfile?jid=' + JID;
            if HttpPost(url, Payload, JsonResponse) then begin
                if IsResponseSucces(JsonResponse) then
                    exit(true);
            end;
        end;
    end;

    local procedure MergePDFDocument(JID: Text): Boolean
    var
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        PDFBase64Txt: Text;
        JToken: JsonToken;
        OStream: OutStream;
        IStream: InStream;
        Payload: Text;
        url: Text;
        JsonResponse: Text;
        ContentTxt: Text;
        FileName: Text;

    begin
        url := 'http://svc.schost.dk:8585/systemconnect/webapi/pdf/processor/api/mergejob/merge?jid=' + JID;
        if HttpGet(url, JsonResponse) then begin
            if IsResponseSucces(JsonResponse) then begin
                if JToken.ReadFrom(jsonresponse) then begin
                    ContentTxt := GetJSonTokenTxt(JToken, 'content');
                    TempBlob.CreateOutStream(OStream);
                    Base64Convert.FromBase64(ContentTxt, OStream);
                    TempBlob.CreateInStream(IStream);
                    Filename := 'PurchaseOrders.pdf';
                    DownloadFromStream(IStream, 'Download PDF', '', 'PDF file (*.pdf)', FileName);
                end;
            end;
        end
    end;


    local procedure HttpPost(url: Text; payload: Text; var jsonresponse: Text): Boolean;
    var
        client: HttpClient;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        contentHeaders: HttpHeaders;
        content: HttpContent;
    begin
        content.WriteFrom(payload);
        content.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');
        request.Content := content;
        request.SetRequestUri(url);
        request.Method := 'POST';
        client.DefaultRequestHeaders().Add('Authorization', 'Basic anY6SlYxMjM0anYh');
        client.Send(request, response);
        jsonresponse := '';
        if response.Content().ReadAs(jsonresponse) then
            exit(true);
    end;

    local procedure HttpGet(url: Text; var jsonresponse: Text): Boolean;
    var
        client: HttpClient;
        response: HttpResponseMessage;
    begin
        client.DefaultRequestHeaders().Add('Authorization', 'Basic anY6SlYxMjM0anYh');
        client.Get(url, response);
        jsonresponse := '';
        if response.Content().ReadAs(jsonresponse) then
            exit(true);
    end;

    local procedure IsResponseSucces(jsonresponse: Text): Boolean
    var
        JToken: JsonToken;
    begin
        if JToken.ReadFrom(jsonresponse) then begin
            JToken.SelectToken('success', JToken);
            if JToken.AsValue().AsText() = 'true' then
                exit(true);
        end;
    end;

    local procedure GetJSonTokenTxt(JToken: JsonToken; TokenKey: text) JTokenTxt: Text
    begin
        JToken.SelectToken(TokenKey, JToken);
        if JToken.IsValue() then
            if not JToken.AsValue().IsNull then
                JTokenTxt := JToken.AsValue().AsText();
    end;


    var
        ReportNo: Integer;
        LanguageCode: Code[10];

}

