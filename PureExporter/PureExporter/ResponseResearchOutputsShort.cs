using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PureExporter
{
    class ResponseResearchOutputsShort
    {
        // short version for limited result on title and type only (for populating result list)

        public class ResearchOutputResponse
        {
            public int count { get; set; }
            public Item[] items { get; set; }
        }

        public class Item
        {
            public string uuid { get; set; }
            public string title { get; set; }
            public Type type { get; set; }
        }
        public class Type
        {
            public string locale { get; set; }
            public string value { get; set; }
            public string uri { get; set; }
        }
    }
}
