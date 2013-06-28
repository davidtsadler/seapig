<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
  xmlns:wsdlsoap="http://schemas.xmlsoap.org/wsdl/soap/"
  xmlns:soap12="http://schemas.xmlsoap.org/wsdl/soap12/"
  exclude-result-prefixes="xs wsdl wsdlsoap soap12">

<xsl:template match="operation" mode="layout-request">
  <xsl:variable name="content" as="element()+">
    <h3>Request</h3>
    <ul data-role="listview" data-inset="true" data-filter="true">
    <xsl:apply-templates select="request/*" mode="layout"/>
    </ul>
  </xsl:variable>
  <xsl:call-template name="layout-default">
    <xsl:with-param name="content" select="$content"/>
    <xsl:with-param name="pageTitle" select="@name"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="operation" mode="layout-response">
  <xsl:variable name="content" as="element()+">
    <h3>Response</h3>
    <ul data-role="listview" data-inset="true" data-filter="true">
    <xsl:apply-templates select="response/*" mode="layout"/>
    </ul>
  </xsl:variable>
  <xsl:call-template name="layout-default">
    <xsl:with-param name="content" select="$content"/>
    <xsl:with-param name="pageTitle" select="@name"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="*" mode="layout">
  <xsl:element name="li">
    <xsl:attribute name="data-filtertext" select="name()"/>
    <div class="ui-grid-a">
      <div class="ui-block-a">
        <ul>
          <li><strong><xsl:value-of select="name()"/></strong></li>
          <xsl:apply-templates select="@type" mode="layout"/>
          <xsl:apply-templates select="@required|@returned" mode="layout"/>
        </ul>
      </div>
      <div class="ui-block-b"><xsl:value-of select="description" disable-output-escaping="yes"/></div>          
    </div>
  </xsl:element>
  <xsl:apply-templates select="* except(description)" mode="layout"/>
</xsl:template>

<xsl:template match="@type" mode="layout">
  <li><b class="type"><xsl:value-of select="."/></b></li>
</xsl:template>

<xsl:template match="@required|@returned" mode="layout">
  <li><b class="occurrence"><xsl:value-of select="."/></b></li>
</xsl:template>

</xsl:stylesheet>
