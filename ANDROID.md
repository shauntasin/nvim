# Android development and review

Start from the DroneControl workspace with `./setup/nvim`, or run `nvim` inside
`dronecontrol`. The launcher sources the existing Android environment and does
not require GitLab authentication. Space is the leader key.

Press **Space A** for the Android action menu or **Space m** for the key guide.

| Shortcut | Action |
|---|---|
| `Space mb` | Build both debug APKs |
| `Space mt` | Run both modules' Gradle unit tests |
| `Space ml` | Run both modules' Android lint with `--continue` |
| `Space mq` | Load saved lint reports into quickfix, errors first |
| `Space mf` / `Space ms` | Find source files / search source |
| `Space mx` / `Space mc` | Find resources and manifests / build configuration |
| `Space mr` | Find the `R.layout.name`, `@layout/name`, string or ID under the cursor |
| `Space mO` | LSP symbol outline |
| `Space md` / `Space mL` | Select a connected device / stream its logcat |
| `Space me` | Use the existing helper to install and open the offline emulator |
| `Space mi` | Open the project in Android Studio |
| `Space mo` / `Space mS` | Reopen task output / cancel the current Gradle task |
| `Space mR` | Toggle review mode for the current buffer |
| `Space mB` | Diff the branch against the locally available `upstream/main` |
| `Space gD` / `Space gH` | Existing working diff / file history |
| `Space gL` | Existing GitLab review actions |
| `Space uC` / `Space uN` | Existing theme picker / cycle themes |

## Development

Java uses JDTLS with Android imports, XML uses LemMinX, and C/JNI uses clangd
and the existing native compilation database. `gd`, `gr`, `K` and `Space ca`
provide definitions, references, hover and code actions. `Space co` organizes
Java imports; the Java extra also supplies extraction/refactoring actions.
XML formatting now uses LemMinX because this installation of Prettier has no
XML parser. Other formatters and language tools are retained.

`:AndroidGradle <tasks and arguments>` runs custom Gradle tasks as separate
arguments, without shell interpolation. For example:

```vim
:AndroidGradle :app:testDebugUnitTest --tests com.example.dronecontrol.ExampleUnitTest
:AndroidGradle :MavsdkServerApp:assembleDebug
```

Commands use the outer DroneControl root even from the nested companion app.
They reuse `setup/build` (JDK 17, Android SDK, GStreamer, two Gradle workers).
Save edited project buffers before starting a task; the command refuses to
build an older disk revision when buffers have unsaved changes. One Gradle
task runs per project at a time. Output stays in a terminal buffer and is saved
after completion under `stdpath('state')/android/`. Recognized Java compiler
errors populate quickfix; use `:copen`, `:cnext`, and `:cprev` to navigate.

The Android file pickers exclude build outputs, Gradle caches, IDE metadata,
and bundled libraries. Existing general-purpose searches remain available.
Resource navigation shows qualified variants and both modules, so the module
path remains visible when names overlap. Framework and dependency resources
without local source definitions require Android Studio or available LSP sources.

## Review

Review mode disables automatic formatting only for the current buffer and
shows `REVIEW` in the statusline. Toggling it off restores the previous buffer
setting. It does not make the file read-only or prevent explicit edits/formatting.

Lint findings come from existing `lint-results-debug.xml` reports. Run
`:AndroidLint` and then `:AndroidLintResults` to refresh them. Lint can exit
nonzero while still producing valid reports; `--continue` lets both modules
run. Findings show severity, module, filename, line and lint rule. Enter jumps
to the location; `:cclose` hides the list. Reports can be stale, and unavailable
dependency lint checks remain a limitation of the project's current lint version.

The branch comparison uses the local upstream reference; it does not fetch or
switch branches. Existing GitLab commands retain their draft-comment and Keychain
authentication configuration. Publishing comments still requires an explicit
action through those commands.

## Appearance and preservation

The default remains `github_dark_high_contrast`. The dashboard, rounded borders,
buffer tabs, compact lint list and statusline follow the active theme. The
statusline shows GCS/MAVSDK, task/review state, and actual attached language
servers on wide terminals. The theme picker now includes the current default
and Catppuccin Mocha alongside all previous choices. Theme changes are per session,
as before. Nerd Fonts are already installed on this Mac.

All existing plugins and keybindings are retained, including ArduPilot, PX4,
Python, C++, C#, Rust, SSH tunnels, TUI launcher, tests, Lazygit and GitLab.
No plugin revisions were upgraded. The Java extra now loads before local plugin
specifications to remove LazyVim's import-order warning.

Before-change config backup:
`/Users/sameer/work/android_review/setup/backups/nvim-20260911-131519/`.
To restore an edited file, copy its counterpart from that backup. Newly added
files are `lua/config/android.lua`, `lua/plugins/android-workflow.lua`,
`lua/plugins/review-ui.lua`, `scripts/android-lint.py`, and this guide. Preserve
any later edits before doing a full restore.

## Verification

`setup/check-android-workflow.py` exercises a real embedded Neovim UI: command
registration, source/resource/build pickers, resource navigation, nested-project
root selection, review-mode restoration, lint locations, and a Gradle build/test
invocation. Evidence and UI captures are in `setup/logs/nvim-*`.

The successful Gradle invocation reused cached unit-test results. Java, XML and
native C language-server attachment and document symbols were checked separately.
XML formatting returned valid edits through LemMinX without applying them to source. Android
device debugging is not configured; use Android Studio for APK/JDWP debugging.
The new emulator/Studio menu actions and live logcat were not exercised during
this configuration change. Existing application-source and build-setting files
were preserved.

References: [Android lint](https://developer.android.com/studio/write/lint),
[Snacks picker](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md).
