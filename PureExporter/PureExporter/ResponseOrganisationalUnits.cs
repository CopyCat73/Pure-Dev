using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PureExporter
{
    class ResponseOrganisationalUnits
    {
        public class OrganisationResponse
        {
            public int count { get; set; }
            public Item[] items { get; set; }
            public Navigationlink[] navigationLink { get; set; }
        }

        public class Item
        {
            public string uuid { get; set; }
            public Period period { get; set; }
            public Externalableinfo externalableInfo { get; set; }
            public Info info { get; set; }
            public Name[] name { get; set; }
            public Type[] type { get; set; }
            public Visibility[] visibility { get; set; }
            public Namevariant[] nameVariants { get; set; }
            public Id[] ids { get; set; }
            public Parent[] parents { get; set; }
        }

        public class Period
        {
            public DateTime startDate { get; set; }
            public DateTime endDate { get; set; }
        }

        public class Externalableinfo
        {
            public string source { get; set; }
            public string sourceId { get; set; }
            public bool externallyManaged { get; set; }
            public Secondarysource[] secondarySources { get; set; }
        }

        public class Secondarysource
        {
            public string source { get; set; }
            public string sourceId { get; set; }
        }

        public class Info
        {
            public string createdBy { get; set; }
            public DateTime createdDate { get; set; }
            public string modifiedBy { get; set; }
            public DateTime modifiedDate { get; set; }
            public string portalUrl { get; set; }
        }

        public class Name
        {
            public string locale { get; set; }
            public string value { get; set; }
        }

        public class Type
        {
            public string locale { get; set; }
            public string value { get; set; }
            public string uri { get; set; }
        }

        public class Visibility
        {
            public string locale { get; set; }
            public string value { get; set; }
            public string key { get; set; }
        }

        public class Namevariant
        {
            public string locale { get; set; }
            public string value { get; set; }
            public string typeUri { get; set; }
            public string type { get; set; }
        }

        public class Id
        {
            public string typeUri { get; set; }
            public string typeLocale { get; set; }
            public string type { get; set; }
            public string value { get; set; }
        }

        public class Parent
        {
            public string uuid { get; set; }
            public Link link { get; set; }
            public Name1[] name { get; set; }
            public Type1[] type { get; set; }
        }

        public class Link
        {
            public string _ref { get; set; }
            public string href { get; set; }
        }

        public class Name1
        {
            public string locale { get; set; }
            public string value { get; set; }
        }

        public class Type1
        {
            public string locale { get; set; }
            public string value { get; set; }
            public string uri { get; set; }
        }

        public class Navigationlink
        {
            public string _ref { get; set; }
            public string href { get; set; }
        }


    }
}

