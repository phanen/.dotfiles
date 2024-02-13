#!/usr/bin/env python
import xml.etree.ElementTree as ET
import os


def create_outline(url):
    outline = ET.Element("outline")
    outline.set("text", url)
    outline.set("type", "rss")
    outline.set("xmlUrl", url)
    return outline


def convert_to_opml(file_path, output_path):
    root = ET.Element("opml")
    root.set("version", "1.0")
    body = ET.SubElement(root, "body")

    with open(file_path, "r") as file:
        for line in file:
            url = line.strip()
            if url:
                outline = create_outline(url)
                body.append(outline)

    tree = ET.ElementTree(root)
    tree.write(output_path, encoding="utf-8", xml_declaration=True)


homedir = os.environ["HOME"]
input_file = homedir + "/.config/newsboat/urls"
output_file = homedir + "/priv/rss.opml"
convert_to_opml(input_file, output_file)
