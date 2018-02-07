<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="v1.publication-import.base-uk.pure.atira.dk" xmlns:ns2="v3.commons.pure.atira.dk" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <xsl:output method="xml" indent="yes" omit-xml-declaration="no" encoding ="utf-8"/>

  <xsl:template name="publicationType">
    <!-- base fields for all publication types-->
    
    <!-- Subtype -->
    <xsl:attribute name="subType">
      <xsl:call-template name="GetLastSegment">
        <xsl:with-param name="value" select="./type[@locale='en_GB']/@uri"/>
      </xsl:call-template>
    </xsl:attribute>
    
    <!-- ID todo: fallback indien geen metis -->
    <xsl:attribute name="id">
      <xsl:choose>
        <xsl:when test="./externalableInfo/sourceId/text()">
          <xsl:value-of select="./externalableInfo/sourceId/text()" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="./@uuid" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <!-- Fields appear in correct sequence for import. Do not move them around -->

    <!-- Peer reviewed-->
    <peerReviewed>
      <xsl:choose>
        <xsl:when test="./peerReview/text()">
          <xsl:value-of select="./peerReview" />
        </xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </peerReviewed>

    <!-- International Peer reviewed : need example
    <internationalPeerReviewed/>
    -->

    <!-- Accepted duplicate : not used
    <acceptedDuplicate/>
    -->

    <!-- Category-->
    <xsl:if test="./category/text()">
      <publicationCategory>
        <xsl:call-template name="GetLastSegment">
          <xsl:with-param name="value" select="./category[@locale='en_GB']/@uri"/>
        </xsl:call-template>
      </publicationCategory>
    </xsl:if>

    <!-- Publication statuses-->
    <xsl:if test="./publicationStatuses/child::node()">

      <publicationStatuses>
        <xsl:for-each select="./publicationStatuses/publicationStatus">
          <!-- this level only has the status but importing it does not seem to be supported -->
          <!-- only english will do-->
          <publicationStatus>
            <statusType>
              <xsl:call-template name="GetLastSegment">
                <xsl:with-param name="value" select="./publicationStatus[@locale='en_GB']/@uri"/>
              </xsl:call-template>
            </statusType>
            <xsl:if test="./publicationDate/year/text()">
              <date>
                <ns2:year>
                  <xsl:value-of select="./publicationDate/year" />
                </ns2:year>
                <xsl:if test="./publicationDate/month/text()">
                  <ns2:month>
                    <xsl:value-of select="./publicationDate/month" />
                  </ns2:month>
                </xsl:if>
                <xsl:if test="./publicationDate/day/text()">
                  <ns2:day>
                    <xsl:value-of select="./publicationDate/day" />
                  </ns2:day>
                </xsl:if>
              </date>
            </xsl:if>
          </publicationStatus>
        </xsl:for-each>
      </publicationStatuses>
    </xsl:if>

    <!-- Workflow -->
    <xsl:if test="./workflow/text()">
      <workflow>
        <xsl:value-of select="./workflow[@locale='en_GB']/@workflowStep"/>
      </workflow>
    </xsl:if>

    <!-- Language -->
    <xsl:if test="./language/text()">
      <language>
        <xsl:call-template name="GetLastSegment">
          <xsl:with-param name="value" select="./language[@locale='en_GB']/@uri"/>
        </xsl:call-template>
      </language>
    </xsl:if>

    <!-- Title : API output has no locale?-->
    <xsl:if test="./title/text()">
      <title>
        <ns2:text lang="en" country="GB">
          copy of <xsl:value-of select="./title" />
        </ns2:text>
      </title>
    </xsl:if>

    <!-- Subtitle : API output has no locale?-->
    <xsl:if test="./subTitle/text()">
      <subTitle>
        <ns2:text lang="en">
          <xsl:value-of select="./subTitle" />
        </ns2:text>
      </subTitle>
    </xsl:if>

    <!-- Abstract-->
    <xsl:if test="./abstract/text()">
      <xsl:for-each select="./abstract">
        <abstract>
          <ns2:text>
            <xsl:attribute name="lang">
              <xsl:value-of select="substring-before(./@locale,'_')"/>
            </xsl:attribute>
            <xsl:attribute name="country">
              <xsl:value-of select="substring-after(./@locale,'_')"/>
            </xsl:attribute>
            <xsl:value-of select="current()"/>
          </ns2:text>
        </abstract>
      </xsl:for-each>
    </xsl:if>

    <!-- Persons-->
    <xsl:if test="./personAssociations/child::node()">
      <persons>
        <xsl:for-each select="./personAssociations/personAssociation">
          <author>
            <role>
              <xsl:call-template name="GetLastSegment">
                <xsl:with-param name="value" select="./personRole[@locale='en_GB']/@uri"/>
              </xsl:call-template>
            </role>
            <xsl:choose>
              <!-- no type indicator for internal persons, just check if not external -->
              <xsl:when test=".//type[@locale='en_GB']/@uri != '/dk/atira/pure/externalperson/externalpersontypes/externalperson/externalperson'">
                <person>
                  <xsl:attribute name="id">
                    <xsl:value-of select=".//person/@uuid" />
                  </xsl:attribute>
                  <xsl:attribute name="external">false</xsl:attribute>
                  <firstName>
                    <xsl:value-of select="./name/firstName"/>
                  </firstName>
                  <lastName>
                    <xsl:value-of select="./name/lastName"/>
                  </lastName>
                </person>
                <xsl:if test=".//organisationalUnits/child::node()">
                  <organisations>
                    <xsl:for-each select=".//organisationalUnit">
                      <organisation>
                        <xsl:attribute name="id">
                          <xsl:value-of select="./@uuid"/>
                        </xsl:attribute>
                        <name>
                          <ns2:text>
                            <xsl:value-of select="./name[@locale='en_GB']"/>
                          </ns2:text>
                        </name>
                      </organisation>
                    </xsl:for-each>
                  </organisations>
                </xsl:if>
              </xsl:when>
              <xsl:when test=".//type[@locale='en_GB']/@uri='/dk/atira/pure/externalperson/externalpersontypes/externalperson/externalperson'">
                <person>
                  <xsl:attribute name="id">
                    <xsl:value-of select="./externalPerson/@uuid" />
                  </xsl:attribute>
                  <xsl:attribute name="external">true</xsl:attribute>
                  <firstName>
                    <xsl:value-of select="./name/firstName"/>
                  </firstName>
                  <lastName>
                    <xsl:value-of select="./name/lastName"/>
                  </lastName>
                </person>
                <xsl:if test=".//organisationalUnits/child::node()">
                  <organisations>
                    <xsl:for-each select=".//organisationalUnit">
                      <organisation>
                        <xsl:attribute name="id">
                          <xsl:value-of select="./@uuid"/>
                        </xsl:attribute>
                        <name>
                          <ns2:text>
                            <xsl:value-of select="./name[@locale='en_GB']"/>
                          </ns2:text>
                        </name>
                      </organisation>
                    </xsl:for-each>
                  </organisations>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
              </xsl:otherwise>
            </xsl:choose>
          </author>
        </xsl:for-each>
      </persons>
    </xsl:if>

    <!-- Organisations -->
    <xsl:if test="./organisationalUnits/child::node()">
      <organisations>
        <xsl:for-each select="./organisationalUnits/organisationalUnit">
          <organisation>
            <xsl:attribute name="id">
              <xsl:value-of select="./@uuid"/>
            </xsl:attribute>
            <name>
              <ns2:text>
                <xsl:value-of select="./name[@locale='en_GB']"/>
              </ns2:text>
            </name>
          </organisation>
        </xsl:for-each>
      </organisations>
    </xsl:if>

    <!-- Owner -->
    <xsl:if test="./managingOrganisationalUnit/child::node()">
      <owner>
        <xsl:attribute name="id">
          <xsl:value-of select="./managingOrganisationalUnit/@uuid"></xsl:value-of>
        </xsl:attribute>
      </owner>
    </xsl:if>

    <!-- Keywords -->
    <xsl:if test="./keywordGroups/child::node()">
      <keywords>
        <xsl:for-each select="./keywordGroups/keywordGroup">
          <ns2:logicalGroup>
            <xsl:attribute name="logicalName">
              <xsl:value-of select="./@logicalName"></xsl:value-of>
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="./type/@uri">
                <ns2:structuredKeywords>
                  <xsl:for-each select="./keywords/keyword[@locale='en_GB']">
                    <ns2:structuredKeyword>
                      <xsl:attribute name="classification">
                        <xsl:value-of select="./@uri"/>
                      </xsl:attribute>
                    </ns2:structuredKeyword>
                  </xsl:for-each>
                </ns2:structuredKeywords>
              </xsl:when>
              <xsl:otherwise>
                <ns2:structuredKeywords>
                  <ns2:structuredKeyword>
                    <ns2:freeKeywords>
                      <xsl:for-each select="./keywords/keyword">
                        <ns2:freeKeyword>
                          <ns2:text>
                            <xsl:attribute name="lang">
                              <xsl:value-of select="substring-before(./@locale,'_')"/>
                            </xsl:attribute>
                            <xsl:attribute name="country">
                              <xsl:value-of select="substring-after(./@locale,'_')"/>
                            </xsl:attribute>
                            <xsl:value-of select="current()"/>
                          </ns2:text>
                        </ns2:freeKeyword>
                      </xsl:for-each>
                    </ns2:freeKeywords>
                  </ns2:structuredKeyword>
                </ns2:structuredKeywords>
              </xsl:otherwise>
            </xsl:choose>
          </ns2:logicalGroup>
        </xsl:for-each>
      </keywords>
    </xsl:if>

    <!-- Urls-->
    <xsl:if test="./additionalLinks/child::node()">
      <urls>
        <xsl:for-each select="./additionalLinks/additionalLink">
          <url>
            <url>
              <xsl:value-of select="./url"/>
            </url>
            <xsl:if test="./description/text()">
              <description>
                <xsl:for-each select="./description">
                  <ns2:text>
                    <xsl:attribute name="lang">
                      <xsl:value-of select="substring-before(./@locale,'_')"/>
                    </xsl:attribute>
                    <xsl:attribute name="country">
                      <xsl:value-of select="substring-after(./@locale,'_')"/>
                    </xsl:attribute>
                    <xsl:value-of select="current()"/>
                  </ns2:text>
                </xsl:for-each>
              </description>
            </xsl:if>
            <xsl:if test="./linkType[@locale='en_GB']/@uri">
              <type>
                <xsl:value-of select="./linkType[@locale='en_GB']/@uri"/>
              </type>
            </xsl:if>
          </url>
        </xsl:for-each>
      </urls>
    </xsl:if>

    <!-- Electronic Versions-->
    <xsl:if test="./electronicVersions/child::node()">
      <electronicVersions>
        <xsl:if test="./electronicVersions/electronicVersion[@xsi:type='wsElectronicVersionDoiAssociation']/child::node()">
          <xsl:for-each select="./electronicVersions/electronicVersion[@xsi:type='wsElectronicVersionDoiAssociation']">
            <electronicVersionDOI>
              <version>
                <xsl:call-template name="GetLastSegment">
                  <xsl:with-param name="value" select="./versionType[@locale='en_GB']/@uri"/>
                </xsl:call-template>
              </version>
              <xsl:if test="./licenseType/text()">
                <license>
                  <xsl:call-template name="GetLastSegment">
                    <xsl:with-param name="value" select="./licenseType[@locale='en_GB']/@uri"/>
                  </xsl:call-template>
                </license>
              </xsl:if>
              <publicAccess>
                <xsl:call-template name="GetLastSegment">
                  <xsl:with-param name="value" select="./accessType/@uri"/>
                </xsl:call-template>
              </publicAccess>
              <xsl:if test="./embargoPeriod/startDate">
                <embargoStartDate>
                  <xsl:value-of select="./embargoPeriod/startDate"/>
                </embargoStartDate>
              </xsl:if>
              <xsl:if test="./embargoPeriod/endDate">
                <embargoEndDate>
                  <xsl:value-of select="./embargoPeriod/endDate"/>
                </embargoEndDate>
              </xsl:if>
              <doi>
                <xsl:value-of select="./doi"/>
              </doi>
            </electronicVersionDOI>
          </xsl:for-each>
        </xsl:if>
        <xsl:if test="./electronicVersions/electronicVersion[@xsi:type='wsElectronicVersionFileAssociation']/child::node()">
          <xsl:for-each select="./electronicVersions/electronicVersion[@xsi:type='wsElectronicVersionFileAssociation']">
            <electronicVersionFile>
              <version>
                <xsl:call-template name="GetLastSegment">
                  <xsl:with-param name="value" select="./versionType[@locale='en_GB']/@uri"/>
                </xsl:call-template>
              </version>
              <xsl:if test="./licenseType/text()">
                <license>
                  <xsl:call-template name="GetLastSegment">
                    <xsl:with-param name="value" select="./licenseType[@locale='en_GB']/@uri"/>
                  </xsl:call-template>
                </license>
              </xsl:if>
              <publicAccess>
                <xsl:call-template name="GetLastSegment">
                  <xsl:with-param name="value" select="./accessType/@uri"/>
                </xsl:call-template>
              </publicAccess>
              <xsl:if test="./embargoPeriod/startDate">
                <embargoStartDate>
                  <xsl:value-of select="./embargoPeriod/startDate"/>
                </embargoStartDate>
              </xsl:if>
              <xsl:if test="./embargoPeriod/endDate">
                <embargoEndDate>
                  <xsl:value-of select="./embargoPeriod/endDate"/>
                </embargoEndDate>
              </xsl:if>
              <xsl:if test="./title">
                <title>
                  <xsl:value-of select="./title"/>
                </title>
              </xsl:if>
              <!-- not in api or interface<v1:rightsStatement>right statement text</v1:rightsStatement>-->
              <file>
                <filename>
                  <xsl:value-of select="./file/fileURL"/>
                </filename>
                <filesize>
                  <xsl:value-of select="./file/size"/>
                </filesize>
                <mimetype>
                  <xsl:value-of select="./file/mimeType"/>
                </mimetype>
              </file>
            </electronicVersionFile>
          </xsl:for-each>
        </xsl:if>
        <xsl:if test="./electronicVersions/electronicVersion[@xsi:type='wsElectronicVersionLinkAssociation']/child::node()">
          <xsl:for-each select="./electronicVersions/electronicVersion[@xsi:type='wsElectronicVersionLinkAssociation']">
            <electronicVersionLink>
              <version>
                <xsl:call-template name="GetLastSegment">
                  <xsl:with-param name="value" select="./versionType[@locale='en_GB']/@uri"/>
                </xsl:call-template>
              </version>
              <xsl:if test="./licenseType/text()">
                <license>
                  <xsl:call-template name="GetLastSegment">
                    <xsl:with-param name="value" select="./licenseType[@locale='en_GB']/@uri"/>
                  </xsl:call-template>
                </license>
              </xsl:if>
              <publicAccess>
                <xsl:call-template name="GetLastSegment">
                  <xsl:with-param name="value" select="./accessType/@uri"/>
                </xsl:call-template>
              </publicAccess>
              <xsl:if test="./embargoPeriod/startDate">
                <embargoStartDate>
                  <xsl:value-of select="./embargoPeriod/startDate"/>
                </embargoStartDate>
              </xsl:if>
              <xsl:if test="./embargoPeriod/endDate">
                <embargoEndDate>
                  <xsl:value-of select="./embargoPeriod/endDate"/>
                </embargoEndDate>
              </xsl:if>
              <xsl:if test="./link">
                <link>
                  <xsl:value-of select="./link"/>
                </link>
              </xsl:if>
            </electronicVersionLink>
          </xsl:for-each>
        </xsl:if>

      </electronicVersions>
    </xsl:if>

    <!-- Additional Files : not implemented
            <additionalFiles/>
             -->
    <!-- Existing stores : not implemented
            <existingStores/>
            -->
    <!-- Transfer to repository : not implemented
            <transferToRepository/>
            -->

    <!-- Bibliographical notes-->
    <xsl:if test="./bibliographicalNote">
      <bibliographicalNotes>
        <xsl:for-each select="./bibliographicalNote">
          <bibliographicalNote>
            <ns2:text>
              <xsl:attribute name="locale">
                <xsl:value-of select="substring-before(./@locale,'_')"/>
              </xsl:attribute>
              <xsl:attribute name="country">
                <xsl:value-of select="substring-after(./@locale,'_')"/>
              </xsl:attribute>
              <xsl:value-of select="current()"/>
            </ns2:text>
          </bibliographicalNote>
        </xsl:for-each>
      </bibliographicalNotes>
    </xsl:if>

    <!-- visibility-->
    <xsl:if test="./visibility">
      <visibility>
        <xsl:choose>
          <xsl:when test="./visibility[@locale='en_GB']/@key='FREE'">Public</xsl:when>
          <xsl:when test="./visibility[@locale='en_GB']/@key='CAMPUS'">Campus</xsl:when>
          <xsl:when test="./visibility[@locale='en_GB']/@key='RESTRICTED'">Restricted</xsl:when>
          <xsl:when test="./visibility[@locale='en_GB']/@key='CONFIDENTIAL'">Confidential</xsl:when>
          <xsl:otherwise>Unknown visibilty status!</xsl:otherwise>
        </xsl:choose>
      </visibility>
    </xsl:if>

    <!-- external ids -->
    <xsl:if test="./externalableInfo/secondarySources/child::node()">
      <externalIds>
        <xsl:for-each select="./externalableInfo/secondarySources/secondarySource">
          <xsl:choose>
            <xsl:when test="./source='researchoutputwizard'">
            </xsl:when>
            <xsl:otherwise>
              <id>
                <xsl:attribute name="type">
                  <xsl:value-of select="./source"/>
                </xsl:attribute>
                <xsl:value-of select="./sourceId"/>
              </id>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </externalIds>
    </xsl:if>


    <!-- Miscellaneous : not implemented
    <miscellaneous/>
    -->
    <!-- Article Processing Charge : not implemented
    <articleProcessingCharge/>
    -->

    <!-- Comments are not present in API output 
    <comments/>
    -->

    <!-- Related records are not implemented 
    <relatedPublications/>
    <relatedStudentTheses/>
    <relatedActivities/>
    <relatedClippings/>
    <relatedEquipment/>
    <relatedProjects/>
    <relatedDataSets/>
    <relatedImpacts/>
    -->
    
  </xsl:template>
    
  <xsl:template match="/">
    <publications>
      <xsl:apply-templates/>
    </publications>
  </xsl:template>

  <xsl:template match="count">
    <!-- Ignore this -->
  </xsl:template>

  <xsl:template match="contributionToJournal">
    <contributionToJournal>
      <xsl:call-template name="publicationType"/>
      <xsl:call-template name="pages"/>
      <xsl:call-template name="numberOfPages"/>
      <xsl:call-template name="articleNumber"/>
      <xsl:call-template name="journalNumber"/>
      <xsl:call-template name="journalVolume"/>
      <xsl:call-template name="earlyOnlineDate"/>
      <xsl:call-template name="journal"/>
      <xsl:call-template name="event"/>
    </contributionToJournal>
  </xsl:template>

  <xsl:template match="contributionToBookAnthology">
    <chapterInBook>
      <xsl:call-template name="publicationType"/>
      <xsl:call-template name="pages"/>
      <xsl:call-template name="numberOfPages"/>
      <xsl:call-template name="articleNumber"/>
      <xsl:call-template name="edition"/>
      <xsl:call-template name="placeOfPublication"/>
      <xsl:call-template name="volume"/>
      <xsl:call-template name="printIsbns"/>
      <xsl:call-template name="electronicIsbns"/>
      <xsl:call-template name="hostPublicationTitle"/>
      <xsl:call-template name="hostPublicationSubTitle"/>
      <xsl:call-template name="publisher"/>
      <xsl:call-template name="editors"/>
      <xsl:call-template name="series"/>
      <xsl:call-template name="event"/>
    </chapterInBook>
  </xsl:template>

  <xsl:template match="contributionToConference1">
    <contributionToConference>
      <xsl:call-template name="publicationType"/>
      <xsl:call-template name="pages"/>
      <xsl:call-template name="numberOfPages"/>
      <xsl:call-template name="event"/>
    </contributionToConference>
  </xsl:template>

  <xsl:template match="contributionToPeriodical">
    <contributionToPeriodical>
      <xsl:call-template name="publicationType"/>
      <xsl:call-template name="pages"/>
      <xsl:call-template name="numberOfPages"/>
      <xsl:call-template name="articleNumber"/>
      <xsl:call-template name="journalNumber"/>
      <xsl:call-template name="journalVolume"/>
      <xsl:call-template name="earlyOnlineDate"/>
      <xsl:call-template name="journal"/>
      <xsl:call-template name="event"/>
    </contributionToPeriodical>
  </xsl:template>

  <xsl:template match="patent">
    <patent>
      <xsl:call-template name="publicationType"/>
      <xsl:call-template name="ipc"/>
      <xsl:call-template name="patentNumber"/>
      <xsl:call-template name="priorityDate"/>
      <xsl:call-template name="priorityNumber"/>
    </patent>
  </xsl:template>

  <xsl:template match="otherContribution">
    <other>
      <xsl:call-template name="publicationType"/>
      <xsl:call-template name="shortDescription"/>
      <xsl:call-template name="outputMediaText"/>
      <xsl:call-template name="numberOfPages"/>
      <xsl:call-template name="placeOfPublication"/>
      <xsl:call-template name="volume"/>
      <xsl:call-template name="edition"/>
      <xsl:call-template name="printIsbns"/>
      <xsl:call-template name="electronicIsbns"/>
      <xsl:call-template name="series"/>
      <xsl:call-template name="publisher"/>
    </other>
  </xsl:template>

  <xsl:template match="bookAnthology">
    <book>
      <xsl:call-template name="publicationType"/>
      <xsl:call-template name="placeOfPublication"/>
      <xsl:call-template name="edition"/>
      <xsl:call-template name="volume"/>
      <xsl:call-template name="printIsbns"/>
      <xsl:call-template name="electronicIsbns"/>
      <xsl:call-template name="commissioningBodyExternalOrganisation"/>
      <xsl:call-template name="series"/>
      <xsl:call-template name="publisher"/>
    </book>
  </xsl:template>

  <xsl:template match="workingPaper">
    <workingPaper>
      <xsl:call-template name="publicationType"/>
      <xsl:call-template name="pages"/>
      <xsl:call-template name="numberOfPages"/>
      <xsl:call-template name="placeOfPublication"/>
      <xsl:call-template name="volume"/>
      <xsl:call-template name="publisher"/>
      <xsl:call-template name="printIsbns"/>
      <xsl:call-template name="electronicIsbns"/>
      <xsl:call-template name="series"/>
    </workingPaper>
  </xsl:template>

  <xsl:template match="nonTextual">
    <nonTextual>
      <xsl:call-template name="publicationType"/>
      <xsl:call-template name="outputMediaClassification"/>
      <xsl:call-template name="size"/>
      <xsl:call-template name="placeOfPublication"/>
      <xsl:call-template name="edition"/>
      <xsl:call-template name="publisher"/>
      <xsl:call-template name="event"/>
    </nonTextual>
  </xsl:template>

  <xsl:template match="memorandum">
    <memorandum>
      <xsl:call-template name="publicationType"/>
      <xsl:call-template name="projectNumber"/>
      <xsl:call-template name="journalNumber"/>
      <xsl:call-template name="dateFinished"/>
      <xsl:call-template name="applicant"/>
      <xsl:call-template name="series"/>
    </memorandum>
  </xsl:template>


  <xsl:template match="contributionToMemorandum">
    <contributionToMemorandum>
      <xsl:call-template name="publicationType"/>
      <xsl:call-template name="projectNumber"/>
      <xsl:call-template name="journalNumber"/>
      <xsl:call-template name="dateFinished"/>
      <xsl:call-template name="applicant"/>
      <xsl:call-template name="series"/>
    </contributionToMemorandum>
  </xsl:template>

  <xsl:template match="thesis">
    <thesis>
      <xsl:call-template name="publicationType"/>
      <xsl:call-template name="qualification"/>
      <xsl:call-template name="awardingInstitutions"/>
      <xsl:call-template name="thesisSupervisors"/>
      <xsl:call-template name="supervisorOrganisations"/>
      <xsl:call-template name="sponsors"/>
      <xsl:call-template name="awardDate"/>
      <xsl:call-template name="publisher"/>
      <xsl:call-template name="edition"/>
      <xsl:call-template name="placeOfPublication"/>
      <xsl:call-template name="printIsbns"/>
      <xsl:call-template name="electronicIsbns"/>
      <xsl:call-template name="numberOfPages"/>
    </thesis>
  </xsl:template>
     
  <xsl:template match="dataset">
    <dataset>
      <!-- datasets do not seem to be supported -->
      <xsl:call-template name="publicationType"/>
    </dataset>
  </xsl:template>


  <xsl:template name="pages">
    <xsl:if test="./pages/text()">
      <pages>
        <xsl:value-of select="./pages"/>
      </pages>
    </xsl:if>
  </xsl:template>

  <xsl:template name="series">
    <xsl:if test="./publicationSeries/child::node()">
      <series>
        <xsl:for-each select="./publicationSeries/publicationSerie">
          <serie>
            <xsl:if test="./name/text()">
              <name>
                <xsl:value-of select="./name"/>
              </name>
            </xsl:if>
            <xsl:if test="./publisherName/text()">
              <publisherName>
                <xsl:value-of select="./publisherName"/>
              </publisherName>
            </xsl:if>
            <xsl:if test="./volume/text()">
              <volume>
                <xsl:value-of select="./volume"/>
              </volume>
            </xsl:if>
            <xsl:if test="./no/text()">
              <number>
                <xsl:value-of select="./no"/>
              </number>
            </xsl:if>
            <xsl:if test="./issn/text()">
              <printIssn>
                <xsl:value-of select="./issn"/>
              </printIssn>
            </xsl:if>
            <xsl:if test="./electronicIssn/text()">
              <electronicIssn>
                <xsl:value-of select="./electronicIssn"/>
              </electronicIssn>
            </xsl:if>
          </serie>
        </xsl:for-each>
      </series>
    </xsl:if>
  </xsl:template>


  <xsl:template name="numberOfPages">
    <xsl:if test="./numberOfPages/text()">
      <numberOfPages>
        <xsl:value-of select="./numberOfPages"/>
      </numberOfPages>
    </xsl:if>
  </xsl:template>

  <xsl:template name="articleNumber">
    <xsl:if test="./articleNumber/text()">
      <articleNumber>
        <xsl:value-of select="./articleNumber"/>
      </articleNumber>
    </xsl:if>
  </xsl:template>

  <xsl:template name="journalNumber">
    <xsl:if test="./journalNumber/text()">
      <journalNumber>
        <xsl:value-of select="./journalNumber"/>
      </journalNumber>
    </xsl:if>
  </xsl:template>

  <xsl:template name="journalVolume">
    <xsl:if test="./volume/text()">
      <journalVolume>
        <xsl:value-of select="./volume"/>
      </journalVolume>
    </xsl:if>
  </xsl:template>

  <xsl:template name="volume">
    <xsl:if test="./volume/text()">
      <volume>
        <xsl:value-of select="./volume"/>
      </volume>
    </xsl:if>
  </xsl:template>

  <xsl:template name="earlyOnlineDate">
    <!-- earlyOnlineDate not supported 
    <earlyOnlineDate/>
    -->
  </xsl:template>

  <xsl:template name="edition">
    <xsl:if test="./edition/text()">
      <edition>
        <xsl:value-of select="./edition"/>
      </edition>
    </xsl:if>
  </xsl:template>

  <xsl:template name="placeOfPublication">
    <xsl:if test="./placeOfPublication/text()">
      <placeOfPublication>
        <xsl:value-of select="./placeOfPublication"/>
      </placeOfPublication>
    </xsl:if>
  </xsl:template>

  <xsl:template name="hostPublicationTitle">
    <xsl:if test="./hostPublicationTitle/text()">
      <hostPublicationTitle>
        <xsl:value-of select="./hostPublicationTitle"/>
      </hostPublicationTitle>
    </xsl:if>
  </xsl:template>

  <xsl:template name="hostPublicationSubTitle">
    <xsl:if test="./hostPublicationSubTitle/text()">
      <hostPublicationSubTitle>
        <xsl:value-of select="./hostPublicationSubTitle"/>
      </hostPublicationSubTitle>
    </xsl:if>
  </xsl:template>

  <xsl:template name="hostPublicationEditors">
    <xsl:if test="./hostPublicationEditors/child::node()">
      <editors>
        <xsl:for-each select="./hostPublicationEditors/hostPublicationEditor">
          <editor>
            <ns2:firstname>
              <xsl:value-of select="./firstName"/>
            </ns2:firstname>
            <ns2:lastname>
              <xsl:value-of select="./lastName"/>
            </ns2:lastname>
          </editor>
        </xsl:for-each>
      </editors>
    </xsl:if>
  </xsl:template>

  <xsl:template name="event">
    <xsl:if test="./event/child::node()">
      <!-- only process existing id's here to reconnect-->
      <event>
        <xsl:attribute name="id">
          <xsl:value-of select="./event/@uuid"/>
        </xsl:attribute>
      </event>
    </xsl:if>
  </xsl:template>

  <xsl:template name="printIsbns">
    <xsl:if test="./isbns/child::node()">
      <printIsbns>
        <xsl:for-each select="./isbns/isbn">
          <isbn>
            <xsl:value-of select="current()"/>
          </isbn>
        </xsl:for-each>
      </printIsbns>
    </xsl:if>
  </xsl:template>

  <xsl:template name="electronicIsbns">
    <xsl:if test="./electronicIsbns/child::node()">
      <electronicIsbns>
        <xsl:for-each select="./electronicIsbns/electronicIsbn">
          <isbn>
            <xsl:value-of select="current()"/>
          </isbn>
        </xsl:for-each>
      </electronicIsbns>
    </xsl:if>
  </xsl:template>

  <xsl:template name="publisher">
    <xsl:if test="./publisher/child::node()">
      <!-- only process existing id's here to reconnect-->
      <publisher>
        <xsl:attribute name="id">
          <xsl:value-of select="./publisher/@uuid"/>
        </xsl:attribute>
      </publisher>
    </xsl:if>
  </xsl:template>

  <xsl:template name="editors">
    <xsl:if test="./hostPublicationEditors/child::node()">
      <editors>
        <xsl:for-each select="./hostPublicationEditors/hostPublicationEditor">
          <editor>
            <ns2:firstname>
              <xsl:value-of select="./firstName"/>
            </ns2:firstname>
            <ns2:lastname>
              <xsl:value-of select="./lastName"/>
            </ns2:lastname>
          </editor>
        </xsl:for-each>
      </editors>
    </xsl:if>
  </xsl:template>

  <xsl:template name="ipc">
    <xsl:if test="./ipc/text()">
      <ipc>
        <xsl:value-of select="./ipc"/>
      </ipc>
    </xsl:if>
  </xsl:template>

  <xsl:template name="patentNumber">
    <xsl:if test="./patentNumber/text()">
      <patentNumber>
        <xsl:value-of select="./patentNumber"/>
      </patentNumber>
    </xsl:if>
  </xsl:template>

  <xsl:template name="priorityDate">
    <xsl:if test="./priorityDate/text()">
      <priorityDate>
        <xsl:value-of select="./priorityDate"/>
      </priorityDate>
    </xsl:if>
  </xsl:template>

  <xsl:template name="priorityNumber">
    <xsl:if test="./priorityNumber/text()">
      <priorityNumber>
        <xsl:value-of select="./priorityNumber"/>
      </priorityNumber>
      </xsl:if>
  </xsl:template>

  <xsl:template name="shortDescription">
    <xsl:if test="./typeDescription/text()">
      <shortDescription>
        <xsl:value-of select="./typeDescription"/>
      </shortDescription>
    </xsl:if>
  </xsl:template>

  <xsl:template name="outputMediaText">
    <xsl:if test="./outputMedia/text()">
      <outputMedia>
        <xsl:value-of select="./outputMedia"/>
      </outputMedia>
    </xsl:if>
  </xsl:template>

  <xsl:template name="outputMediaClassification">
    <xsl:if test="./outputMedia[@locale='en_GB']/@uri">
      <outputMedia>
        <xsl:call-template name="GetLastSegment">
          <xsl:with-param name="value" select="./outputMedia[@locale='en_GB']/@uri"/>
        </xsl:call-template>
      </outputMedia>
    </xsl:if>
  </xsl:template>

  <xsl:template name="commissioningBodyExternalOrganisation">
    <xsl:if test="./commissioningBody/child::node()">
      <!-- only process existing id's here to reconnect-->
      <commissioningBodyExternalOrganisation>
        <xsl:attribute name="id">
          <xsl:value-of select="./commissioningBody/@uuid"/>
        </xsl:attribute>
      </commissioningBodyExternalOrganisation>
    </xsl:if>
  </xsl:template>

  <xsl:template name="size">
    <xsl:if test="./size/text()">
      <size>
        <xsl:value-of select="./size"/>
      </size>
    </xsl:if>
  </xsl:template>
  
  
  <xsl:template name="projectNumber">
    <!-- Memorandum not used by TU/e, needs to be implemented elsewhere -->
  </xsl:template>

  <xsl:template name="dateFinished">
    <!-- Memorandum not used by TU/e, needs to be implemented elsewhere -->
  </xsl:template>

  <xsl:template name="applicant">
    <!-- Memorandum not used by TU/e, needs to be implemented elsewhere -->
  </xsl:template>

  <xsl:template name="qualification">
    <xsl:if test="./qualification[@locale='en_GB']/@uri">
      <qualification>
        <xsl:call-template name="GetLastSegment">
          <xsl:with-param name="value" select="./qualification[@locale='en_GB']/@uri"/>
        </xsl:call-template>
      </qualification>
    </xsl:if>
  </xsl:template>

  <xsl:template name="awardingInstitutions">
    <xsl:if test="./awardingInstitutions/child::node()">
      <awardingInstitutions>
        <xsl:for-each select="./awardingInstitutions/awardingInstitution">
          <awardingInstitution>
            <xsl:attribute name="id">
              <xsl:value-of select="./externalOrganisationalUnit/@uuid"/>
            </xsl:attribute>
          </awardingInstitution>
        </xsl:for-each>
      </awardingInstitutions>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="thesisSupervisors">
    <xsl:if test="./supervisors/child::node()">
      <thesisSupervisors>
        <xsl:for-each select="./supervisors/supervisor">
          <thesisSupervisor>
            <person>
              <xsl:attribute name="id">
                <xsl:value-of select="./person/@uuid"/>
              </xsl:attribute>
            </person>
              <role>
                <xsl:call-template name="GetLastSegment">
                  <xsl:with-param name="value" select="./personRole/@uri"/>
                </xsl:call-template>
              </role>
            <xsl:if test="./organisationalUnits/child::node()">
              <organisations>
                <xsl:for-each select="./organisationalUnits/organisationalUnit">
                  <organisation>
                    <xsl:attribute name="id">
                      <xsl:value-of select="./@uuid"/>
                    </xsl:attribute>
                  </organisation>
                </xsl:for-each>
              </organisations>
            </xsl:if>
          </thesisSupervisor>
        </xsl:for-each>
      </thesisSupervisors>
    </xsl:if>
  </xsl:template>

  <xsl:template name="supervisorOrganisations">
    <xsl:if test="./supervisorExternalOrganisations/child::node()">
      <supervisorOrganisations>
        <xsl:for-each select="./supervisorExternalOrganisations/supervisorExternalOrganisation">
          <organisation>
            <xsl:attribute name="id">
              <xsl:value-of select="./@uuid"/>
            </xsl:attribute>
          </organisation>
        </xsl:for-each>
      </supervisorOrganisations>
    </xsl:if>
  </xsl:template>

  <xsl:template name="sponsors">
    <xsl:if test="./sponsors/child::node()">
      <sponsors>
        <xsl:for-each select="./sponsors/sponsor">
          <sponsor>
            <xsl:attribute name="id">
              <xsl:value-of select="./@uuid"/>
            </xsl:attribute>
          </sponsor>
        </xsl:for-each>
      </sponsors>
    </xsl:if>
  </xsl:template>

  <xsl:template name="awardDate">
    <xsl:if test="./awardedDate/text()">
      <awardDate>
        <xsl:value-of select="./awardedDate"/>
      </awardDate>
    </xsl:if>
  </xsl:template>
        
  <xsl:template name="journal">
    <!-- only process existing id's here to reconnect-->
    <xsl:if test="./journalAssociation/child::node()">
      <xsl:for-each select="./journalAssociation">
          <xsl:if test="./journal/@uuid">
            <journal>
              <xsl:attribute name="id">
                <xsl:value-of select="./journal/@uuid"/>
              </xsl:attribute>
            </journal>
          </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

	<xsl:template name="GetLastSegment">
		<xsl:param name="value" />
		<xsl:param name="separator" select="'/'" />
		<xsl:choose>
			<xsl:when test="contains($value, $separator)">
				<xsl:call-template name="GetLastSegment">
					<xsl:with-param name="value" select="substring-after($value, $separator)" />
					<xsl:with-param name="separator" select="$separator" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="GetBeforeLastSegment">
		<xsl:param name="value" />
		<xsl:param name="separator" select="'/'" />
		<xsl:call-template name="GetLastSegment">
			<xsl:with-param name="value">
				<xsl:call-template name="substring-before-last">
					<xsl:with-param name="input" select="substring-after($value, $separator)" />
					<xsl:with-param name="substr" select="$separator" />
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="separator" select="$separator" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="substring-before-last">
		<xsl:param name="input" />
		<xsl:param name="substr" />
		<xsl:if test="$substr and contains($input, $substr)">
			<xsl:variable name="temp" select="substring-after($input, $substr)" />
			<xsl:value-of select="substring-before($input, $substr)" />
			<xsl:if test="contains($temp, $substr)">
				<xsl:value-of select="$substr" />
				<xsl:call-template name="substring-before-last">
					<xsl:with-param name="input" select="$temp" />
					<xsl:with-param name="substr" select="$substr" />
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>


</xsl:stylesheet>

