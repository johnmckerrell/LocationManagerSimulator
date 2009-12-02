<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' xmlns:gpx="http://www.topografix.com/GPX/1/0" version='1.0'>
    <xsl:output indent="yes" method="xml"/>

    <xsl:template match="/">
        <plist version="1.0">
            <array>
                <xsl:apply-templates select=".//gpx:trkpt"/>
            </array>
        </plist>
    </xsl:template>

    <xsl:template match="gpx:trkpt">
        <dict>
            <key>time</key>
            <date><xsl:choose>
                <xsl:when test="contains(gpx:time,'.')"><xsl:value-of select="substring-before(gpx:time,'.')"/>Z</xsl:when>
                <xsl:otherwise><xsl:value-of select="gpx:time"/></xsl:otherwise>
            </xsl:choose></date>
            <key>lat</key>
            <real><xsl:value-of select="@lat"/></real>
            <key>lon</key>
            <real><xsl:value-of select="@lon"/></real>
            <xsl:if test="gpx:ele">
                <key>ele</key>
                <real><xsl:value-of select="gpx:ele"/></real>
            </xsl:if>
            <xsl:if test="gpx:hdop">
                <key>hdop</key>
                <real><xsl:value-of select="gpx:hdop"/></real>
            </xsl:if>
            <xsl:if test="gpx:vdop">
                <key>vdop</key>
                <real><xsl:value-of select="gpx:vdop"/></real>
            </xsl:if>
        </dict>
    </xsl:template>

</xsl:stylesheet>
