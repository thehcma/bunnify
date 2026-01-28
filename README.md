# Bunnify 🐰

A powerful Django-based bookmark manager and URL shortcut system with advanced command palette, Chrome integration, and real-time GitHub Copilot code reviews.

## Features

### Core Functionality
- **Smart Search**: Type "pr 12345" or "g search terms" directly in your browser
- **Dynamic URL Redirects**: Navigate to `/<key>/` to be redirected to the bookmark's URL
- **Parameter Substitution**: Supports URLs with placeholders (e.g., `#{pr_id}`, `#{search_terms}`)
- **JSON Schema Validation**: Validates the bookmark JSON file before loading
- **Web Interface**: Browse all bookmarks with search and filtering

### Command Palette (`/cmd/`)
- **Tab Completion**: Auto-complete shortcuts and commands
- **Command History**: Navigate previous commands with ↑/↓ arrows
- **Filtered History**: Type a prefix and use arrows to filter history
- **Reverse Search (Ctrl-R)**: Bash-style interactive history search
- **Special Commands**: Built-in shortcuts like `h` (help) to list all bookmarks
- **Autocomplete Suggestions**: Real-time suggestions as you type
- **Opens in New Tab**: All commands open in new tabs for quick workflows

### Chrome Integration
- **OpenSearch API**: Add Bunnify as a search engine in Chrome
- **Address Bar Suggestions**: Auto-complete suggestions in Chrome's omnibox
- **Seamless Navigation**: Type shortcuts directly in the address bar

### GitHub Copilot Integration
- **PR Code Reviews**: Use the `rpr` shortcut to request Copilot reviews on PRs
- **Streaming Responses**: Real-time progress updates during review generation
- **Private Reviews**: Reviews displayed in-app without public PR comments

### Infrastructure
- **Dual-Stack Networking**: IPv4 and IPv6 support (accessible via 127.0.0.1, [::1], or localhost)
- **Comprehensive Logging**: Detailed logs with PID/function/line numbers to `/tmp/bunnify.log`
- **File Watching**: Auto-reload bookmarks when JSON file changes
- **Daemonization**: Background process management with proper cleanup

## Quick Start

### 1. Clone and Setup

```bash
# Clone the repository
git clone https://github.com/thehcma/bunnify.git
cd bunnify

# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run migrations
./venv/bin/python manage.py migrate

# Create your bookmarks file
mkdir -p ~/work/bunnify
cp bunnify.json.example ~/work/bunnify/bunnify.json
# Edit ~/work/bunnify/bunnify.json with your bookmarks

# Load bookmarks
./venv/bin/python manage.py load_bookmarks
```

### 2. Start the Server

**Always use the start script** to ensure proper setup:
```bash
./start
```

This will:
- Start the Django server on port 8000 (dual-stack IPv4/IPv6 binding)
- Start the bookmark file watcher for auto-reload
- Daemonize both processes
- Show URLs for access

**Logging options:**
```bash
./start --console          # Log to console instead of file
./start --log-level DEBUG  # Change log level
./start --help            # Show all options
```

**Note:** The start script uses dual-stack binding (`[::]:8000`), making the server accessible via IPv4, IPv6, and localhost.

### 3. Access Bunnify

The server is accessible at:
- `http://127.0.0.1:8000/` (IPv4)
- `http://[::1]:8000/` (IPv6)
- `http://localhost:8000/` (auto)

### 4. Chrome Browser Integration

**Set up Bunnify as a search engine in Chrome:**

1. Visit `http://127.0.0.1:8000/` (or `http://[::1]:8000/` for IPv6) while the server is running
2. Go to Chrome Settings → Search engine → Manage search engines
3. Find "Bunnify" (added automatically via OpenSearch) or add manually:
   - **Search engine:** Bunnify
   - **Shortcut:** `s` (or any letter you prefer)
   - **URL (IPv4):** `http://127.0.0.1:8000/search/?q=%s`
   - **URL (IPv6):** `http://[::1]:8000/search/?q=%s`
   - **URL (localhost):** `http://localhost:8000/search/?q=%s`
4. Save

**Note:** Choose the URL that matches how you're running the server:
- Use IPv4 (`127.0.0.1`) if running with `127.0.0.1:8000`
- Use IPv6 (`[::1]`) if you prefer IPv6-only access
- Use `localhost` if running with `[::]:8000` (dual-stack) - Chrome will auto-select

**Optional: Set as Default Search Engine**
- Click the three dots next to "Bunnify" and select "Make default"
- Now you can type bookmarks directly without any prefix!

## Usage

### Command Palette (Recommended)

Visit `http://127.0.0.1:8000/cmd/` for the enhanced command palette:

**Features:**
- **Type** to filter shortcuts with auto-complete
- **Tab** to complete suggestions
- **↑/↓** to navigate command history (with prefix filtering)
- **Ctrl-R** for bash-style reverse search through history
- **Enter** to execute (opens in new tab)
- **Esc** to cancel

**Examples:**
- Type `pr` then ↑ to see recent PR commands
- Type `pr` and ↑ to cycle through filtered history
- Press Ctrl-R and type `12345` to find commands with that PR number

### Browser Address Bar (with Chrome Integration)

Type in Chrome's address bar:
- `s pr 12345` → Opens PR #12345
- `s g django tutorial` → Google search for "django tutorial"
- `s vault` → Opens Vault
- `s h` → Shows all bookmarks

### Direct URL Access

**Simple redirects:**
- `http://127.0.0.1:8000/c/` → Google Calendar
- `http://127.0.0.1:8000/vault/` → Vault

**Parameterized redirects:**
- `http://127.0.0.1:8000/pr/?pr_id=12345` → PR #12345
- `http://127.0.0.1:8000/g/?search_terms=django+tutorial` → Google search

**Special endpoints:**
- `http://127.0.0.1:8000/list/` → Browse all bookmarks
- `http://127.0.0.1:8000/cmd/` → Command palette
- `http://127.0.0.1:8000/review-pr/?pr=12345` → Request Copilot review

## JSON File Format

The application expects a JSON file with the following structure:

```json
{
    "key": {
        "description": "Description of the bookmark",
        "url": "https://example.com/path",
        "old-url": "https://old-url.com/path"  // optional
    }
}
```

### Parameterized URLs

URLs can contain placeholders in the format `#{parameter_name}`:

```json
{
    "pr": {
        "description": "Show a pull request",
        "url": "https://github.com/org/repo/pull/#{pr_id}"
    },
    "g": {
        "description": "Google search",
        "url": "https://www.google.com/search?q=#{search_terms}"
    }
}
```

## Project Structure

```
bunnify/
├── bookmarks/
│   ├── management/
│   │   └── commands/
│   │       └── load_bookmarks.py    # Command to load JSON data
│   ├── templates/
│   │   └── bookmarks/
│   │       ├── base.html            # Base template
│   │       ├── index.html           # Home page
│   │       ├── list.html            # Bookmark list
│   │       └── opensearch.xml       # OpenSearch descriptor
│   ├── models.py                    # Bookmark model
│   ├── views.py                     # View logic (includes search_redirect)
│   └── urls.py                      # URL routing
├── bunnify/
│   ├── settings.py                  # Django settings
│   └── urls.py                      # Main URL config
├── venv/                            # Virtual environment
├── manage.py                        # Django management script
└── requirements.txt                 # Python dependencies
```

## Schema Validation

The `load_bookmarks` command validates the JSON file against a schema that ensures:
- All keys match the pattern `^[a-zA-Z0-9_]+$`
- Each bookmark has required fields: `description` and `url`
- Optional fields: `old-url` or `oldurl`
- **Reserved keywords** "h" and "help" are blocked and will cause an error

## API Endpoints

- `GET /` - Home page with usage instructions
- `GET /search/?q=<query>` - Smart search endpoint (e.g., "pr 12345")
- `GET /list/` - List all bookmarks with search
- `GET /<key>/` - Redirect to bookmark URL
  - With parameters: `GET /<key>/?param1=value1&param2=value2`
- `GET /opensearch.xml` - OpenSearch descriptor for browser integration

## Reserved Keywords

The following keywords are reserved and cannot be used as bookmark keys:
- `h` - Shows all bookmarks (help shortcut)
- `help` - Shows all bookmarks (help shortcut)

## Development

### Running Tests

The project includes comprehensive smoke tests that verify core functionality.

**Run all tests:**
```bash
./test
```

**Run specific test suite:**
```bash
# Run only smoke tests
./test bookmarks.tests.SmokeTests

# Run with verbose output
./test -v 2

# Run a specific test
./test bookmarks.tests.SmokeTests.test_search_with_parameter
```

**Test coverage includes:**
- Page loading (index, list, command palette, OpenSearch XML)
- Search redirects with/without parameters
- Parameter substitution in URLs
- Direct bookmark redirects
- Help command functionality
- API suggestions endpoint
- Model methods and ordering
- Error handling (404, 400)

### Creating a Superuser

```bash
./venv/bin/python manage.py createsuperuser
```

Then access the admin interface at `http://127.0.0.1:8000/admin/`

### Reloading Bookmarks

To reload bookmarks after updating your JSON file:

```bash
./venv/bin/python manage.py load_bookmarks
```

This will clear existing bookmarks and load fresh data.

## Technologies Used

- **Django 6.0**: Web framework
- **jsonschema**: JSON validation
- **SQLite**: Database (default Django DB)
- **Python 3.13**: Programming language with type hints
- **pathlib**: Modern file path handling
- **OpenSearch**: Browser integration protocol
- **localStorage**: Client-side command history
- **Streaming responses**: Real-time progress updates

## Project Structure

```
bunnify/
├── bookmarks/              # Main Django app
│   ├── management/
│   │   └── commands/      # Management commands
│   │       ├── load_bookmarks.py    # Load bookmarks from JSON
│   │       └── watch_bookmarks.py   # Auto-reload on file changes
│   ├── templates/         # HTML templates
│   │   └── bookmarks/
│   │       ├── cmd.html              # Command palette
│   │       ├── list.html             # Browse bookmarks
│   │       ├── opensearch.xml        # Chrome integration
│   │       └── copilot_review.html   # Copilot review UI
│   ├── models.py          # Bookmark model
│   ├── views.py           # View functions
│   └── urls.py            # URL routing
├── bunnify/               # Django project settings
│   ├── settings.py        # Configuration with logging
│   └── urls.py            # Root URL configuration
├── scripts/               # Helper scripts
│   ├── get_copilot_review.sh        # Copilot review helper
│   └── request_copilot_review.sh    # Legacy review script
├── manage.py              # Django management script
├── start                  # Server startup script
├── requirements.txt       # Python dependencies
└── bunnify.json.example   # Example bookmark configuration
```

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**thehcma** - [GitHub](https://github.com/thehcma)

## Acknowledgments

- Built with Django and modern Python features
- Inspired by browser bookmark management needs
- Enhanced with GitHub Copilot integration for code reviews

## Tips & Tricks

1. **Quick Access**: Set Bunnify as your default search engine for the fastest access
2. **Discover Bookmarks**: Type `h` to quickly see all available shortcuts
3. **Parameterized Shortcuts**: For frequently used parameterized bookmarks (like `pr`), you can create individual Chrome search engines for even faster access
4. **Auto-start**: Consider setting up a system service or startup script to run the server automatically

## Troubleshooting

### Server won't start
```bash
# Make sure you're in the right directory
cd ~/work/ai/bunnify

# Use the start script
./start
```

### Bookmarks not loading
```bash
# Check if the JSON file exists and is valid
cat ~/work/bunnify/bunnify.json

# Reload bookmarks
./venv/bin/python manage.py load_bookmarks
```

### Chrome not detecting Bunnify
1. Make sure the server is running at `http://127.0.0.1:8000/`
2. Visit the homepage to trigger OpenSearch detection
3. Manually add the search engine with URL: `http://127.0.0.1:8000/search/?q=%s`

## License

This project is created for managing bookmarks efficiently. 🐰✨
