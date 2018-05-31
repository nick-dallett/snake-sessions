<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="Matches">
		<table>
			<xsl:apply-templates select="Match[@Type='Keyword']" />
		</table>
	</xsl:template>
	<xsl:template match="Match[@Type='Keyword']">
	  <xsl:if test="position() mod 4 = 1">
			<tr>
				<TD>
					<xsl-if test="./@Type='Keyword'">
						<span class="keyword" column="{@Column}" onclick="keyword_select(this)" onselect = "keyword_select()"  onmouseover="keyword_mouseover(this)" onmouseout="keyword_mouseout(this)" ondblclick="keyword_dblclick(this)" ondragstart="keyword_dragstart(this)" ondragend="keyword_dragend(this)" ondrag="keyword_drag(this)"><xsl:value-of select="." />
						</span>
					</xsl-if>
				</TD>
				<TD>
					<xsl-if test="following-sibling::Match[@Type='Keyword'][1]">
						<span class="keyword" column="{@Column}" onclick="keyword_select(this)" onselect = "keyword_select()"  onmouseover="keyword_mouseover(this)" onmouseout="keyword_mouseout(this)" ondblclick="keyword_dblclick(this)" ondragstart="keyword_dragstart(this)" ondragend="keyword_dragend(this)" ondrag="keyword_drag(this)"><xsl:value-of select="following-sibling::Match[@Type='Keyword'][1]" /></span>
					</xsl-if>
				</TD>
				<TD>
					<xsl-if test="following-sibling::Match[@Type='Keyword'][2]">
						<span class="keyword"  column="{@Column}" onclick="keyword_select(this)" onselect = "keyword_select()"  onmouseover="keyword_mouseover(this)" onmouseout="keyword_mouseout(this)" ondblclick="keyword_dblclick(this)" ondragstart="keyword_dragstart(this)" ondragend="keyword_dragend(this)" ondrag="keyword_drag(this)"><xsl:value-of select="following-sibling::Match[@Type='Keyword'][2]" /></span>
					</xsl-if>
				</TD>
				<TD>
					<xsl-if test="following-sibling::Match[@Type='Keyword'][3]">
						<span class="keyword" column="{@Column}" onclick="keyword_select(this)" onselect = "keyword_select()"  onmouseover="keyword_mouseover(this)" onmouseout="keyword_mouseout(this)" ondblclick="keyword_dblclick(this)" ondragstart="keyword_dragstart(this)" ondragend="keyword_dragend(this)" ondrag="keyword_drag(this)"><xsl:value-of select="following-sibling::Match[@Type='Keyword'][3]" /></span>
					</xsl-if>
				</TD>
			</tr>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
