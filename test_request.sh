#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

cd "$(dirname "$0")"

base_url='localhost:8080'
auth_header='Authorization: Bearer sk-ab749f5866ca4e80a994a5fe445a593d'

accept_header='Accept: application/json'
ctype_header='Content-Type: application/json'

echo '==================== GET /api/models ===================='
curl "${base_url}/api/models" -H "${auth_header}" | jq


echo '==================== POST /api/chat/completions ===================='
curl -X POST "${base_url}/api/chat/completions" -H "${auth_header}" -H "${ctype_header}" --data '{
	"model": "tinyllama:latest",
	"messages": [
		{"role": "user", "content": "What would be a good name for a dog?"}
	]
}' | jq
