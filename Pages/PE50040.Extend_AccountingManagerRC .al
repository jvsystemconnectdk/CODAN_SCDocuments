pageextension 50040 Extend_AccountingManagerRC extends "Accounting Manager Role Center"
{
    actions
    {
        addlast(Sections)
        {
            group(ReportSetupActions)
            {
                Caption = 'SC Special';

                action(ReportSetup)
                {
                    Caption = 'Report Setup';
                    RunObject = page SCReportSetup;
                    ApplicationArea = All;
                }
            }
        }
    }
}