declaration template metaconfig/ssh/schema;

include 'pan/types';

# rename these types to prevent conflicts
#   we will remove these in an upcoming pr after template-library-core
#   has been updated with the new types from ncm-ssh
type temp_ssh_ciphers = string with match (SELF, "^[+-]?((blowfish|3des|aes128|aes192|aes256|cast128)-cbc" +
    "|(aes128|aes192|aes256)-ctr|arcfour|arcfour(128|256)|(aes128-gcm|aes256-gcm|chacha20-poly1305)@openssh.com)$");
type temp_ssh_hostkeyalgorithms = string with match(SELF, "^[+-]?(ssh-(rsa|dss|ed25519)|ecdsa-sha2-nistp(256|384|521)|" +
    "(ssh-rsa-cert-v01|ssh-dss-cert-v01|ecdsa-sha2-nistp256-cert-v01|ecdsa-sha2-nistp384-cert-v01|" +
    "ecdsa-sha2-nistp521-cert-v01|ssh-rsa-cert-v00|ssh-dss-cert-v00|ssh-ed25519-cert-v01)@openssh.com)$");
type temp_ssh_kbdinteractivedevices = string with match (SELF, "^(bsdauth|pam|skey)$");
type temp_ssh_kexalgorithms = string with match (SELF, "^[+-]?(diffie-hellman-group(1-sha1|14-sha1|-exchange-sha1|" +
    "-exchange-sha256)|ecdh-sha2-nistp(256|384|521)|curve25519-sha256@libssh.org|gss-gex-sha1-|" +
    "gss-group1-sha1-|gss-group14-sha1-)$");
type temp_ssh_MACs = string with match(SELF, "^[+-]?(hmac-(sha1|sha1-96|sha2-256|sha2-512|md5|md5-96|ripemd160)|" +
    "(hmac-ripemd160|umac-64|umac-128|hmac-sha1-etm|hmac-sha1-96-etm|hmac-sha2-256-etm|hmac-sha2-512-etm|" +
    "hmac-md5-etm|hmac-md5-96-etm|hmac-ripemd160-etm|umac-64-etm|umac-128-etm)@openssh.com)$");
type temp_ssh_CAAlgorithms = string with match(SELF, "^[+-]?(ecdsa-sha2-nistp(256|384|521)|ssh-ed25519|rsa-sha2-(256|512)|ssh-rsa)$");


type ssh_config_opts = {
    'AddKeysToAgent' ? string with match (SELF, "^(yes|no|ask|confirm)$")
    'AddressFamily' ? string with match (SELF, "^(any|inet|inet6)$")
    'BatchMode' ? boolean
    'BindAddress' ? string
    'BindInterface' ? string
    'CanonicalDomains' ? string[]
    'CanonicalizeFallbackLocal' ? boolean
    'CanonicalizeHostname' ? string with match (SELF, "^(yes|no|always)$")
    'CanonicalizeMaxDots' ? long(0..)
    'CanonicalizePermittedCNAMEs' ? string[]
    'CASignatureAlgorithms' ? temp_ssh_CAAlgorithms[]
    'CertificateFile' ? string[]
    'ChallengeResponseAuthentication' ? boolean
    'CheckHostIP' ? boolean
    'Cipher' ? string with match (SELF, "^(blowfish|3des|des)$")
    'Ciphers' ? temp_ssh_ciphers[]
    'ClearAllForwardings' ? boolean
    'Compression' ? boolean
    'CompressionLevel' ? long(0..9)
    'ConnectionAttempts' ? long(0..)
    'ConnectTimeout' ? long(0..)
    'ControlMaster' ? string with match (SELF, "^(yes|no|ask|auto|autoask)$")
    'ControlPath' ? string
    'ControlPersist' ? string
    'DynamicForward' ? string
    'EnableSSHKeysign' ? boolean
    'EscapeChar' ? string
    'ExitOnForwardFailure' ? boolean
    'FingerprintHash' ? string with match (SELF, "^(md5|sha256)$")
    'ForwardAgent' ? boolean
    'ForwardX11' ? boolean
    'ForwardX11Timeout' ? long(0..)
    'ForwardX11Trusted' ? boolean
    'GatewayPorts' ? boolean
    'GlobalKnownHostsFile' ? string[]
    'GSSAPIAuthentication' ? boolean
    'GSSAPIClientIdentity' ? string
    'GSSAPIDelegateCredentials' ? boolean
    'GSSAPIKeyExchange' ? boolean
    'GSSAPIRenewalForcesRekey' ? boolean
    'GSSAPIServerIdentity' ? string
    'GSSAPITrustDns' ? boolean
    'HashKnownHosts' ? boolean
    'HostbasedAuthentication' ? boolean
    'HostbasedKeyTypes' ? string[]
    'HostKeyAlgorithms' ? temp_ssh_hostkeyalgorithms[]
    'HostKeyAlias' ? string
    'HostName' ? string
    'IdentitiesOnly' ? boolean
    'IdentityAgent' ? string
    'IdentityFile' ? string[]
    'IgnoreUnknown' ? string[]
    'Include' ? string[]
    'IPQoS' ? string with match (SELF, "^(af[1234][123]|cs[0-7]|ef|lowdelay|throughput|reliability)$")
    'KbdInteractiveAuthentication' ? boolean
    'KbdInteractiveDevices' ? temp_ssh_kbdinteractivedevices[]
    'KexAlgorithms' ? temp_ssh_kexalgorithms[]
    'LocalCommand' ? string
    'LocalForward' ? string
    'LogLevel' ? string with match (SELF, "^(QUIET|FATAL|ERROR|INFO|VERBOSE|DEBUG|DEBUG[123])$")
    'MACs' ? temp_ssh_MACs[]
    'NoHostAuthenticationForLocalhost' ? boolean
    'NumberOfPasswordPrompts' ? long(0..)
    'PasswordAuthentication' ? boolean
    'PermitLocalCommand' ? boolean
    'PKCS11Provider' ? string
    'Port' ? long(1..65535)
    'PreferredAuthentications' ? string[]
    'Protocol' ? long(1..2)
    'ProxyCommand' ? string
    'ProxyJump' ? string[]
    'ProxyUseFdpass' ? boolean
    'PubkeyAcceptedKeyTypes' ? temp_ssh_hostkeyalgorithms[]
    'PubkeyAuthentication' ? boolean
    'RekeyLimit' ? string
    'RemoteCommand' ? string
    'RemoteForward' ? string
    'RequestTTY' ? string with match (SELF, "^(yes|no|force|auto)$")
    'RevokedHostKeys' ? string[]
    'RhostsRSAAuthentication' ? boolean
    'RSAAuthentication' ? boolean
    'SendEnv' ? string[]
    'ServerAliveCountMax' ? long(0..)
    'ServerAliveInterval' ? long(0..)
    'SetEnv' ? string{}
    'StreamLocalBindMask' ? string
    'StreamLocalBindUnlink' ? boolean
    'StrictHostKeyChecking' ? string with match (SELF, "^(yes|no|ask)$")
    'SyslogFacility' ? string with match(SELF, "^(DAEMON|USER|AUTH|LOCAL[0-7])$")
    'TCPKeepAlive' ? boolean
    'Tunnel' ? string with match (SELF, "^(yes|no|point-to-point|ethernet)$")
    'TunnelDevice' ? string
    'UpdateHostKeys' ? string with match (SELF, "^(yes|no|ask)$")
    'UsePrivilegedPort' ? boolean
    'User' ? string
    'UserKnownHostsFile' ? string[]
    'VerifyHostKeyDNS' ? string with match (SELF, "^(yes|no|ask)$")
    'VisualHostKey' ? boolean
    'XAuthLocation' ? string
};

type ssh_config_host = {
    "hostnames" : string[]
    include ssh_config_opts

};

type ssh_config_match = {
    "matches" : string[]
    include ssh_config_opts

};

type ssh_config_file = {
    'Host' ? ssh_config_host[]
    'Match' ? ssh_config_match[]
    'main' ? ssh_config_opts
};

