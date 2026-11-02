% ehsancv: single-column, ATS-friendly CV class for LuaLaTeX. See README.md.
\NeedsTeXFormat{LaTeX2e}[2023-06-01]
\ProvidesExplClass{ehsancv}{2026-11-02}{2.0.0}{Single-column ATS-friendly CV class for LuaLaTeX}

\msg_new:nnn { ehsancv } { engine } { ehsancv~requires~LuaLaTeX.~Compile~with~lualatex. }
\msg_new:nnn { ehsancv } { unknown-key } { Unknown~option~'#1'.~See~README.md~for~the~option~list. }
\msg_new:nnn { ehsancv } { bad-accent } { accent~'#1'~is~neither~a~preset~nor~six~hex~digits. }
\msg_new:nnn { ehsancv } { too-many-pages } { The~CV~has~#1~pages;~maxpages~is~#2. }

\sys_if_engine_luatex:F { \msg_fatal:nn { ehsancv } { engine } }

\LoadClass{article}
\RequirePackage{geometry}
\RequirePackage{fontspec}
\RequirePackage{microtype}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{hyperref}

\lua_now:n { dofile(kpse.find_file("ehsancv.lua")) }

\dim_new:N \l__ecv_photosize_dim
\bool_new:N \l__ecv_photoauto_bool

\keys_define:nn { ehsancv }
  {
    paper .choice: ,
    paper / a4 .code:n = \tl_set:Nn \l__ecv_paper_tl { a4paper } ,
    paper / letter .code:n = \tl_set:Nn \l__ecv_paper_tl { letterpaper } ,
    paper .initial:n = a4 ,
    marginx .dim_set:N = \l__ecv_marginx_dim ,
    marginx .initial:n = 43.5pt ,
    marginy .dim_set:N = \l__ecv_marginy_dim ,
    marginy .initial:n = 37.5pt ,

    font .tl_set:N = \l__ecv_font_tl ,
    font .initial:n = Carlito ,
    fontpath .tl_set:N = \l__ecv_fontpath_tl ,
    fontoptions .tl_set:N = \l__ecv_fontoptions_tl ,
    fontsize .dim_set:N = \l__ecv_fontsize_dim ,
    fontsize .initial:n = 10.5pt ,
    leading .fp_set:N = \l__ecv_leading_fp ,
    leading .initial:n = 1.3 ,

    accent .tl_set:N = \l__ecv_accent_tl ,
    accent .initial:n = blue ,

    density .choice: ,
    density / compact .code:n = \fp_set:Nn \l__ecv_density_fp { 0.75 } ,
    density / normal .code:n = \fp_set:Nn \l__ecv_density_fp { 1 } ,
    density / relaxed .code:n = \fp_set:Nn \l__ecv_density_fp { 1.35 } ,
    density .initial:n = normal ,
    sectiongap .dim_set:N = \l__ecv_sectiongap_dim ,
    sectiongap .initial:n = 10.5pt ,
    entrygap .dim_set:N = \l__ecv_entrygap_dim ,
    entrygap .initial:n = 4.5pt ,
    itemgap .dim_set:N = \l__ecv_itemgap_dim ,
    itemgap .initial:n = 0.75pt ,

    subtitle .bool_set:N = \l__ecv_subtitle_bool ,
    subtitle .initial:n = true ,
    photo .bool_set:N = \l__ecv_photo_bool ,
    photo .initial:n = true ,
    photosize .code:n =
      {
        \str_if_eq:nnTF { #1 } { auto }
          { \bool_set_true:N \l__ecv_photoauto_bool }
          {
            \bool_set_false:N \l__ecv_photoauto_bool
            \dim_set:Nn \l__ecv_photosize_dim { #1 }
          }
      } ,
    photosize .initial:n = auto ,
    photoshape .choice: ,
    photoshape / circle .code:n = \bool_set_true:N \l__ecv_photocircle_bool ,
    photoshape / square .code:n = \bool_set_false:N \l__ecv_photocircle_bool ,
    photoshape .initial:n = circle ,
    photoborder .dim_set:N = \l__ecv_photoborder_dim ,
    photoborder .initial:n = 1.8pt ,
    photobordercolor .tl_set:N = \l__ecv_photobordercolor_tl ,
    photobordercolor .initial:n = cvaccent!60!white ,
    photofocus .fp_set:N = \l__ecv_photofocus_fp ,
    photofocus .initial:n = 0.3 ,

    icons .bool_set:N = \l__ecv_icons_bool ,
    icons .initial:n = true ,
    linkicons .bool_set:N = \l__ecv_linkicons_bool ,
    linkicons .initial:n = true ,
    contactstyle .choice: ,
    contactstyle / grid .code:n = \bool_set_true:N \l__ecv_contactgrid_bool ,
    contactstyle / inline .code:n = \bool_set_false:N \l__ecv_contactgrid_bool ,
    contactstyle .initial:n = grid ,
    contactcolumns .int_set:N = \l__ecv_contactcolumns_int ,
    contactcolumns .initial:n = 4 ,

    dateformat .choices:nn = { short , long , numeric }
      { \tl_set_eq:NN \l__ecv_dateformat_tl \l_keys_choice_tl } ,
    dateformat .initial:n = short ,
    presentlabel .tl_set:N = \l__ecv_presentlabel_tl ,
    presentlabel .initial:n = Present ,

    variant .tl_set:N = \l__ecv_variant_tl ,
    ats .bool_set:N = \l__ecv_ats_bool ,
    ats .initial:n = false ,
    maxpages .int_set:N = \l__ecv_maxpages_int ,
    maxpages .initial:n = 0 ,
    pagenumbers .bool_set:N = \l__ecv_pagenumbers_bool ,
    pagenumbers .initial:n = false ,
    lastupdated .tl_set:N = \l__ecv_lastupdated_tl ,

    pdftitle .tl_set:N = \l__ecv_pdftitle_tl ,
    pdfkeywords .tl_set:N = \l__ecv_pdfkeywords_tl ,
    lang .tl_set:N = \l__ecv_lang_tl ,
    lang .initial:n = en-US ,

    unknown .code:n = \msg_error:nnV { ehsancv } { unknown-key } \l_keys_key_str ,
  }
\ProcessKeyOptions [ ehsancv ]

\keys_define:nn { ehsancv / entry }
  {
    title .tl_set:N = \l__ecv_e_title_tl ,
    org .tl_set:N = \l__ecv_e_org_tl ,
    location .tl_set:N = \l__ecv_e_location_tl ,
    type .tl_set:N = \l__ecv_e_type_tl ,
    from .tl_set:N = \l__ecv_e_from_tl ,
    to .tl_set:N = \l__ecv_e_to_tl ,
    date .tl_set:N = \l__ecv_e_date_tl ,
    right .tl_set:N = \l__ecv_e_right_tl ,
    detail .tl_set:N = \l__ecv_e_detail_tl ,
    detailright .tl_set:N = \l__ecv_e_detailright_tl ,
    only .tl_set:N = \l__ecv_e_only_tl ,
    unknown .code:n = \msg_error:nnV { ehsancv } { unknown-key } \l_keys_key_str ,
  }

\prop_const_from_keyval:Nn \c__ecv_accents_prop
  {
    blue = 0B4F8A , teal = 0F6B5F , green = 1F6B3A , red = A32A2A ,
    purple = 5B3A8C , orange = 9A4A12 , slate = 3D4650 , black = 1B1F24 ,
  }

\dim_new:N \l__ecv_lead_dim
\dim_new:N \l__ecv_text_dim
\fp_new:N \l__ecv_scale_fp
\tl_new:N \l__ecv_name_tl
\tl_new:N \l__ecv_subtitle_tl
\tl_new:N \l__ecv_photo_tl
\tl_new:N \l__ecv_cells_tl
\seq_new:N \l__ecv_contacts_seq
\int_new:N \l__ecv_cell_int
\int_new:N \g__ecv_items_int
\int_new:N \g__ecv_sections_int
\bool_new:N \g__ecv_aftersection_bool
\box_new:N \l__ecv_contact_box
\box_new:N \l__ecv_header_box
\dim_new:N \l__ecv_header_dim
\dim_const:Nn \c__ecv_photomax_dim { 69pt }

\seq_const_from_clist:Nn \c__ecv_months_short_seq
  { Jan , Feb , Mar , Apr , May , Jun , Jul , Aug , Sep , Oct , Nov , Dec }
\seq_const_from_clist:Nn \c__ecv_months_long_seq
  { January , February , March , April , May , June , July , August , September , October , November , December }

\NewDocumentCommand \cvsetup { m } { \keys_set:nn { ehsancv } { #1 } }
\NewDocumentCommand \cvname { m } { \tl_set:Nn \l__ecv_name_tl { #1 } }
\NewDocumentCommand \cvsubtitle { m } { \tl_set:Nn \l__ecv_subtitle_tl { #1 } }
\NewDocumentCommand \cvphoto { m } { \tl_set:Nn \l__ecv_photo_tl { #1 } }

% Settings are applied once here, so keys never depend on the order they are set in.
\cs_new_protected:Npn \__ecv_apply:
  {
    \bool_if:NT \l__ecv_ats_bool
      {
        \bool_set_false:N \l__ecv_icons_bool
        \bool_set_false:N \l__ecv_linkicons_bool
        \bool_set_false:N \l__ecv_photo_bool
        \bool_set_false:N \l__ecv_contactgrid_bool
        \tl_set:Nn \l__ecv_accent_tl { black }
      }
    \__ecv_apply_colours:
    \dim_set:Nn \l__ecv_sectiongap_dim { \fp_to_dim:n { \l__ecv_density_fp * \l__ecv_sectiongap_dim } }
    \dim_set:Nn \l__ecv_entrygap_dim { \fp_to_dim:n { \l__ecv_density_fp * \l__ecv_entrygap_dim } }
    \dim_set:Nn \l__ecv_itemgap_dim { \fp_to_dim:n { \l__ecv_density_fp * \l__ecv_itemgap_dim } }
    \use:x
      {
        \exp_not:N \geometry
          {
            \l__ecv_paper_tl ,
            hmargin = \dim_use:N \l__ecv_marginx_dim ,
            vmargin = \dim_use:N \l__ecv_marginy_dim ,
            footskip = 18pt
          }
      }
    \__ecv_apply_font:
    \dim_set:Nn \l__ecv_lead_dim { \fp_to_dim:n { \l__ecv_leading_fp * \l__ecv_fontsize_dim } }
    \cs_gset_protected:Npx \normalsize
      {
        \exp_not:N \@setfontsize \exp_not:N \normalsize
          { \dim_to_decimal:n { \l__ecv_fontsize_dim } }
          { \dim_to_decimal:n { \l__ecv_lead_dim } }
      }
    \normalsize
    \setlength { \parindent } { 0pt }
    \setlength { \parskip } { 0pt }
    \setlength { \topskip } { \l__ecv_lead_dim }
    \setlength { \emergencystretch } { 1em }
    \tolerance = 1500 \scan_stop:
    \raggedbottom
    \frenchspacing
    \lefthyphenmin = 3 \scan_stop:
    \righthyphenmin = 3 \scan_stop:
    \finalhyphendemerits = 1000000 \scan_stop:
    \pagestyle { ecv }
    \tl_if_empty:NT \l__ecv_pdftitle_tl
      { \tl_set:Nx \l__ecv_pdftitle_tl { \exp_not:V \l__ecv_name_tl \c_space_tl CV } }
    \hypersetup
      {
        colorlinks = true , linkcolor = cvaccent , urlcolor = cvaccent , citecolor = cvaccent ,
        bookmarksopen = true ,
        pdfauthor = \l__ecv_name_tl ,
        pdftitle = \l__ecv_pdftitle_tl ,
        pdfkeywords = \l__ecv_pdfkeywords_tl ,
        pdflang = \l__ecv_lang_tl ,
      }
    \urlstyle { same }
  }

\cs_new_protected:Npn \__ecv_apply_colours:
  {
    \prop_get:NVNF \c__ecv_accents_prop \l__ecv_accent_tl \l_tmpa_tl
      {
        \tl_set_eq:NN \l_tmpa_tl \l__ecv_accent_tl
        \regex_match:nVF { \A [0-9A-Fa-f]{6} \Z } \l_tmpa_tl
          {
            \msg_error:nnV { ehsancv } { bad-accent } \l_tmpa_tl
            \tl_set:Nn \l_tmpa_tl { 0B4F8A }
          }
      }
    \definecolor { cvaccent } { HTML } { \l_tmpa_tl }
    \lua_now:e { ehsancv.check_contrast("\l_tmpa_tl") }
    \colorlet { cvrule } { cvaccent!28!white }
    \regex_match:nVTF { \A [0-9A-Fa-f]{6} \Z } \l__ecv_photobordercolor_tl
      { \definecolor { cvphotoborder } { HTML } { \l__ecv_photobordercolor_tl } }
      { \colorlet { cvphotoborder } { \l__ecv_photobordercolor_tl } }
    \definecolor { cvtext } { HTML } { 1B1F24 }
    \definecolor { cvmuted } { HTML } { 55606B }
    \definecolor { cvcontact } { HTML } { 3D4650 }
  }

\cs_new_protected:Npn \__ecv_apply_font:
  {
    \defaultfontfeatures { Ligatures = TeX }
    \str_if_eq:VnTF \l__ecv_font_tl { Carlito }
      {
        \setmainfont { Carlito }
          [ Extension = .ttf , UprightFont = *-Regular , BoldFont = *-Bold ,
            ItalicFont = *-Italic , BoldItalicFont = *-BoldItalic ]
      }
      {
        \use:x
          {
            \exp_not:N \setmainfont { \exp_not:V \l__ecv_font_tl }
              [
                \tl_if_empty:NF \l__ecv_fontpath_tl { Path = \exp_not:V \l__ecv_fontpath_tl , }
                \exp_not:V \l__ecv_fontoptions_tl
              ]
          }
      }
    \renewcommand { \familydefault } { \rmdefault }
  }

\AddToHook { begindocument / before } { \__ecv_apply: }
\AddToHook { begindocument / end } { \color { cvtext } }
\AddToHook { enddocument / afterlastpage }
  {
    \int_compare:nNnT \l__ecv_maxpages_int > 0
      {
        \int_compare:nNnT \c@page > \l__ecv_maxpages_int
          {
            \msg_warning:nnee { ehsancv } { too-many-pages }
              { \int_use:N \c@page } { \int_use:N \l__ecv_maxpages_int }
          }
      }
  }

\cs_new_protected:cpn { ps@ecv }
  {
    \cs_set:Npn \@oddhead { }
    \cs_set:Npn \@evenhead { }
    \cs_set:Npn \@oddfoot
      {
        \footnotesize \color { cvmuted }
        \l__ecv_lastupdated_tl
        \hfill
        \bool_if:NT \l__ecv_pagenumbers_bool { Page ~ \thepage \c_space_tl of ~ \PreviousTotalPages }
      }
    \cs_set_eq:NN \@evenfoot \@oddfoot
  }

\cs_new_protected:Npn \__ecv_if_visible:nT #1 #2
  {
    \bool_lazy_or:nnTF { \tl_if_empty_p:n { #1 } } { \tl_if_empty_p:N \l__ecv_variant_tl }
      { #2 }
      { \clist_if_in:nVT { #1 } \l__ecv_variant_tl { #2 } }
  }
\cs_generate_variant:Nn \__ecv_if_visible:nT { V }
\NewDocumentCommand \cvonly { m +m } { \__ecv_if_visible:nT { #1 } { #2 } }

% Icons are PDF path operators: no shell escape, no font, and nothing in the text layer.
\NewDocumentCommand \cvdeficon { m m m m }
  { \tl_gset:cn { g__ecv_icon_ #1 _tl } { { #2 } { #3 } { #4 } } }
\ExplSyntaxOff
\input{ehsancv-icons.def}
\ExplSyntaxOn

\cs_new_protected:Npn \__ecv_icon:nnn #1 #2 #3
  { \exp_args:Nnnv \__ecv_icon_unpack:nnn { #1 } { #2 } { g__ecv_icon_ #3 _tl } }
\cs_new_protected:Npn \__ecv_icon_unpack:nnn #1 #2 #3
  { \__ecv_icon_draw:nnnnn { #1 } { #2 } #3 }
\cs_new_protected:Npn \__ecv_icon_draw:nnnnn #1 #2 #3 #4 #5
  {
    \fp_set:Nn \l__ecv_scale_fp
      { min ( \dim_to_decimal_in_bp:n { #1 } / #3 , \dim_to_decimal_in_bp:n { #2 } / #4 ) }
    \hbox_to_wd:nn { #1 }
      {
        \tex_vrule:D height ~ #2 ~ depth ~ 0pt ~ width ~ 0pt \scan_stop:
        \pdfextension literal
          {
            q ~
            \fp_eval:n { \l__ecv_scale_fp } ~ 0 ~ 0 ~ \fp_eval:n { \l__ecv_scale_fp } ~
            \fp_eval:n { ( \dim_to_decimal_in_bp:n { #1 } - \l__ecv_scale_fp * #3 ) / 2 } ~
            \fp_eval:n { ( \dim_to_decimal_in_bp:n { #2 } - \l__ecv_scale_fp * #4 ) / 2 } ~ cm ~
            #5 ~ f ~ Q
          }
        \hss
      }
  }
\cs_new_protected:Npn \__ecv_link_icon:
  {
    \bool_if:NT \l__ecv_linkicons_bool
      {
        \hskip 2.25pt \scan_stop:
        \raisebox { 0.1pt } { \__ecv_icon:nnn { 6.75pt } { 6.75pt } { external-link } }
      }
  }

\NewDocumentCommand \cvlink { m m }
  {
    \bool_if:NTF \l__ecv_ats_bool
      { \textit { #2 } : ~ \url { #1 } }
      { \href { #1 } { \textit { #2 } \__ecv_link_icon: } }
  }

\NewDocumentCommand \cvcontact { m m o }
  {
    \IfNoValueTF { #3 }
      { \seq_put_right:Nn \l__ecv_contacts_seq { { #1 } { #2 } { } } }
      {
        % hyperref detects the URL scheme by the catcode of ":", which is a letter in expl3.
        \tl_set_rescan:Nnn \l_tmpa_tl { \cctab_select:N \c_document_cctab } { #3 }
        \seq_put_right:Nx \l__ecv_contacts_seq
          { { \exp_not:n { #1 } } { \exp_not:n { #2 } } { \exp_not:V \l_tmpa_tl } }
      }
  }
\NewDocumentCommand \cvlocation { m } { \cvcontact { location } { #1 } }
\NewDocumentCommand \cvemail { m } { \cvcontact { email } { #1 } [ mailto : #1 ] }
\NewDocumentCommand \cvphone { m }
  {
    \tl_set:Nn \l_tmpa_tl { #1 }
    \tl_remove_all:Nn \l_tmpa_tl { ~ }
    \exp_args:NnnV \__ecv_phone:nnn { phone } { #1 } \l_tmpa_tl
  }
\cs_new_protected:Npn \__ecv_phone:nnn #1 #2 #3 { \cvcontact { #1 } { #2 } [ tel : #3 ] }
\NewDocumentCommand \cvwebsite { m } { \cvcontact { website } { #1 } [ https://#1/ ] }
\NewDocumentCommand \cvlinkedin { m } { \cvcontact { linkedin } { linkedin.com/in/#1 } [ https://linkedin.com/in/#1 ] }
\NewDocumentCommand \cvgithub { m } { \cvcontact { github } { github.com/#1 } [ https://github.com/#1 ] }
\NewDocumentCommand \cvgitlab { m } { \cvcontact { gitlab } { gitlab.com/#1 } [ https://gitlab.com/#1 ] }
\NewDocumentCommand \cvstackoverflow { m m } { \cvcontact { stackoverflow } { Stack ~ Overflow : ~ #2 } [ https://stackoverflow.com/users/#1 ] }
\NewDocumentCommand \cvorcid { m } { \cvcontact { orcid } { orcid.org/#1 } [ https://orcid.org/#1 ] }
\NewDocumentCommand \cvcodeforces { m } { \cvcontact { codeforces } { Codeforces : ~ #1 } [ https://codeforces.com/profile/#1 ] }
\NewDocumentCommand \cvleetcode { m } { \cvcontact { leetcode } { LeetCode : ~ #1 } [ https://leetcode.com/u/#1 ] }

\cs_new_protected:Npn \__ecv_contact:nnn #1 #2 #3
  {
    \hbox:n
      {
        \tl_if_empty:nTF { #3 }
          { \__ecv_contact_body:nn { #1 } { \textcolor { cvcontact } { #2 } } }
          {
            \hypersetup { urlcolor = cvcontact }
            \href { #3 } { \__ecv_contact_body:nn { #1 } { #2 } }
          }
      }
  }
\cs_new_protected:Npn \__ecv_contact_body:nn #1 #2
  {
    \bool_if:NT \l__ecv_icons_bool
      {
        \tl_if_empty:nF { #1 }
          {
            \cs_if_exist:cT { g__ecv_icon_ #1 _tl }
              {
                \raisebox { -1.3pt }
                  { \textcolor { cvaccent } { \__ecv_icon:nnn { 9.75pt } { 9pt } { #1 } } }
                \hskip 3pt \scan_stop:
              }
          }
      }
    #2
  }
\cs_new_protected:Npn \__ecv_contact_grid:
  {
    \tl_clear:N \l__ecv_cells_tl
    \int_zero:N \l__ecv_cell_int
    \seq_map_inline:Nn \l__ecv_contacts_seq
      {
        \int_compare:nNnT \l__ecv_cell_int > 0
          {
            \int_compare:nNnTF { \int_mod:nn { \l__ecv_cell_int } { \l__ecv_contactcolumns_int } } = 0
              { \tl_put_right:Nn \l__ecv_cells_tl { \tabularnewline } }
              { \tl_put_right:Nn \l__ecv_cells_tl { & } }
          }
        \int_incr:N \l__ecv_cell_int
        \tl_put_right:Nn \l__ecv_cells_tl { \__ecv_contact:nnn ##1 }
      }
    \use:x
      {
        \exp_not:N \begin { tabular }
          { @{} l * { \int_eval:n { \l__ecv_contactcolumns_int - 1 } } { @{ \exp_not:N \hspace{9pt} } l } @{} }
      }
    \l__ecv_cells_tl
    \end { tabular }
  }
\cs_new_protected:Npn \__ecv_contact_inline:
  {
    \int_zero:N \l__ecv_cell_int
    \raggedright
    \mode_leave_vertical:
    \seq_map_inline:Nn \l__ecv_contacts_seq
      {
        \int_compare:nNnT \l__ecv_cell_int > 0
          {
            \bool_if:NTF \l__ecv_icons_bool
              { \hskip 9pt plus 3pt \scan_stop: }
              {
                % The separator vanishes when the line breaks here.
                \tex_discretionary:D { } { }
                  { \hbox:n { \hskip 4pt \scan_stop: \textcolor { cvcontact } { | } \hskip 4pt \scan_stop: } }
              }
          }
        \int_incr:N \l__ecv_cell_int
        \__ecv_contact:nnn ##1
      }
    \par
  }
% Falls back to wrapping when the grid is wider than the space beside the photo.
\cs_new_protected:Npn \__ecv_contacts:
  {
    \fontsize { \fp_eval:n { 0.9643 * \dim_to_decimal:n { \l__ecv_fontsize_dim } } }
      { \fp_eval:n { 1.396 * \dim_to_decimal:n { \l__ecv_fontsize_dim } } } \selectfont
    \bool_if:NTF \l__ecv_contactgrid_bool
      {
        \hbox_set:Nn \l__ecv_contact_box { \__ecv_contact_grid: }
        \dim_compare:nNnTF { \box_wd:N \l__ecv_contact_box } > \l__ecv_text_dim
          { \__ecv_contact_inline: }
          { \noindent \box_use_drop:N \l__ecv_contact_box \par }
      }
      { \__ecv_contact_inline: }
  }

\cs_new_protected:Npn \__ecv_photo:
  {
    \hbox_set:Nn \l_tmpa_box { \includegraphics { \l__ecv_photo_tl } }
    \fp_set:Nn \l__ecv_scale_fp
      { \dim_to_decimal:n { \l__ecv_photosize_dim } / min ( \dim_to_decimal:n { \box_wd:N \l_tmpa_box } , \dim_to_decimal:n { \box_ht:N \l_tmpa_box } ) }
    \dim_set:Nn \l_tmpa_dim { \fp_to_dim:n { \l__ecv_scale_fp * \box_wd:N \l_tmpa_box } }
    \dim_set:Nn \l_tmpb_dim { \fp_to_dim:n { \l__ecv_scale_fp * \box_ht:N \l_tmpa_box } }
    \hbox_to_wd:nn { \l__ecv_photosize_dim }
      {
        \tex_vrule:D height ~ \dim_use:N \l__ecv_photosize_dim ~ depth ~ 0pt ~ width ~ 0pt \scan_stop:
        \pdfextension literal { q ~ \__ecv_photo_path:n { \l__ecv_photosize_dim } \c_space_tl W ~ n }
        \hbox_overlap_right:n
          {
            \skip_horizontal:n { ( \l__ecv_photosize_dim - \l_tmpa_dim ) / 2 }
            \box_move_down:nn
              { \fp_to_dim:n { ( \l_tmpb_dim - \l__ecv_photosize_dim ) * ( 1 - \l__ecv_photofocus_fp ) } }
              { \hbox:n { \includegraphics [ width = \l_tmpa_dim , height = \l_tmpb_dim ] { \l__ecv_photo_tl } } }
          }
        \pdfextension literal { Q }
        \dim_compare:nNnT \l__ecv_photoborder_dim > { 0pt }
          {
            \group_begin:
              \color { cvphotoborder }
              \pdfextension literal
                {
                  q ~ 1 ~ 0 ~ 0 ~ 1 ~
                  \dim_to_decimal_in_bp:n { \l__ecv_photoborder_dim / 2 } ~
                  \dim_to_decimal_in_bp:n { \l__ecv_photoborder_dim / 2 } ~ cm ~
                  \dim_to_decimal_in_bp:n { \l__ecv_photoborder_dim } ~ w ~
                  \__ecv_photo_path:n { \l__ecv_photosize_dim - \l__ecv_photoborder_dim } \c_space_tl S ~ Q
                }
            \group_end:
          }
        \hss
      }
  }
\cs_new:Npn \__ecv_photo_path:n #1
  {
    \bool_if:NTF \l__ecv_photocircle_bool
      { \exp_args:Ne \__ecv_circle_path:n { \dim_to_decimal_in_bp:n { ( #1 ) / 2 } } }
      { 0 ~ 0 ~ \dim_to_decimal_in_bp:n { #1 } ~ \dim_to_decimal_in_bp:n { #1 } ~ re }
  }
\cs_new:Npn \__ecv_circle_path:n #1
  {
    \exp_args:Ne \__ecv_circle_path:nn { #1 } { \fp_eval:n { #1 * 0.5523 } }
  }
\cs_new:Npn \__ecv_circle_path:nn #1 #2
  {
    \fp_eval:n { 2 * #1 } ~ #1 ~ m ~
    \fp_eval:n { 2 * #1 } ~ \fp_eval:n { #1 + #2 } ~ \fp_eval:n { #1 + #2 } ~ \fp_eval:n { 2 * #1 } ~ #1 ~ \fp_eval:n { 2 * #1 } ~ c ~
    \fp_eval:n { #1 - #2 } ~ \fp_eval:n { 2 * #1 } ~ 0 ~ \fp_eval:n { #1 + #2 } ~ 0 ~ #1 ~ c ~
    0 ~ \fp_eval:n { #1 - #2 } ~ \fp_eval:n { #1 - #2 } ~ 0 ~ #1 ~ 0 ~ c ~
    \fp_eval:n { #1 + #2 } ~ 0 ~ \fp_eval:n { 2 * #1 } ~ \fp_eval:n { #1 - #2 } ~ \fp_eval:n { 2 * #1 } ~ #1 ~ c ~ h
  }

% Header. Each part adds its gap only when it is printed, so a hidden part leaves no space.
\cs_new_protected:Npn \__ecv_photo_if_shown:T #1
  {
    \bool_lazy_and:nnT { \l__ecv_photo_bool } { ! \tl_if_empty_p:N \l__ecv_photo_tl } { #1 }
  }
\NewDocumentCommand \makecvheader { }
  {
    \par
    \dim_set_eq:NN \l__ecv_text_dim \linewidth
    \__ecv_photo_if_shown:T
      {
        \bool_if:NT \l__ecv_photoauto_bool
          { \dim_set_eq:NN \l__ecv_photosize_dim \c__ecv_photomax_dim }
        \dim_sub:Nn \l__ecv_text_dim { \l__ecv_photosize_dim + 9pt }
      }
    \vbox_set:Nn \l__ecv_header_box
      {
        \hsize = \l__ecv_text_dim
        \linewidth = \l__ecv_text_dim
        \__ecv_header_text:
      }
    \dim_set:Nn \l__ecv_header_dim { \box_ht:N \l__ecv_header_box + \box_dp:N \l__ecv_header_box }
    \__ecv_photo_if_shown:T
      {
        \bool_if:NT \l__ecv_photoauto_bool
          {
            \dim_set:Nn \l__ecv_photosize_dim
              { \dim_min:nn { \l__ecv_header_dim } { \c__ecv_photomax_dim } }
          }
        \dim_set:Nn \l__ecv_header_dim { \dim_max:nn { \l__ecv_header_dim } { \l__ecv_photosize_dim } }
      }
    % Full height on the box and no depth, so \topskip adds nothing above it.
    \hbox_to_wd:nn { \linewidth }
      {
        \vbox_to_ht:nn { \l__ecv_header_dim } { \box_use_drop:N \l__ecv_header_box \vfil }
        \hfil
        \__ecv_photo_if_shown:T
          { \vbox_to_ht:nn { \l__ecv_header_dim } { \hbox:n { \__ecv_photo: } \vfil } }
      }
    \nointerlineskip
    \bool_gset_false:N \g__ecv_aftersection_bool
  }
\cs_new_protected:Npn \__ecv_header_text:
  {
    \noindent
    \group_begin:
      \fontsize { 28.5 } { 28.5 } \selectfont \bfseries \l__ecv_name_tl \par
    \group_end:
    \bool_lazy_and:nnTF { \l__ecv_subtitle_bool } { ! \tl_if_empty_p:N \l__ecv_subtitle_tl }
      {
        \skip_vertical:n { 2.5pt }
        \group_begin:
          \noindent
          \fontsize { 12.75 } { 16 } \selectfont \bfseries \color { cvaccent } \l__ecv_subtitle_tl \par
        \group_end:
        \skip_vertical:n { 3pt }
      }
      { \skip_vertical:n { 6.75pt } }
    \seq_if_empty:NF \l__ecv_contacts_seq { \__ecv_contacts: }
  }

% Replaces \section: titlesec is only partly compatible with PDF tagging.
\RenewDocumentCommand \section { s O{} m }
  { \__ecv_if_visible:nT { #2 } { \__ecv_section:n { #3 } } }
\cs_new_protected:Npn \__ecv_section:n #1
  {
    \par
    \addvspace { \l__ecv_sectiongap_dim }
    \int_gincr:N \g__ecv_sections_int
    \pdfbookmark [ 0 ] { #1 } { ecv.section. \int_use:N \g__ecv_sections_int }
    \vbox
      {
        \noindent
        \group_begin:
          \fontsize { \fp_eval:n { 1.0357 * \dim_to_decimal:n { \l__ecv_fontsize_dim } } }
            { \dim_to_decimal:n { \l__ecv_lead_dim } } \selectfont
          \bfseries \color { cvaccent } #1 \par
        \group_end:
        \nointerlineskip
        \skip_vertical:n { 3.5pt }
        \noindent \textcolor { cvrule } { \rule { \linewidth } { 0.75pt } }
      }
    \nobreak
    \tex_prevdepth:D = 0pt \scan_stop:
    \bool_gset_true:N \g__ecv_aftersection_bool
    \int_gzero:N \g__ecv_items_int
  }

% The right-hand text stays on the title line when it fits and wraps right-aligned
% when it does not; a table would split the title from its date in the extracted text.
\cs_new_protected:Npn \__ecv_row:nn #1 #2
  {
    \noindent #1
    \tl_if_blank:nTF { #2 }
      { \par }
      {
        \unskip \nobreak \hfill \penalty 50 \hskip 1em \null \nobreak \hfill
        \mbox { #2 }
        { \parfillskip = 0pt \finalhyphendemerits = 0 \scan_stop: \par }
      }
  }
\cs_new:Npn \__ecv_date:n #1
  {
    \str_if_eq:nnTF { #1 } { present }
      { \l__ecv_presentlabel_tl }
      {
        \regex_match:nnTF { \A \d{4} - \d{2} \Z } { #1 }
          { \__ecv_date_ym:w #1 \q_stop }
          { #1 }
      }
  }
\cs_new:Npn \__ecv_date_ym:w #1 - #2 \q_stop
  {
    \str_case:Vn \l__ecv_dateformat_tl
      {
        { short } { \seq_item:Nn \c__ecv_months_short_seq { \int_eval:n { #2 } } ~ #1 }
        { long } { \seq_item:Nn \c__ecv_months_long_seq { \int_eval:n { #2 } } ~ #1 }
        { numeric } { #2 / #1 }
      }
  }
\cs_generate_variant:Nn \__ecv_date:n { V }
\cs_new_protected:Npn \__ecv_entry_right:
  {
    \tl_if_empty:NTF \l__ecv_e_right_tl
      {
        \tl_if_empty:NTF \l__ecv_e_date_tl
          {
            \tl_if_empty:NF \l__ecv_e_from_tl
              {
                \__ecv_date:V \l__ecv_e_from_tl
                \tl_if_empty:NF \l__ecv_e_to_tl { ~ – ~ \__ecv_date:V \l__ecv_e_to_tl }
              }
          }
          { \l__ecv_e_date_tl }
      }
      { \l__ecv_e_right_tl }
  }
\cs_new_protected:Npn \__ecv_entry_head:
  {
    \par
    \bool_if:NF \g__ecv_aftersection_bool { \addvspace { \l__ecv_entrygap_dim } }
    \bool_gset_false:N \g__ecv_aftersection_bool
    \int_gzero:N \g__ecv_items_int
    \hbox_set:Nn \l_tmpa_box { \__ecv_entry_right: }
    \__ecv_row:nn
      {
        \textbf { \l__ecv_e_title_tl }
        \tl_if_empty:NF \l__ecv_e_org_tl { , ~ \l__ecv_e_org_tl }
      }
      { \dim_compare:nNnT { \box_wd:N \l_tmpa_box } > { 0pt } { \__ecv_entry_right: } }
    \tl_set:Nx \l_tmpa_tl
      {
        \exp_not:V \l__ecv_e_location_tl
        \bool_lazy_and:nnT
          { ! \tl_if_empty_p:N \l__ecv_e_location_tl }
          { ! \tl_if_empty_p:N \l__ecv_e_type_tl }
          { \c_space_tl · \c_space_tl }
        \exp_not:V \l__ecv_e_type_tl
        \exp_not:V \l__ecv_e_detail_tl
      }
    \bool_lazy_and:nnF
      { \tl_if_empty_p:N \l_tmpa_tl }
      { \tl_if_empty_p:N \l__ecv_e_detailright_tl }
      {
        \nobreak
        \exp_args:Nee \__ecv_row:nn
          { \exp_not:n { \textcolor { cvmuted } } { \exp_not:V \l_tmpa_tl } }
          {
            \tl_if_empty:NF \l__ecv_e_detailright_tl
              { \exp_not:n { \textcolor { cvmuted } } { \exp_not:V \l__ecv_e_detailright_tl } }
          }
      }
    \nobreak
  }
\cs_new_protected:Npn \__ecv_entry_clear:
  {
    \clist_map_inline:nn { title , org , location , type , from , to , date , right , detail , detailright , only }
      { \tl_clear:c { l__ecv_e_ ##1 _tl } }
  }
\NewDocumentEnvironment { cventry } { O{} +b }
  {
    \__ecv_entry_clear:
    \keys_set:nn { ehsancv / entry } { #1 }
    \__ecv_if_visible:VT \l__ecv_e_only_tl { \__ecv_entry_head: #2 \par }
  }
  { }

% A heading always keeps its first two bullets on the same page.
\keys_define:nn { ehsancv / item }
  {
    only .tl_set:N = \l__ecv_i_only_tl ,
    unknown .code:n = \msg_error:nnV { ehsancv } { unknown-key } \l_keys_key_str ,
  }
\cs_new_protected:Npn \__ecv_item:nnn #1 #2 #3
  {
    \par
    \group_begin:
      \tl_clear:N \l__ecv_i_only_tl
      \keys_set:nn { ehsancv / item } { #2 }
      \__ecv_if_visible:VT \l__ecv_i_only_tl
        {
          \bool_gset_false:N \g__ecv_aftersection_bool
          \int_compare:nNnT \g__ecv_items_int < 2 { \nobreak }
          \skip_vertical:N \l__ecv_itemgap_dim
          \int_compare:nNnT \g__ecv_items_int < 2
            {
              \nobreak
              \interlinepenalty = 10000 \scan_stop:
            }
          \int_gincr:N \g__ecv_items_int
          \hangindent = \dim_eval:n { #1 + 10.5pt } \scan_stop:
          \hangafter = 1 \scan_stop:
          \noindent
          \hbox_to_wd:nn { \dim_eval:n { #1 + 10.5pt } }
            {
              \skip_horizontal:n { #1 + 1.6pt }
              \textcolor { cvaccent } { \small \char "2022 \scan_stop: }
              \hss
            }
          \ignorespaces #3 \par
        }
    \group_end:
  }
\NewDocumentCommand \cvitem { O{} +m } { \__ecv_item:nnn { 0pt } { #1 } { #2 } }
\NewDocumentCommand \cvsubitem { O{} +m } { \__ecv_item:nnn { 10.5pt } { #1 } { #2 } }

\NewDocumentCommand \cvskill { m +m } { \par \noindent \textbf { #1 : } ~ #2 \par }
\NewDocumentCommand \cvnote { +m }
  { \par \addvspace { \l__ecv_entrygap_dim } \noindent #1 \par }
