using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PureExporter
{
    [Serializable]
    public class PureModification
    {
        public int ID { get; set; }
        public String Name { get; set; }
        public bool Active { get; set; }
        public string Setting { get; set; }
        public string ExtraLabel { get; set; }
    }
}
namespace PureExporter.Properties
{
    public sealed partial class Settings
    {
        [global::System.Configuration.UserScopedSettingAttribute()]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public ObservableCollection<PureModification> Modifications
        {
            get
            {
                return ((ObservableCollection<PureModification>)(this["Modifications"]));
            }
            set
            {
                this["Modifications"] = value;
            }
        }
    }
}
