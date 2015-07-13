m4_divert(-1)
#############################
# Use m4 with the -P switch #
#############################


m4_define(`MAP',
`m4_ifelse(
	`$#', `2', `$1($2)',
	`$1($2)'`,'`$0(`$1', m4_shift(m4_shift($@)))'m4_dnl
)'m4_dnl
)


m4_define(`FOLD_R',
`m4_ifelse(
	`$#', `3', `$1($2, $3)',
	`$1($2, $0($1, m4_shift(m4_shift($@))))'m4_dnl
)'m4_dnl
)


m4_define(`FOLD_L',
`m4_ifelse(
	`$#', `3', `$1($2, $3)',
	`$0($1, $1($2, $3), m4_shift(m4_shift(m4_shift($@))))'m4_dnl
)'m4_dnl
)


m4_define(`LINE',
`m4_ifelse(
	`$1', `',,
	`$1
$0(m4_shift($@))'m4_dnl
)'m4_dnl
)


m4_define(`VHDL_PRE', ``m4_divert(1)m4_dnl
m4_pushdef(`NAME', m4_patsubst($1, `.*/\(.*\)$', `\1'))m4_dnl
<li>Dependency <a href="`#'NAME">NAME</a></li>
m4_divert(2)m4_dnl
<article id="NAME">
	<h1>Source code of <em>NAME</em></h1>
	<a href="`#'nav">back to nav</a>
	<pre><code class="language-vhdl">m4_undivert($1)</code></pre>
	<a href="`#'nav">back to nav</a>
</article>
m4_popdef(`NAME')m4_dnl
m4_divert(0)m4_dnl'')
m4_define(`PRE_VHDL', `VHDL_PRE($1)')


m4_divert(0)m4_dnl
m4_divert(1)m4_dnl
m4_dnl
m4_dnl
m4_dnl
m4_define(`TOP_ARCH', m4_patsubst(VHDL_TOP, `.*/\(.*\)$', `\1'))m4_dnl
m4_divert(1)m4_dnl
<li>Arch <a href="`#'TOP_ARCH">TOP_ARCH</a></li>
m4_divert(2)m4_dnl
<article id="TOP_ARCH">
	<h1>Arch <em>TOP_ARCH</em></h1>
	<a href="`#'nav">back to nav</a>
	<pre><code class="language-vhdl">m4_undivert(VHDL_TOP)</code></pre>
	<a href="`#'nav">back to nav</a>
</article>
m4_divert(0)m4_dnl
m4_dnl
m4_dnl
m4_dnl
m4_define(`TOP_TEST', m4_patsubst(VHDL_TEST, `.*/\(.*\)$', `\1'))m4_dnl
m4_divert(1)m4_dnl
<li>Test <a href="`#'TOP_TEST">TOP_TEST</a></li>
m4_divert(2)m4_dnl
<article id="TOP_TEST">
	<h1>Test <em>TOP_TEST</em></h1>
	<a href="`#'nav">back to nav</a>
	<pre><code class="language-vhdl">m4_undivert(VHDL_TEST)</code></pre>
	<a href="`#'nav">back to nav</a>
</article>
m4_divert(0)m4_dnl
m4_dnl
m4_dnl
m4_dnl
m4_define(`TEST_IN_NAME', m4_patsubst(TEST_IN, `.*/\(.*\)$', `\1'))m4_dnl
m4_divert(1)m4_dnl
<li>Test input <a href="`#'TEST_IN_NAME">TEST_IN_NAME</a></li>
m4_divert(2)m4_dnl
<article id="TEST_IN_NAME">
	<h1>Test input <em>TEST_IN_NAME</em></h1>
	<a href="`#'nav">back to nav</a>
	<pre><code class="language-bash">m4_undivert(TEST_IN)</code></pre>
	<a href="`#'nav">back to nav</a>
</article>
m4_divert(0)m4_dnl
m4_dnl
m4_dnl
m4_dnl
m4_define(`TEST_OUT_NAME', m4_patsubst(TEST_OUT, `.*/\(.*\)$', `\1'))m4_dnl
m4_divert(1)m4_dnl
<li>Test output <a href="`#'TEST_OUT_NAME">TEST_OUT_NAME</a></li>
m4_divert(2)m4_dnl
<article id="TEST_OUT_NAME">
	<h1>Test output <em>TEST_OUT_NAME</em></h1>
	<a href="`#'nav">back to nav</a>
	<pre><code class="language-bash">m4_undivert(TEST_OUT)</code></pre>
	<a href="`#'nav">back to nav</a>
</article>
m4_divert(0)m4_dnl
m4_dnl
m4_dnl
m4_dnl
m4_define(`SIMPNG_NAME', m4_patsubst(SIMPNG, `.*/\(.*\)$', `\1'))m4_dnl
m4_divert(1)m4_dnl
<li>Test waveform <a href="`#'SIMPNG_NAME">SIMPNG_NAME</a></li>
m4_divert(2)m4_dnl
<article id="SIMPNG_NAME">
	<h1>Test waveform <em>SIMPNG_NAME</em></h1>
	<a href="`#'nav">back to nav</a>
	<p><img src="SIMPNG_NAME"
		alt="waveform of test"
		style="width: 100%;"></p>
	<a href="`#'nav">back to nav</a>
</article>
m4_divert(0)m4_dnl
m4_dnl
m4_dnl
m4_dnl
m4_define(`PINOUT_NAME', m4_patsubst(PINOUT, `.*/\(.*\)$', `\1'))m4_dnl
m4_divert(1)m4_dnl
<li>Schematic pinout <a href="`#'PINOUT_NAME">PINOUT_NAME</a></li>
m4_divert(2)m4_dnl
<article id="PINOUT_NAME">
	<h1>Schematic pinout <em>PINOUT_NAME</em></h1>
	<a href="`#'nav">back to nav</a>
	<p><img src="PINOUT_NAME"
		alt="pinout of TOP_ARCH"
		style="width: 100%;"></p>
	<a href="`#'nav">back to nav</a>
</article>
m4_divert(0)m4_dnl
m4_dnl
m4_dnl
m4_dnl
m4_define(`SCHEMA_NAME', m4_patsubst(SCHEMA, `.*/\(.*\)$', `\1'))m4_dnl
m4_divert(1)m4_dnl
<li>Schematic full <a href="`#'SCHEMA_NAME">SCHEMA_NAME</a></li>
m4_divert(2)m4_dnl
<article id="SCHEMA_NAME">
	<h1>Schematic full <em>SCHEMA_NAME</em></h1>
	<a href="`#'nav">back to nav</a>
	<p><img src="SCHEMA_NAME"
		alt="full schematic of TOP_ARCH"
		style="width: 100%;"></p>
	<a href="`#'nav">back to nav</a>
</article>
m4_divert(0)m4_dnl
m4_dnl
m4_dnl
m4_dnl
m4_define(`UCF_NAME', m4_patsubst(UCF, `.*/\(.*\)$', `\1'))m4_dnl
m4_divert(1)m4_dnl
<li>Pin placement (`UCF') <a href="`#'UCF_NAME">UCF_NAME</a></li>
m4_divert(2)m4_dnl
<article id="UCF_NAME">
	<h1>Pin placement (`UCF') <em>UCF_NAME</em></h1>
	<a href="`#'nav">back to nav</a>
	<pre><code class="language-clike">m4_undivert(UCF)</code></pre>
	<a href="`#'nav">back to nav</a>
</article>
m4_divert(0)m4_dnl
m4_dnl
m4_dnl
m4_dnl
m4_ifdef(`VHDL', `LINE(MAP(`PRE_VHDL', VHDL))')m4_dnl
m4_dnl
m4_dnl
m4_dnl
m4_define(`FUSE_LOG_NAME', m4_patsubst(FUSE_LOG, `.*/\(.*\)$', `\1'))m4_dnl
m4_define(`ISIM_LOG_NAME', m4_patsubst(ISIM_LOG, `.*/\(.*\)$', `\1'))m4_dnl
m4_divert(1)m4_dnl
<li>Simulation <a href="`#'sim">log</a>
	<ul>
	<li>Compilation <a href="`#'sim-fuse">FUSE_LOG_NAME</a></li>
	<li>Running     <a href="`#'sim-isim">ISIM_LOG_NAME</a></li>
	</ul>
</li>
m4_divert(2)m4_dnl
<article id="sim">

	<h1 id="sim-fuse">Compilation <em>FUSE_LOG_NAME</em></h1>
	<a href="`#'nav">back to nav</a>
	<pre><code class="language-markdown">m4_undivert(FUSE_LOG)</code></pre>
	<a href="`#'nav">back to nav</a>

	<h1 id="sim-isim">Running     <em>ISIM_LOG_NAME</em></h1>
	<a href="`#'nav">back to nav</a>
	<pre><code class="language-markdown">m4_undivert(ISIM_LOG)</code></pre>
	<a href="`#'nav">back to nav</a>

</article>
m4_divert(0)m4_dnl
m4_dnl
m4_dnl
m4_dnl
m4_define(`XST_LOG_NAME', m4_patsubst(XST_LOG, `.*/\(.*\)$', `\1'))m4_dnl
m4_define(`NGD_LOG_NAME', m4_patsubst(NGD_LOG, `.*/\(.*\)$', `\1'))m4_dnl
m4_define(`MAP_LOG_NAME', m4_patsubst(MAP_LOG, `.*/\(.*\)$', `\1'))m4_dnl
m4_define(`MRP_LOG_NAME', m4_patsubst(MRP_LOG, `.*/\(.*\)$', `\1'))m4_dnl
m4_define(`PAR_LOG_NAME', m4_patsubst(PAR_LOG, `.*/\(.*\)$', `\1'))m4_dnl
m4_define(`BIT_LOG_NAME', m4_patsubst(BIT_LOG, `.*/\(.*\)$', `\1'))m4_dnl
m4_divert(1)m4_dnl
<li>Synthesis <a href="`#'syn">log</a>
	<ul>
	<li>`XST' <a href="`#'syn-xst">XST_LOG_NAME</a></li>
	<li>`NGD' <a href="`#'syn-ngd">NGD_LOG_NAME</a></li>
	<li>`MAP' <a href="`#'syn-map">MAP_LOG_NAME</a></li>
	<li>`MRP' <a href="`#'syn-mrp">MRP_LOG_NAME</a></li>
	<li>`PAR' <a href="`#'syn-par">PAR_LOG_NAME</a></li>
	<li>`BIT' <a href="`#'syn-bit">BIT_LOG_NAME</a></li>
	</ul>
</li>
m4_divert(2)m4_dnl
<article id="syn">

	<h1 id="syn-xst">`XST' <em>XST_LOG_NAME</em></h1>
	<a href="`#'nav">back to nav</a>
	<pre><code class="language-markdown">m4_dnl
m4_changequote(`<', `>')m4_dnl
m4_include(XST_LOG)m4_dnl
m4_changequote(<`>,<'>)</code></pre>
	<a href="`#'nav">back to nav</a>

	<h1 id="syn-ngd">`NGD' <em>NGD_LOG_NAME</em></h1>
	<a href="`#'nav">back to nav</a>
	<pre><code class="language-markdown">m4_dnl
m4_changequote(`<', `>')m4_dnl
m4_include(NGD_LOG)m4_dnl
m4_changequote(<`>,<'>)</code></pre>
	<a href="`#'nav">back to nav</a>

	<h1 id="syn-map">`MAP' <em>MAP_LOG_NAME</em></h1>
	<a href="`#'nav">back to nav</a>
	<pre><code class="language-markdown">m4_dnl
m4_changequote(`<', `>')m4_dnl
m4_undivert(MAP_LOG)m4_dnl
m4_changequote(<`>,<'>)</code></pre>
	<a href="`#'nav">back to nav</a>

	<h1 id="syn-mrp">`MRP' <em>MRP_LOG_NAME</em></h1>
	<a href="`#'nav">back to nav</a>
	<pre><code class="language-markdown">m4_dnl
m4_changequote(`<', `>')m4_dnl
m4_undivert(MRP_LOG)m4_dnl
m4_changequote(<`>,<'>)</code></pre>
	<a href="`#'nav">back to nav</a>

	<h1 id="syn-par">`PAR' <em>PAR_LOG_NAME</em></h1>
	<a href="`#'nav">back to nav</a>
	<pre><code class="language-markdown">m4_dnl
m4_changequote(`<', `>')m4_dnl
m4_include(PAR_LOG)m4_dnl
m4_changequote(<`>,<'>)</code></pre>
	<a href="`#'nav">back to nav</a>

	<h1 id="syn-bit">`BIT' <em>BIT_LOG_NAME</em></h1>
	<a href="`#'nav">back to nav</a>
	<pre><code class="language-markdown">m4_dnl
m4_changequote(`<', `>')m4_dnl
m4_include(BIT_LOG)m4_dnl
m4_changequote(<`>,<'>)</code></pre>
	<a href="`#'nav">back to nav</a>

</article>
m4_divert(0)m4_dnl
m4_dnl
m4_dnl
m4_dnl
<!doctype html>
<html lang="es">

<head>
	<meta charset="utf-8">
	<title>Report of TOP_ARCH</title>
	<link href="prism.css" rel="stylesheet">
	<script src="prism.js"></script>
</head>

<body>

	<header role="banner">
		<h1>Report of TOP_ARCH</h1>
	</header>

	<nav id="nav" role="navigation">
	<ul>
m4_undivert(1)m4_dnl
	</ul>
	</nav>

	<section id="sources">
m4_undivert(2)m4_dnl
	</section>

</body>

</html>
