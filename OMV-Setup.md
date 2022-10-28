# How to set up OpenMediaVault NAS on a Raspberry Pi

Follow the instructions in this somewhat complete [**tutorial**](https://www.youtube.com/watch?v=gyMpI8csWis&t=362s).

1. With [**Raspberry Pi Imager**](https://www.raspberrypi.com/software/) install `Raspberry PI OS Lite (64-bit)` on a Micro SD card.
   - during installation you have the option to **enable SSH** connection and set `username` (for example simply *pi*) and `password`.
2. After installation insert SD card and connect Raspberry Pi through ethernet cable to the **network** and to the **power supply**.
3. On the WiFi router site, find the Raspberry's IP address
4. On a computer type in a terminal:
    ```bash
    ssh <username>@<ip-address>
    # for example: ssh pi@192.168.1.133
    ```

    > ⛔️ If you get this error:
    > ```
    > @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    > @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
    > @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    > IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
    > Someone could be eavesdropping on you right now (man-in-the-middle attack)!
    > It is also possible that a host key has just been changed.
    > The fingerprint for the ED25519 key sent by the remote host is
    > SHA256:Uc1PbMCNe1mWIbazhAqKf9TDYidSL12eVsMuVWa41As.
    > Please contact your system administrator.
    > Add correct host key in /Users/jozseflurvig/.ssh/known_hosts to get rid of this message.
    > Offending ED25519 key in /Users/jozseflurvig/.ssh/known_hosts:7
    > Host key for 192.168.1.133 has changed and you have requested strict checking.
    > Host key verification failed.
    > ```
    > 
    > Just type:
    > 
    > ```bash
    > ssh-keygen -R <ip-address>
    > ```

5. Update Raspberry OS

    ```bash
    sudo apt update && sudo apt upgrade
    ```

6. Install NAS OS `OpenMediaVault`
   - this will take long, and ssh connection will be lost + raspberry will get a new IP address
   - look up the new address on the router and connect to the raspberry again through ssh

   ```bash
   sudo wget -O - https://raw.githubusercontent.com/OpenMediaVault-Plugin-Developers/installScript/master/install | sudo bash
   ```

7. In a web browser, type in the new IP address
   - default `username`: *admin*
   - default `password`: *openmediavault*

8. Change password
   - in the current version it's in the upper right corner. A person icon: **User Settings** > **Change password**

9. Connect HDD via USB
   - it should now appear under **Storage** > **Disks**
   - go to **Storage** > **File Systems**, then hit `+` and **Mount**. Hit **Apply** in the upper right corner.
   - Wait until done.
   - Then under **Storage** > **Shared Folders** hit `+`, name the folder, select previously created file system, and click **Save**

10. Set access services
    - **SMB** is default for Windows (works with Mac - also Time Machine; but **SMB** is a bit faster on Windows)
    - **NFS** is for Linux/Mac
    - **AFP** is for Mac *(tried it, **SMB** is faster)*

    enable **SMB VFS**?

> 🧐 Use **CMS** NAS drives, ***not*** **SMR**!

## How to enable AFP on OMV

**AFP** is the native file and printer sharing protocol for Macs and it supports many unique Mac attributes that are not supported by other protocols. So for the best performance, and 100% compatibility, **AFP** should be used. *([**Source**](https://www.helios.de/web/EN/news/AFP_vs_SMB-NFS.html))*

First install **netatalk**:

```bash
sudo apt install netatalk
nano /etc/netatalk/afp.conf
```

Paste this into the config file:

```conf
;
; Netatalk 3.x configuration file
;

[Global]
; Global server settings

; [Homes]
; basedir regex = /home

[dusty]
path = /srv/dev-disk-by-uuid-10C4B9617AABC62B/dusty

[backup]
path = /srv/dev-disk-by-uuid-2a24ad88-d8e0-489b-9d1f-be706f81f4b4/backup
time machine = yes
```

*Source: https://forum.openmediavault.org/index.php?thread/43750-afp-on-omv-6/*

||MacOS|Windows|
|---|---|---|
|SMB|||
|AFP|||

Restart **netatalk**:

```bash
sudo systemctl restart netatalk
```

*Source: https://chicagodist.com/blogs/news/using-netatalk-to-share-files-between-a-raspberry-pi-and-mac*

## [**How-To Install Wireguard (VPN) in docker**](https://forum.openmediavault.org/index.php?thread/40438-how-to-install-wireguard-vpn-in-docker-server-mode/)

## Create partition on Linux

```bash
sudo parted /dev/sdb
mkpart primary ext4 0% 50%
mkpart primary ntfs 50% 100%
sudo mkfs.ext4 /dev/sdb1
sudo mkntfs -f /dev/sdb2
```

> ⚠️ The `parted mkpart` command does <u>not</u> make file system, even if you specify `ext4` and `ntfs` or other in the same line! Don't let it fool you!

### Useful commands

```bash
lsblk # prints disks
sudo fdisk -l /dev/sdb # prints start-end sectors for partitions
```

### Useful links:

https://linuxhint.com/parted_linux/ \
http://woshub.com/parted-create-manage-disk-partitions-linux/ \
https://www.sciencedirect.com/topics/computer-science/primary-partition

### This is how to update Linux packages

```bash
sudo apt update && sudo apt upgrade
sudo apt autoremove
```

# Installation of Plex Media Server with docker-compose

Find source [**here**](https://forum.openmediavault.org/index.php?thread/28685-how-to-install-plex-media-server-pms-container-using-omv-and-docker-compose/).

# Installation of Plex Media Server with OMV-Extras

Finde source [**here**](https://www.wundertech.net/how-to-install-plex-on-openmediavault/).

1. Install OMV-Extras under **Plugins**

2. Find **omv-extras** menu under **System** in the OMV GUI

3. Select **Docker** and **Install** it.

   - change docker folder (from default `/var/lib/docker`) to one on a media disk *(for more, see **OMV Web interface throws me out immediately after login** section in this documenation)*
   - ☠️ This however caused the CPU to work ~80% 24/7, so moved the folder back and bought a bigger SD card + [**copied**](https://www.youtube.com/watch?v=yREOajrnBIM) the OS disk to the new card.

4. After **Docker** is installed, select **Portainer** and **Install** it.

5. Select **Open Web**

6. Create a user account

7. Select **Get Started**

8. Select **local**

Now we install **Plex** in the docker

1. Select **Volumes**, then **Add Volume** &rarr name it **Plex**, click **Create the Volume**

2. Select **Containers**, then **Add Container** &rarr name it **Plex**, enter **Image**: `linuxserver/plex:latest`

3. At the bottom, under **Advanced container settings**, select **Volumes** (instead of **Command & logging**)

   - in either OMV GUI > **Storage** > **Shared Folders**, or in a Terminal, check for media path (it should look something like this: `/srv/dev-disk-by-uuid-34F5EE1202469FF7/nasty/Movies`)
   - map additional volume
     - container: `/config` - Volume\
       volume: `Plex - local`
   - map additional volume
     - container: `/movies` - Bind\
       volume: `/srv/dev-disk-by-uuid-34F5EE1202469FF7/nasty/Movies` - Read-only
   - map additional volume
     - container: `/shows` - Bind\
       volume: `/srv/dev-disk-by-uuid-34F5EE1202469FF7/nasty/TV Shows` - Read-only (you just simply write space)

4. Under **Network** select **host**

5. Change **Restart policy** to **Always**

6. Under **Runtime & Resources** turn on **Privileged mode**

7. Finally, **Deploy the container**.

In the browser, go to `OMV_IP:32400/web/index.html`

1. Sign in.

2. Go through Plex media setup.

To update Plex Media Server: ?

# OMV Web interface throws me out immediately after login

https://forum.openmediavault.org/index.php?thread/41619-web-interface-throws-me-out-immediately/

This is most probably caused because the OS drive is full. To find out, run:

```bash
df
```

*Source: https://forum.openmediavault.org/index.php?thread/33600-how-to-fix-full-os-filesystem-gui-login-loop/*

Find out what is taking up space with:

```bash
sudo du -xhd1
cd foldername
```

> it is most probably: `/var/lib/docker` (and you can't enter the docker folder, because of permission issue)

To clean up Docker space:

```bash
sudo docker system df # this will provide information
sudo docker system prune --volumes # remove unused images, stopped containers and clean up your Docker install
```

*Source: https://forum.openmediavault.org/index.php?thread/31887-cleaning-up-dockers/*

## Or move docker folder to a media disk

In **System** > **omv-extras** > **Docker**: change docker folder (from default `/var/lib/docker`) to one on a media disk (for example: `/srv/dev-disk-by-uuid-10C4B9617AABC62B/dusty/docker`, to find out the path, you can visit **Storage** > **Shared Folders**).

> ☠️ This way CPU was working 24/7 average 80%. So I moved docker back to default, and bought a bigger SD card + [**copied**](https://www.youtube.com/watch?v=yREOajrnBIM) the OS disk to the new card.

Click Save, and wait.

Install **Portainer** again.

*Source: https://www.youtube.com/watch?v=9h24GbK-cnA*

Remove old folder:

```bash
sudo rm -r <dirname>
# example:
$ sudo rm -r /var/lib/docker/
```

# To transfer OS to a bigger SD card

*Source: https://www.youtube.com/watch?v=yREOajrnBIM*

```bash
pi@raspberrypi:/ $ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    0   1.8T  0 disk
├─sda1        8:1    0   200M  0 part
└─sda2        8:2    0   1.8T  0 part /srv/dev-disk-by-uuid-34F5EE1202469FF7
sdb           8:16   0   1.8T  0 disk
├─sdb1        8:17   0 931.5G  0 part /srv/dev-disk-by-uuid-2a24ad88-d8e0-489b-9d1f-be706f81f4b4
└─sdb2        8:18   0 931.5G  0 part /srv/dev-disk-by-uuid-10C4B9617AABC62B
mmcblk0     179:0    0 119.1G  0 disk
├─mmcblk0p1 179:1    0   256M  0 part /boot
└─mmcblk0p2 179:2    0  14.6G  0 part /
```

*Source: https://elinux.org/RPi_Resize_Flash_Partitions#Manually_resizing_the_SD_card_on_Raspberry_Pi*

# Increase swap to increase memory

To check swap size:

```bash
free -m
```

1. First you need to temporarily stop swapping

   ```bash
   sudo dphys-swapfile swapoff
   ```

2. Modify the swap configuration file.

   ```bash
   sudo nano /etc/dphys-swapfile
   ```

   Navigate to this line:

   ```bash
   CONF_SWAPSIZE=100 # this is in MiB
   ```

   Change the numerical value. (for example 1 GiB = 1024 MiB --> `CONF_SWAPSIZE=1024`)

   Save the file by pressing `CTRL` + `X`, then `Y`, then `ENTER`

3. Re-initialize swap file:

   ```bash
   sudo dphys-swapfile setup
   ```

4. Turn on swapping

   ```bash
   sudo dphys-swapfile swapon
   ```

5. Restart the RasPi

   ```bash
   sudo reboot
   ```

*Source: https://forums.raspberrypi.com/viewtopic.php?t=246029*

*Source: https://pimylifeup.com/raspberry-pi-swap-file/*