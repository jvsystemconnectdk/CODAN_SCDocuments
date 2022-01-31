pageextension 50045 Ext_PostedSalesCrMemoSubform extends "Posted Sales Cr. Memo Subform"
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


