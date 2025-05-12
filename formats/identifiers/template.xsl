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
            <value><xsl:value-of select="$value"/></value>
        </id>
    </xsl:variable>

    <xsl:apply-templates select="$ident/id"/>
</xsl:template>

<xsl:template match="id[scheme='orcid']">
    <map xmlns="http://www.w3.org/2005/xpath-functions">
        <string key="propertyID"><xsl:value-of select="scheme"/></string>
        <string key="value">
            <xsl:analyze-string select="value/text()" regex="(\d\d\d\d)\-?(\d\d\d\d)\-?(\d\d\d\d)\-?(\d\d\d\d)">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>-<xsl:value-of select="regex-group(2)"/>-<xsl:value-of select="regex-group(3)"/>-<xsl:value-of select="regex-group(4)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </string>
    </map>
</xsl:template>

<xsl:template match="id[scheme='isni']">
    <map xmlns="http://www.w3.org/2005/xpath-functions">
        <string key="propertyID"><xsl:value-of select="scheme"/></string>
        <string key="value">
            <xsl:analyze-string select="value/text()" regex="(\d\d\d\d)\-?(\d\d\d\d)\-?(\d\d\d\d)\-?(\d\d\d\d)">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>-<xsl:value-of select="regex-group(2)"/>-<xsl:value-of select="regex-group(3)"/>-<xsl:value-of select="regex-group(4)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </string>
    </map>
</xsl:template>

<xsl:template match="id[scheme='isbn']">
    <map xmlns="http://www.w3.org/2005/xpath-functions">
        <string key="propertyID"><xsl:value-of select="scheme"/></string>
        <string key="value">
            <xsl:analyze-string select="value/text()" regex="(978|979)?-?(\d)-?(\d)-?(\d)-?(\d)-?(\d)-?(\d)-?(\d)-?(\d)-?(\d)-?(\d)">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/><xsl:value-of select="regex-group(2)"/><xsl:value-of select="regex-group(3)"/><xsl:value-of select="regex-group(4)"/><xsl:value-of select="regex-group(5)"/><xsl:value-of select="regex-group(6)"/><xsl:value-of select="regex-group(7)"/><xsl:value-of select="regex-group(8)"/><xsl:value-of select="regex-group(9)"/><xsl:value-of select="regex-group(10)"/><xsl:value-of select="regex-group(11)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </string>
    </map>
</xsl:template>


<xsl:template match="id[scheme='issn']">
    <map xmlns="http://www.w3.org/2005/xpath-functions">
        <string key="propertyID"><xsl:value-of select="scheme"/></string>
        <string key="value">
            <xsl:analyze-string select="value/text()" regex="(\d{{4}})-?(\d{{4}})">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>-<xsl:value-of select="regex-group(2)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </string>
    </map>
</xsl:template>

<xsl:template match="id[scheme='doi']">
    <map xmlns="http://www.w3.org/2005/xpath-functions">
        <string key="propertyID"><xsl:value-of select="scheme"/></string>
        <string key="value">
            <xsl:analyze-string select="value/text()" regex=".*?(10\.\S+)">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </string>
    </map>
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
    <map xmlns="http://www.w3.org/2005/xpath-functions">
        <string key="propertyID"><xsl:value-of select="scheme"/></string>
        <string key="value">
            <xsl:analyze-string select="value/text()" regex=".*?(\d+)">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </string>
    </map>
</xsl:template>

<xsl:template match="id[scheme='pmc']">
    <map xmlns="http://www.w3.org/2005/xpath-functions">
        <string key="propertyID"><xsl:value-of select="scheme"/></string>
        <string key="value">
            <xsl:analyze-string select="value/text()" regex=".*?(\d+)">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </string>
    </map>
</xsl:template>

<xsl:template match="id">
    <map xmlns="http://www.w3.org/2005/xpath-functions">
        <string key="propertyID">Not matched</string>
        <string key="value">scheme: '<xsl:value-of select="scheme"/>', value: '<xsl:value-of select="value"/>'</string>
    </map>
</xsl:template>

</xsl:stylesheet>







