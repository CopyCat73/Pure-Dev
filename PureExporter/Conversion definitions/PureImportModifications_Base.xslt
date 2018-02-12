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

</xsl:stylesheet>

