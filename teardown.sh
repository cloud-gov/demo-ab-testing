#!/usr/bin/env bash
set -euo pipefail

remove_policies() {
	cf network-policies | awk 'f;/source/{f=1}' | 
		awk '{printf "cf remove-network-policy %s %s --protocol %s --port %s\n", $1, $2, $3, $4}' 
}

