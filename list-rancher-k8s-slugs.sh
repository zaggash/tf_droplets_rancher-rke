#!/usr/bin/env bash
set -e

main() {
  #Select product
  PS3='Which product k8s version do you need: '
  options=("Rancher" "RKE" "RKE2" "k3s" "Quit")
  select product in "${options[@]}"
  do
      case $product in
          "Rancher")
            rancherSlugs
            break
            ;;
          "RKE")
            rkeSlugs
            break
            ;;
          "RKE2")
            rke2Slugs
            break
            ;;
          "k3s")
            k3sSlugs
            break
            ;;
          "Exit")
            break
            ;;
          *)
            break
            ;;
      esac
  done
}


function rancherSlugs {
  gh_url="https://api.github.com/repos/rancher/rancher/git/refs/tags"
  curl -sL ${gh_url} |\
    jq -r '.[].ref' | awk 'BEGIN{RS="[/\n]"}/^v[.[:digit:]]+$/' | sort -uV | tr -d 'v'
}

function rkeSlugs {
  branch="$(curl -sL 'https://api.github.com/repos/rancher/kontainer-driver-metadata/branches?per_page=100' | jq -r '.[].name' | grep -E '^release-v')"
  
  PS3="Choose a Rancher branch to search in: "
  COLUMNS=20
  select v in ${branch} Exit; do
  	case $v in
  		Exit)
  			echo "Exiting, did nothing."
  			break
  			;;
  		*)
  		  url="https://raw.githubusercontent.com/rancher/kontainer-driver-metadata/$v/data/data.json"
  		  curl -sL "$url" | jq -r '.K8sVersionRKESystemImages | keys[]' | sort -u -V
  		  break
        ;;
    esac
  done
}

function rke2Slugs {
  gh_url="https://api.github.com/repos/rancher/rke2/git/refs/tags"
  curl -sL ${gh_url} |\
    jq -r '.[] | select(.ref | contains ("rke2")) | .ref' | cut -d '/' -f 3 | grep -v 'rc' | sort -uV
}

function k3sSlugs {
  gh_url="https://api.github.com/repos/k3s-io/k3s/git/refs/tags"
  curl -sL ${gh_url} |\
    jq -r '.[] | select(.ref | contains ("k3s")) | .ref' | cut -d '/' -f 3 | grep -v 'rc' | sort -uV
}

main "$@"; exit
