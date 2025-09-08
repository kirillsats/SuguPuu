<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
    <xsl:output method="xml" indent="yes"/>

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
					<th>Saasta</th>
					<th>Vanus</th>
					<th>Elukoht</th>
					<th>Laste arv</th>
					<th>Lapsed</th>
				</tr>
				<xsl:for-each select="//inimene">
					<xsl:variable name="nimi" select="nimi"/>
					<xsl:variable name="lasteArv" select="count(lapsed/inimene)"/>
					<xsl:variable name="elukoht" select="@elukoht"/>
					<xsl:variable name="hasD" select="contains(nimi, 'D') or contains(nimi, 'd')"/>
					<tr>
						<td>
							<xsl:attribute name="class">
								<xsl:if test="$hasD">red</xsl:if>
								<xsl:if test="$lasteArv &gt;= 2">
									<xsl:text> </xsl:text>
									<xsl:text>yellow</xsl:text>
								</xsl:if>
							</xsl:attribute>
							<xsl:value-of select="$nimi"/>
						</td>
						<td>
							<xsl:value-of select="perekonnanimi"/>
						</td>
						<td>
							<xsl:value-of select="@saasta"/>
						</td>
						<td>
							<xsl:value-of select="2025 - number(@saasta)"/>
						</td>
						<td>
							<xsl:value-of select="$elukoht"/>
						</td>
						<td>
							<xsl:value-of select="$lasteArv"/>
						</td>
						<td>
							<!-- Minu ülesanne. Välja tuua konkreetse isiku laste nimede nimekiri -->
							<xsl:for-each select="lapsed/inimene">
								<xsl:value-of select="nimi"/>
								<xsl:if test="position()!=last()">, </xsl:if>
							</xsl:for-each>
						</td>
					</tr>
				</xsl:for-each>
			</table>
			<h3>Kokkuvõte</h3>
			<p>
				<strong>Kokku inimesi: </strong>
				<xsl:value-of select="count(//inimene)"/>
			</p>
			<h3>Elukohtade statistika:</h3>
			<ul>
				<xsl:for-each select="//inimene[generate-id() = generate-id(key('elukohtKey', @elukoht)[1])]">
					<li>
						<xsl:value-of select="@elukoht"/>:
						<xsl:value-of select="count(key('elukohtKey', @elukoht))"/>
					</li>
				</xsl:for-each>
			</ul>
		<!-- Minu ülesanne. Tee tabel, kus on näidatud vanaemad ja nende lapselapsed. -->
		<h2>Vanaemad ja nende lapselapsed</h2>
		<table>
			<tr>
				<th>Vanaema</th>
				<th>Lapsed</th>
				<th>Laste arv</th>
			</tr>
			<xsl:for-each select="//inimene">
				<xsl:variable name="lapsed2" select="lapsed/inimene/lapsed/inimene"/>
				<xsl:if test="count($lapsed2) &gt; 0">
					<tr>
						<td>
							<xsl:value-of select="nimi"/>
						</td>
						<td>
							<xsl:for-each select="$lapsed2">
								<xsl:value-of select="nimi"/>
								<xsl:if test="position()!=last()">, </xsl:if>
							</xsl:for-each>
						</td>
						<td>
							<xsl:value-of select="count($lapsed2)"/>
						</td>
					</tr>
				</xsl:if>
			</xsl:for-each>
		</table>
	</xsl:template>
</xsl:stylesheet>
