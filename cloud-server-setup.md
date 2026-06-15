# Cloud Server Setup Guide (No Credit Card Required)

**Purpose:** Set up lightweight Ubuntu VMs for DevOps learning without spending money on cloud services.

**Alternative to:** Oracle Cloud, AWS, GCP (which all require credit cards)

**Note:** This guide uses VirtualBox to run servers on your own computer. When you get a job, you'll use the same skills on real cloud platforms.

---

## Overview

```
Your Computer (Host)
├── VirtualBox (free software)
│   ├── VM1: Ubuntu Server (lightweight)
│   ├── VM2: Additional VMs as needed
│   └── VMs are isolated, safe to experiment
└── Real cloud skills you'll use later:
    ├── SSH access
    ├── Linux administration
    ├── Docker containers
    ├── Kubernetes clusters
    └── Infrastructure as Code
```

---

## Prerequisites

| What | Details |
|------|---------|
| Computer | 4GB+ RAM, 20GB+ free disk space |
| OS | Windows, macOS, or Linux |
| Software | VirtualBox (free download) |
| Time | ~2-3 hours for full setup |

---

## Part 1: Install VirtualBox

### Download

1. Go to: **https://www.virtualbox.org/wiki/Downloads**
2. Click: **"Windows hosts"** / **"macOS hosts"** / **"Linux distributions"**
3. Download the latest version (~100MB)

### Install

**Windows:**
```
1. Run the .exe installer
2. Click "Next" through all options
3. ⚠️ When prompted about network interfaces → Click "Yes" to install drivers
4. Wait for installation to complete
5. Click "Finish" → VirtualBox opens
```

**macOS:**
```
1. Open the .dmg file
2. Drag VirtualBox to Applications
3. Enter your password when prompted
4. Go to System Settings → Privacy & Security → Allow the extension
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install virtualbox
```

### Install VirtualBox Extension Pack (Optional but Recommended)

```
1. Download from: https://www.virtualbox.org/wiki/Downloads
   → "VirtualBox 7.x.x Oracle VM VirtualBox Extension Pack"
2. Open VirtualBox → File → Tools → Extensions
3. Click "Install" → Select the downloaded file
4. Accept license → Done
```

---

## Part 2: Download Ubuntu Server

### Why Ubuntu Server (Not Desktop)?

| | Ubuntu Server | Ubuntu Desktop |
|--|--------------|----------------|
| Size | ~400MB | ~4.5GB |
| RAM usage | ~300MB idle | ~1GB idle |
| GUI | None (command line) | Full desktop |
| Speed | Faster install | Slower, heavier |
| **For DevOps** | ✅ **Recommended** | ❌ Skip |

### Download

1. Go to: **https://ubuntu.com/download/server**
2. Click: **"Option 2 — Manual server installation"**
3. Download: `ubuntu-24.04 LTS-server-amd64.iso`
   - Size: ~400MB
   - LTS = Long Term Support (5 years of updates)

**Alternative (Even Lighter):**
- Ubuntu Netboot: ~50MB (for advanced users)
- https://help.ubuntu.com/community/Installation/MinimalCD

---

## Part 3: Create Your First VM

### Step 1: New Virtual Machine

In VirtualBox:

```
1. Click "New"
2. Fill in:
   ├── Name: ubuntu-devops
   ├── Folder: (leave default or pick a drive with space)
   ├── ISO Image: (browse to ubuntu-24.04-server-amd64.iso)
   ├── Type: Linux
   ├── Version: Ubuntu (64-bit)
   └── ☑️ Skip Unattended Installation
3. Click "Next"
```

### Step 2: Hardware Configuration

```
┌─────────────────────────────────────────────────────┐
│  Base Memory: 1024 MB (1 GB)                        │
│  (Can increase later if you have more RAM)          │
│                                                     │
│  Processors: 1 CPU                                  │
│  (Add more if you have multiple cores)              │
│                                                     │
│  EFI: ☑️ Enable (optional, stick with BIOS)        │
└─────────────────────────────────────────────────────┘
```

**Why 1GB RAM?**
- Minimum for Ubuntu Server
- Enough for Docker and basic Kubernetes
- Keep host responsive

### Step 3: Virtual Hard Disk

```
┌─────────────────────────────────────────────────────┐
│  ☑️ Create a virtual hard disk now                  │
│                                                     │
│  File size: 20 GB                                   │
│  (Dynamic allocation = uses space as needed)        │
│                                                     │
│  ☑️ Pre-allocate Full Size (optional, faster)      │
└─────────────────────────────────────────────────────┘
```

### Step 4: Summary

```
Name: ubuntu-devops
OS: Ubuntu (64-bit)
Memory: 1024 MB
CPU: 1
Disk: 20 GB (dynamic)
ISO: ubuntu-24.04-server-amd64.iso

Click "Finish"
```

---

## Part 4: Install Ubuntu Server

### Start the VM

Click "Start" in VirtualBox.

### Installation Steps

**1. Welcome Screen:**
```
Select language: English
Choose: "Install Ubuntu Server"
```

**2. Network:**
```
Leave default (should auto-detect)
→ "Done"
```

**3. Mirror:**
```
Leave default (Ubuntu archive)
→ "Done"
```

**4. Storage:**
```
→ "Use an entire disk"
→ "Done"
→ "Continue" (confirm)
→ "Done"
```

**5. Profile Setup:**
```
Your name: devops
Your server's name: ubuntu-devops
Pick a username: devops
Choose a password: ************
Confirm password: ************
```

**6. SSH Setup (Important!):**
```
☐ Install OpenSSH server  ← CHECK THIS
→ "Done"
```

**7. Featured Software Snaps:**
```
Leave all unchecked (we'll install manually)
→ "Done"
```

**8. Installation:**
```
Wait ~5-10 minutes...
DO NOT close the window
```

**9. Complete:**
```
"Reboot Now"
```

---

## Part 5: First Login

### After Reboot

You'll see:
```
ubuntu-devops login: _
```

Type: `devops`
Press: Enter

Password: (enter the password you created)

---

## Part 6: Essential First Steps

### Update Everything

```bash
sudo apt update && sudo apt upgrade -y
```

### Install Essential Tools

```bash
sudo apt install -y \
    curl \
    wget \
    git \
    htop \
    tmux \
    vim \
    net-tools \
    dnsutils \
    ufw \
    fail2ban
```

### Remove Unnecessary Packages

```bash
# Remove snapd (causes issues, not needed for server)
sudo apt remove --purge -y snapd

# Remove unnecessary services
sudo apt autoremove -y

# Clean up
sudo apt autoclean
sudo apt clean
```

### Check System Resources

```bash
# See CPU, RAM, processes
htop

# See disk usage
df -h

# See network interfaces
ip addr
```

---

## Part 7: Set Up SSH Access

### From Host Computer (Not the VM)

#### Windows (Use PowerShell or Git Bash)

```powershell
# Check if you have an SSH key
ls ~/.ssh/id_rsa.pub

# If not, generate one
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# Copy public key to VM
type ~/.ssh/id_rsa.pub | ssh devops@<VM-IP-ADDRESS> "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

#### Linux/macOS

```bash
# Check if you have an SSH key
cat ~/.ssh/id_rsa.pub

# If not, generate one
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# Copy public key to VM
ssh-copy-id devops@<VM-IP-ADDRESS>
```

### Find Your VM's IP Address

Inside the VM:
```bash
hostname -I
```

Output looks like: `10.0.2.15`

### Connect from Host

```bash
ssh devops@10.0.2.15
```

### Create SSH Config (Easier Access)

On your **host computer**:

```bash
# Create/edit SSH config
nano ~/.ssh/config
```

Add:
```bash
Host devops
    HostName 10.0.2.15
    User devops
    IdentityFile ~/.ssh/id_rsa
    Port 22
```

Now connect with just:
```bash
ssh devops
```

---

## Part 8: Configure Firewall

### Enable UFW (Uncomplicated Firewall)

```bash
# Allow SSH (CRITICAL - do this before enabling!)
sudo ufw allow ssh

# Allow common ports
sudo ufw allow 80/tcp   # HTTP
sudo ufw allow 443/tcp  # HTTPS

# Enable firewall
sudo ufw enable

# Check status
sudo ufw status verbose
```

**⚠️ Warning:** If you didn't allow SSH before enabling the firewall, you may lock yourself out!

---

## Part 9: Create a Snapshot (Backup Point)

### What is a Snapshot?

A snapshot saves your VM's exact state. If you break something later, you can restore to this point.

### Take a Snapshot

```
1. In VirtualBox, select your VM (powered on or off)
2. Click "Snapshots" (top-right corner)
3. Click the camera icon "Take"
4. Name: "Fresh Install + Basic Setup"
5. Description: "After first-boot setup, before Docker/K8s"
6. Click "OK"
```

### Restore a Snapshot

```
1. Click "Snapshots"
2. Select the snapshot you want
3. Click "Restore"
4. ☑️ "Create a checkpoint of the current machine state"
5. Click "Restore"
```

---

## Part 10: Install Docker

### Quick Install

```bash
curl -fsSL https://get.docker.com | sh
```

### Add User to Docker Group

```bash
sudo usermod -aG docker devops

# Log out and back in for group to take effect
exit
# Then reconnect: ssh devops
```

### Verify Installation

```bash
docker --version
docker run hello-world
```

### Install Docker Compose

```bash
sudo apt install -y docker-compose
docker-compose --version
```

---

## Part 11: Install Kubernetes (K3s - Lightweight)

### Why K3s?

| | K8s (Standard) | K3s |
|--|---------------|-----|
| RAM needed | 2GB+ | 512MB |
| Install time | 30+ minutes | 1 minute |
| Complexity | High | Medium |
| **For learning** | Overkill | ✅ **Recommended** |

### Install K3s

```bash
curl -sfL https://get.k3s.io | sh -
```

### Check Status

```bash
sudo kubectl get nodes
kubectl version --client
```

### Optional: Multi-Node Setup

For a true cluster, you'll create additional VMs and join them to the master. We'll cover this in a separate guide.

---

## Part 12: Create a Template VM (Clone for Future)

### Why Create a Template?

Instead of reinstalling Ubuntu every time you want a new VM:
- Clone your configured VM
- Save hours of setup
- Consistent environment

### Create the Template

```
1. Shut down your VM
2. Right-click the VM → "Clone"
3. Name: ubuntu-template
4. Clone type: "Linked Clone" (saves disk space)
5. Click "Clone"
6. Wait for cloning to complete
```

### Use the Template

```
1. Right-click "ubuntu-template"
2. Click "Clone"
3. Name: ubuntu-devops-2, ubuntu-k8s, etc.
4. Start using immediately!
```

---

## Part 13: Common Problems & Solutions

| Problem | Solution |
|---------|----------|
| VM won't start (VT-x error) | Enable virtualization in BIOS/UEFI |
| Black screen after install | Increase video RAM in VM settings |
| Can't SSH in | Check firewall: `sudo ufw status` |
| Network not working | VM settings → Adapter → NAT |
| Slow performance | Increase RAM/CPU in VM settings |
| Disk full | `docker system prune -a` to clean up |

### Enable Virtualization (If Needed)

**Windows:**
```
1. Restart computer
2. Enter BIOS/UEFI (press F2, F12, or Del)
3. Find: "Intel VT-x" or "AMD-V"
4. Enable
5. Save and restart
```

**Linux:**
```bash
# Check if virtualization is enabled
egrep -c '(vmx|svm)' /proc/cpuinfo

# If output is 0, it's not enabled
# If output is 1+, it's enabled
```

---

## Part 14: What's Next?

### Skills to Practice

| Week | Skill | How |
|------|-------|-----|
| 1 | Linux commands | Run `htop`, `tmux`, `journalctl` |
| 2 | Docker | Build images, run containers |
| 3 | Docker Compose | Multi-container apps |
| 4 | Kubernetes | Deploy apps to K3s |
| 5 | Networking | Configure firewall, DNS |
| 6 | Scripting | Bash scripts, automation |

### When to Add More VMs

- Need a separate database server? → Clone template
- Need a monitoring server? → Clone template
- Need a load balancer? → Clone template

### Progression Path

```
VM1: Ubuntu Server (you're here)
    ├── Learn Linux basics
    ├── Install Docker
    └── Practice container commands

VM2: Ubuntu Server (add in week 2)
    ├── Docker host for apps
    └── Network between VMs

VM3: Ubuntu Server (add in week 4)
    ├── K3s master node
    └── Practice Kubernetes

VM1+VM2+VM3 = Your Home Lab
    ├── Real cluster experience
    ├── Portfolio projects
    └── Job interview evidence
```

---

## Summary: Commands Reference

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install tools
sudo apt install -y curl wget git htop tmux vim net-tools ufw fail2ban

# Install Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker devops

# Install K3s
curl -sfL https://get.k3s.io | sh -

# Check status
htop                          # System resources
docker ps                     # Running containers
kubectl get nodes             # K8s cluster
sudo ufw status              # Firewall rules
journalctl -xe               # System logs
```

---

## Resources

- Ubuntu Server Guide: https://ubuntu.com/server/docs
- VirtualBox Docs: https://docs.oracle.com/virtualization/virtualbox/
- Docker Docs: https://docs.docker.com/
- K3s Docs: https://docs.k3s.io/

---

*Last updated: 2026-06-15*
