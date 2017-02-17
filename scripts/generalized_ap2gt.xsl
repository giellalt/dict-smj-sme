<?xml version="1.0"?>
<!--+
    | Usage: java -Xmx2048m net.sf.saxon.Transform -it main THIS_FILE inDir=DIR
    | 
    +-->

<xsl:stylesheet version="2.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:xhtml="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="xs xhtml">

  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" name="xml"
	      encoding="UTF-8"
	      omit-xml-declaration="no"
	      indent="yes"/>

  <xsl:output method="text" name="txt"
              encoding="UTF-8"
              omit-xml-declaration="yes"
              indent="no"/>
 
  <xsl:param name="inDir" select="'00_indir'"/>
  <xsl:param name="slang" select="'sme'"/>
  <xsl:param name="tlang" select="'smj'"/>
  <xsl:param name="sls" select="'a'"/>
  <xsl:param name="tls" select="'o'"/>
  <xsl:variable name="outDir" select="concat('xp_6_', $slang, $tlang)"/>
  <xsl:variable name="of" select="'xml'"/>
  <xsl:variable name="e" select="$of"/>
  <xsl:variable name="debug" select="true()"/>
  <xsl:variable name="nl" select="'&#xa;'"/>
  <xsl:param name="relabel_file" select="'gt2ap2gt.relabel'"/>
  <xsl:variable name="rf_parsed" select="unparsed-text($relabel_file)"/>
  <xsl:variable name="rf_lines" select="tokenize($rf_parsed, '&#xa;')" as="xs:string+"/>
  <xsl:variable name="rf_array">
    <xsl:for-each select="$rf_lines">
      <map gt="{normalize-space(tokenize(., ':')[01])}" ap="{normalize-space(tokenize(., ':')[02])}"/>
    </xsl:for-each>
  </xsl:variable>

  
  <xsl:template match="/" name="main">
    <xsl:for-each select="for $f in collection(concat($inDir,'?recurse=no;select=*.dix;on-error=warning')) return $f">
      
      <xsl:variable name="current_file" select="(tokenize(document-uri(.), '/'))[last()]"/>
      <xsl:variable name="current_dir" select="substring-before(document-uri(.), $current_file)"/>
      <xsl:variable name="current_location" select="concat($inDir, substring-after($current_dir, $inDir))"/>
      <xsl:variable name="file_name" select="substring-before($current_file, '.dix')"/>      

      <xsl:if test="$debug">
	<xsl:message terminate="no">
	  <xsl:value-of select="concat('-----------------------------------------', $nl)"/>
	  <xsl:value-of select="concat('processing file ', $current_file, $nl)"/>
	  <xsl:value-of select="'-----------------------------------------'"/>
	</xsl:message>
      </xsl:if>

      <xsl:result-document href="{$outDir}/{$file_name}.{$of}" format="{$of}">
	<r xml:lang="{$slang}">
	  <xsl:for-each select=".//e[not(./@r)], .//e[./@r][./@r='LR']">

	    <xsl:if test="$debug">
	      <xsl:message terminate="no">
		<xsl:value-of select="concat('-------------------', $nl)"/>
		<xsl:value-of select="concat('e  ', ./p/l, $nl)"/>
		<xsl:value-of select="'-------------------'"/>
	      </xsl:message>
	    </xsl:if>
	    
	    <xsl:variable name="c_e">
	      <e>
		<xsl:if test="./@r">
		  <xsl:attribute name="r">
		    <xsl:value-of select="./@r"/> 
		  </xsl:attribute>
		</xsl:if>
		<lg>
		  <l>
		    <xsl:attribute name="pos">
		      <xsl:variable name="c_pos" select="./p/l/s[01]/@n"/>
		      <xsl:value-of select="$rf_array/map[./@ap=$c_pos]/@gt"/>
		    </xsl:attribute>
		    
		    <xsl:variable name="c_spec">
		      <xsl:for-each select="./p/l/s[position()&gt;01]">
			<xsl:variable name="c_n" select="./@n"/>
			<xsl:value-of select="$rf_array/map[./@ap=$c_n]/@gt"/>
			<xsl:if test="not(position()=last())">
			  <xsl:value-of select="'.'"/>
			</xsl:if>
		      </xsl:for-each>
		    </xsl:variable>
		    
		    <xsl:if test="not($c_spec='')">
		      <xsl:attribute name="spec">
			<xsl:copy-of select="$c_spec"/>
		      </xsl:attribute>
		    </xsl:if>
		    
		    <!--xsl:copy-of select="normalize-space(./p/l)"/-->
		    <xsl:for-each select="./p/l/node()">
		      <xsl:if test="self::text()">
			<xsl:value-of select="."/>
		      </xsl:if>
		      <xsl:if test="self::* and local-name()='b'">
			<xsl:value-of select="' '"/>
		      </xsl:if>
		      <xsl:if test="self::* and local-name()='g'">
			<xsl:for-each select="./node()">
			  <xsl:if test="self::text()">
			    <xsl:value-of select="."/>
			  </xsl:if>
			  <xsl:if test="self::* and local-name()='b'">
			    <xsl:value-of select="' '"/>
			  </xsl:if>
			</xsl:for-each>
		      </xsl:if>
		    </xsl:for-each>
		  </l>
		</lg>
		<mg>
		  <tg xml:lang="{$tlang}">
		    <t>
		      
		      <xsl:attribute name="pos">
			<xsl:variable name="c_pos" select="./p/r/s[01]/@n"/>
			<xsl:value-of select="$rf_array/map[./@ap=$c_pos]/@gt"/>
		      </xsl:attribute>
		      
		      <xsl:variable name="c_spec">
			<xsl:for-each select="./p/r/s[position()&gt;01]">
			  <xsl:variable name="c_n" select="./@n"/>
			  <xsl:value-of select="$rf_array/map[./@ap=$c_n]/@gt"/>
			  <xsl:if test="not(position()=last())">
			    <xsl:value-of select="'.'"/>
			  </xsl:if>
			</xsl:for-each>
		      </xsl:variable>
		      
		      <xsl:if test="not($c_spec='')">
			<xsl:attribute name="spec">
			  <xsl:copy-of select="$c_spec"/>
			</xsl:attribute>
		      </xsl:if>
		      

		      
		      <!-- <xsl:attribute name="spec"> -->
		      <!--   <xsl:for-each select="./p/r/s[position()&gt;01]"> -->
		      <!-- 	<xsl:variable name="c_n" select="./@n"/> -->
		      <!-- 	<xsl:value-of select="$rf_array/map[./@ap=$c_n]/@gt"/> -->
		      <!-- 	<xsl:if test="not(position()=last())"> -->
		      <!-- 	  <xsl:value-of select="'.'"/> -->
		      <!-- 	</xsl:if> -->
		      <!--   </xsl:for-each> -->
		      <!-- </xsl:attribute> -->

		      <!--xsl:copy-of select="normalize-space(./p/r)"/-->
		      <xsl:for-each select="./p/r/node()">
			<xsl:if test="self::text()">
			  <xsl:value-of select="."/>
			</xsl:if>
			<xsl:if test="self::* and local-name()='b'">
			  <xsl:value-of select="' '"/>
			</xsl:if>
			<xsl:if test="self::* and local-name()='g'">
			  <xsl:for-each select="./node()">
			    <xsl:if test="self::text()">
			      <xsl:value-of select="."/>
			    </xsl:if>
			    <xsl:if test="self::* and local-name()='b'">
			      <xsl:value-of select="' '"/>
			    </xsl:if>
			  </xsl:for-each>
			</xsl:if>
		      </xsl:for-each>
		    </t>
		  </tg>
		</mg>
	      </e>
	      
	      </xsl:variable>

	      <xsl:if test="not($c_e/e/lg/l=$c_e/e/mg/tg/t and $c_e/e/lg/l/@pos='Prop') and not($c_e/e/mg/tg/t='') and not($c_e/e/lg/l='')">
		<xsl:copy-of select="$c_e/e"/>
	      </xsl:if>
	  </xsl:for-each>
	</r>
      </xsl:result-document>
    </xsl:for-each>
  </xsl:template>
  
</xsl:stylesheet>
