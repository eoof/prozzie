#!/usr/bin/env bash

# This file is part of Prozzie - The Wizzie Data Platform (WDP) main entrypoint
# Copyright (C) 2018-2019 Wizzie S.L.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


. "${PREFIX}/share/prozzie/cli/include/config_compose.bash"

# This file handles the connectors based on docker compose that does not need
# any configuration variables, and defines the functions needed to use them.

##
## @brief      Tries to get variables from http2k, but it fails since module
##             does not have any. If you call it with no parameters other than
##             module name, it will print a message. If you try to specify a
##             variable, error message will be shown and an exit will be raised.
##
## @return     0 if no parameter passed, 1 in other case.
##

declare -r no_variables_error_msg='http2k module does not have any variables'
zz_connector_get_variables () {
	shift  # Module name
	printf '%s\n' "$no_variables_error_msg" >&2
	[[ $# -eq 0 ]]
}

##
## @brief      Print that http2k does not have any variables to set and return
## an error.
##
zz_connector_set_variables () {
	printf '%s\n' "$no_variables_error_msg" >&2
	return 1
}

# This variable is intended to be imported, so we don't use this variable here
# shellcheck disable=SC2034
declare -A module_envs=()

##
## @brief      Print message saying that there is nothing to configure for this
##             module
##
## @return     Always 0
##
zz_connector_show_vars_description () {
    printf '\tNo vars description\n'
}
