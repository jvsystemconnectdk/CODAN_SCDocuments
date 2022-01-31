report 50049 SCLabelExport
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem(ReportLabelTranslation; ReportLabelTranslation)
        {
            RequestFilterFields = ReportNo, LabelId;

            trigger OnAfterGetRecord()
            var
                Item: Record Item;
                UnitPrice: Decimal;
                CR: Char;
                LF: Char;
                Tab: Char;
            begin
                CR := 10;
                LF := 13;
                Tab := 9;
                ExportTxt += format(ReportLabelTranslation.ReportNo) + FieldDelimiter() +
                                ReportLabelTranslation.LabelId + FieldDelimiter() +
                                ReportLabelTranslation.LanguageCode + FieldDelimiter() +
                                ReportLabelTranslation.LabelText + LineDelimiter();
            end;

        }
    }

    trigger OnPostReport()
    var
        TempFile: File;
        InStr: InStream;
        OutStr: OutStream;
        TmpBlob: Codeunit "Temp Blob";
        TofileName: text;
        FileManagement: Codeunit "File Management";
    begin
        TmpBlob.CreateOutStream(OutStr, TextEncoding::Windows);
        OutStr.WriteText(ExportTxt);
        TmpBlob.CreateInStream(InStr);
        ToFileName := 'LabelFile.txt';
        DOWNLOADFROMSTREAM(InStr, 'Export', '', 'Textfiles (*.txt)|*.txt', ToFileName);
    end;

    procedure FieldDelimiter(): Text
    var
        Tab: Char;
    begin
        Tab := 9;
        EXIT(FORMAT(Tab));
    end;

    procedure LineDelimiter(): Text
    var
        CR: Char;
        LF: Char;
    begin
        CR := 13;
        LF := 10;
        EXIT(FORMAT(CR) + FORMAT(LF));
    end;

    var
        ExportTxt: text;

}