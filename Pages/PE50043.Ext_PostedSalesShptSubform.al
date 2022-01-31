pageextension 50043 Ext_PostedSalesShptSubform extends "Posted Sales Shpt. Subform"
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
