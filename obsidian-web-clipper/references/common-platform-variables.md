# Platform Variables & Selectors

Known variable extraction patterns for popular platforms. Use these when filling `REPLACE_ME` tokens in a template.

## YouTube

Schema-rich (`schema:@VideoObject`). Preset `{{content}}` works.

| Field | Variable |
|-------|----------|
| Author | `{{schema:@VideoObject:author\|wikilink}}` |
| Published | `{{schema:@VideoObject:uploadDate\|date:"YYYY-MM-DD"}}` |
| Description | `{{schema:@VideoObject:description}}` |
| Cover | `{{schema:@VideoObject:thumbnailUrl}}` or `{{meta:property:og:image}}` |
| Title | `{{title}}` or `{{schema:@VideoObject:name}}` |
| Duration | `{{schema:@VideoObject:duration\|duration:"H:mm:ss"}}` |

Triggers: URL prefixes for watch pages:
```json
"triggers": ["https://www.youtube.com/", "https://youtube.com/", "https://youtu.be/"]
```

**Transcript:** Requires opening the transcript panel before clipping. Use `{{transcript}}` (preset) or `{{selectorHtml:.ytd-transcript-segment-list-renderer\|markdown}}` (selector). Needs user to click More → Show Transcript first.

## Medium

Preset variables (`{{author}}`, `{{published}}`) work. No JSON-LD schema.

| Field | Variable |
|-------|----------|
| Author | `{{author\|wikilink}}` |
| Published | `{{meta:property:article:published_time\|date:"YYYY-MM-DD"}}` |
| Description | `{{description}}` |
| Cover | `{{meta:property:og:image}}` |
| Tags | `{{selector:a[href^=\"/tag/\"]}}` |
| Reading time | `{{words\|calc:\"/238\"\|round}}` |

Triggers: URL prefix + subdomain regex:
```json
"triggers": [
  "https://medium.com/",
  "/^https:\\/\\/[a-zA-Z0-9-]+\\.medium\\.com\\/.*$/"
]
```

## Substack

`meta:name:author` works. Some pages have `schema:@NewsArticle`.

| Field | Variable |
|-------|----------|
| Author | `{{meta:name:author\|wikilink}}` |
| Published | `{{schema:@NewsArticle:datePublished\|date:"YYYY-MM-DD"}}` or `{{selector:time?datetime\|first}}` |
| Description | `{{description}}` |
| Cover | `{{meta:property:og:image}}` |
| Site | `{{meta:property:og:site_name}}` |

Triggers: URL prefix + subdomain regex:
```json
"triggers": [
  "https://substack.com/",
  "/^https:\\/\\/[a-zA-Z0-9-]+\\.substack\\.com\\/.*$/"
]
```

## GitHub

Three distinct page types with different selectors.

### Repository
| Field | Variable |
|-------|----------|
| Owner | `{{meta:octolytics-dimension-user-login}}` or `{{selector:.author\|first}}` |
| Stars | `{{selector:#repo-stars-counter-star}}` |
| Topics | `{{selector:.topic-tag\|join:", "}}` |
| Description | `{{meta:property:og:description}}` |

Trigger:
```json
"triggers": ["/^https:\\/\\/github\\.com\\/[^\\/]+\\/[^\\/]+\\/?$/"]
```

### Issue
| Field | Variable |
|-------|----------|
| Author | `{{selector:.author\|first}}` |
| Created | `{{selector:relative-time?datetime\|first\|date:"YYYY-MM-DD"}}` |
| Content | `{{selectorHtml:.markdown-body\|markdown}}` |

Trigger:
```json
"triggers": ["/^https:\\/\\/github\\.com\\/[^\\/]+\\/[^\\/]+\\/issues\\/.+$/"]
```

### Release
| Field | Variable |
|-------|----------|
| Author | `{{selector:.author\|first}}` |
| Published | `{{selector:relative-time?datetime\|first\|date:"YYYY-MM-DD"}}` |
| Content | `{{selectorHtml:.markdown-body\|markdown}}` |

Trigger:
```json
"triggers": ["/^https:\\/\\/github\\.com\\/[^\\/]+\\/[^\\/]+\\/releases\\/.+$/"]
```

## Reddit

Custom elements (`shreddit-post`) expose attributes.

| Field | Variable |
|-------|----------|
| Author | `{{selector:shreddit-post?author}}` |
| Title | `{{selector:shreddit-post?post-title}}` |
| Subreddit | `{{selector:shreddit-post?subreddit-prefixed-name}}` |
| Created | `{{selector:shreddit-post?created-timestamp\|date:"YYYY-MM-DD"}}` |
| Score | `{{selector:shreddit-post?score}}` |
| Comments | `{{selector:shreddit-comment-tree}}` |

Trigger:
```json
"triggers": ["/^https:\\/\\/www\\.reddit\\.com\\/r\\/.+\\/comments\\/.+$/"]
```

## Wikipedia

Schema-rich (`schema:@Article`). Content uses a specific content div selector with junk removal.

| Field | Variable |
|-------|----------|
| Title | `{{title}}` |
| Published | `{{schema:@Article:datePublished\|date:"YYYY-MM-DD"}}` |
| Modified | `{{schema:@Article:dateModified\|date:"YYYY-MM-DD"}}` |
| Author | `{{schema:@Article:author\|wikilink}}` |
| Cover | `{{meta:property:og:image}}` |
| Content | `{{selectorHtml:#mw-content-text\|remove_html:(".navbox,.printfooter,.side-box")\|markdown}}` |

Trigger:
```json
"triggers": ["https://en.wikipedia.org/"]
```

## Apple Podcasts

Schema-rich (`schema:@PodcastEpisode`).

| Field | Variable |
|-------|----------|
| Author/Host | `{{schema:@PodcastEpisode:partOfSeries.name\|wikilink}}` |
| Published | `{{schema:@PodcastEpisode:datePublished\|date:"YYYY-MM-DD"}}` |
| Episode | `{{schema:@PodcastEpisode:episodeNumber}}` |
| Duration | `{{schema:@PodcastEpisode:duration\|duration}}` |
| Description | `{{schema:@PodcastEpisode:description}}` |
| Cover | `{{schema:@PodcastEpisode:thumbnailUrl}}` |

Trigger:
```json
"triggers": ["https://podcasts.apple.com/"]
```

## Spotify Podcasts

Show page has og:title, og:description, og:image via oEmbed. Episode pages require login and have no schema.org.

| Field | Variable |
|-------|----------|
| Show name | `{{title}}` (show page) or prompt variable (episode) |
| Description | `{{description}}` (show page) or prompt variable (episode) |
| Cover | `{{meta:property:og:image}}` (show page) |
| Source URL | `{{url}}` |

For best results, use the [Apple Podcasts](#apple-podcasts) equivalent page (schema-rich) instead of Spotify when you need structured podcast metadata.

Triggers:
```json
"triggers": ["https://open.spotify.com/show/", "https://open.spotify.com/episode/"]
```

## X / Twitter

No schema.org. Post text and author extracted from page title via text filters. Only works on individual post pages, not feed.

| Field | Variable |
|-------|----------|
| Author | `{{title\|split:" on X: "\|first}}` |
| Handle | `{{url\|split:"/"\|slice:3,-2}}` |
| Post text | `{{title\|split:" on X: "\|last\|slice:1,-5\|split:" https://t.co"\|first}}` |
| Published | `{{published}}` |
| Images | `{{selector:img[alt="Image"]?src\|image:""}}` |
| First image | `{{selector:img[alt="Image"]?src\|first}}` |

Trigger (individual post):
```json
"triggers": ["/^https:\\/\\/x\\.com\\/[A-Za-z0-9_]+\\/status\\/\\d+$/"]
```

## Threads

No community template available yet. Meta tags only. Use prompt variables or general selectors.

| Field | Variable |
|-------|----------|
| Description | `{{meta:property:og:description}}` |
| Cover | `{{meta:property:og:image}}` |

Trigger:
```json
"triggers": ["https://www.threads.net/"]
```

## Hacker News

| Field | Variable |
|-------|----------|
| Title | `{{title}}` |
| Score | `{{selector:.score}}` |
| Author | `{{selector:.hnuser\|first}}` |
| Comments | `{{selectorHtml:.comment-tree\|markdown}}` |

Trigger:
```json
"triggers": ["https://news.ycombinator.com/"]
```

## Perplexity

SPA, no schema.org. Meta tags only. Use prompt variables for content extraction.

| Field | Variable |
|-------|----------|
| Description | `{{meta:property:og:description}}` |
| Source URL | `{{url}}` |

Consider using `context` to scope Interpreter input.

## Documentation sites (MDN, ReadTheDocs, etc.)

Generic selectors that work on most doc sites:

| Field | Variable |
|-------|----------|
| Title | `{{selector:h1\|first}}` |
| Body | `{{selectorHtml:article\|markdown}}` |
| Fallback body | `{{selectorHtml:main,\ .content,\ .markdown-body,\ .documentation\|markdown}}` |

## General selector patterns

For unfamiliar sites, try these fallback patterns:

| Field | CSS selector |
|-------|-------------|
| Title | `h1` or `[itemprop="headline"]` or `meta[property="og:title"]?content` |
| Author | `[rel="author"]` or `a[href*="/@"]` or `meta[name="author"]?content` |
| Date | `time?datetime` or `[itemprop="datePublished"]?content` or `meta[property="article:published_time"]?content` |
| Body | `article` or `.post-content` or `main` or `.entry-content` |
| Tags | `[rel="tag"]` or `.tag a` or `a[href*="/tag/"]` |
| Cover | `meta[property="og:image"]?content` or `[itemprop="image"]?src` |
| Description | `meta[property="og:description"]?content` or `meta[name="description"]?content` |
