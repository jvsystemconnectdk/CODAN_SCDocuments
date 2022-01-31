codeunit 50043 SCCurrAdjUtil
{
    trigger OnRun()
    begin

    end;

    procedure IsSalesLineCurrAdjusted(var SalesLine: Record "Sales Line"; var EURExchRate: Decimal; var USDExchRate: Decimal; var BasePrice: Decimal; var AdjPct: Decimal; var AdjUnitPrice: Decimal): Boolean
    var
        SalesHeader: Record "Sales Header";
        RecRef: RecordRef;
        ActiveTxt: Text;
        HeaderCurAdjActive: Boolean;
        LineCurrAdjusted: Boolean;

    begin
        if SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.") then begin
            RecRef.GetTable(SalesHeader);
            if Evaluate(HeaderCurAdjActive, format(RecRef.Field(50120).Value)) then;
            if Evaluate(EURExchRate, format(RecRef.Field(50121).Value)) then;
            if Evaluate(USDExchRate, format(RecRef.Field(50122).Value)) then;
            if HeaderCurAdjActive and (EURExchRate <> 0) and (USDExchRate <> 0) then begin
                RecRef.GetTable(SalesLine);
                if Evaluate(LineCurrAdjusted, format(RecRef.Field(50120).Value)) then;
                if Evaluate(BasePrice, format(RecRef.Field(50121).Value)) then;
                if Evaluate(AdjPct, format(RecRef.Field(50122).Value)) then;
                if Evaluate(AdjUnitPrice, format(RecRef.Field(50123).Value)) then;
                AdjPct := Round(AdjPct, 0.01);
                if LineCurrAdjusted and (AdjUnitPrice <> 0) then
                    exit(true);
            end;
        end;
    end;
}