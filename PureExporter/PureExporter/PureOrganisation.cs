using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PureExporter
{
    class PureOrganisation
    {
        public string Name { get; private set; }
        public string NameType { get { return Name + " (" + Type + ")"; } }
        public string UUID { get; private set; }
        public string Type { get; private set; }
        public string Parent { get; private set; }

        public PureOrganisation(string name, string uuid, string type, string parent)
        {
            Name = name;
            UUID = uuid;
            Type = type;
            Parent = parent;
        }

    }

}