using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Runtime.Serialization.Json;
using Newtonsoft.Json;
using System.Windows.Forms;

namespace PureExporter
{
    public class SwaggerInfo
    {
        public string description;
        public string title;
        public int version;
    }

    public class SwaggerResponse
    {
        public string swagger;
        public SwaggerInfo info;
        public string basePath;
    }


    public class PureWebrequest

    {

        private Form1 mainForm;
        public PureExporter.JSONRequests.WSResearchOutputsQuery researchOutputQuery;
        public PureExporter.JSONRequests.WSPersonsQuery personQuery;
        private string postData;
        private string PublicationsRequestURL;
        private string PublicationsRequestData;
        private string PersonsRequestURL;
        private string PersonRequestURL;
        private string ExportPath;
        private int ExportSteps;
        private int ExportStep;
        public string exportSetName;
        string _ExportItemsOriginalInImportformat;
        List<string> _ExportItemsOriginal = new List<string>();
        private readonly string _byteOrderMarkUtf8 = Encoding.UTF8.GetString(Encoding.UTF8.GetPreamble());
        private Queue<string> _exportItems = new Queue<string>();

        public PureWebrequest(Form1 form)
        {
            mainForm = form;
            
        }

        public void SetExportPath(string Path)
        {
            ExportPath = Path;
        }

        public void DoWebRequest(String RequestURL, String Function, String Method, String ResultType, String ResultFormat)
        {
            if (Function != "api_processservermeta" && mainForm.Connected == false)
            {
                mainForm.ShowMessage("Not connected to API");
                return;
            }
            mainForm.ProgressBar(true);
            String PubID = mainForm.GetPubIDFromBox();
            WebClient ApiClient = new WebClient();
            ApiClient.Encoding = Encoding.UTF8;
            ApiClient.Headers.Set("api-key", Properties.Settings.Default.APIKey);

            if (Method == "Post")
            {
                switch (ResultType)
                {
                    case "Publications":
                        postData = JsonConvert.SerializeObject(researchOutputQuery, Newtonsoft.Json.Formatting.None,
                        new JsonSerializerSettings
                        {
                            NullValueHandling = NullValueHandling.Ignore,
                            DefaultValueHandling = DefaultValueHandling.Ignore
                        });
                        break;
                    case "Persons":
                        postData = JsonConvert.SerializeObject(personQuery, Newtonsoft.Json.Formatting.None,
                        new JsonSerializerSettings
                        {
                            NullValueHandling = NullValueHandling.Ignore,
                            DefaultValueHandling = DefaultValueHandling.Ignore
                        });
                        break;
                    default:
                        break;
                }
            }
          
            switch (Function)
            {

                case "api_processrestrecord":
                    ApiClient.UploadDataCompleted += new UploadDataCompletedEventHandler(api_processrestrecord);
                    break;
                case "api_processpersoncount":
                    PersonsRequestURL = RequestURL;
                    ApiClient.UploadDataCompleted += new UploadDataCompletedEventHandler(api_processpersoncount);
                    break;
                case "api_processpersons":
                    PersonsRequestURL = RequestURL;
                    ApiClient.UploadDataCompleted += new UploadDataCompletedEventHandler(api_processpersons);
                    break;
                case "api_processpersondetails":
                    PersonRequestURL = RequestURL;
                    ApiClient.DownloadStringCompleted += new DownloadStringCompletedEventHandler(api_processpersondetails);
                    break;
                case "api_processpublicationcount":
                    PublicationsRequestURL = RequestURL;
                    PublicationsRequestData = postData;
                    ApiClient.UploadDataCompleted += new UploadDataCompletedEventHandler(api_processpublicationcount);
                    break;
                case "api_processpublications":
                    PublicationsRequestURL = RequestURL;
                    PublicationsRequestData = postData;
                    ApiClient.UploadDataCompleted += new UploadDataCompletedEventHandler(api_processpublications);
                    break;
                case "api_countorganisations":
                    ApiClient.DownloadStringCompleted += new DownloadStringCompletedEventHandler(api_countorganisations);
                    break;
                case "api_processorganisations":
                    ApiClient.DownloadStringCompleted += new DownloadStringCompletedEventHandler(api_processorganisations);
                    break;
                case "api_processservermeta":
                    ApiClient.DownloadStringCompleted += new DownloadStringCompletedEventHandler(api_processservermeta);
                    break;
                default:
                    break;
            }
            try
            {
                ApiClient.Headers.Set("Accept", "application/"+ResultFormat);

                if (Method == "Get")
                {
                    //ApiClient.Headers.Set("Accept", "application/json");
                    if (Properties.Settings.Default.DebugRequests)
                    mainForm.Debug("request", RequestURL);
                    ApiClient.DownloadStringAsync(new Uri(RequestURL));
                }
                else
                {
                    ApiClient.Headers.Set("Content-Type","application/json");
                    //ApiClient.Headers.Set("Accept", "application/json");
                    //ApiClient.Headers.Set("Content-Length",Data.Length.ToString());
                    mainForm.Debug("request", RequestURL);
                    mainForm.Debug("request", postData);
                    byte[] postArray = Encoding.UTF8.GetBytes(postData);
                    mainForm.ProgressBar(true);
                    ApiClient.UploadDataAsync(new Uri(RequestURL), postArray);
                }
            }
            catch (WebException e1)
            {
                if (e1.Status == WebExceptionStatus.Timeout || e1.Status == WebExceptionStatus.ConnectFailure)
                {
                    mainForm.ShowMessage("There was a problem connecting to the API: " + e1.Message);
         
                }
                else
                {
                    mainForm.ShowMessage("Error Event Fired: " + e1.Message);
                }
                mainForm.ProgressBar(false);
                
            }
        }

        private static void DownloadProgressCallback(object sender, DownloadProgressChangedEventArgs e)
        {
            if (e.BytesReceived == e.TotalBytesToReceive)
            {
                Console.WriteLine();
            }
            // Displays the operation identifier, and the transfer progress.
            /*
            Console.WriteLine("{0}    downloaded {1} of {2} bytes. {3} % complete...",
                (string)e.UserState,
                e.BytesReceived,
                e.TotalBytesToReceive,
                e.ProgressPercentage);
             */
        }

        private static void UploadProgressCallback(object sender, UploadProgressChangedEventArgs e)
        {
            // Displays the operation identifier, and the transfer progress.
            Console.WriteLine("{0}    uploaded {1} of {2} bytes. {3} % complete...",
                (string)e.UserState,
                e.BytesReceived,
                e.TotalBytesToReceive,
                e.ProgressPercentage);
        }

        private void api_processservermeta(object sender, DownloadStringCompletedEventArgs e)
        {
            if (!e.Cancelled && e.Error == null)
            {

                string json = (string)e.Result;
                
                SwaggerResponse response = JsonConvert.DeserializeObject<SwaggerResponse>(json);
                if (response.info.version > 0)
                { 
                    mainForm.SetVersionInfo(response.info.version.ToString());
                    mainForm.Connected = true;
                } 
                else
                {
                    mainForm.ShowMessage("The webservice URL seems incorrect");

                }
            }
            else
            {
                if (e.Error.GetType().Name == "WebException")
                {
                    WebException we = (WebException)e.Error;
                    HttpWebResponse response = (System.Net.HttpWebResponse)we.Response;
                    if (response != null)
                    {
                        mainForm.ShowMessage("The webservice URL seems incorrect: " + response.StatusCode);
                    }
                }
            }
            mainForm.ProgressBar(false);
        }

        private void api_countorganisations(object sender, DownloadStringCompletedEventArgs e)
        {
            if (!e.Cancelled && e.Error == null)
            {
                string json = (string)e.Result;
                ResponseOrganisationalUnits.OrganisationResponse Results = JsonConvert.DeserializeObject<ResponseOrganisationalUnits.OrganisationResponse>(json);
                var RequestURL = Properties.Settings.Default.WebserviceURL + Properties.Settings.Default.APIVersion + "/organisational-units?locale=en_GB&linkingStrategy=documentLinkingStrategy&pageSize=" + Results.count.ToString();
                DoWebRequest(RequestURL, "api_processorganisations", "Get", null,"json");
            }
            else if (e.Cancelled)
            {
                mainForm.ShowMessage("cancelled");
                mainForm.ResetRefreshButton();
                mainForm.ProgressBar(false);
            }
            else if (e.Error != null)
            {
                mainForm.ShowMessage(e.Error.ToString());
                mainForm.Debug("response", e.Error.ToString());
                mainForm.ResetRefreshButton();
                mainForm.ProgressBar(false);
            }
        }



        private void api_processorganisations(object sender, DownloadStringCompletedEventArgs e)
        {
            if (!e.Cancelled && e.Error == null)
            {
                string json = (string)e.Result;
                ResponseOrganisationalUnits.OrganisationResponse Results = JsonConvert.DeserializeObject<ResponseOrganisationalUnits.OrganisationResponse>(json);
               
                mainForm.ClearOrganisations();

                foreach (ResponseOrganisationalUnits.Item organisation in Results.items)
                {

                    String OrgName = organisation.name[0].value;
                    String OrgUUID = organisation.uuid;
                    String OrgType = organisation.type[0].value;
                    String OrgParent = "";
                    if (organisation.parents !=null) {
                        OrgParent = organisation.parents[0].uuid;
                    }
                    mainForm.AddOrganisation(OrgName, OrgUUID, OrgType, OrgParent);
                    mainForm.AddOrganisationTree(OrgName, OrgUUID, OrgType, OrgParent);

                }

                mainForm.refreshOrganisationTree();
            }
            else if (e.Cancelled)
            {
                mainForm.ShowMessage("cancelled");
                mainForm.ResetRefreshButton();
            }
            else if (e.Error != null)
            {
                mainForm.ShowMessage(e.Error.ToString());
                mainForm.Debug("response", e.Error.ToString());
                mainForm.ResetRefreshButton();
            }
            mainForm.ProgressBar(false);
        }

        
        private void api_processpublicationcount(object sender, UploadDataCompletedEventArgs e)
        {

            if (!e.Cancelled && e.Error == null)
            {
                string json = Encoding.Default.GetString(e.Result);
                mainForm.Debug("response", json);
                ResponseResearchOutputs.ResearchOutputResponse Result = JsonConvert.DeserializeObject<ResponseResearchOutputs.ResearchOutputResponse>(json);
                researchOutputQuery.size = Result.count;
                if (Result.count > 1000)
                {
                    DialogResult dialogResult = MessageBox.Show("The query has more than 1000 results, continue?", "Query warning", MessageBoxButtons.YesNo);
                    if(dialogResult == DialogResult.No)
                    {
                        mainForm.ProgressBar(false);
                        return;
                    }
                }
                //researchOutputQuery.fields = new string[] { "title","type" };

                postData = JsonConvert.SerializeObject(researchOutputQuery, Newtonsoft.Json.Formatting.None,
                                new JsonSerializerSettings
                                {
                                    NullValueHandling = NullValueHandling.Ignore,
                                    DefaultValueHandling = DefaultValueHandling.Ignore
                                });
                String RequestURL = PublicationsRequestURL;
                DoWebRequest(RequestURL, "api_processpublications", "Post", postData,"json");
            }
                  
            else
            {
                mainForm.ShowMessage(e.Error.ToString());
                mainForm.Debug("response", e.Error.ToString());
                mainForm.ProgressBar(false);
            }
            
        }

        private void api_processpublications(object sender, UploadDataCompletedEventArgs e)
        {
            if (!e.Cancelled && e.Error == null)
            {
                string json = Encoding.UTF8.GetString(e.Result);
                mainForm.Debug("response", json);
                ResponseResearchOutputs.ResearchOutputResponse Result = JsonConvert.DeserializeObject<ResponseResearchOutputs.ResearchOutputResponse>(json);
                researchOutputQuery.size = Result.count;
              
                mainForm.ClearPublicationTab();
                foreach(ResponseResearchOutputs.Item item in Result.items)
                {
                    for (int i = 0; i < item.type.Length; i++)
                    {
                        if (item.type[i].locale == "en_GB")
                        {
                            mainForm.AddPureDownloadedPublication(item.title, item.uuid, item.type[i].uri);
                            mainForm.AddPureDownloadedPublicationFilter(item.title, item.uuid, item.type[i].uri);
                            mainForm.AddPublicationType(item.type[i].value, item.type[i].uri);
                        }
                        
                    }
                }
              
                mainForm.ResetPublicationsList();
                mainForm.ResetPublicationsFilter();
            }
            mainForm.ProgressBar(false);
        }

        private void api_processpersoncount(object sender, UploadDataCompletedEventArgs e)
        {
            if (!e.Cancelled && e.Error == null)
            {
                mainForm.PersonListReset(false);

                string json = Encoding.Default.GetString(e.Result);
                mainForm.Debug("response", json);
                ResponsePersons.PersonResponse Result = JsonConvert.DeserializeObject<ResponsePersons.PersonResponse>(json);
                personQuery.size = Result.count;
                personQuery.linkingStrategy = "portalLinkingStrategy";
                postData = JsonConvert.SerializeObject(personQuery, Newtonsoft.Json.Formatting.None,
                                new JsonSerializerSettings
                                {
                                    NullValueHandling = NullValueHandling.Ignore,
                                    DefaultValueHandling = DefaultValueHandling.Ignore
                                });
                String RequestURL = PersonsRequestURL;
                DoWebRequest(RequestURL, "api_processpersons", "Post", "Persons","json");
            }
            else
            {
                mainForm.ShowMessage(e.Error.ToString());
                mainForm.Debug("response", e.Error.ToString());
            }


        }

        private void api_processpersons(object sender, UploadDataCompletedEventArgs e)
        {
            if (!e.Cancelled && e.Error == null)
            {
                string json = Encoding.Default.GetString(e.Result);
                mainForm.Debug("response", json);
                
                ResponsePersons.PersonResponse Result = JsonConvert.DeserializeObject<ResponsePersons.PersonResponse>(json);
                personQuery.size = Result.count;
                
                foreach(ResponsePersons.Item Person in Result.items)
                {
                    mainForm.AddPersonList(Person.name.firstName + " " + Person.name.lastName, Person.uuid);
                }
                
                mainForm.PersonListReset(true);
                
            }
            else
            {
                mainForm.ShowMessage(e.Error.ToString());
                mainForm.Debug("response", e.Error.ToString());
            }
            mainForm.ProgressBar(false);
        }

  
        private void api_processpersondetails(object sender, DownloadStringCompletedEventArgs e)
        {
            if (!e.Cancelled && e.Error == null)
            {
                string json = (string)e.Result;
                mainForm.Debug("response", json);
                ResponsePerson.OnePerson person = JsonConvert.DeserializeObject<ResponsePerson.OnePerson>(json);
                string Bio = "";
                if (person.profileInformations != null)
                {
                    foreach (ResponsePerson.Profileinformation pInfo in person.profileInformations)
                    {
                        if (pInfo.typeUri == "/dk/atira/pure/person/customfields/researchinterests")
                        {
                            Bio = pInfo.value;
                        }
                    }
                }
                string PhotoUrl = "";
                string SourceID = "";
                
                if (person.profilePhotos != null)
                {
                    PhotoUrl = person.profilePhotos[0].url;
                }
                if (person.externalableInfo != null)
                {
                    if (person.externalableInfo.sourceId != null)
                    {
                        SourceID = person.externalableInfo.sourceId;
                    }
                }
                if (person.externalableInfo != null)
                {
                    if (person.externalableInfo.sourceId != null)
                    {
                        SourceID = person.externalableInfo.sourceId;
                    }
                }
                string UUID = ""; 
                if (person.uuid != null) {
                    UUID = person.uuid;
                }
                string StartDate = "";
                if (person.employeeStartDate !=null) {
                    StartDate = person.employeeStartDate.ToShortDateString();
                }
                mainForm.UpdatePersonList(UUID, Bio, PhotoUrl, SourceID, StartDate);
                mainForm.PersonResultBox_DisplaySelectedPerson();
                

            }
            else
            {
                mainForm.ShowMessage(e.Error.ToString());
            }
            mainForm.ProgressBar(false);
        }

        private void api_processrestrecord(object sender, UploadDataCompletedEventArgs e)
        {
            if (!e.Cancelled && e.Error == null)
            {
                string XMLInput = Encoding.Default.GetString(e.Result);
                string XMLOutput = DoConversionXSLT(XMLInput);
                if (XMLOutput != "ERROR")
                {
                    mainForm.SetExportboxText(System.Xml.Linq.XDocument.Parse(XMLInput).ToString());
                   
                    if (mainForm.ApplyModifications())
                    {
                        XMLOutput = DoModificationXSLT(XMLOutput);
                    }
                    if (XMLOutput != "ERROR")
                    {
                        try
                        {
                            mainForm.SetImportboxText(System.Xml.Linq.XDocument.Parse(XMLOutput).ToString());
                        }
                        catch (Exception e1)
                        {
                            mainForm.ShowMessage("XSLT error:" + e1.Message);
                            mainForm.ShowMessage(XMLOutput);
                        }
                    }
                }
            }
            mainForm.ProgressBar(false);
        }

        private string DoConversionXSLT(String XMLInput)
        {
            String XMLOutput = "";
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(XMLInput);
            XmlNode root = doc.DocumentElement;
            XmlNamespaceManager nsmgr = new XmlNamespaceManager(doc.NameTable);
            String RecordType = root.SelectSingleNode("//type[@locale='en_GB']/@uri").Value;
            mainForm.SetTypeBox(RecordType);
           
            var myXslTrans = new XslCompiledTransform();
            
            if (Properties.Settings.Default.ConversionXSLTLocation != null && File.Exists(Properties.Settings.Default.ConversionXSLTLocation))
            {
                try
                {
                    myXslTrans.Load(Properties.Settings.Default.ConversionXSLTLocation);

                    using (MemoryStream stream = new MemoryStream())
                    {
                        using (var writer = XmlWriter.Create(stream, myXslTrans.OutputSettings))
                        {
                            myXslTrans.Transform(doc, writer);
                        };

                        var arr = stream.ToArray();
                        XMLOutput = myXslTrans.OutputSettings.Encoding.GetString(arr);
                        if (XMLOutput.StartsWith(_byteOrderMarkUtf8, StringComparison.Ordinal))
                        {
                            XMLOutput = XMLOutput.Remove(0, _byteOrderMarkUtf8.Length);
                        }

                    }

                    
                }
                catch (Exception e1)
                {
                    mainForm.ShowMessage("XSLT error:" + e1.Message);
                    XMLOutput = "ERROR";

                }
            }
            else
            {
                mainForm.ShowMessage("Please provide the location of a valid conversion xslt file on the settings tab.");
                XMLOutput = "ERROR";
                
            }
            return XMLOutput;
        }

        public string DoModificationXSLT(String XMLInput)
        {
            String XMLOutput = "";
            XmlDocument doc = new XmlDocument();
            doc.LoadXml(XMLInput);
            XmlNode root = doc.DocumentElement;
            XmlNamespaceManager nsmgr = new XmlNamespaceManager(doc.NameTable);
           
            var myXslTrans = new XslCompiledTransform();

            if (Properties.Settings.Default.ModificationXSLTLocation != null && File.Exists(Properties.Settings.Default.ModificationXSLTLocation))
            {
                try
                {
                    myXslTrans.Load(Properties.Settings.Default.ModificationXSLTLocation);

                    using (MemoryStream stream = new MemoryStream())
                    {
                        using (var writer = XmlWriter.Create(stream, myXslTrans.OutputSettings))
                        {
                            myXslTrans.Transform(doc, writer);
                        };

                        var arr = stream.ToArray();
                        XMLOutput = myXslTrans.OutputSettings.Encoding.GetString(arr);
                        if (XMLOutput.StartsWith(_byteOrderMarkUtf8, StringComparison.Ordinal))
                        {
                            XMLOutput = XMLOutput.Remove(0, _byteOrderMarkUtf8.Length);
                        }

                    }
                }
                catch (Exception e1)
                {
                    mainForm.ShowMessage("XSLT error:" + e1.Message);
                    XMLOutput = "ERROR";
       
                }
            }
            else
            {
                mainForm.ShowMessage("Please provide the location of a valid modification xslt file on the settings tab.");
       
            }
            return XMLOutput;
        }

        private bool SaveFiles(string Original)
        {
            XmlReader reader = XmlReader.Create(new StringReader(Original));
            XElement root = XElement.Load(reader);
            XmlNameTable nameTable = reader.NameTable;
            XmlNamespaceManager namespaceManager = new XmlNamespaceManager(nameTable);
            IEnumerable<XElement> list = root.XPathSelectElements("//electronicVersions/electronicVersion/file/fileURL", namespaceManager);
            bool thereWereErrors = false;
            foreach (XElement el in list)
            {
                try
                {
                    Uri uri = new Uri(el.Value);
                    string filename = Path.GetFileName(uri.AbsolutePath);
                    if (filename != "")
                    {
                        string saveLoc = ExportPath + "\\Files\\" + filename;
                        WebClient webClient = new WebClient();
                        webClient.DownloadFileAsync(new Uri(el.Value), @saveLoc);
                    }
                    else
                    {
                        mainForm.ShowMessage("URL " + el.Value + " does not seem to be a file link");
                    }
                }
                catch (Exception e1)
                {
                    mainForm.ShowMessage("File download error: " + el.Value.ToString());
                    return false;
                }
            }
            if (thereWereErrors)
            { 
                return false;
            }
            return true;
        }

                    
        private string ModifyUrls(string Original, string setName)
        {

            XmlReader reader = XmlReader.Create(new StringReader(Original));
            XElement root = XElement.Load(reader);
            XmlNameTable nameTable = reader.NameTable;
            XmlNamespaceManager namespaceManager = new XmlNamespaceManager(nameTable);
            IEnumerable<XElement> list = root.XPathSelectElements("//electronicVersions/electronicVersion/file/fileURL", namespaceManager);

            foreach (XElement el in list)
            {
                Uri uri = new Uri(el.Value);
                string filename = Path.GetFileName(uri.AbsolutePath);
                if (filename != "")
                {
                    string newLoc = Properties.Settings.Default.ExportDownloadURL + "/" + setName + "/" + filename;
                    el.Value = newLoc;

                }
                else
                {
                    mainForm.ShowMessage("URL " + el.Value + " does not seem to be a file link");
                }
            }
                return root.ToString();
        }


        private void ExportModifications(string XMLInput)
        {
            string ExportFilePath = ExportPath + "\\" + mainForm.GetExportSetName() + "_importformat_modified.xml";
            if (ExportStep > 1)
            {
                ExportFilePath = ExportPath + "\\" + mainForm.GetExportSetName() + "_importformat_modified " + ExportStep.ToString() + ".xml";
            }

            StreamWriter ExportWriter = new StreamWriter(ExportFilePath);

            ExportWriter.WriteLine(DoModificationXSLT(ModifyUrls(XMLInput, exportSetName)));
            ExportWriter.Close();
        }

  
        public void enqueueExportItem(string Item)
        {
            _exportItems.Enqueue(Item);
        }

        public void exportPublicationSet()
        {
            if (Properties.Settings.Default.ExportDownloadFiles)
            {
                if (Properties.Settings.Default.ExportDownloadURL == "")
                {
                    mainForm.ShowMessage("File download has been enabled but no URL was defined.");
                    mainForm.ProgressBar(false);
                    return;
                }
            }
            // Process output in chunks of 1000
            ExportSteps = (int)Math.Ceiling((double)_exportItems.Count() / (double)1000);
            ExportStep = 1;

            exportOneChunk();
        }

        public void exportOneChunk()
        {
            string RequestURL = Properties.Settings.Default.WebserviceURL + Properties.Settings.Default.APIVersion + "/research-outputs";
            researchOutputQuery = new PureExporter.JSONRequests.WSResearchOutputsQuery();

            List<string> uuidCollection = new List<string>();
            for (int x = 0; x < 1000; x++)
            {
                if (_exportItems.Any())
                {
                    var uuid = _exportItems.Dequeue();
                    uuidCollection.Add(uuid);
                }
            }
            researchOutputQuery.uuids = uuidCollection.ToArray();
            researchOutputQuery.size = uuidCollection.Count;
            
            postData = JsonConvert.SerializeObject(researchOutputQuery, Newtonsoft.Json.Formatting.None,
                       new JsonSerializerSettings
                       {
                           NullValueHandling = NullValueHandling.Ignore,
                           DefaultValueHandling = DefaultValueHandling.Ignore
                       });

            WebClient ApiClient = new WebClient();
            ApiClient.Encoding = Encoding.UTF8;
            ApiClient.Headers.Set("api-key", Properties.Settings.Default.APIKey);
            ApiClient.UploadDataCompleted += new UploadDataCompletedEventHandler(api_processexportchunk);
            ApiClient.Headers.Set("Content-Type","application/json");
            mainForm.Debug("request", RequestURL);
            mainForm.Debug("request", postData);
            byte[] postArray = Encoding.UTF8.GetBytes(postData);
            mainForm.ProgressBar(true);
            ApiClient.UploadDataAsync(new Uri(RequestURL), postArray);
            

        }

        private void api_processexportchunk(object sender, UploadDataCompletedEventArgs e)
        {
            if (!e.Cancelled && e.Error == null)
            {
                string XMLInput = Encoding.Default.GetString(e.Result);

                if (Properties.Settings.Default.ExportDownloadFiles)
                {
                    if (Properties.Settings.Default.ExportDownloadURL == "")
                    {
                        mainForm.ShowMessage("File download has been enabled but no URL was defined.");
                        mainForm.ProgressBar(false);
                        return;
                    }
                    if (SaveFiles(XMLInput))
                    {
                        XMLInput = ModifyUrls(XMLInput, mainForm.GetExportSetName());
                    }
                    else
                    {
                        mainForm.ProgressBar(false);
                        return;
                    }
                }
                
                string XMLOutput = DoConversionXSLT(XMLInput);
                if (XMLOutput != "ERROR")
                {
                    string ExportFilePath = ExportPath + "\\" + mainForm.GetExportSetName() + "_importformat_unmodified.xml";
                    if (ExportStep > 1)
                    {
                        ExportFilePath = ExportPath + "\\" + mainForm.GetExportSetName() + "_importformat_unmodified " + ExportStep.ToString() + ".xml";
                    }
                    StreamWriter ExportWriter = new StreamWriter(ExportFilePath, false);
                    _ExportItemsOriginalInImportformat = XMLOutput;

                    ExportWriter.WriteLine(XMLOutput);
                    ExportWriter.Close();

                    ExportModifications(XMLOutput);
                    if (ExportStep == ExportSteps) 
                    {
                        mainForm.ShowMessage("Saved to " + ExportPath, "Saved XML File", System.Windows.Forms.MessageBoxButtons.OK, System.Windows.Forms.MessageBoxIcon.Information);
                        mainForm.ProgressBar(false);
                    }
                    else
                    {
                        ExportStep +=1;
                        exportOneChunk();
                    }
                }
                else
                {
                    mainForm.ProgressBar(false);
                }
            }
            

        }
        /*
        private void api_processpublicationexport(object sender, UploadDataCompletedEventArgs e)
        {
            if (!e.Cancelled && e.Error == null)
            {
                int fileIncrement = (int)e.UserState;
                mainForm.ShowMessage(fileIncrement.ToString());
                string XMLInput = Encoding.Default.GetString(e.Result);
                if (Properties.Settings.Default.ExportDownloadFiles) {
                    if (Properties.Settings.Default.ExportDownloadURL == "")
                    {
                        mainForm.ShowMessage("File download has been enabled but no URL was defined.");
                        mainForm.ProgressBar(false);
                        return;
                    }
                    if (SaveFiles(XMLInput))
                    {
                        XMLInput = ModifyUrls(XMLInput, mainForm.GetExportSetName());
                    }
                    else
                    {
                        mainForm.ProgressBar(false);
                        return;
                    }
                }
                string XMLOutput = DoConversionXSLT(XMLInput);
                if (XMLOutput != "ERROR")
                {
                    string ExportFilePath = ExportPath + "\\" + mainForm.GetExportSetName() + "_importformat_unmodified.xml";
                    if (fileIncrement > 1)
                    {
                        ExportFilePath = ExportPath + "\\" + mainForm.GetExportSetName() + "_importformat_unmodified " + fileIncrement.ToString() + ".xml";
                    }
                    StreamWriter ExportWriter = new StreamWriter(ExportFilePath,false);
                    _ExportItemsOriginalInImportformat = XMLOutput;

                    ExportWriter.WriteLine(XMLOutput);
                    ExportWriter.Close();

                    ExportModifications(XMLOutput,fileIncrement);
                    mainForm.ShowMessage("Saved to " + ExportPath, "Saved XML File", System.Windows.Forms.MessageBoxButtons.OK, System.Windows.Forms.MessageBoxIcon.Information);
                }
                else
                {
                    mainForm.ProgressBar(false);
                }
            }
            mainForm.ProgressBar(false);
    
        }
        */

        public void InitializeExport()
        {
            _ExportItemsOriginalInImportformat = ""; 
            _ExportItemsOriginal.Clear();
            _exportItems.Clear();
        }
      
        
    }
}
