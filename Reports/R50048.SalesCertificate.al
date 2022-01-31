Report 50048 SalesCertificate
{
    DefaultLayout = Word;
    Caption = 'Certificate';
    PreviewMode = PrintLayout;
    WordMergeDataItem = Header;

    dataset
    {
        dataitem(Header; "Sales Invoice Header")
        {
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Certificate';
            column(SCFileName; SCFileName)
            {
            }
            column(CompanyPicture; CompanyInformation.Picture)
            {
            }
            column(CompanyInfo; CompanyInfo)
            {
            }
            column(CompanyName; CompanyNameTxt)
            {
            }
            column(CompanyAddress; CompanyAddress1)
            {
            }
            column(CompanyAddress2; CompanyAddress2)
            {
            }
            column(CompanyPostCodeCity; CompanyPostCodeCity)
            {
            }
            column(CompanyCountry; CompanyCountry)
            {
            }
            column(CompanyPhone; CompanyPhone)
            {
            }
            column(CompanyURL; CompanyURL)
            {
            }
            column(CompanyEmail; CompanyEmail)
            {
            }
            column(CompanyCVR; CompanyCVR)
            {
            }
            column(CompanyExportNo; CompanyExportNo)
            {
            }
            column(CompanyRegNo; CompanyRegNo)
            {
            }
            column(InvoiceAddress1; InvoiceAddress[1])
            {
            }
            column(InvoiceAddress2; InvoiceAddress[2])
            {
            }
            column(InvoiceAddress3; InvoiceAddress[3])
            {
            }
            column(InvoiceAddress4; InvoiceAddress[4])
            {
            }
            column(InvoiceAddress5; InvoiceAddress[5])
            {
            }
            column(InvoiceAddress6; InvoiceAddress[6])
            {
            }
            column(InvoiceAddress7; InvoiceAddress[7])
            {
            }
            column(InvoiceAddress8; InvoiceAddress[8])
            {
            }
            column(ShipmentAddress1; ShipToAddress[1])
            {
            }
            column(ShipmentAddress2; ShipToAddress[2])
            {
            }
            column(ShipmentAddress3; ShipToAddress[3])
            {
            }
            column(ShipmentAddress4; ShipToAddress[4])
            {
            }
            column(ShipmentAddress5; ShipToAddress[5])
            {
            }
            column(ShipmentAddress6; ShipToAddress[6])
            {
            }
            column(ShipmentAddress7; ShipToAddress[7])
            {
            }
            column(ShipmentAddress8; ShipToAddress[8])
            {
            }
            column(AccountNo; "Sell-to Customer No.")
            {
            }
            column(InvoiceAccountNo; "Bill-to Customer No.")
            {
            }
            column(DocumentNo; "No.")
            {
            }
            column(DocumentDate; SCReportUtil.FixDateYYYYMMDD("Posting Date"))
            {
            }
            dataitem(Line; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = Header;
                DataItemTableView = sorting("Document No.", "Line No.");
                UseTemporary = true;
                column(ItemNo_Line; ItemNumber)
                {
                }
                column(ItemNoOrg_Line; ItemNumberOrg)
                {
                }
                column(Description_Line; DescriptionTxt)
                {
                }
                column(Quantity_Line; QtyTxt)
                {
                }
                column(LOTNo; "Shipment No.")
                {
                }
                column(InvoiceNo; Header."No.")
                {
                }
                column(SterilDate_Line; SterilDate)
                {
                }
                column(ExpiryDate_Line; ExpiryDate)
                {
                }
                column(LblProduct; scutil.LabelTxt('LblProduct'))
                {
                }
                column(LblQty; scutil.LabelTxt('LblQty'))
                {
                }
                column(LblLOT; scutil.LabelTxt('LblLOT'))
                {
                }
                column(LblSterilDate; scutil.LabelTxt('LblSterilDate'))
                {
                }
                column(LblExpiryDate; scutil.LabelTxt('LblExpiryDate'))
                {
                }
                column(LblCODANRef; scutil.LabelTxt('LblCODANRef'))
                {
                }
                column(LblInvoiceNo; scutil.LabelTxt('LblInvoiceNo'))
                {
                }

                trigger OnAfterGetRecord();
                begin
                    ItemNumberOrg := "No.";
                    ItemNumber := SCReportUtil.FixItemNumber("No.");

                    QtyTxt := SCUtil.FixAmount(Quantity, 0, false);
                    DescriptionTxt := SCUtil.InvoiceLineDescription(Line, false, false);
                    SterilDate := '';
                    if Line."Shipment Date" <> 0D then
                        SterilDate := SCReportUtil.FixDateDDMMYYYY(Line."Shipment Date");
                    ExpiryDate := '';
                    if Line."Posting Date" <> 0D then
                        ExpiryDate := SCReportUtil.FixDateDDMMYYYY(Line."Posting Date")
                end;
            }
            dataitem(Labels; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(LblDocument; scutil.LabelTxt('LblDocument'))
                {
                }
                column(LblDocumentNo; scutil.LabelTxt('LblDocumentNo'))
                {
                }
                column(LblDocumentDate; scutil.LabelTxt('LblDocumentDate'))
                {
                }
                column(LblPhoneNo; scutil.LabelTxt('LblPhoneNo'))
                {
                }
                column(LblVatRegNo; scutil.LabelTxt('LblVatRegNo'))
                {
                }
            }
            trigger OnAfterGetRecord();
            var
                Customer: Record Customer;
                SalesInvoiceLine: Record "Sales Invoice Line";
                TrackingSpecification: Record "Tracking Specification" temporary;
                ItemTrackingDocManagement: Codeunit "Item Tracking Doc. Management";
                TrackingLineNo: Integer;
            begin
                Customer.Get(Header."Bill-to Customer No.");

                getReportInfo(LanguageCode, ReportNo);
                LanguageCode := 'ENU';
                SCUtil.SetReportInfo(LanguageCode, ReportNo);
                CurrReport.Language := Language.GetLanguageID(LanguageCode);

                SCFileName := StrSubstNo(scutil.LabelTxt('LblFileName'), "No.");

                SCAddress.FormatInvoiceBillingAddress(Header, InvoiceAddress, true);
                SCAddress.FormatInvoiceShippingAddress(Header, ShipToAddress, true);
                SCAddress.GetCompanyAddress(CompanyNameTxt, CompanyAddress1, CompanyAddress2, CompanyPostCodeCity, CompanyCountry, CompanyPhone, CompanyURL, CompanyEmail, CompanyCVR);

                if TrackingSpecification.IsTemporary and Line.IsTemporary then begin
                    Line.Reset();
                    Line.DeleteAll();
                    TrackingLineNo := 0;
                    SalesInvoiceLine.reset;
                    SalesInvoiceLine.SetRange("Document No.", Header."No.");
                    if InvoiceLineFilter <> '' then
                        SalesInvoiceLine.SetFilter("Line No.", InvoiceLineFilter);
                    if SalesInvoiceLine.FindSet() then begin
                        repeat
                            TrackingSpecification.Reset();
                            TrackingSpecification.DeleteAll();
                            ItemTrackingDocManagement.RetrieveDocumentItemTracking(TrackingSpecification, SalesInvoiceLine."Document No.", DATABASE::"Sales Invoice Header", 0);
                            TrackingSpecification.SetRange("Source Ref. No.", SalesInvoiceLine."Line No.");
                            if TrackingSpecification.FindSet() then begin
                                repeat
                                    TrackingLineNo += 10000;
                                    Line.Init();
                                    Line := SalesInvoiceLine;
                                    Line."Line No." := TrackingLineNo;
                                    Line.Quantity := TrackingSpecification."Quantity (Base)";
                                    Line."Shipment No." := TrackingSpecification."Lot No.";
                                    Line."Shipment Date" := WorkDate();
                                    Line."Posting Date" := TrackingSpecification."Expiration Date";
                                    Line.Insert();
                                until TrackingSpecification.Next() = 0;
                            end else begin
                                Line.Init();
                                Line := SalesInvoiceLine;
                                Line."Shipment No." := '';
                                Line."Shipment Date" := 0D;
                                Line."Posting Date" := 0D;
                                Line.Insert();
                            end;
                        until SalesInvoiceLine.Next() = 0;
                    end;
                end;
            end;
        }
    }

    trigger OnInitReport()
    begin
        CompanyInformation.Get;
        CompanyInformation.CalcFields(Picture);
    end;

    procedure SetInvoiceLineFilter(SetLineFilter: text)
    begin
        InvoiceLineFilter := SetLineFilter;
    end;

    var
        SCReportUtil: Codeunit SCReportUtil;
        CompanyInformation: Record "Company Information";
        SCFileName: text;
        Language: Codeunit Language;
        InvoiceAddress: array[8] of Text[50];
        ShipToAddress: array[8] of Text[50];
        CompanyNameTxt: Text;
        CompanyInfo: Text;
        CompanyAddress1: Text;
        CompanyAddress2: Text;
        CompanyPostCodeCity: Text;
        CompanyCountry: Text;
        CompanyPhone: Text;
        CompanyURL: Text;
        CompanyEmail: Text;
        CompanyCVR: Text;
        CompanyExportNo: Text;
        CompanyRegNo: Text;
        SCUtil: Codeunit SCReportUtil;
        SCAddress: Codeunit SCReportAddress;
        SCSpecial: Codeunit SCReportSpecial;
        ReportNo: Integer;
        LanguageCode: Code[10];
        ItemNumber: Code[20];
        ItemNumberOrg: Code[20];
        QtyTxt: Text;
        DescriptionTxt: Text;
        SterilDate: Text;
        ExpiryDate: Text;
        InvoiceLineFilter: Text;


    local procedure getReportInfo(var LanguageCodeX: Code[10]; var ReportNoX: Integer)
    var
        SCReportSetup: Record SCReportSetup;
        DefaultLanguageCode: Code[10];
    begin
        LanguageCodeX := Header."Language Code";
        if LanguageCodeX = '' then
            LanguageCodeX := SCReportSetup.GetCode('LANGUAGE', '', '', 'DefaultLanguageCode');
        Evaluate(ReportNoX, SCUtil.StrKeep(CurrReport.ObjectId(false), '0123456789'));
    end;

}
