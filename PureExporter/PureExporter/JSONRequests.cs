using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PureExporter
{
    public class JSONRequests
    {
        public class WSJournalsQuery {
            public string searchString { get; set; }
            public string[] uuids { get; set; }
            public int size { get; set; }
            public int offset { get; set; }
            public string linkingStrategy { get; set; }
            public string[] locales { get; set; }
            public string[] fallbackLocales { get; set; }
            public string[] renderings { get; set; }
            public string[] fields { get; set; }
            public string[] orderings { get; set; }
            public bool returnUsedContent { get; set; }
            public bool navigationLink { get; set; }
            public string[] titles { get; set; }
            public string[] typeUris { get; set; }
            public string[] issns { get; set; }
            public string[] workflowSteps { get; set; }
        }
        
        public class WSPublishersQuery {
            public string searchString { get; set; }
            public string[] uuids { get; set; }
            public int size { get; set; }
            public int offset { get; set; }
            public string linkingStrategy { get; set; }
            public string[] locales { get; set; }
            public string[] fallbackLocales { get; set; }
            public string[] renderings { get; set; }
            public string[] fields { get; set; }
            public string[] orderings { get; set; }
            public bool returnUsedContent { get; set; }
            public bool navigationLink { get; set; }
            public string[] names { get; set; }
            public string[] countryUris { get; set; }
            public string[] workflowSteps { get; set; }
        }

        public class WSPersonsQuery {
            public string searchString { get; set; }
            public string[] uuids { get; set; }
            public int size { get; set; }
            public int offset { get; set; }
            public string linkingStrategy { get; set; }
            public string[] locales { get; set; }
            public string[] fallbackLocales { get; set; }
            public string[] renderings { get; set; }
            public string[] fields { get; set; }
            public string[] orderings { get; set; }
            public bool returnUsedContent { get; set; }
            public bool navigationLink { get; set; }
            public string[] employmentTypeUris { get; set; }
            public string employmentStatus { get; set; } //['ACTIVE', 'FORMER'],
            public WSCompoundDateRange employmentPeriod { get; set; }
            public string[] personOrganisationAssociationTypes { get; set; }
            public WSOrganisationsQuery forOrganisations { get; set; }
            }

        public class WSOrganisationsQuery {
            public string searchString  { get; set; }
            public string[] uuids { get; set; }
            public int size { get; set; }
            public int offset;
            public string linkingStrategy { get; set; }
            public string[] locales { get; set; }
            public string[] fallbackLocales { get; set; }
            public string[] renderings { get; set; }
            public string[] fields { get; set; }
            public string[] orderings { get; set; }
            public bool returnUsedContent { get; set; }
            public bool navigationLink { get; set; }
            public string[] organisationalUnitTypeUris { get; set; }
            public string organisationPeriodStatus { get; set; } // ['ACTIVE', 'FORMER']
        }


        public class WSCompoundDate {
            public int year { get; set; }
            public int month { get; set; }
            public int day { get; set; }
        }
        
        public class WSCompoundDateRange {
            public WSCompoundDate startDate { get; set; }
            public WSCompoundDate endDate { get; set; }
        }
        
        public class WSResearchOutputsQuery {
            public string searchString { get; set; }
            public string[] uuids { get; set; }
            public int size { get; set; }
            public int offset { get; set; }
            public string linkingStrategy { get; set; }
            public string[] locales { get; set; }
            public string[] fallbackLocales { get; set; }
            public string[] renderings { get; set; }
            public string[] fields { get; set; }
            public string[] orderings { get; set; }
            public bool returnUsedContent { get; set; }
            public bool navigationLink { get; set; }
            public string[] typeUris { get; set; }
            public string[] publicationStatuses { get; set; }
            public string[] publicationCategories { get; set; }
            public bool peerReviewed { get; set; }
            public bool internationalPeerReviewed { get; set; }
            public WSJournalsQuery forJournals { get; set; }
            public WSPublishersQuery forPublishers { get; set; }
            public WSPersonsQuery forPersons { get; set; }
            public WSOrganisationsQuery forOrganisationalUnits { get; set; }
            public string[] workflowSteps { get; set; }

        }

    }
}
