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

{% include ribbon.html %}

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
  {%- comment -%} Checkbox for commands not belonging to any discipline group {%- endcomment -%}
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

<ol id="doc-list">
{% for doc in all_docs %}
  {% if doc.title %}
    {%- assign doc_group = '_none_' -%}
    {%- if group_titles contains doc.parent -%}
      {%- assign doc_group = doc.parent -%}
    {%- endif -%}
    <li data-group="{{ doc_group }}" data-slug="{{ doc.namespace }}">
      {% if doc.wip %}

        <div class="doc-item">
          <div class="doc-title">
            <span>{{ doc.title }} ({% t index.wipstatus %})</span>
          </div>
          {% if doc.parent %}
            {% if group_titles contains doc.parent %}
              {% assign parent_key = doc.parent | downcase %}
              <span>{% t discipline_short.{{ parent_key }} %}</span>
            {% else %}
              <span>{{ doc.parent }}</span>
            {% endif %}
          {% endif %}
        </div>

      {% elsif doc.description and doc.description != "" or doc.description_es and doc.description_es != "" %}

        <details>
          <summary class="doc-item">
            <div class="doc-title">
              <a href="{{ doc.url | relative_url }}">{{ doc.title }}</a>
            </div>
            {% if doc.parent %}
              {% if group_titles contains doc.parent %}
                {% assign parent_key = doc.parent | downcase %}
                <span>{% t discipline_short.{{ parent_key }} %}</span>
              {% else %}
                <span>{{ doc.parent }}</span>
              {% endif %}
            {% endif %}
          </summary>
          <div class="doc-description">
            {% assign current_description = doc.description %}
            {% if site.lang == 'es' and doc.description_es and doc.description_es != "" %}
              {% assign current_description = doc.description_es %}
            {% endif %}
            {{ current_description | markdownify }}
          </div>
        </details>

      {% else %}

        <div class="doc-item">
          <div class="doc-title">
            <a href="{{ doc.url | relative_url }}">{{ doc.title }}</a>
          </div>
          {% if doc.parent %}
            {% if group_titles contains doc.parent %}
              {% assign parent_key = doc.parent | downcase %}
              <span>{% t discipline_short.{{ parent_key }} %}</span>
            {% else %}
              <span>{{ doc.parent }}</span>
            {% endif %}
          {% endif %}
        </div>

      {% endif %}
    </li>
  {% endif %}
{% endfor %}
</ol>

<script src="{{ '/assets/js/commands.js' | relative_url }}"></script>
