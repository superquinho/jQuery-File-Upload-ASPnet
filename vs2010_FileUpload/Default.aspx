<%@ Page Title="Home Page" Language="vb" MasterPageFile="~/Site.Master" AutoEventWireup="false"
    CodeBehind="Default.aspx.vb" Inherits="vs2010_FileUpload._Default" %>




<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
 
    <link type="text/css" rel="stylesheet" href="../FileUpload/css/style.css" />
    <link type="text/css" rel="stylesheet" href="../FileUpload/css/jquery-ui-1.9.0.custom.css" />
    <link type="text/css" rel="stylesheet" href="../FileUpload/css/jquery.fileupload-ui.css" />
    <link type="text/css" rel="stylesheet" href="../FileUpload/css/jquery.ui.all.css" />
    <link type="text/css" rel="stylesheet" href="../FileUpload/css/jquery-ui-1.8.21.custom.css" />

    <script  type="text/javascript" src="../FileUpload/js/jQuery/1.8.2/jquery-1.8.2.js"></script>
    <script  type="text/javascript" src="../FileUpload/js/jQuery/external/jquery.bgiframe-2.1.2.js"></script>
    <script  type="text/javascript" src="../FileUpload/js/jQuery/1.9.0/jquery-ui.js"></script> 

    <script  type="text/javascript" src="../FileUpload/js/jquery-1.7.2.min.js"></script>
    <script  type="text/javascript" src="../FileUpload/js/jQuery/1.8.13/jquery-ui.min.js"></script>
    <script  type="text/javascript" src="../FileUpload/js/jQuery/beta1/jquery.tmpl.min.js"></script>
    <script  type="text/javascript" src="../FileUpload/js/jquery.iframe-transport.js"></script>
    <script  type="text/javascript" src="../FileUpload/js/jquery.fileupload.js"></script>
    <script  type="text/javascript" src="../FileUpload/js/jquery.fileupload-ui.js"></script>
    <script  type="text/javascript" src="../FileUpload/js/application.js"></script> 

    <script type="text/javascript">

        $(document).ready(function () {

            // Trying to fix for Opera and Chrome
            $("#dialog-message").dialog({
                title: "Attach Files",
                modal: true,
                autoOpen: true,
                resizable: false,
                height: 500,
                width: 1000,
                buttons: {
                    "Ok": function (e) {
                        $(this).dialog("close");
                    }
                }
            });

            $("#attach-files")
                        .button()
                        .click(function (e) {
                            $("#dialog-message").dialog("open");
                            e.preventDefault();
                            return false;
                        });

            $("#dialog-message").dialog("close");

            UpdatejqFileName();
        });
    </script>

    <script type="text/javascript" language="javascript">

        function GetTxtFileName() {

            return $('#' + '<%= txtFileName.ClientID %>').val();

        }

        function SetTxtFileName(fileName) {

            document.getElementById('<%= txtFileName.ClientID %>').value = fileName;
            return false;

        }

        function AddTxtFileName(fileName) {
            var filesName = GetTxtFileName();
            filesName = $.trim(filesName + "|" + fileName);

            if (filesName.substring(0, 3).indexOf("|") > -1) {
                filesName = filesName.substring(filesName.substring(0, 3).indexOf("|") + 1, filesName.length);
            }

            document.getElementById('<%= txtFileName.ClientID %>').value = filesName;

            AppendButton(fileName);

            return false;
        }

        function RemoveTxtFileName(filename) {
            var filesName = GetTxtFileName();
            var tempFilesName;

            if (filename.indexOf("Handler.ashx?f=") >= 0) {
                filename = filename.replace("Handler.ashx?f=", "");
            }

            tempFilesName = filesName.replace(filename, '');
            while (tempFilesName.indexOf(filename) > 0) {
                tempFilesName = tempFilesName.replace(filename, '');
            }

            document.getElementById('<%= txtFileName.ClientID %>').value = tempFilesName;

            UpdatejqFileName();

            return false;

        }

        function UpdatejqFileName() {
            var tempFilesName = GetTxtFileName() + '';
            var tempFile;
            var i;

            $('div.jShowFilesLabel').remove();
            $('.dFileButton').remove();

            if (tempFilesName.length > 0) {

                while (tempFilesName.length > 0) {
                    i = tempFilesName.indexOf("|");
                    if (i == -1) { // Last File
                        tempFile = tempFilesName;
                        tempFilesName = '';
                    } else {
                        tempFile = tempFilesName.substring(0, i);
                        tempFilesName = tempFilesName.substring(i + 1);
                    }

                    if ($.trim(tempFile) !== "") {
                        AppendButton(tempFile);
                    }
                }
            }
        }

        function AppendButton(fileName) {

            if (fileName.length > 40) {
                fileName = FixTooLong(fileName);
            }

            $('div.jShowFiles').append("<div class='dFileButton'><button class='jqFileName'>" + fileName + "</button><br></div>");

            $('.jqFileName')
                .button({
                    icons: { primary: 'ui-icon-disk' }
                })
                .click(function (e) {
                    e.preventDefault();
                    return false;
                });

            return false;

        }

        function FixTooLong(fileName) {
            var tempFile;

            tempFile = fileName;
            tempFile = tempFile.substring(0, 25) + "..." + tempFile.substring(tempFile.length - 15);

            return tempFile;
        }
    
    </script>

</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

    <table border="0" cellpadding="0" cellspacing="0">
    
        <tr>
            <td style="width:52%; vertical-align:top;">
                   <asp:Panel ID="fuDocument" runat="server" Width="100%">
                        <table class="CustomTable2" cellpadding="0" cellspacing="0" width="100%" border="0">
                            <tr >
                                <td class="docAttach" style="width:170px;height:32px;">Document to submit:</td>
                                <td style="width:310px;">
                                     <button id="attach-files" class="jButton" type="button" tabindex="16">Attach Files</button> 
                                    <div class="jShowFilesLabel"></div>
                                    <asp:TextBox id="txtFileName" runat="server" style="display:none" ></asp:TextBox>
                                </td>
                            </tr>   
                            <tr>
                                <td></td>
                                <td >
                                    <div class="jShowFiles">
                                    </div>
                                </td>
                            </tr>             
                        </table>
                    </asp:Panel>
            </td>
        </tr>

    </table>

        
    <div id="dialog-message" title="Attach Files">

        <div id="fileupload">
            <div class="fileupload-buttonbar">
                <label class="fileinput-button">
                    <span class="addfile" >Add files...</span>
                    <input id="file" type="file" name="files[]" multiple />
                </label>
                <button type="submit" class="start">Start upload</button> 
                <button type="reset" class="cancel">Cancel upload</button>
            </div>
            <div class="fileupload-content" >
                <table class="files"></table>
                <div class="fileupload-progressbar"></div>
            </div>
        </div>

          <script id="template-upload" type="text/x-jquery-tmpl">
            <tr class="template-upload{{if error}} ui-state-error{{/if}}">
                <td class="preview"></td>
                <td class="name">${name}</td>
                <td class="size">${sizef}</td>
                {{if error}}
                    <td class="error" colspan="2">Error:
                        {{if error === 'maxFileSize'}}File is too big
                        {{else error === 'minFileSize'}}File is too small
                        {{else error === 'acceptFileTypes'}}Filetype not allowed
                        {{else error === 'maxNumberOfFiles'}}Max number of files exceeded
                        {{else}}${error}
                        {{/if}}
                    </td>
                {{else}}
                    <td class="progress"><div></div></td>
                    <td class="start"><button>Start</button></td>
                {{/if}}
                <td class="cancel"><button>Cancel</button></td>
            </tr>
        </script>
        <script id="template-download" type="text/x-jquery-tmpl">
            <tr class="template-download{{if _errorMSG}} ui-state-error{{/if}}">
                {{if _errorMSG}}
                    <td></td>
                    <td class="name">${_name}</td>
                    <td class="size">${sizef}</td>
                    <td class="error" colspan="2">Error:
                        {{if _errorMSG === 1}}File exceeds upload_max_filesize
                        {{else _errorMSG === 2}}File exceeds MAX_FILE_SIZE (HTML form directive)
                        {{else _errorMSG === 3}}File was only partially uploaded
                        {{else _errorMSG === 4}}No File was uploaded
                        {{else _errorMSG === 5}}Missing a temporary folder
                        {{else _errorMSG === 6}}Failed to write file to disk
                        {{else _errorMSG === 7}}File upload stopped by extension
                        {{else _errorMSG === 'maxFileSize'}}File is too big
                        {{else _errorMSG === 'minFileSize'}}File is too small
                        {{else _errorMSG === 'acceptFileTypes'}}Filetype not allowed
                        {{else _errorMSG === 'maxNumberOfFiles'}}Max number of files exceeded
                        {{else _errorMSG === 'uploadedBytes'}}Uploaded bytes exceed file size
                        {{else _errorMSG === 'emptyResult'}}Empty file upload result
                        {{else}}${_errorMSG}. File Not Uploaded!
                        {{/if}}
                    </td>
                    <td class="failupload">
                        <button data-type="${delete_type}" data-url="${delete_url}">Cancel Upload</button>
                    </td>                
                {{else}}
                    <td class="preview">
                        {{if Thumbnail_url}}
                            <a href="${_url}" target="_blank"><img src="${Thumbnail_url}"></a>
                        {{/if}}
                    </td>
                    <td class="name">
                        <a href="${_url}"{{if thumbnail_url}} target="_blank"{{/if}}>${_name}</a>
                    </td>
                    <td class="size">${sizef}</td>
                    <td colspan="2"></td>
                    <td class="success">
                        <button>File Uploaded</button>
                    </td>
                    <td class="delete">
                        <button data-type="${delete_type}" data-url="${delete_url}">Remove File</button>
                    </td>                
                {{/if}}

            </tr>
        </script>
              
    </div>          

</asp:Content>
