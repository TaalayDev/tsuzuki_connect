Place app icons here for Electron Builder:

- `icon.icns` for macOS
- `icon.ico` for Windows
- `icon.png` (512x512 or 1024x1024) for Linux/general

Current config in `package.json` uses:

- `build.icon`: `build/icons/icon.png`
- `build.mac.icon`: `build/icons/icon.icns`
- `build.win.icon`: `build/icons/icon.ico`
- `build.linux.icon`: `build/icons`

After adding files, build with:

```bash
npm run electron:build
```
