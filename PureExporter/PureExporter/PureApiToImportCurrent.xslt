<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="xs msxsl cur cur1 v1 commons publication-template externalorganisation-template journal-template core xsi publication-base_uk extensions-core person-template externalperson-template organisation-template extensions-base_uk publisher-template event-template"
    xmlns:cur="http://atira.dk/schemas/pure4/model/base_uk/researchoutput/current"
    xmlns:cur1="http://atira.dk/schemas/pure4/model/template/abstractpublication/current"
    xmlns:publication-template="http://atira.dk/schemas/pure4/wsdl/template/abstractpublication/current"
    xmlns:core="http://atira.dk/schemas/pure4/model/core/current"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:publication-base_uk="http://atira.dk/schemas/pure4/model/template/abstractpublication/current"
    xmlns:extensions-core="http://atira.dk/schemas/pure4/model/core/extensions/current"
    xmlns:person-template="http://atira.dk/schemas/pure4/model/template/abstractperson/current"
    xmlns:externalperson-template="http://atira.dk/schemas/pure4/model/template/abstractexternalperson/current"
    xmlns:organisation-template="http://atira.dk/schemas/pure4/model/template/abstractorganisation/current"
    xmlns:externalorganisation-template="http://atira.dk/schemas/pure4/model/template/abstractexternalorganisation/current"
    xmlns:extensions-base_uk="http://atira.dk/schemas/pure4/model/base_uk/extensions/current"
    xmlns:publisher-template="http://atira.dk/schemas/pure4/model/template/abstractpublisher/current"
    xmlns:journal-template="http://atira.dk/schemas/pure4/model/template/abstractjournal/current"
    xmlns:v1="v1.publication-import.base-uk.pure.atira.dk"
    xmlns:commons="v3.commons.pure.atira.dk"
    xmlns:event-template="http://atira.dk/schemas/pure4/model/template/abstractevent/current">

  <!--
    <xs:element name="contributionToJournal" type="contributionToJournalType" substitutionGroup="publication"/>
    <xs:element name="chapterInBook" type="chapterInBookType" substitutionGroup="publication"/>
    <xs:element name="contributionToConference" type="contributionToConferenceType" substitutionGroup="publication"/>
    <xs:element name="contributionToSpecialist" type="contributionToSpecialistType" substitutionGroup="publication"/>
    <xs:element name="patent" type="patentType" substitutionGroup="publication"/>
    <xs:element name="other" type="otherType" substitutionGroup="publication"/>
    <xs:element name="book" type="bookType" substitutionGroup="publication"/>
    <xs:element name="workingPaper" type="workingPaperType" substitutionGroup="publication"/>
    <xs:element name="nonTextual" type="nonTextualType" substitutionGroup="publication"/>
    <xs:element name="memorandum" type="memorandumType" substitutionGroup="publication"/>
    <xs:element name="contributionToMemorandum" type="contributionToMemorandumType" substitutionGroup="publication"/>
    <xs:element name="thesis" type="thesisType" substitutionGroup="publication"/>
  
    When searching for a subtype use the parent scheme /dk/atira/pure/researchoutput/researchoutputtypes
    The classification scheme per type:
    Book/report: /dk/atira/pure/researchoutput/researchoutputtypes/bookanthology
    Contribution to
    book/report:/dk/atira/pure/researchoutput/researchoutputtypes/contributiontobookanthology
    Contribution to conference:
    /dk/atira/pure/researchoutput/researchoutputtypes/contributiontoconference1
    Contribution to journal: /dk/atira/pure/researchoutput/researchoutputtypes/contributiontojournal
    Contribution to memorandum:
    /dk/atira/pure/researchoutput/researchoutputtypes/contributiontomemorandum
    Datasets: /dk/atira/pure/researchoutput/researchoutputtypes/dataset
    Memorandum: /dk/atira/pure/researchoutput/researchoutputtypes/memorandum
    Non-textual: /dk/atira/pure/researchoutput/researchoutputtypes/nontextual
    Other contribution: /dk/atira/pure/researchoutput/researchoutputtypes/othercontribution
    Patent: /dk/atira/pure/researchoutput/researchoutputtypes/patent
    Specialist publication: /dk/atira/pure/researchoutput/researchoutputtypes/contributiontoperiodical
    Thesis: /dk/atira/pure/researchoutput/researchoutputtypes/thesis
    Working paper: /dk/atira/pure/researchoutput/researchoutputtypes/workingpaper
    -->


  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
  <xsl:variable name="p_type_uri" select ="//core:content[1]/cur1:typeClassification/core:uri"/>

  <xsl:variable name="p_type_o">
    <xsl:call-template name="GetBeforeLastSegment">
      <xsl:with-param name="value" select="//core:content[1]/cur1:typeClassification/core:uri"/>
    </xsl:call-template>
  </xsl:variable>


  <xsl:variable name="p_subtype">
    <xsl:call-template name="GetLastSegment">
      <xsl:with-param name="value" select="//core:content[1]/cur1:typeClassification/core:uri"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="p_type">
    <xsl:choose>
      <xsl:when test="$p_type_o='bookanthology'">
        <xsl:value-of select="'book'" />
      </xsl:when>
      <xsl:when test="$p_type_o='contributiontobookanthology'">
        <xsl:value-of select="'chapterInBook'" />
      </xsl:when>
      <xsl:when test="$p_type_o='contributiontoconference1'">
        <xsl:value-of select="'contributionToConference'" />
      </xsl:when>
      <xsl:when test="$p_type_o='contributiontojournal'">
        <xsl:value-of select="'contributionToJournal'" />
      </xsl:when>
      <xsl:when test="$p_type_o='contributiontomemorandum'">
        <xsl:value-of select="'contributionToMemorandum'" />
      </xsl:when>
      <!--<xsl:when test="$p_type_o='dataset'">
                <xsl:value-of select="'????'" /> datasets don't seem to be supported
            </xsl:when>-->
      <xsl:when test="$p_type_o='memorandum'">
        <xsl:value-of select="'memorandum'" />
      </xsl:when>
      <xsl:when test="$p_type_o='nontextual'">
        <xsl:value-of select="'nonTextual'" />
      </xsl:when>
      <xsl:when test="$p_type_o='othercontribution'">
        <xsl:value-of select="'other'" />
      </xsl:when>
      <xsl:when test="$p_type_o='patent'">
        <xsl:value-of select="'patent'" />
      </xsl:when>
      <xsl:when test="$p_type_o='contributiontoperiodical'">
        <xsl:value-of select="'contributionToJournal'" />
      </xsl:when>
      <xsl:when test="$p_type_o='thesis'">
        <xsl:value-of select="'thesis'" />
      </xsl:when>
      <xsl:when test="$p_type_o='workingpaper'">
        <xsl:value-of select="'workingPaper'" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'unknowntype'" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  

  <!-- Start main doc-->
  <xsl:template match="/">

    <xsl:element name="v1:{$p_type}" xmlns="v1.publication-import.base-uk.pure.atira.dk" >
      <xsl:attribute name="subType">
        <xsl:value-of select='$p_subtype'/>
      </xsl:attribute>
      <xsl:attribute name="id">
        <xsl:value-of select="concat('Metis',//extensions-core:secondarySource[@source='Metis']/@source_id,'-fixed')"/> <!-- keep fixed?-->
      </xsl:attribute>
      
      

      <!-- Common nodes-->

      <v1:peerReviewed>
      <xsl:choose>
        <xsl:when test="//extensions-core:peerReviewed/text()">
            <xsl:value-of select="//extensions-core:peerReviewed" />
        </xsl:when>
        <xsl:otherwise>false</xsl:otherwise>     
      </xsl:choose>
      </v1:peerReviewed>

      <!-- deprecated?
      <internationalPeerReviewed/>
      <acceptedDuplicate/> -->

      <xsl:if test="//cur1:publicationCategory/extensions-core:publicationCategory/core:uri/text()">
        <v1:publicationCategory>
          <xsl:call-template name="GetLastSegment">
            <xsl:with-param name="value" select="//cur1:publicationCategory/extensions-core:publicationCategory/core:uri"/>
          </xsl:call-template>
        </v1:publicationCategory>
      </xsl:if>

      <xsl:if test="//core:publicationStatus/core:uri/text()">

        <v1:publicationStatuses>
          <v1:publicationStatus>
            <v1:statusType>
              <xsl:call-template name="GetLastSegment">
                <xsl:with-param name="value" select="//core:publicationStatus/core:uri"/>
              </xsl:call-template>
            </v1:statusType>
            <xsl:if test="//core:publicationDate/core:year/text()">
              <v1:date>
                <commons:year>
                  <xsl:value-of select="//core:publicationDate/core:year" />
                </commons:year>
                <xsl:if test="//core:publicationDate/core:month/text()">
                  <commons:month>
                    <xsl:value-of select="//core:publicationDate/core:month" />
                  </commons:month>
                </xsl:if>
                <xsl:if test="//core:publicationDate/core:day/text()">
                  <commons:day>
                    <xsl:value-of select="//core:publicationDate/core:day" />
                  </commons:day>
                </xsl:if>
              </v1:date>
            </xsl:if>
          </v1:publicationStatus>
        </v1:publicationStatuses>
      </xsl:if>
      
      <xsl:if test="//core:startedWorkflow/core:state/text()">
        <v1:workflow>
          <xsl:value-of select="//core:startedWorkflow/core:state" />
        </v1:workflow>
      </xsl:if>

      <xsl:if test="//cur1:language/core:uri/text()">
        <v1:language>
          <xsl:call-template name="GetLastSegment">
            <xsl:with-param name="value" select="//cur1:language/core:uri"/>
          </xsl:call-template>
        </v1:language>
      </xsl:if>


      <xsl:if test="//cur1:title/text()">
        <s01:title xmlns:s01="v1.publication-import.base-uk.pure.atira.dk" xmlns="v3.commons.pure.atira.dk">
          <text lang="en">
            <xsl:value-of select="//cur1:title" />
          </text>
        </s01:title>
      </xsl:if>

      <xsl:if test="//cur1:subtitle/text()">
        <s01:subTitle xmlns:s01="v1.publication-import.base-uk.pure.atira.dk" xmlns="v3.commons.pure.atira.dk">
          <text lang="en">
            <xsl:value-of select="//cur1:subtitle" />
          </text>
        </s01:subTitle>
      </xsl:if>

      <xsl:if test="//cur1:abstract/child::node()">
        <v1:abstract>
          <xsl:for-each select="//cur1:abstract/core:localizedString">
            <commons:text>
              <xsl:attribute name="lang">
                <xsl:value-of select="substring-before(./@locale,'_')"/>
              </xsl:attribute>
              <xsl:attribute name="country">
                <xsl:value-of select="substring-after(./@locale,'_')"/>
              </xsl:attribute>
              <xsl:value-of select="current()"/>
            </commons:text>
          </xsl:for-each>
        </v1:abstract>
      </xsl:if>
<!---->
      <xsl:if test="//person-template:personAssociation/child::node()">
        <v1:persons>
          <xsl:for-each select="//person-template:personAssociation">
            <v1:author>
              <v1:role>
                <xsl:call-template name="GetLastSegment">
                  <xsl:with-param name="value" select="./person-template:personRole/core:uri"/>
                </xsl:call-template>
              </v1:role>
              <xsl:choose>
                <xsl:when test=".//core:family='dk.atira.pure.api.shared.model.person.Person'">
                  <v1:person>
                    <xsl:attribute name="id">
                      <xsl:value-of select="./person-template:person/@uuid" />
                    </xsl:attribute>
                    <xsl:attribute name="external">false</xsl:attribute>
                    <v1:firstName>
                      <xsl:value-of select="./person-template:name/core:firstName"/>
                    </v1:firstName>
                    <v1:lastName>
                      <xsl:value-of select="./person-template:name/core:lastName"/>
                    </v1:lastName>
                  </v1:person>
                  <xsl:if test=".//person-template:organisations/child::node()">
                    <v1:organisations>
                      <xsl:for-each select=".//person-template:organisations/organisation-template:association">
                        <v1:organisation>
                          <xsl:attribute name="id">
                            <xsl:value-of select="./organisation-template:organisation/@uuid"/>
                          </xsl:attribute>
                        </v1:organisation>
                      </xsl:for-each>
                    </v1:organisations>
                  </xsl:if>
                </xsl:when>
                <xsl:when test=".//core:family='dk.atira.pure.api.shared.model.externalperson.ExternalPerson'">
                  <v1:person>
                    <xsl:attribute name="id">
                      <xsl:value-of select="./person-template:externalPerson/@uuid" />
                    </xsl:attribute>
                    <xsl:attribute name="external">true</xsl:attribute>
                  </v1:person>
                </xsl:when>
                <xsl:otherwise>
                </xsl:otherwise>
              </xsl:choose>
            </v1:author>
          </xsl:for-each>
        </v1:persons>
      </xsl:if>

      
      
      <!-- Skip organisatins for now.
      <xsl:if test="//cur:organisations/organisation-template:association/child::node()">
        <v1:organisations>
          <xsl:for-each select="//cur:organisations/organisation-template:association">
            <v1:organisation>
              <xsl:attribute name="id">
                <xsl:value-of select="./organisation-template:organisation/organisation-template:external/extensions-core:sourceId"/>
              </xsl:attribute>
            </v1:organisation>
          </xsl:for-each>
        </v1:organisations>
      </xsl:if>-->

      <xsl:if test="//cur1:owner/child::node()">
        <v1:owner>
          <xsl:attribute name="id">
            <xsl:value-of select="//cur1:owner/@uuid"></xsl:value-of>
          </xsl:attribute>
        </v1:owner>
      </xsl:if>

      <!--
      <xsl:if test="//cur:publicationDate/core:year/text()">
        <s01:publicationDate xmlns:s01="v1.publication-import.base-uk.pure.atira.dk" xmlns="v3.commons.pure.atira.dk">
          <year>
            <xsl:value-of select="//cur:publicationDate/core:year"/>
          </year>
        </s01:publicationDate>
      </xsl:if>-->



      <xsl:if test="//core:content[1]/core:keywordGroups/child::node()">
        <v1:keywords>
          <!-- Free keyword -->
          <xsl:for-each select="//core:content[1]/core:keywordGroups/core:keywordGroup">
            <xsl:choose>
              <xsl:when test=".//core:classificationScheme/child::node()">
                <commons:logicalGroup>
                  <xsl:attribute name="logicalName">
                    <xsl:value-of select=".//core:name/core:localizedString[@locale='en_GB']"/>
                  </xsl:attribute>
                  <commons:structuredKeywords>
                    <xsl:for-each select=".//core:keyword">
                      <commons:structuredKeyword>
                        <xsl:attribute name="classification">
                          <xsl:value-of select=".//core:uri"/>
                        </xsl:attribute>
                        <xsl:if test="./core:userDefinedKeyword/child::node()">
                          <commons:freeKeywords>
                            <xsl:for-each select=".//core:userDefinedKeyword">
                              <xsl:for-each select=".//core:freeKeyword">
                                <commons:freeKeyword>
                                  <commons:text>
                                    <xsl:attribute name="lang">
                                      <xsl:value-of select="substring-before(../@locale,'_')"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="country">
                                      <xsl:value-of select="substring-after(../@locale,'_')"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="current()"/>
                                  </commons:text>
                                </commons:freeKeyword>
                              </xsl:for-each>
                            </xsl:for-each>
                          </commons:freeKeywords>
                        </xsl:if>
                      </commons:structuredKeyword>
                    </xsl:for-each>
                  </commons:structuredKeywords>
                </commons:logicalGroup>
              </xsl:when>
              <xsl:otherwise>

                <commons:logicalGroup logicalName="keywordContainers">
                  <commons:structuredKeywords>
                    <commons:structuredKeyword>
                      <commons:freeKeywords>
                        <xsl:for-each select=".//core:userDefinedKeyword">
                          <xsl:for-each select=".//core:freeKeyword">
                            <commons:freeKeyword>
                              <commons:text>
                                <xsl:attribute name="lang">
                                  <xsl:value-of select="substring-before(../@locale,'_')"/>
                                </xsl:attribute>
                                <xsl:attribute name="country">
                                  <xsl:value-of select="substring-after(../@locale,'_')"/>
                                </xsl:attribute>
                                <xsl:value-of select="current()"/>
                              </commons:text>
                            </commons:freeKeyword>
                          </xsl:for-each>
                        </xsl:for-each>
                      </commons:freeKeywords>
                    </commons:structuredKeyword>
                  </commons:structuredKeywords>
                </commons:logicalGroup>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </v1:keywords>
      </xsl:if>

      <!-- not present yet in xml_long
      <v1:urls>
			<v1:url>
				<v1:url>http://www.elsevier.com/online-tools/research-intelligence/products-and-services/pure</v1:url>
				<v1:description>
					<commons:text lang="en" country="GB">Pure</commons:text>
				</v1:description>
				<v1:type>unspecified</v1:type>
			</v1:url>
		</v1:urls>-->

      <xsl:if test="//core:content[1]/cur1:electronicVersionAssociations/core:electronicVersionDOIAssociations/child::node() or //core:content[1]/cur1:electronicVersionAssociations/core:electronicVersionFileAssociations/child::node()">
        <v1:electronicVersions>
          <xsl:if test="//core:content[1]/cur1:electronicVersionAssociations/core:electronicVersionDOIAssociations/child::node()">
            <xsl:for-each select=".//core:electronicVersionDOIAssociation">
              <v1:electronicVersionDOI>
                <v1:version>
                  <xsl:call-template name="GetLastSegment">
                    <xsl:with-param name="value" select="./core:versionType/core:uri"/>
                  </xsl:call-template>
                </v1:version>
                <!-- not in api <v1:licence>cc_by_nd</v1:licence>-->
                <!-- not in api <v1:publicAccess>closed</v1:publicAccess>-->
                <v1:doi>
                  <xsl:value-of select="./core:doi"/>
                </v1:doi>
              </v1:electronicVersionDOI>
            </xsl:for-each>
          </xsl:if>
          <xsl:if test="//core:content[1]/cur1:electronicVersionAssociations/core:electronicVersionFileAssociations/child::node()">
            <xsl:for-each select="//core:content[1]/cur1:electronicVersionAssociations/core:electronicVersionFileAssociations/core:electronicVersionFileAssociation">
              <v1:electronicVersionFile>
                <v1:version>
                  <xsl:call-template name="GetLastSegment">
                    <xsl:with-param name="value" select="./core:versionType/core:uri"/>
                  </xsl:call-template>               
                </v1:version>
                <!-- not in api<v1:licence>cc_by_nd</v1:licence>-->
                <v1:publicAccess>
                  <xsl:call-template name="GetLastSegment">
                    <xsl:with-param name="value" select="./core:accessType/core:uri"/>
                  </xsl:call-template>
                </v1:publicAccess>
                <v1:title>
                  <xsl:value-of select="./core:title"/>
                </v1:title>
                <!-- not in api or interface<v1:rightsStatement>right statement text</v1:rightsStatement>-->
                <v1:file>
                  <v1:filename>
                    <xsl:value-of select="./core:file/core:url"/>
                  </v1:filename>
                  <v1:filesize>
                    <xsl:value-of select="./core:file/core:size"/>
                  </v1:filesize>
                  <v1:mimetype>
                    <xsl:value-of select="./core:file/core:mimeType"/>
                  </v1:mimetype>
                </v1:file>
              </v1:electronicVersionFile>
            </xsl:for-each>
          </xsl:if>
        </v1:electronicVersions>
      </xsl:if>
      
      <!-- all below not in api
      <additionalFiles/>
      <documents/>
      <existingStores/>
      <transferToRepository/>
      -->

        

      <xsl:if test="//cur1:bibliographicalNote/child::node()">
        <v1:bibliographicalNotes>
          <v1:bibliographicalNote>
            <!-- todo set language attributes on the fly-->
            <xsl:if test="//cur1:bibliographicalNote/core:localizedString[@locale='en_GB']/text()">
              <commons:text lang="en" country="GB">
                <xsl:value-of select="//cur1:bibliographicalNote/core:localizedString[@locale='en_GB']"/>
              </commons:text>
            </xsl:if>
            <xsl:if test="//cur1:bibliographicalNote/core:localizedString[@locale='nl_NL']/text()">
              <commons:text lang="nl" country="NL">
                <xsl:value-of select="//cur1:bibliographicalNote/core:localizedString[@locale='nl_NL']"/>
              </commons:text>
            </xsl:if>
          </v1:bibliographicalNote>
        </v1:bibliographicalNotes>
      </xsl:if>

      <v1:visibility>
        <xsl:choose>
          <xsl:when test="//cur1:limitedVisibility/core:visibility/text()='FREE'">Public</xsl:when>
          <xsl:when test="//cur1:limitedVisibility/core:visibility/text()='CAMPUS'">Campus</xsl:when>
          <xsl:when test="//cur1:limitedVisibility/core:visibility/text()='RESTRICTED'">Restricted</xsl:when>
          <xsl:when test="//cur1:limitedVisibility/core:visibility/text()='CONFIDENTIAL'">Confidential</xsl:when>
          <xsl:otherwise>Unknown visibilty status!</xsl:otherwise>
        </xsl:choose>
      </v1:visibility>


      <xsl:if test="//cur1:external/child::node()">
        <v1:externalIds>
          <xsl:for-each select="//cur1:external/extensions-core:secondarySource">
            <xsl:choose>
              <xsl:when test="current()/@source='researchoutputwizard'">
              </xsl:when>
              <xsl:otherwise>
                <v1:id>
                  <xsl:attribute name="type">
                    <xsl:value-of select="current()/@source"/>
                  </xsl:attribute>
                  <xsl:value-of select="current()/@source_id"/>
                </v1:id>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </v1:externalIds>
      </xsl:if>


      <!-- to do 
      <miscellaneous/>
      <articleProcessingCharge/>
      <comments/>-->
      
      <!-- contributionToJournalType nodes-->

      <xsl:if test="//cur1:pages[1]/text()">
        <v1:pages>
          <xsl:value-of select="//cur1:pages"/>
        </v1:pages>
      </xsl:if>
      <xsl:if test="//cur1:numberOfPages[1]/text()">
        <v1:numberOfPages>
          <xsl:value-of select="//cur1:numberOfPages"/>
        </v1:numberOfPages>
      </xsl:if>
      <xsl:if test="//cur1:articleNumber[1]/text()">
        <v1:articleNumber>
          <xsl:value-of select="//cur1:articleNumber"/>
        </v1:articleNumber>
      </xsl:if>
      <xsl:if test="//cur1:journalNumber[1]/text()">
        <v1:journalNumber>
          <xsl:value-of select="//cur1:journalNumber"/>
        </v1:journalNumber>
      </xsl:if>
      <xsl:if test="//cur1:volume[1]/text()">
        <v1:journalVolume>
          <xsl:value-of select="//cur1:volume"/>
        </v1:journalVolume>
      </xsl:if>

      <xsl:if test="//cur1:onlineEarlyDate/text()">
        <v1:earlyOnlineDate>
          <xsl:value-of select="msxsl:format-date(substring-before(//cur1:onlineEarlyDate,'+'), 'd-M-yyyy')"/>
        </v1:earlyOnlineDate>
      </xsl:if>
     
      <xsl:if test="//journal-template:journal/child::node()">
        <v1:journal>
          <xsl:attribute name="id">
            <xsl:value-of select="//journal-template:journal/@uuid"/>
          </xsl:attribute>
          <v1:title>
            <xsl:value-of select="//journal-template:journal/journal-template:titles/journal-template:title[1]/extensions-core:string"/>
          </v1:title>
          <xsl:if test="//journal-template:issn/child::node()">
            <v1:printIssns>
              <xsl:for-each select="//journal-template:issn">
                <v1:issn>
                  <xsl:value-of select="./extensions-core:string"/>
                </v1:issn>
              </xsl:for-each>
            </v1:printIssns>
          </xsl:if>
          <!--not in api <v1:electronicIssns/>-->
          <!--not in api <v1:workflow/>-->
        </v1:journal>
      </xsl:if>

      <!-- chapterInBookType nodes-->

      <xsl:if test="//publisher-template:edition/text()">
        <v1:edition>
          <xsl:value-of select="//publisher-template:edition"/>
        </v1:edition>
      </xsl:if>

      <xsl:if test="//publisher-template:placeOfPublication/text()">
        <v1:placeOfPublication>
          <xsl:value-of select="//publisher-template:placeOfPublication"/>
        </v1:placeOfPublication>
      </xsl:if>

      <xsl:if test="//publisher-template:volume/text()">
        <v1:volume>
          <xsl:value-of select="//publisher-template:volume"/>
        </v1:volume>
      </xsl:if>

      <xsl:if test="//publisher-template:printIsbns/child::node()">
        <v1:printIsbns>
          <xsl:for-each select="//publisher-template:printIsbns">
            <v1:isbn>
              <xsl:value-of select="./core:value"/>
            </v1:isbn>
          </xsl:for-each>
        </v1:printIsbns>
      </xsl:if>
      <xsl:if test="//publisher-template:electronicIsbns/child::node()">
        <v1:electronicIsbns>
          <xsl:for-each select="//publisher-template:electronicIsbns">
            <v1:isbn>
              <xsl:value-of select="./core:value"/>
            </v1:isbn>
          </xsl:for-each>
        </v1:electronicIsbns>
      </xsl:if>

      <xsl:if test="//cur1:hostPublicationTitle/text()">
        <v1:hostPublicationTitle>
          <xsl:value-of select="//cur1:hostPublicationTitle"/>
        </v1:hostPublicationTitle>
      </xsl:if>
      <xsl:if test="//cur1:hostPublicationSubTitle/text()">
        <v1:hostPublicationSubTitle/>
        <v1:hostPublicationSubTitle>
          <xsl:value-of select="//cur1:hostPublicationSubTitle"/>
        </v1:hostPublicationSubTitle>
      </xsl:if>

      <xsl:if test="//publisher-template:name/text()">
        <v1:publisher>
          <v1:name>
            <xsl:value-of select="//publisher-template:name"/>
          </v1:name>
        </v1:publisher>
      </xsl:if>

      <xsl:if test="//cur1:hostEditors/cur1:hostEditor/child::node()">
        <v1:editors>
          <xsl:for-each select="//cur1:hostEditors/cur1:hostEditor">
            <!-- geen naam/achternaam definitie in de import api-->
            <v1:editor>
              <commons:firstname>
                <xsl:value-of select="./core:firstName"/>
              </commons:firstname>
              <commons:lastname>
                <xsl:value-of select="./core:lastName"/>
              </commons:lastname>
            </v1:editor>
          </xsl:for-each>
        </v1:editors>
      </xsl:if>

      <xsl:if test="//cur1:publicationSeries/child::node()">
        <v1:series>
          <xsl:for-each select="//cur1:publicationSeries/extensions-core:publicationSerie">
            <v1:serie>
              <v1:name>
                <xsl:value-of select="./extensions-core:name"/>
              </v1:name>
              <v1:publisherName>
                <xsl:value-of select="./extensions-core:publisherName"/>
              </v1:publisherName>
              <v1:volume>
                <xsl:value-of select="./extensions-core:volume"/>
              </v1:volume>
              <v1:number>
                <xsl:value-of select="./extensions-core:no"/>
              </v1:number>
              <v1:printIssn>
                <xsl:value-of select="./extensions-core:printISSN"/>
              </v1:printIssn>
              <v1:electronicIssn>
                <xsl:value-of select="./extensions-core:electronicISSN"/>
              </v1:electronicIssn>
            </v1:serie>
          </xsl:for-each>
        </v1:series>
      </xsl:if>

      <xsl:if test="//cur:event/child::node()">
        <v1:event>
          <xsl:attribute name="id">
            <xsl:value-of select="//cur:event/@uuid" />
          </xsl:attribute>
          <!--
          <s01:description xmlns:s01="v1.publication-import.base-uk.pure.atira.dk" xmlns="v3.commons.pure.atira.dk">
            <v1:text lang="en">
              <xsl:value-of select="//cur:event/event-template:title/core:localizedString[@locale='en_GB']"/>
            </v1:text>
          </s01:description>
          <v1:startDate>
            <xsl:value-of select="msxsl:format-date(substring-before(//cur:event/event-template:dateRange/extensions-core:startDate,'+'), 'd-M-yyyy')"/>
          </v1:startDate>
          <v1:endDate>
            <xsl:value-of select="msxsl:format-date(substring-before(//cur:event/event-template:dateRange/extensions-core:endDate,'+'), 'd-M-yyyy')"/>
          </v1:endDate>-->
        </v1:event>
     </xsl:if>

      <!-- contributionToConferenceType nodes-->

      <!-- contributionToSpecialistType nodes-->
      <xsl:if test="//cur1:number/text()">
        <v1:number>
          <xsl:value-of select="//cur1:number"/>
          <!-- check actual node name, this is a guess-->
        </v1:number>
      </xsl:if>

      <!-- patentType nodes-->
      <xsl:if test="//cur1:ipc/text()">
        <v1:ipc>
          <xsl:value-of select="//cur1:ipc"/>
        </v1:ipc>
      </xsl:if>

      <xsl:if test="//cur1:patentNumber/text()">
        <v1:patentNumber>
          <xsl:value-of select="//cur1:patentNumber"/>
        </v1:patentNumber>
      </xsl:if>

      <!--<v1:priorityDate/> not in api-->
      <!--<v1:priorityNumber/> not in api-->

      <!-- otherType nodes-->
      <xsl:if test="//core:content[1]/cur1:stringType/text()">
        <v1:shortDescription>
          <xsl:value-of select="//core:content[1]/cur1:stringType"/>
          <!-- tagname reported to Atira, seems wrong-->
        </v1:shortDescription>
      </xsl:if>
      <!--<v1:outputMedia/> not in api-->
      <!-- bookType nodes-->
      <!--<v1:commissioningBody/> not in api, not in interface (internal)-->
      <!--<v1:commissioningBodyExternalOrganisation/> not in api-->
      <!-- workingPaperType nodes-->
      <!-- nonTextualType nodes-->
      <xsl:if test="//cur1:outputMedia/child::node()">
        <xsl:for-each select="//cur1:outputMedia">
          <v1:outputMedia>
            <xsl:call-template name="GetLastSegment">
              <xsl:with-param name="value" select="./core:uri"/>
            </xsl:call-template>
          </v1:outputMedia>
        </xsl:for-each>
      </xsl:if>

      <xsl:if test="//cur1:size/text()">
        <v1:size>
          <xsl:value-of select="//cur1:size"/>
        </v1:size>
      </xsl:if>

      <!-- memorandumType nodes-->
      <xsl:if test="//cur1:projectNo/text()">
        <v1:projectNumber>
          <xsl:value-of select="//cur1:projectNo"/>
        </v1:projectNumber>
      </xsl:if>

      <xsl:if test="//cur1:journalNo/text()">
        <v1:journalNumber>
          <xsl:value-of select="//cur1:journalNo"/>
        </v1:journalNumber>
      </xsl:if>

      <xsl:if test="//cur1:dateFinished/text()">
        <v1:dateFinished>
          <xsl:value-of select="msxsl:format-date(substring-before(//cur1:dateFinished,'+'), 'd-M-yyyy')"/>
        </v1:dateFinished>
      </xsl:if>

      <xsl:if test="//cur1:applicant/text()">
        <v1:applicant>
          <xsl:value-of select="//cur1:applicant"/>
        </v1:applicant>
      </xsl:if>
      <!-- contributionToMemorandumType nodes-->
      <!-- thesisType nodes-->
      <xsl:if test="//cur1:qualification/child::node()">
        <xsl:for-each select="//cur1:qualification">
          <v1:qualification>
            <xsl:call-template name="GetLastSegment">
              <xsl:with-param name="value" select="./core:uri"/>
            </xsl:call-template>
          </v1:qualification>
        </xsl:for-each>
      </xsl:if>

      <xsl:if test="//cur1:awardingInstitution/child::node()">
        <xsl:for-each select="//cur1:awardingInstitution/cur1:internalExternalOrganisationAssociation">
          <v1:awardingInstitution>
            <xsl:attribute name="id">
              <xsl:value-of select=".//organisation-template:external/extensions-core:sourceId"/>
            </xsl:attribute>
            <s01:name xmlns:s01="v1.publication-import.base-uk.pure.atira.dk" xmlns="v3.commons.pure.atira.dk">
              <v1:text lang="en">
                <xsl:value-of select=".//organisation-template:name/core:localizedString[@locale='en_GB']"/>
              </v1:text>
            </s01:name>
          </v1:awardingInstitution>
        </xsl:for-each>
      </xsl:if>

      <xsl:if test="//cur1:supervisorAdvisor/child::node()">
        <v1:thesisSupervisors>
          <xsl:for-each select="//cur1:supervisorAdvisor">
            <v1:thesisSupervisor>
              <v1:person>
                <xsl:attribute name="id">
                  <xsl:value-of select=".//person-template:external/extensions-core:sourceId"/>
                </xsl:attribute>
                <v1:firstName>
                  <xsl:value-of select=".//person-template:name/core:firstName"/>
                </v1:firstName>
                <v1:lastName>
                  <xsl:value-of select=".//person-template:name/core:lastName"/>
                </v1:lastName>
              </v1:person>
              <v1:role>
                <xsl:call-template name="GetLastSegment">
                  <xsl:with-param name="value" select="./cur1:personRole/core:uri"/>
                </xsl:call-template>
              </v1:role>
            </v1:thesisSupervisor>
          </xsl:for-each>
        </v1:thesisSupervisors>
      </xsl:if>

      <xsl:if test="//cur1:sponsors/child::node()">
        <v1:sponsors>
          <xsl:for-each select="//cur1:sponsors/externalorganisation-template:externalOrganisation">
            <v1:sponsor>
              <v1:name>
                <xsl:value-of select=".//externalorganisation-template:name"/>
              </v1:name>
              <v1:type>
                <xsl:call-template name="GetLastSegment">
                  <xsl:with-param name="value" select=".//externalorganisation-template:typeClassification/core:uri"/>
                </xsl:call-template>
              </v1:type>
              <v1:country></v1:country>
              <!-- zit niet in de xml_long-->
            </v1:sponsor>
          </xsl:for-each>
        </v1:sponsors>
      </xsl:if>

      <xsl:if test="//cur1:awardDate/text()">
        <v1:awardDate>
          <xsl:value-of select="msxsl:format-date(substring-before(//cur1:awardDate, '+'), 'd-M-yyyy')"/>
        </v1:awardDate>
      </xsl:if>

    </xsl:element>
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
