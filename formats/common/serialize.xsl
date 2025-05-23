<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="3.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:didl="urn:mpeg:mpeg21:2002:02-DIDL-NS" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:dii="urn:mpeg:mpeg21:2002:01-DII-NS" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:didmodel="urn:mpeg:mpeg21:2002:02-DIDMODEL-NS" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dip="urn:mpeg:mpeg21:2005:01-DIP-NS" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

<xsl:template match="*" mode="serialize">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:apply-templates select="@*" mode="serialize" />
    <xsl:choose>
        <xsl:when test="node()">
            <xsl:text>&gt;</xsl:text>
            <xsl:apply-templates mode="serialize" />
            <xsl:text>&lt;/</xsl:text>
            <xsl:value-of select="name()"/>
            <xsl:text>&gt;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text> /&gt;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="@*" mode="serialize">
    <xsl:text> </xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>="</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"</xsl:text>
</xsl:template>

<xsl:template match="text()" mode="serialize">
    <xsl:value-of select="."/>
</xsl:template>

</xsl:stylesheet>