#!/bin/bash
#cd /temp/mp3merge
#file="/temp/mp3merge/auto-m4b-tool.sh"
#cp -u /auto-m4b-tool.sh /temp/mp3merge/auto-m4b-tool.sh

USER_NAME="autom4b"
PUID=${PUID:-1001}
PGID=${PGID:-1001}

function log() {
    echo "[entrypoint] $@"
}

if [[ "$(id -u)" == 0 ]]; then
    # Create user if they don't exist
    if ! id -u "${PUID}" &>/dev/null; then
        # # If PUID is a number, create a user with that id
        # if [[ "${PUID}" =~ ^[0-9]+$ ]]; then
        #     user_id="${PUID}"
        # # otherwise create a user with the name from PUID
        # else
        #     user_name="${PUID}"
        # fi
        # # If PGID is a number, create a user with that id
        # if [[ "${PGID}" =~ ^[0-9]+$ ]]; then
        #     group_id="${PGID}"
        # fi

        # Get pre-existing users and groups with desired ID's
        E_GROUP_NAME=$(cat /etc/group | grep :${PGID}: | cut -d: -f1)
        E_USER_NAME=$(cat /etc/passwd | grep :${PUID}: | cut -d: -f1)

        if [[ -z $E_GROUP_NAME ]]; then
            addgroup -g "${PGID}" -S "${USER_NAME}"
        fi

        if [[ -z $E_USER_NAME ]]; then
            adduser -DH -u "${PUID}" -G "${USER_NAME}" "${USER_NAME}"
        fi

        log "Created missing ${USER_NAME} user with UID ${PUID} and GID ${PGID}"
    fi

    chown -R ${PUID}:${PGID} /config
    chown -R ${PUID}:${PGID} /temp
fi

# cmd_prefix=""
# if [[ -n "${PUID:-}" ]]; then
#     cmd_prefix="/sbin/setuser ${user_name}"
# fi

# ${cmd_prefix} /auto-m4b-tool.sh 2> /config/auto-m4b-tool.log

# su -s /bin/bash -c /auto-m4b-tool.sh -pm - "${user_name}"
exec setpriv --pdeathsig=keep --reuid="$PUID" --regid="$PGID" --clear-groups -- "$@"
