# Display top 10 processes sorted by memory usage
#
# options to sort:
#   -b  : ignore leading whitespace
#   -k i: sort on ith field
# 
# Sorting on fourth field displays top 10 processes by memory usage
# Sorting on third field displays top 10 processes by CPU usage
#
# Run:
#   sh ps.sh

ps aux | sort -b -k 4 | tail

echo ""
echo ""
echo "Above is a list of top 10 process sorted by memory usage"
