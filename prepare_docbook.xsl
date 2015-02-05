<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- identity template -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Get rid of deleted text and comments -->
    <xsl:template match="section[title[count(element())=1 and emphasis[@role='deletedtext']]]"/>
    <xsl:template match="emphasis[@role='deletedtext']"/>
    <xsl:template match="para[count(element())=1 and emphasis[@role='commenttext']]"/>
    <xsl:template match="emphasis[@role='commenttext']"/>

    <!-- Remove the highlight from new text -->
    <xsl:template match="emphasis[@role='newtext']">
        <xsl:apply-templates select="node()"/>
    </xsl:template>

    <!-- Convert emphasised DRAFT in subtitle to (DRAFT) -->
    <xsl:template match="emphasis[ancestor::subtitle]">
        <xsl:text>(</xsl:text>
        <xsl:apply-templates select="node()"/>
        <xsl:text>)</xsl:text>
    </xsl:template>

    <!-- Get rid of spurious paragraphs containing only
         whitespace/non-breaking-space. -->
    <xsl:template match="para[count(element()) = 0]/text()[matches(., '^[ &#160;]+$')]"/>
</xsl:stylesheet>
