pageextension 50048 Ext_PostedSalesInvoice extends "Posted Sales Invoice"
{

    actions
    {
        addlast(processing)
        {
            action(PrintCertificate)
            {
                Caption = 'Certificate';
                Visible = true;
                ApplicationArea = All;
                Image = Certificate;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    SalesInvoiceLine: Record "Sales Invoice Line";
                    SalesCertificate: Report SalesCertificate;
                    CertificateSelect: Page CertificateSelect;
                    InvoiceLineFilter: Text;

                begin
                    SalesInvoiceHeader.reset;
                    SalesInvoiceHeader.SetRange("No.", Rec."No.");
                    if SalesInvoiceHeader.FindFirst() then begin
                        SalesInvoiceLine.reset;
                        SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
                        if SalesInvoiceLine.Count > 1 then begin
                            Clear(CertificateSelect);
                            CertificateSelect.SetInvoiceLines(SalesInvoiceHeader."No.");
                            CertificateSelect.LookupMode(true);
                            if CertificateSelect.RunModal() = Action::LookupOK then
                                CertificateSelect.GetInvoiceLineFilter(InvoiceLineFilter);
                        end;
                        Clear(SalesCertificate);
                        SalesCertificate.SetTableView(SalesInvoiceHeader);
                        if InvoiceLineFilter <> '' then
                            SalesCertificate.SetInvoiceLineFilter(InvoiceLineFilter);
                        SalesCertificate.Run();
                    end;
                end;
            }
        }
    }

}