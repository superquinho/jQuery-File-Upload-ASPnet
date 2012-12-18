jQuery-File-Upload-ASPnet
=========================

blueimp awesome jQuery File Upload plugin running on VB.net VS2010 

 This is an ASP.net project using the awesome jQuery File Upload developed by blueImp (https://github.com/blueimp/jQuery-File-Upload) and adapted to run on server-side with VB.net.
To make this run smooth on your machine, all you will need is Visual Studio 2010 installed.
Some of important changes made for this project to run are:

    - on FileUpload\js\jquery.fileupload-ui.js it maximum size allowed for a single file is set to 100kb.
    // The maximum allowed file size:
    maxFileSize: 100000,

    - also on the same .js file, the maximum number of files allowed for this project is set to 5 total files per upload.
    This will reset once the user reload the page. (on Page_Load, Not IsPostBack)
    // The following option limits the number of files that are
    // allowed to be uploaded using this widget:
    maxNumberOfFiles: 5,

    - for the previous to run smooth, a changed was necessary in 2 places, that was resetting as soon as the files were uploaded, allowing the user to upload another set of 5 files.

    on application.js the following were commented off:
    // Don't allow to add another file for each successfull File uploaded
    //fu._adjustMaxNumberOfFiles(JSONjQueryObject.List.length);

    on jquery.fileupload-ui.js the following were commented off:
    // Don't allow to add another file for each successfull File uploaded
    //that._adjustMaxNumberOfFiles(1);

    - the property filePath was added to the file variable on jquery.fileupload.js in case the internet browser is IE and the security setting enables
    "Initialize and Script ActiveX controls not marked as safe for scripting"
    so the file size of each uploading file is retrieved correctly, otherwise, "N/A kb" and the Handler.ashx will do another check on the server-side.

    - on appSettings in web.config file has some very important information regarding the Handler.ashx process.
    add key="UploadFilesTempBasePath" value="C:\"
    add key="UploadFilesTempPath" value="docs\jQueryFileUpload\"
    add key="UploadFilesMaximumFileSize" value="100" -- value in KB --
    if you planning on adding more server-side check (i.e. acceptFileTypes , maxNumberOfFiles, etc) it should be added in here and implement the code on Handler.ashx.

    - since IE might won't return the file size, a check is made on Handler.ashx if the browser is IE, and then using the setting on web.config, it will verify if the file size is within the limit.
    Dim maximumFileSize As Integer = ConfigurationManager.AppSettings("UploadFilesMaximumFileSize")
    If hpf.ContentLength >= 0 And (hpf.ContentLength <= maximumFileSize * 1000 Or maximumFileSize = 0) Then

    - on file jquery.fileupload-ui.js the following code was added to retrieve any erros message from Handler.ashx:
    var files = data.result;
    if (files.Value._errorMSG != null) {
    file.error = files.Value._errorMSG;
    }

    - on file jquery.fileupload-ui.js the following code was added to control which files has been uploaded using the jQuery plugin:
    // Adding the files to a TextBox
    AddTxtFileName(data.files[index].name);

Everything else is pretty much the same.

So, feel free to make any changes to run according to your requests.
