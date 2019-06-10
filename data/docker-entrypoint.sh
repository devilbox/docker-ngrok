#!/usr/bin/env bash

set -e
set -u
set -o pipefail

CONFIG_FILE="/home/ngrok/.ngrok2/ngrok.yml"


# -------------------------------------------------------------------------------------------------
# REQUIRED ENV VARIABLES
# -------------------------------------------------------------------------------------------------

if ! env | grep -q '^HTTP_TUNNELS='; then
	>&2 echo "[ERROR] HTTP_TUNNELS is not defined, but required to create a tunnel"
	exit 1
fi


# -------------------------------------------------------------------------------------------------
# SPECIFY REGION
# -------------------------------------------------------------------------------------------------

if ! env | grep -q '^REGION='; then
	REGION=
else
	REGION="$( env env | grep '^REGION=' | awk -F'=' '{print $2}' | xargs )"
	REGION="${REGION##*( )}" # Trim leading whitespaces
	REGION="${REGION%%*( )}" # Trim trailing whitespaces

	if [ -z "${REGION}" ]; then
		>&2 echo "[WARN]  REGION specified, but empty"
	else
		echo "[INFO]  Using region as specified in REGION: ${REGION}"
		echo "region: ${REGION}" >> "${CONFIG_FILE}"
	fi
fi


# -------------------------------------------------------------------------------------------------
# SPECIFY AUTH TOKEN
# -------------------------------------------------------------------------------------------------

if ! env | grep -q '^AUTHTOKEN='; then
	>&2 echo "[WARN]  No AUTHTOKEN specified, limited functionality only"
else
	AUTHTOKEN="$( env env | grep '^AUTHTOKEN=' | awk -F'=' '{print $2}' | xargs )"
	AUTHTOKEN="${AUTHTOKEN##*( )}" # Trim leading whitespaces
	AUTHTOKEN="${AUTHTOKEN%%*( )}" # Trim trailing whitespaces

	if [ -z "${AUTHTOKEN}" ]; then
		>&2 echo "[WARN]  AUTHTOKEN specified, but empty, limited functionality only"
	else
		echo "[INFO]  Using authtoken as specified in AUTHTOKEN"
		echo "authtoken: ${AUTHTOKEN}" >> "${CONFIG_FILE}"
	fi
fi


# -------------------------------------------------------------------------------------------------
# SPECIFY HTTP TUNNELS
# -------------------------------------------------------------------------------------------------

HTTP_TUNNELS="$( env | grep '^HTTP_TUNNELS=' | awk -F'=' '{print $2}' )"
HTTP_TUNNELS="$( echo "${HTTP_TUNNELS}" | xargs )" # Trim lwhitespaces
HTTP_TUNNELS="${HTTP_TUNNELS##*( )}" # Trim leading whitespaces
HTTP_TUNNELS="${HTTP_TUNNELS%%*( )}" # Trim trailing whitespaces

if [ -z "${HTTP_TUNNELS}" ]; then
	>&2 echo "[ERROR] HTTP_TUNNELS is empty."
	>&2 echo "[ERROR] Expected: '<domain>:<backend_addr>:<backend_port>[,<domain>:<backend_addr>:<backend_port>]'";
	exit 1
fi

i=0
IFS=','
echo "tunnels:" >> "${CONFIG_FILE}"
for tunnel in ${HTTP_TUNNELS}; do
	i=$((i+1))
	# Ensure each tunnel line has the correct format: <string>:<string>:<string>
	if [ "$( echo "${tunnel}" | sed 's/:/:\n/g' | grep -c ':' )" -ne "2" ]; then
		>&2 echo "[ERROR] Wrong format in tunnel line: '${tunnel}'"
		>&2 echo "[ERROR] Should be: <domain>:<backend_addr>:<backend_port>"
		exit 1
	fi
	domain_name="$(  echo "${tunnel}" | awk -F':' '{print $1}' )"
	backend_addr="$( echo "${tunnel}" | awk -F':' '{print $2}' )"
	backend_port="$( echo "${tunnel}" | awk -F':' '{print $3}' )"

	# Append to ngrok config
	{
		echo "  tunnel_${i}:"
		echo "    addr: ${backend_addr}:${backend_port}"
		echo "    host_header: \"${domain_name}\""
		echo "    proto: http"

	} >> "${CONFIG_FILE}"

done

cat ${CONFIG_FILE}

# -------------------------------------------------------------------------------------------------
# START NGROK
# -------------------------------------------------------------------------------------------------

exec ngrok start --all
