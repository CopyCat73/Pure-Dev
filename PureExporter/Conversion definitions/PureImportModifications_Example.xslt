<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="v1.publication-import.base-uk.pure.atira.dk"
                xmlns:p="v1.publication-import.base-uk.pure.atira.dk"
                xmlns:ns2="v3.commons.pure.atira.dk" 
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                exclude-result-prefixes="p">

	<xsl:output method="xml" indent="yes" omit-xml-declaration="no" encoding ="utf-8"/>

	<!-- Step 1: Copy everything -->
	<xsl:template match="@*|node()">
	<xsl:copy>
	  <xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
	</xsl:template>

	<!-- Step 2: Prepend "Copy of" to the record title -->
  
	<!-- Title -->
	<xsl:if test="./title/text()">
	  <title>
		<ns2:text>
		  <xsl:attribute name="lang">
			<xsl:call-template name="GetLastSegmentBeforeUnderscore">
			  <xsl:with-param name="value" select="./language/@uri"/>
			</xsl:call-template>
		  </xsl:attribute>
		  <xsl:attribute name="country">
			<xsl:call-template name="GetLastSegmentAfterUnderscore">
			  <xsl:with-param name="value" select="./language/@uri"/>
			</xsl:call-template>
		  </xsl:attribute>
		  Copy of <xsl:value-of select="./title" />
		</ns2:text>
	  </title>
	</xsl:if>  
   
 
</xsl:stylesheet>

