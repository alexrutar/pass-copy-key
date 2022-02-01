# Pass Show Key
## Introduction
This script is a command line wrapper around the password manager [pass](https://www.passwordstore.org) to help copy values to the clipboard.
If you like [fisher](https://github.com/jorgebucaran/fisher), you can
```
fisher install alexrutar/psk
```
Otherwise, just copy the files [functions/psk.fish](functions/psk.fish) and [completions/psk.fish](completions/psk.fish) to their relevant directories.

Pass-copy-key assumes your pass files are in the following format:
```
<password>
<key>: <value>
...
```
Any value for `<key>` or `<value>` is allowed, and in the case of multiple occurrences of `: `, the separation happens at the latest one.
The main command is
```
psk login <passfile>
```
This copies the first valid `<value>` in `<passfile>` to your clipboard, and prompts you to continue.
Once you continue, it copies the password to your clipboard.
```
psk copy-key <passfile> <key>
```
copes the value corresponding to `<key>` in `<passfile>` to the clipboard.
```
psk list-keys <passfile>
```
lists all recognized keys.

## Dependencies
You should install [pass](https://www.passwordstore.org) and have it set up appropriately.
You also need the tool [fd](https://github.com/sharkdp/fd) installed and accessible on your `PATH`.
