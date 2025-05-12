<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="3.0" xmlns="http://www.w3.org/2005/xpath-functions"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:didl="urn:mpeg:mpeg21:2002:02-DIDL-NS" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:dii="urn:mpeg:mpeg21:2002:01-DII-NS" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:didmodel="urn:mpeg:mpeg21:2002:02-DIDMODEL-NS" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dip="urn:mpeg:mpeg21:2005:01-DIP-NS" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

<xsl:output method="text" indent="yes" />

<xsl:template match="/">
  <xsl:variable name="xml-transformed">
    <xsl:apply-templates select="/PubmedArticleSet/PubmedArticle"/>
  </xsl:variable>
  <xsl:value-of select="xml-to-json($xml-transformed)"/>
</xsl:template>

<xsl:template match="MedlineCitation">
  <map>
    <map key="@context">
      <string key="schema">https://schema.org/</string>
      <string key="@vocab">schema</string>
    </map>
    <string key="@type">schema:ScholarlyArticle</string>
    <map key="schema:title">
      <string key="@value"><xsl:value-of select="normalize-space(Article/ArticleTitle)"/></string>
      <string key="@language">en</string>
    </map>
    <!-- <xsl:apply-templates select="Article/Abstract"/> -->
    <!-- <xsl:apply-templates select="mods:relatedItem"/> -->
    <array key="schema:identifier">
      <xsl:for-each select="Article/ELocationID">
        <map>
          <string key="schema:propertyID"><xsl:value-of select="@EIdType"/></string>
          <string key="schema:value"><xsl:value-of select="normalize-space(text())"/></string>
        </map>
      </xsl:for-each>
    </array>
    <array key="schema:author">
      <xsl:for-each select="Article/AuthorList/Author">
        <map>
          <string key="schema:givenName"><xsl:value-of select="normalize-space(ForeName)"/></string>
          <string key="schema:familyName"><xsl:value-of select="normalize-space(LastName)"/></string>
          <xsl:if test="Identifier">
            <array key="schema:identifier">
              <xsl:for-each select="Identifier">
                <map>
                  <string key="schema:propertyID"><xsl:value-of select="@Source"/></string>
                  <string key="schema:value"><xsl:value-of select="normalize-space(text())"/></string>
                </map>
              </xsl:for-each>
            </array>
          </xsl:if>
        </map>
      </xsl:for-each>
    </array>
  </map>
</xsl:template>

</xsl:stylesheet>