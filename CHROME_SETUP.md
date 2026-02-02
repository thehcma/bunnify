# 🔍 Chrome Search Engine Setup Guide

Configure your bookmark manager as a Chrome built-in search engine for ultra-fast access!

## Method 1: Automatic Setup (Recommended)

### Step 1: Visit the Homepage
1. Make sure the server is running: `./bunnify-server`
2. Open Chrome and visit: `http://127.0.0.1:8000/`
3. Chrome will automatically detect the OpenSearch descriptor

### Step 2: Add to Chrome
Chrome should auto-detect the search engine, but you can verify in:
- `chrome://settings/searchEngines`
- Look for "Bookmarks" in "Site Search" section

## Method 2: Manual Setup (Always Works)

### Step 1: Open Chrome Settings
1. Open Chrome
2. Go to `chrome://settings/searchEngines`
3. Click "Add" under "Site search"

### Step 2: Configure Search Engine

Fill in these fields:

**Search engine:**
```
Bookmarks
```

**Shortcut/Keyword:**
```
b
```
(You can use any keyword you prefer: `bm`, `go`, `link`, etc.)

**URL with %s in place of query:**
```
http://127.0.0.1:8000/%s/
```

### Step 3: Click "Add"

## 🚀 Usage

Once configured, you can use it directly from Chrome's address bar:

### Simple Bookmarks
Type the keyword followed by the bookmark key:
- `b c` → Redirects to Google Calendar
- `b vault` → Redirects to Vault  
- `b slack` → Redirects to Slack
- `b gpt` → Redirects to ChatGPT

### Parameterized Bookmarks

For bookmarks requiring parameters, you'll need to type the full URL:

**Option A: Use the bookmark key + manual parameters**
1. Type: `b pr`
2. You'll get an error about missing `pr_id`
3. Instead, navigate directly: `http://127.0.0.1:8000/pr/?pr_id=12345`

**Option B: Create specific shortcuts for common patterns**

You can create multiple search engines for different patterns:

#### For Pull Requests
- **Search engine:** PR
- **Keyword:** `pr`
- **URL:** `http://127.0.0.1:8000/pr/?pr_id=%s`

Usage: `pr 12345` → Opens PR #12345

#### For Google Search
- **Search engine:** BM Google
- **Keyword:** `bmg`
- **URL:** `http://127.0.0.1:8000/g/?search_terms=%s`

Usage: `bmg django tutorial` → Google search

#### For Commits
- **Search engine:** Commit
- **Keyword:** `cm`
- **URL:** `http://127.0.0.1:8000/cw/?commit_id=%s`

Usage: `cm abc123` → Opens commit

#### For GitHub Search
- **Search engine:** GH Search
- **Keyword:** `ghs`
- **URL:** `http://127.0.0.1:8000/ghs/?search_terms=%s`

Usage: `ghs DatabaseError` → Searches GitHub

## 💡 Pro Tips

### 1. Set as Default (Optional)
You can set "Bookmarks" as your default search engine:
1. Go to `chrome://settings/searchEngines`
2. Find "Bookmarks"
3. Click the three dots (⋮)
4. Select "Make default"

Now just typing `c` in the address bar will redirect to Calendar!

### 2. Multiple Keywords
Create variations for frequently used bookmarks:
- `cal` → `http://127.0.0.1:8000/c/` (Calendar)
- `mail` → `http://127.0.0.1:8000/m/` (Gmail)

### 3. Quick Access Pattern
Best workflow:
- Use short keyword like `b` for general bookmarks
- Create specific keywords for parameterized ones (`pr`, `cm`, etc.)

## 📋 Common Bookmark Keywords to Set Up

Here are suggested search engines to create:

| Keyword | Description | URL Pattern |
|---------|-------------|-------------|
| `b` | General bookmarks | `http://127.0.0.1:8000/%s/` |
| `pr` | Pull requests | `http://127.0.0.1:8000/pr/?pr_id=%s` |
| `cm` | Commits | `http://127.0.0.1:8000/cw/?commit_id=%s` |
| `bmg` | Google via bookmark | `http://127.0.0.1:8000/g/?search_terms=%s` |
| `ghs` | GitHub search | `http://127.0.0.1:8000/ghs/?search_terms=%s` |
| `inc` | Incidents | `http://127.0.0.1:8000/incident/?incident_number=%s` |

## 🔧 Troubleshooting

### Search engine not appearing
- Make sure server is running
- Visit `http://127.0.0.1:8000/` first
- Manually add it using Method 2

### Redirects not working
- Check server is running: `curl http://127.0.0.1:8000/c/`
- Verify the bookmark exists: Visit `http://127.0.0.1:8000/list/`

### OpenSearch XML not loading
- Visit directly: `http://127.0.0.1:8000/opensearch.xml`
- Should see XML with search configuration

## 🎯 Example Workflow

1. **Morning routine:**
   - Type `b c` → Calendar
   - Type `b m` → Email
   - Type `b slack` → Slack

2. **Code review:**
   - Type `pr 54321` → Opens PR #54321
   - Type `b mq` → Opens merge queue

3. **Search:**
   - Type `bmg django models` → Google search
   - Type `ghs authentication bug` → GitHub search

## 🌐 For Production (Optional)

If you deploy this to a server (e.g., `bookmarks.company.com`), update the URLs:

```
http://bookmarks.company.com/%s/
http://bookmarks.company.com/pr/?pr_id=%s
```

---

**Enjoy lightning-fast bookmark access! ⚡**
