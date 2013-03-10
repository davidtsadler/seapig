<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs">

<xsl:output method="html" encoding="UTF-8" indent="yes"/>

<xsl:include href="layouts/call_reference.xsl" />
<xsl:include href="layouts/default.xsl" />

<xsl:param name="destDirectory" required="yes" as="xs:string"/>
<xsl:param name="wsdlDirectory" required="yes" as="xs:string"/>

<xsl:template match="/">
  <xsl:apply-templates select="//service"/>
</xsl:template>

<xsl:template match="service">
  <xsl:variable name="href" select="replace(lower-case(@name), ' ', '_')" as="xs:string"/>
  <xsl:result-document href="{$destDirectory}/{$href}/index.html">
    <xsl:apply-templates select="." mode="layout"/>
  </xsl:result-document>
</xsl:template>

</xsl:stylesheet>
