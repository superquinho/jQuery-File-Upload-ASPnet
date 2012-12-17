Public Class _Default
    Inherits System.Web.UI.Page

#Region "Generic"

    Private Function GetUserFolderName(ByVal useSessionID As Boolean) As String

        Dim sessionPath As String

        If useSessionID Then
            Dim ss As HttpSessionState = HttpContext.Current.Session
            sessionPath = ss.SessionID
        Else
            sessionPath = DateAndTime.Now.ToString("yyyy_MM_dd-H_mm")
        End If

        Return sessionPath & "_" & System.Guid.NewGuid.ToString()

    End Function

#End Region

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try

            If Not IsPostBack Then

                Session("UserFolder") = GetUserFolderName(False)

            End If

        Catch ex As Exception
            Throw
        End Try

    End Sub

End Class