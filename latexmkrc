@default_files = ('main.tex');

# Cleanup mode 
# [2 is for doing aux files cleanup before building, ex]
# [1 is for doing ALL output files cleanup]
# [0 is for not doing cleanup]
# $cleanup_mode = 2;

# Use XeLaTeX to compile. 
# [5 is XeLaTeX]
$pdf_mode = 5;
$xelatex = "xelatex -shell-escape -file-line-error -halt-on-error -interaction=nonstopmode -no-pdf -synctex=1 %O %S";
$xdvipdfmx = "xdvipdfmx -q -E -o %D %O %S";

$clean_ext = "synctex.gz acn acr alg aux bbl bcf blg brf ans fdb_latexmk glg glo gls idx ilg ind lof log lot out run.xml toc pdf thm toe ist idx";

# Preview mode & Auto complie after save. 
# $preview_continuous_mode = 0;

# Set XeLaTeX option.
# $pdflatex = "xelatex -file-line-error -halt-on-error -shell-escape -interaction=nonstopmode -synctex=1 %O %S";

# Process index. [Use Chinese index program]
# $makeindex = 'zhmakeindex %O -o %D %S';

# Preview mode 
# [1 is for running a previewer after building]
# [0 is for not running it]
# $preview_mode = 0;


$show_time=1;

$sleep_time=1;