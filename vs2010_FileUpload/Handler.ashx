<%@ WebHandler Language="VB" Class="Handler" %>

Imports System
Imports System.Web

Public Class Handler : Implements IHttpHandler, IReadOnlySessionState
    
    Public Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        
        Try
            
            Select Case context.Request.HttpMethod
                Case "HEAD"
                Case "GET"
                    If GivenFilename(context) Then
                        DeliverFile(context)
                    End If
                Case "POST"
                    ' ajax calls POST, but it can be a "DELETE" if there is a QueryString on the context
                    If GivenFilename(context) Then
                        DeleteFile(context)
                    Else
                        Uploadfile(context)
                    End If
                    Return

                Case "PUT"
                Case "DELETE"
                    DeleteFile(context)
                    Return

                Case "OPTIONS"
                Case Else
                    context.Response.ClearHeaders()
                    context.Response.StatusCode = 405
                    Return

            End Select
            
        Catch ex As Exception
            Throw
        End Try

    End Sub
    
    Private Sub Uploadfile(ByVal context As HttpContext)

        Dim i As Integer
        Dim r As New Generic.LinkedList(Of ViewDataUploadFilesResult)
        Dim files As String()
        Dim savedFileName As String = String.Empty
        Dim js As New Script.Serialization.JavaScriptSerializer
        
        Try
            
            If context.Request.Files.Count >= 1 Then
                
                Dim maximumFileSize As Integer = ConfigurationManager.AppSettings("UploadFilesMaximumFileSize")
                
                context.Response.ContentType = "text/plain"
                For i = 0 To context.Request.Files.Count - 1
                    Dim hpf As HttpPostedFile
                    Dim FileName As String
                    hpf = context.Request.Files.Item(i)
            
                    If HttpContext.Current.Request.Browser.Browser.ToUpper = "IE" Then
                        files = hpf.FileName.Split(CChar("\\"))
                        FileName = files(files.Length - 1)
                    Else
                        FileName = hpf.FileName
                    End If
            
            
                    If hpf.ContentLength >= 0 And (hpf.ContentLength <= maximumFileSize * 1000 Or maximumFileSize = 0) Then
                
                        savedFileName = StorageRoot(context)
                        
                        savedFileName = savedFileName & FileName
                        
                        hpf.SaveAs(savedFileName)
                
                        r.AddLast(New ViewDataUploadFilesResult(FileName, hpf.ContentLength, hpf.ContentType, savedFileName))
                    
                        Dim uploadedFiles = r.Last
                        Dim jsonObj = js.Serialize(uploadedFiles)
                        context.Response.Write(jsonObj.ToString)
                
                    Else
                        
                        ' File to Big (using IE without ActiveXObject enabled
                        If hpf.ContentLength > maximumFileSize * 1000 Then
                            r.AddLast(New ViewDataUploadFilesResult(FileName, hpf.ContentLength, hpf.ContentType, String.Empty, "maxFileSize"))
                    
                        End If

                        Dim uploadedFiles = r.Last
                        Dim jsonObj = js.Serialize(uploadedFiles)
                        context.Response.Write(jsonObj.ToString)
                        
                    End If
                Next
                
            End If
            
        Catch ex As Exception
            Throw
        End Try

    End Sub
   
    Private Sub DeleteFile(ByVal context As HttpContext)
        Try
            Dim path = StorageRoot(context)
            Dim file = context.Request("f")
            path &= file
            
            If System.IO.File.Exists(path) Then
                System.IO.File.Delete(path)
            End If
            
        Catch ex As Exception
            Throw
        End Try
    End Sub
    
    

    Public ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property
    
#Region "Generic helpers"
    
    Private Function StorageRoot(ByVal context As HttpContext) As String
        Try
            Dim uploadFilesTempBasePath As String = ConfigurationManager.AppSettings("UploadFilesTempBasePath")
            Dim uploadFilesTempPath As String = ConfigurationManager.AppSettings("UploadFilesTempPath")
            Dim initPath As String = uploadFilesTempBasePath & uploadFilesTempPath
            
            ' Add the Session Unique Folder Name
            If context.Session("UserFolder") IsNot Nothing Then
                If (initPath.LastIndexOf("\") <> initPath.Length - 1) Then
                    initPath &= "\"
                End If
                initPath &= context.Session("UserFolder")
            End If
            
            CheckPath(initPath)
            
            Return initPath 
        Catch ex As Exception
            Throw
        End Try
    End Function
    
    Private Sub CheckPath(ByRef serverPath As String)
        Dim initPath As String = String.Empty
        Dim tempPath As String = String.Empty
        Dim folders As String()
        
        Try
            
            folders = serverPath.Split(CChar("\\"))

            ' Save file to a server
            If serverPath.Contains("\\") Then
                initPath = "\\"
            Else
                ' Save file to a local folders
            End If
            
            For i As Integer = 0 To folders.Length - 1
                If tempPath.Trim = String.Empty And _
                folders(i) <> String.Empty Then
                    tempPath = initPath & folders(i)
                ElseIf tempPath.Trim <> String.Empty And _
                folders(i).Trim <> String.Empty Then
                    tempPath = tempPath & "\" & folders(i)
                    
                    ' Doesn't check if it's a network connection
                    If Not tempPath.Contains("\\") And _
                    Not folders(i).Contains("$") Then
                        
                        If Not System.IO.Directory.Exists(tempPath) Then
                            System.IO.Directory.CreateDirectory(tempPath)
                        End If
 
                    Else
                        If Not System.IO.Directory.Exists(tempPath) Then
                            System.IO.Directory.CreateDirectory(tempPath)
                        End If
                        
                    End If
                    
                End If

            Next
            
            serverPath = tempPath & "\"
            
        Catch ex As Exception
            Throw
        End Try
    End Sub
    
    Private Function GivenFilename(ByVal context As HttpContext) As Boolean
        Try
            Return Not String.IsNullOrEmpty(context.Request("f"))
        Catch ex As Exception
            Throw
        End Try
    End Function
    
    Private Sub DeliverFile(ByVal context As HttpContext)
        Try
            Dim file = context.Request("f")
            Dim filePath = StorageRoot(context) + file
            
            If System.IO.File.Exists(filePath) Then
                context.Response.AddHeader("Content-Disposition", "attachment; filename=" + file)
                context.Response.ContentType = "application/octet-stream"
                context.Response.ClearContent()
                context.Response.WriteFile(filePath)
            Else
                context.Response.StatusCode = 404
            End If
            
        Catch ex As Exception
            Throw
        End Try
    End Sub
    
#End Region

End Class

#Region "local Class"

Public Class ViewDataUploadFilesResult
    Public _name As String
    Public _length As Integer
    Public _type As String
    Public _url As String
    Public delete_url As String
    Public delete_type As String
    Public _errorMSG As String

    Sub New()
        Try

        Catch ex As Exception
            Throw
        End Try
    End Sub

    Sub New(ByVal Name As String, ByVal Length As Integer, ByVal Type As String, ByVal URL As String)
        Try
            _name = Name
            _length = Length
            _type = Type
            _url = "Handler.ashx?f=" + Name
            delete_url = "Handler.ashx?f=" + Name
            delete_type = "POST"
        Catch ex As Exception
            Throw
        End Try
    End Sub
    
    Sub New(ByVal Name As String, ByVal Length As Integer, ByVal Type As String, ByVal URL As String, ByVal errorMSG As String)
        Try
            _name = Name
            _length = Length
            _type = Type
            _url = "Handler.ashx?f=" + Name
            delete_url = "Handler.ashx?f=" + Name
            delete_type = "POST"
            _errorMSG = errorMSG
        Catch ex As Exception
            Throw
        End Try
    End Sub

End Class

#End Region
