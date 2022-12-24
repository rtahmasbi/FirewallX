
# https://github.com/zertrin/iptables-persistent

cat > /etc/init.d/iptables-persistent << "EOF"
#!/bin/sh
### BEGIN INIT INFO
# Provides:          iptables-persistent
# Required-Start:    mountkernfs $local_fs
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# X-Start-Before:    $network
# X-Stop-After:      $network
# Short-Description: Set up iptables rules
### END INIT INFO

PATH="/sbin:/bin:/usr/sbin:/usr/bin"

# Include config file for iptables-persistent
. /etc/default/iptables-persistent.conf

# Include lsb init functions
. /lib/lsb/init-functions
rc=0

case "$1" in
start)
    if [ -e /var/run/iptables ]; then
        log_warning_msg "iptables is already started!"
        exit 1
    else
        touch /var/run/iptables
    fi

    # if fail2ban is already running, stop it the time needed to load the new rules
    if [ -x /etc/init.d/fail2ban ]; then
        /etc/init.d/fail2ban stop
    fi

    log_action_begin_msg "Starting iptables"

    if [ $ENABLE_ROUTING -ne 0 ]; then
        # Enable Routing
        echo 1 > /proc/sys/net/ipv4/ip_forward
        log_action_cont_msg "IPv4 routing enabled"
        if [ $IPV6 -ne 0 ]; then
            echo 1 >/proc/sys/net/ipv6/conf/all/forwarding
            log_action_cont_msg "IPv6 routing enabled"
        fi
    fi

    if [ $MODULES ]; then
        # Load Modules
        modprobe -a $MODULES
        log_action_cont_msg "Modules $MODULES loaded"
    fi

    # Load saved rules
    if [ -f /etc/iptables/rules ]; then
        iptables-restore </etc/iptables/rules
        if [ $? -ne 0 ]; then
            rc=1
        fi
        log_action_cont_msg "IPv4 rules loaded"
    fi
    if [ $IPV6 -ne 0 -a -f /etc/iptables/ipv6_rules ]; then
        ip6tables-restore </etc/iptables/ipv6_rules
        if [ $? -ne 0 ]; then
            rc=1
        fi
        log_action_cont_msg "IPv6 rules loaded"
    fi

    log_action_end_msg $rc

    # restart of fail2ban
    if [ -x /etc/init.d/fail2ban ]; then
        /etc/init.d/fail2ban start
    fi
    ;;

stop|force-stop)
    if [ ! -e /var/run/iptables ]; then
        log_warning_msg "iptables is already stopped!"
        exit 1
    else
        rm /var/run/iptables
    fi

    # stop fail2ban before flushing iptables chains
    if [ -x /etc/init.d/fail2ban ]; then
        /etc/init.d/fail2ban stop
    fi

    log_action_begin_msg "Stopping iptables"

    if [ $SAVE_NEW_RULES -ne 0 ]; then
        # Backup old rules
        cp /etc/iptables/rules /etc/iptables/rules.bak
        # Save new rules
        iptables-save >/etc/iptables/rules
        if [ $? -ne 0 ]; then
            rc=1
        fi
        log_action_cont_msg "IPv4 rules saved"

        if [ $IPV6 -ne 0 ]; then
            # Backup old rules
            cp /etc/iptables/ipv6_rules /etc/iptables/ipv6_rules.bak
            # Save new rules
            ip6tables-save >/etc/iptables/ipv6_rules
            if [ $? -ne 0 ]; then
                rc=1
            fi
            log_action_cont_msg "IPv6 rules saved"
        fi
    fi

    # Restore Default Policies
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT

    # Flush rules on default tables
    iptables -F
    iptables -t nat -F
    iptables -t mangle -F

    if [ $IPV6 -ne 0 ]; then
        # Restore Default Policies
        ip6tables -P INPUT ACCEPT
        ip6tables -P FORWARD ACCEPT
        ip6tables -P OUTPUT ACCEPT

        # Flush rules on default tables
        ip6tables -F
        ip6tables -t mangle -F
    fi

    if [ $MODULES ]; then
        # Unload previously loaded MODULES
        modprobe -r $MODULES
        log_action_cont_msg "Modules $MODULES unloaded"
    fi

    # Disable Routing if enabled
    if [ $ENABLE_ROUTING -ne 0 ]; then
        # Disable Routing
        echo 0 > /proc/sys/net/ipv4/ip_forward
        log_action_cont_msg "IPv4 routing disabled"
        if [ $IPV6 -ne 0 ]; then
            echo 0 >/proc/sys/net/ipv6/conf/all/forwarding
            log_action_cont_msg "IPv6 routing disabled"
        fi
    fi

    log_action_end_msg $rc

    # start of fail2ban
    if [ -x /etc/init.d/fail2ban ]; then
        /etc/init.d/fail2ban start
    fi
    ;;

restart|force-reload)
    $0 stop
    $0 start
    ;;

status)
    echo "Filter Rules:"
    echo "--------------"
    iptables -L -v
    echo ""
    echo "NAT Rules:"
    echo "-------------"
    iptables -t nat -L -v
    echo ""
    echo "Mangle Rules:"
    echo "----------------"
    iptables -t mangle -L -v

    if [ $IPV6 -ne 0 ]; then
        echo "**********"
        echo "** IPV6 **"
        echo "**********"
        echo "Filter Rules:"
        echo "--------------"
        ip6tables -L -v
        echo ""
        echo "Mangle Rules:"
        echo "----------------"
        ip6tables -t mangle -L -v
    fi
    ;;

*)
    echo "Usage: $0 {start|stop|force-stop|restart|force-reload|status}" >&2
    exit 1
    ;;
esac

exit 0

EOF

chmod 755 /etc/init.d/iptables-persistent


cat > /etc/default/iptables-persistent.conf << "EOF"
# A basic config file for the /etc/init.d/iptable-persistent script
#
# Should new manually added rules from command line be saved on reboot? Assign to a value different that 0 if you want this enabled.
SAVE_NEW_RULES=0

# Modules to load:
#MODULES="ip_conntrack_ftp" #example for ftp conntracking
MODULES=""

# Enable Routing? Assign to a value different that 0 if you want this enabled.
ENABLE_ROUTING=1

# Enable IPv6? Assign to a value different that 0 if you want this enabled.
IPV6=0

EOF


cat > /etc/iptables/rules << "EOF"
# Generated by iptables-save v1.8.8 on Mon Oct 17 18:38:39 2022
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -i wlan0 -p tcp -m tcp --dport 22 -j DROP
-A INPUT -i wlan0 -p tcp -m tcp --dport 22 -j DROP
COMMIT
# Completed on Mon Oct 17 18:38:39 2022
# Generated by iptables-save v1.8.8 on Mon Oct 17 18:38:39 2022
*nat
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -o wlan0 -j MASQUERADE
COMMIT

EOF


#cat > /etc/iptables/ipv6_rules << "EOF"
#EOF



#update-rc.d iptables-persistent defaults

iptables -nv -L

runlevel #N 3
check /etc/rc.d/rc3.d/


I added ". /etc/rc.d/init.d/iptables-persistent start" in the /etc/init.d/rc.local 



less /var/log/sys.log


/etc/init.d/iptables-persistent status


################################################################################
################################################################################
################################################################################


# http://archive.ubuntu.com/ubuntu/pool/universe/i/iptables-persistent/

cd /sources
wget http://archive.ubuntu.com/ubuntu/pool/universe/i/iptables-persistent/iptables-persistent_1.0.16.tar.xz

tar xf iptables-persistent_1.0.16.tar.xz
cd iptables-persistent-1.0.16
./configure --prefix=/usr


./configure --prefix=/usr          \
            --sysconfdir=/etc/lynx \
            --datadir=/usr/share/doc/lynx-2.8.9rel.1 \
            --with-zlib            \
            --with-bzlib           \
            --with-ssl             \
            --with-screen=ncursesw \
            --enable-locale-charset
make

make install-full
# Configuration Information

which lynx

cd /sources



#END
