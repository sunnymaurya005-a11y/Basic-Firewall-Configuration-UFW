# Basic Firewall Configuration with UFW

## Project overview

This project demonstrates how to install and configure UFW (Uncomplicated Firewall) on Kali Linux or Ubuntu. UFW manages network traffic using rules that allow or deny connections.

## Tools used

- Kali Linux / Ubuntu
- UFW (Uncomplicated Firewall)
- Bash
- `curl` and Python HTTP server for a basic connectivity test

## Firewall policy

The configuration applies these default policies:

- **Incoming: deny** — unsolicited incoming connections are blocked unless an explicit allow rule exists.
- **Outgoing: allow** — applications on the machine can initiate outbound connections.

## Rules configured

| Port | Protocol | Action | Reason |
|---|---|---|---|
| 22 | TCP | Allow incoming | Allows SSH administration |
| 80 | TCP | Deny incoming | Blocks unencrypted HTTP service access |
| 443 | TCP | Allow incoming | Allows HTTPS service access |
| 23 | TCP | Deny incoming | Blocks insecure Telnet access |

The project does not open DNS port 53. A typical workstation does not need to accept inbound DNS queries. The screenshots supplied during setup show an earlier `allow 53` rule; the final script intentionally omits it.

## Run the configuration

```bash
sudo apt update
sudo apt install ufw -y
chmod +x ufw_configuration.sh
sudo ./ufw_configuration.sh
```

The script checks for UFW, installs it if missing, sets the default policies, adds the four rules, enables the firewall, and prints the final status.

> Warning: If you administer the machine remotely over SSH, confirm that SSH access is allowed before enabling UFW. These rules allow SSH on TCP port 22 from any source. For better security, restrict SSH to trusted IP addresses when appropriate.

## Verify the rules

```bash
sudo ufw status verbose
```

Expected key entries:

```text
Status: active
Default: deny (incoming), allow (outgoing)

22/tcp    ALLOW IN    Anywhere
80/tcp    DENY IN     Anywhere
443/tcp   ALLOW IN    Anywhere
23/tcp    DENY IN     Anywhere
```

IPv6 entries may also appear when IPv6 support is enabled.

## Testing method

A reliable inbound firewall test should be performed from a **second machine** on a network that can reach the Kali/Ubuntu VM.

1. On the firewall machine, start a temporary HTTP server bound to its VM IP address:

   ```bash
   python3 -m http.server 80 --bind <FIREWALL_VM_IP>
   ```

2. On a second machine, attempt to connect:

   ```bash
   curl --connect-timeout 5 http://<FIREWALL_VM_IP>/
   ```

3. With UFW active and the TCP/80 deny rule in place, the remote connection should fail or time out. Confirm that the server is running and that both VMs can communicate before interpreting the result.
4. Stop the temporary server with `Ctrl+C`.

### Evidence note

The screenshots in `screenshots/` are the screenshots supplied during the project session. They show successful UFW installation, script execution, active firewall rules, and a `curl` request that returned a directory listing from `192.168.213.129`.

**Important:** That `curl` output is a successful HTTP response, not proof that port 80 was blocked. It appears to be a test against the same Kali machine, so it does not verify inbound filtering. The project therefore records the test as inconclusive and provides the correct second-machine test above. Capture a new screenshot of the failed remote request before claiming the HTTP block has been verified.

## Screenshots

| File | What it shows |
|---|---|
| `01-ufw-installation.jpg` | UFW package installation completed |
| `02-network-and-http-test.jpg` | Kali interface addresses and the HTTP request output |
| `03-ufw-script-execution.jpg` | Script applied policies and enabled UFW |
| `04-ufw-status-verbose.jpg` | Active UFW status and configured rules |

## What is a firewall?

A firewall is a security control that monitors and filters network traffic according to configured rules. It helps reduce unwanted network access by deciding which connections are allowed and which are denied.

## Why these rules?

- SSH is allowed so an administrator can manage the machine remotely.
- HTTP is denied to prevent inbound access to an unencrypted web service.
- HTTPS is allowed for secure web services.
- Telnet is denied because it does not encrypt session traffic.
- Denying incoming traffic by default follows a least-exposure approach: only explicitly required inbound services are opened.

Allowing a port does not install or start the corresponding service. For example, allowing TCP/443 does not create an HTTPS server; it only permits matching traffic through the firewall.

## Useful commands

```bash
sudo ufw status verbose
sudo ufw status numbered
sudo ufw enable
sudo ufw disable
sudo ufw delete allow 53
sudo ufw logging on
```

## References

- Ubuntu Community Help Wiki — UFW: https://help.ubuntu.com/community/UFW
- Ubuntu Server documentation — Firewalls: https://ubuntu.com/server/docs/how-to/security/firewalls/
- UFW manual: `man ufw`

## Conclusion

This project demonstrates basic Linux firewall administration with UFW, including installation, default policies, port-based allow/deny rules, Bash automation, status verification, and a practical remote testing procedure.
