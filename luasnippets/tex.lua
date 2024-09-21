local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local parse = ls.parser.parse_snippet

return {
  -- Inline math node
  s({ trig = "im", name = "Inline Math", wordTrig = true }, { t "\\(", i(1), t "\\)" }),
  -- Display Math node
  s(
    { trig = "dm", name = "Display Math", wordTrig = true },
    { t "\\[", i(1), t ".\\]" }
  ),
  -- Left/right delimiters
  s(
    { trig = "lr", name = "left right" },
    { t "\\left", i(1), t " ", i(0), t " ", t "\\right", i(2) }
  ),
  s({ trig = "lr(", name = "left( right)" }, { t "\\left( ", i(0), t " \\right)" }),
  s({ trig = "lr[", name = "left[ right]" }, { t "\\left[ ", i(0), t " \\right]" }),
  s({ trig = "lr|", name = "left| right|" }, { t "\\left| ", i(0), t " \\right|" }),
  s({ trig = "lr{", name = "left{ right}" }, { t "\\left\\{ ", i(0), t " \\right\\}" }),
  s({ trig = "lra", name = "langle rangle" }, { t "\\langle ", i(0), t " \\rangle" }),
  -- Emphasis
  s({ trig = "emp", name = "emphasis" }, { t "\\emph{", i(0), t "}" }),

  -- Frame
  parse(
    { trig = "frame", wordTrig = true },
    table.concat({
      "\\begin{frame}[${1:tc}]",
      "\\frametitle{${2:title}}",
      "\\framesubtitle{${3:subtitle}}",
      "$0",
      "\\end{frame}",
    }, "\n")
  ),

  parse(
    { trig = "aln", wordTrig = true },
    table.concat({
      "\\begin{align${1:*}}",
      "$0",
      "\\end{align$1}",
    }, "\n")
  ),
  parse(
    { trig = "preamble", name = "Anand's preamble" },
    [[
\documentclass{article}

\usepackage[utf8]{inputenc}

% numbers option provides compact numerical references in the text. 
% \usepackage[numbers]{natbib}

\usepackage{microtype}
% Nice images, figures
\usepackage{graphicx}
\usepackage{epstopdf}
\graphicspath{{figures/}}
\DeclareGraphicsExtensions{.eps,.pdf,.jpeg,.png}

% Nice tables and floats
\usepackage{float}
\usepackage{tabularx}
\usepackage{booktabs}
\usepackage[caption=false]{subfig}
% \usepackage{floatflt} % Put figures aside a text
\usepackage{array}
\usepackage{multirow}
\newcolumntype{L}{>{$}l<{$}} % math-mode version of "l" column type
  \newcolumntype{R}{>{$}r<{$}} % math-mode version of "r" column type
\newcolumntype{C}{>{$}c<{$}} % math-mode version of "r" column type
\newcolumntype{P}[1]{>{\centering\arraybackslash}p{#1}}
% Nice lists
\let\labelindent\relax
\usepackage[inline]{enumitem}
% Colors
\usepackage{xcolor}

% Algorithms
\usepackage[ruled, lined, linesnumbered, commentsnumbered, longend]{algorithm2e}

% Notational helpers
\usepackage{notation}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For the draft
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\usepackage{ifdraft}
\usepackage{comment}
\usepackage[obeyFinal]{todonotes}

\newenvironment{todocomment}[1][]{% start
  \par\textcolor{red}{\bfseries To-Do\ifblank{#1}{}{ (#1)}:} \color{red}\ignorespaces%
}{% end
  \par
}

\ifoptionfinal{%
  \excludecomment{todocomment}
}{%
  \usepackage[columnwise,switch]{lineno}
  \linenumbers

  \newcommand\todotext[1]{\textcolor{red}{To-Do: #1}}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main document
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ]]
  ),
}
