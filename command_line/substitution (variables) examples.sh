echo; \
file="$HOME/.secrets/007"
echo 'file="$HOME/.secrets/007"'
echo; \
echo '$file'
echo "$file"
echo; \
echo 'File location: $file'; \
echo "File location: $file"; \
echo; \
echo 'Filename: ${file#*/}'; \
echo 'note the followings result is missing the first character'
echo "Filename: ${file#*/}"; \
echo; \
echo 'Filename: ${file##*/}'; \
echo "Filename: ${file##*/}"; \
echo; \
echo 'Directory of file: ${file%/*}'; \
echo "Directory of file: ${file%/*}"; \
echo; \
echo 'Non-secret file: ${file/secrets/not_secret}'; \
echo "Non-secret file: ${file/secrets/not_secret}"; \
echo; \
echo 'Other file location: ${other:-There is no other file}'; \
echo "Other file location: ${other:-There is no other file}"; \
echo; \
echo 'Using file if there is no other file: ${other:=$file}'; \
echo "Using file if there is no other file: ${other:=$file}"; \
echo; \
echo 'Other filename: ${other##*/}'; \
echo "Other filename: ${other##*/}"; \
echo; \
echo 'Other file location length: ${#other}'
echo "Other file location length: ${#other}"


$ version=1.5.9; echo "MAJOR: ${version%%.*}, MINOR: ${version#*.}." #=> MAJOR: 1, MINOR: 5.9.
$ echo "Dash: ${version/./-}, Dashes: ${version//./-}." #=> Dash: 1-5.9, Dashes: 1-5-9.

echo 'You cannot use multiple PEs together. If you need to execute multiple PEs on a parameter, you will need to use multiple statements:'
$ file=$HOME/image.jpg; file=${file##*/}; echo "${file%.*}" #=> image
