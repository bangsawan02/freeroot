# Foxytoux (proot Ubuntu)

Self-contained Ubuntu 20.04 rootfs running via proot. No setup needed.

## Usage

```bash
git clone https://github.com/bangsawan02/freeroot.git
cd freeroot
chmod +x run.sh
./run.sh
```

On first run it extracts `rootfs.tar.gz` (once), then launches proot.
Subsequent runs skip extraction.

## Run a command

```bash
./run.sh /bin/bash -c "cat /etc/os-release"
```
