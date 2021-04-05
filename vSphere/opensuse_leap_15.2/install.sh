# Executar updates
#
zypper -n dup -y

# Desabilitar Swap
#
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Resetar o valor de machine-id
#
truncate -s 0 /etc/machine-id
rm /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id

# Limpeza
#
zypper -n clean --all
rm -f /etc/udev/rules.d/70-persistent-net.rules
touch /etc/udev/rules.d/75-persistent-net-generator.rules
truncate -s 0 /etc/{hostname,hosts,resolv.conf}
for seed in /var/lib/systemd/random-seed /var/lib/misc/random-seed; do
  [ -f "$seed" ] && rm -f "$seed"
done
if [ -d /var/lib/wicked ]; then
    rm -rf /var/lib/wicked/*
fi
rm -rf /tmp/* /tmp/.* /var/tmp/* /var/tmp/.* &> /dev/null || true
rm -rf /var/cache/*/* /var/crash/* /var/lib/systemd/coredump/*
cloud-init clean -s -l
