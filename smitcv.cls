\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{smitcv}[2020/07/15 smitcv , class for a fresher resume.]

\newif\if@academicons
\DeclareOption{academicons}{\@academiconstrue}
%% Choice of round/square photo
\newif\if@normalphoto
\DeclareOption{normalphoto}{\@normalphototrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}
\newif\if@raggedtwoe
\DeclareOption{ragged2e}{\@raggedtwoetrue}
\newif\if@withhyper
\DeclareOption{withhyper}{\@withhypertrue}
\ProcessOptions\relax

\LoadClass{article}
%% file more 'friendly' with copy-paste etc
\RequirePackage[a-1b]{pdfx}
\RequirePackage[margin=2cm]{geometry}
\RequirePackage[fixed]{fontawesome5}
\RequirePackage{ifxetex,ifluatex}
\RequirePackage{scrlfile}
\RequirePackage{xparse}

\newif\ifxetexorluatex
\ifxetex
  \xetexorluatextrue
\else
  \ifluatex
    \xetexorluatextrue
  \else
    \xetexorluatexfalse
  \fi
\fi

\ifxetexorluatex
  \RequirePackage{fontspec}
\else
  %% copy-paste as normal characters
  \RequirePackage{cmap}
  \RequirePackage[utf8]{inputenc}
  \RequirePackage[T1]{fontenc}
  \input{glyphtounicode}
  \pdfglyphtounicode{f_f}{FB00}
  \pdfglyphtounicode{f_f_i}{FB03}
  \pdfglyphtounicode{f_f_l}{FB04}
  \pdfglyphtounicode{f_i}{FB01}
  \pdfgentounicode=1
\fi


\if@academicons
  \ifxetexorluatex
    \RequirePackage{fontspec}

    \@ifl@t@r\fmtversion{2018/04/01}{%
      \RequirePackage{academicons}
    }{
      \@ifl@t@r\fmtversion{2017/04/01}{%
        \@ifpackagelater{academicons}{2018/03/01}{%
          \RequirePackage{academicons}
        }{
          \let\ori@newfontfamily\newfontfamily%
          \renewcommand{\newfontfamily}[2]{}
          \RequirePackage{academicons}
          \let\newfontfamily\ori@newfontfamily
          \newfontfamily{\AI}{academicons.ttf}
        }
      }{
          \let\ori@newfontfamily\newfontfamily%
          \renewcommand{\newfontfamily}[2]{}
          \RequirePackage{academicons}
          \let\newfontfamily\ori@newfontfamily
          \newfontfamily{\AI}{academicons.ttf}
      }
    }
  \else
    \ClassError{smitcv}{academicons unsupported by latex or pdflatex. Please compile with xelatex or lualatex}{Please compile with xelatex or lualatex to use the academicons option}
  \fi
\fi

\if@raggedtwoe
  \RequirePackage[newcommands]{ragged2e}
\fi

\if@withhyper
  \AtBeginDocument{
    \RequirePackage{hyperref}
    \hypersetup{hidelinks}
    \urlstyle{same}
  }
\fi

\RequirePackage{xcolor}

\colorlet{accent}{blue!70!black}
\colorlet{emphasis}{black}
\colorlet{heading}{black}
\colorlet{headingrule}{black}
\colorlet{subheading}{emphasis}
\colorlet{body}{black!80!white}
\colorlet{name}{heading}
\colorlet{tagline}{accent}
\newcommand{\itemmarker}{{\small\textbullet}}
\newcommand{\ratingmarker}{\faCircle}

\RequirePackage{tikz}
\usetikzlibrary{arrows}
\RequirePackage[skins]{tcolorbox}
\RequirePackage[inline]{enumitem}
\setlist{leftmargin=*,labelsep=0.5em,nosep,itemsep=0.25\baselineskip,after=\vspace{0.25\baselineskip}}
\setlist[itemize]{label=\itemmarker}
\RequirePackage{graphicx}
\RequirePackage{etoolbox}
\RequirePackage{dashrule}
\RequirePackage{multirow,tabularx}
\RequirePackage{changepage}
% \RequirePackage{marginfix}

\setlength{\parindent}{0pt}
\newcommand{\divider}{\textcolor{body!30}{\hdashrule{\linewidth}{0.6pt}{0.5ex}}\medskip}

\newenvironment{fullwidth}{%
  \begin{adjustwidth}{}{\dimexpr-\marginparwidth-\marginparsep\relax}}
  {\end{adjustwidth}}

\newcommand{\utffriendlydetokenize}[1]{%
\scantokens{%
  \catcode`\_=12%
%   \catcode`\^=12%
%   \catcode`\{=12%
%   \catcode`\}=12%
  \catcode`\&=12%
  \catcode`\$=12%
  \catcode`\#=12%
  \catcode`\~=12%
%   \catcode`\\=12%
  {#1}%
}%
}

\ExplSyntaxOn
\NewDocumentCommand{\printinfo}{m m o}{%
  \IfNoValueTF{#3}{%
    \mbox{\textcolor{accent}{\normalfont #1}~\utffriendlydetokenize{#2}\hspace{2em}}%
  }{%
     \if@withhyper%
      \mbox{\textcolor{accent}{\normalfont #1}~
      \href{#3}{\utffriendlydetokenize{#2}}\hspace{2em}}
     \else%
       \ClassWarning{Please specify [withhyper] option to enable hyperlinks. Printing out full hyperlink prefix #1 for now.}%
      \mbox{\textcolor{accent}{\normalfont #1}~{\utffriendlydetokenize{#3#2}}\hspace{2em}}%
     \fi%
  }%
}%

%% v1.3: Exploring convenient creation of fields
\NewDocumentCommand{\NewInfoField}{m m o}{%
  \IfNoValueF{#3}{\csdef{#1 hyperprefix}{#3}}%
  \csdef{#1 symbol}{#2}%
  \csdef{#1}##1{%
    \if@withhyper
      \IfNoValueTF {#3}
        {\printinfo{\csuse{#1 symbol}}{##1}}%
        {\printinfo{\csuse{#1 symbol}}{##1}[\csuse{#1 hyperprefix}##1]}%
    \else
      \printinfo{\csuse{#1 symbol}}{##1}%
    \fi%
  }
}
\ExplSyntaxOff

\newcommand{\name}[1]{\def\@name{#1}}
\newcommand{\tagline}[1]{\def\@tagline{#1}}
\newcommand{\personalinfo}[1]{\def\@personalinfo{#1}}
\NewInfoField{email}{\faAt}[mailto:]
\NewInfoField{mailaddress}{\faEnvelope}
\NewInfoField{phone}{\faPhone}
\NewInfoField{homepage}{\faGlobe}[https://]
\NewInfoField{twitter}{\faTwitter}[https://twitter.com/]
\NewInfoField{linkedin}{\faLinkedin}[https://linkedin.com/in/]
\NewInfoField{github}{\faGithub}[https://github.com/]
\NewInfoField{quora}{\faQuora}[https://quora.com/]
\NewInfoField{orcid}{\aiOrcid}[https://orcid.com/]
\NewInfoField{location}{\faMapMarker*}

% Support for multiple photos
\newlength{\smitcv@photos@width}
\newlength{\smitcv@photo@diam@left}
\newlength{\smitcv@photo@diam@right}
\def\smitcv@left@photos{}
\def\smitcv@right@photos{}

\newcommand{\@makeaphoto}[2]{%
  \begin{minipage}{#1}%
    \if@normalphoto
      \includegraphics[width=\linewidth]{#2}
    \else
      \tikz\path[fill overzoom image={#2}]circle[radius=0.5\linewidth];
    \fi%
  \end{minipage}%
}

\newcommand{\smitcv@add@photo@left}[1]{%
  \appto{\smitcv@left@photos}{%
    \@makeaphoto{\smitcv@photo@diam@left}{#1}\hspace{1ex}%
  }%
  \addtolength{\smitcv@photos@width}{\smitcv@photo@diam@left}%
  \addtolength{\smitcv@photos@width}{1ex}%
}
\newcommand{\smitcv@add@photo@right}[1]{%
  \appto{\smitcv@right@photos}{%
    \@makeaphoto{\smitcv@photo@diam@right}{#1}\hspace{1ex}%
  }%
  \addtolength{\smitcv@photos@width}{\smitcv@photo@diam@right}%
  \addtolength{\smitcv@photos@width}{1ex}%
}
\newcommand{\photoL}[2]{%
  \setlength{\smitcv@photo@diam@left}{#1}%
  \forcsvlist{\smitcv@add@photo@left}{#2}%
}
\newcommand{\photoR}[2]{%
  \setlength{\smitcv@photo@diam@right}{#1}%
  \forcsvlist{\smitcv@add@photo@right}{#2}%
}
\let\photo\photoR

\newcommand{\namefont}{\Huge}
\newcommand{\taglinefont}{\large}
\newcommand{\personalinfofont}{\small}
\newcommand{\cvsectionfont}{\LARGE\bfseries}
\newcommand{\cvsubsectionfont}{\large\bfseries}

\newcommand{\makecvheader}{%
  \begingroup
    \smitcv@left@photos\hfill%
    \begin{minipage}{\dimexpr\linewidth-\smitcv@photos@width}%
    \raggedright%
    {\namefont\color{name}\MakeUppercase{\@name}\par}
    \medskip
    {\taglinefont\color{tagline}\@tagline\par}
    \medskip
    {\personalinfofont\@personalinfo\par}
    \end{minipage}\hfill%
    \smitcv@right@photos\par%
  \endgroup\medskip
}

\renewenvironment{quote}{\color{accent}\itshape\large}{\par}

\newcommand{\cvsection}[2][]{%
  \bigskip%
  \ifstrequal{#1}{}{}{\marginpar{\vspace*{\dimexpr1pt-\baselineskip}\raggedright\input{#1}}}%
  {\color{heading}\cvsectionfont\MakeUppercase{#2}}\\[-1ex]%
  {\color{headingrule}\rule{\linewidth}{1pt}\par}\medskip
}

\newcommand{\cvsubsection}[1]{%
  \smallskip%
  {\color{subheading}\cvsubsectionfont{#1}\par}\medskip
}

\newcommand{\cvevent}[4]{%
  {\large\bfseries\color{emphasis}#1}
  \hfill
  \ifstrequal{#2}{}{}{
  \textbf{\color{accent}| #2}\par
  \smallskip}
  \ifstrequal{#3}{}{}{{\small\makebox[0.5\linewidth][l]{\textcolor{accent}{\faCalendar}~#3}}}%
  \ifstrequal{#4}{}{}{{\small\makebox[0.5\linewidth][l]{\textcolor{accent}{\faMapMarker*}~#4}}}\par
  \medskip\normalsize
}

\newcommand{\cvedu}[3]{%
  {\large\bfseries\color{emphasis}#1\par}
  \smallskip\normalsize
  \ifstrequal{#2}{}{}{{\small\makebox[0.5\linewidth][l]{\textcolor{accent}{\faCalendar}~#2}}}%
  \ifstrequal{#3}{}{}{{\small\makebox[0.5\linewidth][l]{\textcolor{accent}{\faGraduationCap}~#3}}}\par
  \medskip\normalsize
}

\newcommand{\cvproject}[2]{%
  {\large\bfseries\color{emphasis}#1}
  \ifstrequal{#2}{}{}{
  \hfill
  \textbf{\color{accent}#2}\par
  \medskip}

  \normalsize
}

\newcommand{\cvtag}[1]{%
  \tikz[baseline]\node[anchor=base,draw=body!30,rounded corners,inner xsep=1ex,inner ysep =0.75ex,text height=1.5ex,text depth=.25ex]{#1};
}

\newcommand{\cvskill}[2]{%
\textcolor{emphasis}{\textbf{#1}}\hfill
\foreach \x in {1,...,5}{%
  \space{\ifnumgreater{\x}{#2}{\color{body!30}}{\color{accent}}\ratingmarker}}\par%
}

\AtBeginDocument{%
  \pagestyle{empty}
  \color{body}
  \raggedright
}
