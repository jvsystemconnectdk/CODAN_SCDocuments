page 50043 CertificateSelect
{
    PageType = List;
    SourceTable = "Sales Invoice Line";
    SourceTableTemporary = true;
    Caption = 'Select Invoice Lines';
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field(Marked; Marked)
                {
                    Caption = 'Marked';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        rec."Allow Line Disc." := Marked;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Marked := false;
        if Rec."Allow Line Disc." then
            Marked := true;
    end;

    procedure SetInvoiceLines(InvoiceNo: Code[20])
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        if Rec.IsTemporary then begin
            SalesInvoiceLine.reset;
            SalesInvoiceLine.SetRange("Document No.", InvoiceNo);
            if SalesInvoiceLine.FindSet() then begin
                repeat
                    Rec.init;
                    Rec := SalesInvoiceLine;
                    rec."Allow Line Disc." := true;
                    Rec.Insert();
                until SalesInvoiceLine.Next() = 0;
            end;
        end;
    end;

    procedure GetInvoiceLineFilter(var InvoiceLineFilter: text)
    begin
        InvoiceLineFilter := '';
        Rec.reset;
        Rec.SetRange("Allow Line Disc.", true);
        if Rec.FindSet() then begin
            repeat
                if InvoiceLineFilter <> '' then
                    InvoiceLineFilter += '|';
                InvoiceLineFilter += Format(Rec."Line No.");
            until Rec.Next() = 0;
        end;
    end;
    /*
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                
                trigger OnAction();
                begin
                    
                end;
            }
        }
    }
    */
    var
        Marked: Boolean;
}