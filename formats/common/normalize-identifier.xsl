<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:math="http://www.w3.org/2005/xpath-functions/math"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl"
	version="3.0">

<xsl:template name="normalize-identifier">
    <xsl:param name="scheme"/>
    <xsl:param name="value"/>
    <xsl:variable name="ident">
        <id>
            <scheme><xsl:value-of select="replace(lower-case($scheme), 'https?://(\w+).org/?', '$1')"/></scheme>
            <value><xsl:value-of select="normalize-space($value)"/></value>
        </id>
    </xsl:variable>
    <xsl:apply-templates select="$ident/id"/>
</xsl:template>

<xsl:template name="format-identifier">
    <xsl:param name="scheme"/>
    <xsl:param name="value"/>
    <map xmlns="http://www.w3.org/2005/xpath-functions">
        <string key="@id">https://identifiers.org/<xsl:value-of select="$scheme"/>:<xsl:value-of select="$value"/></string>
        <string key="propertyID"><xsl:value-of select="$scheme"/></string>
        <string key="value"><xsl:value-of select="$value"/></string>
    </map>
</xsl:template>

<xsl:template name="format-identifier2">
    <xsl:param name="scheme"/>
    <xsl:param name="value"/>
    <xsl:param name="regex_in"/>
    <xsl:param name="regex_out"/>
    <xsl:variable name="normalized-value">
        <xsl:value-of select="replace($value, $regex_in, $regex_out)"/>
    </xsl:variable>
    <map xmlns="http://www.w3.org/2005/xpath-functions">
        <string key="@id">https://identifiers.org/<xsl:value-of select="$scheme"/>:<xsl:value-of select="$normalized-value"/></string>
        <string key="propertyID"><xsl:value-of select="$scheme"/></string>
        <string key="value"><xsl:value-of select="$normalized-value"/></string>
    </map>
</xsl:template>

<xsl:template match="id[scheme='orcid']">
    <xsl:call-template name="format-identifier2">
        <xsl:with-param name="scheme" select="scheme"/>
        <xsl:with-param name="value" select="value"/>
        <xsl:with-param name="regex_in">(\d\d\d\d)\-?(\d\d\d\d)\-?(\d\d\d\d)\-?(\d\d\d\d)</xsl:with-param>
        <xsl:with-param name="regex_out">$1-$2-$3-$4</xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template match="id[scheme='isni']">
    <xsl:call-template name="format-identifier2">
        <xsl:with-param name="scheme" select="scheme"/>
        <xsl:with-param name="value" select="value"/>
        <xsl:with-param name="regex_in">(\d\d\d\d)\-?(\d\d\d\d)\-?(\d\d\d\d)\-?(\d\d\d\d)</xsl:with-param>
        <xsl:with-param name="regex_out">$1-$2-$3-$4</xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template match="id[scheme='isbn']">
    <xsl:call-template name="format-identifier2">
        <xsl:with-param name="scheme" select="scheme"/>
        <xsl:with-param name="value" select="value"/>
        <xsl:with-param name="regex_in">(978|979)?-?(\d)-?(\d)-?(\d)-?(\d)-?(\d)-?(\d)-?(\d)-?(\d)-?(\d)-?(\d)</xsl:with-param>
        <xsl:with-param name="regex_out">$1$2$3$4$5$6$7$8$9$10$11</xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template match="id[scheme='issn']">
    <xsl:call-template name="format-identifier2">
        <xsl:with-param name="scheme" select="scheme"/>
        <xsl:with-param name="value" select="value"/>
        <xsl:with-param name="regex_in">(\d{{4}})-?(\d{{4}})</xsl:with-param>
        <xsl:with-param name="regex_out">$1$2</xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template match="id[scheme='doi']">
    <xsl:variable name="normalized-value">
        <xsl:analyze-string select="value/text()" regex=".*?(10\.\S+)">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:variable>
    <xsl:call-template name="format-identifier">
        <xsl:with-param name="scheme" select="scheme"/>
        <xsl:with-param name="value" select="$normalized-value"/>
    </xsl:call-template>
</xsl:template>

<xsl:template match="id[scheme='ror']">
    <map xmlns="http://www.w3.org/2005/xpath-functions">
        <string key="propertyID"><xsl:value-of select="scheme"/></string>
        <string key="value">
            <xsl:analyze-string select="value/text()" regex="^.*?([a-z0-9]+)$">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </string>
    </map>
</xsl:template>

<xsl:template match="id[scheme='pubmed']">
    <xsl:call-template name="format-identifier2">
        <xsl:with-param name="scheme" select="scheme"/>
        <xsl:with-param name="value" select="value"/>
        <xsl:with-param name="regex_in">.*?(\d+)</xsl:with-param>
        <xsl:with-param name="regex_out">$1</xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template match="id[scheme='pmc']">
    <xsl:call-template name="format-identifier2">
        <xsl:with-param name="scheme" select="scheme"/>
        <xsl:with-param name="value" select="value"/>
        <xsl:with-param name="regex_in">.*?(\d+)</xsl:with-param>
        <xsl:with-param name="regex_out">$1</xsl:with-param>
    </xsl:call-template>
</xsl:template>

<xsl:template match="id">
    <map xmlns="http://www.w3.org/2005/xpath-functions">
        <string key="propertyID">Not matched</string>
        <string key="value">scheme: '<xsl:value-of select="scheme"/>', value: '<xsl:value-of select="value"/>'</string>
    </map>
</xsl:template>

</xsl:stylesheet>







