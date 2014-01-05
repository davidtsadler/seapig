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
    <title><xsl:copy-of select="$pageTitle"/> - Seapig (v<xsl:copy-of select="$version"/>)</title>
    <meta name="author" content="David T. Sadler"/>
    <meta name="description" content="Navigate and read the eBay API documentation on your mobile device with ease. This is my unoffical Spartan eBay API Guide."/>
    <meta name="copyright" content="Copyright 2014 by David T. Sadler. All Rights Reserved."/>
    <meta name="robots" content="follow, noindex, noodp, noydir, noarchive"/>
    <meta name="viewport" content="width=device-width"/>
    <link rel="stylesheet" href="//code.jquery.com/mobile/1.4.0/jquery.mobile-1.4.0.min.css"/>
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css"/>
    <link rel="stylesheet" href="/css/seapig.css"/>
    <script src="//code.jquery.com/jquery-1.10.2.min.js"></script>
    <script src="//code.jquery.com/mobile/1.4.0/jquery.mobile-1.4.0.min.js"></script>
  </head>
  <body>
    <div data-role="page">
      <div data-role="header">
        <div class="ui-mini ui-btn-left">
          <a href="/" class="ui-btn ui-btn-inline ui-mini ui-corner-all ui-btn-icon-left ui-icon-home">Home</a>
          <xsl:copy-of select="$serviceBtn"/>
        </div>
        <h1><xsl:value-of select="$pageTitle"/></h1>
        <a href="/about/" class="ui-btn-right ui-btn ui-btn-inline ui-mini ui-corner-all ui-btn-icon-left ui-icon-info">About</a>
        <xsl:copy-of select="$navbar"/>
      </div>
      <div data-role="content">
      <xsl:copy-of select="$content"/>
      </div>
      <div data-role="footer">
        <h4>Site developed by <a href="http://davidtsadler.com/" target="_blank" title="Link to the site's developer.">David T. Sadler.</a></h4>
        <h6>
          Share<br/>
          <a class="social-btn google" href="https://plus.google.com/share?url=http%3A%2F%2Fseapig.net%2F" title="Share on Google Plus"><i class="fa fa-google-plus fa-fw fa-2x"></i></a>
          <a class="social-btn twitter" href="https://twitter.com/intent/tweet?url=http%3A%2F%2Fseapig.net%2F&amp;text=Navigate%20and%20read%20the%20eBay%20API%20documentation%20on%20your%20mobile%20device%20with%20ease.&amp;hashtags=ebay,development" title="Share on Twitter"><i class="fa fa-twitter fa-fw fa-2x"></i></a> 
          <a class="social-btn facebook" href="https://www.facebook.com/sharer/sharer.php?u=http%3A%2F%2Fseapig.net%2F" title="Share on Facebook"><i class="fa fa-facebook fa-fw fa-2x"></i></a>
        </h6>
        <h6>Version: <xsl:copy-of select="$version"/></h6>
      </div>
    </div>
    <script>
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
      ga('create', 'UA-46823708-1', 'seapig.net');
      ga('send', 'pageview');
    </script>
  </body>
<xsl:text disable-output-escaping='yes'>
&lt;/html>
</xsl:text>
</xsl:template>

</xsl:stylesheet>
