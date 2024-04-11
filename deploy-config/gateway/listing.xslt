<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="1.0">
  <xsl:output method="html" indent="yes" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>
  <xsl:param name="host"/>
  <xsl:param name="port"/>
  <xsl:template match="/list">
    <h1>Available Projects:</h1>
    <xsl:apply-templates select="directory"/>
  </xsl:template>
  <xsl:template match="directory">
    <xsl:variable name="project_name" select="."/>
    <h2><xsl:value-of select="$project_name"/></h2>
    <table style="border: 1px solid;">
      <tr>
        <th>Service</th>
        <th>URL</th>
      </tr>
      <tr>
        <td>OGC WMS/WFS</td>
        <td><a href="http://{$project_name}.{$host}:{$port}/ogc/">http://<xsl:value-of select="$project_name"/>.<xsl:value-of select="$host"/>:<xsl:value-of select="$port"/>/ogc/</a></td>
      </tr>
      <tr>
        <td>OGC API Features (WFS3)</td>
        <td><a href="http://{$project_name}.{$host}:{$port}/wfs3/">http://<xsl:value-of select="$project_name"/>.<xsl:value-of select="$host"/>:<xsl:value-of select="$port"/>/wfs3/</a></td>
      </tr>
    </table>
  </xsl:template>
</xsl:stylesheet>
