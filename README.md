# JaCoCo-Tagger

I tag Moose entities based on a JaCoCo report.

## Usage

```st
JTTagger new "Create a tagger"
	famixModel: myModel; "specify the model to tag"
	import: 'JACOCO_TA_a08th02_16h05m58s_722\jacoco.xml' asFileReference. "give reference to the report to use for tagging"
```

Retrieve the tagged entities

```st
tag := myModel tags last.
tagged := (tag taggedEntitiesInModel: myModel).
```

## Installation

```st
Metacello new
    githubUser: 'Evref-BL' project: 'JaCoCo-Tagger' commitish: 'main' path: 'src';
    baseline: 'JaCoCoTagger';
    load
```
