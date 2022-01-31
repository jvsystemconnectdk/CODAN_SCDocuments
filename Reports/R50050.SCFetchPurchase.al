report 50050 SCFetchPurchase
{
    Caption = 'Købsordrer';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Header; "Purchase Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.", "Posting Date";
            RequestFilterHeading = 'Købsordrer';

            trigger OnAfterGetRecord()
            var
                PurchaseLine: Record "Purchase Line";
                Found: Boolean;
            begin
                if PurchaseHeaderSelected.IsTemporary then begin
                    Found := false;
                    PurchaseLine.reset;
                    PurchaseLine.SetRange("Document No.", Header."No.");
                    PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                    if PurchaseLine.FindSet() then begin
                        repeat
                            if FNo <> '' then begin
                                if FNo = PurchaseLine."No." then
                                    Found := true;
                            end else begin
                                if UpperCase(CopyStr(PurchaseLine."No.", 1, 1)) = 'F' then
                                    found := true;
                            end;
                        until (PurchaseLine.Next() = 0) or Found;
                    end;
                    if Found then begin
                        PurchaseHeaderSelected.Init();
                        PurchaseHeaderSelected := Header;
                        PurchaseHeaderSelected.Insert();
                    end;
                end;
            end;
        }
    }

    requestpage
    {

        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(Specification)
                {
                    Caption = 'Filter Purchase';
                    field(FNo; FNo)
                    {
                        ApplicationArea = All;
                        Caption = 'F-Number';
                    }
                }
            }
        }
    }

    var
        PurchaseHeaderSelected: Record "Purchase Header" temporary;
        FNo: Code[20];

    procedure GetPurchaseHeaderSelected(var TmpPurchaseHeaderSelected: Record "Purchase Header")
    begin
        if TmpPurchaseHeaderSelected.IsTemporary then begin
            TmpPurchaseHeaderSelected.reset;
            TmpPurchaseHeaderSelected.DeleteAll();

            PurchaseHeaderSelected.reset;
            if PurchaseHeaderSelected.FindSet() then begin
                repeat
                    TmpPurchaseHeaderSelected.Init();
                    TmpPurchaseHeaderSelected := PurchaseHeaderSelected;
                    TmpPurchaseHeaderSelected.Insert();
                until PurchaseHeaderSelected.Next() = 0;
            end;
        end;

    end;

}