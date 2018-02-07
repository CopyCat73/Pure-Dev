using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PureExporter
{
    class PurePerson
    {
        public string Name { get; private set; }
        public string PhotoUrl { get; private set; }
        public string Type { get; private set; }
        public string UUID { get; private set; }
        public string Bio { get; private set; }
        public string SourceID { get; private set; }
        public string StartDate { get; private set; }

        public PurePerson(string name, string uuid)
        {
            Name = name;
            UUID = uuid;
            PhotoUrl ="";
            Type = "";
            Bio = "";
            SourceID = "";
            StartDate = "";
        }

        public PurePerson(string name, string uuid, string bio, string photourl, string type)
        {
            Name = name;
            PhotoUrl = photourl;
            Type = type;
            UUID = uuid;
            Bio = bio;
        }

        public void Update(string bio, string photourl, string type, string sourceid, string startdate)
        {
            PhotoUrl = photourl;
            Type = type;
            Bio = bio;
            SourceID = sourceid;
            StartDate = startdate;
        }


    }
}
