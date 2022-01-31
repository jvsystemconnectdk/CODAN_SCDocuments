pageextension 50044 Ext_PostedSalesInvoiceSubform extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter("No.")
        {
            field(SCPosition; Rec.SCPosition)
            {
                Editable = false;
            }
        }
    }
}
