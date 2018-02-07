using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml;
using System.Web.Script.Serialization;
using System.Collections;
using System.Collections.Specialized;
using System.Runtime.Serialization.Json;
using System.IO;
using Newtonsoft.Json;
using RestSharp;
using System.Xml.Xsl;
using System.Reflection;
using System.Collections.ObjectModel;
using System.Xml.Linq;
using System.Xml.XPath;
using System.Text.RegularExpressions;




namespace PureExporter
{
    public partial class Form1 : Form
    {
        List<PureOrganisation> _PureOrganisations = new List<PureOrganisation>();
        List<PureOrganisation> _PureOrganisationsTree = new List<PureOrganisation>();
        List<String> _CheckedOrganisationNodes = new List<String>();
        List<String> _CheckedPersonNodes = new List<String>();
        List<PurePublicationType> _PurePublicationTypes = new List<PurePublicationType>();
        List<PurePublicationType> _PurePublicationTypeTree = new List<PurePublicationType>();
        List<PurePublication> _PureDownloadedPublications = new List<PurePublication>();
        List<PurePublication> _PureDownloadedPublicationsFiltered = new List<PurePublication>();
        List<PurePerson> _PureDownloadedPersons = new List<PurePerson>();
        List<string> _PublicationFilter_CheckedItems = new List<string>();
        PurePerson SelectedPerson;
        string currentDirectory = Path.GetDirectoryName(Assembly.GetEntryAssembly().Location);
        PureWebrequest ApiHandler;
        public bool Connected;


        public Form1()
        {
            this.FormBorderStyle = FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            
            InitializeComponent();
            ApiHandler = new PureWebrequest(this);
            indeterminateProgressBar.Style = ProgressBarStyle.Marquee;
            ProgressBar(false);
            Connected = false;

            treeView1.CheckBoxes = true;
            treeView1.HideSelection = false;
            PersonResultBox.ItemCheck += new System.Windows.Forms.ItemCheckEventHandler(this.PersonList_ItemCheck);
            treeView1.AfterCheck += node_AfterCheck;
            PublicationsListBox.ItemCheck += new System.Windows.Forms.ItemCheckEventHandler(this.PublicationsList_ItemCheck);

            WebServiceUrlBox.Text = Properties.Settings.Default.WebserviceURL;
            APIVersion.Text = Properties.Settings.Default.APIVersion;
            APIKeyBox.Text = Properties.Settings.Default.APIKey;
            DebugRequests.Checked = Properties.Settings.Default.DebugRequests;
            DebugResponses.Checked = Properties.Settings.Default.DebugResponses;
            PublicationDefinitionTextBox.Text = Properties.Settings.Default.PublicationXSDLocation;
            XSLTConversionTextBox.Text = Properties.Settings.Default.ConversionXSLTLocation;
            XSLTModificationTextBox.Text = Properties.Settings.Default.ModificationXSLTLocation;
            ExportDownloadURL.Text = Properties.Settings.Default.ExportDownloadURL;
            DownloadFilesCheckbox.Checked = Properties.Settings.Default.ExportDownloadFiles;

            GetServerMeta();
            InitializeClient();

        }

        private void InitializeClient()
        {
            if (Properties.Settings.Default.PureOrganisations != null)
            {
                deSerializeOrganisations();
                drawOrganisationTree();
                label8.Text = Properties.Settings.Default.LastOrganisationRefresh;

            }

        }

        public string GetPubIDFromBox()
        {
            return PubIDBox.Text;
        }
        
        public void ShowMessage(string message)
        {
            MessageBox.Show(message);
        }

        public void ShowMessage(string message, string subtitle, MessageBoxButtons Buttons, MessageBoxIcon Icon)
        {
            MessageBox.Show(message, subtitle, Buttons, Icon);
        }

        public void Debug(string purpose, string message)
        {
            if (purpose == "request" && Properties.Settings.Default.DebugRequests)
            {
                DebugTextbox.AppendText(DateTime.Now + " Requesting: " + message + Environment.NewLine);
            }
            else if (purpose == "response" && Properties.Settings.Default.DebugResponses)
            {
                DebugTextbox.AppendText(DateTime.Now + " Receiving: " + message + Environment.NewLine);
            }
        }

        public void SetVersionInfo(string version)
        {
            VersionBox.Text = version;
            //ConnectedToServer = true;
            ConnectedStatus.Text = "✓";
            ConnectedStatus.ForeColor = Color.Green;
            RefreshOrganisationsButton.Enabled = true;
            PersonSearchButton.Enabled = true;
            ConversionXSLTGoButton.Enabled = true;
        }

        private void GetServerMeta()
        {
            //ConnectedToServer = false;
            VersionBox.Text = "";
            ConnectedStatus.Text = "X";
            ConnectedStatus.ForeColor = Color.Red;
            if (Properties.Settings.Default.WebserviceURL != "")
            {
                if (Properties.Settings.Default.WebserviceURL.ToLower().StartsWith("https://") && Properties.Settings.Default.WebserviceURL.ToLower().EndsWith("/ws/api/"))
                {
                    RestUrlBox.Text = Properties.Settings.Default.WebserviceURL;
                    var RequestURL = Properties.Settings.Default.WebserviceURL + Properties.Settings.Default.APIVersion + "/swagger.json";
                    ApiHandler.DoWebRequest(RequestURL, "api_processservermeta", "Get", null, "json");
                }
                else
                {
                    MessageBox.Show("Please enter a correct Pure API url in the settings (https//domain.ext/ws/api/)");
                }
            }
            else
            {
                MessageBox.Show("Please start by setting up a connection to a Pure API url in the settings.");
                tabControl1.SelectTab(5);
            }

        }


        public string ServiceVersion(string url)
        {
            int pos = url.IndexOf("?");
            /*
            if (pos > 0 && Properties.Settings.Default.WebserviceVersion == "current")
            {
                url = url.Insert(pos, ".current");
               
            }
             * */
            return url;
        }

        private void RefreshOrganisationsButton_Click(object sender, EventArgs e)
        {
            var RequestURL = Properties.Settings.Default.WebserviceURL + Properties.Settings.Default.APIVersion + "/organisational-units?locale=en_GB";
            ApiHandler.DoWebRequest(RequestURL, "api_countorganisations", "Get", null,"json");

        }

        public void ResetRefreshButton()
        {
            RefreshOrganisationsButton.Text = "Refresh list";
        }

        public void ClearOrganisations()
        {
            _PureOrganisations.Clear();
            _PureOrganisationsTree.Clear();
            treeView1.Nodes.Clear();
        }

        public void AddOrganisation(string OrgName, string OrgUUID, string OrgType, string OrgParent)
        {
            _PureOrganisations.Add(new PureOrganisation(OrgName, OrgUUID, OrgType, OrgParent));
        }

        public void AddOrganisationTree(string OrgName, string OrgUUID, string OrgType, string OrgParent)
        {
            _PureOrganisationsTree.Add(new PureOrganisation(OrgName, OrgUUID, OrgType, OrgParent));
       
        }


        public void refreshOrganisationTree()
        {
            serializeOrganisations();
            drawOrganisationTree();
            Properties.Settings.Default.LastOrganisationRefresh = DateTime.Now.ToShortDateString() + " " + DateTime.Now.ToShortTimeString();
            Properties.Settings.Default.Save();
            label8.Text = Properties.Settings.Default.LastOrganisationRefresh;
            ResetRefreshButton();

        }

    
        private void drawOrganisationTree()
        {

            treeView1.Nodes.Clear();

            while (_PureOrganisationsTree.Count > 0)
            {
                for (int i = _PureOrganisationsTree.Count - 1; i >= 0; i--)
                {
                    PureOrganisation TreeOrg = _PureOrganisationsTree[i];
                    if (TreeOrg.Parent == "") // top node
                    {
                        treeView1.Nodes.Add(TreeOrg.UUID, TreeOrg.NameType);
                        _PureOrganisationsTree.RemoveAt(i);
                    }
                    else
                    {
                        TreeNode[] pNodes = treeView1.Nodes.Find(TreeOrg.Parent, true);
                        if (pNodes.Length > 0)
                        {
                            pNodes[0].Nodes.Add(TreeOrg.UUID, TreeOrg.NameType);
                            _PureOrganisationsTree.RemoveAt(i);
                        }
                    }

                }
            }
            foreach (TreeNode tn in treeView1.Nodes)
            {
                tn.Expand();
            }
        }

        private void serializeOrganisations()
        {
            if (Properties.Settings.Default.PureOrganisations == null)
            {
                //Properties.Settings.Default.PureOrganisations = new SortedList();
                Properties.Settings.Default.PureOrganisations = new StringCollection();
            }
            else
            {
                Properties.Settings.Default.PureOrganisations.Clear();
            }
            foreach (PureOrganisation organisation in _PureOrganisations)
            {
                string json = JsonConvert.SerializeObject(organisation);
                Properties.Settings.Default.PureOrganisations.Add(json);
            }
            Properties.Settings.Default.Save();
        }

        private void deSerializeOrganisations()
        {
            _PureOrganisations.Clear();
            _PureOrganisationsTree.Clear();
            //foreach (KeyValuePair<string, string> kvp in Properties.Settings.Default.PureOrganisations)
            foreach (String OrganisationString in Properties.Settings.Default.PureOrganisations)
            {
                PureOrganisation Organisation = JsonConvert.DeserializeObject<PureOrganisation>(OrganisationString);
                _PureOrganisations.Add(Organisation);
                _PureOrganisationsTree.Add(Organisation);
            }
        }

        // Updates all child tree nodes recursively.
        private void CheckAllChildNodes(TreeNode treeNode, bool nodeChecked)
        {

            foreach (TreeNode node in treeNode.Nodes)
            {
                node.Checked = nodeChecked;
                if (node.Nodes.Count > 0)
                {
                    // If the current node has child nodes, call the CheckAllChildsNodes method recursively.
                    this.CheckAllChildNodes(node, nodeChecked);
                }
            }
        }


        private void PersonSearchButton_Click(object sender, EventArgs e)
        {
            string RequestURL = Properties.Settings.Default.WebserviceURL + Properties.Settings.Default.APIVersion + "/persons";
            ApiHandler.personQuery = new PureExporter.JSONRequests.WSPersonsQuery();
            ApiHandler.personQuery.searchString = PersonSearchBox.Text;
            ApiHandler.DoWebRequest(RequestURL, "api_processpersoncount","Post","Persons","json");
        }

        private void PersonSearchBox_keyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                PersonSearchButton_Click(this, new EventArgs());
            }

        }

        private void MainSearchButton_Click(object sender, EventArgs e)
        {
            string RequestURL = Properties.Settings.Default.WebserviceURL + Properties.Settings.Default.APIVersion + "/research-outputs";
            ApiHandler.researchOutputQuery = new PureExporter.JSONRequests.WSResearchOutputsQuery();
            ApiHandler.researchOutputQuery.searchString = MainSearchTextBox.Text;
            ApiHandler.DoWebRequest(RequestURL, "api_processpublicationcount", "Post", "Publications", "json");
        }

        private void MainSearchBox_keyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                MainSearchButton_Click(this, new EventArgs());
            }

        }


        private void PersonResultBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            int selectedIndex = PersonResultBox.SelectedIndex;
            if (selectedIndex > -1)
            {
                SelectedPerson = _PureDownloadedPersons[selectedIndex];
                if (SelectedPerson.UUID != "")
                {
                    string RequestURL = Properties.Settings.Default.WebserviceURL + Properties.Settings.Default.APIVersion + "/persons/" + SelectedPerson.UUID;
                    ApiHandler.DoWebRequest(RequestURL, "api_processpersondetails","Get","Persons","json");
                }
            }
        }

        public void UpdatePersonList(string UUID, string Bio, string PhotoUrl, string SourceID, string StartDate)
        {
            int index = _PureDownloadedPersons.IndexOf(_PureDownloadedPersons.Where(p => p.UUID == UUID).FirstOrDefault());
            if (index > -1)
            {
                PurePerson UpdatePerson = _PureDownloadedPersons[index];
                UpdatePerson.Update(Bio, PhotoUrl, "", SourceID, StartDate);
            }
        }


        public void PersonResultBox_DisplaySelectedPerson()
        {
            SelectedPersonName.Text = SelectedPerson.Name;
            SelectedPersonUUID.Text = SelectedPerson.UUID;
            SelectedPersonBio.DocumentText = "<span style='font-family: Arial; font-size:12px;'>"+SelectedPerson.Bio+"</span>";
            SelectedPersonPhoto.SizeMode = PictureBoxSizeMode.Zoom;
            SelectedPersonPhoto.ImageLocation = SelectedPerson.PhotoUrl;
            SelectedPersonSourceID.Text = SelectedPerson.SourceID;
            SelectedPersonStartDate.Text = SelectedPerson.StartDate;
        }

        public void PersonListReset(bool ButtonActive)
        {
            PeoplePubSaveButton.Enabled = ButtonActive;

            if (ButtonActive == false)
            {
                _PureDownloadedPersons.Clear();
                _CheckedPersonNodes.Clear();
                PersonResultBox.DataSource = null;
                PersonResultBox.Items.Clear();
                PeoplePubSaveButton.Enabled = ButtonActive;
            }
            else
            {
                PersonResultBox.DataSource = _PureDownloadedPersons;
                PersonResultBox.DisplayMember = "Name";
                PersonResultBox.ValueMember = "UUID";
                if (_PureDownloadedPersons.Count > 0)
                {
                    PeoplePubSaveButton.Enabled = true;
                }
            }
        }

        public void AddPersonList(string Name, string UUID)
        {
            _PureDownloadedPersons.Add(new PurePerson(Name, UUID));
        }

        public void AddPersonList(string Name, string UUID, string TUEID, string PhotoUrl, string Type)
        {
            _PureDownloadedPersons.Add(new PurePerson(Name, UUID, TUEID, PhotoUrl, Type));
        }

        private void PersonList_ItemCheck(object sender, ItemCheckEventArgs e)
        {
            this.BeginInvoke((MethodInvoker)(
            () => PersonsSelectedCountBox.Text = CountSelectedPersons().ToString()));
        }

        private int CountSelectedPersons()
        {
            int c = 0;
            _CheckedPersonNodes.Clear();

            for (int i = 0; i < PersonResultBox.Items.Count; i++)
            {
                if (PersonResultBox.GetItemChecked(i) == true)
                {
                    c++;
                    PurePerson SelectedPerson = (PurePerson)PersonResultBox.Items[i];
                    _CheckedPersonNodes.Add(SelectedPerson.UUID);
                }
            }
            
            if (_CheckedPersonNodes.Count > 0)
            {
                PeoplePubSaveButton.Enabled = true;
            }
            else
            {
                PeoplePubSaveButton.Enabled = false;
            }

            return c;
        }

        private void person_AfterCheck(object sender, TreeViewEventArgs e)
        {
            // The code only executes if the user caused the checked state to change.
            if (e.Action != TreeViewAction.Unknown)
            {
                if (e.Node.Nodes.Count > 0)
                {
                    /* Calls the CheckAllChildNodes method, passing in the current 
                    Checked value of the TreeNode whose checked state changed. */

                    this.CheckAllChildNodes(e.Node, e.Node.Checked);
                }
            }
            this.GetSelectedNodes();
            label5.Text = _CheckedOrganisationNodes.Count.ToString();
            if (_CheckedOrganisationNodes.Count > 0)
            {
                OrgPubSaveButton.Enabled = true;
            }
            else
            {
                OrgPubSaveButton.Enabled = false;
            }
        }

        private void node_AfterCheck(object sender, TreeViewEventArgs e)
        {
            // The code only executes if the user caused the checked state to change.
            if (e.Action != TreeViewAction.Unknown)
            {
                if (e.Node.Nodes.Count > 0)
                {
                    /* Calls the CheckAllChildNodes method, passing in the current 
                    Checked value of the TreeNode whose checked state changed. */

                    this.CheckAllChildNodes(e.Node, e.Node.Checked);
                }
            }
            this.GetSelectedNodes();
            label5.Text = _CheckedOrganisationNodes.Count.ToString();
            if (_CheckedOrganisationNodes.Count > 0)
            {
                OrgPubSaveButton.Enabled = true;
            }
            else
            {
                OrgPubSaveButton.Enabled = false;
            }
        }

        private void GetSelectedNodes()
        {
            _CheckedOrganisationNodes.Clear();

            foreach (TreeNode node in treeView1.Nodes)
            {
                if (node.Nodes.Count > 0)
                {
                    this.GetSelectedChildNodeName(node);
                }
                if (node.Checked)
                {
                    _CheckedOrganisationNodes.Add(node.Name);
                }
            }
        }

        private void GetSelectedChildNodeName(TreeNode ParentNode)
        {
            foreach (TreeNode node in ParentNode.Nodes)
            {
                if (node.Nodes.Count > 0)
                {
                    this.GetSelectedChildNodeName(node);
                }
                if (node.Checked)
                {
                    _CheckedOrganisationNodes.Add(node.Name);
                }
            }
        }

        private void OrgSearchBox_TextChanged(object sender, EventArgs e)
        {
            String SearchText = OrgSearchBox.Text;

            if (SearchText.Length == 36)
            {
                treeView1.CollapseAll();
                TreeNode[] n = treeView1.Nodes.Find(SearchText, true);
                if (n.Length > 0)
                {
                    foreach (TreeNode p in n)
                    {
                        treeView1.SelectedNode = p;
                        treeView1.Focus();
                        if (p.Parent != null)
                        {
                            p.Parent.Expand();
                            treeView1.SelectedNode.EnsureVisible();
                        }
                    }
                }
            }
            else
            {
            }

        }

        private void UpdatePublicationCounters()
        {
            PubSelCountLabel.Text = PublicationsListBox.CheckedItems.Count.ToString();
            PubFiltCountLabel.Text = _PureDownloadedPublicationsFiltered.Count.ToString();
            PubTotalCountLabel.Text = _PureDownloadedPublications.Count.ToString();
        }

        private void ClearPublicationsButton_Click(object sender, EventArgs e)
        {
            ClearPublicationTab();
        }

        public void ClearPublicationTab()
        {
            _PureDownloadedPublications.Clear();
            _PureDownloadedPublicationsFiltered.Clear();
            _PublicationFilter_CheckedItems.Clear();
            _PurePublicationTypes.Clear();
            PublicationsFilter.DataSource = null;
            PublicationsListBox.DataSource = null;
            PublicationsListBox.Items.Clear();
            tabControl1.TabPages[2].Text = "Publications";
            UpdatePublicationCounters();

        }

        private void GetPublicationCount(string purpose)
        {

            string RequestURL = Properties.Settings.Default.WebserviceURL + Properties.Settings.Default.APIVersion + "/research-outputs";

            ApiHandler.researchOutputQuery = new PureExporter.JSONRequests.WSResearchOutputsQuery();
         
            if (purpose == "organisation")
            {
                ApiHandler.researchOutputQuery.forOrganisationalUnits = new PureExporter.JSONRequests.WSOrganisationsQuery();
            
                List<string> orgCollection = new List<string>();

                foreach (String UUID in _CheckedOrganisationNodes)
                {
                    orgCollection.Add(UUID);
                }

                ApiHandler.researchOutputQuery.forOrganisationalUnits.uuids = orgCollection.ToArray();
                ApiHandler.researchOutputQuery.forOrganisationalUnits.size = orgCollection.Count;
                ApiHandler.DoWebRequest(RequestURL, "api_processpublicationcount", "Post","Publications","json");

            }
            if (purpose == "person")
            {
                
                ApiHandler.researchOutputQuery.forPersons = new PureExporter.JSONRequests.WSPersonsQuery();

                List<string> personCollection = new List<string>();

                foreach (String UUID in _CheckedPersonNodes)
                {
                    personCollection.Add(UUID);
                }

                ApiHandler.researchOutputQuery.forPersons.uuids = personCollection.ToArray();
                ApiHandler.researchOutputQuery.forPersons.size = personCollection.Count;

                ApiHandler.DoWebRequest(RequestURL, "api_processpublicationcount", "Post","Publications","json");

            }


        }
        /*
        public void ClearPublicationTypes()
        {
            _PurePublicationTypes.Clear();
        }
         * */

        public void AddPublicationType(string Name, string TypeUri)
        {
            int index = _PurePublicationTypes.FindIndex(f => f.Uri == TypeUri);
            if (index == -1)
            {
                _PurePublicationTypes.Add(new PurePublicationType(Name, TypeUri));
            }
        }
        
        public void ResetPublicationsFilter()
        {
            PublicationsFilter.DataSource = _PurePublicationTypes;
            PublicationsFilter.DisplayMember = "Name";
            PublicationsFilter.ValueMember = "Uri";

            _PublicationFilter_CheckedItems.Clear();

            for (int i = 0; i < PublicationsFilter.Items.Count; i++)
            {
                PublicationsFilter.SetItemChecked(i, true);
                PurePublicationType selectedType = (PurePublicationType)PublicationsFilter.Items[i];
                _PublicationFilter_CheckedItems.Add(selectedType.Uri);
            }
            this.PublicationsFilter.ItemCheck += new System.Windows.Forms.ItemCheckEventHandler(this.PublicationsFilter_ItemCheck);
        }

      
        private void PublicationsFilter_ItemCheck(object sender, ItemCheckEventArgs e)
        {
            
            _PureDownloadedPublicationsFiltered.Clear();
            PurePublicationType selectedType = (PurePublicationType)PublicationsFilter.Items[e.Index];

            if (e.NewValue == CheckState.Checked)
            {
                _PublicationFilter_CheckedItems.Add(selectedType.Uri);

            }
            else {
                _PublicationFilter_CheckedItems.Remove(selectedType.Uri);

            }
  
            foreach (PurePublication Pub in _PureDownloadedPublications)
            {
                if (_PublicationFilter_CheckedItems.Contains(Pub.Type))
                {
                    _PureDownloadedPublicationsFiltered.Add(Pub);
                }
            }
            ResetPublicationsList();
        }

        public void ResetPublicationsList()
        {
            PublicationsListBox.DataSource = null;
            PublicationsListBox.DataSource = _PureDownloadedPublicationsFiltered;
            PublicationsListBox.DisplayMember = "Title";
            PublicationsListBox.ValueMember = "UUID";
            tabControl1.TabPages[2].Text = "Publications (0/" + _PureDownloadedPublications.Count.ToString() + ")";
            UpdatePublicationCounters();
        }

        public void AddPureDownloadedPublication(string PubTitle, string PubUUID, string PubType)
        {
            _PureDownloadedPublications.Add(new PurePublication(PubTitle, PubUUID, PubType));
        }

        public void AddPureDownloadedPublicationFilter(string PubTitle, string PubUUID, string PubType)
        {
            _PureDownloadedPublicationsFiltered.Add(new PurePublication(PubTitle, PubUUID, PubType));
        }


        public void SetExportboxText(string text)
        {
            ExportBox.Text = text;
        }

        public void SetImportboxText(string text)
        {
            ImportBox.Text = text;
        }

        public string GetImportboxText()
        {
            return ImportBox.Text;
        }

        private void XSLTGoButton_Click(object sender, EventArgs e)
        {

            if (PubIDBox.Text == null || PubIDBox.Text == "")
            {
                MessageBox.Show("Please enter a publication ID");
                return;

            }

            XSLTSearchBox.Text = "";
            XSLTExportSearchBoxResult.Text = "";

            string PubID = PubIDBox.Text;
            List<string> PubIdCollection = new List<string>();
            PubIdCollection.Add(PubID);

            string RequestURL = Properties.Settings.Default.WebserviceURL + Properties.Settings.Default.APIVersion + "/research-outputs";

            ApiHandler.researchOutputQuery = new PureExporter.JSONRequests.WSResearchOutputsQuery();
            ApiHandler.researchOutputQuery.uuids = PubIdCollection.ToArray();
            ApiHandler.researchOutputQuery.size = 1;
            ApiHandler.DoWebRequest(RequestURL, "api_processrestrecord", "Post", "Publications", "xml");
        }

        public bool ApplyModifications()
        {
            if (ApplyModificationsCheckbox.Checked)
            {
                return true;
            }
            return false;
        }


        private void SaveSettingsButton_Click(object sender, EventArgs e)
        {
            Properties.Settings.Default.WebserviceURL = WebServiceUrlBox.Text;
            Properties.Settings.Default.APIVersion = APIVersion.Text;
            Properties.Settings.Default.APIKey = APIKeyBox.Text;
            Properties.Settings.Default.DebugRequests = DebugRequests.Checked;
            Properties.Settings.Default.DebugResponses = DebugResponses.Checked;
            Properties.Settings.Default.ExportDownloadFiles = DownloadFilesCheckbox.Checked;
            Properties.Settings.Default.ExportDownloadURL = ExportDownloadURL.Text;
            if (DownloadFilesCheckbox.Checked && ExportDownloadURL.Text == "")
            {
                ShowMessage("A download URL must be specified when enabling file downloads.");
            }
      
            Properties.Settings.Default.Save();
            GetServerMeta();
            InitializeClient();
            ClearPublicationTab();
            ClearOrganisations();
        }


            private void ConversionSearchButton_Click(object sender, EventArgs e)

        {
            if (XSLTSearchBox.Text == "" || XSLTSearchBox.Text.Length < 3)
            {
                ShowMessage("Please enter a search term of at least 3 characters.");
                return;
            }

            int index = 0;
            int occurrence = 0;
            while (index < ExportBox.Text.LastIndexOf(XSLTSearchBox.Text))
            {
                ExportBox.Find(XSLTSearchBox.Text, index, ExportBox.TextLength, RichTextBoxFinds.None);
                ExportBox.SelectionBackColor = Color.Yellow;
                index = ExportBox.Text.IndexOf(XSLTSearchBox.Text, index) + 1;
                occurrence = new Regex(XSLTSearchBox.Text).Matches(ExportBox.Text).Count;
            }

            if ( occurrence == 0)//if the givn search string don't match at any time
            {
                XSLTExportSearchBoxResult.Text = "No match found in export";
            }
            XSLTExportSearchBoxResult.Text =  occurrence.ToString() + " matches found in export";//show the number of occurence into the text box

            index = 0;
            occurrence = 0;
            while (index < ImportBox.Text.LastIndexOf(XSLTSearchBox.Text))
            {
                ImportBox.Find(XSLTSearchBox.Text, index, ImportBox.TextLength, RichTextBoxFinds.None);
                ImportBox.SelectionBackColor = Color.Yellow;
                index = ImportBox.Text.IndexOf(XSLTSearchBox.Text, index) + 1;
                occurrence = new Regex(XSLTSearchBox.Text).Matches(ImportBox.Text).Count;
            }

            if (occurrence == 0)//if the givn search string don't match at any time
            {
                XSLTImportSearchBoxResult.Text = "No match found in import";
            }
            XSLTImportSearchBoxResult.Text = occurrence.ToString() + " matches found in import";//show the number of occurence into the text box
            
        }

        private void SingleExportButton_Click(object sender, EventArgs e)
        {
           
            FolderBrowserDialog fbd = new FolderBrowserDialog();
            if (fbd.ShowDialog() == DialogResult.OK)
            {
                // create a writer and open the file
                TextWriter tw = new StreamWriter(fbd.SelectedPath + "\\" + PubIDBox.Text + ".xml");
                tw.WriteLine(ImportBox.Text);
                tw.Close();
                MessageBox.Show("Saved to " + fbd.SelectedPath + "\\" + PubIDBox.Text + ".xml", "Saved XML File", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }

        private void EmailLinkLabel_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            EmailLinkLabel.LinkVisited = true;
            System.Diagnostics.Process.Start("mailto:n.veenstra@tue.nl");
        }

        private void OrgPubSaveButton_Click(object sender, EventArgs e)
        {
            if (_PureDownloadedPublications.Count > 0)
            {
                DialogResult result = MessageBox.Show("Publication list is not empty. \nClear publicationlist first?", "Save publications",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Question,
                    MessageBoxDefaultButton.Button2);

                if (result == DialogResult.Yes)
                {
                    ClearPublicationTab();
                }
            }

            GetPublicationCount("organisation");
        }

        private void PeoplePubSaveButton_Click(object sender, EventArgs e)
        {
            if (_PureDownloadedPublications.Count > 0)
            {
                DialogResult result = MessageBox.Show("Publication list is not empty. \nClear publicationlist first?", "Save publications",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Question,
                    MessageBoxDefaultButton.Button2);

                if (result == DialogResult.Yes)
                {
                    ClearPublicationTab();
                }
            }
            if (_CheckedPersonNodes.Count > 0)
            {
                GetPublicationCount("person");
            }
            else
            {
                MessageBox.Show("Please select one or more authors first.");
            }
        }


        private void PublicationListToggleButton_Click(object sender, EventArgs e)
        {
            int c = 0;
            for (int i = 0; i < PublicationsListBox.Items.Count; i++)
            {
                if (PublicationsListBox.GetItemChecked(i))
                {
                    PublicationsListBox.SetItemChecked(i, false);
                }
                else
                {
                    PublicationsListBox.SetItemChecked(i, true);
                    c++;
                }
            }
            tabControl1.TabPages[2].Text = "Publications ("+c.ToString()+ "/" + _PureDownloadedPublications.Count.ToString() + ")"; 
        }

        private void PublicationsList_ItemCheck(object sender, ItemCheckEventArgs e)
        {
            this.BeginInvoke((MethodInvoker)(
            () => PubSelCountLabel.Text = CountSelectedPublications().ToString()));
        }

        private int CountSelectedPublications()
        {
            int c = 0;
            for (int i = 0; i < PublicationsListBox.Items.Count; i++)
            {
                if (PublicationsListBox.GetItemChecked(i) == true)
                {
                    c++;
                }
            }
            tabControl1.TabPages[2].Text = "Publications (" + c.ToString() + "/" + _PureDownloadedPublications.Count.ToString() + ")"; 
            return c;
        }

        public void SetTypeBox(string text)
        {
            TypeBox.Text = text;
        }

        public string GetExportSetName()
        {
            return MultiExportSetNameBox.Text;
        }
      
        private void Exportbutton_Click(object sender, EventArgs e)
        {

            ApiHandler.InitializeExport();

            if (MultiExportSetNameBox.Text.IndexOfAny(Path.GetInvalidFileNameChars()) >= 0)
            {
                MessageBox.Show("The export set name contains invalid characters");
                return;
            }

            if (PubSelCountLabel.Text == "0")
            {
                MessageBox.Show("Please select one or more publications first");
                return;
            }
            if (MultiExportSetNameBox.Text == "")
            {
                MessageBox.Show("Please enter a name for the export set");
                return;
            }
            FolderBrowserDialog fbd = new FolderBrowserDialog();
            if (fbd.ShowDialog() == DialogResult.OK)
            {

                int c = 0;
                ApiHandler.exportSetName = MultiExportSetNameBox.Text;
                string ExportPath = fbd.SelectedPath + "\\" + MultiExportSetNameBox.Text;
                ApiHandler.SetExportPath(ExportPath);
                //string ExportPathOriginals = ExportPath + "\\Originals";
                string ExportPathFiles = ExportPath + "\\Files";

                if (Directory.Exists(ExportPath))
                {
                    MessageBox.Show("Folder:\n" + ExportPath+ "\n already exists.");
                    return;
                }
                DirectoryInfo di = Directory.CreateDirectory(ExportPath);
                //DirectoryInfo dio = Directory.CreateDirectory(ExportPathOriginals);
                DirectoryInfo dif = Directory.CreateDirectory(ExportPathFiles);

                for (int i = 0; i <PublicationsListBox.Items.Count; i++)
                {
                    if (PublicationsListBox.GetItemChecked(i)) 
                    {
                        PurePublication SelectedPublication = (PurePublication)PublicationsListBox.Items[i];
                        ApiHandler.enqueueExportItem(SelectedPublication.UUID);
                    }
                }
                ApiHandler.exportPublicationSet();
            }
        }

                        
    
                            
                            //ApiHandler.EnqueueExportItem(SelectedPublication.UUID);

                //string RequestURL = Properties.Settings.Default.WebserviceURL + Properties.Settings.Default.APIVersion + "/research-outputs";
                //ApiHandler.researchOutputQuery = new PureExporter.JSONRequests.WSResearchOutputsQuery();


                /*

                // Process output in chunks of 1000
                int exportSteps = (int)Math.Ceiling((double)PublicationsListBox.Items.Count / (double)1000);

                for (int step = 1; step <= exportSteps; step += 1)
                {
                    ApiHandler.researchOutputQuery = new PureExporter.JSONRequests.WSResearchOutputsQuery();
                    List<string> pubCollection = new List<string>();

                    //for (int i = 0; i < PublicationsListBox.Items.Count; i++)

                    int loopStart = ((step*1000)-1000);
                    int loopLimit = 0;
                    if (step == exportSteps)
                    {
                        loopLimit = PublicationsListBox.Items.Count-1;
                    }
                    else
                    {
                        loopLimit = ((step * 1000) - 1);
                    }
                    //ShowMessage("export step " + step + " of " + exportSteps + " start " + loopStart + " limit " + loopLimit);
                    for (int i = loopStart; i <= loopLimit; i++)
                    {
                        if (PublicationsListBox.GetItemChecked(i))
                        {
                            PurePublication SelectedPublication = (PurePublication)PublicationsListBox.Items[i];
                            //ApiHandler.EnqueueExportItem(SelectedPublication.UUID);
                            pubCollection.Add(SelectedPublication.UUID);
                            c++;
                        }
                    }

                    ApiHandler.researchOutputQuery.uuids = pubCollection.ToArray();
                    ApiHandler.researchOutputQuery.size = pubCollection.Count;
                    // Starts the download
                    ProgressBar(true);
                    ApiHandler.DoWebRequest(RequestURL, "api_processpublicationexport", "Post", "Publications", "xml");
                }
                 */

        public void ProgressBar(bool On)
        {
            if (On)
            {
                indeterminateProgressBar.MarqueeAnimationSpeed = 30;
            }
            else
            {
                indeterminateProgressBar.MarqueeAnimationSpeed = 0;
                indeterminateProgressBar.Refresh();

            }
        }

    
         private void ShowInRecordConversionButton_Click(object sender, EventArgs e)
        {
            if (PublicationsListBox.SelectedItem != null)
            {
                PurePublication SelectedPublication = (PurePublication)PublicationsListBox.SelectedItem;
                PubIDBox.Text = SelectedPublication.UUID;
                tabControl1.SelectTab(3);
                ConversionXSLTGoButton.PerformClick();
            }
            else 
            {
                MessageBox.Show("Please select a record from the list");
            }
        }


        private void SelectedPersonBio_DocumentCompleted(object sender, WebBrowserDocumentCompletedEventArgs e)
        {

        }

        private void Conversion_XSLT_Import_Click(object sender, EventArgs e)
        {
            OpenFileDialog XSLTDialog = new OpenFileDialog();
            XSLTDialog.Title = "Import XSLT File";
            XSLTDialog.Filter = "XSLT files|*.xslt";
            string CombinedPath = System.IO.Path.Combine(Directory.GetCurrentDirectory(), "..\\Conversion definitions");
            XSLTDialog.InitialDirectory = System.IO.Path.GetFullPath(CombinedPath);
            if (XSLTDialog.ShowDialog() == DialogResult.OK)
            {
                XSLTConversionTextBox.Text = XSLTDialog.FileName.ToString();
                Properties.Settings.Default.ConversionXSLTLocation = XSLTDialog.FileName.ToString();

            }

        }

        private void Modification_XSLT_Import_Click(object sender, EventArgs e)
        {
            OpenFileDialog XSLTDialog = new OpenFileDialog();
            XSLTDialog.Title = "Import XSLT File";
            XSLTDialog.Filter = "XSLT files|*.xslt";
            string CombinedPath = System.IO.Path.Combine(Directory.GetCurrentDirectory(), "..\\Conversion definitions");
            XSLTDialog.InitialDirectory = System.IO.Path.GetFullPath(CombinedPath);
            if (XSLTDialog.ShowDialog() == DialogResult.OK)
            {
                XSLTModificationTextBox.Text = XSLTDialog.FileName.ToString();
                Properties.Settings.Default.ModificationXSLTLocation = XSLTDialog.FileName.ToString();

            }

        }

        private void PublicationDefinitionImportButton_Click(object sender, EventArgs e)
        {
            OpenFileDialog PubDialog = new OpenFileDialog();
            PubDialog.Title = "Import XSD File";
            PubDialog.Filter = "XSD files|*.xsd";
            string CombinedPath = System.IO.Path.Combine(Directory.GetCurrentDirectory(), "..\\Conversion definitions");
            PubDialog.InitialDirectory = System.IO.Path.GetFullPath(CombinedPath);
            if (PubDialog.ShowDialog() == DialogResult.OK)
            {
                PublicationDefinitionTextBox.Text = PubDialog.FileName.ToString();
                Properties.Settings.Default.PublicationXSDLocation = PubDialog.FileName.ToString();

            }
        }

        private void VerifyConversionButton_Click(object sender, EventArgs e)
        {
            if ((Properties.Settings.Default.PublicationXSDLocation == "") || (Properties.Settings.Default.ConversionXSLTLocation == ""))
            {
                MessageBox.Show("Please set both the conversion xslt and publication xsd file locations on the settings tab");
            }
            else
            {
                parsePublicationsXSD();
                drawConversionTree();
            }
        }

        private void parsePublicationsXSD()
        {
            _PurePublicationTypeTree.Clear();

            string fileContents;
            using (StreamReader streamReader = new StreamReader(Properties.Settings.Default.PublicationXSDLocation, Encoding.UTF8))
            {
                fileContents = streamReader.ReadToEnd();
            }

            try
            {


                XmlReader reader = XmlReader.Create(new StringReader(fileContents));
                XElement root = XElement.Load(reader);
                XmlNameTable nameTable = reader.NameTable;
                XmlNamespaceManager namespaceManager = new XmlNamespaceManager(nameTable);
                namespaceManager.AddNamespace("xs", "http://www.w3.org/2001/XMLSchema");

                List<string> AbstractElementList = new List<string>();
                List<string> PublicationList = new List<string>();
                IEnumerable<XElement> AbstractElements = root.XPathSelectElements("//xs:complexType[@name='publicationType' and @abstract='true']/xs:sequence/xs:element", namespaceManager);
                foreach (XElement el in AbstractElements)
                {
                    if (el.Attribute("name") != null)
                    {
                        String Element = el.Attribute("name").Value;
                        AbstractElementList.Add(Element);
                    }
                    else if (el.Attribute("ref") != null)
                    {
                        String Element = el.Attribute("ref").Value;
                        AbstractElementList.Add(Element);
                    }
                }

                IEnumerable<XElement> PublicationTypes = root.XPathSelectElements("//xs:element[@name='publications']/xs:complexType/xs:choice/xs:element", namespaceManager);
                foreach (XElement el in PublicationTypes)
                {
                    String PubTypeName = el.Attribute("ref").Value;
                    PublicationList.Add(PubTypeName + "Type"); //eigenlijk opzoeken
                }

                IEnumerable<XElement> PublicationComplexTypes = root.XPathSelectElements("//xs:complexType", namespaceManager);
                foreach (XElement el in PublicationComplexTypes)
                {
                    if (el.Attribute("name") != null)
                    {

                        String PubTypeName = el.Attribute("name").Value;
                        if (PublicationList.Contains(PubTypeName))
                        {
                            PurePublicationType PubType = new PurePublicationType(PubTypeName, "");
                            PubType.AssociatedFields = new List<string>();
                            PubType.AssociatedFields.AddRange(AbstractElementList);
                            IEnumerable<XElement> PublicationFields = el.XPathSelectElements("/xs:scomplexContent/xs:extension/xs:sequence/xs:element", namespaceManager);
                            foreach (XElement fld in PublicationFields)
                            {
                                String PubField = fld.Attribute("name").Value;
                                PubType.AssociatedFields.Add(PubField);
                            }
                            _PurePublicationTypeTree.Add(PubType);
                        }
                    }
                }
            }
            catch (Exception e1)
            {
                ShowMessage("Error:" + e1.Message);
            }

        }

        private void drawConversionTree()
        {

            treeView2.Nodes.Clear();

            string fileContents;
            using (StreamReader streamReader = new StreamReader(Properties.Settings.Default.ConversionXSLTLocation, Encoding.UTF8))
            {
                fileContents = streamReader.ReadToEnd();
            }

            try
            {

                XmlReader reader = XmlReader.Create(new StringReader(fileContents));
                XElement root = XElement.Load(reader);
                XmlNameTable nameTable = reader.NameTable;
                XmlNamespaceManager namespaceManager = new XmlNamespaceManager(nameTable);
                namespaceManager.AddNamespace("xs", "http://www.w3.org/2001/XMLSchema");

                foreach (PurePublicationType PubType in _PurePublicationTypeTree)
                {
                    treeView2.Nodes.Add(PubType.Name, PubType.Name);
                    TreeNode[] pNodes = treeView2.Nodes.Find(PubType.Name, true);
                    if (pNodes.Length > 0)
                    {
                        foreach (string Field in PubType.AssociatedFields)
                        {

                            pNodes[0].Nodes.Add(Field, Field);
                        }

                    }
                }
                foreach (TreeNode PubNode in treeView2.Nodes)
                {
                    // publication types
                    foreach (TreeNode FieldNode in PubNode.Nodes)
                    {
                        bool FoundMissing = false;
                        var NodeFound = (double)root.XPathEvaluate("count(//*[local-name() = '" + FieldNode.Name + "'])");
                        if (NodeFound == 0.0)
                        {
                            FieldNode.ForeColor = Color.Red;
                            FoundMissing = true;
                        }
                        if (FoundMissing)
                        {
                            PubNode.ForeColor = Color.Red;
                        }
                    }
                }
            }
            catch (Exception e1)
            {
                ShowMessage("Error:" + e1.Message);
            }
        }



    }
}
