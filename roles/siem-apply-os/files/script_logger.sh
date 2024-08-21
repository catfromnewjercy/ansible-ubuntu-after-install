cat <<EOF > /etc/profile.d/logger.sh
HOSTIP=\$(hostname -i)
U_UID=\$(id -u)
U_GID=\$(id -g)
UN_UID=\$(id -nu)
GN_UID=\$(id -ng)
AUDITD_VER=$(auditctl -v | cut -d' ' -f3)
OS_RES=$(awk -F"=| " '/^ID=/{gsub(/"/,"", $2); print tolower($2)}' /etc/os-release)_$(awk -F"=| " '/^VERSION_ID/{gsub(/"/, "", $2); print tolower($2)}' /etc/os-release)
COMM_TEMP=""

function log2syslog
{
    declare COMMAND
    COMMAND=\$(fc -ln -0 2>/dev/null)

    if [[ ! -z "\$COMMAND" && "\$COMMAND" != "\$COMM_TEMP" ]];then
      logger -p local6.info -t audispd "node=\${HOSTIP} type=BASH \\
      msg=audit(\$(date +%s.%3N):000): comm=\"\${COMMAND}\" \\
      pwd=\"\${PWD}\" uid=\${U_UID} gid=\${U_GID} \\
      UID=\"\${UN_UID}\" GID=\"\${GN_UID}\" ppid=\${PPID} pid=\$\$ \\
      terminal=\"\${SSH_TTY}\" shell=\"\${SHELL}\" shlvl=\"\${SHLVL}\" \\
      ssh_connection=\"\${SSH_CONNECTION}\" \\
      auver=\${AUDITD_VER} osres=\"\${OS_RES}\""

      COMM_TEMP=\${COMMAND}
fi
}
trap log2syslog DEBUG
EOF

chmod 644 /etc/profile.d/logger.sh
chown root:root /etc/profile.d/logger.sh
sstr="source \/etc\/profile\.d\/logger\.sh"
sed -i -e '/'"$sstr"'/{s//'"$sstr"'/;:a;n;ba;q}' -e '$a'"$sstr"'' /etc/skel/.bashrc /etc/profile /root/.bashrc
find /home/ -type f -name ".bashrc" -exec sh -c "sed -i -e '/$sstr/{s//$sstr/;:a;n;ba;q}' -e '\$a$sstr' {}" \;