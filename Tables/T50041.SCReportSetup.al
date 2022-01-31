Table 50041 SCReportSetup
{

    fields
    {
        field(1; Category; Code[50])
        {
        }
        field(5; UserName; Code[50])
        {
        }
        field(6; GroupKey1; Text[50])
        {
        }
        field(10; "Key"; Code[50])
        {
            TableRelation = User."User Name";
        }
        field(15; KeyDescription; Text[250])
        {
        }
        field(20; ValueAsText1; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; Category, UserName, GroupKey1, "Key")
        {
        }
    }

    procedure InitBoolean(SetCategory: Code[50]; SetUserName: Code[50]; SetGroupKey1: Text[50]; SetKey: Code[50]; SetValue: Boolean; SetDescription: Text[250])
    begin
        if SetValue then begin
            InitText(SetCategory, SetUserName, SetGroupKey1, SetKey, '1', SetDescription);
        end else begin
            InitText(SetCategory, SetUserName, SetGroupKey1, SetKey, '0', SetDescription);
        end;
    end;

    procedure GetBoolean(GetCategory: Code[50]; GetUserName: Code[50]; GetGroupKey1: Text[50]; GetKey: Code[50]): Boolean
    begin
        exit(GetText(GetCategory, GetUserName, GetGroupKey1, GetKey) = '1')
    end;

    procedure SetBoolean(SetCategory: Code[50]; SetUserName: Code[50]; SetGroupKey1: Text[50]; SetKey: Code[50]; SetValue: Boolean)
    begin
        if SetValue then begin
            SetText(SetCategory, SetUserName, SetGroupKey1, SetKey, '1');
        end else begin
            SetText(SetCategory, SetUserName, SetGroupKey1, SetKey, '0');
        end;
    end;

    procedure InitInteger(SetCategory: Code[50]; SetUserName: Code[50]; SetGroupKey1: Text[50]; SetKey: Code[50]; SetValue: Integer; SetDescription: Text[250])
    begin
        InitText(SetCategory, SetUserName, SetGroupKey1, SetKey, Format(SetValue), SetDescription);
    end;

    procedure GetInteger(GetCategory: Code[50]; GetUserName: Code[50]; GetGroupKey1: Text[50]; GetKey: Code[50]) Value: Integer
    begin
        if not Evaluate(Value, GetText(GetCategory, GetUserName, GetGroupKey1, GetKey)) then begin
            Value := 0;
        end;
    end;

    procedure SetInteger(SetCategory: Code[50]; SetUserName: Code[50]; SetGroupKey1: Text[50]; SetKey: Code[50]; SetValue: Integer)
    begin
        SetText(SetCategory, SetUserName, SetGroupKey1, SetKey, Format(SetValue));
    end;

    procedure InitDecimal(SetCategory: Code[50]; SetUserName: Code[50]; SetGroupKey1: Text[50]; SetKey: Code[50]; SetValue: Decimal; SetDescription: Text[250])
    begin
        InitText(SetCategory, SetUserName, SetGroupKey1, SetKey, Format(SetValue), SetDescription);
    end;

    procedure GetDecimal(GetCategory: Code[50]; GetUserName: Code[50]; GetGroupKey1: Text[50]; GetKey: Code[50]) Value: Decimal
    begin
        if not Evaluate(Value, GetText(GetCategory, GetUserName, GetGroupKey1, GetKey)) then begin
            Value := 0;
        end;
    end;

    procedure SetDecimal(SetCategory: Code[50]; SetUserName: Code[50]; SetGroupKey1: Text[50]; SetKey: Code[50]; SetValue: Decimal)
    begin
        SetText(SetCategory, SetUserName, SetGroupKey1, SetKey, Format(SetValue));
    end;

    procedure InitDate(SetCategory: Code[50]; SetUserName: Code[50]; SetGroupKey1: Text[50]; SetKey: Code[50]; SetValue: Date; SetDescription: Text[250])
    begin
        InitText(SetCategory, SetUserName, SetGroupKey1, SetKey, Format(SetValue), SetDescription);
    end;

    procedure GetDate(GetCategory: Code[50]; GetUserName: Code[50]; GetGroupKey1: Text[50]; GetKey: Code[50]) Value: Date
    begin
        if not Evaluate(Value, GetText(GetCategory, GetUserName, GetGroupKey1, GetKey)) then begin
            Value := 0D;
        end;
    end;

    procedure SetDate(SetCategory: Code[50]; SetUserName: Code[50]; SetGroupKey1: Text[50]; SetKey: Code[50]; SetValue: Date)
    begin
        SetText(SetCategory, SetUserName, SetGroupKey1, SetKey, Format(SetValue));
    end;

    procedure InitDateTime(SetCategory: Code[50]; SetUserName: Code[50]; SetGroupKey1: Text[50]; SetKey: Code[50]; SetValue: DateTime; SetDescription: Text[250])
    begin
        InitText(SetCategory, SetUserName, SetGroupKey1, SetKey, Format(SetValue, 0, 1), SetDescription);
    end;

    procedure GetDateTime(GetCategory: Code[50]; GetUserName: Code[50]; GetGroupKey1: Text[50]; GetKey: Code[50]) Value: DateTime
    begin
        if not Evaluate(Value, GetText(GetCategory, GetUserName, GetGroupKey1, GetKey)) then begin
            Value := 0DT;
        end;
    end;

    procedure SetDateTime(SetCategory: Code[50]; SetUserName: Code[50]; SetGroupKey1: Text[50]; SetKey: Code[50]; SetValue: DateTime)
    begin
        SetText(SetCategory, SetUserName, SetGroupKey1, SetKey, Format(SetValue, 0, 1));
    end;

    procedure InitTime(SetCategory: Code[50]; SetUserName: Code[50]; SetGroupKey1: Text[50]; SetKey: Code[50]; SetValue: Time; SetDescription: Text[250])
    begin
        InitText(SetCategory, SetUserName, SetGroupKey1, SetKey, Format(SetValue), SetDescription);
    end;

    procedure GetTime(GetCategory: Code[50]; GetUserName: Code[50]; GetGroupKey1: Text[50]; GetKey: Code[50]) Value: Time
    begin
        if not Evaluate(Value, GetText(GetCategory, GetUserName, GetGroupKey1, GetKey)) then begin
            Value := 000000T;
        end;
    end;

    procedure SetTime(SetCategory: Code[50]; SetUserName: Code[50]; SetGroupKey1: Text[50]; SetKey: Code[50]; SetValue: Time)
    begin
        SetText(SetCategory, SetUserName, SetGroupKey1, SetKey, Format(SetValue));
    end;

    procedure InitDuration(SetCategory: Code[50]; SetUserName: Code[50]; SetGroupKey1: Text[50]; SetKey: Code[50]; SetValue: Duration; SetDescription: Text[250])
    begin
        InitText(SetCategory, SetUserName, SetGroupKey1, SetKey, Format(SetValue), SetDescription);
    end;

    procedure GetDuration(GetCategory: Code[50]; GetUserName: Code[50]; GetGroupKey1: Text[50]; GetKey: Code[50]) Value: Duration
    begin
        if not Evaluate(Value, GetText(GetCategory, GetUserName, GetGroupKey1, GetKey)) then begin
            Value := 0;
        end;
    end;

    procedure SetDuration(SetCategory: Code[50]; SetUserName: Code[50]; SetGroupKey1: Text[50]; SetKey: Code[50]; SetValue: Duration)
    begin
        SetText(SetCategory, SetUserName, SetGroupKey1, SetKey, Format(SetValue));
    end;

    procedure InitCode(SetCategory: Code[50]; SetUserName: Code[50]; SetGroupKey1: Text[50]; SetKey: Code[50]; SetValue: Code[1024]; SetDescription: Text[250])
    begin
        InitText(SetCategory, SetUserName, SetGroupKey1, SetKey, SetValue, SetDescription);
    end;

    procedure GetCode(GetCategory: Code[50]; GetUserName: Code[50]; GetGroupKey1: Text[50]; GetKey: Code[50]): Code[1024]
    begin
        exit(GetText(GetCategory, GetUserName, GetGroupKey1, GetKey));
    end;

    procedure SetCode(SetCategory: Code[50]; SetUserName: Code[50]; SetGroupKey1: Text[50]; SetKey: Code[50]; SetValue: Code[1024])
    begin
        SetText(SetCategory, SetUserName, SetGroupKey1, SetKey, SetValue);
    end;

    procedure InitText(SetCategory: Code[50]; SetUserName: Code[50]; SetGroupKey1: Text[50]; SetKey: Code[50]; SetValue: Text; SetDescription: Text[250])
    begin
        if not Exist(SetCategory, SetUserName, SetGroupKey1, SetKey) then begin
            SetText(SetCategory, SetUserName, SetGroupKey1, SetKey, SetValue);
            KeyDescription := SetDescription;
            Modify(false);
        end;
    end;

    procedure GetText(GetCategory: Code[50]; GetUserName: Code[50]; GetGroupKey1: Text[50]; GetKey: Code[50]): Text
    begin
        if SelectRecord(GetCategory, GetUserName, GetGroupKey1, GetKey) then begin
            exit(ValueAsText1);
        end else begin
            exit('');
        end;
    end;

    procedure SetText(SetCategory: Code[50]; SetUserName: Code[50]; SetGroupKey1: Text[50]; SetKey: Code[50]; SetValue: Text)
    begin
        if not SelectRecord(SetCategory, SetUserName, SetGroupKey1, SetKey) then begin
            Category := SetCategory;
            UserName := SetUserName;
            GroupKey1 := SetGroupKey1;
            Key := SetKey;
            Insert(false);
        end;
        ValueAsText1 := CopyStr(SetValue, 1, 250);
        Modify(false);
    end;

    procedure Exist(GetCategory: Code[50]; GetUserName: Code[50]; GetGroupKey1: Text[50]; GetKey: Code[50]): Boolean
    begin
        exit(SelectRecord(GetCategory, GetUserName, GetGroupKey1, GetKey));
    end;

    local procedure SelectRecord(GetCategory: Code[50]; GetUserName: Code[50]; GetGroupKey1: Text[50]; GetKey: Code[50]): Boolean
    begin
        if (Category <> GetCategory) or (UserName <> GetUserName) or (GroupKey1 <> GetGroupKey1) or (Key <> GetKey) then begin
            exit(Rec.Get(GetCategory, GetUserName, GetGroupKey1, GetKey));
        end else begin
            exit(true);
        end;
    end;
}

