#!/usr/bin/env python3

import json
import subprocess
from typing import Dict, List, Optional
from pathlib import Path

def generate_markdown(rule_json: Dict) -> str:
    """
    Generates Markdown documentation for the given rule JSON.
    """
    markdown = f"# {rule_json['id']['name']}\n\n"
    item = rule_json['item']
    if item['docs']:
        markdown += item['docs']['summary'] + "\n\n"

    markdown += f"```\n{rule_json['id']['name']}(\n"

    for param in item['params']:
        if param["kind"] == "only_named_after":
            continue
        if param['name'].startswith("_"):
            continue

        markdown += f"    {param['name']}: {param['type']}"
        if param['default_value']:
            markdown += f" = {param['default_value']}"
        markdown += ",\n"

    markdown += ")\n```\n\n"

    docs = item['docs']
    if docs:
        details = docs['details']
        if details:
            markdown += details + "\n\n"

    markdown += "## Parameters\n\n"

    for param in item['params']:
        if param["kind"] == "only_named_after":
            continue

        docs = param.get("docs")
        if docs:
            markdown += f"### `{param['name']}`\n\n"
            markdown += f"{docs['summary']}\n\n"
            if param['docs']['details']:
                markdown += f"{param['docs']['details']}\n\n"
            markdown += "\n"

    return markdown


def process(rule_json):
    markdown = ''

    for entry in sorted(rule_json, key=lambda e: e['id']['name']):
        if entry['id']['name'] == "native":
            continue
        if entry['item']['kind'] != "function":
            continue
        markdown += generate_markdown(entry)

    return markdown


def main():
    doc_json = subprocess.check_output(["buck2", "docs", "starlark", "//docs:rules.bzl"])

    rule_json = json.loads(doc_json)

    markdown = process(rule_json)

    markdown += "# Toolchain Rules\n\n"
    markdown += "Use these in the `toolchains` cell of your project to define toolchain targets.\n\n"

    toolchain_rules = [
        f"//toolchains:{bzl_file.name}"
        for bzl_file in Path("toolchains").glob("*.bzl")
    ]

    doc_json = subprocess.check_output(["buck2", "docs", "starlark"] + toolchain_rules)

    rule_json = json.loads(doc_json)

    rule_json = [
        item
        for item in rule_json if item['id']['name'].endswith("toolchain")
    ]
    markdown += process(rule_json)

    print(markdown)


if __name__ == '__main__':
    main()
