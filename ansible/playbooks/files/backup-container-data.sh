#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR=$(mktemp -d)
trap 'rm -r "${BACKUP_DIR}"' EXIT

cleanup() {
  rm /tmp/${BACKUP_NAM}
  cp /containe
}

main() {
  pushd "${BACKUP_DIR}" >/dev/null
  mkdir "./data";
  cp -r "/containers" "./data"
  echo $(date -u +"%Y-%m-%dT%H-%M-%SZ") > "./data/backup.txt"
  tar -czf "container-data.tar.gz" "./data"
  scp "container-data.tar.gz" csesoc@cse.unsw.edu.au:~/backups/wheatley/
}


main "$@"
