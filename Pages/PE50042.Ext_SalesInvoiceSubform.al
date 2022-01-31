pageextension 50042 Ext_SalesInvoiceSubform extends "Sales Invoice Subform"
{
    layout
    {
        addafter("No.")
        {
            field(SCPosition; Rec.SCPosition)
            {
            }
        }
    }
}

