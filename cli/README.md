# Prozzie CLI
## Code organization. Extending CLI
Mainly, the prozzie CLI is organized this way. All this files are under `cli/`
directory.

The main file is `prozzie.bash`. This file will be linked under `$PREFIX/bin`,
and is the CLI entry point. If you need to develop a command under it, you have
to create a file named `prozzie-<command>.bash`. Subcommand of the latter
command should be named `prozzie-<command>-<subcommand>.bash`, and be
dispatched by `prozzie-<command>.bash`, like, for example,
`prozzie-compose.bash` do, but it is not mandatory: you can dispatch
subcommands in the same parent command like `prozzie-kafka-topics.bash` do.

On consequence, some commands/files will only exist for subcommand dispatch,
like `prozzie-kafka.bash` or `prozzie-compose.bash`.

A prozzie command can be just a shortcut for subcommands, like the case of
`prozzie-up.bash`, that only call `prozzie-compose.bash` (or, at least, that is
the external effect), or group many commands under the same file, like
`prozzie-up`, `prozzie-stop`, `prozzie-start`, `prozzie-down` and
`prozzie-compose`, that acts different based on the name they are called with.

Because of bash difficulty to import/source files from different locations than
script file one, prozzie exports `PREFIX` one, with the patch of `cli`
installation.

## Config command
### Overview
Prozzie main component is the docker compose. Under that, prozzie needs to
difference between connectors based on docker containers and connectors based
in kafka connect.

To add a new one, you need to create your `cli/config/<module>.bash` file with
the module_envs associative array variable, that contains module keys->values,
and the next functions:

showVarsDescription
: Print all module variable descriptions.

zz_connector_get_variables
: Obtain module variables. First parameter is module name. If no other
parameter is passed, it will print all variables. If parameters passed, it
will print the parameter value. If the parameter does not exists, it will print
an error via stderr and return error code.

### Compose based
To be able to enable/disable docker based components, the compose is formed by
many `.yaml` files, and they are concatenated in prozzie config command: The
`${PREFIX}"/etc/prozzie/compose` path contains symbolic links to the
`share/cli` yaml files, and the compose commands will take that into account.
See [compose Readme.md](../compose/README.md) for more information about this
behavior.

To configure it, you need to add the proper entry in
`cli/config/<module>.bash`: Declare a `module_envs` associative array which
keys are the config compose keys, and values will be
`<default_value>|description`. If the variable ends with `_PATH`, the read
command will help the user with tab completion.

### Kafka-connect based
The config of kafka-connect based connectors uses the kafka-connect model
configuration. To manage that, you need to use kcli module.

Just add your module config values under `cli/config/<module>.bash`, and
modify `prozzie-config.bash:is_kafka_connect_connector()` to take your new
module into account.

You can use `hidden_module_envs` associative array to add "advanced" variables
to your module, or variables that user does not usually need to modify. For
example, module connector class or string processors class should be in this
array. The format is the same as `module_envs`.