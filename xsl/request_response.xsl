<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
  xmlns:dts="http://davidtsadler.com/"
  exclude-result-prefixes="xs">

<xsl:output method="html" encoding="UTF-8" indent="yes" use-character-maps="dts:html"/>

<xsl:include href="operation_doc.xsl" />
<xsl:include href="layouts/request_response.xsl" />
<xsl:include href="layouts/default.xsl" />

<xsl:param name="destDirectory" required="yes" as="xs:string"/>
<xsl:param name="wsdlDirectory" required="yes" as="xs:string"/>

<xsl:character-map name="dts:html">
  <xsl:output-character character="&lt;" string="&lt;"/>
  <xsl:output-character character="&gt;" string="&gt;"/>
</xsl:character-map>

<xsl:template match="/">
  <xsl:apply-templates select="//service"/>
</xsl:template>

<xsl:template match="service">
  <xsl:variable name="wsdl" select="document(concat(concat($wsdlDirectory,'/'),@local-wsdl))" as="document-node()"/>
  <xsl:variable name="href" select="replace(lower-case(@name), ' ', '_')" as="xs:string"/>
  <xsl:variable name="serviceName" select="@name" as="xs:string"/>
  <xsl:for-each select="$wsdl//wsdl:portType/wsdl:operation">
    <xsl:variable name="operation" as="element()+">
      <xsl:apply-templates select="." mode="operation-doc"/>
    </xsl:variable>
    <xsl:result-document href="{$destDirectory}/{$href}/{@name}/request/index.html">
      <xsl:apply-templates select="$operation" mode="layout-request">
        <xsl:with-param name="serviceName" select="$serviceName"/>
      </xsl:apply-templates>
    </xsl:result-document>
    <xsl:result-document href="{$destDirectory}/{$href}/{@name}/response/index.html">
      <xsl:apply-templates select="$operation" mode="layout-response">
        <xsl:with-param name="serviceName" select="$serviceName"/>
      </xsl:apply-templates>
    </xsl:result-document>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
