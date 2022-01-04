# Find processor / memory bandwidth in GB/s
#
# References:
#   https://www.commandlinefu.com/commands/view/772/processor-memory-bandwidthd-in-gbs
#   https://en.wikipedia.org/wiki/GNU_Core_Utilities
# 
# Run:
#   sh dd.sh
#

dd if=/dev/zero of=/dev/null bs=1M count=32768
