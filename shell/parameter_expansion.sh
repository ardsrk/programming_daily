# Ways to manage parameters in shell

FILE=/a/text/file.txt

echo "File Path: ${FILE}"

# The PARAMETER%PATTERN matches PATTERN from end of string referenced by PARAMETER
echo "Directory: ${FILE%/*}"

# The PARAMETER##PATTERN matches PATTERN from beginning of string referenced by PARAMETER
echo "Filename : ${FILE##*/}"

echo "Extension: ${FILE##*.}"
