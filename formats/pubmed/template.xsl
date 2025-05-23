<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="3.0" xmlns="http://www.w3.org/2005/xpath-functions"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:didl="urn:mpeg:mpeg21:2002:02-DIDL-NS" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:dii="urn:mpeg:mpeg21:2002:01-DII-NS" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:didmodel="urn:mpeg:mpeg21:2002:02-DIDMODEL-NS" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dip="urn:mpeg:mpeg21:2005:01-DIP-NS" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

<xsl:output method="text" indent="yes" />

<xsl:import href="../common/normalize-identifier.xsl"/>
<xsl:import href="../common/serialize.xsl"/>

<xsl:template match="/">
  <xsl:variable name="xml-transformed">
    <xsl:apply-templates select="/PubmedArticleSet/PubmedArticle"/>
  </xsl:variable>
  <xsl:value-of select="xml-to-json($xml-transformed)"/>
</xsl:template>

<xsl:template match="PubmedArticle">
  <map>
    <map key="@context">
      <string key="schema">https://schema.org/</string>
      <string key="@vocab">schema</string>
    </map>
    <string key="@id"><xsl:value-of select="normalize-space(PubmedData/ArticleIdList/ArticleId[@IdType=pubmed]/text())"/></string>
    <map key="@graph">
      <string key="@type">schema:ScholarlyArticle</string>
      <map key="schema:title">
        <string key="@value"><xsl:value-of select="normalize-space(MedlineCitation/Article/ArticleTitle)"/></string>
        <string key="@language">en</string>
      </map>
      <xsl:apply-templates select="MedlineCitation/Article/Abstract"/>
      <xsl:apply-templates select="MedlineCitation/Article/Journal"/>
      <array key="schema:identifier">
        <xsl:for-each select="PubmedData/ArticleIdList/ArticleId">
          <xsl:call-template name="normalize-identifier">
            <xsl:with-param name="scheme" select="@IdType"/>
            <xsl:with-param name="value" select="text()"/>
          </xsl:call-template>
        </xsl:for-each>
      </array>
      <array key="schema:author">
        <xsl:for-each select="MedlineCitation/Article/AuthorList/Author">
          <map>
            <string key="schema:givenName"><xsl:value-of select="normalize-space(ForeName)"/></string>
            <string key="schema:familyName"><xsl:value-of select="normalize-space(LastName)"/></string>
            <array key="schema:affiliation">
              <xsl:for-each select="AffiliationInfo">
                <map>
                  <string key="@type">schema:Organization</string>
                  <string key="schema:name"><xsl:value-of select="normalize-space(Affiliation)"/></string>
                </map>
              </xsl:for-each>
            </array>
            <xsl:if test="Identifier">
              <array key="schema:identifier">
                <xsl:for-each select="Identifier">
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
      <array key="schema:citation">
        <xsl:for-each select="PubmedData/ReferenceList/Reference">
          <map>
            <string key="@type">schema:Quotation</string>
            <string key="schema:text"><xsl:value-of select="normalize-space(Citation)"/></string>
            <array key="schema:identifier">
              <xsl:for-each select="ArticleIdList/ArticleId">
                  <xsl:call-template name="normalize-identifier">
                    <xsl:with-param name="scheme" select="@IdType"/>
                    <xsl:with-param name="value" select="text()"/>
                  </xsl:call-template>
              </xsl:for-each>
            </array>
          </map>
        </xsl:for-each>
      </array>
    </map>
  </map>
</xsl:template>

<xsl:template match="Abstract">
  <map key="schema:abstract">
    <string key="@value"><xsl:apply-templates select="AbstractText/node()" mode="serialize"/></string>
    <string key="@language"><xsl:value-of select="@lang"/></string>
  </map>
</xsl:template>

<xsl:template match="Journal">
    <map key="schema:isPartOf">
      <string key="@type">schema:PublicationIssue</string>
      <string key="schema:datePublished"><xsl:value-of select="normalize-space(JournalIssue/PubDate/Year)"/>-<xsl:value-of select="normalize-space(JournalIssue/PubDate/Month)"/>-<xsl:value-of select="normalize-space(JournalIssue/PubDate/Day)"/></string>
      <map key="schema:isPartOf">
        <string key="@type">schema:PublicationVolume</string>
        <!-- <string key="schema:volumeNumber"><xsl:value-of select="mods:part/mods:detail[@type='volume']/mods:number"/></string> -->
        <map key="schema:isPartOf">
          <string key="@type">schema:Periodical</string>
          <string key="schema:name"><xsl:value-of select="normalize-space(Title)"/></string>
          <xsl:apply-templates select="mods:originInfo/mods:publisher"/>
          <array key="schema:issn">
            <xsl:for-each select="ISSN">
              <string><xsl:value-of select="normalize-space(text())"/></string>
            </xsl:for-each>
          </array>
        </map>
      </map>
    </map>
</xsl:template>

</xsl:stylesheet>