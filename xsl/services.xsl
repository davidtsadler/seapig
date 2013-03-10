<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs">

<xsl:output method="html" encoding="UTF-8" indent="yes"/>

<xsl:include href="layouts/services.xsl" />
<xsl:include href="layouts/default.xsl" />

<xsl:param name="destDirectory" required="yes" as="xs:string"/>

<xsl:template match="/">
  <xsl:result-document href="{$destDirectory}/index.html">
    <xsl:apply-templates select="services" mode="layout"/>
  </xsl:result-document>
</xsl:template>

</xsl:stylesheet>
