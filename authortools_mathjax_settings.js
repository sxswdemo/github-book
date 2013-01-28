/**
 * Used to initialize the MathJax settings for this application.
 *
 * Author: Philip Schatz, Ross Reedstrom
 * Copyright (c) 2012 Rice University
 *
 * This software is subject to the provisions of the GNU Lesser General
 * Public License Version 2.1 (LGPL).  See LICENSE.txt for details.
 */
if (window.MathJax && window.MathJax.Hub) {

  MathJax.Hub.Config({
    jax: ["input/MathML", "input/TeX", "input/AsciiMath", "output/NativeMML", "output/HTML-CSS"],
    extensions: ["asciimath2jax.js", "tex2jax.js","mml2jax.js","MathMenu.js","MathZoom.js"],
    tex2jax: { inlineMath: [["[TEX_START]","[TEX_END]"], ["\\(", "\\)"]] },
    // Apparently we can't change the escape sequence for ASCIIMath (MathJax doesn't find it)
    // asciimath2jax: { inlineMath: [["[ASCIIMATH_START]", "[ASCIIMATH_END]"]], },

    // The default for Firefox is "HTML" for some reason so change it to MML
    MMLorHTML: {prefer:{MSIE:"MML",Firefox:"MML",Opera:"HTML",Chrome:"HTML",Safari:"HTML",other:"HTML"}},
    TeX: {
      extensions: ["AMSmath.js","AMSsymbols.js","noErrors.js","noUndefined.js"], noErrors: { disabled: true }
    },
    AsciiMath: { noErrors: { disabled: true } }
        });

} else if (console) {
  console.error('MathJax did not load for some reason.');
}
