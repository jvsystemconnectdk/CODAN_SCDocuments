Codeunit 50041 SCReportAddress
{

    trigger OnRun()
    begin
    end;

    var
        CountryRegion: Record "Country/Region";
        Att: label 'Att.';

    local procedure ClearAddressVar(var Addr: array[10] of Text[50])
    var
        Idx: Integer;
    begin
        for Idx := 1 to 8 do begin
            Addr[Idx] := '';
        end;
    end;

    local procedure TestNotDomestic(CountryCode: Code[10]): Boolean
    var
        CompanyInformation: Record "Company Information";
    begin
        if CountryCode <> '' then
            if CompanyInformation.Get then
                if CompanyInformation."Country/Region Code" <> CountryCode then
                    exit(true);
    end;

    procedure FormatCustAddress(Customer: Record Customer; var Addr: array[10] of Text[50]; ShowAttention: Boolean)
    var
        Idx: Integer;
    begin
        ClearAddressVar(Addr);
        Idx := 0;
        if Customer.Name <> '' then begin
            Idx += 1;
            Addr[Idx] := Customer.Name;
        end;
        if Customer."Name 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := Customer."Name 2";
        end;
        if Customer.Address <> '' then begin
            Idx += 1;
            Addr[Idx] := Customer.Address;
        end;
        if Customer."Address 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := Customer."Address 2";
        end;
        if (Customer."Post Code" <> '') or (Customer.City <> '') then begin
            Idx += 1;
            Addr[Idx] := DelChr(Customer."Post Code" + ' ' + Customer.City, '<>', ' ');
        end;
        if TestNotDomestic(Customer."Country/Region Code") then begin
            if CountryRegion.Get(Customer."Country/Region Code") then begin
                Idx += 1;
                //if CountryRegion.SCExternalName <> '' then
                //  Addr[Idx] := CountryRegion.SCExternalName
                //else
                Addr[Idx] := CountryRegion.Name;
            end;
        end;
        if ShowAttention and (Customer.Contact <> '') then begin
            Idx += 2;
            Addr[Idx] := 'Att: ' + Customer.Contact;
        end;
    end;

    procedure FormatSalesBillingAddress(SalesHeader: Record "Sales Header"; var Addr: array[10] of Text[50]; ShowAttention: Boolean)
    var
        Idx: Integer;
    begin
        ClearAddressVar(Addr);
        Idx := 0;
        if SalesHeader."Bill-to Name" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesHeader."Bill-to Name";
        end;
        if SalesHeader."Bill-to Name 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesHeader."Bill-to Name 2";
        end;
        if SalesHeader."Bill-to Address" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesHeader."Bill-to Address";
        end;
        if SalesHeader."Bill-to Address 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesHeader."Bill-to Address 2";
        end;
        if (SalesHeader."Bill-to Post Code" <> '') or (SalesHeader."Bill-to City" <> '') then begin
            Idx += 1;
            Addr[Idx] := DelChr(SalesHeader."Bill-to Post Code" + ' ' + SalesHeader."Bill-to City", '<>', ' ');
        end;
        if TestNotDomestic(SalesHeader."Bill-to Country/Region Code") then begin
            if CountryRegion.Get(SalesHeader."Bill-to Country/Region Code") then begin
                Idx += 1;
                //if CountryRegion.SCExternalName <> '' then
                //  Addr[Idx] := CountryRegion.SCExternalName
                //else
                Addr[Idx] := CountryRegion.Name;
            end;
        end;
        if ShowAttention and (SalesHeader."Bill-to Contact" <> '') then begin
            Idx += 2;
            Addr[Idx] := 'Att: ' + SalesHeader."Bill-to Contact";
        end;
    end;

    procedure FormatShipmentBillingAddress(SalesShipmentHeader: Record "Sales Shipment Header"; var Addr: array[10] of Text[50]; ShowAttention: Boolean)
    var
        Idx: Integer;
    begin
        ClearAddressVar(Addr);
        Idx := 0;
        if SalesShipmentHeader."Bill-to Name" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesShipmentHeader."Bill-to Name";
        end;
        if SalesShipmentHeader."Bill-to Name 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesShipmentHeader."Bill-to Name 2";
        end;
        if SalesShipmentHeader."Bill-to Address" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesShipmentHeader."Bill-to Address";
        end;
        if SalesShipmentHeader."Bill-to Address 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesShipmentHeader."Bill-to Address 2";
        end;
        if (SalesShipmentHeader."Bill-to Post Code" <> '') or (SalesShipmentHeader."Bill-to City" <> '') then begin
            Idx += 1;
            Addr[Idx] := DelChr(SalesShipmentHeader."Bill-to Post Code" + ' ' + SalesShipmentHeader."Bill-to City", '<>', ' ');
        end;
        if TestNotDomestic(SalesShipmentHeader."Bill-to Country/Region Code") then begin
            if CountryRegion.Get(SalesShipmentHeader."Bill-to Country/Region Code") then begin
                Idx += 1;
                //if CountryRegion.SCExternalName <> '' then
                //  Addr[Idx] := CountryRegion.SCExternalName
                //else
                Addr[Idx] := CountryRegion.Name;
            end;
        end;
        if ShowAttention and (SalesShipmentHeader."Bill-to Contact" <> '') then begin
            Idx += 2;
            Addr[Idx] := 'Att: ' + SalesShipmentHeader."Bill-to Contact";
        end;

        //IF Idx = 0 THEN
        //  FormatShipmentSellToAddress(SalesShipmentHeader, Addr, TRUE);
    end;

    procedure FormatShipmentSellToAddress(SalesShipmentHeader: Record "Sales Shipment Header"; var Addr: array[10] of Text[50]; ShowAttention: Boolean)
    var
        Idx: Integer;
    begin
        ClearAddressVar(Addr);
        Idx := 0;
        if SalesShipmentHeader."Sell-to Customer Name" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesShipmentHeader."Sell-to Customer Name";
        end;
        if SalesShipmentHeader."Sell-to Customer Name 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesShipmentHeader."Sell-to Customer Name 2";
        end;
        if SalesShipmentHeader."Sell-to Address" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesShipmentHeader."Sell-to Address";
        end;
        if SalesShipmentHeader."Sell-to Address 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesShipmentHeader."Sell-to Address 2";
        end;
        if (SalesShipmentHeader."Sell-to Post Code" <> '') or (SalesShipmentHeader."Sell-to City" <> '') then begin
            Idx += 1;
            Addr[Idx] := DelChr(SalesShipmentHeader."Sell-to Post Code" + ' ' + SalesShipmentHeader."Sell-to City", '<>', ' ');
        end;
        if TestNotDomestic(SalesShipmentHeader."Sell-to Country/Region Code") then begin
            if CountryRegion.Get(SalesShipmentHeader."Sell-to Country/Region Code") then begin
                Idx += 1;
                //if CountryRegion.SCExternalName <> '' then
                //  Addr[Idx] := CountryRegion.SCExternalName
                //else
                Addr[Idx] := CountryRegion.Name;
            end;
        end;
        if ShowAttention and (SalesShipmentHeader."Sell-to Contact" <> '') then begin
            Idx += 2;
            Addr[Idx] := 'Att: ' + SalesShipmentHeader."Sell-to Contact";
        end;

        //IF Idx = 0 THEN
        //  FormatShipmentShippingAddress(SalesShipmentHeader, Addr, TRUE);
    end;

    procedure FormatInvoiceBillingAddress(SalesInvoiceHeader: Record "Sales Invoice Header"; var Addr: array[10] of Text[50]; ShowAttention: Boolean)
    var
        Idx: Integer;
    begin
        ClearAddressVar(Addr);
        Idx := 0;
        if SalesInvoiceHeader."Bill-to Name" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesInvoiceHeader."Bill-to Name";
        end;
        if SalesInvoiceHeader."Bill-to Name 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesInvoiceHeader."Bill-to Name 2";
        end;
        if SalesInvoiceHeader."Bill-to Address" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesInvoiceHeader."Bill-to Address";
        end;
        if SalesInvoiceHeader."Bill-to Address 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesInvoiceHeader."Bill-to Address 2";
        end;
        if (SalesInvoiceHeader."Bill-to Post Code" <> '') or (SalesInvoiceHeader."Bill-to City" <> '') then begin
            Idx += 1;
            Addr[Idx] := DelChr(SalesInvoiceHeader."Bill-to Post Code" + ' ' + SalesInvoiceHeader."Bill-to City", '<>', ' ');
        end;
        if TestNotDomestic(SalesInvoiceHeader."Bill-to Country/Region Code") then begin
            if CountryRegion.Get(SalesInvoiceHeader."Bill-to Country/Region Code") then begin
                Idx += 1;
                //if CountryRegion.SCExternalName <> '' then
                //  Addr[Idx] := CountryRegion.SCExternalName
                //else
                Addr[Idx] := CountryRegion.Name;
            end;
        end;
        if ShowAttention and (SalesInvoiceHeader."Bill-to Contact" <> '') then begin
            Idx += 2;
            Addr[Idx] := 'Att: ' + SalesInvoiceHeader."Bill-to Contact";
        end;

        if Idx = 0 then
            FormatInvoiceSellingAddress(SalesInvoiceHeader, Addr, true);
    end;

    procedure FormatInvoiceSellingAddress(SalesInvoiceHeader: Record "Sales Invoice Header"; var Addr: array[10] of Text[50]; ShowAttention: Boolean)
    var
        Idx: Integer;
    begin
        ClearAddressVar(Addr);
        Idx := 0;
        if SalesInvoiceHeader."Sell-to Customer Name" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesInvoiceHeader."Sell-to Customer Name";
        end;
        if SalesInvoiceHeader."Sell-to Customer Name 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesInvoiceHeader."Sell-to Customer Name 2";
        end;
        if SalesInvoiceHeader."Sell-to Address" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesInvoiceHeader."Sell-to Address";
        end;
        if SalesInvoiceHeader."Sell-to Address 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesInvoiceHeader."Sell-to Address 2";
        end;
        if (SalesInvoiceHeader."Sell-to Post Code" <> '') or (SalesInvoiceHeader."Sell-to City" <> '') then begin
            Idx += 1;
            Addr[Idx] := DelChr(SalesInvoiceHeader."Sell-to Post Code" + ' ' + SalesInvoiceHeader."Sell-to City", '<>', ' ');
        end;
        if TestNotDomestic(SalesInvoiceHeader."Sell-to Country/Region Code") then begin
            if CountryRegion.Get(SalesInvoiceHeader."Sell-to Country/Region Code") then begin
                Idx += 1;
                //if CountryRegion.SCExternalName <> '' then
                //  Addr[Idx] := CountryRegion.SCExternalName
                //else
                Addr[Idx] := CountryRegion.Name;
            end;
        end;
        if ShowAttention and (SalesInvoiceHeader."Sell-to Contact" <> '') then begin
            Idx += 2;
            Addr[Idx] := 'Att: ' + SalesInvoiceHeader."Sell-to Contact";
        end;
    end;

    procedure FormatCrMemoBillingAddress(SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var Addr: array[10] of Text[50]; ShowAttention: Boolean)
    var
        Idx: Integer;
    begin
        ClearAddressVar(Addr);
        Idx := 0;
        if SalesCrMemoHeader."Bill-to Name" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesCrMemoHeader."Bill-to Name";
        end;
        if SalesCrMemoHeader."Bill-to Name 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesCrMemoHeader."Bill-to Name 2";
        end;
        if SalesCrMemoHeader."Bill-to Address" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesCrMemoHeader."Bill-to Address";
        end;
        if SalesCrMemoHeader."Bill-to Address 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesCrMemoHeader."Bill-to Address 2";
        end;
        if (SalesCrMemoHeader."Bill-to Post Code" <> '') or (SalesCrMemoHeader."Bill-to City" <> '') then begin
            Idx += 1;
            Addr[Idx] := DelChr(SalesCrMemoHeader."Bill-to Post Code" + ' ' + SalesCrMemoHeader."Bill-to City", '<>', ' ');
        end;
        if TestNotDomestic(SalesCrMemoHeader."Bill-to Country/Region Code") then begin
            if CountryRegion.Get(SalesCrMemoHeader."Bill-to Country/Region Code") then begin
                Idx += 1;
                //if CountryRegion.SCExternalName <> '' then
                //  Addr[Idx] := CountryRegion.SCExternalName
                //else
                Addr[Idx] := CountryRegion.Name;
            end;
        end;
        if ShowAttention and (SalesCrMemoHeader."Bill-to Contact" <> '') then begin
            Idx += 2;
            Addr[Idx] := 'Att: ' + SalesCrMemoHeader."Bill-to Contact";
        end;
    end;

    procedure FormatSalesShippingAddress(SalesHeader: Record "Sales Header"; var Addr: array[10] of Text[50]; ShowAttention: Boolean)
    var
        Idx: Integer;
    begin
        ClearAddressVar(Addr);
        Idx := 0;
        if SalesHeader."Ship-to Name" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesHeader."Ship-to Name";
        end;
        if SalesHeader."Ship-to Name 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesHeader."Ship-to Name 2";
        end;
        if SalesHeader."Ship-to Address" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesHeader."Ship-to Address";
        end;
        if SalesHeader."Ship-to Address 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesHeader."Ship-to Address 2";
        end;
        if (SalesHeader."Ship-to Post Code" <> '') or (SalesHeader."Ship-to City" <> '') then begin
            Idx += 1;
            Addr[Idx] := DelChr(SalesHeader."Ship-to Post Code" + ' ' + SalesHeader."Ship-to City", '<>', ' ');
        end;
        if TestNotDomestic(SalesHeader."Ship-to Country/Region Code") then begin
            if CountryRegion.Get(SalesHeader."Ship-to Country/Region Code") then begin
                Idx += 1;
                //if CountryRegion.SCExternalName <> '' then
                //  Addr[Idx] := CountryRegion.SCExternalName
                //else
                Addr[Idx] := CountryRegion.Name;
            end;
        end;
    end;

    procedure FormatShipmentShippingAddress(SalesShipmentHeader: Record "Sales Shipment Header"; var Addr: array[10] of Text[50]; ShowAttention: Boolean)
    var
        Idx: Integer;
    begin
        ClearAddressVar(Addr);
        Idx := 0;
        if SalesShipmentHeader."Ship-to Name" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesShipmentHeader."Ship-to Name";
        end;
        if SalesShipmentHeader."Ship-to Name 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesShipmentHeader."Ship-to Name 2";
        end;
        if SalesShipmentHeader."Ship-to Address" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesShipmentHeader."Ship-to Address";
        end;
        if SalesShipmentHeader."Ship-to Address 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesShipmentHeader."Ship-to Address 2";
        end;
        if (SalesShipmentHeader."Ship-to Post Code" <> '') or (SalesShipmentHeader."Ship-to City" <> '') then begin
            Idx += 1;
            Addr[Idx] := DelChr(SalesShipmentHeader."Ship-to Post Code" + ' ' + SalesShipmentHeader."Ship-to City", '<>', ' ');
        end;
        if TestNotDomestic(SalesShipmentHeader."Ship-to Country/Region Code") then begin
            if CountryRegion.Get(SalesShipmentHeader."Ship-to Country/Region Code") then begin
                Idx += 1;
                //if CountryRegion.SCExternalName <> '' then
                //  Addr[Idx] := CountryRegion.SCExternalName
                //else
                Addr[Idx] := CountryRegion.Name;
            end;
        end;
    end;

    procedure FormatInvoiceShippingAddress(SalesInvoiceHeader: Record "Sales Invoice Header"; var Addr: array[10] of Text[50]; ShowAttention: Boolean)
    var
        Idx: Integer;
    begin
        ClearAddressVar(Addr);
        Idx := 0;
        if SalesInvoiceHeader."Ship-to Name" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesInvoiceHeader."Ship-to Name";
        end;
        if SalesInvoiceHeader."Ship-to Name 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesInvoiceHeader."Ship-to Name 2";
        end;
        if SalesInvoiceHeader."Ship-to Address" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesInvoiceHeader."Ship-to Address";
        end;
        if SalesInvoiceHeader."Ship-to Address 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesInvoiceHeader."Ship-to Address 2";
        end;
        if (SalesInvoiceHeader."Ship-to Post Code" <> '') or (SalesInvoiceHeader."Ship-to City" <> '') then begin
            Idx += 1;
            Addr[Idx] := DelChr(SalesInvoiceHeader."Ship-to Post Code" + ' ' + SalesInvoiceHeader."Ship-to City", '<>', ' ');
        end;
        if TestNotDomestic(SalesInvoiceHeader."Ship-to Country/Region Code") then begin
            if CountryRegion.Get(SalesInvoiceHeader."Ship-to Country/Region Code") then begin
                Idx += 1;
                //if CountryRegion.SCExternalName <> '' then
                //  Addr[Idx] := CountryRegion.SCExternalName
                //else
                Addr[Idx] := CountryRegion.Name;
            end;
        end;
    end;

    procedure FormatCrMemoShippingAddress(SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var Addr: array[10] of Text[50]; ShowAttention: Boolean)
    var
        Idx: Integer;
    begin
        ClearAddressVar(Addr);
        Idx := 0;
        if SalesCrMemoHeader."Ship-to Name" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesCrMemoHeader."Ship-to Name";
        end;
        if SalesCrMemoHeader."Ship-to Name 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesCrMemoHeader."Ship-to Name 2";
        end;
        if SalesCrMemoHeader."Ship-to Address" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesCrMemoHeader."Ship-to Address";
        end;
        if SalesCrMemoHeader."Ship-to Address 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := SalesCrMemoHeader."Ship-to Address 2";
        end;
        if (SalesCrMemoHeader."Ship-to Post Code" <> '') or (SalesCrMemoHeader."Ship-to City" <> '') then begin
            Idx += 1;
            Addr[Idx] := DelChr(SalesCrMemoHeader."Ship-to Post Code" + ' ' + SalesCrMemoHeader."Ship-to City", '<>', ' ');
        end;
        if TestNotDomestic(SalesCrMemoHeader."Ship-to Country/Region Code") then begin
            if CountryRegion.Get(SalesCrMemoHeader."Ship-to Country/Region Code") then begin
                Idx += 1;
                //if CountryRegion.SCExternalName <> '' then
                //  Addr[Idx] := CountryRegion.SCExternalName
                //else
                Addr[Idx] := CountryRegion.Name;
            end;
        end;
    end;

    procedure FormatReminderAddress(IssuedReminderHeader: Record "Issued Reminder Header"; var Addr: array[10] of Text[50]; ShowAttention: Boolean)
    var
        Idx: Integer;
    begin
        ClearAddressVar(Addr);
        Idx := 0;
        if IssuedReminderHeader.Name <> '' then begin
            Idx += 1;
            Addr[Idx] := IssuedReminderHeader.Name;
        end;
        if IssuedReminderHeader."Name 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := IssuedReminderHeader."Name 2";
        end;
        if IssuedReminderHeader.Address <> '' then begin
            Idx += 1;
            Addr[Idx] := IssuedReminderHeader.Address;
        end;
        if IssuedReminderHeader."Address 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := IssuedReminderHeader."Address 2";
        end;
        if (IssuedReminderHeader."Post Code" <> '') or (IssuedReminderHeader.City <> '') then begin
            Idx += 1;
            Addr[Idx] := DelChr(IssuedReminderHeader."Post Code" + ' ' + IssuedReminderHeader.City, '<>', ' ');
        end;
        if TestNotDomestic(IssuedReminderHeader."Country/Region Code") then begin
            if CountryRegion.Get(IssuedReminderHeader."Country/Region Code") then begin
                Idx += 1;
                //if CountryRegion.SCExternalName <> '' then
                //  Addr[Idx] := CountryRegion.SCExternalName
                //else
                Addr[Idx] := CountryRegion.Name;
            end;
        end;
        if ShowAttention and (IssuedReminderHeader.Contact <> '') then begin
            Idx += 2;
            Addr[Idx] := 'Att: ' + IssuedReminderHeader.Contact;
        end;
    end;

    procedure FormatFinChargeMemoAddress(IssuedFinChargeMemoHeader: Record "Issued Fin. Charge Memo Header"; var Addr: array[10] of Text[50]; ShowAttention: Boolean)
    var
        Idx: Integer;
    begin
        ClearAddressVar(Addr);
        Idx := 0;
        if IssuedFinChargeMemoHeader.Name <> '' then begin
            Idx += 1;
            Addr[Idx] := IssuedFinChargeMemoHeader.Name;
        end;
        if IssuedFinChargeMemoHeader."Name 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := IssuedFinChargeMemoHeader."Name 2";
        end;
        if IssuedFinChargeMemoHeader.Address <> '' then begin
            Idx += 1;
            Addr[Idx] := IssuedFinChargeMemoHeader.Address;
        end;
        if IssuedFinChargeMemoHeader."Address 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := IssuedFinChargeMemoHeader."Address 2";
        end;
        if (IssuedFinChargeMemoHeader."Post Code" <> '') or (IssuedFinChargeMemoHeader.City <> '') then begin
            Idx += 1;
            Addr[Idx] := DelChr(IssuedFinChargeMemoHeader."Post Code" + ' ' + IssuedFinChargeMemoHeader.City, '<>', ' ');
        end;
        if TestNotDomestic(IssuedFinChargeMemoHeader."Country/Region Code") then begin
            if CountryRegion.Get(IssuedFinChargeMemoHeader."Country/Region Code") then begin
                Idx += 1;
                //if CountryRegion.SCExternalName <> '' then
                //  Addr[Idx] := CountryRegion.SCExternalName
                //else
                Addr[Idx] := CountryRegion.Name;
            end;
        end;
        if ShowAttention and (IssuedFinChargeMemoHeader.Contact <> '') then begin
            Idx += 2;
            Addr[Idx] := 'Att: ' + IssuedFinChargeMemoHeader.Contact;
        end;
    end;

    procedure FormatPurchPayToAddress(PurchaseHeader: Record "Purchase Header"; var Addr: array[10] of Text[50]; ShowAttention: Boolean)
    var
        Idx: Integer;
    begin
        ClearAddressVar(Addr);
        Idx := 0;
        if PurchaseHeader."Pay-to Name" <> '' then begin
            Idx += 1;
            Addr[Idx] := PurchaseHeader."Pay-to Name";
        end;
        if PurchaseHeader."Pay-to Name 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := PurchaseHeader."Pay-to Name 2";
        end;
        if PurchaseHeader."Pay-to Address" <> '' then begin
            Idx += 1;
            Addr[Idx] := PurchaseHeader."Pay-to Address";
        end;
        if PurchaseHeader."Pay-to Address 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := PurchaseHeader."Pay-to Address 2";
        end;
        if (PurchaseHeader."Pay-to Post Code" <> '') or (PurchaseHeader."Pay-to City" <> '') then begin
            Idx += 1;
            Addr[Idx] := DelChr(PurchaseHeader."Pay-to Post Code" + ' ' + PurchaseHeader."Pay-to City", '<>', ' ');
        end;
        if TestNotDomestic(PurchaseHeader."Pay-to Country/Region Code") then begin
            if CountryRegion.Get(PurchaseHeader."Pay-to Country/Region Code") then begin
                Idx += 1;
                //if CountryRegion.SCExternalName <> '' then
                //  Addr[Idx] := CountryRegion.SCExternalName
                //else
                Addr[Idx] := CountryRegion.Name;
            end;
        end;
        if ShowAttention and (PurchaseHeader."Pay-to Contact" <> '') then begin
            Idx += 2;
            Addr[Idx] := 'Att: ' + PurchaseHeader."Pay-to Contact";
        end;
    end;

    procedure FormatPurchBuyFromAddress(PurchaseHeader: Record "Purchase Header"; var Addr: array[10] of Text[50]; ShowAttention: Boolean)
    var
        Idx: Integer;
    begin
        ClearAddressVar(Addr);
        Idx := 0;
        if PurchaseHeader."Buy-from Vendor Name" <> '' then begin
            Idx += 1;
            Addr[Idx] := PurchaseHeader."Buy-from Vendor Name";
        end;
        if PurchaseHeader."Buy-from Vendor Name 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := PurchaseHeader."Buy-from Vendor Name 2";
        end;
        if PurchaseHeader."Buy-from Address" <> '' then begin
            Idx += 1;
            Addr[Idx] := PurchaseHeader."Buy-from Address";
        end;
        if PurchaseHeader."Buy-from Address 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := PurchaseHeader."Buy-from Address 2";
        end;
        if (PurchaseHeader."Buy-from Post Code" <> '') or (PurchaseHeader."Buy-from City" <> '') then begin
            Idx += 1;
            Addr[Idx] := DelChr(PurchaseHeader."Buy-from Post Code" + ' ' + PurchaseHeader."Buy-from City", '<>', ' ');
        end;
        if TestNotDomestic(PurchaseHeader."Buy-from Country/Region Code") then begin
            if CountryRegion.Get(PurchaseHeader."Buy-from Country/Region Code") then begin
                Idx += 1;
                //if CountryRegion.SCExternalName <> '' then
                //  Addr[Idx] := CountryRegion.SCExternalName
                //else
                Addr[Idx] := CountryRegion.Name;
            end;
        end;
        if ShowAttention and (PurchaseHeader."Buy-from Contact" <> '') then begin
            Idx += 2;
            Addr[Idx] := 'Att: ' + PurchaseHeader."Buy-from Contact";
        end;
    end;

    procedure FormatPurchRcptBuyFromAddress(PurchRcptHeader: Record "Purch. Rcpt. Header"; var Addr: array[10] of Text[50]; ShowAttention: Boolean)
    var
        Idx: Integer;
    begin
        ClearAddressVar(Addr);
        Idx := 0;
        if PurchRcptHeader."Buy-from Vendor Name" <> '' then begin
            Idx += 1;
            Addr[Idx] := PurchRcptHeader."Buy-from Vendor Name";
        end;
        if PurchRcptHeader."Buy-from Vendor Name 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := PurchRcptHeader."Buy-from Vendor Name 2";
        end;
        if PurchRcptHeader."Buy-from Address" <> '' then begin
            Idx += 1;
            Addr[Idx] := PurchRcptHeader."Buy-from Address";
        end;
        if PurchRcptHeader."Buy-from Address 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := PurchRcptHeader."Buy-from Address 2";
        end;
        if (PurchRcptHeader."Buy-from Post Code" <> '') or (PurchRcptHeader."Buy-from City" <> '') then begin
            Idx += 1;
            Addr[Idx] := DelChr(PurchRcptHeader."Buy-from Post Code" + ' ' + PurchRcptHeader."Buy-from City", '<>', ' ');
        end;
        if TestNotDomestic(PurchRcptHeader."Buy-from Country/Region Code") then begin
            if CountryRegion.Get(PurchRcptHeader."Buy-from Country/Region Code") then begin
                Idx += 1;
                //if CountryRegion.SCExternalName <> '' then
                //  Addr[Idx] := CountryRegion.SCExternalName
                //else
                Addr[Idx] := CountryRegion.Name;
            end;
        end;
        if ShowAttention and (PurchRcptHeader."Buy-from Contact" <> '') then begin
            Idx += 2;
            Addr[Idx] := 'Att: ' + PurchRcptHeader."Buy-from Contact";
        end;
    end;

    procedure FormatPurchInvBuyFromAddress(PurchInvHeader: Record "Purch. inv. Header"; var Addr: array[10] of Text[50]; ShowAttention: Boolean)
    var
        Idx: Integer;
    begin
        ClearAddressVar(Addr);
        Idx := 0;
        if PurchInvHeader."Buy-from Vendor Name" <> '' then begin
            Idx += 1;
            Addr[Idx] := PurchInvHeader."Buy-from Vendor Name";
        end;
        if PurchInvHeader."Buy-from Vendor Name 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := PurchInvHeader."Buy-from Vendor Name 2";
        end;
        if PurchInvHeader."Buy-from Address" <> '' then begin
            Idx += 1;
            Addr[Idx] := PurchInvHeader."Buy-from Address";
        end;
        if PurchInvHeader."Buy-from Address 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := PurchInvHeader."Buy-from Address 2";
        end;
        if (PurchInvHeader."Buy-from Post Code" <> '') or (PurchInvHeader."Buy-from City" <> '') then begin
            Idx += 1;
            Addr[Idx] := DelChr(PurchInvHeader."Buy-from Post Code" + ' ' + PurchInvHeader."Buy-from City", '<>', ' ');
        end;
        if TestNotDomestic(PurchInvHeader."Buy-from Country/Region Code") then begin
            if CountryRegion.Get(PurchInvHeader."Buy-from Country/Region Code") then begin
                Idx += 1;
                //if CountryRegion.SCExternalName <> '' then
                //  Addr[Idx] := CountryRegion.SCExternalName
                //else
                Addr[Idx] := CountryRegion.Name;
            end;
        end;
        if ShowAttention and (PurchInvHeader."Buy-from Contact" <> '') then begin
            Idx += 2;
            Addr[Idx] := 'Att: ' + PurchInvHeader."Buy-from Contact";
        end;
    end;

    procedure FormatPurchShippingAddress(PurchaseHeader: Record "Purchase Header"; var Addr: array[10] of Text[50]; ShowAttention: Boolean)
    var
        Idx: Integer;
    begin
        ClearAddressVar(Addr);
        Idx := 0;
        if PurchaseHeader."Ship-to Name" <> '' then begin
            Idx += 1;
            Addr[Idx] := PurchaseHeader."Ship-to Name";
        end;
        if PurchaseHeader."Ship-to Name 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := PurchaseHeader."Ship-to Name 2";
        end;
        if PurchaseHeader."Ship-to Address" <> '' then begin
            Idx += 1;
            Addr[Idx] := PurchaseHeader."Ship-to Address";
        end;
        if PurchaseHeader."Ship-to Address 2" <> '' then begin
            Idx += 1;
            Addr[Idx] := PurchaseHeader."Ship-to Address 2";
        end;
        if (PurchaseHeader."Ship-to Post Code" <> '') or (PurchaseHeader."Ship-to City" <> '') then begin
            Idx += 1;
            Addr[Idx] := DelChr(PurchaseHeader."Ship-to Post Code" + ' ' + PurchaseHeader."Ship-to City", '<>', ' ');
        end;
        if TestNotDomestic(PurchaseHeader."Ship-to Country/Region Code") then begin
            if CountryRegion.Get(PurchaseHeader."Ship-to Country/Region Code") then begin
                Idx += 1;
                //if CountryRegion.SCExternalName <> '' then
                //  Addr[Idx] := CountryRegion.SCExternalName
                //else
                Addr[Idx] := CountryRegion.Name;
            end;
        end;
    end;

    procedure PurchSetStdShippingAddress(var PurchaseHeader: Record "Purchase Header")
    var
        CompanyInformation: Record "Company Information";
    begin
        if CompanyInformation.Get then begin
            PurchaseHeader."Ship-to Name" := CompanyInformation."Ship-to Name";
            PurchaseHeader."Ship-to Address" := CompanyInformation."Ship-to Address";
            PurchaseHeader."Ship-to Address 2" := CompanyInformation."Ship-to Address 2";
            PurchaseHeader."Ship-to Post Code" := CompanyInformation."Ship-to Post Code";
            PurchaseHeader."Ship-to City" := CompanyInformation."Ship-to City";
            PurchaseHeader."Ship-to Country/Region Code" := CompanyInformation."Ship-to Country/Region Code";
        end;
    end;

    procedure FormatCompanyAddress(var Addr: array[10] of Text[50])
    var
        CompanyInformation: Record "Company Information";
        Idx: Integer;

    begin
        ClearAddressVar(Addr);
        if CompanyInformation.get then begin
            Idx := 0;
            if CompanyInformation.Name <> '' then begin
                Idx += 1;
                Addr[Idx] := CompanyInformation.Name;
            end;
            if CompanyInformation."Name 2" <> '' then begin
                Idx += 1;
                Addr[Idx] := CompanyInformation."Name 2";
            end;
            if CompanyInformation.Address <> '' then begin
                Idx += 1;
                Addr[Idx] := CompanyInformation.Address;
            end;
            if CompanyInformation."Address 2" <> '' then begin
                Idx += 1;
                Addr[Idx] := CompanyInformation."Address 2";
            end;
            if (CompanyInformation."Post Code" <> '') or (CompanyInformation.City <> '') then begin
                Idx += 1;
                Addr[Idx] := DelChr(CompanyInformation."Post Code" + ' ' + CompanyInformation.City, '<>', ' ');
            end;
            if CountryRegion.Get(CompanyInformation."Country/Region Code") then begin
                Idx += 1;
                //if CountryRegion.SCExternalName <> '' then
                //  Addr[Idx] := CountryRegion.SCExternalName
                //else
                Addr[Idx] := CountryRegion.Name;
            end;
        end;
    end;

    procedure GetCompanyAddress(var Name: Text; var Address1: Text; var Address2: Text; var PostCodeCity: Text; var CountryName: Text; var Phone: Text; var URL: Text; var Email: Text; var VATNo: text)
    var
        CompanyInformation: Record "Company Information";
        CountryRegion: Record "Country/Region";
        SCReportUtil: Codeunit SCReportUtil;

    begin
        Name := '';
        if CompanyInformation.Get then begin
            Name := CompanyInformation.Name;
            Address1 := CompanyInformation.Address;
            Address2 := CompanyInformation."Address 2";
            PostCodeCity := SCReportUtil.TrimValue(CompanyInformation."Post Code" + ' ' + CompanyInformation.City);
            if CompanyInformation."Country/Region Code" <> '' then begin
                if CountryRegion.Get(CompanyInformation."Country/Region Code") then begin
                    CountryName := CountryRegion.Name;
                end;
            end;
            Phone := CompanyInformation."Phone No.";
            URL := CompanyInformation."Home Page";
            Email := CompanyInformation."E-Mail";
            VATNo := CompanyInformation."VAT Registration No.";
        end;
    end;

    procedure GetCompanyAddressInfo(var CompanyNameX: Text; var CompanyInfoComposite: Text; NameInInfo: Boolean; HTML: boolean)
    var
        CompanyInformation: Record "Company Information";
        CountryRegion: Record "Country/Region";
        PostCodeCity: Text;
    begin
        CompanyNameX := '';
        CompanyInfoComposite := '';
        if CompanyInformation.Get then begin
            CompanyNameX := CompanyInformation.Name;
            if NameInInfo then
                CompanyInfoComposite := CompanyInformation.Name;

            if CompanyInformation.Address <> '' then begin
                if CompanyInfoComposite <> '' then
                    CompanyInfoComposite += SCUtil.LineBreak();
                CompanyInfoComposite += CompanyInformation.Address;
            end;
            if CompanyInformation."Address 2" <> '' then begin
                if CompanyInfoComposite <> '' then
                    CompanyInfoComposite += SCUtil.LineBreak();
                CompanyInfoComposite += CompanyInformation."Address 2";
            end;
            PostCodeCity := CompanyInformation."Post Code" + ' ' + CompanyInformation.City;
            if PostCodeCity <> '' then begin
                if CompanyInfoComposite <> '' then
                    CompanyInfoComposite += SCUtil.LineBreak();
                CompanyInfoComposite += PostCodeCity;
            end;
            if CompanyInformation."Country/Region Code" <> '' then begin
                if CountryRegion.Get(CompanyInformation."Country/Region Code") then begin
                    CompanyInfoComposite += ', ' + CountryRegion.Name;
                end;
            end;
            if CompanyInformation."Phone No." <> '' then begin
                if CompanyInfoComposite <> '' then
                    CompanyInfoComposite += SCUtil.LineBreak();
                CompanyInfoComposite += 'LblPhone' + ': ' + CompanyInformation."Phone No." + ', ';
            end;
            if CompanyInformation."Home Page" <> '' then begin
                if CompanyInfoComposite <> '' then
                    CompanyInfoComposite += SCUtil.LineBreak();
                CompanyInfoComposite += CompanyInformation."Home Page" + ', ';
            end;
            if CompanyInformation."E-Mail" <> '' then begin
                if CompanyInfoComposite <> '' then
                    CompanyInfoComposite += SCUtil.LineBreak();
                CompanyInfoComposite += CompanyInformation."E-Mail" + ', ';
            end;
            if CompanyInformation."VAT Registration No." <> '' then begin
                if CompanyInfoComposite <> '' then
                    CompanyInfoComposite += SCUtil.LineBreak();
                CompanyInfoComposite += 'LblCOVATNo' + ': ' + CompanyInformation."VAT Registration No.";
            end;
        end;
    end;

    var
        SCUtil: Codeunit SCReportUtil;
}

