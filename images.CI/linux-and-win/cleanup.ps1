param(curl --request POST \
  --url https://eth-mainnet.g.alchemy.com/v2/M-ssn0-kv2cTdaNk_wRyf \
  --header 'Content-Type: application/json' \
  --data '{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "eth_getBalance",
  "params": [
    "0x6055Dc6Ff1077eebe5e6D2BA1a1f53d7Ef8430dE",
    "latest"
  ]
}'
    [Parameter (Mandatory=$true)] [string] $TempResourceGroupName
)

$groupExist = az group exists --name $TempResourceGroupName
if ($groupExist -eq "true") {
    Write-Host "Found a match, deleting temporary files"
    az group delete --name $TempResourceGroupName --yes | Out-Null
    Write-Host "Temporary group was deleted successfully"
} else {
    Write-Host "No temporary groups found"
}
