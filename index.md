---
layout: default
has_toc: false
---

# {% t index.title %}

{% t index.welcome %}

{% t index.guides %}

## {% t index.all_commands %}

<div id="filter-container" style="margin-bottom: 20px;">
  <strong>{% t index.filter_by_discipline %}:</strong>
  {% assign groups = site.pages | where_exp:"item", "item.has_children == true" | sort: "title" %}
  {% for group in groups %}
    <label style="margin-left: 10px; user-select: none;">
      <input type="checkbox" class="filter-checkbox" value="{{ group.title }}">
      {{ group.title }}
    </label>
  {% endfor %}
</div>

<style>
  .doc-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .doc-item:hover {
    background-color: #f0f0f0;
  }
</style>

{% assign all_docs = site.pages | where_exp:"item", "item.has_children != true" | where_exp:"item", "item.name != 'index.md'" | sort: "title" %}
<ol id="doc-list">
{% for doc in all_docs %}
  {% if doc.title %}
    <li data-group="{{ doc.parent }}" class="doc-item">
      <a href="{{ doc.url | relative_url }}">{{ doc.title }}</a>
      {% if doc.parent %}<span>- {{ doc.parent }}</span>{% endif %}
    </li>
  {% endif %}
{% endfor %}
</ol>
