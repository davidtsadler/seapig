<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
  xmlns:wsdlsoap="http://schemas.xmlsoap.org/wsdl/soap/"
  xmlns:soap12="http://schemas.xmlsoap.org/wsdl/soap12/"
  exclude-result-prefixes="xs wsdl wsdlsoap soap12">

<xsl:template match="service" mode="layout">
  <xsl:variable name="wsdl" select="document(concat(concat($wsdlDirectory,'/'),@local-wsdl))" as="document-node()"/>
  <xsl:variable name="version" select="if (exists($wsdl//wsdl:service/wsdl:documentation/*:Version))
                                               then $wsdl//wsdl:service/wsdl:documentation/*:Version
                                               else $wsdl//wsdl:service/wsdl:documentation/*:version" as="xs:string"/>
  <xsl:variable name="prodEndpoint" select="if (exists($wsdl//wsdl:service/*/wsdlsoap:address))
                                               then $wsdl//wsdl:service/*/wsdlsoap:address/@location
                                               else $wsdl//wsdl:service/*/soap12:address/@location" as="xs:string"/>
  <xsl:variable name="sandboxEndpoint" select="replace($prodEndpoint,'ebay.com','sandbox.ebay.com')" as="xs:string"/>
  <xsl:variable name="content" as="element()+">
    <div data-role="collapsible" data-theme="b" data-content-theme="c">
      <h2><xsl:value-of select="@name"/> API <small>Version <xsl:value-of select="$version"/></small></h2>
      <h3>Service Endpints</h3>
      <dl>
        <dt>Sandbox</dt><dd><xsl:value-of select="$prodEndpoint"/></dd>
        <dt>Production</dt><dd><xsl:value-of select="$sandboxEndpoint"/></dd>
      </dl>
      <xsl:apply-templates select="ebay-urls" mode="layout"/>
    </div>
    <h3>Call Reference</h3>
    <ul data-role="listview" data-inset="true" data-filter="true">
    <xsl:apply-templates select="$wsdl//wsdl:portType/wsdl:operation" mode="layout">
      <xsl:sort select="@name"/>
    </xsl:apply-templates>
    </ul>
  </xsl:variable>
  <xsl:call-template name="layout-default">
    <xsl:with-param name="content" select="$content"/>
    <xsl:with-param name="pageTitle" select="@name"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="ebay-urls" mode="layout">
  <h3>eBay Documentation</h3>
  <ul data-role="listview" data-inset="true">
  <xsl:apply-templates select="url" mode="layout"/>
  </ul>
</xsl:template>

<xsl:template match="url" mode="layout">
  <li><a href="{@href}" target="_blank"><xsl:value-of select="@name"/></a></li>
</xsl:template>

<xsl:template match="wsdl:portType/wsdl:operation" mode="layout">
  <li><a href="{@name}/request/"><xsl:value-of select="@name"/></a></li>
</xsl:template>
</xsl:stylesheet>
