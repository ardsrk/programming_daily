# Find the 10 biggest files / folders in current directory
# 
# References:
#   https://www.commandlinefu.com/commands/view/65/get-the-10-biggest-filesfolders-for-the-current-direcotry
# 
# Options to find:
#   -maxdepth 1 : Returns files and folders in current directory. Does not descend into sub-directories
#   \! -name '.': Excludes '.' from output.
#
# Exercise:
#   Remove the "\! -name '.'" expression and see what difference it makes

du -sh `find . -maxdepth 1 \! -name '.'` | sort -n | tail
