Page 50040 ReportLabelTranslation
{
    Caption = 'Report label translation';
    PageType = List;
    SourceTable = ReportLabelTranslation;
    UsageCategory = Lists;
    ApplicationArea = All;
    AdditionalSearchTerms = 'layout';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ReportNo; Rec.ReportNo)
                {
                    ApplicationArea = Basic;
                }
                field(ReportName; Rec.ReportName)
                {
                    ApplicationArea = Basic;
                }
                field(LabelId; Rec.LabelId)
                {
                    ApplicationArea = Basic;
                }
                field(LanguageCode; Rec.LanguageCode)
                {
                    ApplicationArea = Basic;
                }
                field(LabelText; Rec.LabelText)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ImportLabels)
            {
                ApplicationArea = Basic;
                Caption = 'Import';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    LabelImport();
                end;
            }
            action(ExportLabels)
            {
                ApplicationArea = Basic;
                Caption = 'Export';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "SCLabelExport";
            }
        }
    }

    local procedure LabelImport()
    var
        DialogX: Dialog;
        FileTxt: Text;
        Value: array[50] of Text;
        QtyTrans: Integer;
        DialogTitle: Label 'Select text file';
        tempfilename: text;
        FileInStream: InStream;
        TempBlob: Codeunit "Temp Blob";

    begin
        if Confirm('Import label-data?', true) then begin
            TempBlob.CreateInStream(FileInStream, TextEncoding::Windows);
            if UploadIntoStream(DialogTitle, '', 'Textfiles (*.txt)|*.txt', tempfilename, FileInStream) then begin
                DialogX.Open('Entry: ###1#');
                while not FileInStream.EOS do begin
                    FileInStream.ReadText(FileTxt);
                    ReadLine(FileTxt, Value, true);
                    if ImportLabel(Value) then begin
                        QtyTrans := QtyTrans + 1;
                        DialogX.Update(1, QtyTrans);
                    end;
                end;
                DialogX.Close;
                Message('%1 entries has been imported/updated', QtyTrans);
            end else
                Message('File is not found!');
        end;
    end;

    procedure ReadLine(InText: Text; var Value: array[50] of Text; TrimX: Boolean)
    var
        SCUtil: Codeunit SCReportUtil;
        Position: Integer;
        ColNo: Integer;
        chTab: Char;
    begin
        for ColNo := 1 to 50 do begin
            Value[ColNo] := '';
        end;
        ColNo := 0;
        chTab := 9;
        while StrLen(InText) > 0 do begin
            Position := StrPos(InText, Format(chTab));
            if Position = 0 then
                Position := StrLen(InText) + 1;

            ColNo += 1;
            Value[ColNo] := '';
            if Position > 1 then
                if TrimX then
                    Value[ColNo] := SCUtil.TrimValue(CopyStr(InText, 1, Position - 1))
                else
                    Value[ColNo] := CopyStr(InText, 1, Position - 1);

            if Position > 0 then
                InText := DelStr(InText, 1, Position);
        end;
    end;

    local procedure ImportLabel(Value: array[50] of Text) Ok: Boolean
    var
        ReportLabelTranslation: Record ReportLabelTranslation;
        ReportNo: Integer;
    begin
        if Evaluate(ReportNo, Value[1]) then begin
            ReportLabelTranslation.Reset();
            ReportLabelTranslation.SetRange(ReportNo, ReportNo);
            ReportLabelTranslation.SetRange(LabelId, Value[2]);
            ReportLabelTranslation.SetRange(LanguageCode, Value[3]);
            if ReportLabelTranslation.FindFirst() then begin
                ReportLabelTranslation.LabelText := Value[4];
                if ReportLabelTranslation.Modify() then
                    ok := true;
            end else begin
                ReportLabelTranslation.Init();
                ReportLabelTranslation.ReportNo := ReportNo;
                ReportLabelTranslation.LabelId := Value[2];
                ReportLabelTranslation.LanguageCode := Value[3];
                ReportLabelTranslation.LabelText := Value[4];
                if ReportLabelTranslation.Insert() then
                    ok := true;
            end;
        end;
    end;

    local procedure LabelExport()
    var
        TempFile: File;
        InStr: InStream;
        OutStr: OutStream;
        TmpBlob: Codeunit "Temp Blob";
        TofileName: text;
        FileManagement: Codeunit "File Management";
    begin
        TmpBlob.CreateOutStream(OutStr);
        OutStr.WriteText('Dette er en test');
        TmpBlob.CreateInStream(InStr);
        ToFileName := 'SampleFile.txt';
        DOWNLOADFROMSTREAM(InStr, 'Export', '', 'All Files (*.*)|*.*', ToFileName);
    end;

}

