# Page Inspection

When the target platform is not in the known list, inspect the page to find what's actually available before writing variables. See [common-platform-variables.md](common-platform-variables.md) for known patterns across 10+ platforms.

## Step 1: Check meta tags and schema

Open the page and run in the browser console:

```js
JSON.stringify({
  ogTitle: document.querySelector('meta[property="og:title"]')?.content,
  ogImage: document.querySelector('meta[property="og:image"]')?.content,
  ogDescription: document.querySelector('meta[property="og:description"]')?.content,
  author: document.querySelector('meta[name="author"]')?.content,
  published: document.querySelector('meta[property="article:published_time"]')?.content,
  schemaType: document.querySelector('script[type="application/ld+json"]')?.textContent?.substring(0, 500)
}, null, 2)
```

**Done when:** You have identified which of the 4 fields (author, published, description, cover) are available via meta tags or schema.org.

## Step 2: Find selectors for missing fields

For any field that came up null, find the right CSS selector:

```js
// Author
document.querySelector('.author-name')?.textContent
document.querySelector('[rel="author"]')?.textContent

// Date
document.querySelector('time')?.getAttribute('datetime')
document.querySelector('.post-date')?.textContent

// Tags
document.querySelectorAll('.tag-list a')?.length
```

**Done when:** Every field the template will extract has a confirmed selector or schema path that returns a non-null value.

## Step 3: Confirm extraction priority

Climb the extraction ladder: schema first, prompt last.

1. **Schema.org**: most reliable (structured, typed)
2. **Meta**: reliable when present
3. **Selector**: fragile, site-change-prone
4. **Prompt**: LLM extraction, last resort

**Done when:** Every variable uses the strongest available extraction type.
