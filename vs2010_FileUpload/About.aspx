<%@ Page Title="About Us" Language="vb" MasterPageFile="~/Site.Master" AutoEventWireup="false"
    CodeBehind="About.aspx.vb" Inherits="vs2010_FileUpload.About" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <h2>
        About
    </h2>
    <p>
        This is an ASP.net project using the awesome jQuery File Upload developed by blueImp (https://github.com/blueimp/jQuery-File-Upload) and adapted to run on server-side with VB.net.<br />
        To make this run smooth on your machine, all you will beed is Visual Studio 2010 installed.<br />
        Some of important changes made for this project to run are:<br />

        <ul>
            <li>on FileUpload\js\jquery.fileupload-ui.js it maximum size allowed for a single file is set to 100kb.<br />
            // The maximum allowed file size:<br />
            maxFileSize: 100000,   <br />         
            </li><br />
            <li>also on the same .js file, the maximum number of files allowed for this project is set to 5 total files per upload.<br />
            This will reset once the user reload the page. (on Page_Load, Not IsPostBack)<br />
            // The following option limits the number of files that are<br />
            // allowed to be uploaded using this widget:<br />
            maxNumberOfFiles: 5,<br />
            </li><br />
            <li>for the previous to run smooth, a changed was necessary in 2 places, that was resetting as soon as the files were uploaded, allowing the user to upload another set of 5 files.<br /><br />
            on application.js the following were commented off:<br />
            // Don't allow to add another file for each successfull File uploaded<br />
            //fu._adjustMaxNumberOfFiles(JSONjQueryObject.List.length);<br /><br />
            on jquery.fileupload-ui.js the following were commented off:<br />
            // Don't allow to add another file for each successfull File uploaded<br />
            //that._adjustMaxNumberOfFiles(1);<br />
            </li><br />
            <li>the property filePath was added to the file variable on jquery.fileupload.js in case the internet browser is IE and the security setting enables<br />
            "Initialize and Script ActiveX controls not marked as safe for scripting"<br />
            so the file size of each uploading file is retrieved correctly, otherwise, "N/A kb" and the Handler.ashx will do another check on the server-side.<br />
            </li><br />
            <li>on appSettings in web.config file has some very important information regarding the Handler.ashx process.<br />
            add key="UploadFilesTempBasePath" value="C:\"<br />
            add key="UploadFilesTempPath" value="docs\jQueryFileUpload\"<br />
            add key="UploadFilesMaximumFileSize" value="100" -- value in KB --<br />
            if you planning on adding more server-side check (i.e. acceptFileTypes , maxNumberOfFiles, etc) it should be added in here and implement the code on Handler.ashx.<br />
            </li><br />
            <li>since IE might won't return the file size, a check is made on Handler.ashx if the browser is IE, and then using the setting on web.config, it will verify if the file size is within the limit.<br />
            Dim maximumFileSize As Integer = ConfigurationManager.AppSettings("UploadFilesMaximumFileSize")<br />
            If hpf.ContentLength >= 0 And (hpf.ContentLength <= maximumFileSize * 1000 Or maximumFileSize = 0) Then<br />
            </li><br />
            <li>on file jquery.fileupload-ui.js the following code was added to retrieve any erros message from Handler.ashx: <br />
                        var files = data.result;<br />
                        
                        if (files.Value._errorMSG != null) {<br />
                            file.error = files.Value._errorMSG;<br />
                        }            <br />
            </li><br />
            <li>on file jquery.fileupload-ui.js the following code was added to control which files has been uploaded using the jQuery plugin: <br />
                            // Adding the files to a TextBox<br />
                            AddTxtFileName(data.files[index].name);<br />
            </li><br />
        </ul>

        <p>Everything else is pretty much the same.</p>
        <p>So, feel free to make any changes to run according to your requests.</p><br />

        <h3>Have fun and happy programming!</h3>

    </p>
</asp:Content>
