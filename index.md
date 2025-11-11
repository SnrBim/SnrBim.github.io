---
layout: default
has_toc: false
---

# {% t index.title %}

{% t index.welcome %}

{% t index.guides %}

## {% t index.all_commands %}

{% assign all_docs = site.pages | where_exp:"item", "item.namespace" | sort: "title" %}
{% assign groups = site.pages | where_exp:"item", "item.has_children == true" | sort: "title" %}
{% assign group_titles = groups | map: "title" %}

<div id="filter-container" style="margin-bottom: 20px;">
  <strong>{% t index.filter_by_discipline %}:</strong>
  {% for group in groups %}
    {% assign child_docs = all_docs | where:"parent", group.title %}
    {% assign child_count = child_docs | size %}
    {% assign group_key = group.title | downcase %}
    <label style="margin-left: 10px; user-select: none;">
      <input type="checkbox" class="filter-checkbox" value="{{ group.title }}">
      {% t discipline_short.{{ group_key }} %} ({{ child_count }})
    </label>
  {% endfor %}
  {%- comment -%} Add checkbox for items with non-standard groups {%- endcomment -%}
  {% assign other_docs = "" | split: "" %}
  {% for doc in all_docs %}
    {% unless group_titles contains doc.parent %}
      {% assign other_docs = other_docs | push: doc %}
    {% endunless %}
  {% endfor %}
  {% assign other_count = other_docs | size %}
  <label style="margin-left: 10px; user-select: none;">
    <input type="checkbox" class="filter-checkbox" value="_none_">
    {% t index.other %} ({{ other_count }})
  </label>
</div>

<style>
  .doc-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .doc-item:hover {
    background-color: rgba(128, 128, 128, 0.15);
  }
</style>
<ol id="doc-list">
{% for doc in all_docs %}
  {% if doc.title %}
    {%- assign doc_group = '_none_' -%}
    {%- if group_titles contains doc.parent -%}
      {%- assign doc_group = doc.parent -%}
    {%- endif -%}
    <li data-group="{{ doc_group }}" class="doc-item">
      {% if doc.wip %}
        <span>{{ doc.title }} ({% t index.wipstatus %})</span>
      {% else %}
        <a href="{{ doc.url | relative_url }}">{{ doc.title }}</a>
      {% endif %}
      {% if doc.parent %}
        {% if group_titles contains doc.parent %}
          {% assign parent_key = doc.parent | downcase %}
          <span>{% t discipline_short.{{ parent_key }} %}</span>
        {% else %}
          <span>{{ doc.parent }}</span>
        {% endif %}
      {% endif %}
    </li>
  {% endif %}
{% endfor %}
</ol>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    const checkboxes = document.querySelectorAll('.filter-checkbox');
    const docList = document.getElementById('doc-list');
    const allItems = Array.from(docList.getElementsByTagName('li'));

    function filterDocs() {
      const checkedGroups = Array.from(checkboxes)
        .filter(cb => cb.checked)
        .map(cb => cb.value);

      if (checkedGroups.length === 0) {
        allItems.forEach(item => item.style.display = 'flex');
        return;
      }

      allItems.forEach(item => {
        const itemGroup = item.getAttribute('data-group');
        if (checkedGroups.includes(itemGroup)) {
          item.style.display = 'flex';
        } else {
          item.style.display = 'none';
        }
      });
    }

    checkboxes.forEach(checkbox => {
      checkbox.addEventListener('change', filterDocs);
    });

    // Initial state: show all
    filterDocs();
  });
</script>
