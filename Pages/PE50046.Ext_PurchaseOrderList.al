pageextension 50046 Ext_PurchaseOrderList extends "Purchase Order List"
{
    actions
    {
        addlast(processing)
        {
            action(PrintPurchaseRequisForm)
            {
                Caption = 'Købsordre-formular';
                Image = PurchaseTaxStatement;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category5;
                Visible = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    SCReportUtil: Codeunit SCReportUtil;
                begin
                    SCReportUtil.PurchaseRequisitionForm();
                end;
            }
        }
    }
}