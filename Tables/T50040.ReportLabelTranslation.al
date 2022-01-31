Table 50040 ReportLabelTranslation
{
    Caption = 'Report label translation';

    fields
    {
        field(1; ReportNo; Integer)
        {
            Caption = 'Report No.';
            DataClassification = ToBeClassified;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Report));
        }
        field(2; ReportName; Text[30])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Report),
                                                                        "Object ID" = field(ReportNo)));
            Caption = 'Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; LabelId; Text[30])
        {
            Caption = 'Label Id';
            DataClassification = ToBeClassified;
        }
        field(4; LanguageCode; Code[10])
        {
            Caption = 'Language Code';
            DataClassification = ToBeClassified;
        }
        field(5; LabelText; Text[250])
        {
            Caption = 'Label text';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; ReportNo, LabelId, LanguageCode)
        {
        }
    }

    fieldgroups
    {
    }

    procedure getTranslation(ReportNo: Integer; LabelSpec: text; LanguageCode: Code[10]): text;
    var
        ReportLabelTranslation: record ReportLabelTranslation;
    begin
        if ReportLabelTranslation.get(ReportNo, LabelSpec, LanguageCode) then
            exit(ReportLabelTranslation.LabelText);

    end;
}

