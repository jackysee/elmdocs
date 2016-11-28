# elm-html-to-unicode
This library allows to escape html string and unescape named and numeric
character references (e.g. &gt;, &#62;, &x3e;) to the corresponding unicode
characters

## escape

Escapes a string converting characters that could be used to inject XSS
vectors (http://wonko.com/post/html-escaping). At the moment we escape &, <, >,
", ', `, , !, @, $, %, (, ), =, +, {, }, [ and ]

for example

    escape "&<>\"" == "&amp;&lt;&gt;&quot;"

This could be useful to treat safely user input before sending it outside of ELM

## unescape

Unescapes a string, converting all named and numeric character references
(e.g. &gt;, &#62;, &x3e;) to their corresponding unicode characters.

for example

    unescape "&quot;&amp;&lt;&gt;" == "\"&<>"

Since the virtual DOM displays a string exactly how it receives it, this
function could be useful if a string with escaped characters is received from
the outside and needs to be displayed correctly