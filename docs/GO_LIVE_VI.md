# devterm — Checklist Go Live (Tiếng Việt)

> Làm theo thứ tự từ trên xuống dưới. Mỗi bước phải xong mới làm bước tiếp theo.

---

## GIAI ĐOẠN 1 — Hoàn thiện kỹ thuật (Làm trước, bắt buộc)

### 1.1 Thay placeholder `c0x12c`

Ba file cần sửa — tìm `c0x12c` và thay bằng GitHub username thật:

```bash
# Kiểm tra tất cả chỗ cần sửa
grep -rn "c0x12c" .
```

| File | Chỗ cần sửa |
|------|------------|
| `install.sh` | `DEVTERM_REPO` và `DEVTERM_ARCHIVE` (2 chỗ) |
| `README.md` | curl command, git clone command, CI badge (3 chỗ) |
| `CONTRIBUTING.md` | Link GitHub (nếu có) |

### 1.2 Chạy test suite lần cuối

```bash
# Cài bats-core nếu chưa có
brew install bats-core      # macOS
# hoặc: sudo apt install bats   # Ubuntu

# Chạy toàn bộ tests
bats tests/

# Kết quả mong đợi: 112 tests passed, 0 failed
```

Nếu có test fail → fix trước khi tiếp tục.

### 1.3 ShellCheck toàn bộ scripts

```bash
brew install shellcheck      # macOS
# hoặc: sudo apt install shellcheck   # Ubuntu

shellcheck lib/*.sh setup.sh install.sh
```

Không được có lỗi WARNING hoặc ERROR. Chỉ bỏ qua SC1090/SC1091 (source dynamic path).

### 1.4 Test thủ công trên máy thật

Chạy trên một user account sạch (hoặc máy ảo):

```bash
# Clone và chạy
git clone https://github.com/c0x12c/devterm-kit.git
cd devterm
./setup.sh --theme mocha

# Verify: mở terminal mới — Starship prompt + Catppuccin màu hiện đúng không?
# Verify: chạy ls → eza icons hiện không?
# Verify: chạy gs → git status hoạt động không?
# Verify: ./setup.sh --doctor → tất cả ✓ không?
```

Test thêm case p10k migration:

```bash
# Test case: máy đã có p10k
echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
touch ~/.p10k.zsh
./setup.sh --theme macchiato
# Verify: thông báo "Detected Powerlevel10k" hiện không?
# Verify: .zshrc được backup không?
# Verify: terminal mới dùng Starship, không phải p10k?
# Verify: ./setup.sh --doctor → hiện p10k leftovers section không?
```

---

## GIAI ĐOẠN 2 — Tạo demo GIF (Quan trọng nhất cho viral)

### 2.1 Cài VHS

```bash
brew install vhs charmbracelet/tap/vhs
```

### 2.2 Chuẩn bị terminal sạch để record

Trước khi record, cần có một terminal với Catppuccin Mocha đã setup xong để demo "after" state trông đẹp. Cách dễ nhất: dùng chính máy của mình sau khi đã chạy devterm.

### 2.3 Record demo

Script VHS mẫu đã có tại `docs/demo.tape`. Chỉnh lại timing cho phù hợp rồi chạy:

```bash
vhs docs/demo.tape
# Output: docs/demo.gif
```

**GIF cần thể hiện:**
1. Terminal trống (before state)
2. Chạy `./setup.sh` → thấy output màu (✓ steps)
3. Terminal mới với Starship prompt + Catppuccin
4. Chạy `ls` → eza icons
5. Chạy `./setup.sh --doctor` → all green

**Specs:** Tối đa 15 giây, loop. Kích thước 1200×600px.

### 2.4 Thêm GIF vào README.md

Mở `README.md`, tìm dòng:
```
> 📸 _Demo GIF coming soon — install VHS and run `vhs docs/demo.tape` to generate_
```

Thay bằng:
```markdown
![devterm demo](docs/demo.gif)
```

---

## GIAI ĐOẠN 3 — Setup GitHub repository

### 3.1 Push code lên GitHub

```bash
git add -A
git commit -m "v2.0: Starship + Catppuccin, cross-platform macOS & Linux"
git push origin main
```

### 3.2 Cấu hình repo trên GitHub (mất 5 phút)

Vào **Settings** của repo trên GitHub:

**Description** (bắt buộc):
```
One command to a senior dev's terminal — Starship + Catppuccin + Oh My Zsh on macOS & Linux
```

**Topics** (bắt buộc — giúp được discover):
```
terminal  zsh  dotfiles  catppuccin  starship  oh-my-zsh
developer-tools  macos  linux  shell-script  automation  nerd-fonts
```

**Website**: Link GitHub Pages nếu có (`https://c0x12c.github.io/devterm-kit`)

### 3.3 Tạo Release v2.0.0 trên GitHub

Vào **Releases** → **Draft a new release**:

- Tag: `v2.0.0`
- Title: `v2.0.0 — Starship + Catppuccin, macOS & Linux`
- Description:

```markdown
## Highlights

- **Migrated from Powerlevel10k to Starship** — p10k is effectively unmaintained; Starship is faster, cross-shell, and actively developed
- **Linux support added** — Ubuntu, Arch, Fedora (apt / pacman / dnf)
- **All 4 Catppuccin flavors** — Mocha, Macchiato, Frappé, Latte for Starship + iTerm2
- **`--doctor` command** — health check to diagnose your devterm setup
- **Safe p10k migration** — detects existing p10k and guides you through the transition
- **BATS test suite** — 112 tests covering all modules

## One-liner install

\`\`\`bash
curl -fsSL https://raw.githubusercontent.com/c0x12c/devterm-kit/main/install.sh | bash
\`\`\`
```

### 3.4 Nhờ bạn bè star repo (social proof ban đầu)

**Mục tiêu: 10 stars trước khi post lên Reddit.**

Nhắn tin cho 5–10 người quen là developer, nhờ họ vào star repo. Stars ban đầu quan trọng để Reddit/HN thấy project có traction. Đừng bỏ qua bước này.

---

## GIAI ĐOẠN 4 — Launch (Thứ tự quan trọng)

### 4.1 Post lên r/unixporn (Thứ 3 hoặc Thứ 4, 9 AM UTC)

URL: https://www.reddit.com/r/unixporn/

**Tiêu đề:**
```
[macOS/Linux] One command to Starship + Catppuccin — devterm sets up your whole terminal in 30 seconds
```

**Nội dung post:**

```markdown
I built devterm because I was tired of spending hours setting up a new machine's terminal.

**What it does:** One command installs and configures:
- Starship prompt (Rust-based, fast, cross-shell)
- Catppuccin color scheme — all 4 flavors
- Oh My Zsh with autosuggestions + syntax highlighting
- eza, bat, fzf, zoxide
- MesloLGS NF font

**Works on macOS and Linux.**

[PASTE GIF HERE]

\```bash
curl -fsSL https://raw.githubusercontent.com/c0x12c/devterm-kit/main/install.sh | bash
\```

GitHub: https://github.com/c0x12c/devterm-kit
```

> ⚠️ **Lưu ý:** r/unixporn yêu cầu chia sẻ dotfiles/source trong vòng 12 giờ, nếu không bài bị xóa. GitHub link là đủ.

Ở lại comment section 2–3 tiếng sau khi đăng để reply.

### 4.2 Post lên r/commandline (Ngay hôm sau)

URL: https://www.reddit.com/r/commandline/

Cùng nội dung nhưng nhấn mạnh phần kỹ thuật hơn: BATS tests, `--doctor` command, idempotency, cross-platform.

### 4.3 Hacker News — Show HN (Thứ 3 hoặc 4, 9 AM giờ Mỹ EST)

URL: https://news.ycombinator.com/submit

**Tiêu đề:**
```
Show HN: devterm – one command to Starship + Catppuccin terminal setup on macOS/Linux
```

Reply ngay vào comment của mình sau khi đăng:
```
Built this because setting up a new machine's terminal from scratch takes 2–3 hours.
Interesting decisions I made:
- Starship instead of Powerlevel10k (p10k hasn't had a release in 2+ years)
- BATS tests on bash scripts (unusual, but caught several real bugs)
- --doctor command for diagnosing broken setups
- Detects and migrates existing p10k installations gracefully
```

### 4.4 Viết bài dev.to (Tuần 1–2)

**Tiêu đề bài:** "Why I replaced Powerlevel10k with Starship in my terminal setup tool"

Nội dung: kể câu chuyện technical — p10k life support status, tại sao chọn Starship, cách build cross-platform bash scripts, BATS testing. Developer thích đọc "lessons learned" hơn là marketing.

**Tags:** `terminal` `devtools` `zsh` `opensource`

Cross-post lên Hashnode.

### 4.5 Mở issue trên Catppuccin (Tuần 2)

URL: https://github.com/catppuccin/catppuccin/issues

Mở issue xin được list là một community integration. Họ có 50K+ stars và actively list các tool trong ecosystem. Nếu được accept → free discovery từ toàn bộ Catppuccin community.

---

## GIAI ĐOẠN 5 — Chuẩn bị đón contributors

### 5.1 Tạo sẵn "Good First Issues" trên GitHub

Tạo các issue sau trước khi launch để developers có chỗ contribute:

```
[good first issue] Add Ghostty terminal color theme support
[good first issue] Add WezTerm config generation
[good first issue] Add --update flag to pull latest devterm
[enhancement] Fish shell support
[enhancement] Windows WSL2 support
[enhancement] devterm update command
```

### 5.2 Verify CI hoạt động

Vào **Actions** tab trên GitHub. Sau lần push đầu tiên, CI phải chạy và pass:
- ✓ shellcheck
- ✓ syntax-check
- ✓ validate-structure
- ✓ unit-tests (BATS)

Nếu CI fail → fix ngay. Repo có CI badge đỏ sẽ mất uy tín với contributors.

---

## Tóm tắt thứ tự ưu tiên

```
Tuần này:
  □ 1. Thay c0x12c
  □ 2. bats tests/ — pass 100%
  □ 3. shellcheck — clean
  □ 4. Test thủ công trên máy thật (kể cả case p10k migration)
  □ 5. Tạo GIF demo với VHS

Sau khi có GIF:
  □ 6. Push + git tag v2.0.0
  □ 7. Cấu hình GitHub repo (description + topics)
  □ 8. Nhờ 10 người star
  □ 9. Tạo Release v2.0.0
  □ 10. Post r/unixporn Thứ 3 9 AM UTC
  □ 11. Post HN Show HN Thứ 3/4 9 AM ET
  □ 12. Viết bài dev.to

Tuần 2:
  □ 13. Mở issue Catppuccin ecosystem
  □ 14. Tạo Good First Issues cho contributors
```

---

## Câu hỏi thường gặp khi launch

**"curl | bash không an toàn?"**
→ Trả lời: Đúng, đây là tradeoff. Cách an toàn hơn là `git clone` (cũng có trong README). Với devterm, toàn bộ code mở, CI pass, không có external dependencies ẩn.

**"Khác gì dotfiles script bình thường?"**
→ Trả lời: Idempotent (safe re-run), BATS tested, `--doctor` command, cross-platform, Starship config built-in, p10k migration handled.

**"Tại sao không dùng Ansible/Chef?"**
→ Trả lời: Bash zero-dependency. Không cần cài gì trước, không cần Python/Ruby. Chạy được trên máy mới hoàn toàn.
