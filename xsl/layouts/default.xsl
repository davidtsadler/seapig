<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs">

<xsl:template name="layout-default">
  <xsl:param name="serviceBtn" as="element()*"/>
  <xsl:param name="navbar" as="element()*"/>
  <xsl:param name="content" as="element()+"/>
  <xsl:param name="pageTitle" select="''" as="xs:string"/>
<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html>
&lt;html>
</xsl:text>
  <head>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <meta name="viewport" content="width=device-width"/>
    <title><xsl:copy-of select="$pageTitle"/> - Seapig (Beta)</title>
    <link rel="stylesheet" href="http://code.jquery.com/mobile/1.3.0/jquery.mobile-1.3.0.min.css"/>
    <link rel="stylesheet" href="/css/seapig.css"/>
    <script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
    <script src="http://code.jquery.com/mobile/1.3.0/jquery.mobile-1.3.0.min.js"></script>
  </head>
  <body>
    <div data-role="page">
      <div data-role="header">
        <div class="ui-btn-left">
          <a href="/" data-role="button" data-inline="true" data-icon="home">Home</a>
          <xsl:copy-of select="$serviceBtn"/>
        </div>
        <h1><xsl:value-of select="$pageTitle"/></h1>
      </div>
      <xsl:copy-of select="$navbar"/>
      <div data-role="content">
      <xsl:copy-of select="$content"/>
      </div>
      <div data-role="footer">
        <h4>Site developed by <a href="http://davidtsadler.com/" target="_blank" title="Link to the site's developer.">David T. Sadler.</a></h4>
      </div>
    </div>
  </body>
<xsl:text disable-output-escaping='yes'>
&lt;/html>
</xsl:text>
</xsl:template>

</xsl:stylesheet>
