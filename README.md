<p align="center">
  <img src="https://github.com/Sanju0910/Sanju0910/blob/main/images/of_logo.png" width="100" height="100" alt="OrangeFox Recovery" />
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/Sanju0910/Sanju0910/blob/main/images/oneplus_logo.png" width="100" height="100" alt="OnePlus" />
</p>

<h1 align="center">OrangeFox Recovery Tree for OnePlus Kona Family</h1>

<p align="center">
  <b>Supported Devices:</b> OnePlus 8 &bull; OnePlus 8 Pro &bull; OnePlus 8T &bull; OnePlus 9R<br/>
  <b>Maintained by:</b> <a href="https://github.com/zenzer0s">zenzer0s</a>
</p>

---

## 📋 Changelog

### 15-Oct-2026 &bull; R12.0 (by zenzer0s)
- Adapted device tree for zenzer0s development
- Enabled standalone prebuilt kernel configuration (Neutron Clang 24.0.0)
- Integrated High-Speed Flash parallel block extraction engine (~40s flashes)
- Added hardware I/O queue and CPU governor boot optimizations
- Added atomic Super group rebuilder for dynamic partitions
- Added automatic recovery persistence across slot switches
- Synced with latest OrangeFox R12.0 base sources

---

## 🤝 Credits
- **ApexLegend007** – Android 12.1 device Tree
- **The-Incognito** – Recovery Trees for OnePlus 8T
- **YumeMichi** – Implementing EROFS and other misc features
- **bigbiff** – Decryption
- **Pranav Talmale** – Decryption
- **Systemad**, **CaptainThrowback**, **mauronofrio** – Original recovery tree
- **TWRP Team** & **OrangeFox Team**
- **Wishmasterflo** – Previous device tree maintenance
- **Qnorsten** – OOS fix

---

## Building (fox_12.1)

```sh
./orangefox_sync.sh --branch 12.1 --path /path/to/fox_12.1      # OrangeFox sync tools
tools/build-fox-12.1.sh /path/to/fox_12.1 [/path/to/out_dir]
```

`tools/build-fox-12.1.sh` copies the tree into `device/oneplus/opkona`, applies
`patches/fox_12.1/*.patch`, and builds `recoveryimage` with these fixes for
problems hit on a fresh sync:

| Problem | Fix |
| :--- | :--- |
| `TARGET_2ND_ARCH_VARIANT` `armv8-2a` is rejected by the 12.1 build system | `armv8-a` in `BoardConfig.mk` |
| `aidl` / `aidl-cpp` segfault while checking `@Backing(type=...)` (uninitialised `found` in `ConstReferenceFinder`) | `patches/fox_12.1/system_tools_aidl-init-found.patch` |
| Build ends at `sed: .../recovery/root/twres/splash.xml: No such file`; a recovery built that way shows a black screen | `patches/fox_12.1/bootable_recovery-fix-theme-copy-abs-path.patch` (ensures `twRes` always resolves to an absolute path) |
| Link steps hang when a system-wide RBE profile points at a dead service | `USE_RBE=0` and all `RBE_*_EXEC_STRATEGY=local` |
