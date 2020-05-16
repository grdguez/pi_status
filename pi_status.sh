# Gathers system details.
now=$(date +"%H:%M - %b/%d/%Y")
freq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)
volts=$(sudo /opt/vc/bin/vcgencmd measure_volts)
temp=$(sudo /opt/vc/bin/vcgencmd measure_temp)
gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
up=$(uptime -p)

# Prints system uptime
echo "UPTIME"
echo "$up" | sed 's/up/../'
echo " "

# Prints System details
echo "SYSTEM DETAILS"
echo "Date: $now"
echo "$volts" | sed 's/volt=/Voltage:/'
echo "$temp" | sed 's/temp=/Temperature:/'
freq=$((freq/1000))
echo -e "CPU Governor: \e[91m$gov\e[0m"
echo -e "Current speed: \e[96m$freq MHz\e[0m"
echo " "

# Prints free & used RAM
echo "RAM"
free | awk '/Mem/{printf("%.2f MB used\n"), $3/1024}'
free | awk '/Mem/{printf("%.2f MB free\n"), $4/1024}'
echo " "

# Prints disk usage
echo "STORAGE"
df -h | grep -E "root|Filesystem"
echo " "

# Checks system status.
# Requires package dnsutils on linux.
# TODO: Make the script check if the dnsutils package is installed and install it if needed.
echo "DNS STATS"
dig google.com +noall +stats +answer | grep -E "Query|SERVER" | sed 's/;;/../'
echo " "

# Print pihole status.
# Comment or delete the 3 lines below if PiHole is not installed.
echo "PIHOLE STATUS"
pihole status
echo " "
