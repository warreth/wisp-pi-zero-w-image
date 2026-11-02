# wisp Pi Zero W image

A ready-to-flash Raspberry Pi OS Lite image for the **Raspberry Pi Zero W v1.1** with [wisp](https://github.com/LeoLTM/wisp) preinstalled. It turns the Pi into a Sendspin player for [Music Assistant](https://www.music-assistant.io/).

## Download

[Download the latest image](https://github.com/warreth/wisp-pi-zero-w-image/releases/latest) (`.img.xz`).

## What you need

- Raspberry Pi Zero W v1.1
- USB sound card with 3.5 mm output and a micro-USB OTG adapter
- 2.4 GHz Wi-Fi network
- microSD card of 8 GB or more
- Music Assistant with Sendspin enabled

## Setup

1. Flash the `.img.xz` with Raspberry Pi Imager: **Choose OS → Use custom**.
2. Open the `bootfs` partition and edit **`wisp.conf`**:

   ```ini
   WISP_NAME="Kitchen"
   WISP_SERVER="ws://192.168.1.10:8927/sendspin"
   WISP_DEVICE="auto"
   WISP_VOLUME="80"

   WISP_WIFI_SSID="MyWiFi"
   WISP_WIFI_PASSWORD="MyPassword"
   WISP_WIFI_COUNTRY="BE"
   ```

   - `WISP_SERVER` is the LAN IP of your Music Assistant server, port **8927**, path **`/sendspin`**.
   - Keep the quotes. Do not add comments after a value.
   - Use a 2.4 GHz Wi-Fi network.

3. Eject the card, put it in the Pi and power it.
4. Wait 2 to 5 minutes, then check **`wisp-firstboot.log`** on `bootfs`.
5. Open Music Assistant → **Players**. The player appears with the name from `WISP_NAME`.

## wisp.conf

| Key | Required | Example |
|---|---|---|
| `WISP_NAME` | yes | `"Kitchen"` |
| `WISP_SERVER` | yes | `"ws://192.168.1.10:8927/sendspin"` |
| `WISP_DEVICE` | no | `"auto"` or `"plughw:1,0"` |
| `WISP_VOLUME` | no | `"80"` |
| `WISP_WIFI_SSID` | yes | `"MyWiFi"` |
| `WISP_WIFI_PASSWORD` | yes | `"MyPassword"` |
| `WISP_WIFI_COUNTRY` | no | `"BE"` |
| `WISP_SSH_KEY` | no | `"ssh-ed25519 AAAA..."` |

The config is applied on first boot. To apply changes later, create an empty file named **`wisp-reconfigure`** on `bootfs` and reboot.

## Troubleshooting

**The player does not appear in Music Assistant**

- Check `wisp-firstboot.log` on `bootfs`.
- Check that `WISP_SERVER` ends with **`:8927/sendspin`**.
- Make sure the Pi and Music Assistant are on the same network.
- In Music Assistant, open **Settings → Player Providers → Sendspin** and enable **Allow legacy clients**.

**No sound**

- Find the USB sound card with `aplay -l`.
- Set it explicitly in `wisp.conf`, for example `WISP_DEVICE="plughw:1,0"`.
- Check the mixer with `alsamixer`.
- Put the radio or speaker on **AUX/line-in** and set its volume to about 65 to 75%.

## Notes

- The Pi Zero W has no audio jack, so a USB sound card is required.
- This image targets the Pi Zero W v1.1 (ARMv6).
- SSH is off by default. Add a public key to `WISP_SSH_KEY` to enable key-only SSH.
- `wisp` is an unofficial community client, not part of the Open Home Foundation.
- No DAB tuner or TV audio is included.

## Credits

- [wisp](https://github.com/LeoLTM/wisp), Apache-2.0
- [pi-gen](https://github.com/RPi-Distro/pi-gen), BSD-3-Clause
- [Music Assistant](https://www.music-assistant.io/) and [Sendspin](https://www.sendspin-audio.com/)
- Raspberry Pi OS

## License

MIT for this repository. See `LICENSE` and `NOTICE`.
