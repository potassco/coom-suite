---
title: "UI"
icon: "material/television-guide"
---

# UI

To run the COOM Suite UI, run the following steps:

1. Install the latest clinguin version with pip

```console
pip install clinguin
```

2. Run the clinguin command in the command line, replacing <instance-file\> with one of the ASP instance files from the examples folder, eg. `kids-bike.lp`

```console
clinguin client-server  --domain-files <instance-file> src/coomsuite/encodings/encoding-base-clingo.lp --ui-files src/coomsuite/encodings/ui.lp --backend ExplanationBackend --assumption-signature constraint,2
```

The UI is using the clingo encoding.

!!! warning
    Make sure all atoms are shown.
