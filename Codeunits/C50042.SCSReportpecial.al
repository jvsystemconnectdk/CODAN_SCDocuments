codeunit 50042 SCReportSpecial
{
    procedure SCSetIBAN(CurrencyCode: Code[10]) IBANNo: Text
    var
        SCReportSetup: Record SCReportSetup;
        IBANCurrencyCode: Code[10];
    begin
        if CurrencyCode = '' then
            CurrencyCode := 'DKK';
        IBANCurrencyCode := StrSubstNo('IBAN_%1', CurrencyCode);
        IBANNo := SCReportSetup.GetText('IBAN', '', '', IBANCurrencyCode);
    end;

    procedure SCGetSalesInvoiceShptLines(DocumentNo: Code[20]; LineNo: Integer): Text
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        SalesShipmentLine: Record "Sales Shipment Line";
        SCShipmentNo: Text;
    begin
        SCShipmentNo := '';
        ValueEntry.Reset;
        ValueEntry.SetCurrentkey("Document No.");
        ValueEntry.SetRange("Document No.", DocumentNo);
        ValueEntry.SetRange("Document Type", ValueEntry."document type"::"Sales Invoice");
        ValueEntry.SetRange("Document Line No.", LineNo);
        if ValueEntry.FindSet then begin
            repeat
                ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.");
                if ItemLedgerEntry."Document Type" = ItemLedgerEntry."document type"::"Sales Shipment" then
                    if SalesShipmentLine.Get(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.") then begin
                        SCShipmentNo := SalesShipmentLine."Document No.";
                    end;
            until ValueEntry.Next = 0;
        end;
        exit(SCShipmentNo);
    end;

    procedure SCGetSalesCrMemoShptLines(DocumentNo: Code[20]; LineNo: Integer): Text
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        SalesShipmentLine: Record "Return Receipt Line";
        SCShipmentNo: Text;
    begin
        SCShipmentNo := '';
        ValueEntry.Reset;
        ValueEntry.SetCurrentkey("Document No.");
        ValueEntry.SetRange("Document No.", DocumentNo);
        ValueEntry.SetRange("Document Type", ValueEntry."document type"::"Sales Credit Memo");
        ValueEntry.SetRange("Document Line No.", LineNo);
        if ValueEntry.FindSet then begin
            repeat
                ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.");
                if ItemLedgerEntry."Document Type" = ItemLedgerEntry."document type"::"Sales Return Receipt" then
                    if SalesShipmentLine.Get(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.") then begin
                        SCShipmentNo := SalesShipmentLine."Document No.";
                    end;
            until ValueEntry.Next = 0;
        end;
        exit(SCShipmentNo);
    end;

    procedure SetPurchaserPhone(var PurchaseHeader: record "Purchase Header") PurchasePhone: text
    var
        Purchaser: record "Salesperson/Purchaser";
    begin
        if Purchaser.get(PurchaseHeader."Purchaser Code") then
            PurchasePhone := Purchaser."Phone No.";
    end;

    procedure SetRcptPurchaserPhone(var PurchRcptHeader: record "Purch. Rcpt. Header") PurchasePhone: text
    var
        Purchaser: record "Salesperson/Purchaser";
    begin
        if Purchaser.get(PurchRcptHeader."Purchaser Code") then
            PurchasePhone := Purchaser."Phone No.";
    end;

    procedure SetInvPurchaserPhone(var PurchInvHeader: record "Purch. Inv. Header") PurchasePhone: text
    var
        Purchaser: record "Salesperson/Purchaser";
    begin
        if Purchaser.get(PurchInvHeader."Purchaser Code") then
            PurchasePhone := Purchaser."Phone No.";
    end;

    procedure SetPurchaserEmail(var PurchaseHeader: record "Purchase Header") PurchaseEmail: text
    var
        Purchaser: record "Salesperson/Purchaser";
    begin
        if Purchaser.get(PurchaseHeader."Purchaser Code") then
            PurchaseEmail := Purchaser."E-Mail";
    end;

    procedure SetRcptPurchaserEmail(var PurchRcptHeader: record "Purch. Rcpt. Header") PurchaseEmail: text
    var
        Purchaser: record "Salesperson/Purchaser";
    begin
        if Purchaser.get(PurchRcptHeader."Purchaser Code") then
            PurchaseEmail := Purchaser."E-Mail";
    end;

    procedure SetInvPurchaserEmail(var PurchInvHeader: record "Purch. Inv. Header") PurchaseEmail: text
    var
        Purchaser: record "Salesperson/Purchaser";
    begin
        if Purchaser.get(PurchInvHeader."Purchaser Code") then
            PurchaseEmail := Purchaser."E-Mail";
    end;

}