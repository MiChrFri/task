<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="input" select="lower-case('hello my world')"/>
    <xsl:output indent="yes"/>
    <xsl:template match="/">
        <xsl:variable name="string_leng" select="string-length($input)"/>
        <xsl:variable name="breakcharacters">
            <root>
                <xsl:analyze-string select="$input" regex="\c">
                    <xsl:matching-substring>
                        <char val="{.}" count="{$string_leng - string-length(replace($input,.,''))}"
                        />
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </root>
        </xsl:variable>

        <xsl:variable name="new_structure">
            <root>
                <xsl:for-each select="$breakcharacters//char">
                    <xsl:variable name="val" select="@val"/>
                    <xsl:choose>
                        <xsl:when test="preceding-sibling::char/@val = $val"/>
                        <xsl:otherwise>
                            <xsl:copy-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </root>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$new_structure//char[@count > 1][@count mod 2 = 1]">                
                <xsl:apply-templates select="$new_structure//char[@count > 1][1]"/>
                <xsl:text>
                    
                </xsl:text>
                <xsl:value-of
                    select="codepoints-to-string(count($new_structure//char[@count = 1]) - 1 + 65)"
                />
            </xsl:when>
            <xsl:otherwise>                
                <xsl:apply-templates select="$new_structure//char[@count > 1][1]"/>
                <xsl:text>
                    
                </xsl:text>
                <xsl:value-of
                    select="codepoints-to-string(count($new_structure//char[@count = 1]) + 65)"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="char">
        <xsl:variable name="val" select="@val"/>
        <xsl:variable name="root" select=".."/>
        <xsl:choose>
            <xsl:when test="@count mod 2 = 0">
                <xsl:value-of select="@val"/>
                <xsl:value-of select="$root//*[@count = 1][1]/@val"/>
                <xsl:apply-templates select="following-sibling::char[@count > 1]"/>
                <xsl:value-of select="@val"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="1 to @count">
                    <xsl:value-of select="$val"/>
                    <xsl:if test="position() != last()">
                        <xsl:value-of select="$root//char[@count = 2][1]/@val"/>
                    </xsl:if>

                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
