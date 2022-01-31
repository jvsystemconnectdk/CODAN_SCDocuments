pageextension 50041 Ext_SalesOrderSubform extends "Sales Order Subform"
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
