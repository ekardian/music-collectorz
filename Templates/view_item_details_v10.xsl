<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html"/>

<xsl:param name="pageheight">200</xsl:param>
<xsl:param name="pagewidth">400</xsl:param>
<xsl:param name="templatetype">view</xsl:param>
<xsl:param name="absolutelinks">true</xsl:param>
<xsl:param name="allowfindcover">true</xsl:param>
<xsl:param name="stylesheet">view_item_details_blue.css</xsl:param>
<xsl:param name="mybasepath"></xsl:param>

<xsl:include href="shared_templates.xsl"/>

<!-- handle myrating field - set stars -->
<xsl:template name="star">
  <xsl:param name="num" select="0"/>
  	<xsl:variable name="rating">
			<xsl:choose>
			   <xsl:when test="contains($num, '%')">
						<xsl:variable name="percentage">			   
			         <xsl:value-of select="substring-before($num,'%')"/>
						</xsl:variable>
						<xsl:value-of select="$percentage div 10"/>
			   </xsl:when>
			   <xsl:otherwise>		
			       <xsl:value-of select="$num"/>
			   </xsl:otherwise>
			</xsl:choose>
	</xsl:variable>
  <xsl:choose>
    <xsl:when test="$templatetype!='exportdetails'">	
      <a href="http://editrating.html"><img src="{$mybasepath}rating{$rating}.png" border="0"/></a>
    </xsl:when>
    <xsl:otherwise>
      <span class="fieldvaluelarge">  
        <xsl:value-of select="$rating"/>*
      </span>
    </xsl:otherwise>    
  </xsl:choose>     
</xsl:template>

<xsl:template name="creditrole">
  <xsl:param name="roleid" select="dfProducer"/>
  <xsl:if test="credits/credit[./role[@id=$roleid]]!=''">
    <tr valign="top">
       <td nowrap="1" class="fieldlabel">
         <xsl:value-of select="/musicinfo/musicmetadata/field[@id=$roleid]/@label"/>
       </td>
       <td class="fieldvalue">       		
          <xsl:for-each select="credits/credit[./role[@id=$roleid]]">           	  
              <xsl:apply-templates select="person"/>
            <xsl:if test="position()!=last()"><xsl:text>; </xsl:text></xsl:if>
          </xsl:for-each>
       </td>
    </tr>
  </xsl:if>
</xsl:template>

<!-- keep artist link orange-->

<xsl:template name="artistlink">
	<xsl:variable name="prefix">
	  <xsl:choose>
  		<xsl:when test="contains(url, 'http://') or $templatetype !='view'"></xsl:when>
			<xsl:otherwise>http://local_</xsl:otherwise>
  	</xsl:choose>
	</xsl:variable>

<span id="artist">	
  <xsl:choose>
    <xsl:when test="url!='' and $print=''">
      <a href="{$prefix}{url}" class="link"><xsl:value-of select="displayname"/></a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="displayname"/>
    </xsl:otherwise>
  </xsl:choose>
  </span>
</xsl:template>


<xsl:template name="maintitle">
 <xsl:choose>
		<xsl:when test="composers!=''">
      <xsl:for-each select="composers/composer">                      
         <xsl:call-template name="artistlink"/>         
         <xsl:if test="position()!=last()"><xsl:text>; </xsl:text></xsl:if>  	                      
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
			<xsl:for-each select="artists/artist">
  			<xsl:call-template name="artistlink"/>
			   <xsl:if test="position()!=last()"><xsl:text>; </xsl:text></xsl:if>
			</xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
	<xsl:text> - </xsl:text>
	<xsl:value-of select="title"/>
	
	<xsl:if test="subtitle!=''">
   <br/><div id="subtitle"><xsl:value-of select="subtitle"/></div>
   
   </xsl:if>

</xsl:template>

<xsl:template name="backdropimage">
  <xsl:param name="nameimg" select="''"/>
  <xsl:if test="$templatetype='view' or 'print'">
    <xsl:if test="$nameimg!=''">
      <a href="http://image.html"><img src="file:///{$nameimg}" border="0" style="height:150px;"/></a>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template name="boxsetcover">
  <xsl:param name="name" select="''"/>

  <xsl:if test="$templatetype='view'">
    <xsl:if test="$name!=''">
    <div id="boxsetcover">
      <a href="http://image.html"><img src="file:///{$name}" border="0" class="coverimage"/></a>
    </div>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template name="cover">
  <xsl:param name="in_viewhref" select=""/>
  <xsl:param name="in_cover" select=""/>
  <xsl:param name="in_id" select=""/>
  <xsl:param name="in_postfix" select=""/>
  <xsl:param name="in_thumbfilepath" select=""/>
  
  <xsl:choose>
    <xsl:when test="$templatetype='view'">
      <a href="{$in_viewhref}">
        <xsl:choose>
          <xsl:when test="$in_thumbfilepath!=''">
             <img src="file:///{$in_thumbfilepath}" border="0"/>
          </xsl:when>
          <xsl:otherwise>
             <img src="file:///{$in_cover}" border="0" height="200"/>
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
       <xsl:when test="$absolutelinks = 'true'">
         <a href="file:///{$in_cover}"><img src="file:///{$in_cover}" height="200"/></a>
       </xsl:when>
       <xsl:otherwise>
         <xsl:variable name="extf"><xsl:call-template name="extractfileextension"><xsl:with-param name="filepath" select="$in_cover"/></xsl:call-template></xsl:variable>
<!--Original code for cover-->
          <!--<a href="../images/{$in_id}{$in_postfix}.{$extf}"><img src="../images/{$in_id}{$in_postfix}.{$extf}" height="200"/></a>-->
<!--End Original code for cover-->         
<!--To local cover-->
         <!-- <a href="../images/{$in_id}{$in_postfix}.{$extf}"><img src="../images/{$in_id}{$in_postfix}.{$extf}" height="200"/></a> -->
<!--End to local cover-->
<!--To web cover-->
          <!-- <img src="https://googledrive.com/host/0B4IL_NIjd8oWfmkwYmZwS3RrSUg5VWY4T2RfQW1JZnFJWTY5alFfN3lXSjdqYkJlRWVwbFE/{$in_id}{$in_postfix}.{$extf}" height="200"/> -->
          <a href="../images/{$in_id}{$in_postfix}.{$extf}"><img src="../images/{$in_id}{$in_postfix}.{$extf}" height="200"/></a>
<!--End to web cover-->         
       </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="collection_status">
  <xsl:param name="in_listid" select=""/>
  <xsl:param name="in_status" select=""/>

  <xsl:choose>
    <xsl:when test="$templatetype='view'">
      <img src="{$mybasepath}ic_{$in_listid}_24.png" alt="" border="0"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$in_status"/><br/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="imagelink">
  <xsl:param name="in_viewhref" select=""/>
  <xsl:param name="in_url" select=""/>
  
	<xsl:variable name="prefix">
  <xsl:choose>
  		<xsl:when test="contains(in_url, 'http://')"></xsl:when>
			<xsl:otherwise>file:///</xsl:otherwise>
  	</xsl:choose>
	</xsl:variable>
	
  <xsl:choose>
    <xsl:when test="$templatetype='view'">
      <a href="{$in_viewhref}"><img src="{$prefix}{$in_url}" border="0" class="imagefile" /></a>
    </xsl:when>
    <xsl:otherwise>
      <a href="file:///{$in_url}"><img src="file:///{$in_url}" class="imagefile"/></a>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- the main template -->
<xsl:template match="/">
<html>
  <HEAD>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <LINK REL="StyleSheet" TYPE="text/css" HREF="{$mybasepath}{$stylesheet}"></LINK>
    <link rel="icon" type="image/x-icon" href="images/biosmusic.ico" />
    <link rel="stylesheet" href="../css/bootstrap.min.css"/>
    <link rel="stylesheet" href="../css/bootstrap-theme.min.css"/>
    <META http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta property="og:title" content="Yacuiba - Bolivia: http://info.biosxtreme.net" />
    <meta property="og:url" content="http://musica.biosxtreme.net/" />
    <meta property="og:type" content="website" />
    <meta property="og:description" content="A la venta --> Colección     Películas - Documentales - Videotutoriales - Películas Cristianas - Películas Cristianas infantiles - Películas motivacionales" />
    <meta property="og:image" content="http://musica.biosxtreme.net/images/musicbiosxtreme.jpg" />
    <TITLE>
    <xsl:choose>
  		<xsl:when test="musicinfo/musiclist/music/composers!=''">
        <xsl:for-each select="musicinfo/musiclist/music/composers/composer">                      
           <xsl:apply-templates select="."/>         
           <xsl:if test="position()!=last()"><xsl:text>; </xsl:text></xsl:if>  	                      
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
  			<xsl:for-each select="musicinfo/musiclist/music/artists/artist">
    			<xsl:apply-templates select="."/>
  			   <xsl:if test="position()!=last()"><xsl:text>; </xsl:text></xsl:if>
  			</xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  	<xsl:text> - </xsl:text>
  	<xsl:value-of select="musicinfo/musiclist/music/title"/>	
        <xsl:if test="musicinfo/musiclist/music/composition!=''">
  				 <xsl:value-of select="musicinfo/musiclist/music/composition/displaytitle"/>
        </xsl:if>	    
    </TITLE>
  </HEAD>
  <BODY onload="initPage();">
    <xsl:apply-templates select="musicinfo/navigation"/>
    <xsl:apply-templates select="musicinfo/musiclist"/>    
  </BODY>
  </html> 
</xsl:template>

<xsl:template match="details">
 	<xsl:apply-templates select="detail"/>
</xsl:template>

<xsl:template name="composition">
 <xsl:param name="composition"/>
 <xsl:value-of select="$composition/displaytitle"/>
</xsl:template>

<xsl:template match="detail">
		<tr>	
		<xsl:if test="@type='track' or @type='subtrack' or @type='header'">
			<td class="extra">
			&nbsp;
		   <xsl:if test="$templatetype!='exportdetails' and audiofile!=''">
		     <a href="http://playtrack_{audiofile}.html" class="link"><img src="{$mybasepath}playthetrack.png" border="0"/></a>&nbsp;
		   </xsl:if>
				<xsl:if test="$templatetype='exportdetails' and audiofile!=''">
				  <td class="tracktitle"><a href="{audiofile}" class="link">play&gt;</a></td>
				</xsl:if>
		  </td>
		  <xsl:choose> 	       
			  <xsl:when test="@type!='header'">
			  	<td width="10" class="position">
			     &nbsp;<xsl:value-of select="position"/>    		 
			    </td>          			 
		  	</xsl:when>
			  <xsl:otherwise>
	    		<td class="headerdetails" colspan="2">
	    		&nbsp;
	          <xsl:value-of select="title"/>
	        </td>		     		     
	    	</xsl:otherwise>
		  </xsl:choose>				
		  <xsl:if test="@type!='header'">
    		 <td class="tracktitle">
    		 &nbsp;
        		<xsl:value-of select="title"/>
    		 </td>      
    	</xsl:if>
			 <td class="trackdetails">
			 		&nbsp;
	        <xsl:choose>		 
	    			<xsl:when test="composers!=ancestor::music/composers and composers!=''">
	    			 <xsl:for-each select="composers/composer">
	    			    <xsl:apply-templates select="."/>
	    			    <xsl:if test="position()!=last()"><xsl:text>; </xsl:text></xsl:if>
	    			 </xsl:for-each>
	    			</xsl:when>        
						<xsl:otherwise>
						  <xsl:if test="artists!=ancestor::music/artists and artists!=''">
							 <xsl:for-each select="artists/artist">
							    <xsl:apply-templates select="."/>
							    <xsl:if test="position()!=last()"><xsl:text>; </xsl:text></xsl:if>
							 </xsl:for-each>
							</xsl:if>
						</xsl:otherwise>				
					</xsl:choose>
			</td>
	    <td class="trackcomposition">	   
	    	&nbsp;
				<xsl:if test="composition!=ancestor::detail/composition and composition!=''">
	        <xsl:call-template name="composition">
	          <xsl:with-param name="composition" select="composition"/>
	        </xsl:call-template>
				</xsl:if>
			</td>
			<td class="tracknotes">	 
			&nbsp;  
				<xsl:if test="notes!=''">
				 <xsl:value-of select="notes"/>
				</xsl:if>
	    </td> 
			<td class="extra">
			&nbsp;
				<xsl:if test="$templatetype!='exportdetails' and lyricsfile!=''">	
			       <a href="http://local_{lyricsfile}" class="link">Lyrics</a>
			   </xsl:if>			
			</td> 
			<td class="extra">
			&nbsp;
			   <xsl:if test="bpm!=''">
			     <xsl:if test="bpm > 0"><xsl:value-of select="bpm"/>&nbsp;bpm</xsl:if>
			   </xsl:if> 
			</td>
			<td class="tracklength">
			&nbsp;
			 <xsl:if test="length!='00:00'">
			   <xsl:value-of select="length"/>
			 </xsl:if>
			</td>
		</xsl:if>	    
    
	 <xsl:if test="@type='disc' and (count(../detail) > 1)">    
      <td colspan="9"  class="header" style="border-bottom:none;">
		  <xsl:if test="$templatetype!='exportdetails' and (details/detail/audiofile!='')">
		    <a href="http://playdisc{position()}.html" class="link"><img src="{$mybasepath}playthetrack.png" border="0"/></a>&nbsp;
		  </xsl:if>
		    <div id="disc">
		    <xsl:value-of select="title"/>
            <xsl:if test="length!='00:00'">
            &nbsp;(<xsl:value-of select="length"/>)
           </xsl:if>
           </div>
      </td>
     </xsl:if>
   </tr>
   <tr>
    <xsl:if test="@type='disc'">
      <td colspan="9"  class="{@type}">
         <xsl:if test="composition!=ancestor::music/composition and composition!=''">
          <span class="disccomposition">           
            <xsl:call-template name="composition">
              <xsl:with-param name="composition" select="composition"/>
            </xsl:call-template>    
          </span>         
         </xsl:if>
      </td>
   </xsl:if>    
	 </tr>
 	 <xsl:apply-templates select="details"/>
</xsl:template>

<xsl:template match="music">

<xsl:if test="$stylesheet='view_item_details_blue_v10.css'"> 
 	<xsl:variable name="apos">'</xsl:variable>
		<xsl:variable name="fixedbackdrop">
			<xsl:call-template name="replace-string">
				<xsl:with-param name="text" select="backgroundbackdrop"/>
				<xsl:with-param name="replace" select="$apos"/>				
				<xsl:with-param name="with" select="concat('\', $apos)"/>				
			</xsl:call-template>
		</xsl:variable>
	  <xsl:if test="backgroundbackdrop!=''">
	    <style type="text/css">
			body {background:url('<xsl:value-of select="$fixedbackdrop"/>');background-size:100%;background-attachment:fixed;}	    
			</style>
	  </xsl:if>
  </xsl:if>
  
  <xsl:if test="boxset!=''">
		<div id="boxset" class="opacity">
      <xsl:call-template name="boxsetcover"><xsl:with-param name="name" select="boxset/frontcover"/></xsl:call-template>
      <xsl:call-template name="boxsetcover"><xsl:with-param name="name" select="boxset/backcover"/></xsl:call-template>
			<span id="boxsettitle"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfBoxSet']/@label"/>:&nbsp;<xsl:value-of select="boxset/displayname"/></span>
			
      <table class="valuestable" border="0" cellspacing="0" cellpadding="0">
	      <xsl:if test="boxset/upc!=''">
	         <tr valign="top">
	          <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfUPC']/@label"/></td>
	          <td class="fieldvalue"><xsl:value-of select="boxset/upc"/></td>
	         </tr>
	      </xsl:if>
	      <xsl:if test="boxset/releasedate!=''">
	         <tr valign="top">
	          <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfReleaseDate']/@label"/></td>
	          <td class="fieldvalue"><xsl:value-of select="boxset/releasedate/date"/></td>
	         </tr>
	      </xsl:if>
	      <xsl:if test="boxset/purchasedate!=''">
	         <tr valign="top">
	          <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfPurchaseDate']/@label"/></td>
	          <td class="fieldvalue"><xsl:value-of select="boxset/purchasedate/date"/></td>
	         </tr>
	      </xsl:if>
	      <xsl:if test="boxset/purchaseprice!=''">
	         <tr valign="top">
	          <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfPrice']/@label"/></td>
	          <td class="fieldvalue"><xsl:value-of select="boxset/purchaseprice"/></td>
	         </tr>
	      </xsl:if>    
	      <xsl:if test="boxset/store!=''">
	         <tr valign="top">
	          <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfStore']/@label"/></td>
	          <td class="fieldvalue"><xsl:apply-templates select="boxset/store"/></td>
	         </tr>
	      </xsl:if>       
	      <xsl:if test="boxset/condition!=''">
	         <tr valign="top">
	          <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfCondition']/@label"/></td>
	          <td class="fieldvalue"><xsl:value-of select="boxset/condition/displayname"/></td>
	         </tr>
	      </xsl:if>
	      <xsl:if test="boxset/currentvalue!=''">
	         <tr valign="top">
	          <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfCurrentValue']/@label"/></td>
	          <td class="fieldvalue"><xsl:value-of select="boxset/currentvalue"/></td>
	         </tr>
	      </xsl:if>
			</table>
		  <xsl:if test="boxset/notes!=''">
				<div id="notes">
		    <xsl:call-template name="break">
		      <xsl:with-param name="text" select="boxset/notes"/>
		    </xsl:call-template>
				</div>
		  </xsl:if>
		</div>	
	<hr/>
  </xsl:if>  

<!-- Covers -->
<xsl:choose>    
  <xsl:when test="coverfront!=''">
  <div id="frontcover">
    <xsl:call-template name="cover">
      <xsl:with-param name="in_viewhref">http://front.html</xsl:with-param>
      <xsl:with-param name="in_cover" select="coverfront"/>
      <xsl:with-param name="in_id" select="id"/>
      <xsl:with-param name="in_postfix">f</xsl:with-param>
    </xsl:call-template>
  </div>
  </xsl:when>
  <xsl:otherwise>
    <div id="frontcover">
    	<a href="http://searchcover.html">
    		<img src="{$mybasepath}coverplaceholder.png"  width="200" border="0" class="coverimage"/>
    	</a>
    </div>
  </xsl:otherwise>
</xsl:choose>
<xsl:if test="coverback!=''">
	<div id="backcover">
		<xsl:call-template name="cover">
			<xsl:with-param name="in_viewhref">http://back.html</xsl:with-param>
         <xsl:with-param name="in_cover" select="coverback"/>
         <xsl:with-param name="in_id" select="id"/>
         <xsl:with-param name="in_postfix">b</xsl:with-param>
		</xsl:call-template>
	</div>		
</xsl:if>

  <xsl:if test="coverback='' and coverback2!=''">
	<div id="backcover">
      <xsl:call-template name="cover">
        <xsl:with-param name="in_viewhref">http://back.html</xsl:with-param>
        <xsl:with-param name="in_cover" select="coverback2"/>
        <xsl:with-param name="in_id" select="id"/>
        <xsl:with-param name="in_postfix">b</xsl:with-param>
      </xsl:call-template>
	</div>		
 </xsl:if>
 

<table class="titletable opacity" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top"><div id="topbar"><xsl:call-template name="maintitle"/></div>
			<xsl:if test="label!=''"><span class="fieldvaluelarge"><xsl:apply-templates select="label"/></span></xsl:if>
			<xsl:if test="releasedate/year!=''"><span class="fieldvaluelarge"><xsl:text></xsl:text>&#160;(<xsl:value-of select="releasedate/year"/>)</span></xsl:if>
			<xsl:if test="genres!=''"><div class="fieldvaluesmall"><xsl:for-each select="genres/genre"><xsl:value-of select="displayname"/><xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if></xsl:for-each></div></xsl:if>
			<p /><xsl:if test="id!='0'"><span class="fieldvaluelarge">ID: &nbsp;#<xsl:value-of select="id"/></span></xsl:if><p /><xsl:if test="collectionstatus !=''">
			<span class="status"><xsl:call-template name="collection_status"><xsl:with-param name="in_listid" select="collectionstatus/@listid"/><xsl:with-param name="in_status" select="collectionstatus"/></xsl:call-template></span></xsl:if>
			<xsl:if test="index!='0'"><span class="fieldvaluelarge">#<xsl:value-of select="index"/></span></xsl:if>
  		<xsl:if test="rating!=''"><p />Valoración:<xsl:call-template name="star"><xsl:with-param name="num" select="rating"/></xsl:call-template></xsl:if>
			<table border="0" style="margin-top:10px;">
				<tr>
					
					<td><strong>
					
							<xsl:if test="$templatetype!='exportdetails'">      
		  <xsl:if test="format/templateimage!=''"><img><xsl:attribute name="src"><xsl:value-of select="format/templateimage"/></xsl:attribute></img>&nbsp;</xsl:if>
            </xsl:if>
		<span class="smallerdetails"><b><xsl:if test="format!=''"><xsl:apply-templates select="format"/>&nbsp;</xsl:if></b></span> 
		
		&nbsp; 	</strong><xsl:value-of select="nrtracks"/>&nbsp;tracks&nbsp;
		
		<xsl:if test="length!='00:00'">(<xsl:value-of select="length"/>)&nbsp;</xsl:if>
		
		<xsl:if test="$templatetype!='exportdetails' and (//audiofile!='')">	
					      <a href="http://playall.html"><img src="{$mybasepath}playthemusic.png" border="0" style="margin-right:4px;"/></a>
					</xsl:if>
						
						
						
		<br/>
		
		
		
		<xsl:if test="$templatetype!='exportdetails'">
		  <xsl:if test="country/templateimage!=''"><img><xsl:attribute name="src"><xsl:value-of select="country/templateimage"/></xsl:attribute></img>&nbsp;</xsl:if>
      </xsl:if>
      
		<span class="smallerdetails">
		  <xsl:if test="country/displayname!=''"><b><xsl:value-of select="country/displayname"/>&nbsp;</b></xsl:if>
		</span>
					
   				
				
					</td>
				</tr>
			</table> 
		</td>
	</tr>
</table>

<div style="clear:both;margin-top:8px;">	
				
<!--Tracks-->
<div id="tracklist" class="opacity">		
  <table cellspacing="0" cellpadding="0">
    <xsl:apply-templates select="details"/>
      <xsl:if test="links!=''">
    <xsl:if test="links//*[urltype='Playlist']!=''">
    <tr><td class="header" colspan="4">
    	 <xsl:choose>
    	 	<xsl:when test="$templatetype ='view'">
       		<a href="http://local_{links//*[urltype='Playlist']/url}" class="link">Play All</a>
       	</xsl:when>
       	<xsl:otherwise>
       		<a href="{links//*[urltype='Playlist']/url}" class="link">Play All</a>	
       	</xsl:otherwise>
				</xsl:choose>       	
       </td></tr>
       </xsl:if>		    
     </xsl:if>	         
  </table>
</div>

<!-- Details, Personal Details, Musicians, Credits -->		
<div class="detailsdisplay">
  <table border="0" width="100%">
	 <tr>
   	<td valign="top" width="50%">
			<div id="personaldetails" class="opacity">
				<table border="0" cellspacing="0" cellpadding="0">
			       <tr><td class="header"colspan="2"><xsl:value-of select="/musicinfo/localizedtemplatetexts/field[@id='ttPersonalDetails']/@label"/></td></tr>
			      <xsl:if test="purchasedate!=''">
			         <tr valign="top">
			          <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfPurchaseDate']/@label"/></td>
			          <td class="fieldvalue"><xsl:value-of select="purchasedate/date"/></td>
			         </tr>
			      </xsl:if>
<!--Precio-->
			      <!--<xsl:if test="purchaseprice!=''">
			         <tr valign="top">
			          <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfPrice']/@label"/></td>
			          <td class="fieldvalue"><xsl:value-of select="purchaseprice"/></td>
			         </tr>
			      </xsl:if>-->
<!--Tienda-->            
			      <!--<xsl:if test="store!=''">
			         <tr valign="top">
			          <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfStore']/@label"/></td>
			          <td class="fieldvalue"><xsl:apply-templates select="store"/></td>
			         </tr>
			      </xsl:if>-->
<!--Condicion-->            
			      <!--<xsl:if test="condition!=''">
			         <tr valign="top">
			          <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfCondition']/@label"/></td>
			          <td class="fieldvalue"><xsl:value-of select="condition/displayname"/></td>
			         </tr>
			      </xsl:if>-->
<!--Valos actual-->            
			      <!--<xsl:if test="currentvalue!=''">
			         <tr valign="top">
			          <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfCurrentValue']/@label"/></td>
			          <td class="fieldvalue"><xsl:value-of select="currentvalue"/></td>
			         </tr>
			      </xsl:if>-->
			      <xsl:if test="quantity>'1'">
			         <tr valign="top">
			          <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfQuantity']/@label"/></td>
			          <td class="fieldvalue"><xsl:value-of select="quantity"/></td>
			         </tr>
			      </xsl:if>
			      <xsl:if test="tags!=''">
			         <tr valign="top">
			          <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfTag']/@label"/></td>
			          <td class="fieldvalue"><xsl:for-each select="tags/tag">
			             <xsl:value-of select="displayname"/>
			             <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
			           </xsl:for-each></td>
			         </tr>
			      </xsl:if>
		
		         <xsl:if test="albumtext1!=''">
		           <tr valign="top">
		            <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfAlbumText1']/@label"/></td>
		            <td class="fieldvalue"><xsl:value-of select="albumtext1"/></td>
		          </tr>
		         </xsl:if>
		
		         <xsl:if test="albumtext2!=''">
		           <tr valign="top">
		            <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfAlbumText2']/@label"/></td>
		            <td class="fieldvalue"><xsl:value-of select="albumtext2"/></td>
		           </tr>
		         </xsl:if>
		
		         <xsl:if test="albumlookup1!=''">
		           <tr valign="top">
		            <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfAlbumLookup1']/@label"/></td>
		            <td class="fieldvalue"><xsl:apply-templates select="albumlookup1"/></td>
		           </tr>
		         </xsl:if>
		
		         <xsl:if test="albumlookup2!=''">
		           <tr><td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfAlbumLookup2']/@label"/></td>
		           <td class="fieldvalue"><xsl:apply-templates select="albumlookup2"/></td>
		          </tr>
		         </xsl:if>

<!--Propietario-->
		         <!--<xsl:if test="owner!=''">
		           <tr><td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfOwner']/@label"/></td>
		           <td class="fieldvalue"><xsl:apply-templates select="owner"/></td>
		          </tr>
		         </xsl:if>-->
<!--localización-->			
		         <xsl:if test="location!=''">
              <!--Reemplazado localización por LCT-->
		           <tr><!--<td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfLocation']/@label"/></td>-->
               <td class="fieldlabel" nowrap="1">LCT</td>
		           <td class="fieldvalue"><xsl:value-of select="location/displayname"/></td>
		          </tr>
		         </xsl:if>

		         <xsl:if test="loan/loanedto!=''">
		           <tr><td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfLoaner']/@label"/></td>
		           <td class="fieldvalue"><xsl:apply-templates select="loan/loanedto"/>&#160;@&#160;<xsl:value-of select="loan/loandate/date"/></td>
		          </tr>
		         </xsl:if>			 
<!--Enlaces-->
		        <xsl:if test="links!=''">
		          <xsl:if test="links//*[urltype='URL']!=''">
		           <!--<tr valign="top">
		            <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfLinks']/@label"/></td>
		            <td class="fieldvalue">
		              <xsl:apply-templates select="links//*[urltype='URL']"/>
		            </td>
		           </tr>-->
		          </xsl:if>
		          <xsl:if test="(links//*[urltype='Movie']!='')">
		           <tr valign="top">
		            <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfMovieLinks']/@label"/></td>
		            <td class="fieldvalue">
		              <xsl:apply-templates select="(links//*[urltype='Movie'])"/>
		            </td>
		           </tr>
		          </xsl:if>
		          <xsl:if test="(links//*[urltype='Playlist']!='')">
		           <tr valign="top">
		            <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfPlayListLinks']/@label"/></td>
		            <td class="fieldvalue">
		              <xsl:apply-templates select="(links//*[urltype='Playlist'])"/>
		            </td>
		           </tr>
		          </xsl:if>          
		          <xsl:if test="(links//*[urltype='Other']!='')">
		           <tr valign="top">
		            <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfOtherLinks']/@label"/></td>
		            <td class="fieldvalue">
		              <xsl:apply-templates select="(links//*[urltype='Other'])"/>
		            </td>
		           </tr>
		          </xsl:if>
		        </xsl:if>    			
		        <xsl:if test="count(details/detail/storageslot) > 0 or count(details/detail/storagedevice) > 0">     
		          <xsl:for-each select="details/detail">            
		            <xsl:if test="storageslot!='' or storagedevice/displayname!=''">                        
		              <xsl:if test="position()=1">              
		                <tr><td class="header" colspan="2"><br/><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfStorageDevice']/@label"/></td></tr>
		              </xsl:if>              
		              <tr valign="top">
		                <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/localizedtemplatetexts/field[@id='ttDisc']/@label"/>&#160;<xsl:value-of select="position()"/></td>
		                <td class="fieldvalue"><xsl:value-of select="storagedevice/displayname"/>:&#160;<xsl:value-of select="storageslot"/></td>
		              </tr>
		            </xsl:if>
		          </xsl:for-each>
		       </xsl:if>
			     </table>
					</div>
		</td>
   	<td valign="top" >
					<div id="details" class="opacity">
			      <table border="0" cellspacing="0" cellpadding="0">
			       <tr><td class="header" colspan="2"><xsl:value-of select="/musicinfo/localizedtemplatetexts/field[@id='ttDetails']/@label"/></td></tr>         
		         <xsl:if test="studios!=''">
		           <tr valign="top"><td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfStudio']/@label"/></td>
		            <td class="fieldvalue">
		               <xsl:for-each select="studios/studio">
		               	<xsl:apply-templates select="./"/>
		                 <xsl:if test="position()!=last()"><xsl:text>; </xsl:text></xsl:if>
		               </xsl:for-each>
		            </td>           
		           </tr>           
		         </xsl:if>
				       <xsl:if test="origreleasedate!=''">
			 					 <tr valign="top">
									 <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfOrigReleaseDate']/@label"/></td>
									 <td class="fieldvalue"><xsl:value-of select="origreleasedate/date"/></td>
								 </tr>
				       </xsl:if>
					<xsl:if test="composition!=''">
			         <tr valign="top">
			           <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfComposition']/@label"/></td>
			           <td class="fieldvalue"><xsl:value-of select="composition/displaytitle"/></td>
			          </tr>
			       </xsl:if>       		  
<!--Numero de catalogo-->                  
							<!--<xsl:if test="labelnumber!=''">
								<tr valign="top">				
									<td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfLabelNumber']/@label"/></td>
									<td class="fieldvalue"><xsl:value-of select="labelnumber"/></td>
								</tr>
							</xsl:if>-->        
							<xsl:if test="upc!=''">
								<tr valign="top">
									<td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfUPC']/@label"/></td>
									<td class="fieldvalue"><xsl:value-of select="upc"/></td>
								</tr>
							</xsl:if>
<!--Embalaje-->
							<!--<xsl:if test="packaging!=''">
								<tr valign="top">
									<td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfPackaging']/@label"/></td>
									<td class="fieldvalue"><xsl:value-of select="packaging/displayname"/></td>
								</tr>
							</xsl:if>-->              
			       <xsl:if test="tourname!=''">
			         <tr valign="top">
			           <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfTourname']/@label"/></td>
			           <td class="fieldvalue"><xsl:value-of select="tourname"/></td>
			          </tr>
			       </xsl:if>
			       <xsl:if test="live/@boolvalue!='0'">
			         <tr valign="top">
			           <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfLive']/@label"/></td>
			           <td class="fieldvalue"><xsl:value-of select="live"/></td>
			          </tr>
			       </xsl:if>
			       <xsl:if test="recordingdate!=''">
			 	        <tr valign="top">
			           <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfRecordingDate']/@label"/></td>
			           <td class="fieldvalue"><xsl:value-of select="recordingdate/date"/></td>
			          </tr>
			       </xsl:if>
			       <xsl:if test="spars!=''">
			         <tr valign="top">
			           <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfSpars']/@label"/></td>
			           <td class="fieldvalue"><xsl:value-of select="spars"/></td>
			         </tr>
			       </xsl:if>
			       <xsl:if test="rare/@boolvalue!='0'">
			       	<tr valign="top">         
			         <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfRare']/@label"/></td>
			         <td class="fieldvalue"><xsl:value-of select="rare"/></td>
			        </tr>
			       </xsl:if>  
			       <xsl:if test="sounds!=''">
			         <tr valign="top">
			          <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfSound']/@label"/></td>
			          <td class="fieldvalue">
			             <xsl:for-each select="sounds/sound">
			               <xsl:value-of select="displayname"/>
			               <xsl:if test="position()!=last()"><xsl:text>; </xsl:text></xsl:if>
			             </xsl:for-each>
			          </td>
			         </tr>
			      </xsl:if>         
			       <xsl:if test="extras!=''">
			         <tr valign="top">
			          <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfExtras']/@label"/></td>
			          <td class="fieldvalue">
			             <xsl:for-each select="extras/extra">
			               <xsl:value-of select="displayname"/>
			               <xsl:if test="position()!=last()"><xsl:text>; </xsl:text></xsl:if>
			             </xsl:for-each></td>
			        </tr>
			      </xsl:if>
			     </table>
			    </div>
		</td>
	 </tr>
    <tr>
   	<td valign="top">
				<xsl:if test="musicians!='' or (composers!='' and artists !='')">
					<div id="musiciandetails" class="opacity">
			     <table border="0" cellspacing="1" cellpadding="1">
							<tr><td class="header" colspan="2"><xsl:value-of select="/musicinfo/localizedtemplatetexts/field[@id='ttMusicians']/@label"/></td></tr>			     
							<xsl:if test="composers!='' and artists!=''">
					        <tr valign="top">
				          <td class="fieldlabel"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfArtist']/@label"/></td>	     
				         	<td class="fieldvalue" nowrap="1">          
				  	        <xsl:for-each select="artists/artist">                      
				              <xsl:apply-templates select="."/>
				              <xsl:if test="position()!=last()"><xsl:text>; </xsl:text></xsl:if>  	                      
				  	        </xsl:for-each>
					       </td>
					       </tr>
						  </xsl:if>	  
			        <xsl:for-each select="musicians/musician">
		           <tr>
		             <xsl:variable name="role" select="role/@id"/>
		             <xsl:choose>
		               <xsl:when test="instrument!=''">
		                 <td class="fieldlabel"><xsl:value-of select="instrument/displayname"/></td>
		               </xsl:when>
		               <xsl:otherwise>
		                 <td class="fieldlabel"><xsl:value-of select="/musicinfo/musicmetadata/field[@id=$role]/@label"/></td>
		                </xsl:otherwise>
		             </xsl:choose>
		            	<td class="fieldvalue" nowrap="1">
		                <xsl:apply-templates select="person"/>
		               </td>
		             </tr>	       	        
			        </xsl:for-each>
			     </table>
					</div>
			  </xsl:if>
		</td>
   	<td valign="top">
			 	<xsl:if test="credits!='' or conductor!='' or orchestra!='' or chorus!=''">					
					<div id="creditsdetails" class="opacity">
			     <table border="0" cellspacing="0" cellpadding="0">
							<tr><td class="header" colspan="2"><xsl:value-of select="/musicinfo/localizedtemplatetexts/field[@id='ttCredits']/@label"/></td></tr>			     
			       <xsl:if test="conductor!=''">
		 					 <tr valign="top">
								 <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfConductor']/@label"/></td>
								 <td class="fieldvalue"><xsl:apply-templates select="conductor"/></td>
							 </tr>
			       </xsl:if>
			       <xsl:if test="orchestra!=''">
			       	 <tr valign="top">
								 <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfOrchestra']/@label"/></td>
								 <td class="fieldvalue"><xsl:apply-templates select="orchestra"/></td>
							 </tr>
			       </xsl:if>       
			       <xsl:if test="chorus!=''">
			       	 <tr valign="top">
								 <td class="fieldlabel" nowrap="1"><xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfChorus']/@label"/></td>
								 <td class="fieldvalue"><xsl:apply-templates select="chorus"/></td>
							 </tr>
			       </xsl:if>       		       

			        <xsl:call-template name="creditrole"><xsl:with-param name="roleid">dfSongwriter</xsl:with-param></xsl:call-template>
			        <xsl:call-template name="creditrole"><xsl:with-param name="roleid">dfProducer</xsl:with-param></xsl:call-template>
			        <xsl:call-template name="creditrole"><xsl:with-param name="roleid">dfEngineer</xsl:with-param></xsl:call-template>
			        <xsl:call-template name="creditrole"><xsl:with-param name="roleid">dfUserCredit1</xsl:with-param></xsl:call-template>
			        <xsl:call-template name="creditrole"><xsl:with-param name="roleid">dfUserCredit2</xsl:with-param></xsl:call-template>
			     </table>
					</div>			     
			  </xsl:if>		
		</td>
	 </tr>
	 </table>		
	</div>
	
<!-- Notes -->
  <xsl:if test="notes!=''">
		<div id="notes" class="opacity">
		  <div class="header">
		  	<xsl:value-of select="/musicinfo/musicmetadata/field[@id='dfNotes']/@label"/>
		  </div>
	    <xsl:call-template name="break">
	      <xsl:with-param name="text" select="notes"/>
	    </xsl:call-template>
		</div>
  </xsl:if>
  
<!-- Links -->
   <div style="float:left;margin-right:5px;margin-top:5px;">
    <xsl:if test="$absolutelinks = 'true'">
      <xsl:if test="links!=''">
        <xsl:if test="links//*[urltype='Image']!=''">
          <div id="imagefiles">
            <p/>		          
            <div class="header opacity" style="font-size:10pt">
              <xsl:value-of select="/musicinfo/localizedtemplatetexts/field[@id='ttImageLinkDetails']/@label"/>
            </div>
            <xsl:for-each select="links//*[urltype='Image']">
              <xsl:call-template name="imagelink">
                <xsl:with-param name="in_viewhref">http://image.html</xsl:with-param>
                <xsl:with-param name="in_url" select="url"/>
              </xsl:call-template>
            </xsl:for-each>
          </div>
        </xsl:if>
      </xsl:if>
	  </xsl:if>
</div></div>
<xsl:if test="$templatetype!='exportdetails'">
<xsl:if test="backdropurl!=''">
  <div style="float:left;margin-right:5px;margin-top:5px;">
    <div class="header opacity" style="font-size:10pt;">Backdrop</div>	
		  <xsl:call-template name="backdropimage">
		    <xsl:with-param name="nameimg" select="backdropurl"/>
		  </xsl:call-template>
  </div>
</xsl:if>
</xsl:if>

<xsl:if test="position()!=last()">
  <p style="page-break-before:always"/>
</xsl:if>    

</xsl:template>

<xsl:template match="navigation">
	<nav class="text-center">
		<ul class="pagination">
      <xsl:choose>
        <xsl:when test="firstlink/@url!=''">
          <li><a href="{firstlink/@url}"><xsl:value-of select="/musicinfo/localizedtemplatetexts/field[@id='ttFirst']/@label"/></a></li>
        </xsl:when>
        <xsl:otherwise>
          <li><xsl:value-of select="/musicinfo/localizedtemplatetexts/field[@id='ttFirst']/@label"/></li>
        </xsl:otherwise>
      </xsl:choose>   
      <xsl:choose>
        <xsl:when test="prevlink/@url!=''">
          <li><a href="{prevlink/@url}"><xsl:value-of select="/musicinfo/localizedtemplatetexts/field[@id='ttPrev']/@label"/></a></li>
        </xsl:when>
        <xsl:otherwise>
          <li><xsl:value-of select="/musicinfo/localizedtemplatetexts/field[@id='ttPrev']/@label"/></li>
        </xsl:otherwise>
      </xsl:choose>   
      <xsl:choose>
        <xsl:when test="uplink/@url!=''">
          <li><a href="{uplink/@url}"><xsl:value-of select="/musicinfo/localizedtemplatetexts/field[@id='ttUp']/@label"/></a></li>
        </xsl:when>
        <xsl:otherwise>
          <li><xsl:value-of select="/musicinfo/localizedtemplatetexts/field[@id='ttUp']/@label"/></li>
        </xsl:otherwise>
      </xsl:choose>   
      <xsl:choose>
        <xsl:when test="nextlink/@url!=''">
          <li><a href="{nextlink/@url}"><xsl:value-of select="/musicinfo/localizedtemplatetexts/field[@id='ttNext']/@label"/></a></li>
        </xsl:when>
        <xsl:otherwise>
          <li><xsl:value-of select="/musicinfo/localizedtemplatetexts/field[@id='ttNext']/@label"/></li>
        </xsl:otherwise>
      </xsl:choose>   
      <xsl:choose>
        <xsl:when test="lastlink/@url!=''">
          <li><a href="{lastlink/@url}"><xsl:value-of select="/musicinfo/localizedtemplatetexts/field[@id='ttLast']/@label"/></a></li>
        </xsl:when>
        <xsl:otherwise>
          <li><xsl:value-of select="/musicinfo/localizedtemplatetexts/field[@id='ttLast']/@label"/></li>
        </xsl:otherwise>
      </xsl:choose>   
		</ul>
	</nav>

</xsl:template>

</xsl:stylesheet>
