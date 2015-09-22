<?xml version="1.0" encoding="ISO-8859-1"?>

<!-- This is an example of a translation to be used with bib2html
     http://www.cs.cmu.edu/~pfr/misc_software/index.html#bib2html
     Thank you to Mark Moll for contributing this stylesheet.
     You can see what it looks like at:
     http://www.cs.rice.edu/~mmoll/publications/
-->

<xsl:stylesheet 
  version="1.0"
  xmlns:date="http://exslt.org/dates-and-times"
  xmlns:b2h="http://www.cs.cmu.edu/~pfr/misc_software/index.html#bib2html"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="date b2h xsl">
<!--   xmlns="http://www.w3.org/TR/html4/loose.dtd"  -->

<xsl:import href="external/date.format-date.template.xsl" />

<xsl:output 
  method="html" 
  version="4.0"
  doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
  doctype-system="http://www.w3.org/TR/html4/loose.dtd"
  encoding="iso-8859-1" 
  indent="yes"/>

<xsl:strip-space elements="b2h:size b2h:file_format b2h:exists b2h:datetime" />

<xsl:template match="b2h:main_index_links">
  Change sort order:
  <select name="sortorder"
  OnChange="location.href=this.options[selectedIndex].value">
  <option>Select...</option>
  <xsl:for-each select="b2h:index_link">
   <option>
    <xsl:attribute name="value">
     <xsl:value-of select="b2h:url" />
    </xsl:attribute>
    <xsl:value-of select="b2h:name"/>
   </option>
  </xsl:for-each>
  </select>
</xsl:template>

<!-- A template to format the number of bytes into something a little more human
     readable -->
<xsl:template name="size" match="b2h:size">
 <xsl:choose>
  <xsl:when test=".&gt;1024*1024*1024">
   <xsl:value-of select="format-number(. div (1024*1024*1024), '#.0')" />GB
  </xsl:when>
  <xsl:when test=".&gt;1024.0*1024.0">
   <xsl:value-of select="format-number(. div (1024*1024), '#.0')" />MB
  </xsl:when>
  <xsl:when test=".&gt;1024.0">
   <xsl:value-of select="format-number(. div (1024), '#.0')" />kB
  </xsl:when>
  <xsl:otherwise>
   <xsl:value-of select="format-number(. , '#')" />kB
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<!-- A long format of download links, to be used with call-template -->
<xsl:template name="dl_link_long">
 <xsl:param name="dl" />
 <xsl:choose>
  <xsl:when test="count($dl/b2h:download_entry[b2h:exists=1 or b2h:exists='true']) != 0">
   <xsl:for-each select="$dl/b2h:download_entry">
    <xsl:if test="b2h:exists=1 or b2h:exists='true'">
     <a>
      <xsl:attribute name="href">
       <xsl:value-of select="b2h:url" />
      </xsl:attribute>
      <xsl:choose>
       <xsl:when test="b2h:file_format='pdf'">[PDF]</xsl:when>
       <xsl:when test="b2h:file_format='ps.gz'">[gzipped postscript]</xsl:when>
       <xsl:when test="b2h:file_format='ps'">[postscript]</xsl:when>
       <xsl:when test="b2h:file_format='html'">[HTML]</xsl:when>
       <xsl:otherwise>[unknown format]
        <xsl:message>Warning: Unknown file format: <xsl:value-of select="b2h:file_format" /></xsl:message>
       </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="b2h:size" />
     </a> 
     <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
    </xsl:if>
   </xsl:for-each>
  </xsl:when>
  <xsl:otherwise>
  (unavailable)
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<!-- A short format of download links, to be used with call-template -->
<xsl:template name="dl_link_short">
 <xsl:param name="dl" />
 <xsl:choose>
  <xsl:when test="count($dl/b2h:download_entry[b2h:exists=1 or b2h:exists='true']) != 0">
   <xsl:for-each select="$dl/b2h:download_entry">
    <xsl:if test="b2h:exists=1 or b2h:exists='true'">
     <a>
      <xsl:attribute name="href">
       <xsl:value-of select="b2h:url" />
      </xsl:attribute>
      [<xsl:apply-templates select="b2h:size" /> 
      <xsl:choose>
       <xsl:when test="b2h:file_format='pdf'">pdf]</xsl:when>
       <xsl:when test="b2h:file_format='ps.gz'">ps.gz]</xsl:when>
       <xsl:when test="b2h:file_format='ps'">ps]</xsl:when>
       <xsl:when test="b2h:file_format='html'">HTML]</xsl:when>
       <xsl:otherwise>unknown format]
        <xsl:message>Warning: Unknown file format: <xsl:value-of select="b2h:file_format" /></xsl:message>
       </xsl:otherwise>
      </xsl:choose>
      
     </a> 
     <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
    </xsl:if>
   </xsl:for-each>
  </xsl:when>
  <xsl:otherwise>
  (unavailable)
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<!-- Template for the crediting of the generated info -->
<xsl:template match="b2h:generation_info">
 Generated by
 <a>
  <xsl:attribute name="href">
   <xsl:value-of select="b2h:program_url" />
  </xsl:attribute>
  <xsl:value-of select="b2h:program" />
 </a>
 (written by <a>
  <xsl:attribute name="href">
   <xsl:value-of select="b2h:author_url" />
  </xsl:attribute>
  <xsl:value-of select="b2h:author" />
  </a>
  ) on
  <xsl:call-template name="date:format-date">
   <xsl:with-param name="date-time" select="b2h:datetime" />
   <!-- I used to have a zzz at the end here, but I no longer put time zone information in the
        xml file (because that requires the Time::Zone package in perl) -->
   <xsl:with-param name="pattern" select="'EEE MMM dd, yyyy HH:mm:ss'" />
  </xsl:call-template>
 </xsl:template>

<xsl:template name="paper_info_short">
 <xsl:param name="paper_info" />
  <xsl:value-of select="$paper_info/b2h:citation" disable-output-escaping="yes"/>
  <br /> 
  <xsl:if test="$paper_info/b2h:detail_url">
   <a>
    <xsl:attribute name="href"><xsl:value-of select="$paper_info/b2h:detail_url" /></xsl:attribute>
    Details
   </a>
   <xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
  </xsl:if>
  <xsl:if test="$paper_info/b2h:bibtex_url">
   <a>
    <xsl:attribute name="href"><xsl:value-of select="$paper_info/b2h:bibtex_url" /></xsl:attribute>
    BibTeX
   </a>
   <xsl:text disable-output-escaping="yes">&amp;nbsp;&amp;nbsp;&amp;nbsp;</xsl:text>
  </xsl:if>
  Download: 
  <xsl:call-template name="dl_link_short">
   <xsl:with-param name="dl" select="$paper_info/b2h:download_links" />
  </xsl:call-template>
</xsl:template>

<!-- Note that this template does NOT print a header for this group. You should
     do that before applying this template -->
<xsl:template match="b2h:group_papers">
 <xsl:for-each select="b2h:paper_info">
  <p class="citation">
   <xsl:call-template name="paper_info_short">
    <xsl:with-param name="paper_info" select="." />
   </xsl:call-template>
  </p>
 </xsl:for-each>
</xsl:template>

<!--  The main template to match for a list of paper page -->
<!-- Note that this is a named template you have to call with call-template -->
<xsl:template name="list_papers_with_sep">
 <xsl:param name="list" />
 <html lang="en">
 <head>
  <title>Publications <xsl:value-of
  select="translate($list/b2h:list_title,'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 
                                  'abcdefghijklmnopqrstuvwxyz')" /></title>
  <link rel="StyleSheet" href="../layout.css" type="text/css" />              
 </head>
 <body>

  <h2> <xsl:value-of select="$list/b2h:list_title"/> </h2>
  <div class="content">
   <xsl:apply-templates select="$list/b2h:main_index_links" />

  <!-- First, we'll format the index links -->
  <p>&#8226;
  <xsl:for-each select="$list/b2h:list_group_papers/b2h:group_papers">
   <a>
    <xsl:attribute name="href">#<xsl:value-of select="b2h:group_title" /></xsl:attribute>
    <xsl:value-of select="b2h:group_title" disable-output-escaping="yes" />
   </a> &#8226; </xsl:for-each></p>
  
  <xsl:for-each select="$list/b2h:list_group_papers/b2h:group_papers">
   <h3>
    <a>
     <xsl:attribute name="name"><xsl:value-of select="b2h:group_title" /></xsl:attribute>    
    </a>
    <xsl:value-of select="b2h:group_title" disable-output-escaping="yes" />
   </h3>
   <xsl:apply-templates select="." />
  </xsl:for-each>  
  </div>
  
  <hr width="100%" size="2"/>
  <p><small>
  <xsl:apply-templates select="$list/b2h:generation_info" />
  </small> </p>

 </body>
 </html>
</xsl:template>

<!--  The main template to match for a list of paper page with the group boundaries ignored -->
<!-- Note that this is a named template you have to call with call-template -->
<xsl:template name="list_papers_no_sep">
 <xsl:param name="list" />
 <html lang="en" xml:lang="en">
 <head>
  <title>Publications <xsl:value-of
  select="translate($list/b2h:list_title,'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 
                                  'abcdefghijklmnopqrstuvwxyz')" /></title>
  <link rel="StyleSheet" href="../layout.css" type="text/css" />              
 </head>
 <body>

  <h2> <xsl:value-of select="$list/b2h:list_title"/> </h2>
  <div class="content">
  <xsl:apply-templates select="$list/b2h:main_index_links" />

   <xsl:for-each select="$list/b2h:list_group_papers/b2h:group_papers/b2h:paper_info">
     <xsl:call-template name="paper_info_short">
      <xsl:with-param name="paper_info" select="." />
     </xsl:call-template>
   </xsl:for-each>  
  </div>

  <hr width="100%" size="2"/>
  <p><small>
  <xsl:apply-templates select="$list/b2h:generation_info" />
  </small> </p>

 </body>
 </html>
</xsl:template>

<!--  The main template to match for a paper detail page -->
<xsl:template match="b2h:paper_detail">
 <html lang="en" xml:lang="en">
 <head>
  <title>Publications <xsl:value-of
  select="translate(b2h:paper_info/b2h:title,'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 
                                  'abcdefghijklmnopqrstuvwxyz')" /></title>
  <link rel="StyleSheet" href="../layout.css" type="text/css" />              
 </head>
 <body>

  <div class="content">
  <h2> <xsl:value-of select="b2h:paper_info/b2h:title" disable-output-escaping="yes"/> </h2>

   <p class="citation">
   <xsl:value-of select="b2h:paper_info/b2h:citation" disable-output-escaping="yes" /> 
   </p>	

   <h3>Download</h3>
   <p>
    <xsl:call-template name="dl_link_short">
     <xsl:with-param name="dl" select="b2h:paper_info/b2h:download_links" />
    </xsl:call-template>
   </p>

   <h3>Abstract</h3>
   <p class="abstract">
    <xsl:choose>
     <xsl:when test="b2h:paper_info/b2h:abstract">
      <xsl:value-of select="b2h:paper_info/b2h:abstract"/> 
     </xsl:when>
     <xsl:otherwise>
      (unavailable)
     </xsl:otherwise>
    </xsl:choose>
   </p>

   <xsl:if test="b2h:paper_info/b2h:extra_info">
    <h3>Additional Information</h3>
    <p><xsl:value-of select="b2h:paper_info/b2h:extra_info" disable-output-escaping="yes" /></p>
   </xsl:if>

   <xsl:choose>
    <xsl:when test="b2h:paper_info/b2h:bibtex_url">
     <a>
      <xsl:attribute name="href"><xsl:value-of select="b2h:paper_info/b2h:bibtex_url" /></xsl:attribute>
      <h3>BibTeX</h3>
     </a>
    </xsl:when>
    <xsl:otherwise>
     <h3>BibTeX Entry</h3>
    </xsl:otherwise>
   </xsl:choose>
   <xsl:choose>
    <xsl:when test="b2h:paper_info/b2h:bibtex_entry">
     <pre>
      <xsl:value-of select="b2h:paper_info/b2h:bibtex_entry"/> 
     </pre>
    </xsl:when>
    <xsl:otherwise>
     (unavailable)
    </xsl:otherwise>
   </xsl:choose>
  </div>

   <hr width="100%" size="2"/>
   <p><small>
   <xsl:apply-templates select="b2h:generation_info" />
   </small> </p>

 </body>
 </html>
</xsl:template>

<!--  The main templates for the list of papers pages -->

<xsl:template match="b2h:list_papers_by_default">
 <xsl:call-template name="list_papers_no_sep">
  <xsl:with-param name="list" select="." />
 </xsl:call-template>
</xsl:template>

<xsl:template match="b2h:list_papers_by_date">
 <xsl:call-template name="list_papers_with_sep">
  <xsl:with-param name="list" select="." />
 </xsl:call-template>
</xsl:template>

<xsl:template match="b2h:list_papers_by_author">
 <xsl:call-template name="list_papers_with_sep">
  <xsl:with-param name="list" select="." />
 </xsl:call-template>
</xsl:template>

<xsl:template match="b2h:list_papers_by_author_class">
 <xsl:call-template name="list_papers_with_sep">
  <xsl:with-param name="list" select="." />
 </xsl:call-template>
</xsl:template>

<xsl:template match="b2h:list_papers_by_pubtype">
 <xsl:call-template name="list_papers_with_sep">
  <xsl:with-param name="list" select="." />
 </xsl:call-template>
</xsl:template>

<xsl:template match="b2h:list_papers_by_rescat">
 <xsl:call-template name="list_papers_with_sep">
  <xsl:with-param name="list" select="." />
 </xsl:call-template>
</xsl:template>

<xsl:template match="b2h:list_papers_by_funding">
 <xsl:call-template name="list_papers_with_sep">
  <xsl:with-param name="list" select="." />
 </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
