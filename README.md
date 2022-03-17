# dev-toolkit

Scripts and tools for starting and testing a chain


## Quick Start

1. copy `env.example.sh` to `env.sh` (or other file related to your chain name, eg: `env-regen.sh`)
2. Set correct variables in your `env.sh` file
3. Load the env file: `. env.sh`
3. Start the chain: `./setup-simple.sh`
   To run proposal examples you should use `./setup.sh` instead.
   
See and play with other scripts.

You can also run a chain with:

``` shell
# spin a network with 4 validators and print a key mnemonic of one of the validators
simd testnet start

# now let's recover the key, so we can use it in transactions
simd keys add validator --recover
```

## Requirements

- `jq`
- `shell` (zsh, bash, ...)
