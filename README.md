# lido – Linked data overlay

## Purpose

This project aims to bring resources on research information into a coherent data space. Instead of bulk transformations lido is doing this on the fly while resolving identifiers.

## How it works

Initially this repository contains a number of XSL templates to transform the API responses of a number of resources into schema.org based linked data.

## Run a transform

The templates are rely on XSLT 3.0 in order to construct well formed JSON output. You can run the CLI tool of saxonjs to run the transforms like this:

```shell
xslt3 -xsl:formats/didl-mods/template.xsl -s:resources/uu-cris/example.xml -o:output.xml -t && cat output.xml | jq > output.json
```