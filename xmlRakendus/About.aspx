<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="xmlRakendus.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main>
    <h1>XML katsetamine: Minu sugupuu</h1>

    <div>
        
        <asp:Xml runat="server"
            DocumentSource="~/minusugupuu.xml"
            TransformSource="~/minuparing.xslt">

        </asp:Xml>
    </div>
</main>
</asp:Content>
