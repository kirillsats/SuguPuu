<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
	<xsl:output method="xml" indent="yes"/>

	<!-- xsl:key: loome indeksi inimeste jaoks elukoha järgi (kasutatakse elukohtade statistikas) -->
	<xsl:key name="elukohtKey" match="inimene" use="@elukoht"/>

	<xsl:template match="/">
		<style>
			.red { color: red; }
			.yellow { background-color: yellow; }
			table, th, td { border: 1px solid black; border-collapse: collapse; padding: 5px; }
		</style>
		<h2>Inimeste andmed</h2>
		<table>
			<tr>
				<th>Nimi</th>
				<th>Perekonnanimi</th>
				<th>SünniAasta</th>
				<th>Vanus</th>
				<th>Elukoht</th>
				<th>Laste arv</th>
				<th>Lapsed</th>
				<th>Auto</th>
				<!-- uus veerg -->
			</tr>
			<xsl:for-each select="//inimene">
				<!-- variable: salvestame väärtused, et neid mitu korda kasutada -->
				<xsl:variable name="nimi" select="nimi"/>
				<xsl:variable name="perenimi" select="perekonnanimi"/>
				<xsl:variable name="saasta" select="@saasta"/>
				<xsl:variable name="lasteArv" select="count(lapsed/inimene)"/>
				<!-- loeme laste arvu -->
				<xsl:variable name="elukoht" select="@elukoht"/>
				<xsl:variable name="hasD" select="contains(nimi, 'A') or contains(nimi, 'a')"/>
				<!-- kontrollime, kas nimes on A või a -->
				<tr>
					<td>
						<!-- xsl:attribute: lisame dünaamiliselt CSS klassid -->
						<xsl:attribute name="class">
							<xsl:if test="$hasD">red</xsl:if>
							<!-- nimi punane, kui sisaldab A või a -->
							<xsl:if test="$lasteArv &gt;= 2">
								<!-- kui lapsi on vähemalt 2 -->
								<xsl:text> </xsl:text>
								<xsl:text>yellow</xsl:text>
							</xsl:if>
						</xsl:attribute>
						<xsl:value-of select="$nimi"/>
					</td>
					<td>
						<xsl:value-of select="$perenimi"/>
					</td>
					<td>
						<xsl:value-of select="$saasta"/>
					</td>
					<td>
						<!-- vanuse arvutamine sünniaasta põhjal -->
						<xsl:value-of select="2025 - number($saasta)"/>
					</td>
					<td>
						<xsl:value-of select="$elukoht"/>
					</td>
					<td>
						<xsl:value-of select="$lasteArv"/>
					</td>
					<td>
						<!-- loetleme laste nimed, eraldame komaga -->
						<xsl:for-each select="lapsed/inimene">
							<xsl:value-of select="nimi"/>
							<xsl:if test="position()!=last()">, </xsl:if>
						</xsl:for-each>
					</td>
					<td>
						<!-- auto veerg: auto olemas või "-" -->
						<xsl:choose>
							<xsl:when test="$nimi='Maksim' and $perenimi='Volkov' and $saasta='1986'">Toyota</xsl:when>
							<xsl:when test="$nimi='Andrei' and $perenimi='Volkov'">Volvo</xsl:when>
							<xsl:when test="$nimi='Kirill' and $perenimi='Volkov'">Volvo</xsl:when>
							<xsl:when test="$nimi='Kirill' and $perenimi='Sats'">Audi</xsl:when>
							<xsl:otherwise>-</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</xsl:for-each>
		</table>
		<h3>Kokkuvõte</h3>
		<p>
			<strong>Kokku inimesi: </strong>
			<xsl:value-of select="count(//inimene)"/>
			<!-- loeme kõigi inimeste arvu -->
		</p>
		<h3>Elukohtade statistika:</h3>
		<ul>
			<!-- kasutame generate-id + key(), et võtta ainult unikaalsed elukohad -->
			<xsl:for-each select="//inimene[generate-id() = generate-id(key('elukohtKey', @elukoht)[1])]">
				<li>
					<xsl:value-of select="@elukoht"/>:
					<xsl:value-of select="count(key('elukohtKey', @elukoht))"/> <!-- mitu inimest selles elukohas -->
				</li>
			</xsl:for-each>
		</ul>
		<!-- tabel: vanaemad ja nende lapselapsed -->
		<h2>Vanaemad ja nende lapselapsed</h2>
		<table>
			<tr>
				<th>Vanaema</th>
				<th>LapseLapsed</th>
				<th>LapseLaste arv</th>
			</tr>
			<xsl:for-each select="//inimene">
				<!-- lapsed2: võtame "laste lapsed", st lapselapsed -->
				<xsl:variable name="lapsed2" select="lapsed/inimene/lapsed/inimene"/>
				<xsl:if test="count($lapsed2) &gt; 0">
					<!-- ainult siis, kui inimesel on vähemalt 1 lapselaps -->
					<tr>
						<td>
							<xsl:value-of select="nimi"/>
							<!-- vanaema nimi -->
						</td>
						<td>
							<!-- loetleme kõik lapselapsed komadega -->
							<xsl:for-each select="$lapsed2">
								<xsl:value-of select="nimi"/>
								<xsl:if test="position()!=last()">, </xsl:if>
							</xsl:for-each>
						</td>
						<td>
							<xsl:value-of select="count($lapsed2)"/>
							<!-- lapselaste koguarv -->
						</td>
					</tr>
				</xsl:if>
			</xsl:for-each>
		</table>
	</xsl:template>
</xsl:stylesheet>
