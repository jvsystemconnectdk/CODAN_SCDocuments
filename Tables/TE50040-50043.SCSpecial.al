tableextension 50040 ExtSalesLine extends "Sales Line"
{
    fields
    {
        field(50040; SCPosition; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Postion';
        }
    }
}
tableextension 50041 ExtSalesInvoiceLine extends "Sales Invoice Line"
{
    fields
    {
        field(50040; SCPosition; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Postion';
        }
    }
}

tableextension 50042 ExtSalesCrMemoLine extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50040; SCPosition; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Postion';
        }
    }
}

tableextension 50043 ExtSalesShipmentLine extends "Sales Shipment Line"
{
    fields
    {
        field(50040; SCPosition; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Postion';
        }
    }
}