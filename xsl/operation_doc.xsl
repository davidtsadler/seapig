<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
  xmlns:dts="http://davidtsadler.com/">

<xsl:template match="wsdl:portType/wsdl:operation" mode="operation-doc">
  <xsl:element name="operation">
    <xsl:attribute name="name" select="@name"/>
    <xsl:element name="request">
      <xsl:apply-templates select="wsdl:input" mode="operation-doc">
        <xsl:with-param name="operation" select="@name" tunnel="yes"/>
        <xsl:with-param name="inOut" select="'in'" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:element>
    <xsl:element name="response">
      <xsl:apply-templates select="wsdl:output" mode="operation-doc">
        <xsl:with-param name="operation" select="@name" tunnel="yes"/>
        <xsl:with-param name="inOut" select="'out'" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:element>
</xsl:template>

<xsl:template match="wsdl:input|wsdl:output" mode="operation-doc">
  <xsl:variable name="local-name" select="substring-after(@message, ':')"/>
  <xsl:variable name="type" select="substring-after(//xs:element[@name=$local-name]/@type, ':')"/>
  <xsl:variable name="deprecationVersion" select="dts:get_deprecation_version(//xs:complexType[@name=$type],'')" as="xs:string?"/>
  <xsl:element name="{$local-name}">
    <xsl:attribute name="type" select="$type"/>
    <xsl:if test="$deprecationVersion">
      <xsl:attribute name="deprecated" select="$deprecationVersion"/>
    </xsl:if>
    <xsl:apply-templates select="//xs:complexType[@name=$type]" mode="operation-doc">
      <xsl:with-param name="anti-recursion" select="''"/>
    </xsl:apply-templates>
  </xsl:element>
</xsl:template>

<xsl:template match="xs:complexType" mode="operation-doc">
  <xsl:param name="operation" as="xs:string" tunnel="yes"/>
  <xsl:param name="inOut" as="xs:string" tunnel="yes"/>
  <xsl:param name="anti-recursion" as="xs:string"/>
  <xsl:apply-templates select="xs:complexContent/xs:extension" mode="operation-doc">
    <xsl:with-param name="anti-recursion" select="concat($anti-recursion, ' ', @name)"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="xs:simpleContent/xs:extension" mode="operation-doc">
    <xsl:with-param name="anti-recursion" select="concat($anti-recursion, ' ', @name)"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="xs:attribute[dts:include_field(., $operation, $inOut)]" mode="operation-doc">
    <xsl:with-param name="anti-recursion" select="concat($anti-recursion, ' ', @name)"/>
    <xsl:sort select="@name"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="xs:sequence//xs:element[dts:include_field(., $operation, $inOut)]" mode="operation-doc">
    <xsl:with-param name="anti-recursion" select="concat($anti-recursion, ' ', @name)"/>
    <xsl:sort select="@name"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="xs:extension" mode="operation-doc">
  <xsl:param name="operation" as="xs:string" tunnel="yes"/>
  <xsl:param name="inOut" as="xs:string" tunnel="yes"/>
  <xsl:param name="anti-recursion" as="xs:string"/>
  <xsl:variable name="type" select="if (contains(@base, ':'))
                          then substring-after(@base, ':')
                          else @base"/>
  <xsl:apply-templates select="//xs:complexType[@name=$type]" mode="operation-doc">
    <xsl:with-param name="anti-recursion" select="$anti-recursion"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="xs:attribute[dts:include_field(., $operation, $inOut)]" mode="operation-doc">
    <xsl:with-param name="anti-recursion" select="$anti-recursion"/>
    <xsl:sort select="@name"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="xs:sequence//xs:element[dts:include_field(., $operation, $inOut)]" mode="operation-doc">
    <xsl:with-param name="anti-recursion" select="$anti-recursion"/>
    <xsl:sort select="@name"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="xs:element|xs:attribute" mode="operation-doc">
  <xsl:param name="operation" as="xs:string" tunnel="yes"/>
  <xsl:param name="inOut" as="xs:string" tunnel="yes"/>
  <xsl:param name="anti-recursion" as="xs:string"/>
  <xsl:variable name="type" select="substring-after(@type, ':')"/>
  <xsl:variable name="deprecationVersion" select="dts:get_deprecation_version(., $operation)"/>
  <xsl:element name="{@name}">
    <xsl:attribute name="type" select="$type"/>
    <xsl:if test="name()='xs:attribute'">
      <xsl:attribute name="is-attribute"/>
    </xsl:if>
    <xsl:if test="$deprecationVersion">
        <xsl:attribute name="deprecated" select="$deprecationVersion"/>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="$inOut='in'">
        <xsl:attribute name="required" select="dts:get_required_input(., $operation)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="returned" select="dts:get_required_output(., $operation)"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="dts:halt_recursion($anti-recursion, $type)">
        <xsl:attribute name="recursive" select="'true'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="description">
          <xsl:apply-templates select="xs:annotation/xs:documentation"/>
        </xsl:element>
        <xsl:apply-templates select="//xs:complexType[@name=$type]" mode="operation-doc">
          <xsl:with-param name="anti-recursion" select="concat($anti-recursion, ' ', $type)"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:element>
</xsl:template>

<xsl:template match="xs:annotation/xs:documentation">
  <!-- Remove spaces found within elements, E.g. <  /li> -->
  <xsl:value-of select="replace(replace(., '&lt;/*\s+(b|i|code|/)', '&lt;$1'), '&lt;\s+field', '')"/>
</xsl:template>

<xsl:function name="dts:halt_recursion" as="xs:boolean">
  <xsl:param name="anti-recursion" as="xs:string"/>
  <xsl:param name="type" as="xs:string"/>
  <xsl:choose>
    <xsl:when test="$type='string' or $type='integer' or $type='dateTime' or $type='boolean' or $type='int' or $type='float' or $type='decimal' or $type='double' or $type='time'">
      <xsl:sequence select="false()"/>
    </xsl:when>
    <xsl:when test="count(tokenize($anti-recursion,' ')[.=$type]) > 2">
      <xsl:sequence select="true()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="false()"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="dts:include_field" as="xs:boolean">
  <xsl:param name="field" as="element()"/>
  <xsl:param name="operation" as="xs:string"/>
  <xsl:param name="inOut" as="xs:string"/>
  <xsl:choose>
    <xsl:when test="$inOut='in'">
      <xsl:sequence select="string-length(dts:get_required_input($field, $operation)) > 0"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="string-length(dts:get_required_output($field, $operation)) > 0"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="dts:get_required_input" as="xs:string">
  <xsl:param name="field" as="element()?"/>
  <xsl:param name="operation" as="xs:string"/>
  <xsl:variable name="appInfo" select="$field/xs:annotation/xs:appinfo" as="element()?"/>
  <xsl:choose>
    <xsl:when test="$appInfo">
      <xsl:variable name="str" select="string(($appInfo/*:CallInfo[*:AllCalls or *:CallName=$operation or (*:AllCallsExcept and not(tokenize(*:AllCallsExcept,', ')=$operation))][*:RequiredInput]/*:RequiredInput)[1])"/>
      <xsl:choose>
        <xsl:when test="$str='Yes'">
          <xsl:sequence select="'Required'"/>
        </xsl:when>
        <xsl:when test="$str='No'">
          <xsl:sequence select="'Optional'"/>
        </xsl:when>
        <xsl:when test="$str='Conditionally'">
          <xsl:sequence select="'Conditional'"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="str" select="string(($appInfo/*:callInfo[*:allCalls or *:callName=$operation or (*:allCallsExcept and not(tokenize(*:allCallsExcept,', ')=$operation))][*:requiredInput]/*:requiredInput)[1])"/>
          <xsl:choose>
            <xsl:when test="$str='Yes'">
              <xsl:sequence select="'Required'"/>
            </xsl:when>
            <xsl:when test="$str='No'">
              <xsl:sequence select="'Optional'"/>
            </xsl:when>
            <xsl:when test="$str='Conditionally'">
              <xsl:sequence select="'Conditional'"/>
            </xsl:when>
            <xsl:otherwise><xsl:sequence select="''"/></xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="'Required'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="dts:get_required_output" as="xs:string">
  <xsl:param name="field" as="element()"/>
  <xsl:param name="operation" as="xs:string"/>
  <xsl:variable name="appInfo" select="$field/xs:annotation/xs:appinfo" as="element()?" />
  <xsl:choose>
    <xsl:when test="$appInfo">
      <xsl:variable name="str" select="string(($appInfo/*:CallInfo[*:AllCalls or *:CallName=$operation or (*:AllCallsExcept and not(tokenize(*:AllCallsExcept,', ')=$operation))][*:Returned]/*:Returned)[1])"/>
      <xsl:choose>
        <xsl:when test="$str!=''">
          <xsl:sequence select="$str"/>
        </xsl:when>
        <xsl:otherwise>
        <xsl:sequence select="string(($appInfo/*:callInfo[*:allCalls or *:callName=$operation or (*:allCallsExcept and not(tokenize(*:allCallsExcept,', ')=$operation))][*:returned]/*:returned)[1])"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="'Always'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="dts:get_app_info" as="element()?">
  <xsl:param name="field" as="element()"/>
  <xsl:copy-of select="$field/xs:annotation/xs:appinfo"/>
</xsl:function>

<xsl:function name="dts:get_call_info" as="element()?">
  <xsl:param name="field" as="element()"/>
  <xsl:param name="operation" as="xs:string"/>
  <xsl:variable name="appInfo" select="dts:get_app_info($field)" as="element()?"/>
  <xsl:choose>
    <xsl:when test="$appInfo">
      <xsl:variable name="callInfo" select="($appInfo/*:CallInfo[*:AllCalls or *:CallName=$operation or (*:AllCallsExcept and not(tokenize(*:AllCallsExcept,', ')=$operation))])[1] | ($appInfo/*:callInfo[*:allCalls or *:callName=$operation or (*:allCallsExcept and not(tokenize(*:allCallsExcept,', ')=$operation))])[1]"/>
      <xsl:copy-of select="$callInfo"/>
    </xsl:when>
  </xsl:choose>
</xsl:function>

<xsl:function name="dts:get_deprecation_version" as="xs:string?">
  <xsl:param name="field" as="element()"/>
  <xsl:param name="operation" as="xs:string"/>
  <xsl:variable name="appInfo" select="dts:get_app_info($field)" as="element()?"/>
  <xsl:variable name="appInfoAlt" select="dts:get_call_info($field, $operation)/*:DeprecationVersion"/>
  <xsl:choose>
    <xsl:when test="$appInfo/*:DeprecationVersion">
      <xsl:value-of select="$appInfo/*:DeprecationVersion"/>
    </xsl:when>
    <xsl:when test="$appInfo/*:deprecationVersion">
      <xsl:value-of select="$appInfo/*:deprecationVersion"/>
    </xsl:when>
    <xsl:when test="$appInfoAlt/*:DeprecationVersion">
      <xsl:value-of select="$appInfoAlt/*:DeprecationVersion"/>
    </xsl:when>
    <xsl:when test="$appInfoAlt/*:deprecationVersion">
      <xsl:value-of select="$appInfoAlt/*:deprecationVersion"/>
    </xsl:when>
  </xsl:choose>
</xsl:function>

</xsl:stylesheet>
