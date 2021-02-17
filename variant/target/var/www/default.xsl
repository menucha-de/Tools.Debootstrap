<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html"/>

<xsl:template match="/">
 <html>
 <head>
   <link rel="stylesheet" type="text/css" href="style.css"></link>
 </head>
 <body>
 <xsl:apply-templates/>
 </body>
 </html>
</xsl:template>

<xsl:template match="document">
  <p>
  <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="chapter">
  <div class="chapter">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="title">
  <h1>
    <xsl:apply-templates/>
  </h1>
</xsl:template>

<xsl:template match="code">
  <code>
    <xsl:apply-templates/>
  </code>
</xsl:template>

<xsl:template match="text">
  <p>
    <xsl:apply-templates/>
  </p>
</xsl:template>

</xsl:stylesheet>
