using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PureExporter
{
    class PurePublication
    {
        public string Title { get; private set; }
        public string UUID { get; private set; }
        public string Type { get; private set; }

        public PurePublication(string title, string uuid, string type)
        {
            Title = title;
            UUID = uuid;
            Type = type;
        }

    }
}