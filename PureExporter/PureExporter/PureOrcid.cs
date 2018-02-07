using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace PureExporter
{
    public class PureOrcid
    {
        string ProductionURL = "https://pub.orcid.org";
        string SandboxURL = "https://pub.sandbox.orcid.org";
        string TokenPath = "/oauth/token";
        string Token;
        String Authorization_code;

        private Form1 mainForm;
        private string PublicationsRequestURL;
        private string PersonsRequestURL;
        private string PersonRequestURL;
        private string ExportPath;
        Queue<string> _ExportItems = new Queue<string>();
        List<string> _ExportItemsModifiedInImportformat = new List<string>();
        List<string> _ExportItemsOriginalInImportformat = new List<string>();
        List<string> _ExportItemsOriginal = new List<string>();

        public PureOrcid(Form1 form)
        {
            mainForm = form;
            
        }

        [DataContract]
        public class TokenResponse
        {
            [DataMember(Name = "access_token")]
            public string AccessToken { get; set; }
            [DataMember(Name = "token_type")]
            public string TokenType { get; set; }
            [DataMember(Name = "refresh_token")]
            public string RefreshToken { get; set; }
            [DataMember(Name = "expires_in")]
            public string Expires { get; set; }
            [DataMember(Name = "scope")]
            public string Scope { get; set; }
            [DataMember(Name = "orcid")]
            public string Orcid { get; set; }
            
        }

        public static String ConstructQueryString(NameValueCollection parameters)
        {
            List<string> items = new List<string>();

            foreach (string name in parameters)
                items.Add(string.Concat(name, "=", System.Web.HttpUtility.UrlEncode(parameters[name])));

            return string.Join("&", items.ToArray());
        }

        public void Authorize()
        {
            WebClient RestClient = new WebClient();
            RestClient.Encoding = Encoding.UTF8;
            RestClient.Headers.Add("Accept", "application/json");

            NameValueCollection parameters = new NameValueCollection();

            //parameters.Add("client_id", "APP-9HFLCCN84UBQ0NKA");
            //parameters.Add("client_secret", "68fa2a2c-394c-40a2-b9d7-da70368c4c2c");
            parameters.Add("client_id", "APP-01XX65MXBF79VJGF");
            parameters.Add("client_secret", "3a87028d-c84c-4d5f-8ad5-38a93181c9e1");
            
            parameters.Add("grant_type", "client_credentials");
            parameters.Add("scope", "/read-public");
            string TokenRequestURL = SandboxURL + TokenPath;


            //RestClient.DownloadStringCompleted += new DownloadStringCompletedEventHandler(rest_processorcidtoken);
            RestClient.UploadStringCompleted += new UploadStringCompletedEventHandler(rest_processorcidtoken);
            RestClient.UploadStringAsync(new Uri(TokenRequestURL), "POST", ConstructQueryString(parameters));

        }


        public void GetPublicSearchToken()
        {
            WebClient RestClient = new WebClient();
            RestClient.Encoding = Encoding.UTF8;
            RestClient.Headers.Add("Accept", "application/json");
            string TokenRequestURL = SandboxURL + TokenPath;

            System.Collections.Specialized.NameValueCollection formData = new System.Collections.Specialized.NameValueCollection();
            formData["client_id"] = "APP-01XX65MXBF79VJGF";
            formData["client_secret"] = "3a87028d-c84c-4d5f-8ad5-38a93181c9e1";
            formData["grant_type"] = "client_credentials";
            formData["scope"] = "/read-public";
            //byte[] responseBytes = RestClient.UploadValues(TokenRequestURL, "POST", formData);
            byte[] responseBytes = RestClient.UploadValues(TokenRequestURL, "POST", formData);
            MemoryStream stream = new MemoryStream(responseBytes);
            
            //string Result = Encoding.UTF8.GetString(responseBytes);
            DataContractJsonSerializer jsonSerializer = new DataContractJsonSerializer(typeof(TokenResponse));
            object objResponse = jsonSerializer.ReadObject(stream);
            TokenResponse jsonResponse = objResponse as TokenResponse;

            //mainForm.ShowMessage(jsonResponse.AccessToken);

            WebClient SearchClient = new WebClient();
            RestClient.Encoding = Encoding.UTF8;
            RestClient.Headers.Add("Content-Type", "application/orcid+xml");
            RestClient.Headers.Add("Authorization", "Bearer " + jsonResponse.AccessToken);
            string RequestURL = SandboxURL + "/v1.2/search/orcid-bio/?q=eindhoven+AND+university";

            SearchClient.DownloadStringCompleted += new DownloadStringCompletedEventHandler(rest_processsearchresult);
            SearchClient.DownloadStringAsync(new Uri(RequestURL));

            /*
            NameValueCollection parameters = new NameValueCollection();

            parameters.Add("client_id", "APP-9HFLCCN84UBQ0NKA");
            parameters.Add("client_secret", "68fa2a2c-394c-40a2-b9d7-da70368c4c2c");
            parameters.Add("grant_type", "client_credentials");
            parameters.Add("scope", "/read-public");
            string TokenRequestURL = SandboxURL + TokenPath;
          

            //RestClient.DownloadStringCompleted += new DownloadStringCompletedEventHandler(rest_processorcidtoken);
            RestClient.UploadStringCompleted +=new UploadStringCompletedEventHandler(rest_processorcidtoken);
            RestClient.UploadStringAsync(new Uri(TokenRequestURL), "POST", "client_id=APP-9HFLCCN84UBQ0NKA&client_secret=68fa2a2c-394c-40a2-b9d7-da70368c4c2c&grant_type=client_credentials&scope=/read-public");
            */
        }

        private void rest_processsearchresult(object sender, DownloadStringCompletedEventArgs e)
        {
            if (!e.Cancelled && e.Error == null)
            {
                //_PureDownloadedPublications.Clear();
                string textString = (string)e.Result;
                mainForm.ShowMessage(textString);

                XmlDocument doc = new XmlDocument();
                doc.LoadXml(textString);
                XmlNode root = doc.DocumentElement;
                XmlNamespaceManager nsmgr = new XmlNamespaceManager(doc.NameTable);
                nsmgr.AddNamespace("orcid", "http://www.orcid.org/ns/orcid");
                
                XmlNode CountNode = root.SelectSingleNode("descendant::orcid:orcid-search-results", nsmgr);
                int RecordsToFetch = Int32.Parse(CountNode.Attributes["num-found"].Value);
                if (RecordsToFetch > 1)
                {
                    XmlNodeList ResultNodeList = root.SelectNodes("descendant::orcid:orcid-search-result", nsmgr);

                    foreach (XmlNode ResultNode in ResultNodeList)
                    {

                        XmlNode IDNode = ResultNode.SelectSingleNode("descendant::orcid:orcid-identifier/orcid:uri", nsmgr);
                        String ORCiD = IDNode.InnerText;
                        mainForm.ShowMessage(ORCiD);
                        //String UUID = PersonNode.Attributes["uuid"].Value;

                        //mainForm.AddPersonList(Name, UUID);
                        //mainForm.ProgressBarStep();
                    }
                }
                else if (RecordsToFetch == 0)
                {
                    mainForm.ShowMessage("Nothing found");
                }
            }
           
        }


        private void rest_processorcidtoken(object sender, UploadStringCompletedEventArgs e)
        {
            if (!e.Cancelled && e.Error == null)
            {
                string textString = (string)e.Result;
                mainForm.ShowMessage(textString);


            }
            else
            {
                mainForm.ShowMessage(e.Error.ToString());
                if (e.Error.GetType().Name == "WebException")
                {
                    WebException we = (WebException)e.Error;
                    HttpWebResponse response = (System.Net.HttpWebResponse)we.Response;
                    if (response != null)
                    {
                        mainForm.ShowMessage("The orcid token URL seems incorrect: " + response.ToString());
                    }
                }
            }
        }

    }
}
