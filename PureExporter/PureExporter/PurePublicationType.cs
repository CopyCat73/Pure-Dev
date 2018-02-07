using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PureExporter
{
    class PurePublicationType
    {
        public string Name { get; private set; }
        public string Uri { get; private set; }
        public List<string> AssociatedFields { get; set; }
     
        public PurePublicationType(string name, string uri)
        {
            Name = name;
            Uri = uri;
        }
    
    }

}
