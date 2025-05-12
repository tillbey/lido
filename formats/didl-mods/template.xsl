<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
  xmlns="http://www.w3.org/2005/xpath-functions"
  xmlns:oai="http://www.openarchives.org/OAI/2.0/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:didl="urn:mpeg:mpeg21:2002:02-DIDL-NS"
  xmlns:mods="http://www.loc.gov/mods/v3"
  xmlns:dii="urn:mpeg:mpeg21:2002:01-DII-NS"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:didmodel="urn:mpeg:mpeg21:2002:02-DIDMODEL-NS"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:dip="urn:mpeg:mpeg21:2005:01-DIP-NS"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

<xsl:output method="text" indent="yes" />

<xsl:import href="../identifiers/template.xsl"/>

<xsl:template match="/">
  <xsl:variable name="json">
    <array>
      <xsl:apply-templates select="//oai:record/oai:metadata/didl:DIDL/didl:Item/didl:Item/didl:Component/didl:Resource"/>
    </array>
  </xsl:variable>
  <xsl:copy-of select="xml-to-json($json)"/>
</xsl:template>

<xsl:template match="mods:mods">
  <map>
    <map key="@context">
      <string key="schema">https://schema.org/</string>
      <string key="@vocab">schema</string>
    </map>
    <string key="@type">schema:ScholarlyArticle</string>
    <map key="schema:title">
      <string key="@value"><xsl:value-of select="mods:titleInfo/mods:title"/></string>
      <string key="@language"><xsl:value-of select="mods:titleInfo/@lang"/></string>
    </map>
  <xsl:apply-templates select="mods:abstract"/>
  <array key="relatedItem">
    <xsl:apply-templates select="mods:relatedItem"/>
  </array>
    <array key="schema:identifier">
      <xsl:for-each select="mods:identifier[not(@type='local')]">
        <xsl:call-template name="normalize-identifier">
            <xsl:with-param name="scheme" select="@type"/>
            <xsl:with-param name="value" select="text()"/>
        </xsl:call-template>
      </xsl:for-each>
    </array>
    <array key="schema:author">
      <xsl:for-each select="mods:name[@type='personal']">
        <map>
          <string key="schema:givenName"><xsl:value-of select="mods:namePart[@type='given']"/></string>
          <string key="schema:familyName"><xsl:value-of select="mods:namePart[@type='family']"/></string>
          <xsl:if test="Identifier">
            <array key="schema:identifier">
              <xsl:for-each select="mods:nameIdentifier">
                <xsl:call-template name="normalize-identifier">
                  <xsl:with-param name="scheme" select="@Source"/>
                  <xsl:with-param name="value" select="text()"/>
                </xsl:call-template>
              </xsl:for-each>
            </array>
          </xsl:if>
        </map>
      </xsl:for-each>
    </array>
  </map>
</xsl:template>

<xsl:template match="mods:abstract">
  <map key="schema:abstract">
    <string key="@value"><xsl:value-of select="."/></string>
    <string key="@language"><xsl:value-of select="@lang"/></string>
  </map>
</xsl:template>

<xsl:template match="mods:relatedItem">
  <map>
    <map key="schema:isPartOf">
      <string key="@type">schema:PublicationIssue</string>
      <map key="schema:isPartOf">
        <string key="@type">schema:PublicationVolume</string>
        <string key="schema:volumeNumber"><xsl:value-of select="mods:part/mods:detail[@type='volume']/mods:number"/></string>
        <map key="schema:isPartOf">
          <string key="@type">schema:Periodical</string>
          <string key="schema:name"><xsl:value-of select="mods:titleInfo/mods:title"/></string>
          <string key="schema:publisher"><xsl:value-of select="mods:originInfo/mods:publisher"/></string>
          <array key="schema:issn">
            <xsl:for-each select="mods:identifier[@type='issn']">
              <string><xsl:value-of select="text()"/></string>
            </xsl:for-each>
          </array>
        </map>
      </map>
    </map>
    <string key="schema:pageStart"><xsl:value-of select="mods:part/mods:extent/mods:start"/></string>
    <string key="schema:pageEnd"><xsl:value-of select="mods:part/mods:extent/mods:end"/></string>
  </map>
</xsl:template>


</xsl:stylesheet>