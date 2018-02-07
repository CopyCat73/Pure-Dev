using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PureExporter
{
    class ResponseResearchOutputs
    {
        
        public class ResearchOutputResponse
        {
        public int count { get; set; }
        public Item[] items { get; set; }
        }

        public class Item
        {
        public string uuid { get; set; }
        public string title { get; set; }
        public bool peerReview { get; set; }
        public Managingorganisationalunit managingOrganisationalUnit { get; set; }
        public bool confidential { get; set; }
        public Externalableinfo externalableInfo { get; set; }
        public Info info { get; set; }
        public string placeOfPublication { get; set; }
        public Publisher publisher { get; set; }
        public string hostPublicationTitle { get; set; }
        public Type3[] type { get; set; }
        public Category[] category { get; set; }
        public Language[] language { get; set; }
        public Openaccesspermission[] openAccessPermission { get; set; }
        public Visibility[] visibility { get; set; }
        public Workflow[] workflow { get; set; }
        public Publicationstatus[] publicationStatuses { get; set; }
        public Personassociation[] personAssociations { get; set; }
        public Organisationalunit1[] organisationalUnits { get; set; }
        public Event _event { get; set; }
        public Electronicversion[] electronicVersions { get; set; }
        }

        public class Managingorganisationalunit
        {
        public string uuid { get; set; }
        public Link link { get; set; }
        public Name[] name { get; set; }
        public Type[] type { get; set; }
        }

        public class Link
        {
        public string _ref { get; set; }
        public string href { get; set; }
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

        public class Publisher
        {
        public string uuid { get; set; }
        public Link1 link { get; set; }
        public Name1[] name { get; set; }
        public Type1[] type { get; set; }
        }

        public class Link1
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

        public class Event
        {
        public string uuid { get; set; }
        public Link2 link { get; set; }
        public Name2[] name { get; set; }
        public Type2[] type { get; set; }
        }

        public class Link2
        {
        public string _ref { get; set; }
        public string href { get; set; }
        }

        public class Name2
        {
        public string locale { get; set; }
        public string value { get; set; }
        }

        public class Type2
        {
        public string locale { get; set; }
        public string value { get; set; }
        public string uri { get; set; }
        }

        public class Type3
        {
        public string locale { get; set; }
        public string value { get; set; }
        public string uri { get; set; }
        }

        public class Category
        {
        public string locale { get; set; }
        public string value { get; set; }
        public string uri { get; set; }
        }

        public class Language
        {
        public string locale { get; set; }
        public string value { get; set; }
        public string uri { get; set; }
        }

        public class Openaccesspermission
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

        public class Workflow
        {
        public string locale { get; set; }
        public string value { get; set; }
        public string workflowStep { get; set; }
        }

        public class Publicationstatus
        {
        public bool current { get; set; }
        public Publicationdate publicationDate { get; set; }
        public Publicationstatu[] publicationStatus { get; set; }
        }

        public class Publicationdate
        {
        public int year { get; set; }
        }

        public class Publicationstatu
        {
        public string locale { get; set; }
        public string value { get; set; }
        public string uri { get; set; }
        }

        public class Personassociation
        {
        public int id { get; set; }
        public Person person { get; set; }
        public Name4 name { get; set; }
        public Personrole[] personRole { get; set; }
        public Organisationalunit[] organisationalUnits { get; set; }
        public Externalperson externalPerson { get; set; }
        }

        public class Person
        {
        public string uuid { get; set; }
        public Link3 link { get; set; }
        public Name3[] name { get; set; }
        }

        public class Link3
        {
        public string _ref { get; set; }
        public string href { get; set; }
        }

        public class Name3
        {
        public string locale { get; set; }
        public string value { get; set; }
        }

        public class Name4
        {
        public string firstName { get; set; }
        public string lastName { get; set; }
        }

        public class Externalperson
        {
        public string uuid { get; set; }
        public Link4 link { get; set; }
        public Name5[] name { get; set; }
        public Type4[] type { get; set; }
        }

        public class Link4
        {
        public string _ref { get; set; }
        public string href { get; set; }
        }

        public class Name5
        {
        public string locale { get; set; }
        public string value { get; set; }
        }

        public class Type4
        {
        public string locale { get; set; }
        public string value { get; set; }
        public string uri { get; set; }
        }

        public class Personrole
        {
        public string locale { get; set; }
        public string value { get; set; }
        public string uri { get; set; }
        }

        public class Organisationalunit
        {
        public string uuid { get; set; }
        public Link5 link { get; set; }
        public Name6[] name { get; set; }
        public Type5[] type { get; set; }
        }

        public class Link5
        {
        public string _ref { get; set; }
        public string href { get; set; }
        }

        public class Name6
        {
        public string locale { get; set; }
        public string value { get; set; }
        }

        public class Type5
        {
        public string locale { get; set; }
        public string value { get; set; }
        public string uri { get; set; }
        }

        public class Organisationalunit1
        {
        public string uuid { get; set; }
        public Link6 link { get; set; }
        public Name7[] name { get; set; }
        public Type6[] type { get; set; }
        }

        public class Link6
        {
        public string _ref { get; set; }
        public string href { get; set; }
        }

        public class Name7
        {
        public string locale { get; set; }
        public string value { get; set; }
        }

        public class Type6
        {
        public string locale { get; set; }
        public string value { get; set; }
        public string uri { get; set; }
        }

        public class Electronicversion
        {
        public int id { get; set; }
        public DateTime visibleOnPortalDate { get; set; }
        public string creator { get; set; }
        public DateTime created { get; set; }
        public string title { get; set; }
        public File file { get; set; }
        public Accesstype[] accessType { get; set; }
        public Versiontype[] versionType { get; set; }
        }

        public class File
        {
        public string fileName { get; set; }
        public string mimeType { get; set; }
        public int size { get; set; }
        public string fileURL { get; set; }
        public string digestAlgorithm { get; set; }
        public string digest { get; set; }
        }

        public class Accesstype
        {
        public string locale { get; set; }
        public string value { get; set; }
        public string uri { get; set; }
        }

        public class Versiontype
        {
        public string locale { get; set; }
        public string value { get; set; }
        public string uri { get; set; }
        }


    }
}
