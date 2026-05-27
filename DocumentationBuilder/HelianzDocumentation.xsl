<?xml version='1.0'?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
  <html>
	<script type="text/javascript" >
	<![CDATA[	//The use of CDATA stops the xml engine from attempting to parse the javascript.

		window.onload = function() {
			loadform();
		}

		/* Triggered when the DOM elements of the page are done loading. Fills the combo and text boxes. Jumps to the anchor */
		function loadform(){
			//Portion that sets the version combo box
			var addr,options,optionChoice; 
			addr=window.location.pathname;
			options=document.getElementById("versionSelect");
			for(i=0; i<options.length; i++){
				optionChoice=options[i].value;
				if(optionChoice === addr){
					options[i].selected=true;
					break;
				}
			}
			//Portion that fills the filter box and refreshes the table list
			var searchterm=getparam("search");
			if(searchterm){
				document.getElementById("filter").value=searchterm;
				this.refreshList();
			}
			//Portion that scrolls the page to the correct anchor.
			if(window.location.hash){
				window.location.href=window.location.hash;
			}
			var link = document.getElementById("linkDocumentation");
			if(options.selectedIndex > -1 && options.options[options.selectedIndex].getAttribute("hasDiff") == "true") {
			  link.style.display = "";
			}
			else {
			  link.style.display = "none";
			}
		}

		/* Refreshes the list of tables in the navigation pane based on the input box. */
		function refreshList() {
			var input, filter, table, tr, td, atag, i;
			input=document.getElementById("filter");
			filter=input.value.toUpperCase();
			table=document.getElementById("tables");
			tr=table.getElementsByTagName("tr");
			//Start at 1 because of the table header
			for(i=1; i<tr.length; i++){
				td=tr[i].getElementsByTagName("td")[0];
				if(td){
					atag=td.getElementsByTagName("a")[0];
					if(atag){
						if(filter.indexOf("#")>-1 && ("#"+atag.innerHTML.toUpperCase()).indexOf(filter)===0) {
							tr[i].style.display="";
						}
						else if(atag.innerHTML.toUpperCase().indexOf(filter) > -1) {
							tr[i].style.display="";
						}
						else {
							tr[i].style.display="none";
						}
					}
				}
			}
		}

		/* Parses through the query parameters for the given term. */
		function getparam(name) {
			name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
			var regexS="[\\?&]" + name + "=([^&#]*)";
			var regex=new RegExp(regexS);
			var results=regex.exec(window.location.href);
			if (!results)
				return "";
			else
				return results[1];
		}
		
		/*changes the content of a string by removing a range of characters and/or adding new characters.*/
		String.prototype.splice = function(idx, delCount, str) {
			return this.slice(0, idx) + str + this.slice(idx + Math.abs(delCount));
		};
		
		/* Sets the correct link to the schema changes. */
		function setSchemaChangesLink() {
			var link = document.getElementById("linkDocumentation");
		//insert "Diff" after Helianz
			var idxStart= window.location.pathname.indexOf("Helianz")+"Helianz".length;
			var newLink=window.location.pathname.splice(idxStart,0,"Diff").replace('/','');
			link.setAttribute('href', newLink);
		}
		
		/* Triggered when an option is selected from the version combo box */
		function optionChanged(newAddress){
			var currentPath=window.location.pathname;
			//If the version selected isn't the current page, then we'll go to it.
			if(currentPath !== newAddress.toString()){
				//We'll carry over the search term and anchor too.
				var searchterm=document.getElementById("filter").value;
				var query="";
				if(searchterm){
					query="?search="+document.getElementById("filter").value;
				}
				var anchor=window.location.hash;	//Anchor returns empty string if theres no anchor
				window.location.href=newAddress.toString() + query + anchor;		
			}
		}
	]]>
	</script>  
  <body>
  <div>
  <nav style="position: fixed; top:0; bottom:0; Left:0; width:300px; Overflow-x:hidden; overflow-y:scroll; min-height:100%;">
	<div style="text-align:center; display: block; margin-bottom:.809em;">
		<p>
		<a href="/">
		<img src="images/logos/logo.png" alt="Home" style="border:0;margin-bottom:8px;"></img>
		</a>
		<select id="versionSelect" onchange="optionChanged(this.value);" style="margin-bottom:8px;">
			<option value="/HelianzDocumentation18-2.xml" hasDiff="true">Version 18.2</option>
			<option value="/HelianzDocumentation18-1.xml" hasDiff="true">Version 18.1</option>
			<option value="/HelianzDocumentation17-4.xml" hasDiff="true">Version 17.4</option>
			<option value="/HelianzDocumentation17-3.xml" hasDiff="true">Version 17.3</option>
			<option value="/HelianzDocumentation17-2.xml" hasDiff="true">Version 17.2</option>
			<option value="/HelianzDocumentation17-1.xml" hasDiff="true">Version 17.1</option>
			<option value="/HelianzDocumentation16-4.xml">Version 16.4</option>
			<option value="/HelianzDocumentation16-3.xml">Version 16.3</option>
			<option value="/HelianzDocumentation16-2.xml">Version 16.2</option>
			<option value="/HelianzDocumentation16-1.xml">Version 16.1</option>
			<option value="/HelianzDocumentation15-4.xml">Version 15.4</option>
			<option value="/HelianzDocumentation15-3.xml">Version 15.3</option>
			<option value="/HelianzDocumentation15-2.xml">Version 15.2</option>
			<option value="/HelianzDocumentation15_1.xml">Version 15.1</option>
			<option value="/HelianzDocumentation14_3.xml">Version 14.3</option>
			<option value="/HelianzDocumentation14_2.xml">Version 14.2</option>
			<option value="/HelianzDocumentation14_1.xml">Version 14.1</option>
			<option value="/HelianzDocumentation13_1.xml">Version 13.1</option>
			<option value="/HelianzDocumentation12_2.xml">Version 12.2</option>
			<option value="/HelianzDocumentation11_1.xml">Version 11.1</option>
			<option value="/HelianzDocumentation75.xml">Version 7.5</option>
			<option value="/HelianzDocumentation73.xml">Version 7.3</option>
			<option value="/HelianzDocumentation67.xml">Version 6.7</option>
			<option value="/HelianzDocumentation64.xml">Version 6.4</option>
			<option value="/HelianzDocumentation56.xml">Version 5.6</option>
			<option value="/HelianzDocumentation55.xml">Version 5.5</option>
			<option value="/HelianzDocumentation51.xml">Version 5.1</option>
			<option value="/HelianzDocumentation44.xml">Version 4.4</option>
		</select>
		<br/>
		<input type="text" id="filter" placeholder="Filter Tables..." onkeyup="refreshList()"></input>
		</p>
	</div>
	<div style="margin-left:20; margin-right:20; overflow-y=auto;">
		<p>
		  <a style="display:none;" href="/HelianzDocumentation18-2.xml" id="linkDocumentation" onclick="setSchemaChangesLink();">Show Schema Changes</a>
		  <table id="tables" border="1" cellpadding="1" cellspacing="0" bgcolor="#F1F4F8" width="243">
			<tr bgcolor="#A5B7C9">
			  <td><b>Database Tables</b></td>
			</tr>
			<xsl:for-each select="database/table">
			<tr>
			  <td>
				<a>
				  <xsl:attribute name="href">
					#<xsl:value-of select="@name"/>
				  </xsl:attribute>
				  <xsl:value-of select="@name"/>
				</a>
			  </td>
			</tr>
			</xsl:for-each>
		  </table>
		</p>
	</div>
	</nav>
	<div style="height:100%; max-width:800px; margin:auto; margin-left:320px;">
		<xsl:for-each select="database/table">
		  <p>
		  <a>
			<xsl:attribute name="name">
			  <xsl:value-of select="@name"/>
			</xsl:attribute>
		  </a>
		  <table width="650" border="1" cellpadding="1" cellspacing="0" bgcolor="#F1F4F8">
			<tr bgcolor="#A5B7C9">
			  <td><b><xsl:value-of select="@name"/></b></td>
			</tr>
			<tr>
			  <td><xsl:value-of select="summary"/></td>
			</tr>
		  </table>
		  <table width="650" border="1" cellpadding="1" cellspacing="0" bgcolor="#F1F4F8">
			<tr bgcolor="#D0D1D2">
			  <td width="50">Order</td>
			  <td width="100">Name</td>
			  <td width="100">Type</td>
			  <td width="400">Summary</td>
			</tr>
			<xsl:for-each select="column">
			<tr>
			  <td width="50"><xsl:value-of select="@order"/></td>
			  <td width="100"><xsl:value-of select="@name"/></td>
			  <td width="100"><xsl:value-of select="@type"/></td>
			  <td width="400">
				<xsl:choose>
				  <xsl:when test="@fk">
					FK to 
					<a>
					  <xsl:attribute name="href">
						#<xsl:value-of select="@fk"/>
					  </xsl:attribute>
					  <xsl:value-of select="@fk"/>
					</a>
					<xsl:value-of select="substring(summary,7 + string-length(@fk))"/>
				  </xsl:when>
				  <xsl:otherwise>
					<xsl:value-of select="summary"/>
				  </xsl:otherwise>
				</xsl:choose>
			  </td>
			</tr>
			  <xsl:for-each select="Enumeration">
				<xsl:for-each select="EnumValue">
				<tr>
				  <td width="50"></td>
				  <td width="100"></td>
				  <td width="100"></td>
				  <td width="400">
					<xsl:value-of select="@name"/>: <xsl:value-of select="."/>
				  </td>
				</tr>
				</xsl:for-each>
			  </xsl:for-each>
			</xsl:for-each>
		  </table>
		  </p>
		</xsl:for-each>
	</div>
	</div>
  </body>
  </html>
</xsl:template>
</xsl:stylesheet>