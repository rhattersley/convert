<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- identity template -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="emphasis[@role='deletedtext']">
    </xsl:template>
    <xsl:template match="emphasis[@role='newtext']">
        <xsl:apply-templates select="node()"/>
    </xsl:template>
</xsl:stylesheet>
