<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  version="2.0"
  xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
  xmlns:dts="http://davidtsadler.com/"
  exclude-result-prefixes="xs wsdl dts">

<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="destDirectory" required="yes" as="xs:string"/>
<xsl:param name="wsdlDirectory" required="yes" as="xs:string"/>
<xsl:param name="site-url" as="xs:string" select="'http://seapig.net'"/>
<xsl:param name="last-mod" as="xs:string" select="format-date(current-date(),'[Y]-[M01]-[D01]')"/>

<xsl:template match="/">
  <xsl:result-document href="{$destDirectory}/sitemap.xml">
    <urlset>
      <xsl:copy-of select="dts:url('', 'monthly', '0.9')"/>
      <xsl:copy-of select="dts:url('/about', 'monthly', '1.0')"/>
      <xsl:apply-templates select="//service" mode="sitemap"/>
    </urlset>
  </xsl:result-document>
</xsl:template>

<xsl:template match="service" mode="sitemap">
  <xsl:variable name="service" select="replace(lower-case(@name), ' ', '_')" as="xs:string"/>
  <xsl:variable name="wsdl" select="document(concat(concat($wsdlDirectory,'/'),@local-wsdl))" as="document-node()"/>
  <xsl:copy-of select="dts:url(concat('/', $service), 'weekly', '0.5')"/>
  <xsl:apply-templates select="$wsdl//wsdl:portType/wsdl:operation" mode="sitemap">
    <xsl:with-param name="service" select="$service"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="wsdl:portType/wsdl:operation" mode="sitemap">
  <xsl:param name="service" as="xs:string"/>
  <xsl:copy-of select="dts:url(concat('/', $service, '/', @name, '/request'), 'weekly', '0.5')"/>
  <xsl:copy-of select="dts:url(concat('/', $service, '/', @name, '/response'), 'weekly', '0.5')"/>
</xsl:template>

<xsl:function name="dts:url" as="element()+">
  <xsl:param name="loc" as="xs:string"/>
  <xsl:param name="change-freq" as="xs:string"/>
  <xsl:param name="priority" as="xs:string"/>
  <url> 
    <loc><xsl:copy-of select="concat($site-url, $loc, '/')"/></loc>
    <lastmod><xsl:copy-of select="$last-mod"/></lastmod>
    <changefreq><xsl:copy-of select="$change-freq"/></changefreq>
    <priority><xsl:copy-of select="$priority"/></priority>
  </url>
</xsl:function>
</xsl:stylesheet>
