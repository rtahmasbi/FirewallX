# r4_35_squid
# I had this error before, I added autoreconf -vfi (look at the ipfire: https://github.com/ipfire/ipfire-2.x/blob/master/lfs/squid)
# WARNING: 'aclocal-1.15' is missing on your system.

## for configuration
# https://www.digitalocean.com/community/tutorials/how-to-set-up-squid-proxy-on-ubuntu-20-04
# https://devopscube.com/setup-and-configure-proxy-server/
# https://phoenixnap.com/kb/setup-install-squid-proxy-server-ubuntu
# https://wiki.squid-cache.org/SquidFaq/SquidAcl
# squid -z: Initializes cache, or swap, directories. You must use this option when running Squid for the first time or whenever you add a new cache directory.


# compile
# https://wiki.squid-cache.org/SquidFaq/CompilingSquid


https://fossies.org/linux/www/squid-5.7.tar.xz/
wget http://www.squid-cache.org/Versions/v5/squid-5.7.tar.xz
wget https://fossies.org/linux/www/squid-5.7.tar.xz

cd /source
tar xf squid-5.7.tar.xz 
cd squid-5.7
./bootstrap.sh
autoreconf -vfi
cd libltdl
autoreconf -vfi
cd ..

./configure \
		--prefix=/usr \
		--sysconfdir=/etc/squid \
		--datadir=/usr/lib/squid \
		--mandir=/usr/share/man \
		--libexecdir=/usr/lib/squid \
		--localstatedir=/var \
		--disable-ssl \
		--disable-icmp \
		--disable-wccp \
		--disable-wccpv2 \
		--disable-kqueue \
		--disable-esi \
		--disable-arch-native \
		--disable-strict-error-checking \
		--enable-poll \
		--enable-ident-lookups \
		--enable-storeio=aufs,diskd,ufs \
		--enable-underscores \
		--enable-http-violations \
		--enable-removal-policies=heap,lru \
		--enable-delay-pools \
		--enable-linux-netfilter \
		--enable-snmp \
		--enable-auth \
		--enable-auth-basic \
		--enable-auth-digest \
		--enable-auth-negotiate \
		--enable-auth-ntlm \
		--enable-log-daemon-helpers \
		--enable-url-rewrite-helpers \
		--enable-build-info \
		--enable-eui \
		--enable-async-io=16 \
		--enable-unlinkd \
		--enable-internal-dns \
		--enable-epoll \
		--enable-select \
		--enable-cache-digests \
		--enable-forw-via-db \
		--enable-htcp \
		--enable-kill-parent-hack \
		--enable-icap-client \
		--enable-zph-qos \
		--with-dl \
		--with-large-files \
		--without-gnutls \
		--without-netfilter-conntrack \
		--with-default-user=squid \
		--with-logdir=/var/log/squid \
		--with-pidfile=/var/run/squid.pid


make -j2 # (very slow)
make install

which squid
squid -v

/sbin/useradd squid

mkdir -p /var/log/cache /var/log/squid
touch /var/log/squid/access.log
touch /var/log/squid/cache.log
chown -R squid:squid /var/log/squid /var/log/cache /var/log/updatexlrator
chown -R squid:squid /var/log/squid/cache.log


#mkdir -p /var/log/cache /var/log/squid
#touch /var/log/squid/access.log
#touch /var/log/squid/cache.log
#touch /var/log/cache.log
#chown -R squid:squid /var/log/squid /var/log/cache
#chown -R squid:squid /var/log/squid/cache.log
#chown -R squid:squid /var/log/cache.log

squid -z



## i run till here

rm -f /etc/squid/squid.conf
ln -sf /var/ipfire/proxy/squid.conf /etc/squid/squid.conf
rm -f /etc/squid/cachemgr.conf
ln -sf /var/ipfire/proxy/cachemgr.conf /etc/squid/cachemgr.conf
rm -f /etc/squid/errors
ln -sf /usr/lib/squid/errors/en /etc/squid/errors

-mkdir -p /var/log/cache /var/log/squid /var/log/updatexlrator
touch /var/log/squid/access.log
chown -R squid:squid /var/log/squid /var/log/cache /var/log/updatexlrator

cp /usr/lib/squid/cachemgr.cgi /srv/web/ipfire/cgi-bin/cachemgr.cgi
chown root:root /srv/web/ipfire/cgi-bin/cachemgr.cgi

cp -f $(DIR_SRC)/config/updxlrator/updxlrator /usr/sbin/updxlrator
cp -f $(DIR_SRC)/config/updxlrator/checkup /var/ipfire/updatexlrator/bin/checkup
cp -f $(DIR_SRC)/config/updxlrator/download /var/ipfire/updatexlrator/bin/download
cp -f $(DIR_SRC)/config/updxlrator/convert /var/ipfire/updatexlrator/bin/convert
cp -f $(DIR_SRC)/config/updxlrator/lscache /var/ipfire/updatexlrator/bin/lscache
cp -f $(DIR_SRC)/config/updxlrator/checkdeaddl /var/ipfire/updatexlrator/bin/checkdeaddl

cp -f $(DIR_SRC)/config/updxlrator/updxlrator-lib.pl /var/ipfire/updatexlrator/updxlrator-lib.pl

chmod 755 /usr/sbin/updxlrator /var/ipfire/updatexlrator/bin/checkup \
	/var/ipfire/updatexlrator/bin/download \
	/var/ipfire/updatexlrator/bin/convert \
	/var/ipfire/updatexlrator/bin/lscache \
	/var/ipfire/updatexlrator/bin/checkdeaddl

ln -fs /bin/false /var/ipfire/updatexlrator/autocheck/cron.daily
ln -fs /bin/false /var/ipfire/updatexlrator/autocheck/cron.monthly
ln -fs /bin/false /var/ipfire/updatexlrator/autocheck/cron.weekly

chown -R nobody:nobody /var/ipfire/updatexlrator
chown -R root:root /var/ipfire/updatexlrator/bin
chown nobody.squid /var/updatecache
chown nobody.squid /var/updatecache/download
chown nobody.squid /var/updatecache/metadata
chmod 775 /var/updatecache
chmod 775 /var/updatecache/download
chmod 775 /var/updatecache/metadata
chmod 755 /var/log/updatexlrator
chmod 755 /srv/web/ipfire/html/images/updbooster

chown squid:squid /var/log/squid
ln -sf /usr/lib/squid /usr/lib/squid/auth
cp -f $(DIR_SRC)/config/proxy/proxy.pac /srv/web/ipfire/html/proxy.pac
chown nobody.nobody /srv/web/ipfire/html/proxy.pac
ln -sf /srv/web/ipfire/html/proxy.pac /srv/web/ipfire/html/wpad.dat

# Copy stylesheets for the errorpages
cp -f $(DIR_SRC)/config/proxy/errorpage-ipfire.css /var/ipfire/proxy/
cp -f /etc/squid/errorpage.css /var/ipfire/proxy/errorpage-squid.css




cat > /etc/squid/blocked.acl << "EOF"
.facebook.com
.yahoo.com
EOF



nano /etc/squid/squid.conf
# rasool added these two line
acl blocked_websites dstdomain "/etc/squid/blocked.acl"
http_access deny blocked_websites

visible_hostname rasool_proxy



# I think we need to create init.d

cat > /etc/init.d/squid-rasool << "EOF"
#!/bin/sh
### BEGIN INIT INFO
# Provides:          squid-rasool
# Required-Start:    mountkernfs $local_fs
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# X-Start-Before:    $network
# X-Stop-After:      $network
# Short-Description: squid-rasool
### END INIT INFO

PATH="/sbin:/bin:/usr/sbin:/usr/bin"

# Include lsb init functions
. /lib/lsb/init-functions
rc=0

case "$1" in
start)
	ulimit -n 32768
	if [ -e /var/run/squid.pid ]; then
        log_warning_msg "squid is already started!"
        exit 1
    else
        touch /var/run/squid.pid
    fi
	log_warning_msg "Creating Squid swap directories..."
	/usr/sbin/squid -z >/dev/null 2>&1
	if [ $? -ne 0 ]; then
        rc=1
    fi
	log_warning_msg "Starting Squid Proxy Server..."
	/usr/sbin/squid
	;;

stop|force-stop)
    if [ ! -e /var/run/squid.pid ]; then
        log_warning_msg "squid is already stopped!"
        exit 1
    else
		PID=`cat /var/run/squid.pid 2>/dev/null`
		kill -0 $PID 2>/dev/null
        rm /var/run/squid.pid
		log_warning_msg "Squid Proxy stopped!"
    fi
	;;

restart|force-reload)
    $0 stop
    $0 start
    ;;

status)
    echo "rasool: make it complete"
	;;

*)
    echo "Usage: $0 {start|stop|force-stop|restart|force-reload|status}" >&2
    exit 1
    ;;

esac

exit 0


EOF


# this web also have a good info for startting:
#https://gist.github.com/e7d/1f784339df82c57a43bf

chmod 755 /etc/init.d/squid-rasool

/etc/init.d/squid-rasool
/etc/init.d/squid-rasool start
/etc/init.d/squid-rasool stop

less /var/log/sys.log 

[root@0] [/sources] pstree
init─┬─6*[agetty]
     ├─dhcpcd─┬─dhcpcd───2*[dhcpcd]
     │        └─2*[dhcpcd]
     ├─dhcpcd─┬─dhcpcd───4*[dhcpcd]
     │        └─2*[dhcpcd]
     ├─klogd
     ├─ntpd───{ntpd}
     ├─rngd───3*[{rngd}]
     ├─squid───squid───log_file_daemon
     ├─sshd───sshd───bash───pstree
     ├─syslogd
     ├─udevd
     └─wpa_supplicant



squid -k debug -f /etc/squid/squid.conf


tail /var/log/sys.log

l /etc/squid/
l /var/log/squid



curl -v -x http://192.168.0.1:3128 http://www.google.com/
curl -v -x http://192.168.0.1:3128 http://www.facebook.com/

curl -v -x http://your_squid_username:your_squid_password@your_server_ip:3128 http://www.google.com/



##############
# In order to set it up on my laptop:
my_mac -> Open Network Prefrences -> AX88179 USB 3.0 to Gigabit Ethernet 2 -> Advanced -> proxies
- Enable: HTTP, HTTPS, FTP, ...
- server: 192.168.0.1     port: 3128







if you need to make username and pass:
htpasswd



# list of bad ip block list
https://ipblocklist.com/
http://www.squidguard.org/blacklists.html
https://github.com/ipfire/ipfire-2.x/blob/master/config/ipblocklist/sources
our %sources = ( 'EMERGING_FWRULE' => { 'name'     => 'Emerging Threats Blocklist',
                                    'url'      => 'https://rules.emergingthreats.net/fwrules/emerging-Block-IPs.txt',
                                    'info'     => 'https://doc.emergingthreats.net/bin/view/Main/EmergingFirewallRules',
                                    'parser'   => 'ip-or-net-list',
                                    'rate'     => '1h',
                                    'category' => 'composite',
                                    'disable'  => ['FEODO_RECOMMENDED', 'FEODO_IP', 'FEODO_AGGRESSIVE', 'SPAMHAUS_DROP', 'DSHIELD'] },
             'EMERGING_COMPROMISED' => { 'name' => 'Emerging Threats Compromised IPs',
                                    'url'      => 'https://rules.emergingthreats.net/blockrules/compromised-ips.txt',
                                    'info'     => 'https://doc.emergingthreats.net/bin/view/Main/CompromisedHost',
                                    'parser'   => 'ip-or-net-list',
                                    'rate'     => '1h',
                                    'category' => 'attacker' },
             'SPAMHAUS_DROP'   => { 'name'     => "Spamhaus Don't Route or Peer List",
                                    'url'      => 'https://www.spamhaus.org/drop/drop.txt',
                                    'info'     => 'https://www.spamhaus.org/drop/',
                                    'parser'   => 'ip-or-net-list',
                                    'rate'     => '12h',
                                    'category' => 'reputation' },
             'SPAMHAUS_EDROP'  => { 'name'     => "Spamhaus Extended Don't Route or Peer List",
                                    'url'      => 'https://www.spamhaus.org/drop/edrop.txt',
                                    'info'     => 'https://www.spamhaus.org/drop/',
                                    'parser'   => 'ip-or-net-list',
                                    'rate'     => '1h',
                                    'category' => 'reputation' },
             'DSHIELD'         => { 'name'     => 'Dshield.org Recommended Block List',
                                    'url'      => 'https://www.dshield.org/block.txt',
                                    'info'     => 'https://dshield.org/',
                                    'parser'   => 'dshield',
                                    'rate'     => '1h',
                                    'category' => 'attacker' },
             'FEODO_RECOMMENDED'=> {'name'     => 'Feodo Trojan IP Blocklist (Recommended)',
                                    'url'      => 'https://feodotracker.abuse.ch/downloads/ipblocklist_recommended.txt',
                                    'info'     => 'https://feodotracker.abuse.ch/blocklist',
                                    'parser'   => 'ip-or-net-list',
                                    'rate'     => '5m',
                                    'category' => 'c and c' },
             'FEODO_IP'        => { 'name'     => 'Feodo Trojan IP Blocklist',
                                    'url'      => 'https://feodotracker.abuse.ch/downloads/ipblocklist.txt',
                                    'info'     => 'https://feodotracker.abuse.ch/blocklist',
                                    'parser'   => 'ip-or-net-list',
                                    'rate'     => '5m',
                                    'category' => 'c and c',
                                    'disable'  => 'FEODO_RECOMMENDED' },
             'FEODO_AGGRESSIVE' => { 'name'     => 'Feodo Trojan IP Blocklist (Aggressive)',
                                    'url'      => 'https://feodotracker.abuse.ch/downloads/ipblocklist_aggressive.txt',
                                    'info'     => 'https://feodotracker.abuse.ch/blocklist',
                                    'parser'   => 'ip-or-net-list',
                                    'rate'     => '5m',
                                    'category' => 'c and c',
                                    'disable'  => ['FEODO_IP', 'FEODO_RECOMMENDED'] },
             'CIARMY'          => { 'name'     => 'The CINS Army List',
                                    'url'      => 'https://cinsscore.com/list/ci-badguys.txt',
                                    'info'     => 'https://cinsscore.com/#list',
                                    'parser'   => 'ip-or-net-list',
                                    'rate'     => '15m',
                                    'category' => 'reputation' },
             'TOR_ALL'         => { 'name'     => 'Known Tor Nodes',
                                    'url'      => 'https://www.dan.me.uk/torlist',
                                    'info'     => 'https://www.dan.me.uk/tornodes',
                                    'parser'   => 'ip-or-net-list',
                                    'rate'     => '1h',
                                    'category' => 'application',
                                    'disable'  => 'TOR_EXIT' },
             'TOR_EXIT'        => { 'name'     => 'Known Tor Exit Nodes',
                                    'url'      => 'https://www.dan.me.uk/torlist/?exit',
                                    'info'     => 'https://www.dan.me.uk/tornodes',
                                    'parser'   => 'ip-or-net-list',,
                                    'rate'     => '1h',
                                    'category' => 'application' },
             'ALIENVAULT'      => { 'name'     => 'AlienVault IP Reputation database',
                                    'url'      => 'https://reputation.alienvault.com/reputation.generic',
                                    'info'     => 'https://www.alienvault.com/resource-center/videos/what-is-ip-domain-reputation',
                                    'parser'   => 'ip-or-net-list',
                                    'rate'     => '1h',
                                    'category' => 'reputation' },
             'BOGON'           => { 'name'     => 'Bogus address list (Martian)',
                                    'url'      => 'https://www.team-cymru.org/Services/Bogons/bogon-bn-agg.txt',
                                    'info'     => 'https://www.team-cymru.com/bogon-reference',
                                    'parser'   => 'ip-or-net-list',
                                    'rate'     => '1d',
                                    'category' => 'invalid' },
             'BOGON_FULL'      => { 'name'     => 'Full Bogus Address List',
                                    'url'      => 'https://www.team-cymru.org/Services/Bogons/fullbogons-ipv4.txt',
                                    'info'     => 'https://www.team-cymru.com/bogon-reference',
                                    'parser'   => 'ip-or-net-list',
                                    'rate'     => '4h',
                                    'category' => 'invalid',
                                    'disable'  => 'BOGON' },
             'SHODAN'          => { 'name'     => 'ISC Shodan scanner blocklist',
                                    'url'      => 'https://isc.sans.edu/api/threatlist/shodan?tab',
                                    'info'     => 'https://isc.sans.edu',
                                    'parser'   => 'ip-or-net-list',
                                    'rate'     => '1d',
                                    'category' => 'scanner' },
             'BLOCKLIST_DE'    => { 'name'     => 'Blocklist.de all attacks list',
                                    'url'      => 'https://lists.blocklist.de/lists/all.txt',
                                    'info'     => 'https://www.blocklist.de',
                                    'parser'   => 'ip-or-net-list',
                                    'rate'     => '30m',
                                    'category' => 'attacker' }


#END
