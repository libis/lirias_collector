# !!!!!!!!! 
# check rubu version
source /ftp/LIMO/.rvm/gems/ruby-2.4.3/environment

#  root@libis-p-ftp-1 /ftp/LIMO 14:07 
# /etc/init.d/firewall start
# rm records/*xml
cd /home/limo/dCollector
#ruby collector.rb rules/lirias_pre_pnx_rules.rb
ruby collector.rb rules/recent_lirias_rules.rb



