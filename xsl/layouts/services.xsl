<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="services" mode="layout">
  <xsl:variable name="content" as="element()+">
    <h2>Services</h2>
    <p>Listed below are most of the services available via the eBay API.</p> 
    <ul data-role="listview" data-inset="true">
    <xsl:apply-templates select="category" mode="layout"/>
    </ul>
  </xsl:variable>
  <xsl:call-template name="layout-default">		
    <xsl:with-param name="content" select="$content"/>
    <xsl:with-param name="pageTitle" select="'Services'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="category" mode="layout">
  <li data-role="list-divider"><xsl:value-of select="@name"/></li>
  <xsl:apply-templates select="service" mode="layout"/>
</xsl:template>

<xsl:template match="service" mode="layout">
  <li><a href="{replace(lower-case(@name), ' ', '_')}/"><xsl:value-of select="@name"/></a></li>
</xsl:template>

</xsl:stylesheet>
