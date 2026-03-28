# summernote-flutter-fix

A self-hosted version of `summernote.html` from the [html_editor_enhanced](https://github.com/tneotia/html-editor-enhanced) Flutter package, patched to fix **YouTube Error 153** on iOS WKWebView.

## What's Fixed

The original package loads `summernote.html` from local app assets (`file:///`), which means no valid HTTP `Referer` header is sent. After YouTube's July 2025 policy enforcement, this causes **Error 153 (embedder.identity.missing.referrer)** for all YouTube iframes inside the editor.

This repo adds one line to `summernote.html`:

```html
<meta name="referrer" content="strict-origin-when-cross-origin" />
```

When loaded from a real HTTPS origin (GitHub Pages), the browser automatically sends `Referer: https://kiennt-commnia.github.io` — which YouTube accepts.

## Files

| File | Description |
|------|-------------|
| `summernote.html` | Patched editor HTML (with plugins support) |
| `summernote-no-plugins.html` | Patched editor HTML (no plugins, lighter) |
| `jquery.min.js` | jQuery — copy from pub cache (see below) |
| `summernote-lite.min.js` | Summernote JS — copy from pub cache |
| `summernote-lite.min.css` | Summernote CSS — copy from pub cache |
| `summernote-lite-dark.min.css` | Summernote dark CSS — copy from pub cache |
| `plugins/` | Summernote plugins folder — copy from pub cache |

## Setup

### Step 1: Copy asset files from your pub cache

```bash
# macOS/Linux - adjust version number as needed
PUB_CACHE=~/.pub-cache/hosted/pub.dev/html_editor_enhanced-2.7.1/lib/assets

cp $PUB_CACHE/jquery.min.js .
cp $PUB_CACHE/summernote-lite.min.js .
cp $PUB_CACHE/summernote-lite.min.css .
cp $PUB_CACHE/summernote-lite-dark.min.css .
cp -r $PUB_CACHE/plugins .
```

### Step 2: Enable GitHub Pages

Go to your repo → **Settings → Pages → Source: GitHub Actions**

After pushing, your files will be live at:
```
https://kiennt-commnia.github.io/summernote-flutter-fix/summernote.html
```

### Step 3: Use in your Flutter app

```dart
HtmlEditor(
  controller: controller,
  htmlEditorOptions: HtmlEditorOptions(
    filePath: 'https://kiennt-commnia.github.io/summernote-flutter-fix/summernote.html',
  ),
)
```

## How It Works

```
BEFORE (broken)
  WKWebView loads: file:///var/containers/.../summernote.html
    └── origin: null → YouTube iframe Referer: null → Error 153 ❌

AFTER (fixed)
  WKWebView loads: https://kiennt-commnia.github.io/.../summernote.html
    └── origin: https://kiennt-commnia.github.io
          └── YouTube iframe Referer: https://kiennt-commnia.github.io → ✅
```

## Notes

- All `<!--headString-->`, `<!--summernoteScripts-->`, `<!--darkCSS-->` placeholders are preserved exactly — the Flutter package requires these to inject its JS bridge and plugin code.
- The JS/CSS asset files are **not included** in this repo due to size. You must copy them from your pub cache (see Step 1 above).
- This fix works for both `summernote.html` (with plugins) and `summernote-no-plugins.html`.
