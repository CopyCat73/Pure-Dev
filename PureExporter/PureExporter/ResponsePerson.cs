using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PureExporter
{
    class ResponsePerson
    {

        public class OnePerson
        {
            public string uuid { get; set; }
            public Name name { get; set; }
            public int scopusHIndex { get; set; }
            public DateTime employeeStartDate { get; set; }
            public string fte { get; set; }
            public Externalableinfo externalableInfo { get; set; }
            public Info info { get; set; }
            public Nationality[] nationality { get; set; }
            public Visibility[] visibility { get; set; }
            public Namevariant[] nameVariants { get; set; }
            public Title[] titles { get; set; }
            public Id[] ids { get; set; }
            public Profilephoto[] profilePhotos { get; set; }
            public Link[] links { get; set; }
            public Profileinformation[] profileInformations { get; set; }
            public Studentorganisationassociation[] studentOrganisationAssociations { get; set; }
            public Stafforganisationassociation[] staffOrganisationAssociations { get; set; }
            public Keywordgroup[] keywordGroups { get; set; }
        }

        public class Name
        {
            public string firstName { get; set; }
            public string lastName { get; set; }
        }

        public class Externalableinfo
        {
            public string source { get; set; }
            public string sourceId { get; set; }
            public bool externallyManaged { get; set; }
        }

        public class Info
        {
            public string createdBy { get; set; }
            public DateTime createdDate { get; set; }
            public string modifiedBy { get; set; }
            public DateTime modifiedDate { get; set; }
            public string portalUrl { get; set; }
        }

        public class Nationality
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
            public Name1 name { get; set; }
            public Classification[] classification { get; set; }
        }

        public class Name1
        {
            public string firstName { get; set; }
            public string lastName { get; set; }
        }

        public class Classification
        {
            public string locale { get; set; }
            public string value { get; set; }
            public string uri { get; set; }
        }

        public class Title
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

        public class Profilephoto
        {
            public string typeUri { get; set; }
            public string typeLocale { get; set; }
            public string type { get; set; }
            public string url { get; set; }
            public string filename { get; set; }
            public string mimetype { get; set; }
            public int size { get; set; }
        }

        public class Link
        {
            public int id { get; set; }
            public string url { get; set; }
            public Description[] description { get; set; }
            public Linktype[] linkType { get; set; }
        }

        public class Description
        {
            public string locale { get; set; }
            public string value { get; set; }
        }

        public class Linktype
        {
            public string locale { get; set; }
            public string value { get; set; }
            public string uri { get; set; }
        }

        public class Profileinformation
        {
            public string locale { get; set; }
            public bool formatted { get; set; }
            public string value { get; set; }
            public string typeUri { get; set; }
            public string type { get; set; }
        }

        public class Studentorganisationassociation
        {
            public int id { get; set; }
            public Person person { get; set; }
            public Period period { get; set; }
            public bool isPrimaryAssociation { get; set; }
            public string startYear { get; set; }
            public string programme { get; set; }
            public Employmenttype[] employmentType { get; set; }
            public Organisationalunit organisationalUnit { get; set; }
            public Studenttypedescription[] studentTypeDescription { get; set; }
            public Projecttitle[] projectTitle { get; set; }
            public Status[] status { get; set; }
            public Address[] addresses { get; set; }
        }

        public class Person
        {
            public string uuid { get; set; }
            public Link1 link { get; set; }
            public Name2[] name { get; set; }
        }

        public class Link1
        {
            public string _ref { get; set; }
            public string href { get; set; }
        }

        public class Name2
        {
            public string locale { get; set; }
            public string value { get; set; }
        }

        public class Period
        {
            public DateTime startDate { get; set; }
            public DateTime endDate { get; set; }
        }

        public class Organisationalunit
        {
            public string uuid { get; set; }
            public Link2 link { get; set; }
            public Name3[] name { get; set; }
            public Type[] type { get; set; }
        }

        public class Link2
        {
            public string _ref { get; set; }
            public string href { get; set; }
        }

        public class Name3
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

        public class Employmenttype
        {
            public string locale { get; set; }
            public string value { get; set; }
            public string uri { get; set; }
        }

        public class Studenttypedescription
        {
            public string locale { get; set; }
            public string value { get; set; }
            public string uri { get; set; }
        }

        public class Projecttitle
        {
            public string locale { get; set; }
            public string value { get; set; }
        }

        public class Status
        {
            public string locale { get; set; }
            public string value { get; set; }
            public string uri { get; set; }
        }

        public class Address
        {
            public int id { get; set; }
            public string city { get; set; }
            public Addresstype[] addressType { get; set; }
            public Country[] country { get; set; }
        }

        public class Addresstype
        {
            public string locale { get; set; }
            public string value { get; set; }
            public string uri { get; set; }
        }

        public class Country
        {
            public string locale { get; set; }
            public string value { get; set; }
            public string uri { get; set; }
        }

        public class Stafforganisationassociation
        {
            public int id { get; set; }
            public Person1 person { get; set; }
            public Period1 period { get; set; }
            public bool isPrimaryAssociation { get; set; }
            public string fte { get; set; }
            public Employmenttype1[] employmentType { get; set; }
            public Organisationalunit1 organisationalUnit { get; set; }
            public Stafftype[] staffType { get; set; }
            public Jobdescription[] jobDescription { get; set; }
            public Jobtitle[] jobTitle { get; set; }
            public Email[] emails { get; set; }
        }

        public class Person1
        {
            public string uuid { get; set; }
            public Link3 link { get; set; }
            public Name4[] name { get; set; }
        }

        public class Link3
        {
            public string _ref { get; set; }
            public string href { get; set; }
        }

        public class Name4
        {
            public string locale { get; set; }
            public string value { get; set; }
        }

        public class Period1
        {
            public DateTime startDate { get; set; }
            public DateTime endDate { get; set; }
        }

        public class Organisationalunit1
        {
            public string uuid { get; set; }
            public Link4 link { get; set; }
            public Name5[] name { get; set; }
            public Type1[] type { get; set; }
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

        public class Type1
        {
            public string locale { get; set; }
            public string value { get; set; }
            public string uri { get; set; }
        }

        public class Employmenttype1
        {
            public string locale { get; set; }
            public string value { get; set; }
            public string uri { get; set; }
        }

        public class Stafftype
        {
            public string locale { get; set; }
            public string value { get; set; }
            public string uri { get; set; }
        }

        public class Jobdescription
        {
            public string locale { get; set; }
            public string value { get; set; }
        }

        public class Jobtitle
        {
            public string locale { get; set; }
            public string value { get; set; }
            public string uri { get; set; }
        }

        public class Email
        {
            public string typeUri { get; set; }
            public string typeLocale { get; set; }
            public string type { get; set; }
            public string value { get; set; }
        }

        public class Keywordgroup
        {
            public string logicalName { get; set; }
            public Type2[] type { get; set; }
            public Keyword[] keywords { get; set; }
        }

        public class Type2
        {
            public string locale { get; set; }
            public string value { get; set; }
            public string uri { get; set; }
        }

        public class Keyword
        {
            public string locale { get; set; }
            public string value { get; set; }
            public string uri { get; set; }
        }
    }
}
 