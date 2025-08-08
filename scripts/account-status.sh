#!/usr/bin/env bash
rpc_endpoint=http://66.165.238.146:8080/v1
account_address=$1
is_founder=$(libra query --url ${rpc_endpoint} view --function-id 0x1::founder::is_founder --args ${account_address} | jq '.body[0]' )
v8_authorized=$(libra query --url ${rpc_endpoint} view --function-id 0x1::reauthorization::is_v8_authorized --args ${account_address} | jq '.body[0]' )
cached_score=$(libra query --url ${rpc_endpoint} view --function-id 0x1::page_rank_lazy::get_cached_score --args ${account_address} | jq '.body[0]' | tr -d '"')
vouch_limit=$(libra query --url ${rpc_endpoint} view --function-id 0x1::vouch_limits::get_vouch_limit --args ${account_address} | jq '.body[0]' | tr -d '"')
balance_response=$(libra query --url ${rpc_endpoint} balance ${account_address})
unlocked_balance=$(echo ${balance_response} | jq '.unlocked')
total_balance=$(echo ${balance_response} | jq '.total')
echo "Founder (user re-join done): ${is_founder}"
echo "Reauthorized (coins unlocking): ${v8_authorized}"
echo "Cached score (vouch score): ${cached_score}"
echo "Vouch limit (number of vouches to give): $vouch_limit"
echo "Balance: ${total_balance} (${unlocked_balance} unlocked)"
