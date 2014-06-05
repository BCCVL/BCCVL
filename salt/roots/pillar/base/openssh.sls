


sshd_config:

  Protocol: 2
  HostKey:
    - /etc/ssh/ssh_host_rsa_key
    - /etc/ssh/ssh_host_dsa_key
  ServerKeyBits: 1024
  SyslogFacility: AUTHPRIV
  PermitRootLogin: no
  AuthorizedKeysFile: .ssh/authorized_keys
  # IngoreUserKnownHosts: no
  PasswordAuthentication: no
  ChallengeResponseAuthentication: no

  UsePam: yes
  GSSAPIAuthentication: yes
  GSSAPICleanupCredentials: yes
  MaxStartups: "10:30:100"
  Banner: /etc/ssh/sshd_banner
  Subsystem: sftp /usr/lib/openssh/sftp-server

  AcceptEnv: >
      LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
      LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
      LC_IDENTIFICATION LC_ALL LANGUAGE
      XMODIFIERS

  AllowGroups: ssh_user
