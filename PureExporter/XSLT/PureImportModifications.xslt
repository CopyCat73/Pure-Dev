<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="v1.publication-import.base-uk.pure.atira.dk" xmlns:ns2="v3.commons.pure.atira.dk" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <xsl:output method="xml" indent="yes" omit-xml-declaration="no" encoding ="utf-8"/>




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

