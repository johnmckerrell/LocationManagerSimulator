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
        <xsl:variable name="sec"><xsl:value-of select="position() mod 60"/></xsl:variable>
        <xsl:variable name="seconds"><xsl:if test="$sec &lt; 10">0</xsl:if><xsl:value-of select="$sec"/></xsl:variable>
        <xsl:variable name="mins"><xsl:value-of select="floor(position() div 60) mod 60"/></xsl:variable>
        <xsl:variable name="minutes"><xsl:if test="$mins &lt; 10">0</xsl:if><xsl:value-of select="$mins"/></xsl:variable>
        <xsl:variable name="hrs"><xsl:value-of select="floor(position() div 3600)"/></xsl:variable>
        <xsl:variable name="hours"><xsl:if test="$hrs &lt; 10">0</xsl:if><xsl:value-of select="$hrs"/></xsl:variable>
        <dict>
            <key>time</key>
            <date>2014-01-16T<xsl:value-of select="$hours"/>:<xsl:value-of select="$minutes"/>:<xsl:value-of select="$seconds"/>Z</date>
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
