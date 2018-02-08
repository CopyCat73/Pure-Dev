<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="v1.publication-import.base-uk.pure.atira.dk"
                xmlns:p="v1.publication-import.base-uk.pure.atira.dk"
                xmlns:ns2="v3.commons.pure.atira.dk" 
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                exclude-result-prefixes="p">

  <xsl:output method="xml" indent="yes" omit-xml-declaration="no" encoding ="utf-8"/>

<!--
 
  Faculty	Metis ID	Name	Purpose	# publications	# activities	UUID PROD	REPLACE ON PROD WITH
  B	B-personal	All non related research of the Department of Architecture, Building and Planning 	Exclude, during TU/e employment	664	18	9962b90c-d5c2-432f-ae86-f86eb011c29b	fe4092dc-3eb9-46c1-902d-be1e28ec1945
  B	B-OLD	All previous research of the Department of Architecture, Building and Planning 	Include, but affiliation unknown	127	2	8406a238-029b-4006-ba93-d6760704e51c	5918ce87-5e18-4792-9e13-6669c7682f96
  BMT	BMT-EBMT	Other non-related research programmes 	Exclude, before TU/e employment	37	0	e763fae0-b082-4c51-8028-f578ad71d00c	5918ce87-5e18-4792-9e13-6669c7682f96
  BMT	BMT-personal	External personal Research BMT	Exclude, during TU/e employment	204	0	afe085e3-1390-4160-811e-1f38c4e713a8	fe4092dc-3eb9-46c1-902d-be1e28ec1945
  E	e-ecr-00	Pre-TU publications 	Exclude, before TU/e employment	0	0	e7307d19-af59-4493-b395-991fe2436460	5918ce87-5e18-4792-9e13-6669c7682f96
  E	e-em-00	Pre-TU publications	Exclude, before TU/e employment	76	0	daff56fd-c564-4b54-84c5-ebad4d4d152a	5918ce87-5e18-4792-9e13-6669c7682f96
  E	E-PHI-00	Pre-TU publications 	Exclude, before TU/e employment	35	1	4948bd0a-5386-49e8-80c1-5a2d5b737c70	5918ce87-5e18-4792-9e13-6669c7682f96
  E	E-EEA-9	Non-project related research 	Exclude, during TU/e employment	6	0	01f64696-776a-4ece-9b8e-a1dbbc91f773	fe4092dc-3eb9-46c1-902d-be1e28ec1945
  E	e-eco-00	Pre-TU publications 	Exclude, before TU/e employment	68	1	ea167ae0-c267-45f1-b8de-b53c16377766	5918ce87-5e18-4792-9e13-6669c7682f96
  E	e-sps-00	Pre-TU publications 	Exclude, before TU/e employment	97	0	175809ba-08c8-4701-b3e1-7e9bd5d44ce1	5918ce87-5e18-4792-9e13-6669c7682f96
  E	e-cs-00	Pre-TU publications 	Exclude, before TU/e employment	44	0	40062717-e7c6-4cba-8229-539341674187	5918ce87-5e18-4792-9e13-6669c7682f96
  E	e-msm-00	Pre-TU publications 	Exclude, before TU/e employment	42	0	11240ade-67de-4d31-9673-a12a39b178bf	5918ce87-5e18-4792-9e13-6669c7682f96
  E	e-es-00	Pre-TU publications 	Exclude, before TU/e employment	103	0	85c0f999-dd2f-4fbf-b2c6-84051f7152c4	5918ce87-5e18-4792-9e13-6669c7682f96
  E	e-epe-00	Pre-TU publications 	Exclude, before TU/e employment	83	0	b757ee98-d05c-468f-a964-4e852acb060b	5918ce87-5e18-4792-9e13-6669c7682f96
  E	e-ees-00	Pre-TU publications 	Exclude, before TU/e employment	16	0	d6984c6a-e58a-4aa9-8455-603d0326baba	5918ce87-5e18-4792-9e13-6669c7682f96
  E	e-personal	Pre TU & All other research faculty E	Exclude, during TU/e employment	200	0	bdca651d-9621-4fc5-9671-e49e78e7e5ed	fe4092dc-3eb9-46c1-902d-be1e28ec1945
  EsoE	ESoE-personal	Output - niet TU/e 	Exclude, before TU/e employment	556	37	c8d287f3-86ce-40bc-9e36-6d3cb56aa403	5918ce87-5e18-4792-9e13-6669c7682f96
  ID	ID-personal	Non related research projects 	Exclude, before TU/e employment	117	0	9101b933-683e-459e-a5b9-205b9e94e171	5918ce87-5e18-4792-9e13-6669c7682f96
  IEC	IEC-personal	Non-project related research output IEC 	Exclude, before TU/e employment	20	11	437d8710-3b7e-4eb5-8a01-55d92b95ad82	5918ce87-5e18-4792-9e13-6669c7682f96
  IEIS	TM-T&B-npg	Non project related results T&B	Exclude, during TU/e employment	10	1	3f7ec64a-ffef-40e8-9b51-a8665462765c	fe4092dc-3eb9-46c1-902d-be1e28ec1945
  IEIS	IEIS-ECIS-Extern	External publications Ecis	Exclude, before TU/e employment	58	1	30524690-5f48-4827-bbe8-25bd6247274e	5918ce87-5e18-4792-9e13-6669c7682f96
  IEIS	TM-OSM-npg	Niet projectgebonden onderzoeksresultaten OSM 	Exclude, during TU/e employment	3	0	7bfeb8df-1288-460d-9edd-e6738b268ebf	fe4092dc-3eb9-46c1-902d-be1e28ec1945
  IEIS	TM-OPAC-npg	Non project related results OPAC 	Exclude, during TU/e employment	40	0	475b6dd6-8bd9-45bc-a94a-b9477211fcef	fe4092dc-3eb9-46c1-902d-be1e28ec1945
  IEIS	TM-IS-npg	Non project related results IS 	Exclude, before TU/e employment	0	0	a10f7abd-de80-4dba-9c06-d2183ec25542	5918ce87-5e18-4792-9e13-6669c7682f96
  IEIS	TM-BM-npg	Non project related results BM 	Exclude, before TU/e employment	1	0	7e90a22f-0a98-4816-8caf-a5c5964b7769	5918ce87-5e18-4792-9e13-6669c7682f96
  IEIS	TM-AW-npg	Non project related results AW	Exclude, before TU/e employment	51	6	07f234a2-8b26-4a58-b64c-6b2c4144eb76	5918ce87-5e18-4792-9e13-6669c7682f96
  IEIS	TM-personal	Niet programma gebonden onderzoek IEIS 	Exclude, during TU/e employment	70	11	0d976a35-796b-43d3-af34-94952b67228c	fe4092dc-3eb9-46c1-902d-be1e28ec1945
  IEIS	TM-old	Voormalig Onderzoek TM	Include, but affiliation unknown	110	0	b02e257d-3118-4409-9b5a-bdcdafcd650c	5918ce87-5e18-4792-9e13-6669c7682f96
  IEIS	IEIS-overig	Personal (external) Output 	Exclude, before TU/e employment	994	24	577fa99c-79ed-4295-a83d-348554efb175	5918ce87-5e18-4792-9e13-6669c7682f96
  ST	STSMO-99	Other research / not applicable 	Exclude, before TU/e employment	27	0	c3fb1e29-5c76-4ab1-839f-4e1828e63e35	5918ce87-5e18-4792-9e13-6669c7682f96
  ST	ST-old 	Alle voormalig onderzoek ST 	Include, but affiliation unknown	3955	5	29f20f68-0c60-4b4f-aa83-8316c18950f8	5918ce87-5e18-4792-9e13-6669c7682f96
  ST	ST-Personal	Non related research projects ST or TU/e	Exclude, during TU/e employment	256	1	edf361ba-ec5b-4162-92cb-ae610cae532f	fe4092dc-3eb9-46c1-902d-be1e28ec1945
  TN	TN-personal	Non related research projects 	Exclude, during TU/e employment	231	0	f5140c63-cbbe-4c8a-b4a8-62b637b19a25	fe4092dc-3eb9-46c1-902d-be1e28ec1945
  TN	TN-oud	Old Research TN 	Include, but affiliation unknown	78	0	ed3d5ebb-960a-4cda-84b3-5111691f2173	5918ce87-5e18-4792-9e13-6669c7682f96
  W	W-personal	non related Researh Programs W 	Exclude, before TU/e employment	164	0	de207f7e-3dc8-4395-a310-be9599ea6130	5918ce87-5e18-4792-9e13-6669c7682f96
  W&I	WSKI-Personal	Non related research projects	Exclude, before TU/e employment	4467	0	49030e41-b405-439c-98cc-0fe53d793079	5918ce87-5e18-4792-9e13-6669c7682f96

-->
  <!-- 310e1a7c-3c8b-4aca-971b-53b380b71246 man org 0d976a35-796b-43d3-af34-94952b67228c--> 
  <!-- organisatie issue met de2dce3b-999d-4e48-b361-cd7023c66a50-->
  <!-- photonic integration non related 6 stuks 01f64696-776a-4ece-9b8e-a1dbbc91f773-->
  <!-- 422ba8ad-88fc-4af4-8794-936ad195657e utf-8 issue -->

  <xsl:variable name="DepartmentWI" select="'49030e41-b405-439c-98cc-0fe53d793079'" />
  <xsl:variable name="DepartmentW" select="'de207f7e-3dc8-4395-a310-be9599ea6130'" />
  <xsl:variable name="DepartmentTN" select="'f5140c63-cbbe-4c8a-b4a8-62b637b19a25 ed3d5ebb-960a-4cda-84b3-5111691f2173'" />
  <xsl:variable name="DepartmentST" select="'c3fb1e29-5c76-4ab1-839f-4e1828e63e35 29f20f68-0c60-4b4f-aa83-8316c18950f8 edf361ba-ec5b-4162-92cb-ae610cae532f'" />
  <xsl:variable name="DepartmentIEIS" select="'3f7ec64a-ffef-40e8-9b51-a8665462765c 30524690-5f48-4827-bbe8-25bd6247274e 7bfeb8df-1288-460d-9edd-e6738b268ebf 475b6dd6-8bd9-45bc-a94a-b9477211fcef a10f7abd-de80-4dba-9c06-d2183ec25542 7e90a22f-0a98-4816-8caf-a5c5964b7769 07f234a2-8b26-4a58-b64c-6b2c4144eb76 0d976a35-796b-43d3-af34-94952b67228c b02e257d-3118-4409-9b5a-bdcdafcd650c 577fa99c-79ed-4295-a83d-348554efb175'" />
  <xsl:variable name="DepartmentID" select="'9101b933-683e-459e-a5b9-205b9e94e171'" />
  <xsl:variable name="DepartmentESOE" select="'c8d287f3-86ce-40bc-9e36-6d3cb56aa403'" />
  <xsl:variable name="DepartmentE" select="'e7307d19-af59-4493-b395-991fe2436460 daff56fd-c564-4b54-84c5-ebad4d4d152a 4948bd0a-5386-49e8-80c1-5a2d5b737c70 01f64696-776a-4ece-9b8e-a1dbbc91f773 ea167ae0-c267-45f1-b8de-b53c16377766 175809ba-08c8-4701-b3e1-7e9bd5d44ce1 40062717-e7c6-4cba-8229-539341674187 11240ade-67de-4d31-9673-a12a39b178bf 85c0f999-dd2f-4fbf-b2c6-84051f7152c4 b757ee98-d05c-468f-a964-4e852acb060b d6984c6a-e58a-4aa9-8455-603d0326baba bdca651d-9621-4fc5-9671-e49e78e7e5ed'" />
  <xsl:variable name="DepartmentBMT" select="'e763fae0-b082-4c51-8028-f578ad71d00c afe085e3-1390-4160-811e-1f38c4e713a8'" />
  <xsl:variable name="DepartmentB" select="'9962b90c-d5c2-432f-ae86-f86eb011c29b 8406a238-029b-4006-ba93-d6760704e51c'" />

  <xsl:variable name="organisationsToBeRemoved" select="'9962b90c-d5c2-432f-ae86-f86eb011c29b 8406a238-029b-4006-ba93-d6760704e51c e763fae0-b082-4c51-8028-f578ad71d00c afe085e3-1390-4160-811e-1f38c4e713a8 e7307d19-af59-4493-b395-991fe2436460 daff56fd-c564-4b54-84c5-ebad4d4d152a 4948bd0a-5386-49e8-80c1-5a2d5b737c70 01f64696-776a-4ece-9b8e-a1dbbc91f773 ea167ae0-c267-45f1-b8de-b53c16377766 175809ba-08c8-4701-b3e1-7e9bd5d44ce1 40062717-e7c6-4cba-8229-539341674187 11240ade-67de-4d31-9673-a12a39b178bf 85c0f999-dd2f-4fbf-b2c6-84051f7152c4 b757ee98-d05c-468f-a964-4e852acb060b d6984c6a-e58a-4aa9-8455-603d0326baba bdca651d-9621-4fc5-9671-e49e78e7e5ed c8d287f3-86ce-40bc-9e36-6d3cb56aa403 9101b933-683e-459e-a5b9-205b9e94e171 437d8710-3b7e-4eb5-8a01-55d92b95ad82 3f7ec64a-ffef-40e8-9b51-a8665462765c 30524690-5f48-4827-bbe8-25bd6247274e 7bfeb8df-1288-460d-9edd-e6738b268ebf 475b6dd6-8bd9-45bc-a94a-b9477211fcef a10f7abd-de80-4dba-9c06-d2183ec25542 7e90a22f-0a98-4816-8caf-a5c5964b7769 07f234a2-8b26-4a58-b64c-6b2c4144eb76 0d976a35-796b-43d3-af34-94952b67228c b02e257d-3118-4409-9b5a-bdcdafcd650c 577fa99c-79ed-4295-a83d-348554efb175 c3fb1e29-5c76-4ab1-839f-4e1828e63e35 29f20f68-0c60-4b4f-aa83-8316c18950f8 edf361ba-ec5b-4162-92cb-ae610cae532f f5140c63-cbbe-4c8a-b4a8-62b637b19a25 ed3d5ebb-960a-4cda-84b3-5111691f2173 de207f7e-3dc8-4395-a310-be9599ea6130 49030e41-b405-439c-98cc-0fe53d793079'" />
  <xsl:variable name="duringEmployment" select="'9962b90c-d5c2-432f-ae86-f86eb011c29b afe085e3-1390-4160-811e-1f38c4e713a8 01f64696-776a-4ece-9b8e-a1dbbc91f773 bdca651d-9621-4fc5-9671-e49e78e7e5ed 3f7ec64a-ffef-40e8-9b51-a8665462765c 7bfeb8df-1288-460d-9edd-e6738b268ebf 475b6dd6-8bd9-45bc-a94a-b9477211fcef 0d976a35-796b-43d3-af34-94952b67228c edf361ba-ec5b-4162-92cb-ae610cae532f f5140c63-cbbe-4c8a-b4a8-62b637b19a25'"/>
  <xsl:variable name="outsideEmployment" select="'e763fae0-b082-4c51-8028-f578ad71d00c e7307d19-af59-4493-b395-991fe2436460 daff56fd-c564-4b54-84c5-ebad4d4d152a 4948bd0a-5386-49e8-80c1-5a2d5b737c70 ea167ae0-c267-45f1-b8de-b53c16377766 175809ba-08c8-4701-b3e1-7e9bd5d44ce1 40062717-e7c6-4cba-8229-539341674187 11240ade-67de-4d31-9673-a12a39b178bf 85c0f999-dd2f-4fbf-b2c6-84051f7152c4 b757ee98-d05c-468f-a964-4e852acb060b d6984c6a-e58a-4aa9-8455-603d0326baba c8d287f3-86ce-40bc-9e36-6d3cb56aa403 9101b933-683e-459e-a5b9-205b9e94e171 437d8710-3b7e-4eb5-8a01-55d92b95ad82 30524690-5f48-4827-bbe8-25bd6247274e a10f7abd-de80-4dba-9c06-d2183ec25542 7e90a22f-0a98-4816-8caf-a5c5964b7769 07f234a2-8b26-4a58-b64c-6b2c4144eb76 577fa99c-79ed-4295-a83d-348554efb175 c3fb1e29-5c76-4ab1-839f-4e1828e63e35 de207f7e-3dc8-4395-a310-be9599ea6130 49030e41-b405-439c-98cc-0fe53d793079'"/>
 
  <!-- Step 1: Copy everything -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Step 2: remove all unwanted organisations at authors and replace with placeholder 
  <xsl:template match="p:author[p:person[@origin='internal']]/p:organisations/p:organisation">
    <xsl:choose>
      <xsl:when test="contains(concat(' ', $organisationsToBeRemoved, ' '),concat(' ', ./@id, ' '))">
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="/p:publications/*/p:organisations/p:organisation/@id = ./@id">
            <xsl:choose>
              <xsl:when test="contains(concat(' ', $duringEmployment, ' '),concat(' ', ./@id, ' '))">
                <organisation id="fe4092dc-3eb9-46c1-902d-be1e28ec1945"/>
              </xsl:when>
              <xsl:otherwise>
                <organisation id="5918ce87-5e18-4792-9e13-6669c7682f96"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="contains(concat(' ', $organisationsToBeRemoved, ' '),concat(' ', ./@id, ' '))">
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy>
              <xsl:apply-templates select="@*|node()"/>
            </xsl:copy>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template> -->

  <!-- Step 2: remove all unwanted organisations at authors and replace with placeholder 
  <xsl:template match="p:author[p:person[@origin='internal']]/p:organisations/p:organisation">
    <xsl:choose>
      <xsl:when test="contains(concat(' ', $organisationsToBeRemoved, ' '),concat(' ', ./@id, ' '))">
        <xsl:choose>
          <xsl:when test="contains(concat(' ', $duringEmployment, ' '),concat(' ', ./@id, ' '))">
            <organisation id="fe4092dc-3eb9-46c1-902d-be1e28ec1945"/>
          </xsl:when>
          <xsl:otherwise>
            <organisation id="5918ce87-5e18-4792-9e13-6669c7682f96"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->

  <!-- Step 2: remove all unwanted organisations at authors and replace with placeholder -->
  <xsl:template match="p:author[p:person[@origin='internal']]/p:organisations/p:organisation">
    <xsl:choose>
      <xsl:when test="contains(concat(' ', $organisationsToBeRemoved, ' '),concat(' ', ./@id, ' '))">
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- Step 3: add placeholder organisation to all internal authors without an affiliation
  <xsl:template match="p:author[p:person[@origin='internal'] and not (p:organisations)]">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <organisations>
        OUTSIDE moet eigenlijk opgehaald : twee versies van modificaties maken?
        <organisation id="5918ce87-5e18-4792-9e13-6669c7682f96"/>
        DURING moet eigenlijk opgehaald : twee versies van modificaties maken? 
        <organisation id="fe4092dc-3eb9-46c1-902d-be1e28ec1945"/>
      </organisations>
    </xsl:copy>
  </xsl:template>-->

  <!-- Step 4: Replace owner if needed -->
  <xsl:template match="p:owner">
    <xsl:call-template name="replace-owner">
      <xsl:with-param name="currentOwner" select="./@id"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Step 5: remove all organisation mentions not at author level -->
  <xsl:template match="/p:publications/*/p:organisations">
  </xsl:template>
  
    
  <!-- function templates -->
  <xsl:template name="replace-owner">
    <xsl:param name="currentOwner"/>
    <owner>
      <xsl:attribute name="id">
        <xsl:choose>
          <xsl:when test="contains(concat(' ', $organisationsToBeRemoved, ' '),concat(' ', $currentOwner, ' '))">
            <xsl:choose>
              <xsl:when test="count(../p:organisations/p:organisation) > 1">
                <xsl:call-template name="affiliationOfFirstInternalOrganisation" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="contains(concat(' ', $DepartmentWI, ' '),concat(' ', $currentOwner, ' '))">
                    <xsl:value-of select="'e6ae38b6-692b-49dd-ab2d-a740165e28d5'"/>
                  </xsl:when>
                  <xsl:when test="contains(concat(' ', $DepartmentW, ' '),concat(' ', $currentOwner, ' '))">
                    <xsl:value-of select="'761371e4-6bd2-49cb-a9c4-5694bb9e01d1'"/>
                  </xsl:when>
                  <xsl:when test="contains(concat(' ', $DepartmentTN, ' '),concat(' ', $currentOwner, ' '))">
                    <xsl:value-of select="'43deb459-9d78-4cbb-9a13-5266d1e146bc'"/>
                  </xsl:when>
                  <xsl:when test="contains(concat(' ', $DepartmentST, ' '),concat(' ', $currentOwner, ' '))">
                    <xsl:value-of select="'8aa12328-bc35-4bb5-a1ae-555294e4ded5'"/>
                  </xsl:when>
                  <xsl:when test="contains(concat(' ', $DepartmentIEIS, ' '),concat(' ', $currentOwner, ' '))">
                    <xsl:value-of select="'e9f81f7f-a2eb-4d6e-b90f-15749f9e0b3b'"/>
                  </xsl:when>
                  <xsl:when test="contains(concat(' ', $DepartmentID, ' '),concat(' ', $currentOwner, ' '))">
                    <xsl:value-of select="'20cda6d2-da57-42ef-8639-6fb5b6b51549'"/>
                  </xsl:when>
                  <xsl:when test="contains(concat(' ', $DepartmentESOE, ' '),concat(' ', $currentOwner, ' '))">
                    <xsl:value-of select="'9d582194-9e9c-4d78-bcd8-95677df86c01'"/>
                  </xsl:when>
                  <xsl:when test="contains(concat(' ', $DepartmentE, ' '),concat(' ', $currentOwner, ' '))">
                    <xsl:value-of select="'fbe49471-080b-42ee-9cc8-5c730e4c0351'"/>
                  </xsl:when>
                  <xsl:when test="contains(concat(' ', $DepartmentBMT, ' '),concat(' ', $currentOwner, ' '))">
                    <xsl:value-of select="'e0f04165-de96-4596-b533-1aba2511bd22'"/>
                  </xsl:when>
                  <xsl:when test="contains(concat(' ', $DepartmentB, ' '),concat(' ', $currentOwner, ' '))">
                    <xsl:value-of select="'350156d1-ae6a-4a17-8429-3eab020cfc22'"/>
                  </xsl:when>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="./@id"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </owner>
  </xsl:template>

  <xsl:template name="replace-affiliation">
    <xsl:param name="currentAffiliation"/>
    <organisation>
      <xsl:attribute name="id">
        <xsl:choose>
          <xsl:when test="contains(concat(' ', $duringEmployment, ' '),concat(' ', $currentAffiliation, ' '))">
            <xsl:value-of select="'fe4092dc-3eb9-46c1-902d-be1e28ec1945'"/>
          </xsl:when>
          <xsl:when test="contains(concat(' ', $outsideEmployment, ' '),concat(' ', $currentAffiliation, ' '))">
            <xsl:value-of select="'5918ce87-5e18-4792-9e13-6669c7682f96'"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="currentAffiliation"/> <!-- als er een gewone organisatie staat wat doen? -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </organisation>
  </xsl:template>

  <xsl:template name="affiliationOfFirstInternalOrganisation">
    <xsl:choose>
         <xsl:when test="contains(concat(' ', $organisationsToBeRemoved, ' '),concat(' ', /p:publications/*/p:organisations/p:organisation[1]/@id, ' '))">
        <xsl:value-of select="../p:organisations/p:organisation/@id[2]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="../p:organisations/p:organisation[1]/@id"/>
      </xsl:otherwise>
    </xsl:choose>
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

