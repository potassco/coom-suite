---
icon: "material/rocket-launch"
---

# Usage

## Solve a COOM model

To solve a COOM model file, run (replacing <coom-model\>)
```console
coomsuite solve <coom-model>
```

## Convert COOM to ASP

To convert a COOM model to the serialized ASP fact format, run
```console
coomsuite convert <coom-model>
```

To obtain the (COOM-independent) refined fact format, run
```console
coomsuite solve <coom-model> --show-facts
```

### Command-line interface

Additional options can be found with

```console
coomsuite -h
```
