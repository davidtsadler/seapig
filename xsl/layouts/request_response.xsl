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
  <xsl:param name="serviceName" as="xs:string"/>
  <xsl:variable name="serviceBtn" as="element()+">
    <a href="../../" class="ui-btn ui-btn-b ui-btn-inline ui-mini ui-corner-all ui-btn-icon-left ui-icon-arrow-l"><xsl:value-of select="$serviceName"/></a>
  </xsl:variable>
  <xsl:variable name="navbar" as="element()+">
    <div data-role="navbar">
      <ul>
        <li><a href="" class="ui-btn-active ui-state-persist">Request</a></li>
        <li><a href="../response/">Response</a></li>
      </ul>
    </div> 
  </xsl:variable>
  <xsl:variable name="content" as="element()+">
    <h2>Request</h2>
    <form class="ui-filterable">
      <input id="request-filter" data-type="search" placeholder="Filter request..."/>
    </form>
    <ul data-role="listview" data-inset="true" data-filter="true" data-input="#request-filter">
    <xsl:apply-templates select="request/*" mode="layout"/>
    </ul>
  </xsl:variable>
  <xsl:call-template name="layout-default">
    <xsl:with-param name="serviceBtn" select="$serviceBtn"/>
    <xsl:with-param name="navbar" select="$navbar"/>
    <xsl:with-param name="content" select="$content"/>
    <xsl:with-param name="pageTitle" select="@name"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="operation" mode="layout-response">
  <xsl:param name="serviceName" as="xs:string"/>
  <xsl:variable name="serviceBtn" as="element()+">
    <a href="../../" class="ui-btn ui-btn-b ui-btn-inline ui-mini ui-corner-all ui-btn-icon-left ui-icon-arrow-l"><xsl:value-of select="$serviceName"/></a>
  </xsl:variable>
  <xsl:variable name="navbar" as="element()+">
    <div data-role="navbar">
      <ul>
        <li><a href="../request/">Request</a></li>
        <li><a href="" class="ui-btn-active ui-state-persist">Response</a></li>
      </ul>
    </div> 
  </xsl:variable>
  <xsl:variable name="content" as="element()+">
    <h2>Response</h2>
    <form class="ui-filterable">
      <input id="response-filter" data-type="search" placeholder="Filter response..."/>
    </form> 
    <ul data-role="listview" data-inset="true" data-filter="true" data-input="#response-filter">
    <xsl:apply-templates select="response/*" mode="layout"/>
    </ul>
  </xsl:variable>
  <xsl:call-template name="layout-default">
    <xsl:with-param name="serviceBtn" select="$serviceBtn"/>
    <xsl:with-param name="navbar" select="$navbar"/>
    <xsl:with-param name="content" select="$content"/>
    <xsl:with-param name="pageTitle" select="@name"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="*" mode="layout">
  <xsl:variable name="ancestors" as="xs:string*">
    <xsl:for-each select="ancestor::*">
      <xsl:sort select="position()" order="ascending"/>
      <xsl:if test="position() > 3">
        <xsl:value-of select="concat(name(), ' ')"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <xsl:element name="li">
    <xsl:if test="@deprecated">
      <xsl:attribute name="class" select="'deprecated'"/>
    </xsl:if>
    <xsl:attribute name="data-filtertext">
      <xsl:value-of select="$ancestors"/>
      <xsl:value-of select="name()"/>
    </xsl:attribute>
    <div class="ui-grid-a">
      <div class="ui-block-a">
        <ul>
          <li><xsl:value-of select="$ancestors"/><strong><xsl:if test="@is-attribute">[</xsl:if><xsl:value-of select="name()"/><xsl:if test="@is-attribute">]</xsl:if></strong></li>
          <xsl:apply-templates select="@type" mode="layout"/>
          <xsl:apply-templates select="@required|@returned" mode="layout"/>
          <xsl:apply-templates select="@repeatable" mode="layout"/>
        </ul>
      </div>
      <div class="ui-block-b"><xsl:if test="@deprecated"><strong>Deprecated as of version <xsl:value-of select="@deprecated"/>.</strong></xsl:if><xsl:value-of select="description" disable-output-escaping="yes"/></div>          
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

<xsl:template match="@repeatable" mode="layout">
  <li><b class="repeatable">Repeatable: [<xsl:value-of select="."/>]</b></li>
</xsl:template>

</xsl:stylesheet>
