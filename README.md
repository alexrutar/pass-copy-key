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
...
```
In fact, any valid [YAML](https://yaml.org/spec/1.2.2/) is allowed.
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
You also need the tool [yq](https://github.com/mikefarah/yq) installed and accessible on your `PATH`.

## Configuration
Specify the login keys with `PSK_LOGIN_KEYS`.
The keys are tried in order of specification.
For example, if you want to login with the `username` key, and fall back to the `email` key if `username` is not specified,
```
set -x PSK_LOGIN_KEYS username email
```
This value defaults to `username`.
