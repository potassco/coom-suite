---
title: "User Input"
icon: "material/account"
---


# User Input

The *COOM Suite* offers the possibility for the user to provide
specific requirements for the current solving process
- so called **user input**- via the command-line by using the `--user-input` (`-u`) option.

The syntax allows for two directives:

- `set`: Sets the value for an attribute variable
- `add`: Adds a part to the solution

## Usage

```console
coomsuite solve examples/coom/bike/kids-bike.coom -u examples/coom/bike/user-input-kids.coom
```



## Example solution

The [`user-input-kids.coom`][user-input-file] file contains the `set color[0] = Yellow` directive
and therefore returns only solutions where the color of the bike is set to Yellow.
Due to the conditional requirement
`condition color = Yellow require frontWheel.size > 16`
of the [Kids Bike][kids] this also filters all solutions with small wheels
which in turn disable the wheel suppport.
As a consequence only two solutions remain.

[user-input-file]: https://github.com/potassco/coom-suite/tree/master/examples/coom/bike/user-input-kids.coom
[kids]: ../examples/kids-bike.md

```shell
Answer: 1
color[0] = "Yellow"
frontWheel[0] = "W20"
frontWheel[0].size[0] = 20
rearWheel[0] = "W20"
rearWheel[0].size[0] = 20
wheelSupport[0] = "False"

Answer: 2
color[0] = "Yellow"
frontWheel[0] = "W18"
frontWheel[0].size[0] = 18
rearWheel[0] = "W18"
rearWheel[0].size[0] = 18
wheelSupport[0] = "False"
```
