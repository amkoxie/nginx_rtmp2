<?xml version="1.0" encoding="utf-8" ?>


<!--
   Copyright (C) Roman Arutyunyan
-->


<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<xsl:template match="/">
    <html>
        <head>
            <title>RTMP statistics</title>
        </head>
        <body>
            <xsl:apply-templates select="rtmp"/>
            <hr/>
            Generated by <a href='https://github.com/arut/nginx-rtmp-module'>
            nginx-rtmp-module</a>&#160;<xsl:value-of select="/rtmp/nginx_rtmp_version"/>,
            <a href="http://nginx.org">nginx</a>&#160;<xsl:value-of select="/rtmp/nginx_version"/>,
            pid <xsl:value-of select="/rtmp/pid"/>,
            built <xsl:value-of select="/rtmp/built"/>&#160;<xsl:value-of select="/rtmp/compiler"/>
<script>
  setTimeout(function() { location.reload(); }, 1000);
  var d=document.getElementsByClassName('data-panel')[0];
  var match = location.search.match(/show/)
  if (match) { d.style.display = '' }
  else { d.style.display = 'none'}
 </script>
        </body>
    </html>
</xsl:template>


<!--Second-->
<xsl:template match="rtmp">
    <table cellspacing="1" cellpadding="5">
        <!--一级表头-->
        <tr bgcolor="#999999">
            <th>RTMP</th>
            <th>#clients</th>
            <th colspan="6">Video</th>
            <th colspan="6">Audio</th>
            <th>In bytes</th>
            <th>Out bytes</th>
            <th>In bits/s</th>
            <th>Out bits/s</th>
            <th>Time</th>
            <th>State</th>
            <!-- 缓存 -->
            <th bgcolor="#6495ED">Cache Time</th>
            <th bgcolor="#6495ED">Cache Count</th>
            <th bgcolor="#6495ED">#relays</th>
        </tr>
        <tr>
            <!--colspan 和并列两列-->
            <td colspan="2">Accepted: <xsl:value-of select="naccepted"/></td>
            <th bgcolor="#999999">codec</th>
            <th bgcolor="#999999">In bits/s</th>
            <th bgcolor="#6495ED">Out bits/s</th>
            <th bgcolor="#6495ED">Cache Time</th>
            <th bgcolor="#999999">size</th>
            <th bgcolor="#999999">fps</th>
            <th bgcolor="#999999">codec</th>
            <th bgcolor="#999999">In bits/s</th>
            <th bgcolor="#6495ED">Out bits/s</th>
            <th bgcolor="#6495ED">Cache Time</th>
            <th bgcolor="#999999">freq</th>
            <th bgcolor="#999999">chan</th>
            <!-- 后面几列 FF69B4-->
            <td>          
                <xsl:call-template name="showsize">
                    <xsl:with-param name="size" select="bytes_in"/>
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="showsize">
                    <xsl:with-param name="size" select="bytes_out"/>
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="showsize">
                    <xsl:with-param name="size" select="bw_in"/>
                    <xsl:with-param name="bits" select="1"/>
                    <xsl:with-param name="persec" select="1"/>
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="showsize">
                    <xsl:with-param name="size" select="bw_out"/>
                    <xsl:with-param name="bits" select="1"/>
                    <xsl:with-param name="persec" select="1"/>
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="showtime">
                    <xsl:with-param name="time" select="/rtmp/uptime * 1000"/>
                </xsl:call-template>
            </td>
            <!--空白的-->
            <td/>
            <td/>
            <td/>
            <td/>
        </tr>
        <xsl:apply-templates select="server"/>
    </table>
</xsl:template>






<xsl:template match="server">
    <xsl:apply-templates select="application"/>
</xsl:template>

<xsl:template match="application">
    <tr bgcolor="#999999">
        <td>
            <b><xsl:value-of select="name"/></b>
        </td>
    </tr>
    <xsl:apply-templates select="live"/>
    <xsl:apply-templates select="play"/>
</xsl:template>

<xsl:template match="live">
    <tr bgcolor="#aaaaaa">
        <td>
            <i>live streams</i>
        </td>
        <td align="middle">
            <xsl:value-of select="nclients"/>
        </td>
    </tr>
    <xsl:apply-templates select="stream"/>
</xsl:template>

<xsl:template match="play">
    <tr bgcolor="#aaaaaa">
        <td>
            <i>vod streams</i>
        </td>
        <td align="middle">
            <xsl:value-of select="nclients"/>
        </td>
    </tr>
    <xsl:apply-templates select="stream"/>
</xsl:template>





<xsl:template match="stream">
    <tr valign="top">
        <xsl:attribute name="bgcolor">
            <xsl:choose>
                <!--
                <xsl:when test="active">#cccccc</xsl:when>
                <xsl:otherwise>#dddddd</xsl:otherwise>
                <xsl:when test="active">#808080</xsl:when>
                -->
                <xsl:when test="active">#B0C4DE</xsl:when>
                <xsl:otherwise>#dddddd</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        
        <td>
            <a href="">
                <xsl:attribute name="onclick">
                    var d=document.getElementById('<xsl:value-of select="../../name"/>-<xsl:value-of select="name"/>');
                    d.style.display=d.style.display=='none'?'':'none';
                    location.search = location.search ? '' : 'show'
                    return false
                </xsl:attribute>
                <xsl:value-of select="name"/>
                <xsl:if test="string-length(name) = 0">
                    [EMPTY]
                </xsl:if>
            </a>
        </td>
        
        <td align="middle"> <xsl:value-of select="nclients"/> </td>
        
        <td>
            <xsl:value-of select="meta/video/codec"/>&#160;<xsl:value-of select="meta/video/profile"/>&#160;<xsl:value-of select="meta/video/level"/>
        </td>
        
        <td>
            <xsl:call-template name="showsize">
                <xsl:with-param name="size" select="bw_in_video"/>
                <xsl:with-param name="bits" select="1"/>
                <xsl:with-param name="persec" select="1"/>
            </xsl:call-template>
        </td>
        <!--Vedio Out-->
        <td>
            <xsl:call-template name="showsize">
                <xsl:with-param name="size" select="bw_out_video"/>
                <xsl:with-param name="bits" select="1"/>
                <xsl:with-param name="persec" select="1"/>
            </xsl:call-template>
        </td>

        <td>
            <xsl:call-template name="showtime">
               <xsl:with-param name="time" select="cache_vlen"/>
            </xsl:call-template>
        </td>
        <!--
        <td>
            <xsl:call-template name="showsize">
               <xsl:with-param name="size" select="cache_vlen"/>
           </xsl:call-template>
        </td>
        -->
        
        <td>
            <xsl:apply-templates select="meta/video/width"/>
        </td>
        
        <td>
            <xsl:value-of select="meta/video/frame_rate"/>
        </td>
        
        <td>
            <xsl:value-of select="meta/audio/codec"/>&#160;<xsl:value-of select="meta/audio/profile"/>
        </td>
        
        <td>
            <xsl:call-template name="showsize">
                <xsl:with-param name="size" select="bw_in_audio"/>
                <xsl:with-param name="bits" select="1"/>
                <xsl:with-param name="persec" select="1"/>
            </xsl:call-template>
        </td>
        <!--Audio Out--> 
        <td>
            <xsl:call-template name="showsize">
                <xsl:with-param name="size" select="bw_out_audio"/>
                <xsl:with-param name="bits" select="1"/>
                <xsl:with-param name="persec" select="1"/>
            </xsl:call-template>
        </td>
        <td>
            <xsl:call-template name="showtime">
               <xsl:with-param name="time" select="cache_alen"/>
            </xsl:call-template>
        </td>
        <!--
        <td>
            <xsl:call-template name="showsize">
               <xsl:with-param name="size" select="cache_alen"/>
           </xsl:call-template>
        </td>
        -->
        <td>
            <xsl:apply-templates select="meta/audio/sample_rate"/>
        </td>

        <!--频道-->
        <td>
            <xsl:value-of select="meta/audio/channels"/>
        </td>
        
        <td>
            <xsl:call-template name="showsize">
               <xsl:with-param name="size" select="bytes_in"/>
           </xsl:call-template>
        </td>
        
        <td>
            <xsl:call-template name="showsize">
                <xsl:with-param name="size" select="bytes_out"/>
            </xsl:call-template>
        </td>
        
        <td>
            <xsl:call-template name="showsize">
                <xsl:with-param name="size" select="bw_in"/>
                <xsl:with-param name="bits" select="1"/>
                <xsl:with-param name="persec" select="1"/>
            </xsl:call-template>
        </td>
        
        <td>
            <xsl:call-template name="showsize">
                <xsl:with-param name="size" select="bw_out"/>
                <xsl:with-param name="bits" select="1"/>
                <xsl:with-param name="persec" select="1"/>
            </xsl:call-template>
        </td>
        
        <td>
            <xsl:call-template name="showtime">
               <xsl:with-param name="time" select="time"/>
            </xsl:call-template>
        </td>
        
        <td><xsl:call-template name="streamstate"/></td>
            
        <td>
            <xsl:call-template name="showtime">
               <xsl:with-param name="time" select="cache_len"/>
            </xsl:call-template>
        </td>
        <td><xsl:value-of select="cache_count"/></td>
        <td><xsl:value-of select="nrelays"/></td>
    </tr>


    <tr style="" class="data-panel">
        <xsl:attribute name="id">
            <xsl:value-of select="../../name"/>-<xsl:value-of select="name"/>
        </xsl:attribute>
        <!--
        <td colspan="16" ngcolor="#eeeeee">
        -->
        <!--查特酒绿 -->
        <td colspan="23" ngcolor="#7FFF00">
            <table cellspacing="1" cellpadding="5">
                <tr>
                    <th>Id</th>
                    <th>State</th>
                    <th>Address</th>
                    <th>Flash version</th>
                    <th>Page URL</th>
                    <th>SWF URL</th>
                    <th>Dropped</th>
                    <th>Timestamp</th>
                    <!--
                    <th min-width="30">A-V</th>
                    -->
                    <th>A-V</th>
                    <th>Time</th>
                    <th>TC URL</th>
                    <th>#recs</th>
                </tr>
                <!--stream 值的获得-->
                <xsl:apply-templates select="client"/>
            </table>
        </td>
    </tr>
</xsl:template>





<xsl:template name="showtime">
    <xsl:param name="time"/>

    <xsl:if test="$time &gt; 0">
        <xsl:variable name="sec">
            <xsl:value-of select="floor($time div 1000)"/>
        </xsl:variable>

        <xsl:if test="$sec &gt;= 86400">
            <xsl:value-of select="floor($sec div 86400)"/>d
        </xsl:if>

        <xsl:if test="$sec &gt;= 3600">
            <xsl:value-of select="(floor($sec div 3600)) mod 24"/>h
        </xsl:if>

        <xsl:if test="$sec &gt;= 60">
            <xsl:value-of select="(floor($sec div 60)) mod 60"/>m
        </xsl:if>

        <xsl:value-of select="$sec mod 60"/>s
    </xsl:if>
</xsl:template>


<xsl:template name="showsize">
    <xsl:param name="size"/>
    <xsl:param name="bits" select="0" />
    <xsl:param name="persec" select="0" />
    <xsl:variable name="sizen">
        <xsl:value-of select="floor($size div 1024)"/>
    </xsl:variable>
    <xsl:choose>
        <xsl:when test="$sizen &gt;= 1073741824">
            <xsl:value-of select="format-number($sizen div 1073741824,'#.###')"/> T</xsl:when>

        <xsl:when test="$sizen &gt;= 1048576">
            <xsl:value-of select="format-number($sizen div 1048576,'#.###')"/> G</xsl:when>

        <xsl:when test="$sizen &gt;= 1024">
            <xsl:value-of select="format-number($sizen div 1024,'#.##')"/> M</xsl:when>
        <xsl:when test="$sizen &gt;= 0">
            <xsl:value-of select="$sizen"/> K</xsl:when>
    </xsl:choose>
    <xsl:if test="string-length($size) &gt; 0">
        <xsl:choose>
            <xsl:when test="$bits = 1">b</xsl:when>
            <xsl:otherwise>B</xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$persec = 1">/s</xsl:if>
    </xsl:if>
</xsl:template>


<xsl:template name="streamstate">
    <xsl:choose>
        <xsl:when test="active">active</xsl:when>
        <xsl:otherwise>idle</xsl:otherwise>
    </xsl:choose>
</xsl:template>


<xsl:template name="clientstate">
    <xsl:choose>
        <xsl:when test="publishing">publishing</xsl:when>
        <xsl:otherwise>playing</xsl:otherwise>
    </xsl:choose>
</xsl:template>







<xsl:template match="client">
    <tr>
        <xsl:attribute name="bgcolor">
            <xsl:choose>
                <xsl:when test="publishing">#cccccc</xsl:when>
                <xsl:otherwise>#eeeeee</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        
        <!--id-->
        <td><xsl:value-of select="id"/></td>

        <!--类别 publish or play-->
        <td><xsl:call-template name="clientstate"/></td>

        <!--地址-->
        <td>
            <a target="_blank">
                <xsl:attribute name="href">
                    http://apps.db.ripe.net/search/query.html&#63;searchtext=<xsl:value-of select="address"/>
                </xsl:attribute>
                <xsl:attribute name="title">whois</xsl:attribute>
                <xsl:value-of select="address"/>
            </a>
        </td>
        
        <!--flash 版本-->
        <td><xsl:value-of select="flashver"/></td>
                
        <!---->
        <td>
            <a target="_blank">
                <xsl:attribute name="href">
                    <xsl:value-of select="pageurl"/>
                </xsl:attribute>
                <xsl:value-of select="pageurl"/>
            </a>
        </td>
        
        <td><xsl:value-of select="swfurl"/></td>
        <td><xsl:value-of select="dropped"/></td>
        <td><xsl:value-of select="timestamp"/></td>
        <td><xsl:value-of select="avsync"/></td>
        
        <!--时间-->
        <td>
            <xsl:call-template name="showtime">
               <xsl:with-param name="time" select="time"/>
            </xsl:call-template>
        </td>

        <!--推送地址-->
        <td><xsl:value-of select="tcurl"/></td>
        <td><xsl:value-of select="nreconnects"/></td>
    </tr>
</xsl:template>





<xsl:template match="publishing">
    publishing
</xsl:template>

<xsl:template match="active">
    active
</xsl:template>

<xsl:template match="width">
    <xsl:value-of select="."/>x<xsl:value-of select="../height"/>
</xsl:template>

</xsl:stylesheet>