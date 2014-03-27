using System;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

public partial class _GYMActivityLogger : System.Web.UI.Page
{
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
            string appkey = System.Web.Configuration.WebConfigurationManager.AppSettings["appkey"];
            string successregex = System.Web.Configuration.WebConfigurationManager.AppSettings["successregex"];
            string errorregex = System.Web.Configuration.WebConfigurationManager.AppSettings["errorregex"];

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
                alertStr.Text = string.Format("<b>Success</b><br />Posted: '{0}'", resultStr);

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
}