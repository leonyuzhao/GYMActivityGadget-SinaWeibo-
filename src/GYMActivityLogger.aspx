<%@ Page Language="C#" %>
<%@ Assembly Src="Web.cs" %>

<!DOCTYPE html>

<script runat="server">

  const string cUpdateURL = @"https://api.weibo.com/2/statuses/update.json";
  const string cSuccessRegex = @"""text"":""(.+?)""";
  const string cErrorRegex = @"""error"":""(.+?)""";
  
  protected void Page_Load(object sender, EventArgs e)
  {

  }

  protected void Page_PreRender(object sender, EventArgs e)
  {
    alertDiv.Visible = false;

    if (Page.IsPostBack) 
    {
      // Load necessary variables
      string username = System.Web.Configuration.WebConfigurationManager.AppSettings["username"];
      string password = System.Web.Configuration.WebConfigurationManager.AppSettings["password"];
      string updateURL = System.Web.Configuration.WebConfigurationManager.AppSettings["updateURL"];
      string appkey =System.Web.Configuration.WebConfigurationManager.AppSettings["appkey"];
      string successregex =System.Web.Configuration.WebConfigurationManager.AppSettings["successregex"];
      string errorregex =System.Web.Configuration.WebConfigurationManager.AppSettings["errorregex"];

      if (string.IsNullOrEmpty(updateURL)) { updateURL = cUpdateURL; }
      if (string.IsNullOrEmpty(successregex)) { successregex = cSuccessRegex; }
      if (string.IsNullOrEmpty(errorregex)) { errorregex = cErrorRegex; }

      if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password) || string.IsNullOrEmpty(appkey))
      {
        alertDiv.Visible = true;
        alertDiv.Attributes.Remove("class");
        alertDiv.Attributes.Add("class", "alert alert-danger alert-dismissable");
        alertStr.Text = "<b>Error</b><br />Please set username, password, app key in your web.config file.";
        return;
      }
      
      // Prevent from duplicated submission
      submitBtn.Disabled = true;

      StringBuilder contentBuilder = new StringBuilder();
      contentBuilder.Append(string.Format("#GYM Workout# {0} {1}; {2}; {3}; {4}; {5}; {6}", 
        DateTime.Now.ToShortDateString(),
        cardioSelect.Items[cardioSelect.SelectedIndex].Value,
        (nonCardioRdo.Checked ? "Has " : "No ") + nonCardioRdo.Value,
        (drinkRdo.Checked ? "Has " : "No ") + drinkRdo.Value,
        (fiberRdo.Checked ? "Has " : "No ") + fiberRdo.Value,
        (junkRdo.Checked ? "Has " : "No ") + junkRdo.Value,
        extraRdo.Checked ? "Note: " + extraTxt.Value : ""));

      Utility.Web.HttpContent webContentUpdater = new Utility.Web.HttpContent(username, password);
      string responseContent = webContentUpdater.PostContent(updateURL, string.Format("source={0}&status={1}", appkey, HttpUtility.UrlEncode(contentBuilder.ToString())));

      bool updateSuccess = false;
      string resultStr = string.Empty;
      Regex reg = new Regex(successregex);
      Match match = reg.Match(responseContent);
      if (match.Groups.Count == 2) 
      {
        if (!string.IsNullOrEmpty(match.Groups[1].Value)) 
        {
          updateSuccess = true;
          resultStr = match.Groups[1].Value;
        }
      }
      reg = new Regex(errorregex);
      match = reg.Match(responseContent);
      if (match.Groups.Count == 2)
      {
        if (!string.IsNullOrEmpty(match.Groups[1].Value))
        {
          updateSuccess = false;
          resultStr = match.Groups[1].Value;
        }
      }
      
      alertDiv.Visible = true;
      alertDiv.Attributes.Remove("class");
      if (updateSuccess)
      {
        alertDiv.Attributes.Add("class", "alert alert-success alert-dismissable");
        alertStr.Text  = string.Format("<b>Success</b><br />Posted: '{0}'", resultStr);
        
        // Reset
        cardioSelect.SelectedIndex = 0;
        nonCardioRdo.Checked = false;
        drinkRdo.Checked = false;
        fiberRdo.Checked = false;
        junkRdo.Checked = false;
        extraRdo.Checked = false;
        extraTxt.Value = string.Empty;
      }
      else
      {
        alertDiv.Attributes.Add("class", "alert alert-danger alert-dismissable");
        alertStr.Text = string.Format("<b>Failed</b><br />Error Msg: '{0}'", resultStr);
      }
      
      submitBtn.Disabled = false;
    }
  }

</script>

<html>
<head>
  <title>GYM Activity Logger</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <!-- Latest compiled and minified CSS -->
  <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
  <!-- Optional theme -->
  <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">
</head>
<body>
  <form runat="server">
  <div class="container">
    <div class="header">
      <h3 class="text-muted">
        GYM Activity Logger</h3>
      <hr />
    </div>
    <div class="row marketing">
      <div class="alert alert-success alert-dismissable" id="alertDiv" runat="server">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">
          &times;</button>
        <asp:Literal ID="alertStr" runat="server"></asp:Literal>
      </div>      
      <div class="col-lg-12">
        <select class="form-control" id="cardioSelect" runat="server">
          <option selected="selected">Cardio Not Performed</option>
          <option>Cardio Performed</option>
          <option>Swim</option>
        </select>
        <div class="checkbox">
          <label>
            <input type="checkbox" value="Non-Cardio" id="nonCardioRdo" runat="server">
            Non-Cardio (Weight)
          </label>
        </div>
        <div class="checkbox">
          <label>
            <input type="checkbox" value="Fizzy Drinks" id="drinkRdo" runat="server">
            Fizzy Drinks
          </label>
        </div>
        <div class="checkbox">
          <label>
            <input type="checkbox" value="High Fiber & Protein" id="fiberRdo" runat="server">
            High Fiber & Protein
          </label>
        </div>
        <div class="checkbox">
          <label>
            <input type="checkbox" value="Junk Food" id="junkRdo" runat="server">
            Junk Food
          </label>
        </div>
        <div class="input-group">
          <span class="input-group-addon">
            <input type="checkbox" id="extraRdo" runat="server">
          </span>
          <input type="text" class="form-control" placeholder="Extra Information" id="extraTxt" runat="server">
        </div>
        <!-- /input-group -->
        <br />
        <button type="button" class="btn btn-primary btn-lg btn-block" id="submitBtn" runat="server">
          Submit</button>
      </div>
    </div>
    <div class="footer">
      <hr />
      <p>
        &copy; Leon Yu Zhao 2014</p>
    </div>
  </div>
  <!-- Placed at the end of the document so the pages load faster -->

  <script src="http://cdn.bootcss.com/jquery/1.10.2/jquery.min.js"></script>

  <!-- Latest compiled and minified JavaScript -->

  <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>

  </form>
</body>
</html>

<script language="javascript" type="text/javascript">
// <!CDATA[

  $("#submitBtn").click(function() {
    document.forms[0].submit();
    return false;
  });

// ]]>
</script>


